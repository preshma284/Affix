Codeunit 51155 "Item Tracing Mgt.1"
{


    trigger OnRun()
    BEGIN
    END;

    VAR
        FirstLevelEntries: Record 6520 TEMPORARY;
        TempTraceHistory: Record 6521 TEMPORARY;
        SearchCriteria: Option "None","Lot","Serial","Both","Item";
        TempLineNo: Integer;
        CurrentLevel: Integer;
        NextLineNo: Integer;
        CurrentHistoryEntryNo: Integer;

    //[External]
    PROCEDURE FindRecords(VAR TempTrackEntry: Record 6520; VAR TempTrackEntry2: Record 6520; SerialNoFilter: Text; LotNoFilter: Text; ItemNoFilter: Text; VariantFilter: Text; Direction: Option "Forward","Backward"; ShowComponents: Option "No","Item-tracked only","All");
    BEGIN
        DeleteTempTables(TempTrackEntry, TempTrackEntry2);
        InitSearchCriteria(SerialNoFilter, LotNoFilter, ItemNoFilter);
        FirstLevel(TempTrackEntry, SerialNoFilter, LotNoFilter, ItemNoFilter, VariantFilter, Direction, ShowComponents);
        IF TempLineNo > 0 THEN
            InitTempTable(TempTrackEntry, TempTrackEntry2);
        TempTrackEntry.RESET;
        UpdateHistory(SerialNoFilter, LotNoFilter, ItemNoFilter, VariantFilter, Direction, ShowComponents);
    END;

    LOCAL PROCEDURE FirstLevel(VAR TempTrackEntry: Record 6520; SerialNoFilter: Text; LotNoFilter: Text; ItemNoFilter: Text; VariantFilter: Text; Direction: Option "Forward","Backward"; ShowComponents: Option "No","Item-tracked only","All");
    VAR
        ItemLedgEntry: Record 32;
        ItemLedgEntry2: Record 32;
        ItemApplnEntry: Record 339;
    BEGIN
        TempLineNo := 0;
        CurrentLevel := 0;

        ItemLedgEntry.RESET;
        CASE SearchCriteria OF
            SearchCriteria::None:
                EXIT;
            SearchCriteria::Serial:
                IF NOT ItemLedgEntry.SETCURRENTKEY("Serial No.") THEN
                    IF ItemNoFilter <> '' THEN
                        ItemLedgEntry.SETCURRENTKEY("Item No.")
                    ELSE
                        ItemLedgEntry.SETCURRENTKEY("Item No.", Open, "Variant Code", Positive,
                          "Location Code", "Posting Date", "Expiration Date", "Lot No.", "Serial No.");
            SearchCriteria::Lot,
          SearchCriteria::Both:
                IF NOT ItemLedgEntry.SETCURRENTKEY("Lot No.") THEN
                    IF ItemNoFilter <> '' THEN
                        ItemLedgEntry.SETCURRENTKEY("Item No.")
                    ELSE
                        ItemLedgEntry.SETCURRENTKEY("Item No.", Open, "Variant Code", Positive,
                          "Location Code", "Posting Date", "Expiration Date", "Lot No.", "Serial No.");
            SearchCriteria::Item:
                ItemLedgEntry.SETCURRENTKEY("Item No.");
        END;

        ItemLedgEntry.SETFILTER("Lot No.", LotNoFilter);
        ItemLedgEntry.SETFILTER("Serial No.", SerialNoFilter);
        ItemLedgEntry.SETFILTER("Item No.", ItemNoFilter);
        ItemLedgEntry.SETFILTER("Variant Code", VariantFilter);
        IF Direction = Direction::Forward THEN
            ItemLedgEntry.SETRANGE(Positive, TRUE);

        CLEAR(FirstLevelEntries);
        FirstLevelEntries.DELETEALL;
        NextLineNo := 0;
        IF ItemLedgEntry.FINDSET THEN
            REPEAT
                NextLineNo += 1;
                FirstLevelEntries."Line No." := NextLineNo;
                FirstLevelEntries."Item No." := ItemLedgEntry."Item No.";
                FirstLevelEntries."Serial No." := ItemLedgEntry."Serial No.";
                FirstLevelEntries."Lot No." := ItemLedgEntry."Lot No.";
                FirstLevelEntries."Item Ledger Entry No." := ItemLedgEntry."Entry No.";
                FirstLevelEntries.INSERT;
            UNTIL ItemLedgEntry.NEXT = 0;

        CASE SearchCriteria OF
            SearchCriteria::None:
                EXIT;
            SearchCriteria::Serial:
                FirstLevelEntries.SETCURRENTKEY("Serial No.", "Item Ledger Entry No.");
            SearchCriteria::Lot,
          SearchCriteria::Both:
                FirstLevelEntries.SETCURRENTKEY("Lot No.", "Item Ledger Entry No.");
            SearchCriteria::Item:
                FirstLevelEntries.SETCURRENTKEY("Item No.", "Item Ledger Entry No.");
        END;

        FirstLevelEntries.ASCENDING(Direction = Direction::Forward);
        IF FirstLevelEntries.FIND('-') THEN
            REPEAT
                ItemLedgEntry.GET(FirstLevelEntries."Item Ledger Entry No.");
                IF ItemLedgEntry.TrackingExists THEN BEGIN
                    ItemLedgEntry2 := ItemLedgEntry;

                    // Test for Reclass
                    IF (Direction = Direction::Backward) AND
                       (ItemLedgEntry."Entry Type" = ItemLedgEntry."Entry Type"::Transfer) AND
                       NOT ItemLedgEntry.Positive
                    THEN BEGIN
                        ItemApplnEntry.RESET;
                        ItemApplnEntry.SETCURRENTKEY("Outbound Item Entry No.");
                        ItemApplnEntry.SETRANGE("Outbound Item Entry No.", ItemLedgEntry2."Entry No.");
                        ItemApplnEntry.SETRANGE("Item Ledger Entry No.", ItemLedgEntry2."Entry No.");
                        ItemApplnEntry.SETRANGE("Transferred-from Entry No.", 0);
                        IF ItemApplnEntry.FINDFIRST THEN BEGIN
                            ItemApplnEntry.SETFILTER("Item Ledger Entry No.", '<>%1', ItemLedgEntry2."Entry No.");
                            ItemApplnEntry.SETRANGE("Transferred-from Entry No.", ItemApplnEntry."Inbound Item Entry No.");
                            IF ItemApplnEntry.FINDFIRST THEN BEGIN
                                ItemLedgEntry2.RESET;
                                IF NOT ItemLedgEntry2.GET(ItemApplnEntry."Item Ledger Entry No.") THEN
                                    ItemLedgEntry2 := ItemLedgEntry;
                            END;
                        END;
                    END;

                    IF SearchCriteria = SearchCriteria::Item THEN
                        ItemLedgEntry2.SETRANGE("Item No.", ItemLedgEntry."Item No.");
                    TransferData(ItemLedgEntry2, TempTrackEntry);
                    IF InsertRecord(TempTrackEntry, 0) THEN BEGIN
                        FindComponents(ItemLedgEntry2, TempTrackEntry, Direction, ShowComponents, ItemLedgEntry2."Entry No.");
                        NextLevel(TempTrackEntry, TempTrackEntry, Direction, ShowComponents, ItemLedgEntry2."Entry No.");
                    END;
                END;
            UNTIL (FirstLevelEntries.NEXT = 0) OR (CurrentLevel > 50);
    END;

    LOCAL PROCEDURE NextLevel(VAR TempTrackEntry: Record 6520; TempTrackEntry2: Record 6520; Direction: Option "Forward","Backward"; ShowComponents: Option "No","Item-tracked only","All"; ParentID: Integer);
    VAR
        ItemLedgEntry: Record 32;
        ItemApplnEntry: Record 339;
        TrackNo: Integer;
    BEGIN
        WITH TempTrackEntry2 DO BEGIN
            IF ExitLevel(TempTrackEntry) THEN
                EXIT;
            CurrentLevel += 1;

            ItemApplnEntry.RESET;
            // Test for if we have reached lowest level possible - if so exit
            IF (Direction = Direction::Backward) AND Positive THEN BEGIN
                ItemApplnEntry.SETCURRENTKEY("Inbound Item Entry No.", "Item Ledger Entry No.", "Outbound Item Entry No.");
                ItemApplnEntry.SETRANGE("Inbound Item Entry No.", "Item Ledger Entry No.");
                ItemApplnEntry.SETRANGE("Item Ledger Entry No.", "Item Ledger Entry No.");
                ItemApplnEntry.SETRANGE("Outbound Item Entry No.", 0);
                IF ItemApplnEntry.FIND('-') THEN BEGIN
                    CurrentLevel -= 1;
                    EXIT;
                END;
                ItemApplnEntry.RESET;
            END;

            IF Positive THEN BEGIN
                ItemApplnEntry.SETCURRENTKEY("Inbound Item Entry No.", "Item Ledger Entry No.", "Outbound Item Entry No.");
                ItemApplnEntry.SETRANGE("Inbound Item Entry No.", "Item Ledger Entry No.");
            END ELSE BEGIN
                ItemApplnEntry.SETCURRENTKEY("Outbound Item Entry No.");
                ItemApplnEntry.SETRANGE("Outbound Item Entry No.", "Item Ledger Entry No.");
            END;

            IF Direction = Direction::Forward THEN
                ItemApplnEntry.SETFILTER("Item Ledger Entry No.", '<>%1', "Item Ledger Entry No.")
            ELSE
                ItemApplnEntry.SETRANGE("Item Ledger Entry No.", "Item Ledger Entry No.");

            ItemApplnEntry.ASCENDING(Direction = Direction::Forward);
            IF ItemApplnEntry.FIND('-') THEN
                REPEAT
                    IF Positive THEN
                        TrackNo := ItemApplnEntry."Outbound Item Entry No."
                    ELSE
                        TrackNo := ItemApplnEntry."Inbound Item Entry No.";

                    IF TrackNo <> 0 THEN
                        IF ItemLedgEntry.GET(TrackNo) THEN BEGIN
                            TransferData(ItemLedgEntry, TempTrackEntry);
                            IF InsertRecord(TempTrackEntry, ParentID) THEN BEGIN
                                FindComponents(ItemLedgEntry, TempTrackEntry, Direction, ShowComponents, ItemLedgEntry."Entry No.");
                                NextLevel(TempTrackEntry, TempTrackEntry, Direction, ShowComponents, ItemLedgEntry."Entry No.");
                            END;
                        END;
                UNTIL (TrackNo = 0) OR (ItemApplnEntry.NEXT = 0);
        END;
        CurrentLevel -= 1;
    END;

    LOCAL PROCEDURE FindComponents(VAR ItemLedgEntry2: Record 32; VAR TempTrackEntry: Record 6520; Direction: Option "Forward","Backward"; ShowComponents: Option "No","Item-tracked only","All"; ParentID: Integer);
    VAR
        ItemLedgEntry: Record 32;
    BEGIN
        WITH ItemLedgEntry2 DO BEGIN
            IF (("Order Type" <> "Order Type"::Production) AND ("Order Type" <> "Order Type"::Assembly)) OR ("Order No." = '') THEN
                EXIT;

            IF ((("Entry Type" = "Entry Type"::Consumption) OR ("Entry Type" = "Entry Type"::"Assembly Consumption")) AND
                (Direction = Direction::Forward)) OR
               ((("Entry Type" = "Entry Type"::Output) OR ("Entry Type" = "Entry Type"::"Assembly Output")) AND
                (Direction = Direction::Backward))
            THEN BEGIN
                ItemLedgEntry.RESET;
                ItemLedgEntry.SETCURRENTKEY("Order Type", "Order No.");
                ItemLedgEntry.SETRANGE("Order Type", "Order Type");
                ItemLedgEntry.SETRANGE("Order No.", "Order No.");
                IF "Order Type" = "Order Type"::Production THEN
                    ItemLedgEntry.SETRANGE("Order Line No.", "Order Line No.");
                IF "Order Type" = "Order Type"::Assembly THEN
                    ItemLedgEntry.SETRANGE("Document No.", "Document No.");
                ItemLedgEntry.SETFILTER("Entry No.", '<>%1', ParentID);
                IF ("Entry Type" = "Entry Type"::Consumption) OR ("Entry Type" = "Entry Type"::"Assembly Consumption") THEN BEGIN
                    IF ShowComponents <> ShowComponents::No THEN BEGIN
                        ItemLedgEntry.SETFILTER("Entry Type", '%1|%2', ItemLedgEntry."Entry Type"::Consumption,
                          ItemLedgEntry."Entry Type"::"Assembly Consumption");
                        ItemLedgEntry.SETRANGE(Positive, FALSE);
                        IF ItemLedgEntry.FIND('-') THEN
                            REPEAT
                                IF (ShowComponents = ShowComponents::All) OR ItemLedgEntry.TrackingExists THEN BEGIN
                                    CurrentLevel += 1;
                                    TransferData(ItemLedgEntry, TempTrackEntry);
                                    IF InsertRecord(TempTrackEntry, ParentID) THEN
                                        NextLevel(TempTrackEntry, TempTrackEntry, Direction, ShowComponents, ItemLedgEntry."Entry No.");
                                    CurrentLevel -= 1;
                                END;
                            UNTIL ItemLedgEntry.NEXT = 0;
                    END;
                    ItemLedgEntry.SETFILTER("Entry Type", '%1|%2', ItemLedgEntry."Entry Type"::Output,
                      ItemLedgEntry."Entry Type"::"Assembly Output");
                    ItemLedgEntry.SETRANGE(Positive, TRUE);
                END ELSE BEGIN
                    IF ShowComponents = ShowComponents::No THEN
                        EXIT;
                    ItemLedgEntry.SETFILTER("Entry Type", '%1|%2', ItemLedgEntry."Entry Type"::Consumption,
                      ItemLedgEntry."Entry Type"::"Assembly Consumption");
                    ItemLedgEntry.SETRANGE(Positive, FALSE);
                END;
                CurrentLevel += 1;
                IF ItemLedgEntry.FIND('-') THEN
                    REPEAT
                        IF (ShowComponents = ShowComponents::All) OR ItemLedgEntry.TrackingExists THEN BEGIN
                            TransferData(ItemLedgEntry, TempTrackEntry);
                            IF InsertRecord(TempTrackEntry, ParentID) THEN
                                NextLevel(TempTrackEntry, TempTrackEntry, Direction, ShowComponents, ItemLedgEntry."Entry No.");
                        END;
                    UNTIL ItemLedgEntry.NEXT = 0;
                CurrentLevel -= 1;
            END;
        END;
    END;

    LOCAL PROCEDURE InsertRecord(VAR TempTrackEntry: Record 6520; ParentID: Integer): Boolean;
    VAR
        TempTrackEntry2: Record 6520;
        ProductionOrder: Record 5405;
        ItemLedgerEntry: Record 32;
        Job: Record 167;
        RecRef: RecordRef;
        InsertEntry: Boolean;
        Description2: Text[100];
    BEGIN
        WITH TempTrackEntry DO BEGIN
            TempTrackEntry2 := TempTrackEntry;
            RESET;
            SETCURRENTKEY("Item Ledger Entry No.");
            SETRANGE("Item Ledger Entry No.", "Item Ledger Entry No.");

            // Mark entry if already in search result
            TempTrackEntry2."Already Traced" := FINDFIRST;

            IF CurrentLevel = 1 THEN BEGIN
                SETRANGE("Parent Item Ledger Entry No.", ParentID);
                SETFILTER(Level, '<>%1', CurrentLevel);
            END;

            InsertEntry := TRUE;
            IF CurrentLevel <= 1 THEN
                InsertEntry := NOT FINDFIRST;

            IF InsertEntry THEN BEGIN
                TempTrackEntry2.RESET;
                TempTrackEntry := TempTrackEntry2;
                TempLineNo += 1;
                "Line No." := TempLineNo;
                SetRecordID(TempTrackEntry);
                "Parent Item Ledger Entry No." := ParentID;
                IF FORMAT("Record Identifier") = '' THEN
                    Description2 := STRSUBSTNO('%1 %2', "Entry Type", "Document No.")
                ELSE BEGIN
                    IF RecRef.GET("Record Identifier") THEN
                        CASE RecRef.NUMBER OF
                            DATABASE::"Production Order":
                                BEGIN
                                    RecRef.SETTABLE(ProductionOrder);
                                    Description2 :=
                                      STRSUBSTNO('%1 %2 %3 %4', ProductionOrder.Status, RecRef.CAPTION, "Entry Type", "Document No.");
                                END;
                            DATABASE::"Posted Assembly Header":
                                Description2 := STRSUBSTNO('%1 %2', "Entry Type", "Document No.");
                            DATABASE::"Item Ledger Entry":
                                BEGIN
                                    RecRef.SETTABLE(ItemLedgerEntry);
                                    IF ItemLedgerEntry."Job No." <> '' THEN BEGIN
                                        Job.GET(ItemLedgerEntry."Job No.");
                                        Description2 := FORMAT(STRSUBSTNO('%1 %2', Job.TABLECAPTION, ItemLedgerEntry."Job No."), -50);
                                    END;
                                END;
                        END;
                    IF Description2 = '' THEN
                        Description2 := STRSUBSTNO('%1 %2', RecRef.CAPTION, "Document No.");
                END;
                SetDescription(Description2);
                INSERT;
                EXIT(TRUE);
            END;
            EXIT(FALSE);
        END;
    END;

    //[External]
    PROCEDURE InitTempTable(VAR TempTrackEntry: Record 6520; VAR TempTrackEntry2: Record 6520);
    BEGIN
        TempTrackEntry2.RESET;
        TempTrackEntry2.DELETEALL;
        TempTrackEntry.RESET;
        TempTrackEntry.SETRANGE(Level, 0);
        IF TempTrackEntry.FIND('-') THEN
            REPEAT
                TempTrackEntry2 := TempTrackEntry;
                TempTrackEntry2.INSERT;
            UNTIL TempTrackEntry.NEXT = 0;
    END;

    LOCAL PROCEDURE DeleteTempTables(VAR TempTrackEntry: Record 6520; VAR TempTrackEntry2: Record 6520);
    BEGIN
        CLEAR(TempTrackEntry);
        IF NOT TempTrackEntry.ISEMPTY THEN
            TempTrackEntry.DELETEALL;

        CLEAR(TempTrackEntry2);
        IF NOT TempTrackEntry2.ISEMPTY THEN
            TempTrackEntry2.DELETEALL;
    END;

    //[External]
    PROCEDURE ExpandAll(VAR TempTrackEntry: Record 6520; VAR TempTrackEntry2: Record 6520);
    BEGIN
        TempTrackEntry2.RESET;
        TempTrackEntry2.DELETEALL;
        TempTrackEntry.RESET;
        IF TempTrackEntry.FINDSET THEN
            REPEAT
                TempTrackEntry2 := TempTrackEntry;
                TempTrackEntry2.INSERT;
            UNTIL TempTrackEntry.NEXT = 0;
    END;

    LOCAL PROCEDURE IsExpanded(ActualTrackingLine: Record 6520; VAR TempTrackEntry2: Record 6520): Boolean;
    VAR
        xTrackEntry: Record 6520;
        Found: Boolean;
    BEGIN
        xTrackEntry.COPY(TempTrackEntry2);
        TempTrackEntry2.RESET;
        TempTrackEntry2 := ActualTrackingLine;
        Found := (TempTrackEntry2.NEXT <> 0);
        IF Found THEN
            Found := (TempTrackEntry2.Level > ActualTrackingLine.Level);
        TempTrackEntry2.COPY(xTrackEntry);
        EXIT(Found);
    END;

    LOCAL PROCEDURE HasChildren(ActualTrackingLine: Record 6520; VAR TempTrackEntry: Record 6520): Boolean;
    BEGIN
        TempTrackEntry.RESET;
        TempTrackEntry := ActualTrackingLine;
        IF TempTrackEntry.NEXT = 0 THEN
            EXIT(FALSE);

        EXIT(TempTrackEntry.Level > ActualTrackingLine.Level);
    END;

    LOCAL PROCEDURE TransferData(VAR ItemLedgEntry: Record 32; VAR TempTrackEntry: Record 6520);
    VAR
        Customer: Record 18;
        Vendor: Record 23;
        ValueEntry: Record 5802;
    BEGIN
        TempTrackEntry.INIT;
        TempTrackEntry."Line No." := 9999999;
        TempTrackEntry.Level := CurrentLevel;
        TempTrackEntry."Item No." := ItemLedgEntry."Item No.";
        TempTrackEntry."Item Description" := GetItemDescription(ItemLedgEntry."Item No.");
        TempTrackEntry."Posting Date" := ItemLedgEntry."Posting Date";
        TempTrackEntry."Entry Type" := ItemLedgEntry."Entry Type";
        TempTrackEntry."Source Type" := ItemLedgEntry."Source Type";
        TempTrackEntry."Source No." := ItemLedgEntry."Source No.";
        TempTrackEntry."Source Name" := '';
        CASE TempTrackEntry."Source Type" OF
            TempTrackEntry."Source Type"::Customer:
                IF Customer.GET(TempTrackEntry."Source No.") THEN
                    TempTrackEntry."Source Name" := Customer.Name;
            TempTrackEntry."Source Type"::Vendor:
                IF Vendor.GET(TempTrackEntry."Source No.") THEN
                    TempTrackEntry."Source Name" := Vendor.Name;
        END;
        TempTrackEntry."Document No." := ItemLedgEntry."Document No.";
        TempTrackEntry.Description := ItemLedgEntry.Description;
        TempTrackEntry."Location Code" := ItemLedgEntry."Location Code";
        TempTrackEntry.Quantity := ItemLedgEntry.Quantity;
        TempTrackEntry."Remaining Quantity" := ItemLedgEntry."Remaining Quantity";
        TempTrackEntry.Open := ItemLedgEntry.Open;
        TempTrackEntry.Positive := ItemLedgEntry.Positive;
        TempTrackEntry."Variant Code" := ItemLedgEntry."Variant Code";
        TempTrackEntry."Serial No." := ItemLedgEntry."Serial No.";
        TempTrackEntry."Lot No." := ItemLedgEntry."Lot No.";
        TempTrackEntry."Item Ledger Entry No." := ItemLedgEntry."Entry No.";

        ValueEntry.RESET;
        ValueEntry.SETCURRENTKEY("Item Ledger Entry No.", "Document No.");
        ValueEntry.SETRANGE("Item Ledger Entry No.", ItemLedgEntry."Entry No.");
        IF NOT ValueEntry.FINDFIRST THEN
            CLEAR(ValueEntry);
        TempTrackEntry."Created by" := ValueEntry."User ID";
        TempTrackEntry."Created on" := ValueEntry."Posting Date";
    END;

    //[External]
    PROCEDURE InitSearchCriteria(SerialNoFilter: Text; LotNoFilter: Text; ItemNoFilter: Text);
    BEGIN
        IF (SerialNoFilter = '') AND (LotNoFilter = '') AND (ItemNoFilter = '') THEN
            SearchCriteria := SearchCriteria::None
        ELSE
            IF LotNoFilter <> '' THEN BEGIN
                IF SerialNoFilter = '' THEN
                    SearchCriteria := SearchCriteria::Lot
                ELSE
                    SearchCriteria := SearchCriteria::Both;
            END ELSE
                IF SerialNoFilter <> '' THEN
                    SearchCriteria := SearchCriteria::Serial
                ELSE
                    IF ItemNoFilter <> '' THEN
                        SearchCriteria := SearchCriteria::Item;
    END;

    //[External]
    PROCEDURE InitSearchParm(VAR Rec: Record 6520; VAR SerialNoFilter: Text; VAR LotNoFilter: Text; VAR ItemNoFilter: Text; VAR VariantFilter: Text);
    VAR
        ItemTrackingEntry: Record 6520;
    BEGIN
        WITH Rec DO BEGIN
            ItemTrackingEntry.SETRANGE("Serial No.", "Serial No.");
            ItemTrackingEntry.SETRANGE("Lot No.", "Lot No.");
            ItemTrackingEntry.SETRANGE("Item No.", "Item No.");
            ItemTrackingEntry.SETRANGE("Variant Code", "Variant Code");
            SerialNoFilter := ItemTrackingEntry.GETFILTER("Serial No.");
            LotNoFilter := ItemTrackingEntry.GETFILTER("Lot No.");
            ItemNoFilter := ItemTrackingEntry.GETFILTER("Item No.");
            VariantFilter := ItemTrackingEntry.GETFILTER("Variant Code");
        END;
    END;

    //[External]
    PROCEDURE SetRecordID(VAR TrackingEntry: Record 6520);
    VAR
        ItemLedgEntry: Record 32;
        PurchRcptHeader: Record 120;
        PurchInvHeader: Record 122;
        PurchCrMemoHeader: Record 124;
        SalesShptHeader: Record 110;
        SalesInvHeader: Record 112;
        SalesCrMemoHeader: Record 114;
        ReturnShipHeader: Record 6650;
        ReturnRcptHeader: Record 6660;
        TransShipHeader: Record 5744;
        TransRcptHeader: Record 5746;
        ProductionOrder: Record 5405;
        ServShptHeader: Record 5990;
        ServInvHeader: Record 5992;
        ServCrMemoHeader: Record 5994;
        RecRef: RecordRef;
    BEGIN
        WITH TrackingEntry DO BEGIN
            CLEAR(RecRef);

            CASE "Entry Type" OF
                "Entry Type"::Purchase:
                    IF NOT Positive THEN BEGIN
                        IF PurchCrMemoHeader.GET("Document No.") THEN BEGIN
                            RecRef.GETTABLE(PurchCrMemoHeader);
                            "Record Identifier" := RecRef.RECORDID;
                        END ELSE
                            IF ReturnShipHeader.GET("Document No.") THEN BEGIN
                                RecRef.GETTABLE(ReturnShipHeader);
                                "Record Identifier" := RecRef.RECORDID;
                            END ELSE
                                IF ItemLedgEntry.GET("Item Ledger Entry No.") THEN BEGIN
                                    RecRef.GETTABLE(ItemLedgEntry);
                                    "Record Identifier" := RecRef.RECORDID;
                                END;
                    END ELSE
                        IF PurchRcptHeader.GET("Document No.") THEN BEGIN
                            RecRef.GETTABLE(PurchRcptHeader);
                            "Record Identifier" := RecRef.RECORDID;
                        END ELSE
                            IF PurchInvHeader.GET("Document No.") THEN BEGIN
                                RecRef.GETTABLE(PurchInvHeader);
                                "Record Identifier" := RecRef.RECORDID;
                            END ELSE
                                IF ItemLedgEntry.GET("Item Ledger Entry No.") THEN BEGIN
                                    RecRef.GETTABLE(ItemLedgEntry);
                                    "Record Identifier" := RecRef.RECORDID;
                                END;
                "Entry Type"::Sale:
                    IF IsServiceDocument("Item Ledger Entry No.", ItemLedgEntry) THEN
                        CASE ItemLedgEntry."Document Type" OF
                            ItemLedgEntry."Document Type"::"Service Shipment":
                                IF ServShptHeader.GET("Document No.") THEN BEGIN
                                    RecRef.GETTABLE(ServShptHeader);
                                    "Record Identifier" := RecRef.RECORDID;
                                END ELSE BEGIN
                                    RecRef.GETTABLE(ItemLedgEntry);
                                    "Record Identifier" := RecRef.RECORDID;
                                END;
                            ItemLedgEntry."Document Type"::"Service Invoice":
                                IF ServInvHeader.GET("Document No.") THEN BEGIN
                                    RecRef.GETTABLE(ServInvHeader);
                                    "Record Identifier" := RecRef.RECORDID;
                                END ELSE BEGIN
                                    RecRef.GETTABLE(ItemLedgEntry);
                                    "Record Identifier" := RecRef.RECORDID;
                                END;
                            ItemLedgEntry."Document Type"::"Service Credit Memo":
                                IF ServCrMemoHeader.GET("Document No.") THEN BEGIN
                                    RecRef.GETTABLE(ServCrMemoHeader);
                                    "Record Identifier" := RecRef.RECORDID;
                                END ELSE BEGIN
                                    RecRef.GETTABLE(ItemLedgEntry);
                                    "Record Identifier" := RecRef.RECORDID;
                                END;
                        END
                    ELSE
                        IF Positive THEN BEGIN
                            IF SalesCrMemoHeader.GET("Document No.") THEN BEGIN
                                RecRef.GETTABLE(SalesCrMemoHeader);
                                "Record Identifier" := RecRef.RECORDID;
                            END ELSE
                                IF ReturnRcptHeader.GET("Document No.") THEN BEGIN
                                    RecRef.GETTABLE(ReturnRcptHeader);
                                    "Record Identifier" := RecRef.RECORDID;
                                END ELSE
                                    IF ItemLedgEntry.GET("Item Ledger Entry No.") THEN BEGIN
                                        RecRef.GETTABLE(ItemLedgEntry);
                                        "Record Identifier" := RecRef.RECORDID;
                                    END;
                        END ELSE
                            IF SalesShptHeader.GET("Document No.") THEN BEGIN
                                RecRef.GETTABLE(SalesShptHeader);
                                "Record Identifier" := RecRef.RECORDID;
                            END ELSE
                                IF SalesInvHeader.GET("Document No.") THEN BEGIN
                                    RecRef.GETTABLE(SalesInvHeader);
                                    "Record Identifier" := RecRef.RECORDID;
                                END ELSE
                                    IF ItemLedgEntry.GET("Item Ledger Entry No.") THEN BEGIN
                                        RecRef.GETTABLE(ItemLedgEntry);
                                        "Record Identifier" := RecRef.RECORDID;
                                    END;
                "Entry Type"::"Positive Adjmt.",
              "Entry Type"::"Negative Adjmt.":
                    IF ItemLedgEntry.GET("Item Ledger Entry No.") THEN BEGIN
                        RecRef.GETTABLE(ItemLedgEntry);
                        "Record Identifier" := RecRef.RECORDID;
                    END;
                "Entry Type"::Transfer:
                    IF TransShipHeader.GET("Document No.") THEN BEGIN
                        RecRef.GETTABLE(TransShipHeader);
                        "Record Identifier" := RecRef.RECORDID;
                    END ELSE
                        IF TransRcptHeader.GET("Document No.") THEN BEGIN
                            RecRef.GETTABLE(TransRcptHeader);
                            "Record Identifier" := RecRef.RECORDID;
                        END ELSE
                            IF ItemLedgEntry.GET("Item Ledger Entry No.") THEN BEGIN
                                RecRef.GETTABLE(ItemLedgEntry);
                                "Record Identifier" := RecRef.RECORDID;
                            END;
                "Entry Type"::"Assembly Consumption",
              "Entry Type"::"Assembly Output":
                    SetRecordIDAssembly(TrackingEntry);
                "Entry Type"::Consumption,
                "Entry Type"::Output:
                    BEGIN
                        ProductionOrder.SETFILTER(Status, '>=%1', ProductionOrder.Status::Released);
                        ProductionOrder.SETRANGE("No.", "Document No.");
                        IF ProductionOrder.FINDFIRST THEN BEGIN
                            RecRef.GETTABLE(ProductionOrder);
                            "Record Identifier" := RecRef.RECORDID;
                        END;
                    END;
            END;
        END;
    END;

    LOCAL PROCEDURE SetRecordIDAssembly(VAR ItemTracingBuffer: Record 6520);
    VAR
        PostedAssemblyHeader: Record 910;
        RecRef: RecordRef;
    BEGIN
        WITH ItemTracingBuffer DO
            IF PostedAssemblyHeader.GET("Document No.") THEN BEGIN
                RecRef.GETTABLE(PostedAssemblyHeader);
                "Record Identifier" := RecRef.RECORDID;
            END;
    END;

    //[External]
    PROCEDURE ShowDocument(RecID: RecordID);
    VAR
        ItemLedgEntry: Record 32;
        SalesShptHeader: Record 110;
        SalesInvHeader: Record 112;
        SalesCrMemoHeader: Record 114;
        ServShptHeader: Record 5990;
        ServInvHeader: Record 5992;
        ServCrMemoHeader: Record 5994;
        PurchRcptHeader: Record 120;
        PurchInvHeader: Record 122;
        PurchCrMemoHeader: Record 124;
        ReturnShipHeader: Record 6650;
        ReturnRcptHeader: Record 6660;
        TransShipHeader: Record 5744;
        TransRcptHeader: Record 5746;
        ProductionOrder: Record 5405;
        PostedAssemblyHeader: Record 910;
        RecRef: RecordRef;
    BEGIN
        IF FORMAT(RecID) = '' THEN
            EXIT;

        RecRef := RecID.GETRECORD;

        CASE RecID.TABLENO OF
            DATABASE::"Item Ledger Entry":
                BEGIN
                    RecRef.SETTABLE(ItemLedgEntry);
                    PAGE.RUNMODAL(PAGE::"Item Ledger Entries", ItemLedgEntry);
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
                    RecRef.SETTABLE(PurchCrMemoHeader);
                    PAGE.RUNMODAL(PAGE::"Posted Purchase Credit Memo", PurchCrMemoHeader);
                END;
            DATABASE::"Return Shipment Header":
                BEGIN
                    RecRef.SETTABLE(ReturnShipHeader);
                    PAGE.RUNMODAL(PAGE::"Posted Return Shipment", ReturnShipHeader);
                END;
            DATABASE::"Return Receipt Header":
                BEGIN
                    RecRef.SETTABLE(ReturnRcptHeader);
                    PAGE.RUNMODAL(PAGE::"Posted Return Receipt", ReturnRcptHeader);
                END;
            DATABASE::"Transfer Shipment Header":
                BEGIN
                    RecRef.SETTABLE(TransShipHeader);
                    PAGE.RUNMODAL(PAGE::"Posted Transfer Shipment", TransShipHeader);
                END;
            DATABASE::"Transfer Receipt Header":
                BEGIN
                    RecRef.SETTABLE(TransRcptHeader);
                    PAGE.RUNMODAL(PAGE::"Posted Transfer Receipt", TransRcptHeader);
                END;
            DATABASE::"Posted Assembly Line",
            DATABASE::"Posted Assembly Header":
                BEGIN
                    RecRef.SETTABLE(PostedAssemblyHeader);
                    PAGE.RUNMODAL(PAGE::"Posted Assembly Order", PostedAssemblyHeader);
                END;
            DATABASE::"Production Order":
                BEGIN
                    RecRef.SETTABLE(ProductionOrder);
                    IF ProductionOrder.Status = ProductionOrder.Status::Released THEN
                        PAGE.RUNMODAL(PAGE::"Released Production Order", ProductionOrder)
                    ELSE
                        IF ProductionOrder.Status = ProductionOrder.Status::Finished THEN
                            PAGE.RUNMODAL(PAGE::"Finished Production Order", ProductionOrder);
                END;
        END;
    END;

    //[External]
    PROCEDURE SetExpansionStatus(Rec: Record 6520; VAR TempTrackEntry: Record 6520; VAR TempTrackEntry2: Record 6520; VAR ActualExpansionStatus: Option "Has Children","Expanded","No Children");
    BEGIN
        IF IsExpanded(Rec, TempTrackEntry2) THEN
            ActualExpansionStatus := ActualExpansionStatus::Expanded
        ELSE
            IF HasChildren(Rec, TempTrackEntry) THEN
                ActualExpansionStatus := ActualExpansionStatus::"Has Children"
            ELSE
                ActualExpansionStatus := ActualExpansionStatus::"No Children";
    END;

    LOCAL PROCEDURE GetItem(VAR Item: Record 27; ItemNo: Code[20]);
    BEGIN
        IF ItemNo <> Item."No." THEN
            IF NOT Item.GET(ItemNo) THEN
                CLEAR(Item);
    END;

    LOCAL PROCEDURE GetItemDescription(ItemNo: Code[20]): Text[50];
    VAR
        Item: Record 27;
    BEGIN
        GetItem(Item, ItemNo);
        EXIT(Item.Description);
    END;

    LOCAL PROCEDURE GetItemTrackingCode(VAR ItemTrackingCode: Record 6502; ItemNo: Code[20]);
    VAR
        Item: Record 27;
    BEGIN
        GetItem(Item, ItemNo);
        IF Item."Item Tracking Code" <> '' THEN BEGIN
            IF NOT ItemTrackingCode.GET(Item."Item Tracking Code") THEN
                CLEAR(ItemTrackingCode);
        END ELSE
            CLEAR(ItemTrackingCode);
    END;

    //[External]
    PROCEDURE SpecificTracking(ItemNo: Code[20]; SerialNo: Code[50]; LotNo: Code[50]): Boolean;
    VAR
        ItemTrackingCode: Record 6502;
    BEGIN
        GetItemTrackingCode(ItemTrackingCode, ItemNo);
        IF ((SerialNo <> '') AND ItemTrackingCode."SN Specific Tracking") OR
           ((LotNo <> '') AND ItemTrackingCode."Lot Specific Tracking")
        THEN
            EXIT(TRUE);

        EXIT(FALSE);
    END;

    LOCAL PROCEDURE ExitLevel(TempTrackEntry: Record 6520): Boolean;
    BEGIN
        WITH TempTrackEntry DO BEGIN
            IF ("Serial No." = '') AND ("Lot No." = '') THEN
                EXIT(TRUE);
            IF CurrentLevel > 50 THEN
                EXIT(TRUE);
            IF NOT SpecificTracking("Item No.", "Serial No.", "Lot No.") THEN
                EXIT(TRUE);
            IF "Already Traced" THEN
                EXIT(TRUE);
        END;

        EXIT(FALSE);
    END;

    LOCAL PROCEDURE UpdateHistory(SerialNoFilter: Text; LotNoFilter: Text; ItemNoFilter: Text; VariantFilter: Text; TraceMethod: Option "Origin->Usage","Usage->Origin"; ShowComponents: Option "No","Item-tracked only","All") OK: Boolean;
    VAR
        LevelCount: Integer;
    BEGIN
        WITH TempTraceHistory DO BEGIN
            RESET;
            SETFILTER("Entry No.", '>%1', CurrentHistoryEntryNo);
            DELETEALL;

            REPEAT
                INIT;
                "Entry No." := CurrentHistoryEntryNo + 1;
                Level := LevelCount;

                "Serial No. Filter" := COPYSTR(SerialNoFilter, 1, MAXSTRLEN("Serial No. Filter"));
                "Lot No. Filter" := COPYSTR(LotNoFilter, 1, MAXSTRLEN("Lot No. Filter"));
                "Item No. Filter" := COPYSTR(ItemNoFilter, 1, MAXSTRLEN("Item No. Filter"));
                "Variant Filter" := COPYSTR(VariantFilter, 1, MAXSTRLEN("Variant Filter"));

                IF Level = 0 THEN BEGIN
                    "Trace Method" := TraceMethod;
                    "Show Components" := ShowComponents;
                END;
                INSERT;

                LevelCount += 1;
                SerialNoFilter := DELSTR(SerialNoFilter, 1, MAXSTRLEN("Serial No. Filter"));
                LotNoFilter := DELSTR(LotNoFilter, 1, MAXSTRLEN("Lot No. Filter"));
                ItemNoFilter := DELSTR(ItemNoFilter, 1, MAXSTRLEN("Item No. Filter"));
                VariantFilter := DELSTR(VariantFilter, 1, MAXSTRLEN("Variant Filter"));
            UNTIL (SerialNoFilter = '') AND (LotNoFilter = '') AND (ItemNoFilter = '') AND (VariantFilter = '');
            CurrentHistoryEntryNo := "Entry No.";
        END;
        OK := TRUE;
    END;

    //[External]
    PROCEDURE RecallHistory(Steps: Integer; VAR TempTrackEntry: Record 6520; VAR TempTrackEntry2: Record 6520; VAR SerialNoFilter: Text; VAR LotNoFilter: Text; VAR ItemNoFilter: Text; VAR VariantFilter: Text; VAR TraceMethod: Option "Origin->Usage","Usage->Origin"; VAR ShowComponents: Option "No","Item-tracked only","All"): Boolean;
    BEGIN
        IF NOT RetrieveHistoryData(CurrentHistoryEntryNo + Steps,
             SerialNoFilter, LotNoFilter, ItemNoFilter, VariantFilter, TraceMethod, ShowComponents)
        THEN
            EXIT(FALSE);
        DeleteTempTables(TempTrackEntry, TempTrackEntry2);
        InitSearchCriteria(SerialNoFilter, LotNoFilter, ItemNoFilter);
        FirstLevel(TempTrackEntry, SerialNoFilter, LotNoFilter, ItemNoFilter,
          VariantFilter, TraceMethod, ShowComponents);
        IF TempLineNo > 0 THEN
            InitTempTable(TempTrackEntry, TempTrackEntry2);
        TempTrackEntry.RESET;
        CurrentHistoryEntryNo := CurrentHistoryEntryNo + Steps;
        EXIT(TRUE);
    END;

    LOCAL PROCEDURE RetrieveHistoryData(EntryNo: Integer; VAR SerialNoFilter: Text; VAR LotNoFilter: Text; VAR ItemNoFilter: Text; VAR VariantFilter: Text; VAR TraceMethod: Option "Origin->Usage","Usage->Origin"; VAR ShowComponents: Option "No","Item-tracked only","All"): Boolean;
    BEGIN
        WITH TempTraceHistory DO BEGIN
            RESET;
            SETCURRENTKEY("Entry No.", Level);
            SETRANGE("Entry No.", EntryNo);
            IF NOT FINDSET THEN
                EXIT(FALSE);
            REPEAT
                IF Level = 0 THEN BEGIN
                    SerialNoFilter := "Serial No. Filter";
                    LotNoFilter := "Lot No. Filter";
                    ItemNoFilter := "Item No. Filter";
                    VariantFilter := "Variant Filter";
                    TraceMethod := "Trace Method";
                    ShowComponents := "Show Components";
                END ELSE BEGIN
                    SerialNoFilter := SerialNoFilter + "Serial No. Filter";
                    LotNoFilter := LotNoFilter + "Lot No. Filter";
                    ItemNoFilter := ItemNoFilter + "Item No. Filter";
                    VariantFilter := VariantFilter + "Variant Filter";
                END;
            UNTIL NEXT = 0;
            EXIT(TRUE);
        END;
    END;

    //[External]
    PROCEDURE GetHistoryStatus(VAR PreviousExists: Boolean; VAR NextExists: Boolean);
    BEGIN
        TempTraceHistory.RESET;
        TempTraceHistory.SETFILTER("Entry No.", '>%1', CurrentHistoryEntryNo);
        NextExists := NOT TempTraceHistory.ISEMPTY;
        TempTraceHistory.SETFILTER("Entry No.", '<%1', CurrentHistoryEntryNo);
        PreviousExists := NOT TempTraceHistory.ISEMPTY;
    END;

    LOCAL PROCEDURE IsServiceDocument(ItemLedgEntryNo: Integer; VAR ItemLedgEntry: Record 32): Boolean;
    BEGIN
        WITH ItemLedgEntry DO
            IF GET(ItemLedgEntryNo) THEN
                IF "Document Type" IN [
                                       "Document Type"::"Service Shipment", "Document Type"::"Service Invoice",
                                       "Document Type"::"Service Credit Memo"]
                THEN
                    EXIT(TRUE);
        EXIT(FALSE);
    END;

    /* /*BEGIN
END.*/
}





