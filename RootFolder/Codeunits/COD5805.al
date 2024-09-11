Codeunit 51053 "Item Charge Assgnt. (Purch.) 1"
{


    Permissions = TableData 38 = r,
                TableData 39 = r,
                TableData 121 = r,
                TableData 5805 = imd,
                TableData 6651 = r;
    trigger OnRun()
    BEGIN
    END;

    VAR
        SuggestItemChargeMsg: TextConst ENU = 'Select how to distribute the assigned item charge when the document has more than one line of type Item.', ESP = 'Seleccione c¢mo desea distribuir el cargo de producto asignado si el documento tiene m s de una l¡nea del tipo Producto.';
        EquallyTok: TextConst ENU = 'Equally', ESP = 'Igualmente';
        ByAmountTok: TextConst ENU = 'By Amount', ESP = 'Por importe';
        ByWeightTok: TextConst ENU = 'By Weight', ESP = 'Por peso';
        ByVolumeTok: TextConst ENU = 'By Volume', ESP = 'Por volumen';
        ItemChargesNotAssignedErr: TextConst ENU = 'No item charges were assigned.', ESP = 'No se han asignado cargos de los art¡culos.';

    //[External]
    PROCEDURE InsertItemChargeAssgnt(ItemChargeAssgntPurch: Record 5805; ApplToDocType: Enum "Purchase Applies-to Document Type"; ApplToDocNo2: Code[20]; ApplToDocLineNo2: Integer; ItemNo2: Code[20]; Description2: Text[50]; VAR NextLineNo: Integer);
    BEGIN
        InsertItemChargeAssgntWithAssignValues(
          ItemChargeAssgntPurch, ApplToDocType, ApplToDocNo2, ApplToDocLineNo2, ItemNo2, Description2, 0, 0, NextLineNo);
    END;

    //[External]
    PROCEDURE InsertItemChargeAssgntWithAssignValues(FromItemChargeAssgntPurch: Record 5805; ApplToDocType: Enum "Purchase Applies-to Document Type"; FromApplToDocNo: Code[20]; FromApplToDocLineNo: Integer; FromItemNo: Code[20]; FromDescription: Text[50]; QtyToAssign: Decimal; AmountToAssign: Decimal; VAR NextLineNo: Integer);
    VAR
        ItemChargeAssgntPurch: Record 5805;
    BEGIN
        InsertItemChargeAssgntWithAssignValuesTo(
          FromItemChargeAssgntPurch, ApplToDocType, FromApplToDocNo, FromApplToDocLineNo, FromItemNo, FromDescription,
          QtyToAssign, AmountToAssign, NextLineNo, ItemChargeAssgntPurch);
    END;

    //[External]
    PROCEDURE InsertItemChargeAssgntWithAssignValuesTo(FromItemChargeAssgntPurch: Record 5805; ApplToDocType: Enum "Purchase Applies-to Document Type"; FromApplToDocNo: Code[20]; FromApplToDocLineNo: Integer; FromItemNo: Code[20]; FromDescription: Text[50]; QtyToAssign: Decimal; AmountToAssign: Decimal; VAR NextLineNo: Integer; VAR ItemChargeAssgntPurch: Record 5805);
    BEGIN
        NextLineNo := NextLineNo + 10000;

        ItemChargeAssgntPurch."Document No." := FromItemChargeAssgntPurch."Document No.";
        ItemChargeAssgntPurch."Document Type" := FromItemChargeAssgntPurch."Document Type";
        ItemChargeAssgntPurch."Document Line No." := FromItemChargeAssgntPurch."Document Line No.";
        ItemChargeAssgntPurch."Item Charge No." := FromItemChargeAssgntPurch."Item Charge No.";
        ItemChargeAssgntPurch."Line No." := NextLineNo;
        ItemChargeAssgntPurch."Applies-to Doc. No." := FromApplToDocNo;
        ItemChargeAssgntPurch."Applies-to Doc. Type" := ApplToDocType;
        ItemChargeAssgntPurch."Applies-to Doc. Line No." := FromApplToDocLineNo;
        ItemChargeAssgntPurch."Item No." := FromItemNo;
        ItemChargeAssgntPurch.Description := FromDescription;
        ItemChargeAssgntPurch."Unit Cost" := FromItemChargeAssgntPurch."Unit Cost";
        IF QtyToAssign <> 0 THEN BEGIN
            ItemChargeAssgntPurch."Amount to Assign" := AmountToAssign;
            ItemChargeAssgntPurch.VALIDATE("Qty. to Assign", QtyToAssign);
        END;
        OnBeforeInsertItemChargeAssgntWithAssignValues(ItemChargeAssgntPurch);
        ItemChargeAssgntPurch.INSERT;
    END;

    //[External]
    PROCEDURE Summarize(VAR TempToItemChargeAssignmentPurch: Record 5805 TEMPORARY; VAR ToItemChargeAssignmentPurch: Record 5805);
    BEGIN
        WITH TempToItemChargeAssignmentPurch DO BEGIN
            SETCURRENTKEY("Applies-to Doc. Type", "Applies-to Doc. No.", "Applies-to Doc. Line No.");
            IF FINDSET THEN
                REPEAT
                    IF ("Item Charge No." <> ToItemChargeAssignmentPurch."Item Charge No.") OR
                       ("Applies-to Doc. No." <> ToItemChargeAssignmentPurch."Applies-to Doc. No.") OR
                       ("Applies-to Doc. Line No." <> ToItemChargeAssignmentPurch."Applies-to Doc. Line No.")
                    THEN BEGIN
                        IF ToItemChargeAssignmentPurch."Line No." <> 0 THEN
                            ToItemChargeAssignmentPurch.INSERT;
                        ToItemChargeAssignmentPurch := TempToItemChargeAssignmentPurch;
                        ToItemChargeAssignmentPurch."Qty. to Assign" := 0;
                        ToItemChargeAssignmentPurch."Amount to Assign" := 0;
                    END;
                    ToItemChargeAssignmentPurch."Qty. to Assign" += "Qty. to Assign";
                    ToItemChargeAssignmentPurch."Amount to Assign" += "Amount to Assign";
                UNTIL NEXT = 0;
            IF ToItemChargeAssignmentPurch."Line No." <> 0 THEN
                ToItemChargeAssignmentPurch.INSERT;
        END;
    END;



    //[External]
    PROCEDURE CreateRcptChargeAssgnt(VAR FromPurchRcptLine: Record 121; ItemChargeAssgntPurch: Record 5805);
    VAR
        ItemChargeAssgntPurch2: Record 5805;
        NextLine: Integer;
    BEGIN
        FromPurchRcptLine.TESTFIELD("Work Center No.", '');
        NextLine := ItemChargeAssgntPurch."Line No.";
        ItemChargeAssgntPurch2.SETRANGE("Document Type", ItemChargeAssgntPurch."Document Type");
        ItemChargeAssgntPurch2.SETRANGE("Document No.", ItemChargeAssgntPurch."Document No.");
        ItemChargeAssgntPurch2.SETRANGE("Document Line No.", ItemChargeAssgntPurch."Document Line No.");
        ItemChargeAssgntPurch2.SETRANGE(
          "Applies-to Doc. Type", ItemChargeAssgntPurch2."Applies-to Doc. Type"::Receipt);
        REPEAT
            ItemChargeAssgntPurch2.SETRANGE("Applies-to Doc. No.", FromPurchRcptLine."Document No.");
            ItemChargeAssgntPurch2.SETRANGE("Applies-to Doc. Line No.", FromPurchRcptLine."Line No.");
            IF NOT ItemChargeAssgntPurch2.FINDFIRST THEN
                InsertItemChargeAssgnt(ItemChargeAssgntPurch, ItemChargeAssgntPurch2."Applies-to Doc. Type"::Receipt,
                  FromPurchRcptLine."Document No.", FromPurchRcptLine."Line No.",
                  FromPurchRcptLine."No.", FromPurchRcptLine.Description, NextLine);
        UNTIL FromPurchRcptLine.NEXT = 0;
    END;



    //[External]
    PROCEDURE SuggestAssgnt(PurchLine: Record 39; TotalQtyToAssign: Decimal; TotalAmtToAssign: Decimal);
    VAR
        ItemChargeAssgntPurch: Record 5805;
        Selection: Integer;
        SelectionTxt: Text;
        SuggestItemChargeMenuTxt: Text;
        SuggestItemChargeMessageTxt: Text;
    BEGIN
        WITH PurchLine DO BEGIN
            TESTFIELD("Qty. to Invoice");
            ItemChargeAssgntPurch.SETRANGE("Document Type", "Document Type");
            ItemChargeAssgntPurch.SETRANGE("Document No.", "Document No.");
            ItemChargeAssgntPurch.SETRANGE("Document Line No.", "Line No.");
        END;
        IF ItemChargeAssgntPurch.ISEMPTY THEN
            EXIT;

        ItemChargeAssgntPurch.SETFILTER("Applies-to Doc. Type", '<>%1', ItemChargeAssgntPurch."Applies-to Doc. Type"::"Transfer Receipt");

        Selection := 1;
        SuggestItemChargeMenuTxt :=
          STRSUBSTNO('%1,%2,%3,%4', AssignEquallyMenuText, AssignByAmountMenuText, AssignByWeightMenuText, AssignByVolumeMenuText);
        IF ItemChargeAssgntPurch.COUNT > 1 THEN BEGIN
            Selection := 2;
            SuggestItemChargeMessageTxt := SuggestItemChargeMsg;
            OnBeforeShowSuggestItemChargeAssignStrMenu(PurchLine, SuggestItemChargeMenuTxt, SuggestItemChargeMessageTxt, Selection);
            IF SuggestItemChargeMenuTxt = '' THEN
                EXIT;
            IF STRLEN(DELCHR(SuggestItemChargeMenuTxt, '=', DELCHR(SuggestItemChargeMenuTxt, '=', ','))) > 1 THEN
                Selection := STRMENU(SuggestItemChargeMenuTxt, Selection, SuggestItemChargeMessageTxt)
            ELSE
                Selection := 1;
        END;
        IF Selection = 0 THEN
            EXIT;

        SelectionTxt := SELECTSTR(Selection, SuggestItemChargeMenuTxt);
        AssignItemCharges(PurchLine, TotalQtyToAssign, TotalAmtToAssign, SelectionTxt);
    END;



    //[External]
    PROCEDURE AssignItemCharges(PurchLine: Record 39; TotalQtyToAssign: Decimal; TotalAmtToAssign: Decimal; SelectionTxt: Text);
    VAR
        Currency: Record 4;
        PurchHeader: Record 38;
        ItemChargeAssgntPurch: Record 5805;
        ItemChargesAssigned: Boolean;
    BEGIN
        PurchLine.TESTFIELD("Qty. to Invoice");
        PurchHeader.GET(PurchLine."Document Type", PurchLine."Document No.");

        IF NOT Currency.GET(PurchHeader."Currency Code") THEN
            Currency.InitRoundingPrecision;

        ItemChargeAssgntPurch.SETRANGE("Document Type", PurchLine."Document Type");
        ItemChargeAssgntPurch.SETRANGE("Document No.", PurchLine."Document No.");
        ItemChargeAssgntPurch.SETRANGE("Document Line No.", PurchLine."Line No.");
        IF ItemChargeAssgntPurch.FINDFIRST THEN
            CASE SelectionTxt OF
                AssignEquallyMenuText:
                    AssignEqually(ItemChargeAssgntPurch, Currency, TotalQtyToAssign, TotalAmtToAssign);
                AssignByAmountMenuText:
                    AssignByAmount(ItemChargeAssgntPurch, Currency, PurchHeader, TotalQtyToAssign, TotalAmtToAssign);
                AssignByWeightMenuText:
                    AssignByWeight(ItemChargeAssgntPurch, Currency, TotalQtyToAssign);
                AssignByVolumeMenuText:
                    AssignByVolume(ItemChargeAssgntPurch, Currency, TotalQtyToAssign);
                ELSE BEGIN
                    OnAssignItemCharges(
                      SelectionTxt, ItemChargeAssgntPurch, Currency, PurchHeader, TotalQtyToAssign, TotalAmtToAssign, ItemChargesAssigned);
                    IF NOT ItemChargesAssigned THEN
                        ERROR(ItemChargesNotAssignedErr);
                END;
            END;
    END;

    //[External]
    PROCEDURE AssignEquallyMenuText(): Text;
    BEGIN
        EXIT(EquallyTok)
    END;

    //[External]
    PROCEDURE AssignByAmountMenuText(): Text;
    BEGIN
        EXIT(ByAmountTok)
    END;

    //[External]
    PROCEDURE AssignByWeightMenuText(): Text;
    BEGIN
        EXIT(ByWeightTok)
    END;

    //[External]
    PROCEDURE AssignByVolumeMenuText(): Text;
    BEGIN
        EXIT(ByVolumeTok)
    END;

    LOCAL PROCEDURE AssignEqually(VAR ItemChargeAssgntPurch: Record 5805; Currency: Record 4; TotalQtyToAssign: Decimal; TotalAmtToAssign: Decimal);
    VAR
        TempItemChargeAssgntPurch: Record 5805 TEMPORARY;
        RemainingNumOfLines: Integer;
    BEGIN
        REPEAT
            IF NOT ItemChargeAssgntPurch.PurchLineInvoiced THEN BEGIN
                TempItemChargeAssgntPurch := ItemChargeAssgntPurch;
                TempItemChargeAssgntPurch.INSERT;
            END;
        UNTIL ItemChargeAssgntPurch.NEXT = 0;

        IF TempItemChargeAssgntPurch.FINDSET(TRUE) THEN BEGIN
            RemainingNumOfLines := TempItemChargeAssgntPurch.COUNT;
            REPEAT
                ItemChargeAssgntPurch.GET(
                  TempItemChargeAssgntPurch."Document Type",
                  TempItemChargeAssgntPurch."Document No.",
                  TempItemChargeAssgntPurch."Document Line No.",
                  TempItemChargeAssgntPurch."Line No.");
                ItemChargeAssgntPurch."Qty. to Assign" := ROUND(TotalQtyToAssign / RemainingNumOfLines, 0.00001);
                ItemChargeAssgntPurch."Amount to Assign" :=
                  ROUND(
                    ItemChargeAssgntPurch."Qty. to Assign" / TotalQtyToAssign * TotalAmtToAssign,
                    Currency."Amount Rounding Precision");
                TotalQtyToAssign -= ItemChargeAssgntPurch."Qty. to Assign";
                TotalAmtToAssign -= ItemChargeAssgntPurch."Amount to Assign";
                RemainingNumOfLines := RemainingNumOfLines - 1;
                OnAssignEquallyOnBeforeItemChargeAssignmentPurchModify(ItemChargeAssgntPurch);
                ItemChargeAssgntPurch.MODIFY;
            UNTIL TempItemChargeAssgntPurch.NEXT = 0;
        END;
        TempItemChargeAssgntPurch.DELETEALL;
    END;

    LOCAL PROCEDURE AssignByAmount(VAR ItemChargeAssgntPurch: Record 5805; Currency: Record 4; PurchHeader: Record 38; TotalQtyToAssign: Decimal; TotalAmtToAssign: Decimal);
    VAR
        TempItemChargeAssgntPurch: Record 5805 TEMPORARY;
        PurchLine: Record 39;
        PurchRcptLine: Record 121;
        CurrExchRate: Record 330;
        ReturnRcptLine: Record 6661;
        ReturnShptLine: Record 6651;
        SalesShptLine: Record 111;
        CurrencyCode: Code[10];
        TotalAppliesToDocLineAmount: Decimal;
    BEGIN
        REPEAT
            IF NOT ItemChargeAssgntPurch.PurchLineInvoiced THEN BEGIN
                TempItemChargeAssgntPurch := ItemChargeAssgntPurch;
                CASE ItemChargeAssgntPurch."Applies-to Doc. Type" OF
                    ItemChargeAssgntPurch."Applies-to Doc. Type"::Quote,
                    ItemChargeAssgntPurch."Applies-to Doc. Type"::Order,
                    ItemChargeAssgntPurch."Applies-to Doc. Type"::Invoice,
                    ItemChargeAssgntPurch."Applies-to Doc. Type"::"Return Order",
                    ItemChargeAssgntPurch."Applies-to Doc. Type"::"Credit Memo":
                        BEGIN
                            PurchLine.GET(
                              ItemChargeAssgntPurch."Applies-to Doc. Type",
                              ItemChargeAssgntPurch."Applies-to Doc. No.",
                              ItemChargeAssgntPurch."Applies-to Doc. Line No.");
                            TempItemChargeAssgntPurch."Applies-to Doc. Line Amount" :=
                              ABS(PurchLine."Line Amount");
                        END;
                    ItemChargeAssgntPurch."Applies-to Doc. Type"::Receipt:
                        BEGIN
                            PurchRcptLine.GET(
                              ItemChargeAssgntPurch."Applies-to Doc. No.",
                              ItemChargeAssgntPurch."Applies-to Doc. Line No.");
                            CurrencyCode := PurchRcptLine.GetCurrencyCodeFromHeader;
                            IF CurrencyCode = PurchHeader."Currency Code" THEN
                                TempItemChargeAssgntPurch."Applies-to Doc. Line Amount" :=
                                  ABS(PurchRcptLine."Item Charge Base Amount")
                            ELSE
                                TempItemChargeAssgntPurch."Applies-to Doc. Line Amount" :=
                                  CurrExchRate.ExchangeAmtFCYToFCY(
                                    PurchHeader."Posting Date", CurrencyCode, PurchHeader."Currency Code",
                                    ABS(PurchRcptLine."Item Charge Base Amount"));
                        END;
                    ItemChargeAssgntPurch."Applies-to Doc. Type"::"Return Shipment":
                        BEGIN
                            ReturnShptLine.GET(
                              ItemChargeAssgntPurch."Applies-to Doc. No.",
                              ItemChargeAssgntPurch."Applies-to Doc. Line No.");
                            CurrencyCode := ReturnShptLine.GetCurrencyCode;
                            IF CurrencyCode = PurchHeader."Currency Code" THEN
                                TempItemChargeAssgntPurch."Applies-to Doc. Line Amount" :=
                                  ABS(ReturnShptLine."Item Charge Base Amount")
                            ELSE
                                TempItemChargeAssgntPurch."Applies-to Doc. Line Amount" :=
                                  CurrExchRate.ExchangeAmtFCYToFCY(
                                    PurchHeader."Posting Date", CurrencyCode, PurchHeader."Currency Code",
                                    ABS(ReturnShptLine."Item Charge Base Amount"));
                        END;
                    ItemChargeAssgntPurch."Applies-to Doc. Type"::"Sales Shipment":
                        BEGIN
                            SalesShptLine.GET(
                              ItemChargeAssgntPurch."Applies-to Doc. No.",
                              ItemChargeAssgntPurch."Applies-to Doc. Line No.");
                            CurrencyCode := SalesShptLine.GetCurrencyCode;
                            IF CurrencyCode = PurchHeader."Currency Code" THEN
                                TempItemChargeAssgntPurch."Applies-to Doc. Line Amount" :=
                                  ABS(SalesShptLine."Item Charge Base Amount")
                            ELSE
                                TempItemChargeAssgntPurch."Applies-to Doc. Line Amount" :=
                                  CurrExchRate.ExchangeAmtFCYToFCY(
                                    PurchHeader."Posting Date", CurrencyCode, PurchHeader."Currency Code",
                                    ABS(SalesShptLine."Item Charge Base Amount"));
                        END;
                    ItemChargeAssgntPurch."Applies-to Doc. Type"::"Return Receipt":
                        BEGIN
                            ReturnRcptLine.GET(
                              ItemChargeAssgntPurch."Applies-to Doc. No.",
                              ItemChargeAssgntPurch."Applies-to Doc. Line No.");
                            CurrencyCode := ReturnRcptLine.GetCurrencyCode;
                            IF CurrencyCode = PurchHeader."Currency Code" THEN
                                TempItemChargeAssgntPurch."Applies-to Doc. Line Amount" :=
                                  ABS(ReturnRcptLine."Item Charge Base Amount")
                            ELSE
                                TempItemChargeAssgntPurch."Applies-to Doc. Line Amount" :=
                                  CurrExchRate.ExchangeAmtFCYToFCY(
                                    PurchHeader."Posting Date", CurrencyCode, PurchHeader."Currency Code",
                                    ABS(ReturnRcptLine."Item Charge Base Amount"));
                        END;
                END;
                IF TempItemChargeAssgntPurch."Applies-to Doc. Line Amount" <> 0 THEN
                    TempItemChargeAssgntPurch.INSERT
                ELSE BEGIN
                    ItemChargeAssgntPurch."Amount to Assign" := 0;
                    ItemChargeAssgntPurch."Qty. to Assign" := 0;
                    ItemChargeAssgntPurch.MODIFY;
                END;
                TotalAppliesToDocLineAmount += TempItemChargeAssgntPurch."Applies-to Doc. Line Amount";
            END;
        UNTIL ItemChargeAssgntPurch.NEXT = 0;

        IF TempItemChargeAssgntPurch.FINDSET(TRUE) THEN
            REPEAT
                ItemChargeAssgntPurch.GET(
                  TempItemChargeAssgntPurch."Document Type",
                  TempItemChargeAssgntPurch."Document No.",
                  TempItemChargeAssgntPurch."Document Line No.",
                  TempItemChargeAssgntPurch."Line No.");
                IF TotalQtyToAssign <> 0 THEN BEGIN
                    ItemChargeAssgntPurch."Qty. to Assign" :=
                      ROUND(
                        TempItemChargeAssgntPurch."Applies-to Doc. Line Amount" / TotalAppliesToDocLineAmount * TotalQtyToAssign,
                        0.00001);
                    ItemChargeAssgntPurch."Amount to Assign" :=
                      ROUND(
                        ItemChargeAssgntPurch."Qty. to Assign" / TotalQtyToAssign * TotalAmtToAssign,
                        Currency."Amount Rounding Precision");
                    TotalQtyToAssign -= ItemChargeAssgntPurch."Qty. to Assign";
                    TotalAmtToAssign -= ItemChargeAssgntPurch."Amount to Assign";
                    TotalAppliesToDocLineAmount -= TempItemChargeAssgntPurch."Applies-to Doc. Line Amount";
                    OnAssignByAmountOnBeforeItemChargeAssignmentPurchModify(ItemChargeAssgntPurch);
                    ItemChargeAssgntPurch.MODIFY;
                END;
            UNTIL TempItemChargeAssgntPurch.NEXT = 0;
        TempItemChargeAssgntPurch.DELETEALL;
    END;

    LOCAL PROCEDURE AssignByWeight(VAR ItemChargeAssgntPurch: Record 5805; Currency: Record 4; TotalQtyToAssign: Decimal);
    VAR
        TempItemChargeAssgntPurch: Record 5805 TEMPORARY;
        LineAray: ARRAY[3] OF Decimal;
        TotalGrossWeight: Decimal;
        QtyRemainder: Decimal;
        AmountRemainder: Decimal;
    BEGIN
        REPEAT
            IF NOT ItemChargeAssgntPurch.PurchLineInvoiced THEN BEGIN
                TempItemChargeAssgntPurch.INIT;
                TempItemChargeAssgntPurch := ItemChargeAssgntPurch;
                TempItemChargeAssgntPurch.INSERT;
                GetItemValues(TempItemChargeAssgntPurch, LineAray);
                TotalGrossWeight := TotalGrossWeight + (LineAray[2] * LineAray[1]);
            END;
        UNTIL ItemChargeAssgntPurch.NEXT = 0;

        IF TempItemChargeAssgntPurch.FINDSET(TRUE) THEN
            REPEAT
                GetItemValues(TempItemChargeAssgntPurch, LineAray);
                IF TotalGrossWeight <> 0 THEN
                    TempItemChargeAssgntPurch."Qty. to Assign" :=
                      (TotalQtyToAssign * LineAray[2] * LineAray[1]) / TotalGrossWeight + QtyRemainder
                ELSE
                    TempItemChargeAssgntPurch."Qty. to Assign" := 0;
                AssignPurchItemCharge(ItemChargeAssgntPurch, TempItemChargeAssgntPurch, Currency, QtyRemainder, AmountRemainder);
            UNTIL TempItemChargeAssgntPurch.NEXT = 0;
        TempItemChargeAssgntPurch.DELETEALL;
    END;

    LOCAL PROCEDURE AssignByVolume(VAR ItemChargeAssgntPurch: Record 5805; Currency: Record 4; TotalQtyToAssign: Decimal);
    VAR
        TempItemChargeAssgntPurch: Record 5805 TEMPORARY;
        LineAray: ARRAY[3] OF Decimal;
        TotalUnitVolume: Decimal;
        QtyRemainder: Decimal;
        AmountRemainder: Decimal;
    BEGIN
        REPEAT
            IF NOT ItemChargeAssgntPurch.PurchLineInvoiced THEN BEGIN
                TempItemChargeAssgntPurch.INIT;
                TempItemChargeAssgntPurch := ItemChargeAssgntPurch;
                TempItemChargeAssgntPurch.INSERT;
                GetItemValues(TempItemChargeAssgntPurch, LineAray);
                TotalUnitVolume := TotalUnitVolume + (LineAray[3] * LineAray[1]);
            END;
        UNTIL ItemChargeAssgntPurch.NEXT = 0;

        IF TempItemChargeAssgntPurch.FINDSET(TRUE) THEN
            REPEAT
                GetItemValues(TempItemChargeAssgntPurch, LineAray);
                IF TotalUnitVolume <> 0 THEN
                    TempItemChargeAssgntPurch."Qty. to Assign" :=
                      (TotalQtyToAssign * LineAray[3] * LineAray[1]) / TotalUnitVolume + QtyRemainder
                ELSE
                    TempItemChargeAssgntPurch."Qty. to Assign" := 0;
                AssignPurchItemCharge(ItemChargeAssgntPurch, TempItemChargeAssgntPurch, Currency, QtyRemainder, AmountRemainder);
            UNTIL TempItemChargeAssgntPurch.NEXT = 0;
        TempItemChargeAssgntPurch.DELETEALL;
    END;

    LOCAL PROCEDURE AssignPurchItemCharge(VAR ItemChargeAssgntPurch: Record 5805; ItemChargeAssgntPurch2: Record 5805; Currency: Record 4; VAR QtyRemainder: Decimal; VAR AmountRemainder: Decimal);
    BEGIN
        ItemChargeAssgntPurch.GET(
          ItemChargeAssgntPurch2."Document Type",
          ItemChargeAssgntPurch2."Document No.",
          ItemChargeAssgntPurch2."Document Line No.",
          ItemChargeAssgntPurch2."Line No.");
        ItemChargeAssgntPurch."Qty. to Assign" := ROUND(ItemChargeAssgntPurch2."Qty. to Assign", 0.00001);
        ItemChargeAssgntPurch."Amount to Assign" :=
          ItemChargeAssgntPurch."Qty. to Assign" * ItemChargeAssgntPurch."Unit Cost" + AmountRemainder;
        AmountRemainder := ItemChargeAssgntPurch."Amount to Assign" -
          ROUND(ItemChargeAssgntPurch."Amount to Assign", Currency."Amount Rounding Precision");
        QtyRemainder := ItemChargeAssgntPurch2."Qty. to Assign" - ItemChargeAssgntPurch."Qty. to Assign";
        ItemChargeAssgntPurch."Amount to Assign" :=
          ROUND(ItemChargeAssgntPurch."Amount to Assign", Currency."Amount Rounding Precision");
        ItemChargeAssgntPurch.MODIFY;
    END;

    //[External]
    PROCEDURE GetItemValues(TempItemChargeAssgntPurch: Record 5805 TEMPORARY; VAR DecimalArray: ARRAY[3] OF Decimal);
    VAR
        PurchLine: Record 39;
        PurchRcptLine: Record 121;
        ReturnShptLine: Record 6651;
        TransferRcptLine: Record 5747;
        SalesShptLine: Record 111;
        ReturnRcptLine: Record 6661;
    BEGIN
        CLEAR(DecimalArray);
        WITH TempItemChargeAssgntPurch DO
            CASE "Applies-to Doc. Type" OF
                "Applies-to Doc. Type"::Order,
                "Applies-to Doc. Type"::Invoice,
                "Applies-to Doc. Type"::"Return Order",
                "Applies-to Doc. Type"::"Credit Memo":
                    BEGIN
                        PurchLine.GET("Applies-to Doc. Type", "Applies-to Doc. No.", "Applies-to Doc. Line No.");
                        DecimalArray[1] := PurchLine.Quantity;
                        DecimalArray[2] := PurchLine."Gross Weight";
                        DecimalArray[3] := PurchLine."Unit Volume";
                    END;
                "Applies-to Doc. Type"::Receipt:
                    BEGIN
                        PurchRcptLine.GET("Applies-to Doc. No.", "Applies-to Doc. Line No.");
                        PurchRcptLine.Get("Applies-to Doc. No.", "Applies-to Doc. Line No.");
                        DecimalArray[1] := PurchRcptLine.Quantity;
                        DecimalArray[2] := PurchRcptLine."Gross Weight";
                        DecimalArray[3] := PurchRcptLine."Unit Volume";
                    END;
                "Applies-to Doc. Type"::"Return Receipt":
                    BEGIN
                        ReturnRcptLine.GET("Applies-to Doc. No.", "Applies-to Doc. Line No.");
                        DecimalArray[1] := ReturnRcptLine.Quantity;
                        DecimalArray[2] := ReturnRcptLine."Gross Weight";
                        DecimalArray[3] := ReturnRcptLine."Unit Volume";
                    END;
                "Applies-to Doc. Type"::"Return Shipment":
                    BEGIN
                        ReturnShptLine.GET("Applies-to Doc. No.", "Applies-to Doc. Line No.");
                        DecimalArray[1] := ReturnShptLine.Quantity;
                        DecimalArray[2] := ReturnShptLine."Gross Weight";
                        DecimalArray[3] := ReturnShptLine."Unit Volume";
                    END;
                "Applies-to Doc. Type"::"Transfer Receipt":
                    BEGIN
                        TransferRcptLine.GET("Applies-to Doc. No.", "Applies-to Doc. Line No.");
                        DecimalArray[1] := TransferRcptLine.Quantity;
                        DecimalArray[2] := TransferRcptLine."Gross Weight";
                        DecimalArray[3] := TransferRcptLine."Unit Volume";
                    END;
                "Applies-to Doc. Type"::"Sales Shipment":
                    BEGIN
                        SalesShptLine.GET("Applies-to Doc. No.", "Applies-to Doc. Line No.");
                        DecimalArray[1] := SalesShptLine.Quantity;
                        DecimalArray[2] := SalesShptLine."Gross Weight";
                        DecimalArray[3] := SalesShptLine."Unit Volume";
                    END;
            END;
    END;

    //[External]
    PROCEDURE SuggestAssgntFromLine(VAR FromItemChargeAssignmentPurch: Record 5805);
    VAR
        Currency: Record 4;
        PurchHeader: Record 38;
        ItemChargeAssignmentPurch: Record 5805;
        TempItemChargeAssgntPurch: Record 5805 TEMPORARY;
        TotalAmountToAssign: Decimal;
        TotalQtyToAssign: Decimal;
        ItemChargeAssgntLineAmt: Decimal;
        ItemChargeAssgntLineQty: Decimal;
    BEGIN
        WITH FromItemChargeAssignmentPurch DO BEGIN
            PurchHeader.GET("Document Type", "Document No.");
            IF NOT Currency.GET(PurchHeader."Currency Code") THEN
                Currency.InitRoundingPrecision;

            GetItemChargeAssgntLineAmounts(
              "Document Type", "Document No.", "Document Line No.",
              ItemChargeAssgntLineQty, ItemChargeAssgntLineAmt);

            IF NOT ItemChargeAssignmentPurch.GET("Document Type", "Document No.", "Document Line No.", "Line No.") THEN
                EXIT;

            ItemChargeAssignmentPurch."Qty. to Assign" := "Qty. to Assign";
            ItemChargeAssignmentPurch."Amount to Assign" := "Amount to Assign";
            ItemChargeAssignmentPurch.MODIFY;

            ItemChargeAssignmentPurch.SETRANGE("Document Type", "Document Type");
            ItemChargeAssignmentPurch.SETRANGE("Document No.", "Document No.");
            ItemChargeAssignmentPurch.SETRANGE("Document Line No.", "Document Line No.");
            ItemChargeAssignmentPurch.CALCSUMS("Qty. to Assign", "Amount to Assign");
            TotalQtyToAssign := ItemChargeAssignmentPurch."Qty. to Assign";
            TotalAmountToAssign := ItemChargeAssignmentPurch."Amount to Assign";

            IF TotalAmountToAssign = ItemChargeAssgntLineAmt THEN
                EXIT;

            IF TotalQtyToAssign = ItemChargeAssgntLineQty THEN BEGIN
                TotalAmountToAssign := ItemChargeAssgntLineAmt;
                ItemChargeAssignmentPurch.FINDSET;
                REPEAT
                    IF NOT ItemChargeAssignmentPurch.PurchLineInvoiced THEN BEGIN
                        TempItemChargeAssgntPurch := ItemChargeAssignmentPurch;
                        TempItemChargeAssgntPurch.INSERT;
                    END;
                UNTIL ItemChargeAssignmentPurch.NEXT = 0;

                IF TempItemChargeAssgntPurch.FINDSET THEN BEGIN
                    REPEAT
                        ItemChargeAssignmentPurch.GET(
                          TempItemChargeAssgntPurch."Document Type",
                          TempItemChargeAssgntPurch."Document No.",
                          TempItemChargeAssgntPurch."Document Line No.",
                          TempItemChargeAssgntPurch."Line No.");
                        IF TotalQtyToAssign <> 0 THEN BEGIN
                            ItemChargeAssignmentPurch."Amount to Assign" :=
                              ROUND(
                                ItemChargeAssignmentPurch."Qty. to Assign" / TotalQtyToAssign * TotalAmountToAssign,
                                Currency."Amount Rounding Precision");
                            TotalQtyToAssign -= ItemChargeAssignmentPurch."Qty. to Assign";
                            TotalAmountToAssign -= ItemChargeAssignmentPurch."Amount to Assign";
                            ItemChargeAssignmentPurch.MODIFY;
                        END;
                    UNTIL TempItemChargeAssgntPurch.NEXT = 0;
                END;
            END;

            ItemChargeAssignmentPurch.GET("Document Type", "Document No.", "Document Line No.", "Line No.");
        END;

        FromItemChargeAssignmentPurch := ItemChargeAssignmentPurch;
    END;

    LOCAL PROCEDURE GetItemChargeAssgntLineAmounts(DocumentType: Enum "Purchase Document Type"; DocumentNo: Code[20]; DocumentLineNo: Integer; VAR ItemChargeAssgntLineQty: Decimal; VAR ItemChargeAssgntLineAmt: Decimal);
    VAR
        PurchLine: Record 39;
        PurchHeader: Record 38;
        Currency: Record 4;
    BEGIN
        PurchHeader.GET(DocumentType, DocumentNo);
        IF NOT Currency.GET(PurchHeader."Currency Code") THEN
            Currency.InitRoundingPrecision;

        WITH PurchLine DO BEGIN
            GET(DocumentType, DocumentNo, DocumentLineNo);
            TESTFIELD(Type, Type::"Charge (Item)");
            TESTFIELD("No.");
            TESTFIELD(Quantity);

            IF ("Inv. Discount Amount" = 0) AND
               ("Line Discount Amount" = 0) AND
               (NOT PurchHeader."Prices Including VAT")
            THEN
                ItemChargeAssgntLineAmt := "Line Amount"
            ELSE
                IF PurchHeader."Prices Including VAT" THEN
                    ItemChargeAssgntLineAmt :=
                      ROUND(("Line Amount" - "Inv. Discount Amount") / (1 + "VAT %" / 100),
                        Currency."Amount Rounding Precision")
                ELSE
                    ItemChargeAssgntLineAmt := "Line Amount" - "Inv. Discount Amount";

            ItemChargeAssgntLineAmt :=
              ROUND(
                ItemChargeAssgntLineAmt * ("Qty. to Invoice" / Quantity),
                Currency."Amount Rounding Precision");
            ItemChargeAssgntLineQty := "Qty. to Invoice";
        END;
    END;



    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeInsertItemChargeAssgntWithAssignValues(VAR ItemChargeAssgntPurch: Record 5805);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeShowSuggestItemChargeAssignStrMenu(PurchLine: Record 39; VAR SuggestItemChargeMenuTxt: Text; VAR SuggestItemChargeMessageTxt: Text; VAR Selection: Integer);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAssignItemCharges(SelectionTxt: Text; VAR ItemChargeAssignmentPurch: Record 5805; Currency: Record 4; PurchaseHeader: Record 38; TotalQtyToAssign: Decimal; TotalAmtToAssign: Decimal; VAR ItemChargesAssigned: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAssignEquallyOnBeforeItemChargeAssignmentPurchModify(VAR ItemChargeAssignmentPurch: Record 5805);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAssignByAmountOnBeforeItemChargeAssignmentPurchModify(VAR ItemChargeAssignmentPurch: Record 5805);
    BEGIN
    END;

    /* /*BEGIN
END.*/
}





