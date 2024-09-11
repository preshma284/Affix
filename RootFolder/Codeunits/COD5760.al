Codeunit 50019 "Whse.-Post Receipt 1"
{


    TableNo = 7317;
    Permissions = TableData 6509 = i,
                TableData 7318 = i,
                TableData 7319 = i;
    trigger OnRun()
    BEGIN
        OnBeforeRun(Rec);

        WhseRcptLine.COPY(Rec);
        Code;
        Rec := WhseRcptLine;

        OnAfterRun(Rec);
    END;

    VAR
        Text000: TextConst ENU = 'The source document %1 %2 is not released.', ESP = 'No se ha lanzado el documento origen %1 %2.';
        Text001: TextConst ENU = 'There is nothing to post.', ESP = 'No hay nada que registrar.';
        Text002: TextConst ENU = 'Number of source documents posted: %1 out of a total of %2.', ESP = 'N�mero documentos origen registrados: %1 de un total de %2.';
        Text003: TextConst ENU = 'Number of put-away activities created: %3.', ESP = 'N�mero actividades ubicaci�n creadas: %3.';
        WhseRcptHeader: Record 7316;
        WhseRcptLine: Record 7317;
        WhseRcptLineBuf: Record 7317 TEMPORARY;
        TransHeader: Record 5740;
        SalesHeader: Record 36;
        PurchHeader: Record 38;
        TempWhseJnlLine: Record 7311 TEMPORARY;
        Location: Record 14;
        ItemUnitOfMeasure: Record 5404;
        WhseRqst: Record 5765;
        TempWhseItemEntryRelation: Record 6509 TEMPORARY;
        NoSeriesMgt: Codeunit 396;
        ItemTrackingMgt: Codeunit 6500;
        WMSMgt: Codeunit 7302;
        WhseJnlRegisterLine: Codeunit 7301;
        CreatePutAway: Codeunit 7313;
        PostingDate: Date;
        CounterSourceDocOK: Integer;
        CounterSourceDocTotal: Integer;
        CounterPutAways: Integer;
        PutAwayRequired: Boolean;
        HideValidationDialog: Boolean;
        ReceivingNo: Code[20];
        ItemEntryRelationCreated: Boolean;
        Text004: TextConst ENU = 'is not within your range of allowed posting dates', ESP = 'no est� dentro del periodo de fechas de registro permitidas';
        QBCodeunitPublisher: Codeunit 7207352;

    LOCAL PROCEDURE Code();
    VAR
        WhseManagement: Codeunit 5775;
    BEGIN
        WITH WhseRcptLine DO BEGIN
            SETCURRENTKEY("No.");
            SETRANGE("No.", "No.");
            SETFILTER("Qty. to Receive", '>0');
            IF FIND('-') THEN
                REPEAT
                    TESTFIELD("Unit of Measure Code");
                    WhseRqst.GET(
                      WhseRqst.Type::Inbound, "Location Code", "Source Type", "Source Subtype", "Source No.");
                    IF WhseRqst."Document Status" <> WhseRqst."Document Status"::Released THEN
                        ERROR(Text000, "Source Document", "Source No.");
                    OnAfterCheckWhseRcptLine(WhseRcptLine);
                UNTIL NEXT = 0
            ELSE
                ERROR(Text001);

            CounterSourceDocOK := 0;
            CounterSourceDocTotal := 0;
            CounterPutAways := 0;
            CLEAR(CreatePutAway);

            WhseRcptHeader.GET("No.");
            WhseRcptHeader.TESTFIELD("Posting Date");
            OnAfterCheckWhseRcptLines(WhseRcptHeader, WhseRcptLine);
            IF WhseRcptHeader."Receiving No." = '' THEN BEGIN
                WhseRcptHeader.TESTFIELD("Receiving No. Series");
                WhseRcptHeader."Receiving No." :=
                  NoSeriesMgt.GetNextNo(
                    WhseRcptHeader."Receiving No. Series", WhseRcptHeader."Posting Date", TRUE);
            END;
            WhseRcptHeader."Create Posted Header" := TRUE;
            OnCodeOnBeforeWhseRcptHeaderModify(WhseRcptHeader, WhseRcptLine);
            WhseRcptHeader.MODIFY;
            COMMIT;

            SETCURRENTKEY("No.", "Source Type", "Source Subtype", "Source No.", "Source Line No.");
            FINDSET(TRUE);
            REPEAT
                WhseManagement.SetSourceFilterForWhseRcptLine(WhseRcptLine, "Source Type", "Source Subtype", "Source No.", -1, FALSE);
                GetSourceDocument;
                MakePreliminaryChecks;
                InitSourceDocumentLines(WhseRcptLine);
                InitSourceDocumentHeader;
                COMMIT;

                CounterSourceDocTotal := CounterSourceDocTotal + 1;

                OnBeforePostSourceDocument(WhseRcptLine, PurchHeader, SalesHeader, TransHeader);
                PostSourceDocument(WhseRcptLine);

                IF FINDLAST THEN;
                SETRANGE("Source Type");
                SETRANGE("Source Subtype");
                SETRANGE("Source No.");
            UNTIL NEXT = 0;

            GetLocation("Location Code");
            PutAwayRequired := Location.RequirePutaway("Location Code");
            IF PutAwayRequired AND NOT Location."Use Put-away Worksheet" THEN
                CreatePutAwayDoc(WhseRcptHeader);

            CLEAR(WMSMgt);
            CLEAR(WhseJnlRegisterLine);
        END;
    END;

    LOCAL PROCEDURE GetSourceDocument();
    BEGIN
        WITH WhseRcptLine DO
            CASE "Source Type" OF
                DATABASE::"Purchase Line":
                    PurchHeader.GET("Source Subtype", "Source No.");
                DATABASE::"Sales Line": // Return Order
                    SalesHeader.GET("Source Subtype", "Source No.");
                DATABASE::"Transfer Line":
                    TransHeader.GET("Source No.");
            END;
    END;

    LOCAL PROCEDURE MakePreliminaryChecks();
    VAR
        GenJnlCheckLine: Codeunit 11;
    BEGIN
        WITH WhseRcptHeader DO BEGIN
            IF GenJnlCheckLine.DateNotAllowed("Posting Date") THEN
                FIELDERROR("Posting Date", Text004);
        END;
    END;

    LOCAL PROCEDURE InitSourceDocumentHeader();
    VAR
        SalesRelease: Codeunit 414;
        PurchRelease: Codeunit 415;
        ModifyHeader: Boolean;
    BEGIN
        WITH WhseRcptLine DO
            CASE "Source Type" OF
                DATABASE::"Purchase Line":
                    BEGIN
                        IF (PurchHeader."Posting Date" = 0D) OR
                           (PurchHeader."Posting Date" <> WhseRcptHeader."Posting Date")
                        THEN BEGIN
                            PurchRelease.Reopen(PurchHeader);
                            PurchRelease.SetSkipCheckReleaseRestrictions;
                            PurchHeader.SetHideValidationDialog(TRUE);
                            PurchHeader.VALIDATE("Posting Date", WhseRcptHeader."Posting Date");
                            PurchRelease.RUN(PurchHeader);
                            ModifyHeader := TRUE;
                        END;
                        IF WhseRcptHeader."Vendor Shipment No." <> '' THEN BEGIN
                            PurchHeader."Vendor Shipment No." := WhseRcptHeader."Vendor Shipment No.";
                            ModifyHeader := TRUE;
                        END;
                        OnInitSourceDocumentHeaderOnBeforePurchHeaderModify(PurchHeader, WhseRcptHeader, ModifyHeader);
                        IF ModifyHeader THEN
                            PurchHeader.MODIFY;
                    END;
                DATABASE::"Sales Line": // Return Order
                    BEGIN
                        IF (SalesHeader."Posting Date" = 0D) OR
                           (SalesHeader."Posting Date" <> WhseRcptHeader."Posting Date")
                        THEN BEGIN
                            SalesRelease.Reopen(SalesHeader);
                            SalesRelease.SetSkipCheckReleaseRestrictions;
                            SalesHeader.SetHideValidationDialog(TRUE);
                            SalesHeader.VALIDATE("Posting Date", WhseRcptHeader."Posting Date");
                            SalesRelease.RUN(SalesHeader);
                            ModifyHeader := TRUE;
                        END;
                        OnInitSourceDocumentHeaderOnBeforeSalesHeaderModify(SalesHeader, WhseRcptHeader, ModifyHeader);
                        IF ModifyHeader THEN
                            SalesHeader.MODIFY;
                    END;
                DATABASE::"Transfer Line":
                    BEGIN
                        IF (TransHeader."Posting Date" = 0D) OR
                           (TransHeader."Posting Date" <> WhseRcptHeader."Posting Date")
                        THEN BEGIN
                            TransHeader.CalledFromWarehouse(TRUE);
                            TransHeader.VALIDATE("Posting Date", WhseRcptHeader."Posting Date");
                            ModifyHeader := TRUE;
                        END;
                        IF WhseRcptHeader."Vendor Shipment No." <> '' THEN BEGIN
                            TransHeader."External Document No." := WhseRcptHeader."Vendor Shipment No.";
                            ModifyHeader := TRUE;
                        END;
                        OnInitSourceDocumentHeaderOnBeforeTransHeaderModify(TransHeader, WhseRcptHeader, ModifyHeader);
                        IF ModifyHeader THEN
                            TransHeader.MODIFY;
                    END;
                ELSE
                    OnInitSourceDocumentHeader(WhseRcptHeader, WhseRcptLine);
            END;
    END;

    LOCAL PROCEDURE InitSourceDocumentLines(VAR WhseRcptLine: Record 7317);
    VAR
        WhseRcptLine2: Record 7317;
        TransLine: Record 5741;
        SalesLine: Record 37;
        PurchLine: Record 39;
        ModifyLine: Boolean;
    BEGIN
        WhseRcptLine2.COPY(WhseRcptLine);
        WITH WhseRcptLine2 DO BEGIN
            CASE "Source Type" OF
                DATABASE::"Purchase Line":
                    BEGIN
                        PurchLine.SETRANGE("Document Type", "Source Subtype");
                        PurchLine.SETRANGE("Document No.", "Source No.");
                        IF PurchLine.FIND('-') THEN
                            REPEAT
                                SETRANGE("Source Line No.", PurchLine."Line No.");
                                IF FINDFIRST THEN BEGIN
                                    OnAfterFindWhseRcptLineForPurchLine(WhseRcptLine2, PurchLine);
                                    IF "Source Document" = "Source Document"::"Purchase Order" THEN BEGIN
                                        ModifyLine := PurchLine."Qty. to Receive" <> "Qty. to Receive";
                                        IF ModifyLine THEN
                                            PurchLine.VALIDATE("Qty. to Receive", "Qty. to Receive")
                                    END ELSE BEGIN
                                        ModifyLine := PurchLine."Return Qty. to Ship" <> -"Qty. to Receive";
                                        IF ModifyLine THEN
                                            PurchLine.VALIDATE("Return Qty. to Ship", -"Qty. to Receive");
                                    END;
                                    IF PurchLine."Bin Code" <> "Bin Code" THEN BEGIN
                                        PurchLine."Bin Code" := "Bin Code";
                                        ModifyLine := TRUE;
                                    END;
                                END ELSE
                                    IF "Source Document" = "Source Document"::"Purchase Order" THEN BEGIN
                                        ModifyLine := PurchLine."Qty. to Receive" <> 0;
                                        IF ModifyLine THEN
                                            PurchLine.VALIDATE("Qty. to Receive", 0);
                                    END ELSE BEGIN
                                        ModifyLine := PurchLine."Return Qty. to Ship" <> 0;
                                        IF ModifyLine THEN
                                            PurchLine.VALIDATE("Return Qty. to Ship", 0);
                                    END;
                                OnBeforePurchLineModify(PurchLine, WhseRcptLine2, ModifyLine);
                                IF ModifyLine THEN
                                    PurchLine.MODIFY;
                            UNTIL PurchLine.NEXT = 0;
                    END;
                DATABASE::"Sales Line": // Return Order
                    BEGIN
                        SalesLine.SETRANGE("Document Type", "Source Subtype");
                        SalesLine.SETRANGE("Document No.", "Source No.");
                        IF SalesLine.FIND('-') THEN
                            REPEAT
                                SETRANGE("Source Line No.", SalesLine."Line No.");
                                IF FINDFIRST THEN BEGIN
                                    OnAfterFindWhseRcptLineForSalesLine(WhseRcptLine2, SalesLine);
                                    IF "Source Document" = "Source Document"::"Sales Order" THEN BEGIN
                                        ModifyLine := SalesLine."Qty. to Ship" <> -"Qty. to Receive";
                                        IF ModifyLine THEN
                                            SalesLine.VALIDATE("Qty. to Ship", -"Qty. to Receive");
                                    END ELSE BEGIN
                                        ModifyLine := SalesLine."Return Qty. to Receive" <> "Qty. to Receive";
                                        IF ModifyLine THEN
                                            SalesLine.VALIDATE("Return Qty. to Receive", "Qty. to Receive");
                                    END;
                                    IF SalesLine."Bin Code" <> "Bin Code" THEN BEGIN
                                        SalesLine."Bin Code" := "Bin Code";
                                        ModifyLine := TRUE;
                                    END;
                                END ELSE
                                    IF "Source Document" = "Source Document"::"Sales Order" THEN BEGIN
                                        ModifyLine := SalesLine."Qty. to Ship" <> 0;
                                        IF ModifyLine THEN
                                            SalesLine.VALIDATE("Qty. to Ship", 0);
                                    END ELSE BEGIN
                                        ModifyLine := SalesLine."Return Qty. to Receive" <> 0;
                                        IF ModifyLine THEN
                                            SalesLine.VALIDATE("Return Qty. to Receive", 0);
                                    END;
                                OnBeforeSalesLineModify(SalesLine, WhseRcptLine2, ModifyLine);
                                IF ModifyLine THEN
                                    SalesLine.MODIFY;
                            UNTIL SalesLine.NEXT = 0;
                    END;
                DATABASE::"Transfer Line":
                    BEGIN
                        TransLine.SETRANGE("Document No.", "Source No.");
                        TransLine.SETRANGE("Derived From Line No.", 0);
                        IF TransLine.FIND('-') THEN
                            REPEAT
                                SETRANGE("Source Line No.", TransLine."Line No.");
                                IF FINDFIRST THEN BEGIN
                                    OnAfterFindWhseRcptLineForTransLine(WhseRcptLine2, TransLine);
                                    ModifyLine := TransLine."Qty. to Receive" <> "Qty. to Receive";
                                    IF ModifyLine THEN
                                        TransLine.VALIDATE("Qty. to Receive", "Qty. to Receive");
                                    IF TransLine."Transfer-To Bin Code" <> "Bin Code" THEN BEGIN
                                        TransLine."Transfer-To Bin Code" := "Bin Code";
                                        ModifyLine := TRUE;
                                    END;
                                END ELSE BEGIN
                                    ModifyLine := TransLine."Qty. to Receive" <> 0;
                                    IF ModifyLine THEN
                                        TransLine.VALIDATE("Qty. to Receive", 0);
                                END;
                                OnBeforeTransLineModify(TransLine, WhseRcptLine2, ModifyLine);
                                IF ModifyLine THEN
                                    TransLine.MODIFY;
                            UNTIL TransLine.NEXT = 0;
                    END;
                ELSE
                    OnInitSourceDocumentLines(WhseRcptLine2);
            END;
            SETRANGE("Source Line No.");
        END;

        OnAfterInitSourceDocumentLines(WhseRcptLine2);
    END;

    LOCAL PROCEDURE PostSourceDocument(WhseRcptLine: Record 7317);
    VAR
        WhseSetup: Record 5769;
        WhseRcptHeader: Record 7316;
        PurchPost: Codeunit 90;
        SalesPost: Codeunit 80;
        TransferPostReceipt: Codeunit 5705;
    BEGIN
        WhseSetup.GET;
        WITH WhseRcptLine DO BEGIN
            WhseRcptHeader.GET("No.");
            CASE "Source Type" OF
                DATABASE::"Purchase Line":
                    BEGIN
                        IF "Source Document" = "Source Document"::"Purchase Order" THEN
                            PurchHeader.Receive := TRUE
                        ELSE
                            PurchHeader.Ship := TRUE;
                        PurchHeader.Invoice := FALSE;

                        PurchPost.SetWhseRcptHeader(WhseRcptHeader);
                        CASE WhseSetup."Receipt Posting Policy" OF
                            WhseSetup."Receipt Posting Policy"::"Posting errors are not processed":
                                BEGIN
                                    IF PurchPost.RUN(PurchHeader) THEN
                                        CounterSourceDocOK := CounterSourceDocOK + 1;
                                END;
                            WhseSetup."Receipt Posting Policy"::"Stop and show the first posting error":
                                BEGIN
                                    PurchPost.RUN(PurchHeader);
                                    CounterSourceDocOK := CounterSourceDocOK + 1;
                                END;
                        END;
                        CLEAR(PurchPost);
                    END;
                DATABASE::"Sales Line": // Return Order
                    BEGIN
                        IF "Source Document" = "Source Document"::"Sales Order" THEN
                            SalesHeader.Ship := TRUE
                        ELSE
                            SalesHeader.Receive := TRUE;
                        SalesHeader.Invoice := FALSE;

                        SalesPost.SetWhseRcptHeader(WhseRcptHeader);
                        CASE WhseSetup."Receipt Posting Policy" OF
                            WhseSetup."Receipt Posting Policy"::"Posting errors are not processed":
                                BEGIN
                                    IF SalesPost.RUN(SalesHeader) THEN
                                        CounterSourceDocOK := CounterSourceDocOK + 1;
                                END;
                            WhseSetup."Receipt Posting Policy"::"Stop and show the first posting error":
                                BEGIN
                                    SalesPost.RUN(SalesHeader);
                                    CounterSourceDocOK := CounterSourceDocOK + 1;
                                END;
                        END;
                        CLEAR(SalesPost);
                    END;
                DATABASE::"Transfer Line":
                    BEGIN
                        IF HideValidationDialog THEN
                            TransferPostReceipt.SetHideValidationDialog(HideValidationDialog);
                        TransferPostReceipt.SetWhseRcptHeader(WhseRcptHeader);
                        CASE WhseSetup."Receipt Posting Policy" OF
                            WhseSetup."Receipt Posting Policy"::"Posting errors are not processed":
                                BEGIN
                                    IF TransferPostReceipt.RUN(TransHeader) THEN
                                        CounterSourceDocOK := CounterSourceDocOK + 1;
                                END;
                            WhseSetup."Receipt Posting Policy"::"Stop and show the first posting error":
                                BEGIN
                                    TransferPostReceipt.RUN(TransHeader);
                                    CounterSourceDocOK := CounterSourceDocOK + 1;
                                END;
                        END;
                        CLEAR(TransferPostReceipt);
                    END;
                ELSE
                    OnPostSourceDocument(WhseRcptHeader, WhseRcptLine);
            END;
        END;
    END;

    //[External]
    PROCEDURE GetResultMessage();
    VAR
        MessageText: Text[250];
    BEGIN
        MessageText := Text002;
        IF CounterPutAways > 0 THEN
            MessageText := MessageText + '\\' + Text003;
        MESSAGE(MessageText, CounterSourceDocOK, CounterSourceDocTotal, CounterPutAways);
    END;

    //[External]
    PROCEDURE PostUpdateWhseDocuments(VAR WhseRcptHeader: Record 7316);
    VAR
        WhseRcptLine2: Record 7317;
        WhsePutAwayRequest: Record 7324;
        DeleteWhseRcptLine: Boolean;
    BEGIN
        OnBeforePostUpdateWhseDocuments(WhseRcptHeader);
        WITH WhseRcptLineBuf DO
            IF FIND('-') THEN BEGIN
                REPEAT
                    WhseRcptLine2.GET("No.", "Line No.");
                    DeleteWhseRcptLine := "Qty. Outstanding" = "Qty. to Receive";
                    OnBeforePostUpdateWhseRcptLine(WhseRcptLine2, WhseRcptLineBuf, DeleteWhseRcptLine);
                    IF DeleteWhseRcptLine THEN
                        WhseRcptLine2.DELETE
                    ELSE BEGIN
                        WhseRcptLine2.VALIDATE("Qty. Received", "Qty. Received" + "Qty. to Receive");
                        // WhseRcptLine2.VALIDATE("Qty. Outstanding","Qty. Outstanding" - "Qty. to Receive");

                        QBCodeunitPublisher.PostUpdateWhseDocumentsCUWhsePostReceipt(WhseRcptHeader);   // QB

                        WhseRcptLine2."Qty. to Cross-Dock" := 0;
                        WhseRcptLine2."Qty. to Cross-Dock (Base)" := 0;
                        WhseRcptLine2.Status := WhseRcptLine2.GetLineStatus;
                        WhseRcptLine2.MODIFY;
                        OnAfterPostUpdateWhseRcptLine(WhseRcptLine2);
                    END;
                UNTIL NEXT = 0;
                DELETEALL;
            END;

        IF WhseRcptHeader."Create Posted Header" THEN BEGIN
            WhseRcptHeader."Last Receiving No." := WhseRcptHeader."Receiving No.";
            WhseRcptHeader."Receiving No." := '';
            WhseRcptHeader."Create Posted Header" := FALSE;
        END;

        WhseRcptLine2.SETRANGE("No.", WhseRcptHeader."No.");
        IF WhseRcptLine2.FINDFIRST THEN BEGIN
            WhseRcptHeader."Document Status" := WhseRcptHeader.GetHeaderStatus(0);
            WhseRcptHeader.MODIFY;
        END ELSE BEGIN
            WhseRcptHeader.DeleteRelatedLines(FALSE);
            WhseRcptHeader.DELETE;
        END;

        GetLocation(WhseRcptHeader."Location Code");
        IF Location."Require Put-away" THEN BEGIN
            WhsePutAwayRequest."Document Type" := WhsePutAwayRequest."Document Type"::Receipt;
            WhsePutAwayRequest."Document No." := WhseRcptHeader."Last Receiving No.";
            WhsePutAwayRequest."Location Code" := WhseRcptHeader."Location Code";
            WhsePutAwayRequest."Zone Code" := WhseRcptHeader."Zone Code";
            WhsePutAwayRequest."Bin Code" := WhseRcptHeader."Bin Code";
            IF WhsePutAwayRequest.INSERT THEN;
        END;

        OnAfterPostUpdateWhseDocuments(WhseRcptHeader, WhsePutAwayRequest);
    END;

    //[External]
    PROCEDURE CreatePostedRcptHeader(VAR PostedWhseRcptHeader: Record 7318; VAR WhseRcptHeader: Record 7316; ReceivingNo2: Code[20]; PostingDate2: Date);
    VAR
        WhseComment: Record 5770;
        WhseComment2: Record 5770;
    BEGIN
        ReceivingNo := ReceivingNo2;
        PostingDate := PostingDate2;

        IF NOT WhseRcptHeader."Create Posted Header" THEN BEGIN
            PostedWhseRcptHeader.GET(WhseRcptHeader."Last Receiving No.");
            EXIT;
        END;

        PostedWhseRcptHeader.INIT;
        PostedWhseRcptHeader.TRANSFERFIELDS(WhseRcptHeader);
        PostedWhseRcptHeader."No." := WhseRcptHeader."Receiving No.";
        PostedWhseRcptHeader."Whse. Receipt No." := WhseRcptHeader."No.";
        PostedWhseRcptHeader."No. Series" := WhseRcptHeader."Receiving No. Series";

        GetLocation(PostedWhseRcptHeader."Location Code");
        IF NOT Location."Require Put-away" THEN
            PostedWhseRcptHeader."Document Status" := PostedWhseRcptHeader."Document Status"::"Completely Put Away";
        OnBeforePostedWhseRcptHeaderInsert(PostedWhseRcptHeader, WhseRcptHeader);
        PostedWhseRcptHeader.INSERT;

        WhseComment.SETRANGE("Table Name", WhseComment."Table Name"::"Whse. Receipt");
        WhseComment.SETRANGE(Type, WhseComment.Type::" ");
        WhseComment.SETRANGE("No.", WhseRcptHeader."No.");
        IF WhseComment.FIND('-') THEN
            REPEAT
                WhseComment2.INIT;
                WhseComment2 := WhseComment;
                WhseComment2."Table Name" := WhseComment2."Table Name"::"Posted Whse. Receipt";
                WhseComment2."No." := PostedWhseRcptHeader."No.";
                WhseComment2.INSERT;
            UNTIL WhseComment.NEXT = 0;
    END;

    //[External]
    PROCEDURE CreatePostedRcptLine(VAR WhseRcptLine: Record 7317; VAR PostedWhseRcptHeader: Record 7318; VAR PostedWhseRcptLine: Record 7319; VAR TempHandlingSpecification: Record 336);
    BEGIN
        UpdateWhseRcptLineBuf(WhseRcptLine);
        WITH PostedWhseRcptLine DO BEGIN
            INIT;
            TRANSFERFIELDS(WhseRcptLine);
            "No." := PostedWhseRcptHeader."No.";
            OnAfterInitPostedRcptLine(WhseRcptLine, PostedWhseRcptLine);
            Quantity := WhseRcptLine."Qty. to Receive";
            "Qty. (Base)" := WhseRcptLine."Qty. to Receive (Base)";
            CASE WhseRcptLine."Source Document" OF
                WhseRcptLine."Source Document"::"Purchase Order":
                    "Posted Source Document" := "Posted Source Document"::"Posted Receipt";
                WhseRcptLine."Source Document"::"Sales Order":
                    "Posted Source Document" := "Posted Source Document"::"Posted Shipment";
                WhseRcptLine."Source Document"::"Purchase Return Order":
                    "Posted Source Document" := "Posted Source Document"::"Posted Return Shipment";
                WhseRcptLine."Source Document"::"Sales Return Order":
                    "Posted Source Document" := "Posted Source Document"::"Posted Return Receipt";
                WhseRcptLine."Source Document"::"Inbound Transfer":
                    "Posted Source Document" := "Posted Source Document"::"Posted Transfer Receipt";
            END;

            GetLocation("Location Code");
            IF NOT Location."Require Put-away" THEN BEGIN
                "Qty. Put Away" := Quantity;
                "Qty. Put Away (Base)" := "Qty. (Base)";
                Status := Status::"Completely Put Away";
            END;
            "Posted Source No." := ReceivingNo;
            "Posting Date" := PostingDate;
            "Whse. Receipt No." := WhseRcptLine."No.";
            "Whse Receipt Line No." := WhseRcptLine."Line No.";
            INSERT;
        END;

        PostWhseJnlLine(PostedWhseRcptHeader, PostedWhseRcptLine, TempHandlingSpecification);
    END;

    LOCAL PROCEDURE UpdateWhseRcptLineBuf(WhseRcptLine2: Record 7317);
    BEGIN
        WITH WhseRcptLine2 DO BEGIN
            WhseRcptLineBuf."No." := "No.";
            WhseRcptLineBuf."Line No." := "Line No.";
            IF NOT WhseRcptLineBuf.FIND THEN BEGIN
                WhseRcptLineBuf.INIT;
                WhseRcptLineBuf := WhseRcptLine2;
                WhseRcptLineBuf.INSERT;
            END;
        END;
    END;

    LOCAL PROCEDURE PostWhseJnlLine(VAR PostedWhseRcptHeader: Record 7318; VAR PostedWhseRcptLine: Record 7319; VAR TempWhseSplitSpecification: Record 336 TEMPORARY);
    VAR
        TempWhseJnlLine2: Record 7311 TEMPORARY;
        IsHandled: Boolean;
    BEGIN
        IsHandled := FALSE;
        OnBeforePostWhseJnlLine(PostedWhseRcptHeader, PostedWhseRcptLine, WhseRcptLine, TempWhseSplitSpecification, IsHandled);
        IF IsHandled THEN
            EXIT;

        WITH PostedWhseRcptLine DO BEGIN
            GetLocation("Location Code");
            InsertWhseItemEntryRelation(PostedWhseRcptHeader, PostedWhseRcptLine, TempWhseSplitSpecification);

            IF Location."Bin Mandatory" THEN BEGIN
                InsertTempWhseJnlLine(PostedWhseRcptLine);

                TempWhseJnlLine.GET('', '', "Location Code", "Line No.");
                TempWhseJnlLine."Line No." := 0;
                TempWhseJnlLine."Reference No." := ReceivingNo;
                TempWhseJnlLine."Registering Date" := PostingDate;
                TempWhseJnlLine."Whse. Document Type" := TempWhseJnlLine."Whse. Document Type"::Receipt;
                TempWhseJnlLine."Whse. Document No." := "No.";
                TempWhseJnlLine."Whse. Document Line No." := "Line No.";
                TempWhseJnlLine."Registering No. Series" := PostedWhseRcptHeader."No. Series";
                OnBeforeRegisterWhseJnlLines(TempWhseJnlLine, PostedWhseRcptHeader, PostedWhseRcptLine);

                ItemTrackingMgt.SplitWhseJnlLine(TempWhseJnlLine, TempWhseJnlLine2, TempWhseSplitSpecification, FALSE);
                IF TempWhseJnlLine2.FIND('-') THEN
                    REPEAT
                        WhseJnlRegisterLine.RUN(TempWhseJnlLine2);
                    UNTIL TempWhseJnlLine2.NEXT = 0;
            END;
        END;

        OnAfterPostWhseJnlLine(WhseRcptLine);
    END;

    LOCAL PROCEDURE InsertWhseItemEntryRelation(VAR PostedWhseRcptHeader: Record 7318; VAR PostedWhseRcptLine: Record 7319; VAR TempWhseSplitSpecification: Record 336 TEMPORARY);
    VAR
        WhseItemEntryRelation: Record 6509;
    BEGIN
        IF ItemEntryRelationCreated THEN BEGIN
            IF TempWhseItemEntryRelation.FIND('-') THEN BEGIN
                REPEAT
                    WhseItemEntryRelation := TempWhseItemEntryRelation;
                    WhseItemEntryRelation.SetSource(
                      DATABASE::"Posted Whse. Receipt Line", 0, PostedWhseRcptHeader."No.", PostedWhseRcptLine."Line No.");
                    WhseItemEntryRelation.INSERT;
                UNTIL TempWhseItemEntryRelation.NEXT = 0;
                ItemEntryRelationCreated := FALSE;
            END;
            EXIT;
        END;
        TempWhseSplitSpecification.RESET;
        IF TempWhseSplitSpecification.FIND('-') THEN
            REPEAT
                WhseItemEntryRelation.InitFromTrackingSpec(TempWhseSplitSpecification);
                WhseItemEntryRelation.SetSource(
                  DATABASE::"Posted Whse. Receipt Line", 0, PostedWhseRcptHeader."No.", PostedWhseRcptLine."Line No.");
                WhseItemEntryRelation.INSERT;
            UNTIL TempWhseSplitSpecification.NEXT = 0;
    END;

    //[External]
    PROCEDURE GetFirstPutAwayDocument(VAR WhseActivHeader: Record 5766): Boolean;
    BEGIN
        EXIT(CreatePutAway.GetFirstPutAwayDocument(WhseActivHeader));
    END;

    //[External]
    PROCEDURE GetNextPutAwayDocument(VAR WhseActivHeader: Record 5766): Boolean;
    BEGIN
        EXIT(CreatePutAway.GetNextPutAwayDocument(WhseActivHeader));
    END;

    LOCAL PROCEDURE InsertTempWhseJnlLine(PostedWhseRcptLine: Record 7319);
    VAR
        SourceCodeSetup: Record 242;
        SNRequired: Boolean;
        LNRequired: Boolean;
    BEGIN
        WITH PostedWhseRcptLine DO BEGIN
            TempWhseJnlLine.INIT;
            TempWhseJnlLine."Entry Type" := TempWhseJnlLine."Entry Type"::"Positive Adjmt.";
            TempWhseJnlLine."Line No." := "Line No.";
            TempWhseJnlLine."Location Code" := "Location Code";
            TempWhseJnlLine."To Zone Code" := "Zone Code";
            TempWhseJnlLine."To Bin Code" := "Bin Code";
            TempWhseJnlLine."Item No." := "Item No.";
            TempWhseJnlLine.Description := Description;
            GetLocation("Location Code");
            IF Location."Directed Put-away and Pick" THEN BEGIN
                TempWhseJnlLine."Qty. (Absolute)" := Quantity;
                TempWhseJnlLine."Unit of Measure Code" := "Unit of Measure Code";
                TempWhseJnlLine."Qty. per Unit of Measure" := "Qty. per Unit of Measure";
                GetItemUnitOfMeasure2("Item No.", "Unit of Measure Code");
                TempWhseJnlLine.Cubage := ABS(TempWhseJnlLine."Qty. (Absolute)") * ItemUnitOfMeasure.Cubage;
                TempWhseJnlLine.Weight := ABS(TempWhseJnlLine."Qty. (Absolute)") * ItemUnitOfMeasure.Weight;
            END ELSE BEGIN
                TempWhseJnlLine."Qty. (Absolute)" := "Qty. (Base)";
                TempWhseJnlLine."Unit of Measure Code" := WMSMgt.GetBaseUOM("Item No.");
                TempWhseJnlLine."Qty. per Unit of Measure" := 1;
            END;

            TempWhseJnlLine."Qty. (Absolute, Base)" := "Qty. (Base)";
            TempWhseJnlLine."User ID" := USERID;
            TempWhseJnlLine."Variant Code" := "Variant Code";
            TempWhseJnlLine.SetSource("Source Type", "Source Subtype", "Source No.", "Source Line No.", 0);
            TempWhseJnlLine."Source Document" := "Source Document";
            SourceCodeSetup.GET;
            CASE "Source Document" OF
                "Source Document"::"Purchase Order":
                    BEGIN
                        TempWhseJnlLine."Source Code" := SourceCodeSetup.Purchases;
                        TempWhseJnlLine."Reference Document" :=
                          TempWhseJnlLine."Reference Document"::"Posted Rcpt.";
                    END;
                "Source Document"::"Sales Order":
                    BEGIN
                        TempWhseJnlLine."Source Code" := SourceCodeSetup.Sales;
                        TempWhseJnlLine."Reference Document" :=
                          TempWhseJnlLine."Reference Document"::"Posted Shipment";
                    END;
                "Source Document"::"Purchase Return Order":
                    BEGIN
                        TempWhseJnlLine."Source Code" := SourceCodeSetup.Purchases;
                        TempWhseJnlLine."Reference Document" :=
                          TempWhseJnlLine."Reference Document"::"Posted Rtrn. Shipment";
                    END;
                "Source Document"::"Sales Return Order":
                    BEGIN
                        TempWhseJnlLine."Source Code" := SourceCodeSetup.Sales;
                        TempWhseJnlLine."Reference Document" :=
                          TempWhseJnlLine."Reference Document"::"Posted Rtrn. Rcpt.";
                    END;
                "Source Document"::"Inbound Transfer":
                    BEGIN
                        TempWhseJnlLine."Source Code" := SourceCodeSetup.Transfer;
                        TempWhseJnlLine."Reference Document" :=
                          TempWhseJnlLine."Reference Document"::"Posted T. Receipt";
                    END;
            END;

            OnBeforeInsertTempWhseJnlLine(TempWhseJnlLine, PostedWhseRcptLine);

            //ItemTrackingMgt.CheckWhseItemTrkgSetup("Item No.", SNRequired, LNRequired, FALSE);
            ItemTrackingMgt.CheckWhseItemTrkgSetup("Item No.");
            IF SNRequired THEN
                TESTFIELD("Qty. per Unit of Measure", 1);

            WMSMgt.CheckWhseJnlLine(TempWhseJnlLine, 0, 0, FALSE);
            TempWhseJnlLine.INSERT;
        END;
    END;

    LOCAL PROCEDURE CreatePutAwayDoc(WhseRcptHeader: Record 7316);
    VAR
        WhseActivHeader: Record 5766;
        PostedWhseRcptLine: Record 7319;
        TempPostedWhseRcptLine: Record 7319 TEMPORARY;
        TempPostedWhseRcptLine2: Record 7319 TEMPORARY;
        WhseWkshLine: Record 7326;
        WhseSourceCreateDocument: Report 7305;
        ItemTrackingMgt: Codeunit 6500;
        ItemTrackingMgt1: Codeunit 51151;
        WhseSNRequired: Boolean;
        WhseLNRequired: Boolean;
        RemQtyToHandleBase: Decimal;
        IsHandled: Boolean;
    BEGIN
        PostedWhseRcptLine.SETRANGE("No.", WhseRcptHeader."Receiving No.");
        IF NOT PostedWhseRcptLine.FIND('-') THEN
            EXIT;

        REPEAT
            RemQtyToHandleBase := PostedWhseRcptLine."Qty. (Base)";
            IsHandled := FALSE;
            OnBeforeCreatePutAwayDoc(WhseRcptHeader, PostedWhseRcptLine, IsHandled);
            IF NOT IsHandled THEN BEGIN
                CreatePutAway.SetCrossDockValues(TRUE);

                //ItemTrackingMgt.CheckWhseItemTrkgSetup(PostedWhseRcptLine."Item No.", WhseSNRequired, WhseLNRequired, FALSE);
                ItemTrackingMgt.CheckWhseItemTrkgSetup(PostedWhseRcptLine."Item No.");
                IF WhseSNRequired OR WhseLNRequired THEN
                    ItemTrackingMgt1.InitItemTrkgForTempWkshLine(
                      WhseWkshLine."Whse. Document Type"::Receipt,
                      PostedWhseRcptLine."No.", PostedWhseRcptLine."Line No.",
                      PostedWhseRcptLine."Source Type", PostedWhseRcptLine."Source Subtype",
                      PostedWhseRcptLine."Source No.", PostedWhseRcptLine."Source Line No.", 0);

                ItemTrackingMgt.SplitPostedWhseRcptLine(PostedWhseRcptLine, TempPostedWhseRcptLine);

                TempPostedWhseRcptLine.RESET;
                IF TempPostedWhseRcptLine.FIND('-') THEN
                    REPEAT
                        TempPostedWhseRcptLine2 := TempPostedWhseRcptLine;
                        TempPostedWhseRcptLine2."Line No." := PostedWhseRcptLine."Line No.";
                        WhseSourceCreateDocument.SetQuantity(TempPostedWhseRcptLine2, DATABASE::"Posted Whse. Receipt Line", RemQtyToHandleBase);
                        CreatePutAway.RUN(TempPostedWhseRcptLine2);
                    UNTIL TempPostedWhseRcptLine.NEXT = 0;
            END;
        UNTIL PostedWhseRcptLine.NEXT = 0;

        IF GetFirstPutAwayDocument(WhseActivHeader) THEN
            REPEAT
                CreatePutAway.DeleteBlankBinContent(WhseActivHeader);
                CounterPutAways := CounterPutAways + 1;
            UNTIL NOT GetNextPutAwayDocument(WhseActivHeader);
    END;

    LOCAL PROCEDURE GetLocation(LocationCode: Code[10]);
    BEGIN
        IF LocationCode <> Location.Code THEN
            IF NOT Location.GET(LocationCode) THEN;
    END;

    LOCAL PROCEDURE GetItemUnitOfMeasure2(ItemNo: Code[20]; UOMCode: Code[10]);
    BEGIN
        IF (ItemUnitOfMeasure."Item No." <> ItemNo) OR
           (ItemUnitOfMeasure.Code <> UOMCode)
        THEN
            IF NOT ItemUnitOfMeasure.GET(ItemNo, UOMCode) THEN
                ItemUnitOfMeasure.INIT;
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterRun(VAR WarehouseReceiptLine: Record 7317);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeRun(VAR WarehouseReceiptLine: Record 7317);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterCheckWhseRcptLine(VAR WarehouseReceiptLine: Record 7317);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterFindWhseRcptLineForPurchLine(VAR WhseRcptLine: Record 7317; PurchaseLine: Record 39);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterFindWhseRcptLineForSalesLine(VAR WhseRcptLine: Record 7317; SalesLine: Record 37);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterFindWhseRcptLineForTransLine(VAR WhseRcptLine: Record 7317; TransferLine: Record 5741);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterPostUpdateWhseDocuments(VAR WarehouseReceiptHeader: Record 7316; VAR WhsePutAwayRequest: Record 7324);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforePostUpdateWhseRcptLine(VAR WarehouseReceiptLine: Record 7317; VAR WarehouseReceiptLineBuf: Record 7317; VAR DeleteWhseRcptLine: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforePostWhseJnlLine(VAR PostedWhseReceiptHeader: Record 7318; VAR PostedWhseReceiptLine: Record 7319; VAR WhseReceiptLine: Record 7317; VAR TempTrackingSpecification: Record 336 TEMPORARY; VAR IsHandled: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeRegisterWhseJnlLines(VAR TempWarehouseJournalLine: Record 7311 TEMPORARY; VAR PostedWhseReceiptHeader: Record 7318; VAR PostedWhseReceiptLine: Record 7319);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterPostUpdateWhseRcptLine(VAR WarehouseReceiptLine: Record 7317);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterPostWhseJnlLine(VAR WarehouseReceiptLine: Record 7317);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterInitPostedRcptLine(VAR WarehouseReceiptLine: Record 7317; VAR PostedWhseReceiptLine: Record 7319);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterInitSourceDocumentLines(VAR WhseReceiptLine: Record 7317);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterCheckWhseRcptLines(VAR WhseRcptHeader: Record 7316; VAR WhseRcptLine: Record 7317);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeCreatePutAwayDoc(VAR WarehouseReceiptHeader: Record 7316; VAR PostedWhseReceiptLine: Record 7319; VAR IsHandled: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforePurchLineModify(VAR PurchaseLine: Record 39; WhseRcptLine: Record 7317; VAR ModifyLine: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeSalesLineModify(VAR SalesLine: Record 37; WhseRcptLine: Record 7317; VAR ModifyLine: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeTransLineModify(VAR TransferLine: Record 5741; WhseRcptLine: Record 7317; VAR ModifyLine: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforePostSourceDocument(VAR WhseRcptLine: Record 7317; PurchaseHeader: Record 38; SalesHeader: Record 36; TransferHeader: Record 5740);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforePostUpdateWhseDocuments(VAR WhseRcptHeader: Record 7316);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforePostedWhseRcptHeaderInsert(VAR PostedWhseReceiptHeader: Record 7318; WarehouseReceiptHeader: Record 7316);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnCodeOnBeforeWhseRcptHeaderModify(VAR WarehouseReceiptHeader: Record 7316; WarehouseReceiptLine: Record 7317);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnInitSourceDocumentHeader(VAR WhseReceiptHeader: Record 7316; VAR WhseReceiptLine: Record 7317);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnInitSourceDocumentHeaderOnBeforePurchHeaderModify(VAR PurchaseHeader: Record 38; VAR WarehouseReceiptHeader: Record 7316; VAR ModifyHeader: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnInitSourceDocumentHeaderOnBeforeSalesHeaderModify(VAR SalesHeader: Record 36; VAR WarehouseReceiptHeader: Record 7316; VAR ModifyHeader: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnInitSourceDocumentHeaderOnBeforeTransHeaderModify(VAR TransferHeader: Record 5740; VAR WarehouseReceiptHeader: Record 7316; VAR ModifyHeader: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnInitSourceDocumentLines(VAR WhseReceiptLine: Record 7317);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnPostSourceDocument(VAR WhseReceiptHeader: Record 7316; VAR WhseReceiptLine: Record 7317);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeInsertTempWhseJnlLine(VAR TempWarehouseJournalLine: Record 7311 TEMPORARY; PostedWhseReceiptLine: Record 7319);
    BEGIN
    END;

    /* /*BEGIN
END.*/
}









