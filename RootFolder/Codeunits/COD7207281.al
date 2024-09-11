Codeunit 7207281 "Copy Doc Measurement"
{


    trigger OnRun()
    BEGIN
    END;

    VAR
        Text000: TextConst ENU = 'Please enter a Document No.', ESP = 'Introduzca un n� documento.';
        Text001: TextConst ENU = '%1 %2 cannot be copied onto itself.', ESP = '%1 %2. No se puede copiar sobre si misma.';
        Text002: TextConst ENU = 'The existing lines for %1 %2 will be deleted.\\', ESP = 'Se eliminar�n las l�neas existentes para %1 %2.\\';
        Text003: TextConst ENU = 'Do you want to continue?', ESP = '�Confirma que desea continuar?';
        Text004: TextConst ENU = '"The document line(s) with a G/L account where direct posting is not allowed "', ESP = '"La/s l�nea/s del documento que tienen indicada una cuenta contable que no admite "';
        Text005: TextConst ENU = 'have not been copied to the new document by the Copy Document batch job.', ESP = 'registro directo, no se copian al nuevo documento.';
        Text006: TextConst ENU = 'NOTE: A Payment Discount was Granted by %1 %2', ESP = 'NOTA: Un descuento P.P. fue concedido %1 %2';
        Text007: TextConst ENU = 'Quote,Blanket Order,Order,Invoice,Credit Memo,Posted Shipment,Posted Invoice,Posted Credit Memo,Posted Return Receipt', ESP = 'Oferta,Pedido abierto,Pedido,Factura,Abono,Albar�n registrado,Factura registrada,Abono registrado,Recep. devol. regis.';
        Text008: TextConst ENU = 'There are no negative sales lines to move.', ESP = 'No hay l�neas ventas negativas para mover.';
        Text009: TextConst ENU = 'NOTE: A Payment Discount was Received by %1 %2', ESP = 'NOTA: Un descuento P.P. fue recibido por %1 %2';
        Text010: TextConst ENU = 'There are no negative purchase lines to move.', ESP = 'No hay l�neas compra negativas para mover.';
        Text011: TextConst ENU = 'Please enter a Vendor No.', ESP = 'Introduzca un n� proveedor';
        Text012: TextConst ENU = 'There are no sales lines to copy.', ESP = 'No hay l�neas venta para copiar.';
        CustCheckCreditLimit: Codeunit 312;
        ItemCheckAvail: Codeunit 311;
        TransferOldExtLines: Codeunit 379;
        SalesDocType: Option "Quote","Blanket Order","Order","Invoice","Return Order","Credit Memo","Posted Shipment","Posted Invoice","Posted Return Receipt","Posted Credit Memo";
        PurchDocType: Option "Quote","Blanket Order","Order","Invoice","Return Order","Credit Memo","Posted Receipt","Posted Invoice","Posted Return Shipment","Posted Credit Memo";
        IncludeHeader: Boolean;
        RecalculateLines: Boolean;
        MoveNegLines: Boolean;
        CreateToHeader: Boolean;
        HideDialog: Boolean;

    PROCEDURE SetProperties(NewIncludeHeader: Boolean; NewRecalculateLines: Boolean; NewMoveNegLines: Boolean; NewCreateToHeader: Boolean; NewHideDialog: Boolean);
    BEGIN
        IncludeHeader := NewIncludeHeader;
        RecalculateLines := NewRecalculateLines;
        MoveNegLines := NewMoveNegLines;
        CreateToHeader := NewCreateToHeader;
        HideDialog := NewHideDialog;
    END;

    PROCEDURE SalesHeaderDocType(DocType: Option): Integer;
    VAR
        SalesHeader: Record 36;
    BEGIN
        CASE DocType OF
            SalesDocType::Quote:
                EXIT(SalesHeader."Document Type"::Quote.AsInteger());
            SalesDocType::"Blanket Order":
                EXIT(SalesHeader."Document Type"::"Blanket Order".AsInteger());
            SalesDocType::Order:
                EXIT(SalesHeader."Document Type"::Order.AsInteger());
            SalesDocType::Invoice:
                EXIT(SalesHeader."Document Type"::Invoice.AsInteger());
            SalesDocType::"Return Order":
                EXIT(SalesHeader."Document Type"::"Return Order".AsInteger());
            SalesDocType::"Credit Memo":
                EXIT(SalesHeader."Document Type"::"Credit Memo".AsInteger());
        END;
    END;

    PROCEDURE PurchHeaderDocType(DocType: Option): Integer;
    VAR
        FromPurchHeader: Record 38;
    BEGIN
        CASE DocType OF
            PurchDocType::Quote:
                EXIT(FromPurchHeader."Document Type"::Quote.AsInteger());
            PurchDocType::"Blanket Order":
                EXIT(FromPurchHeader."Document Type"::"Blanket Order".AsInteger());
            PurchDocType::Order:
                EXIT(FromPurchHeader."Document Type"::Order.AsInteger());
            PurchDocType::Invoice:
                EXIT(FromPurchHeader."Document Type"::Invoice.AsInteger());
            PurchDocType::"Return Order":
                EXIT(FromPurchHeader."Document Type"::"Return Order".AsInteger());
            PurchDocType::"Credit Memo":
                EXIT(FromPurchHeader."Document Type"::"Credit Memo".AsInteger());
        END;
    END;

    PROCEDURE CopySalesDoc(FromDocType: Option; FromDocNo: Code[20]; VAR ToSalesHeader: Record 36);
    VAR
        SalesSetup: Record 311;
        ToSalesLine: Record 37;
        OldSalesHeader: Record 36;
        FromSalesHeader: Record 36;
        FromSalesLine: Record 37;
        FromSalesShptHeader: Record 110;
        FromSalesShptLine: Record 111;
        FromSalesInvHeader: Record 112;
        FromSalesInvLine: Record 113;
        FromReturnRcptHeader: Record 6660;
        FromReturnRcptLine: Record 6661;
        FromSalesCrMemoHeader: Record 114;
        FromSalesCrMemoLine: Record 115;
        CustLedgEntry: Record 21;
        NextLineNo: Integer;
        ItemChargeAssgntNextLineNo: Integer;
        LinesNotCopied: Integer;
        ApplFromItemEntry: Integer;
    BEGIN
        WITH ToSalesHeader DO BEGIN
            IF NOT CreateToHeader THEN BEGIN
                TESTFIELD(Status, Status::Open);
                IF FromDocNo = '' THEN
                    ERROR(Text000);
                FIND;
            END;
            TransferOldExtLines.ClearLineNumbers;
            CASE FromDocType OF
                SalesDocType::Quote,
                SalesDocType::"Blanket Order",
                SalesDocType::Order,
                SalesDocType::Invoice,
                SalesDocType::"Return Order",
                SalesDocType::"Credit Memo":
                    BEGIN
                        FromSalesHeader.GET(SalesHeaderDocType(FromDocType), FromDocNo);
                        IF MoveNegLines THEN
                            DeleteSalesLinesWithNegQty(FromSalesHeader, TRUE);
                        IF (FromSalesHeader."Document Type" = "Document Type") AND
                           (FromSalesHeader."No." = "No.")
                        THEN
                            ERROR(
                              Text001,
                              "Document Type", "No.");

                        IF "Document Type".AsInteger() <= "Document Type"::Invoice.AsInteger() THEN BEGIN
                            FromSalesHeader.CALCFIELDS("Amount Including VAT");
                            "Amount Including VAT" := FromSalesHeader."Amount Including VAT";
                            CustCheckCreditLimit.SalesHeaderCheck(ToSalesHeader);
                        END;
                        IF "Document Type" IN ["Document Type"::Order, "Document Type"::Invoice] THEN BEGIN
                            FromSalesLine.SETRANGE("Document Type", FromSalesHeader."Document Type");
                            FromSalesLine.SETRANGE("Document No.", FromSalesHeader."No.");
                            FromSalesLine.SETRANGE(Type, FromSalesLine.Type::Item);
                            FromSalesLine.SETFILTER("No.", '<>%1', '');
                            IF FromSalesLine.FINDFIRST THEN
                                REPEAT
                                    IF FromSalesLine.Quantity > 0 THEN BEGIN
                                        ToSalesLine."No." := FromSalesLine."No.";
                                        ToSalesLine."Variant Code" := FromSalesLine."Variant Code";
                                        ToSalesLine."Location Code" := FromSalesLine."Location Code";
                                        ToSalesLine."Bin Code" := FromSalesLine."Bin Code";
                                        ToSalesLine."Unit of Measure Code" := FromSalesLine."Unit of Measure Code";
                                        ToSalesLine."Qty. per Unit of Measure" := FromSalesLine."Qty. per Unit of Measure";
                                        ToSalesLine."Outstanding Quantity" := FromSalesLine.Quantity;
                                        CheckItemAvailable(ToSalesHeader, ToSalesLine);
                                    END;
                                UNTIL FromSalesLine.NEXT = 0;
                        END;
                        IF NOT IncludeHeader AND NOT RecalculateLines THEN BEGIN
                            FromSalesHeader.TESTFIELD("Sell-to Customer No.", "Sell-to Customer No.");
                            FromSalesHeader.TESTFIELD("Bill-to Customer No.", "Bill-to Customer No.");
                            FromSalesHeader.TESTFIELD("Customer Posting Group", "Customer Posting Group");
                            FromSalesHeader.TESTFIELD("Gen. Bus. Posting Group", "Gen. Bus. Posting Group");
                            FromSalesHeader.TESTFIELD("Currency Code", "Currency Code");
                            FromSalesHeader.TESTFIELD("Prices Including VAT", "Prices Including VAT");
                        END;
                    END;
                SalesDocType::"Posted Shipment":
                    BEGIN
                        FromSalesShptHeader.GET(FromDocNo);
                        IF "Document Type" IN ["Document Type"::Order, "Document Type"::Invoice] THEN BEGIN
                            FromSalesShptLine.SETRANGE("Document No.", FromSalesShptHeader."No.");
                            FromSalesShptLine.SETRANGE(Type, FromSalesShptLine.Type::Item);
                            FromSalesShptLine.SETFILTER("No.", '<>%1', '');
                            IF FromSalesShptLine.FINDSET(FALSE) THEN
                                REPEAT
                                    IF FromSalesShptLine.Quantity > 0 THEN BEGIN
                                        ToSalesLine."No." := FromSalesShptLine."No.";
                                        ToSalesLine."Variant Code" := FromSalesShptLine."Variant Code";
                                        ToSalesLine."Location Code" := FromSalesShptLine."Location Code";
                                        ToSalesLine."Bin Code" := FromSalesShptLine."Bin Code";
                                        ToSalesLine."Unit of Measure Code" := FromSalesShptLine."Unit of Measure Code";
                                        ToSalesLine."Qty. per Unit of Measure" := FromSalesShptLine."Qty. per Unit of Measure";
                                        ToSalesLine."Outstanding Quantity" := FromSalesShptLine.Quantity;
                                        CheckItemAvailable(ToSalesHeader, ToSalesLine);
                                    END;
                                UNTIL FromSalesShptLine.NEXT = 0;
                        END;
                        IF NOT IncludeHeader AND NOT RecalculateLines THEN BEGIN
                            FromSalesShptHeader.TESTFIELD("Sell-to Customer No.", "Sell-to Customer No.");
                            FromSalesShptHeader.TESTFIELD("Bill-to Customer No.", "Bill-to Customer No.");
                            FromSalesShptHeader.TESTFIELD("Customer Posting Group", "Customer Posting Group");
                            FromSalesShptHeader.TESTFIELD("Gen. Bus. Posting Group", "Gen. Bus. Posting Group");
                            FromSalesShptHeader.TESTFIELD("Currency Code", "Currency Code");
                            FromSalesShptHeader.TESTFIELD("Prices Including VAT", "Prices Including VAT");
                        END;
                    END;
                SalesDocType::"Posted Invoice":
                    BEGIN
                        FromSalesInvHeader.GET(FromDocNo);
                        WarnSalesInvoicePmtDisc(ToSalesHeader, FromSalesHeader, FromDocType, FromDocNo);
                        IF "Document Type".AsInteger() <= "Document Type"::Invoice.AsInteger() THEN BEGIN
                            FromSalesInvHeader.CALCFIELDS("Amount Including VAT");
                            "Amount Including VAT" := FromSalesInvHeader."Amount Including VAT";
                            CustCheckCreditLimit.SalesHeaderCheck(ToSalesHeader);
                        END;
                        IF "Document Type" IN ["Document Type"::Order, "Document Type"::Invoice] THEN BEGIN
                            FromSalesInvLine.SETRANGE("Document No.", FromSalesInvHeader."No.");
                            FromSalesInvLine.SETRANGE(Type, FromSalesInvLine.Type::Item);
                            FromSalesInvLine.SETFILTER("No.", '<>%1', '');
                            IF FromSalesInvLine.FINDSET(FALSE) THEN
                                REPEAT
                                    IF FromSalesInvLine.Quantity > 0 THEN BEGIN
                                        ToSalesLine."No." := FromSalesInvLine."No.";
                                        ToSalesLine."Variant Code" := FromSalesInvLine."Variant Code";
                                        ToSalesLine."Location Code" := FromSalesInvLine."Location Code";
                                        ToSalesLine."Bin Code" := FromSalesInvLine."Bin Code";
                                        ToSalesLine."Unit of Measure Code" := FromSalesInvLine."Unit of Measure Code";
                                        ToSalesLine."Qty. per Unit of Measure" := FromSalesInvLine."Qty. per Unit of Measure";
                                        ToSalesLine."Outstanding Quantity" := FromSalesInvLine.Quantity;
                                        CheckItemAvailable(ToSalesHeader, ToSalesLine);
                                    END;
                                UNTIL FromSalesInvLine.NEXT = 0;
                        END;
                        IF NOT IncludeHeader AND NOT RecalculateLines THEN BEGIN
                            FromSalesInvHeader.TESTFIELD("Sell-to Customer No.", "Sell-to Customer No.");
                            FromSalesInvHeader.TESTFIELD("Bill-to Customer No.", "Bill-to Customer No.");
                            FromSalesInvHeader.TESTFIELD("Customer Posting Group", "Customer Posting Group");
                            FromSalesInvHeader.TESTFIELD("Gen. Bus. Posting Group", "Gen. Bus. Posting Group");
                            FromSalesInvHeader.TESTFIELD("Currency Code", "Currency Code");
                            FromSalesInvHeader.TESTFIELD("Prices Including VAT", "Prices Including VAT");
                        END;
                    END;
                SalesDocType::"Posted Return Receipt":
                    BEGIN
                        FromReturnRcptHeader.GET(FromDocNo);
                        IF "Document Type" IN ["Document Type"::Order, "Document Type"::Invoice] THEN BEGIN
                            FromReturnRcptLine.SETRANGE("Document No.", FromReturnRcptHeader."No.");
                            FromReturnRcptLine.SETRANGE(Type, FromReturnRcptLine.Type::Item);
                            FromReturnRcptLine.SETFILTER("No.", '<>%1', '');
                            IF FromReturnRcptLine.FINDSET(FALSE) THEN
                                REPEAT
                                    IF FromReturnRcptLine.Quantity > 0 THEN BEGIN
                                        ToSalesLine."No." := FromReturnRcptLine."No.";
                                        ToSalesLine."Variant Code" := FromReturnRcptLine."Variant Code";
                                        ToSalesLine."Location Code" := FromReturnRcptLine."Location Code";
                                        ToSalesLine."Bin Code" := FromReturnRcptLine."Bin Code";
                                        ToSalesLine."Unit of Measure Code" := FromReturnRcptLine."Unit of Measure Code";
                                        ToSalesLine."Qty. per Unit of Measure" := FromReturnRcptLine."Qty. per Unit of Measure";
                                        ToSalesLine."Outstanding Quantity" := FromReturnRcptLine.Quantity;
                                        CheckItemAvailable(ToSalesHeader, ToSalesLine);
                                    END;
                                UNTIL FromReturnRcptLine.NEXT = 0;
                        END;
                        IF NOT IncludeHeader AND NOT RecalculateLines THEN BEGIN
                            FromReturnRcptHeader.TESTFIELD("Sell-to Customer No.", "Sell-to Customer No.");
                            FromReturnRcptHeader.TESTFIELD("Bill-to Customer No.", "Bill-to Customer No.");
                            FromReturnRcptHeader.TESTFIELD("Customer Posting Group", "Customer Posting Group");
                            FromReturnRcptHeader.TESTFIELD("Gen. Bus. Posting Group", "Gen. Bus. Posting Group");
                            FromReturnRcptHeader.TESTFIELD("Currency Code", "Currency Code");
                            FromReturnRcptHeader.TESTFIELD("Prices Including VAT", "Prices Including VAT");
                        END;
                    END;
                SalesDocType::"Posted Credit Memo":
                    BEGIN
                        FromSalesCrMemoHeader.GET(FromDocNo);
                        IF "Document Type".AsInteger() <= "Document Type"::Invoice.AsInteger() THEN BEGIN
                            FromSalesCrMemoHeader.CALCFIELDS("Amount Including VAT");
                            "Amount Including VAT" := FromSalesCrMemoHeader."Amount Including VAT";
                            CustCheckCreditLimit.SalesHeaderCheck(ToSalesHeader);
                        END;
                        IF "Document Type" IN ["Document Type"::Order, "Document Type"::Invoice] THEN BEGIN
                            FromSalesCrMemoLine.SETRANGE("Document No.", FromSalesCrMemoHeader."No.");
                            FromSalesCrMemoLine.SETRANGE(Type, FromSalesCrMemoLine.Type::Item);
                            FromSalesCrMemoLine.SETFILTER("No.", '<>%1', '');
                            IF FromSalesCrMemoLine.FINDSET(FALSE) THEN
                                REPEAT
                                    IF FromSalesCrMemoLine.Quantity > 0 THEN BEGIN
                                        ToSalesLine."No." := FromSalesCrMemoLine."No.";
                                        ToSalesLine."Variant Code" := FromSalesCrMemoLine."Variant Code";
                                        ToSalesLine."Location Code" := FromSalesCrMemoLine."Location Code";
                                        ToSalesLine."Bin Code" := FromSalesCrMemoLine."Bin Code";
                                        ToSalesLine."Unit of Measure Code" := FromSalesCrMemoLine."Unit of Measure Code";
                                        ToSalesLine."Qty. per Unit of Measure" := FromSalesCrMemoLine."Qty. per Unit of Measure";
                                        ToSalesLine."Outstanding Quantity" := FromSalesCrMemoLine.Quantity;
                                        CheckItemAvailable(ToSalesHeader, ToSalesLine);
                                    END;
                                UNTIL FromSalesCrMemoLine.NEXT = 0;
                        END;
                        IF NOT IncludeHeader AND NOT RecalculateLines THEN BEGIN
                            FromSalesCrMemoHeader.TESTFIELD("Sell-to Customer No.", "Sell-to Customer No.");
                            FromSalesCrMemoHeader.TESTFIELD("Bill-to Customer No.", "Bill-to Customer No.");
                            FromSalesCrMemoHeader.TESTFIELD("Customer Posting Group", "Customer Posting Group");
                            FromSalesCrMemoHeader.TESTFIELD("Gen. Bus. Posting Group", "Gen. Bus. Posting Group");
                            FromSalesCrMemoHeader.TESTFIELD("Currency Code", "Currency Code");
                            FromSalesCrMemoHeader.TESTFIELD("Prices Including VAT", "Prices Including VAT");
                        END;
                    END;
            END;

            ToSalesLine.LOCKTABLE;

            IF CreateToHeader THEN BEGIN
                INSERT(TRUE);
                ToSalesLine.SETRANGE("Document Type", "Document Type");
                ToSalesLine.SETRANGE("Document No.", "No.");
            END ELSE BEGIN
                ToSalesLine.SETRANGE("Document Type", "Document Type");
                ToSalesLine.SETRANGE("Document No.", "No.");
                IF IncludeHeader THEN BEGIN
                    IF ToSalesLine.FINDFIRST THEN BEGIN
                        COMMIT;
                        IF NOT
                           CONFIRM(
                             Text002 +
                             Text003, TRUE,
                             "Document Type", "No.")
                        THEN
                            EXIT;
                        ToSalesLine.DELETEALL(TRUE);
                    END;
                END;
            END;

            IF ToSalesLine.FINDLAST THEN
                NextLineNo := ToSalesLine."Line No."
            ELSE
                NextLineNo := 0;

            IF NOT RECORDLEVELLOCKING THEN
                LOCKTABLE(TRUE, TRUE);

            IF IncludeHeader THEN BEGIN
                OldSalesHeader := ToSalesHeader;
                CASE FromDocType OF
                    SalesDocType::Quote,
                    SalesDocType::"Blanket Order",
                    SalesDocType::Order,
                    SalesDocType::Invoice,
                    SalesDocType::"Return Order",
                    SalesDocType::"Credit Memo":
                        BEGIN
                            TRANSFERFIELDS(FromSalesHeader, FALSE);
                            IF FromDocType = SalesDocType::Quote THEN
                                IF OldSalesHeader."Posting Date" = 0D THEN
                                    "Posting Date" := WORKDATE
                                ELSE
                                    "Posting Date" := OldSalesHeader."Posting Date";
                            CopyFromSalesDocDimToHeader(ToSalesHeader, FromSalesHeader);
                        END;
                    SalesDocType::"Posted Shipment":
                        BEGIN
                            TRANSFERFIELDS(FromSalesShptHeader, FALSE);
                            CopyFromPstdSalesDocDimToHdr(
                              ToSalesHeader, FromDocType, FromSalesShptHeader, FromSalesInvHeader,
                              FromReturnRcptHeader, FromSalesCrMemoHeader);
                        END;
                    SalesDocType::"Posted Invoice":
                        BEGIN
                            TRANSFERFIELDS(FromSalesInvHeader, FALSE);
                            CopyFromPstdSalesDocDimToHdr(
                              ToSalesHeader, FromDocType, FromSalesShptHeader, FromSalesInvHeader,
                              FromReturnRcptHeader, FromSalesCrMemoHeader);
                        END;
                    SalesDocType::"Posted Return Receipt":
                        BEGIN
                            TRANSFERFIELDS(FromReturnRcptHeader, FALSE);
                            CopyFromPstdSalesDocDimToHdr(
                              ToSalesHeader, FromDocType, FromSalesShptHeader, FromSalesInvHeader,
                              FromReturnRcptHeader, FromSalesCrMemoHeader);
                        END;
                    SalesDocType::"Posted Credit Memo":
                        BEGIN
                            TRANSFERFIELDS(FromSalesCrMemoHeader, FALSE);
                            CopyFromPstdSalesDocDimToHdr(
                              ToSalesHeader, FromDocType, FromSalesShptHeader, FromSalesInvHeader,
                              FromReturnRcptHeader, FromSalesCrMemoHeader);
                        END;
                END;
                Status := Status::Open;
                "No. Series" := OldSalesHeader."No. Series";
                "Posting Description" := OldSalesHeader."Posting Description";
                "Posting No." := OldSalesHeader."Posting No.";
                "Posting No. Series" := OldSalesHeader."Posting No. Series";
                "Shipping No." := OldSalesHeader."Shipping No.";
                "Shipping No. Series" := OldSalesHeader."Shipping No. Series";
                "Return Receipt No." := OldSalesHeader."Return Receipt No.";
                "Return Receipt No. Series" := OldSalesHeader."Return Receipt No. Series";
                "No. Printed" := 0;
                IF ((FromDocType = SalesDocType::"Posted Invoice") AND
                    ("Document Type" IN ["Document Type"::"Return Order", "Document Type"::"Credit Memo"])) OR
                   ((FromDocType = SalesDocType::"Posted Credit Memo") AND
                    NOT ("Document Type" IN ["Document Type"::"Return Order", "Document Type"::"Credit Memo"]))
                THEN BEGIN
                    CustLedgEntry.SETCURRENTKEY("Document Type", "Document No.", "Customer No.");
                    IF FromDocType = SalesDocType::"Posted Invoice" THEN
                        CustLedgEntry.SETRANGE("Document Type", CustLedgEntry."Document Type"::Invoice)
                    ELSE
                        CustLedgEntry.SETRANGE("Document Type", CustLedgEntry."Document Type"::"Credit Memo");
                    CustLedgEntry.SETRANGE("Document No.", FromDocNo);
                    CustLedgEntry.SETRANGE("Customer No.", "Bill-to Customer No.");
                    CustLedgEntry.SETRANGE(Open, TRUE);
                    IF CustLedgEntry.FINDFIRST THEN
                        IF FromDocType = SalesDocType::"Posted Invoice" THEN BEGIN
                            "Applies-to Doc. Type" := "Applies-to Doc. Type"::Invoice;
                            "Applies-to Doc. No." := FromDocNo;
                        END ELSE BEGIN
                            "Applies-to Doc. Type" := "Applies-to Doc. Type"::"Credit Memo";
                            "Applies-to Doc. No." := FromDocNo;
                        END;
                END;
                IF "Document Type" IN ["Document Type"::"Return Order", "Document Type"::"Credit Memo"] THEN BEGIN
                    "Shipment Date" := 0D;
                    "Due Date" := 0D;
                    "Pmt. Discount Date" := 0D;
                END;
                IF CreateToHeader THEN BEGIN
                    VALIDATE("Payment Terms Code");
                    MODIFY(TRUE);
                END ELSE
                    MODIFY;
            END;

            LinesNotCopied := 0;
            CASE FromDocType OF
                SalesDocType::Quote,
                SalesDocType::"Blanket Order",
                SalesDocType::Order,
                SalesDocType::Invoice,
                SalesDocType::"Return Order",
                SalesDocType::"Credit Memo":
                    BEGIN
                        ItemChargeAssgntNextLineNo := 0;
                        FromSalesLine.RESET;
                        FromSalesLine.SETRANGE("Document Type", FromSalesHeader."Document Type");
                        FromSalesLine.SETRANGE("Document No.", FromSalesHeader."No.");
                        IF MoveNegLines THEN
                            FromSalesLine.SETFILTER(Quantity, '<=0');
                        IF FromSalesLine.FINDSET(FALSE) THEN
                            REPEAT
                                CopySalesLine(ToSalesHeader, ToSalesLine, FromSalesHeader, FromSalesLine, NextLineNo, LinesNotCopied, 0);
                                CopyFromSalesDocDimToLine(ToSalesLine, FromSalesLine);
                                IF FromSalesLine.Type = FromSalesLine.Type::"Charge (Item)" THEN
                                    CopyFromSalesDocAssgntToLine(ToSalesLine, FromSalesLine, ItemChargeAssgntNextLineNo);
                            UNTIL FromSalesLine.NEXT = 0;
                    END;
                SalesDocType::"Posted Shipment":
                    BEGIN
                        SalesSetup.GET;
                        FromSalesHeader.TRANSFERFIELDS(FromSalesShptHeader);
                        FromSalesShptLine.RESET;
                        FromSalesShptLine.SETRANGE("Document No.", FromSalesShptHeader."No.");
                        IF MoveNegLines THEN
                            FromSalesShptLine.SETFILTER(Quantity, '<=0');
                        IF FromSalesShptLine.FINDSET(FALSE) THEN
                            REPEAT
                                FromSalesLine.TRANSFERFIELDS(FromSalesShptLine);
                                IF SalesSetup."Exact Cost Reversing Mandatory" AND
                                   (FromSalesShptLine.Type = FromSalesShptLine.Type::Item) AND
                                   ("Document Type" IN ["Document Type"::"Return Order", "Document Type"::"Credit Memo"])
                                THEN
                                    ApplFromItemEntry := FromSalesShptLine."Item Shpt. Entry No."
                                ELSE
                                    ApplFromItemEntry := 0;
                                CopySalesLine(
                                  ToSalesHeader, ToSalesLine, FromSalesHeader, FromSalesLine,
                                  NextLineNo, LinesNotCopied, ApplFromItemEntry);
                                CopyFromPstdSalesDocDimToLine(
                                  ToSalesLine, FromDocType, FromSalesShptLine, FromSalesInvLine,
                                  FromReturnRcptLine, FromSalesCrMemoLine);
                            UNTIL FromSalesShptLine.NEXT = 0;
                    END;
                SalesDocType::"Posted Invoice":
                    BEGIN
                        FromSalesHeader.TRANSFERFIELDS(FromSalesInvHeader);
                        FromSalesInvLine.RESET;
                        FromSalesInvLine.SETRANGE("Document No.", FromSalesInvHeader."No.");
                        IF MoveNegLines THEN
                            FromSalesInvLine.SETFILTER(Quantity, '<=0');
                        IF FromSalesInvLine.FINDSET(FALSE) THEN
                            REPEAT
                                FromSalesLine.TRANSFERFIELDS(FromSalesInvLine);
                                CopySalesLine(ToSalesHeader, ToSalesLine, FromSalesHeader, FromSalesLine, NextLineNo, LinesNotCopied, 0);
                                CopyFromPstdSalesDocDimToLine(
                                  ToSalesLine, FromDocType, FromSalesShptLine, FromSalesInvLine,
                                  FromReturnRcptLine, FromSalesCrMemoLine);
                            UNTIL FromSalesInvLine.NEXT = 0;
                    END;
                SalesDocType::"Posted Return Receipt":
                    BEGIN
                        FromSalesHeader.TRANSFERFIELDS(FromReturnRcptHeader);
                        FromReturnRcptLine.RESET;
                        FromReturnRcptLine.SETRANGE("Document No.", FromReturnRcptHeader."No.");
                        IF MoveNegLines THEN
                            FromReturnRcptLine.SETFILTER(Quantity, '<=0');
                        IF FromReturnRcptLine.FINDSET(FALSE) THEN
                            REPEAT
                                FromSalesLine.TRANSFERFIELDS(FromReturnRcptLine);
                                CopySalesLine(ToSalesHeader, ToSalesLine, FromSalesHeader, FromSalesLine, NextLineNo, LinesNotCopied, 0);
                                CopyFromPstdSalesDocDimToLine(
                                  ToSalesLine, FromDocType, FromSalesShptLine, FromSalesInvLine,
                                  FromReturnRcptLine, FromSalesCrMemoLine);
                            UNTIL FromReturnRcptLine.NEXT = 0;
                    END;
                SalesDocType::"Posted Credit Memo":
                    BEGIN
                        FromSalesHeader.TRANSFERFIELDS(FromSalesCrMemoHeader);
                        FromSalesCrMemoLine.RESET;
                        FromSalesCrMemoLine.SETRANGE("Document No.", FromSalesCrMemoHeader."No.");
                        IF MoveNegLines THEN
                            FromSalesCrMemoLine.SETFILTER(Quantity, '<=0');
                        IF FromSalesCrMemoLine.FINDSET(FALSE) THEN
                            REPEAT
                                FromSalesLine.TRANSFERFIELDS(FromSalesCrMemoLine);
                                CopySalesLine(ToSalesHeader, ToSalesLine, FromSalesHeader, FromSalesLine, NextLineNo, LinesNotCopied, 0);
                                CopyFromPstdSalesDocDimToLine(
                                  ToSalesLine, FromDocType, FromSalesShptLine, FromSalesInvLine,
                                  FromReturnRcptLine, FromSalesCrMemoLine);
                            UNTIL FromSalesCrMemoLine.NEXT = 0;
                    END;
            END;
        END;

        IF MoveNegLines THEN
            DeleteSalesLinesWithNegQty(FromSalesHeader, FALSE);

        IF LinesNotCopied > 0 THEN
            MESSAGE(
              Text004 +
              Text005);
    END;

    PROCEDURE CopyPurchDoc(FromDocType: Option; FromDocNo: Code[20]; VAR ToPurchHeader: Record 38);
    VAR
        PurchSetup: Record 312;
        ToPurchLine: Record 39;
        OldPurchHeader: Record 38;
        FromPurchHeader: Record 38;
        FromPurchLine: Record 39;
        FromPurchRcptHeader: Record 120;
        FromPurchRcptLine: Record 121;
        FromPurchInvHeader: Record 122;
        FromPurchInvLine: Record 123;
        FromReturnShptHeader: Record 6650;
        FromReturnShptLine: Record 6651;
        FromPurchCrMemoHeader: Record 124;
        FromPurchCrMemoLine: Record 125;
        VendLedgEntry: Record 25;
        NextLineNo: Integer;
        ItemChargeAssgntNextLineNo: Integer;
        LinesNotCopied: Integer;
        ApplToItemEntry: Integer;
    BEGIN
        WITH ToPurchHeader DO BEGIN
            IF NOT CreateToHeader THEN BEGIN
                TESTFIELD(Status, Status::Open);
                IF FromDocNo = '' THEN
                    ERROR(Text000);
                FIND;
            END;
            TransferOldExtLines.ClearLineNumbers;
            CASE FromDocType OF
                PurchDocType::Quote,
                PurchDocType::"Blanket Order",
                PurchDocType::Order,
                PurchDocType::Invoice,
                PurchDocType::"Return Order",
                PurchDocType::"Credit Memo":
                    BEGIN
                        FromPurchHeader.GET(PurchHeaderDocType(FromDocType), FromDocNo);
                        IF MoveNegLines THEN
                            DeletePurchLinesWithNegQty(FromPurchHeader, TRUE);
                        IF (FromPurchHeader."Document Type" = "Document Type") AND
                           (FromPurchHeader."No." = "No.")
                        THEN
                            ERROR(
                              Text001,
                              "Document Type", "No.");
                        IF NOT IncludeHeader AND NOT RecalculateLines THEN BEGIN
                            FromPurchHeader.TESTFIELD("Buy-from Vendor No.", "Buy-from Vendor No.");
                            FromPurchHeader.TESTFIELD("Pay-to Vendor No.", "Pay-to Vendor No.");
                            FromPurchHeader.TESTFIELD("Vendor Posting Group", "Vendor Posting Group");
                            FromPurchHeader.TESTFIELD("Gen. Bus. Posting Group", "Gen. Bus. Posting Group");
                            FromPurchHeader.TESTFIELD("Currency Code", "Currency Code");
                        END;
                    END;
                PurchDocType::"Posted Receipt":
                    BEGIN
                        FromPurchRcptHeader.GET(FromDocNo);
                        IF NOT IncludeHeader AND NOT RecalculateLines THEN BEGIN
                            FromPurchRcptHeader.TESTFIELD("Buy-from Vendor No.", "Buy-from Vendor No.");
                            FromPurchRcptHeader.TESTFIELD("Pay-to Vendor No.", "Pay-to Vendor No.");
                            FromPurchRcptHeader.TESTFIELD("Vendor Posting Group", "Vendor Posting Group");
                            FromPurchRcptHeader.TESTFIELD("Gen. Bus. Posting Group", "Gen. Bus. Posting Group");
                            FromPurchRcptHeader.TESTFIELD("Currency Code", "Currency Code");
                        END;
                    END;
                PurchDocType::"Posted Invoice":
                    BEGIN
                        FromPurchInvHeader.GET(FromDocNo);
                        WarnPurchInvoicePmtDisc(ToPurchHeader, FromPurchHeader, FromDocType, FromDocNo);
                        IF NOT IncludeHeader AND NOT RecalculateLines THEN BEGIN
                            FromPurchInvHeader.TESTFIELD("Buy-from Vendor No.", "Buy-from Vendor No.");
                            FromPurchInvHeader.TESTFIELD("Pay-to Vendor No.", "Pay-to Vendor No.");
                            FromPurchInvHeader.TESTFIELD("Vendor Posting Group", "Vendor Posting Group");
                            FromPurchInvHeader.TESTFIELD("Gen. Bus. Posting Group", "Gen. Bus. Posting Group");
                            FromPurchInvHeader.TESTFIELD("Currency Code", "Currency Code");
                        END;
                    END;
                PurchDocType::"Posted Return Shipment":
                    BEGIN
                        FromReturnShptHeader.GET(FromDocNo);
                        IF NOT IncludeHeader AND NOT RecalculateLines THEN BEGIN
                            FromReturnShptHeader.TESTFIELD("Buy-from Vendor No.", "Buy-from Vendor No.");
                            FromReturnShptHeader.TESTFIELD("Pay-to Vendor No.", "Pay-to Vendor No.");
                            FromReturnShptHeader.TESTFIELD("Vendor Posting Group", "Vendor Posting Group");
                            FromReturnShptHeader.TESTFIELD("Gen. Bus. Posting Group", "Gen. Bus. Posting Group");
                            FromReturnShptHeader.TESTFIELD("Currency Code", "Currency Code");
                        END;
                    END;
                PurchDocType::"Posted Credit Memo":
                    BEGIN
                        FromPurchCrMemoHeader.GET(FromDocNo);
                        IF NOT IncludeHeader AND NOT RecalculateLines THEN BEGIN
                            FromPurchCrMemoHeader.TESTFIELD("Buy-from Vendor No.", "Buy-from Vendor No.");
                            FromPurchCrMemoHeader.TESTFIELD("Pay-to Vendor No.", "Pay-to Vendor No.");
                            FromPurchCrMemoHeader.TESTFIELD("Vendor Posting Group", "Vendor Posting Group");
                            FromPurchCrMemoHeader.TESTFIELD("Gen. Bus. Posting Group", "Gen. Bus. Posting Group");
                            FromPurchCrMemoHeader.TESTFIELD("Currency Code", "Currency Code");
                        END;
                    END;
            END;

            ToPurchLine.LOCKTABLE;

            IF CreateToHeader THEN BEGIN
                INSERT(TRUE);
                ToPurchLine.SETRANGE("Document Type", "Document Type");
                ToPurchLine.SETRANGE("Document No.", "No.");
            END ELSE BEGIN
                ToPurchLine.SETRANGE("Document Type", "Document Type");
                ToPurchLine.SETRANGE("Document No.", "No.");
                IF IncludeHeader THEN BEGIN
                    IF ToPurchLine.FINDFIRST THEN BEGIN
                        COMMIT;
                        IF NOT
                           CONFIRM(
                             Text002 +
                             Text003, TRUE,
                             "Document Type", "No.")
                        THEN
                            EXIT;
                        ToPurchLine.DELETEALL(TRUE);
                    END;
                END;
            END;

            IF ToPurchLine.FINDLAST THEN
                NextLineNo := ToPurchLine."Line No."
            ELSE
                NextLineNo := 0;

            IF NOT RECORDLEVELLOCKING THEN
                LOCKTABLE(TRUE, TRUE);

            IF IncludeHeader THEN BEGIN
                OldPurchHeader := ToPurchHeader;
                CASE FromDocType OF
                    PurchDocType::Quote,
                    PurchDocType::"Blanket Order",
                    PurchDocType::Order,
                    PurchDocType::Invoice,
                    PurchDocType::"Return Order",
                    PurchDocType::"Credit Memo":
                        BEGIN
                            TRANSFERFIELDS(FromPurchHeader, FALSE);
                            IF FromDocType = PurchDocType::Quote THEN
                                IF OldPurchHeader."Posting Date" = 0D THEN
                                    "Posting Date" := WORKDATE
                                ELSE
                                    "Posting Date" := OldPurchHeader."Posting Date";
                            CopyFromPurchDocDimToHeader(ToPurchHeader, FromPurchHeader);
                        END;
                    PurchDocType::"Posted Receipt":
                        BEGIN
                            TRANSFERFIELDS(FromPurchRcptHeader, FALSE);
                            CopyFromPstdPurchDocDimToHdr(
                              ToPurchHeader, FromDocType, FromPurchRcptHeader, FromPurchInvHeader,
                              FromReturnShptHeader, FromPurchCrMemoHeader);
                        END;
                    PurchDocType::"Posted Invoice":
                        BEGIN
                            TRANSFERFIELDS(FromPurchInvHeader, FALSE);
                            CopyFromPstdPurchDocDimToHdr(
                              ToPurchHeader, FromDocType, FromPurchRcptHeader, FromPurchInvHeader,
                              FromReturnShptHeader, FromPurchCrMemoHeader);
                        END;
                    PurchDocType::"Posted Return Shipment":
                        BEGIN
                            TRANSFERFIELDS(FromReturnShptHeader, FALSE);
                            CopyFromPstdPurchDocDimToHdr(
                              ToPurchHeader, FromDocType, FromPurchRcptHeader, FromPurchInvHeader,
                              FromReturnShptHeader, FromPurchCrMemoHeader);
                        END;
                    PurchDocType::"Posted Credit Memo":
                        BEGIN
                            TRANSFERFIELDS(FromPurchCrMemoHeader, FALSE);
                            CopyFromPstdPurchDocDimToHdr(
                              ToPurchHeader, FromDocType, FromPurchRcptHeader, FromPurchInvHeader,
                              FromReturnShptHeader, FromPurchCrMemoHeader);
                        END;
                END;
                Status := Status::Open;
                "No. Series" := OldPurchHeader."No. Series";
                "Posting Description" := OldPurchHeader."Posting Description";
                "Posting No." := OldPurchHeader."Posting No.";
                "Posting No. Series" := OldPurchHeader."Posting No. Series";
                "Receiving No." := OldPurchHeader."Receiving No.";
                "Receiving No. Series" := OldPurchHeader."Receiving No. Series";
                "Return Shipment No." := OldPurchHeader."Return Shipment No.";
                "Return Shipment No. Series" := OldPurchHeader."Return Shipment No. Series";
                "No. Printed" := 0;
                IF ((FromDocType = PurchDocType::"Posted Invoice") AND
                   ("Document Type" IN ["Document Type"::"Return Order", "Document Type"::"Credit Memo"])) OR
                   ((FromDocType = PurchDocType::"Posted Credit Memo") AND
                   NOT ("Document Type" IN ["Document Type"::"Return Order", "Document Type"::"Credit Memo"]))
                THEN BEGIN
                    VendLedgEntry.SETCURRENTKEY("Document Type", "Document No.", "Vendor No.");
                    IF FromDocType = PurchDocType::"Posted Invoice" THEN
                        VendLedgEntry.SETRANGE("Document Type", VendLedgEntry."Document Type"::Invoice)
                    ELSE
                        VendLedgEntry.SETRANGE("Document Type", VendLedgEntry."Document Type"::"Credit Memo");
                    VendLedgEntry.SETRANGE("Document No.", FromDocNo);
                    VendLedgEntry.SETRANGE("Vendor No.", "Pay-to Vendor No.");
                    VendLedgEntry.SETRANGE(Open, TRUE);
                    IF VendLedgEntry.FINDFIRST THEN
                        IF FromDocType = PurchDocType::"Posted Invoice" THEN BEGIN
                            "Applies-to Doc. Type" := "Applies-to Doc. Type"::Invoice;
                            "Applies-to Doc. No." := FromDocNo;
                        END ELSE BEGIN
                            "Applies-to Doc. Type" := "Applies-to Doc. Type"::"Credit Memo";
                            "Applies-to Doc. No." := FromDocNo;
                        END;
                END;
                IF "Document Type" IN ["Document Type"::"Return Order", "Document Type"::"Credit Memo"] THEN BEGIN
                    "Expected Receipt Date" := 0D;
                    "Due Date" := 0D;
                    "Pmt. Discount Date" := 0D;
                END;
                IF CreateToHeader THEN BEGIN
                    VALIDATE("Payment Terms Code");
                    MODIFY(TRUE);
                END ELSE
                    MODIFY;
            END;

            LinesNotCopied := 0;
            CASE FromDocType OF
                PurchDocType::Quote,
                PurchDocType::"Blanket Order",
                PurchDocType::Order,
                PurchDocType::Invoice,
                PurchDocType::"Return Order",
                PurchDocType::"Credit Memo":
                    BEGIN
                        ItemChargeAssgntNextLineNo := 0;
                        FromPurchLine.RESET;
                        FromPurchLine.SETRANGE("Document Type", FromPurchHeader."Document Type");
                        FromPurchLine.SETRANGE("Document No.", FromPurchHeader."No.");
                        IF MoveNegLines THEN
                            FromPurchLine.SETFILTER(Quantity, '<=0');
                        IF FromPurchLine.FINDSET(FALSE) THEN
                            REPEAT
                                CopyPurchLine(
                                  ToPurchHeader, ToPurchLine, FromPurchHeader, FromPurchLine,
                                  NextLineNo, LinesNotCopied, 0);
                                CopyFromPurchDocDimToLine(ToPurchLine, FromPurchLine);
                                IF FromPurchLine.Type = FromPurchLine.Type::"Charge (Item)" THEN
                                    CopyFromPurchDocAssgntToLine(ToPurchLine, FromPurchLine, ItemChargeAssgntNextLineNo);
                            UNTIL FromPurchLine.NEXT = 0;
                    END;
                PurchDocType::"Posted Receipt":
                    BEGIN
                        PurchSetup.GET;
                        FromPurchHeader.TRANSFERFIELDS(FromPurchRcptHeader);
                        FromPurchRcptLine.RESET;
                        FromPurchRcptLine.SETRANGE("Document No.", FromPurchRcptHeader."No.");
                        IF MoveNegLines THEN
                            FromPurchRcptLine.SETFILTER(Quantity, '<=0');
                        IF FromPurchRcptLine.FINDSET(FALSE) THEN
                            REPEAT
                                FromPurchLine.TRANSFERFIELDS(FromPurchRcptLine);
                                IF PurchSetup."Exact Cost Reversing Mandatory" AND
                                   (FromPurchRcptLine.Type = FromPurchRcptLine.Type::Item) AND
                                   ("Document Type" IN ["Document Type"::"Return Order", "Document Type"::"Credit Memo"])
                                THEN
                                    ApplToItemEntry := FromPurchRcptLine."Item Rcpt. Entry No."
                                ELSE
                                    ApplToItemEntry := 0;
                                CopyPurchLine(
                                  ToPurchHeader, ToPurchLine, FromPurchHeader, FromPurchLine,
                                  NextLineNo, LinesNotCopied, ApplToItemEntry);
                                CopyFromPstdPurchDocDimToLine(
                                  ToPurchLine, FromDocType, FromPurchRcptLine, FromPurchInvLine,
                                  FromReturnShptLine, FromPurchCrMemoLine);
                            UNTIL FromPurchRcptLine.NEXT = 0;
                    END;
                PurchDocType::"Posted Invoice":
                    BEGIN
                        FromPurchHeader.TRANSFERFIELDS(FromPurchInvHeader);
                        FromPurchInvLine.RESET;
                        FromPurchInvLine.SETRANGE("Document No.", FromPurchInvHeader."No.");
                        IF MoveNegLines THEN
                            FromPurchInvLine.SETFILTER(Quantity, '<=0');
                        IF FromPurchInvLine.FINDSET(FALSE) THEN
                            REPEAT
                                FromPurchLine.TRANSFERFIELDS(FromPurchInvLine);
                                CopyPurchLine(
                                  ToPurchHeader, ToPurchLine, FromPurchHeader, FromPurchLine,
                                  NextLineNo, LinesNotCopied, 0);
                                CopyFromPstdPurchDocDimToLine(
                                  ToPurchLine, FromDocType, FromPurchRcptLine, FromPurchInvLine,
                                  FromReturnShptLine, FromPurchCrMemoLine);
                            UNTIL FromPurchInvLine.NEXT = 0;
                    END;
                PurchDocType::"Posted Return Shipment":
                    BEGIN
                        FromPurchHeader.TRANSFERFIELDS(FromReturnShptHeader);
                        FromReturnShptLine.RESET;
                        FromReturnShptLine.SETRANGE("Document No.", FromReturnShptHeader."No.");
                        IF MoveNegLines THEN
                            FromReturnShptLine.SETFILTER(Quantity, '<=0');
                        IF FromReturnShptLine.FINDSET(FALSE) THEN
                            REPEAT
                                FromPurchLine.TRANSFERFIELDS(FromReturnShptLine);
                                CopyPurchLine(
                                  ToPurchHeader, ToPurchLine, FromPurchHeader, FromPurchLine,
                                  NextLineNo, LinesNotCopied, 0);
                                CopyFromPstdPurchDocDimToLine(
                                  ToPurchLine, FromDocType, FromPurchRcptLine, FromPurchInvLine,
                                  FromReturnShptLine, FromPurchCrMemoLine);
                            UNTIL FromReturnShptLine.NEXT = 0;
                    END;
                PurchDocType::"Posted Credit Memo":
                    BEGIN
                        FromPurchHeader.TRANSFERFIELDS(FromPurchCrMemoHeader);
                        FromPurchCrMemoLine.RESET;
                        FromPurchCrMemoLine.SETRANGE("Document No.", FromPurchCrMemoHeader."No.");
                        IF MoveNegLines THEN
                            FromPurchCrMemoLine.SETFILTER(Quantity, '<=0');
                        IF FromPurchCrMemoLine.FINDSET(FALSE) THEN
                            REPEAT
                                FromPurchLine.TRANSFERFIELDS(FromPurchCrMemoLine);
                                CopyPurchLine(
                                  ToPurchHeader, ToPurchLine, FromPurchHeader, FromPurchLine,
                                  NextLineNo, LinesNotCopied, 0);
                                CopyFromPstdPurchDocDimToLine(
                                  ToPurchLine, FromDocType, FromPurchRcptLine, FromPurchInvLine,
                                  FromReturnShptLine, FromPurchCrMemoLine);
                            UNTIL FromPurchCrMemoLine.NEXT = 0;
                    END;
            END;
        END;

        IF MoveNegLines THEN
            DeletePurchLinesWithNegQty(FromPurchHeader, FALSE);

        IF LinesNotCopied > 0 THEN
            MESSAGE(
              Text004 +
              Text005);
    END;

    PROCEDURE ShowSalesDoc(ToSalesHeader: Record 36);
    BEGIN
        WITH ToSalesHeader DO BEGIN
            CASE "Document Type" OF
                "Document Type"::Order:
                    PAGE.RUN(PAGE::"Sales Order", ToSalesHeader);
                "Document Type"::Invoice:
                    PAGE.RUN(PAGE::"Sales Invoice", ToSalesHeader);
                "Document Type"::"Return Order":
                    PAGE.RUN(PAGE::"Sales Return Order", ToSalesHeader);
                "Document Type"::"Credit Memo":
                    PAGE.RUN(PAGE::"Sales Credit Memo", ToSalesHeader);
            END;
        END;
    END;

    PROCEDURE ShowPurchDoc(ToPurchHeader: Record 38);
    BEGIN
        WITH ToPurchHeader DO BEGIN
            CASE "Document Type" OF
                "Document Type"::Order:
                    PAGE.RUN(PAGE::"Purchase Order", ToPurchHeader);
                "Document Type"::Invoice:
                    PAGE.RUN(PAGE::"Purchase Invoice", ToPurchHeader);
                "Document Type"::"Return Order":
                    PAGE.RUN(PAGE::"Purchase Return Order", ToPurchHeader);
                "Document Type"::"Credit Memo":
                    PAGE.RUN(PAGE::"Purchase Credit Memo", ToPurchHeader);
            END;
        END;
    END;

    PROCEDURE CopyFromSalesToPurchDoc(VendorNo: Code[20]; FromSalesHeader: Record 36; VAR ToPurchHeader: Record 38);
    VAR
        FromSalesLine: Record 37;
        ToPurchLine: Record 39;
        NextLineNo: Integer;
    BEGIN
        IF VendorNo = '' THEN
            ERROR(Text011);

        WITH ToPurchLine DO BEGIN
            LOCKTABLE;
            ToPurchHeader.INSERT(TRUE);
            ToPurchHeader.VALIDATE("Buy-from Vendor No.", VendorNo);
            ToPurchHeader.MODIFY(TRUE);
            FromSalesLine.SETRANGE("Document Type", FromSalesHeader."Document Type");
            FromSalesLine.SETRANGE("Document No.", FromSalesHeader."No.");
            IF NOT FromSalesLine.FINDFIRST THEN
                ERROR(Text012);
            REPEAT
                NextLineNo := NextLineNo + 10000;
                CLEAR(ToPurchLine);
                INIT;
                "Document Type" := ToPurchHeader."Document Type";
                "Document No." := ToPurchHeader."No.";
                IF FromSalesLine.Type = FromSalesLine.Type::" " THEN
                    Description := FromSalesLine.Description
                ELSE
                    TransfldsFromSalesToPurchLine(FromSalesLine, ToPurchLine);
                "Line No." := NextLineNo;
                INSERT(TRUE);
            UNTIL FromSalesLine.NEXT = 0;
        END;
    END;

    PROCEDURE TransfldsFromSalesToPurchLine(VAR FromSalesLine: Record 37; VAR ToPurchLine: Record 39);
    BEGIN
        WITH ToPurchLine DO BEGIN
            VALIDATE(Type, FromSalesLine.Type);
            VALIDATE("No.", FromSalesLine."No.");
            VALIDATE("Unit of Measure Code", FromSalesLine."Unit of Measure Code");
            VALIDATE(Quantity, FromSalesLine."Outstanding Quantity");
            IF (Type = Type::Item) AND ("No." <> '') THEN
                UpdateUOMQtyPerStockQty;
            VALIDATE("Direct Unit Cost");
            VALIDATE("Return Reason Code", FromSalesLine."Return Reason Code");
            "Expected Receipt Date" := FromSalesLine."Shipment Date";
            "Location Code" := FromSalesLine."Location Code";
            "Variant Code" := FromSalesLine."Variant Code";
            "Bin Code" := FromSalesLine."Bin Code";
        END;
    END;

    LOCAL PROCEDURE DeleteSalesLinesWithNegQty(FromSalesHeader: Record 36; OnlyTest: Boolean);
    VAR
        FromSalesLine: Record 37;
    BEGIN
        WITH FromSalesLine DO BEGIN
            SETRANGE("Document Type", FromSalesHeader."Document Type");
            SETRANGE("Document No.", FromSalesHeader."No.");
            SETFILTER(Quantity, '<0');
            IF OnlyTest THEN BEGIN
                IF NOT FromSalesLine.FINDFIRST THEN
                    ERROR(Text008);
            END ELSE
                DELETEALL(TRUE);
        END;
    END;

    LOCAL PROCEDURE DeletePurchLinesWithNegQty(FromPurchHeader: Record 38; OnlyTest: Boolean);
    VAR
        FromPurchLine: Record 39;
    BEGIN
        WITH FromPurchLine DO BEGIN
            SETRANGE("Document Type", FromPurchHeader."Document Type");
            SETRANGE("Document No.", FromPurchHeader."No.");
            SETFILTER(Quantity, '<0');
            IF OnlyTest THEN BEGIN
                IF NOT FromPurchLine.FINDFIRST THEN
                    ERROR(Text010);
            END ELSE
                DELETEALL(TRUE);
        END;
    END;

    LOCAL PROCEDURE CopySalesLine(VAR ToSalesHeader: Record 36; VAR ToSalesLine: Record 37; VAR FromSalesHeader: Record 36; VAR FromSalesLine: Record 37; VAR NextLineNo: Integer; VAR LinesNotCopied: Integer; ApplFromItemEntry: Integer);
    VAR
        GLAcc: Record 15;
        CopyThisLine: Boolean;
    BEGIN
        CopyThisLine := TRUE;
        IF RecalculateLines THEN
            ToSalesLine.INIT
        ELSE
            ToSalesLine := FromSalesLine;
        NextLineNo := NextLineNo + 10000;
        ToSalesLine."Document Type" := ToSalesHeader."Document Type";
        ToSalesLine."Document No." := ToSalesHeader."No.";
        ToSalesLine."Line No." := NextLineNo;
        ToSalesLine.VALIDATE("Currency Code", FromSalesHeader."Currency Code");

        IF RecalculateLines THEN BEGIN
            ToSalesLine.VALIDATE(Type, FromSalesLine.Type);
            ToSalesLine.VALIDATE(Description, FromSalesLine.Description);
            ToSalesLine.VALIDATE("Description 2", FromSalesLine."Description 2");
            IF (FromSalesLine.Type.AsInteger() <> 0) AND (FromSalesLine."No." <> '') THEN BEGIN
                IF ToSalesLine.Type = ToSalesLine.Type::"G/L Account" THEN BEGIN
                    ToSalesLine."No." := FromSalesLine."No.";
                    IF GLAcc."No." <> FromSalesLine."No." THEN
                        GLAcc.GET(FromSalesLine."No.");
                    CopyThisLine := GLAcc."Direct Posting";
                    IF CopyThisLine THEN
                        ToSalesLine.VALIDATE("No.", FromSalesLine."No.");
                END ELSE
                    ToSalesLine.VALIDATE("No.", FromSalesLine."No.");
                ToSalesLine.VALIDATE("Location Code", FromSalesLine."Location Code");
                ToSalesLine.VALIDATE("Unit of Measure", FromSalesLine."Unit of Measure");
                ToSalesLine.VALIDATE("Unit of Measure Code", FromSalesLine."Unit of Measure Code");
                ToSalesLine.VALIDATE(Quantity, FromSalesLine.Quantity);
                IF NOT (FromSalesLine.Type IN [FromSalesLine.Type::Item, FromSalesLine.Type::Resource]) THEN BEGIN
                    IF (FromSalesHeader."Currency Code" <> ToSalesHeader."Currency Code") OR
                       (FromSalesHeader."Prices Including VAT" <> ToSalesHeader."Prices Including VAT")
                       THEN BEGIN
                        ToSalesLine."Unit Price" := 0;
                        ToSalesLine."Line Discount %" := 0;
                    END ELSE BEGIN
                        ToSalesLine.VALIDATE("Unit Price", FromSalesLine."Unit Price");
                        ToSalesLine.VALIDATE("Line Discount %", FromSalesLine."Line Discount %");
                    END;
                    IF ToSalesLine.Quantity <> 0 THEN
                        ToSalesLine.VALIDATE("Line Discount Amount", FromSalesLine."Line Discount Amount");
                END;
                ToSalesLine.VALIDATE("Work Type Code", FromSalesLine."Work Type Code");
            END;
        END ELSE BEGIN
            ToSalesLine."Quantity Shipped" := 0;
            ToSalesLine."Qty. Shipped (Base)" := 0;
            ToSalesLine."Return Qty. Received" := 0;
            ToSalesLine."Return Qty. Received (Base)" := 0;
            ToSalesLine."Quantity Invoiced" := 0;
            ToSalesLine."Qty. Invoiced (Base)" := 0;
            ToSalesLine."Reserved Quantity" := 0;
            ToSalesLine."Reserved Qty. (Base)" := 0;
            ToSalesLine."Qty. to Ship" := 0;
            ToSalesLine."Qty. to Ship (Base)" := 0;
            ToSalesLine."Return Qty. to Receive" := 0;
            ToSalesLine."Return Qty. to Receive (Base)" := 0;
            ToSalesLine."Qty. to Invoice" := 0;
            ToSalesLine."Qty. to Invoice (Base)" := 0;
            ToSalesLine."Qty. Shipped Not Invoiced" := 0;
            ToSalesLine."Return Qty. Rcd. Not Invd." := 0;
            ToSalesLine."Shipped Not Invoiced" := 0;
            ToSalesLine."Return Rcd. Not Invd." := 0;
            ToSalesLine."Qty. Shipped Not Invd. (Base)" := 0;
            ToSalesLine."Ret. Qty. Rcd. Not Invd.(Base)" := 0;
            ToSalesLine."Shipped Not Invoiced (LCY)" := 0;
            ToSalesLine."Return Rcd. Not Invd. (LCY)" := 0;

            ToSalesLine.InitOutstanding;
            IF ToSalesLine."Document Type" IN
                 [ToSalesLine."Document Type"::"Return Order", ToSalesLine."Document Type"::"Credit Memo"]
            THEN
                ToSalesLine.InitQtyToReceive
            ELSE
                ToSalesLine.InitQtyToShip;
            ToSalesLine."VAT Difference" := FromSalesLine."VAT Difference";
            IF NOT CreateToHeader THEN
                ToSalesLine."Shipment Date" := ToSalesHeader."Shipment Date";
            ToSalesLine."Appl.-from Item Entry" := 0;
            ToSalesLine."Purchase Order No." := '';
            ToSalesLine."Purch. Order Line No." := 0;
            ToSalesLine."Drop Shipment" := FALSE;
            ToSalesLine.UpdateWithWarehouseShip;
            ToSalesLine."Blanket Order No." := '';
            ToSalesLine."Blanket Order Line No." := 0;
        END;

        IF MoveNegLines THEN BEGIN
            IF ToSalesLine.Type <> ToSalesLine.Type::" " THEN
                ToSalesLine.VALIDATE(Quantity, -FromSalesLine.Quantity);
            ToSalesLine."Appl.-to Item Entry" := FromSalesLine."Appl.-to Item Entry";
            ToSalesLine."Appl.-from Item Entry" := FromSalesLine."Appl.-from Item Entry";
        END ELSE
            ToSalesLine."Appl.-from Item Entry" := ApplFromItemEntry;

        ToSalesLine."Attached to Line No." :=
          TransferOldExtLines.TransferExtendedText(
            FromSalesLine."Line No.",
            NextLineNo,
            FromSalesLine."Attached to Line No.");
        IF CopyThisLine THEN
            ToSalesLine.INSERT
        ELSE
            LinesNotCopied := LinesNotCopied + 1;
    END;

    LOCAL PROCEDURE CopyPurchLine(VAR ToPurchHeader: Record 38; VAR ToPurchLine: Record 39; VAR FromPurchHeader: Record 38; VAR FromPurchLine: Record 39; VAR NextLineNo: Integer; VAR LinesNotCopied: Integer; ApplToItemEntry: Integer);
    VAR
        GLAcc: Record 15;
        CopyThisLine: Boolean;
    BEGIN
        CopyThisLine := TRUE;
        IF RecalculateLines THEN
            ToPurchLine.INIT
        ELSE
            ToPurchLine := FromPurchLine;
        NextLineNo := NextLineNo + 10000;
        ToPurchLine."Document Type" := ToPurchHeader."Document Type";
        ToPurchLine."Document No." := ToPurchHeader."No.";
        ToPurchLine."Line No." := NextLineNo;
        ToPurchLine.VALIDATE("Currency Code", FromPurchHeader."Currency Code");

        IF RecalculateLines THEN BEGIN
            ToPurchLine.VALIDATE(Type, FromPurchLine.Type);
            ToPurchLine.VALIDATE(Description, FromPurchLine.Description);
            ToPurchLine.VALIDATE("Description 2", FromPurchLine."Description 2");
            IF (FromPurchLine.Type.AsInteger() <> 0) AND (FromPurchLine."No." <> '') THEN BEGIN
                IF ToPurchLine.Type = ToPurchLine.Type::"G/L Account" THEN BEGIN
                    ToPurchLine."No." := FromPurchLine."No.";
                    IF GLAcc."No." <> FromPurchLine."No." THEN
                        GLAcc.GET(FromPurchLine."No.");
                    CopyThisLine := GLAcc."Direct Posting";
                    IF CopyThisLine THEN
                        ToPurchLine.VALIDATE("No.", FromPurchLine."No.");
                END ELSE
                    ToPurchLine.VALIDATE("No.", FromPurchLine."No.");
                ToPurchLine.VALIDATE("Location Code", FromPurchLine."Location Code");
                ToPurchLine.VALIDATE("Unit of Measure", FromPurchLine."Unit of Measure");
                ToPurchLine.VALIDATE("Unit of Measure Code", FromPurchLine."Unit of Measure Code");
                ToPurchLine.VALIDATE(Quantity, FromPurchLine.Quantity);
                IF FromPurchLine.Type <> FromPurchLine.Type::Item THEN BEGIN
                    FromPurchHeader.TESTFIELD("Currency Code", ToPurchHeader."Currency Code");
                    ToPurchLine.VALIDATE("Direct Unit Cost", FromPurchLine."Direct Unit Cost");
                    ToPurchLine.VALIDATE("Line Discount %", FromPurchLine."Line Discount %");
                    IF ToPurchLine.Quantity <> 0 THEN
                        ToPurchLine.VALIDATE("Line Discount Amount", FromPurchLine."Line Discount Amount");
                END;
            END;
        END ELSE BEGIN
            ToPurchLine."Quantity Received" := 0;
            ToPurchLine."Qty. Received (Base)" := 0;
            ToPurchLine."Return Qty. Shipped" := 0;
            ToPurchLine."Return Qty. Shipped (Base)" := 0;
            ToPurchLine."Quantity Invoiced" := 0;
            ToPurchLine."Qty. Invoiced (Base)" := 0;
            ToPurchLine."Reserved Quantity" := 0;
            ToPurchLine."Reserved Qty. (Base)" := 0;
            ToPurchLine."Qty. Rcd. Not Invoiced" := 0;
            ToPurchLine."Qty. Rcd. Not Invoiced (Base)" := 0;
            ToPurchLine."Return Qty. Shipped Not Invd." := 0;
            ToPurchLine."Ret. Qty. Shpd Not Invd.(Base)" := 0;
            ToPurchLine."Qty. to Receive" := 0;
            ToPurchLine."Qty. to Receive (Base)" := 0;
            ToPurchLine."Return Qty. to Ship" := 0;
            ToPurchLine."Return Qty. to Ship (Base)" := 0;
            ToPurchLine."Qty. to Invoice" := 0;
            ToPurchLine."Qty. to Invoice (Base)" := 0;
            ToPurchLine."Amt. Rcd. Not Invoiced" := 0;
            ToPurchLine."Amt. Rcd. Not Invoiced (LCY)" := 0;
            ToPurchLine."Return Shpd. Not Invd." := 0;
            ToPurchLine."Return Shpd. Not Invd. (LCY)" := 0;

            ToPurchLine.InitOutstanding;
            IF ToPurchLine."Document Type" IN
                 [ToPurchLine."Document Type"::"Return Order", ToPurchLine."Document Type"::"Credit Memo"]
            THEN
                ToPurchLine.InitQtyToShip
            ELSE
                ToPurchLine.InitQtyToReceive;
            ToPurchLine."VAT Difference" := FromPurchLine."VAT Difference";
            ToPurchLine."Receipt No." := '';
            ToPurchLine."Receipt Line No." := 0;
            IF NOT CreateToHeader THEN
                ToPurchLine."Expected Receipt Date" := ToPurchHeader."Expected Receipt Date";
            ToPurchLine."Sales Order No." := '';
            ToPurchLine."Sales Order Line No." := 0;
            ToPurchLine."Drop Shipment" := FALSE;
            ToPurchLine.UpdateWithWarehouseReceive;
        END;

        IF MoveNegLines THEN BEGIN
            IF ToPurchLine.Type <> ToPurchLine.Type::" " THEN
                ToPurchLine.VALIDATE(Quantity, -FromPurchLine.Quantity);
            ToPurchLine."Appl.-to Item Entry" := FromPurchLine."Appl.-to Item Entry"
        END ELSE
            ToPurchLine."Appl.-to Item Entry" := ApplToItemEntry;
        ToPurchLine."Attached to Line No." :=
          TransferOldExtLines.TransferExtendedText(
            FromPurchLine."Line No.",
            NextLineNo,
            FromPurchLine."Attached to Line No.");

        IF CopyThisLine THEN
            ToPurchLine.INSERT
        ELSE
            LinesNotCopied := LinesNotCopied + 1;
    END;

    LOCAL PROCEDURE CopyFromSalesDocDimToHeader(VAR ToSalesHeader: Record 36; VAR FromSalesHeader: Record 36);
    BEGIN
        ToSalesHeader."Shortcut Dimension 1 Code" := FromSalesHeader."Shortcut Dimension 1 Code";
        ToSalesHeader."Shortcut Dimension 2 Code" := FromSalesHeader."Shortcut Dimension 2 Code";
        ToSalesHeader."Dimension Set ID" := FromSalesHeader."Dimension Set ID";
    END;

    LOCAL PROCEDURE CopyFromPurchDocDimToHeader(VAR ToPurchHeader: Record 38; VAR FromPurchHeader: Record 38);
    BEGIN
        ToPurchHeader."Shortcut Dimension 1 Code" := FromPurchHeader."Shortcut Dimension 1 Code";
        ToPurchHeader."Shortcut Dimension 2 Code" := FromPurchHeader."Shortcut Dimension 2 Code";
        ToPurchHeader."Dimension Set ID" := FromPurchHeader."Dimension Set ID";
    END;

    LOCAL PROCEDURE CopyFromPstdSalesDocDimToHdr(VAR ToSalesHeader: Record 36; FromDocType: Option; VAR FromSalesShptHeader: Record 110; VAR FromSalesInvHeader: Record 112; VAR FromReturnRcptHeader: Record 6660; VAR FromSalesCrMemoHeader: Record 114);
    BEGIN
        CASE FromDocType OF
            SalesDocType::"Posted Shipment":
                BEGIN
                    ToSalesHeader."Shortcut Dimension 1 Code" := FromSalesShptHeader."Shortcut Dimension 1 Code";
                    ToSalesHeader."Shortcut Dimension 2 Code" := FromSalesShptHeader."Shortcut Dimension 2 Code";
                    ToSalesHeader."Dimension Set ID" := FromSalesShptHeader."Dimension Set ID";
                END;
            SalesDocType::"Posted Invoice":
                BEGIN
                    ToSalesHeader."Shortcut Dimension 1 Code" := FromSalesInvHeader."Shortcut Dimension 1 Code";
                    ToSalesHeader."Shortcut Dimension 2 Code" := FromSalesInvHeader."Shortcut Dimension 2 Code";
                    ToSalesHeader."Dimension Set ID" := FromSalesInvHeader."Dimension Set ID";
                END;
            SalesDocType::"Posted Return Receipt":
                BEGIN
                    ToSalesHeader."Shortcut Dimension 1 Code" := FromReturnRcptHeader."Shortcut Dimension 1 Code";
                    ToSalesHeader."Shortcut Dimension 2 Code" := FromReturnRcptHeader."Shortcut Dimension 2 Code";
                    ToSalesHeader."Dimension Set ID" := FromReturnRcptHeader."Dimension Set ID";
                END;
            SalesDocType::"Posted Credit Memo":
                BEGIN
                    ToSalesHeader."Shortcut Dimension 1 Code" := FromSalesCrMemoHeader."Shortcut Dimension 1 Code";
                    ToSalesHeader."Shortcut Dimension 2 Code" := FromSalesCrMemoHeader."Shortcut Dimension 2 Code";
                    ToSalesHeader."Dimension Set ID" := FromSalesCrMemoHeader."Dimension Set ID";
                END;
        END;
    END;

    LOCAL PROCEDURE CopyFromPstdPurchDocDimToHdr(VAR ToPurchHeader: Record 38; FromDocType: Option; VAR FromPurchRcptHeader: Record 120; VAR FromPurchInvHeader: Record 122; VAR FromReturnShptHeader: Record 6650; VAR FromPurchCrMemoHeader: Record 124);
    BEGIN
        CASE FromDocType OF
            PurchDocType::"Posted Receipt":
                BEGIN
                    ToPurchHeader."Shortcut Dimension 1 Code" := FromPurchRcptHeader."Shortcut Dimension 1 Code";
                    ToPurchHeader."Shortcut Dimension 2 Code" := FromPurchRcptHeader."Shortcut Dimension 2 Code";
                    ToPurchHeader."Dimension Set ID" := FromPurchRcptHeader."Dimension Set ID";
                END;
            PurchDocType::"Posted Invoice":
                BEGIN
                    ToPurchHeader."Shortcut Dimension 1 Code" := FromPurchInvHeader."Shortcut Dimension 1 Code";
                    ToPurchHeader."Shortcut Dimension 2 Code" := FromPurchInvHeader."Shortcut Dimension 2 Code";
                    ToPurchHeader."Dimension Set ID" := FromPurchInvHeader."Dimension Set ID";
                END;
            PurchDocType::"Posted Return Shipment":
                BEGIN
                    ToPurchHeader."Shortcut Dimension 1 Code" := FromReturnShptHeader."Shortcut Dimension 1 Code";
                    ToPurchHeader."Shortcut Dimension 2 Code" := FromReturnShptHeader."Shortcut Dimension 2 Code";
                    ToPurchHeader."Dimension Set ID" := FromReturnShptHeader."Dimension Set ID";
                END;
            PurchDocType::"Posted Credit Memo":
                BEGIN
                    ToPurchHeader."Shortcut Dimension 1 Code" := FromPurchCrMemoHeader."Shortcut Dimension 1 Code";
                    ToPurchHeader."Shortcut Dimension 2 Code" := FromPurchCrMemoHeader."Shortcut Dimension 2 Code";
                    ToPurchHeader."Dimension Set ID" := FromPurchCrMemoHeader."Dimension Set ID";
                END;
        END;
    END;

    LOCAL PROCEDURE CopyFromSalesDocDimToLine(VAR ToSalesLine: Record 37; VAR FromSalesLine: Record 37);
    BEGIN
        IF IncludeHeader THEN BEGIN
            ToSalesLine."Shortcut Dimension 1 Code" := FromSalesLine."Shortcut Dimension 1 Code";
            ToSalesLine."Shortcut Dimension 2 Code" := FromSalesLine."Shortcut Dimension 2 Code";
            ToSalesLine."Dimension Set ID" := FromSalesLine."Dimension Set ID";
        END;
    END;

    LOCAL PROCEDURE CopyFromPurchDocDimToLine(VAR ToPurchLine: Record 39; VAR FromPurchLine: Record 39);
    BEGIN
        IF IncludeHeader THEN BEGIN
            ToPurchLine."Shortcut Dimension 1 Code" := FromPurchLine."Shortcut Dimension 1 Code";
            ToPurchLine."Shortcut Dimension 2 Code" := FromPurchLine."Shortcut Dimension 2 Code";
            ToPurchLine."Dimension Set ID" := FromPurchLine."Dimension Set ID";
        END;
    END;

    LOCAL PROCEDURE CopyFromPstdSalesDocDimToLine(VAR ToSalesLine: Record 37; FromDocType: Option; VAR FromSalesShptLine: Record 111; VAR FromSalesInvLine: Record 113; VAR FromReturnRcptLine: Record 6661; VAR FromSalesCrMemoLine: Record 115);
    BEGIN
        IF IncludeHeader THEN BEGIN
            CASE FromDocType OF
                SalesDocType::"Posted Shipment":
                    BEGIN
                        ToSalesLine."Shortcut Dimension 1 Code" := FromSalesShptLine."Shortcut Dimension 1 Code";
                        ToSalesLine."Shortcut Dimension 2 Code" := FromSalesShptLine."Shortcut Dimension 2 Code";
                        ToSalesLine."Dimension Set ID" := FromSalesShptLine."Dimension Set ID";
                    END;
                SalesDocType::"Posted Invoice":
                    BEGIN
                        ToSalesLine."Shortcut Dimension 1 Code" := FromSalesInvLine."Shortcut Dimension 1 Code";
                        ToSalesLine."Shortcut Dimension 2 Code" := FromSalesInvLine."Shortcut Dimension 2 Code";
                        ToSalesLine."Dimension Set ID" := FromSalesInvLine."Dimension Set ID";
                    END;
                SalesDocType::"Posted Return Receipt":
                    BEGIN
                        ToSalesLine."Shortcut Dimension 1 Code" := FromReturnRcptLine."Shortcut Dimension 1 Code";
                        ToSalesLine."Shortcut Dimension 2 Code" := FromReturnRcptLine."Shortcut Dimension 2 Code";
                        ToSalesLine."Dimension Set ID" := FromReturnRcptLine."Dimension Set ID";
                    END;
                SalesDocType::"Posted Credit Memo":
                    BEGIN
                        ToSalesLine."Shortcut Dimension 1 Code" := FromSalesCrMemoLine."Shortcut Dimension 1 Code";
                        ToSalesLine."Shortcut Dimension 2 Code" := FromSalesCrMemoLine."Shortcut Dimension 2 Code";
                        ToSalesLine."Dimension Set ID" := FromSalesCrMemoLine."Dimension Set ID";
                    END;
            END;
        END;
    END;

    LOCAL PROCEDURE CopyFromPstdPurchDocDimToLine(VAR ToPurchLine: Record 39; FromDocType: Option; VAR FromPurchRcptLine: Record 121; VAR FromPurchInvLine: Record 123; VAR FromReturnShptLine: Record 6651; VAR FromPurchCrMemoLine: Record 125);
    BEGIN
        IF IncludeHeader THEN BEGIN
            CASE FromDocType OF
                PurchDocType::"Posted Receipt":
                    BEGIN
                        ToPurchLine."Shortcut Dimension 1 Code" := FromPurchRcptLine."Shortcut Dimension 1 Code";
                        ToPurchLine."Shortcut Dimension 2 Code" := FromPurchRcptLine."Shortcut Dimension 2 Code";
                        ToPurchLine."Dimension Set ID" := FromPurchRcptLine."Dimension Set ID";
                    END;
                PurchDocType::"Posted Invoice":
                    BEGIN
                        ToPurchLine."Shortcut Dimension 1 Code" := FromPurchInvLine."Shortcut Dimension 1 Code";
                        ToPurchLine."Shortcut Dimension 2 Code" := FromPurchInvLine."Shortcut Dimension 2 Code";
                        ToPurchLine."Dimension Set ID" := FromPurchInvLine."Dimension Set ID";
                    END;
                PurchDocType::"Posted Return Shipment":
                    BEGIN
                        ToPurchLine."Shortcut Dimension 1 Code" := FromReturnShptLine."Shortcut Dimension 1 Code";
                        ToPurchLine."Shortcut Dimension 2 Code" := FromReturnShptLine."Shortcut Dimension 2 Code";
                        ToPurchLine."Dimension Set ID" := FromReturnShptLine."Dimension Set ID";
                    END;
                PurchDocType::"Posted Credit Memo":
                    BEGIN
                        ToPurchLine."Shortcut Dimension 1 Code" := FromPurchCrMemoLine."Shortcut Dimension 1 Code";
                        ToPurchLine."Shortcut Dimension 2 Code" := FromPurchCrMemoLine."Shortcut Dimension 2 Code";
                        ToPurchLine."Dimension Set ID" := FromPurchCrMemoLine."Dimension Set ID";
                    END;
            END;
        END;
    END;

    LOCAL PROCEDURE CopyFromSalesDocAssgntToLine(VAR ToSalesLine: Record 37; FromSalesLine: Record 37; VAR ItemChargeAssgntNextLineNo: Integer);
    VAR
        FromItemChargeAssgntSales: Record 5809;
        ToItemChargeAssgntSales: Record 5809;
        AssignItemChargeSales: Codeunit 5807;
    BEGIN
        WITH FromSalesLine DO BEGIN
            IF NOT FromItemChargeAssgntSales.RECORDLEVELLOCKING THEN
                FromItemChargeAssgntSales.LOCKTABLE(TRUE, TRUE);
            FromItemChargeAssgntSales.RESET;
            FromItemChargeAssgntSales.SETRANGE("Document Type", "Document Type");
            FromItemChargeAssgntSales.SETRANGE("Document No.", "Document No.");
            FromItemChargeAssgntSales.SETRANGE("Document Line No.", "Line No.");
            FromItemChargeAssgntSales.SETFILTER(
              "Applies-to Doc. Type", '<>%1', "Document Type");
            IF FromItemChargeAssgntSales.FINDSET(TRUE) THEN
                REPEAT
                    ToItemChargeAssgntSales.COPY(FromItemChargeAssgntSales);
                    ToItemChargeAssgntSales."Document Type" := ToSalesLine."Document Type";
                    ToItemChargeAssgntSales."Document No." := ToSalesLine."Document No.";
                    ToItemChargeAssgntSales."Document Line No." := ToSalesLine."Line No.";
                    // AssignItemChargeSales.InsertItemChargeAssgnt(
                    //   ToItemChargeAssgntSales, ToItemChargeAssgntSales."Applies-to Doc. Type",
                    //   ToItemChargeAssgntSales."Applies-to Doc. No.", ToItemChargeAssgntSales."Applies-to Doc. Line No.",
                    //   ToItemChargeAssgntSales."Item No.", ToItemChargeAssgntSales.Description, ItemChargeAssgntNextLineNo);
                UNTIL FromItemChargeAssgntSales.NEXT = 0;
        END;
    END;

    LOCAL PROCEDURE CopyFromPurchDocAssgntToLine(VAR ToPurchLine: Record 39; FromPurchLine: Record 39; VAR ItemChargeAssgntNextLineNo: Integer);
    VAR
        FromItemChargeAssgntPurch: Record 5805;
        ToItemChargeAssgntPurch: Record 5805;
        AssignItemChargePurch: Codeunit 5805;
         AssignItemChargePurch1: Codeunit 51053;
    BEGIN
        WITH FromPurchLine DO BEGIN
            IF NOT FromItemChargeAssgntPurch.RECORDLEVELLOCKING THEN
                FromItemChargeAssgntPurch.LOCKTABLE(TRUE, TRUE);
            FromItemChargeAssgntPurch.RESET;
            FromItemChargeAssgntPurch.SETRANGE("Document Type", "Document Type");
            FromItemChargeAssgntPurch.SETRANGE("Document No.", "Document No.");
            FromItemChargeAssgntPurch.SETRANGE("Document Line No.", "Line No.");
            FromItemChargeAssgntPurch.SETFILTER(
              "Applies-to Doc. Type", '<>%1', "Document Type");
            IF FromItemChargeAssgntPurch.FINDSET(TRUE) THEN
                REPEAT
                    ToItemChargeAssgntPurch.COPY(FromItemChargeAssgntPurch);
                    ToItemChargeAssgntPurch."Document Type" := ToPurchLine."Document Type";
                    ToItemChargeAssgntPurch."Document No." := ToPurchLine."Document No.";
                    ToItemChargeAssgntPurch."Document Line No." := ToPurchLine."Line No.";
                    AssignItemChargePurch1.InsertItemChargeAssgnt(
                      ToItemChargeAssgntPurch, ToItemChargeAssgntPurch."Applies-to Doc. Type",
                      ToItemChargeAssgntPurch."Applies-to Doc. No.", ToItemChargeAssgntPurch."Applies-to Doc. Line No.",
                      ToItemChargeAssgntPurch."Item No.", ToItemChargeAssgntPurch.Description, ItemChargeAssgntNextLineNo);
                UNTIL FromItemChargeAssgntPurch.NEXT = 0;
        END;
    END;

    LOCAL PROCEDURE WarnSalesInvoicePmtDisc(VAR ToSalesHeader: Record 36; VAR FromSalesHeader: Record 36; FromDocType: Option; FromDocNo: Code[20]);
    VAR
        CustLedgEntry: Record 21;
    BEGIN
        IF HideDialog THEN
            EXIT;

        IF IncludeHeader AND
           (ToSalesHeader."Document Type" IN
             [ToSalesHeader."Document Type"::"Return Order", ToSalesHeader."Document Type"::"Credit Memo"])
        THEN BEGIN
            CustLedgEntry.SETRANGE("Document Type", FromSalesHeader."Document Type"::Invoice);
            CustLedgEntry.SETRANGE("Document No.", FromDocNo);
            IF CustLedgEntry.FINDFIRST THEN BEGIN
                IF (CustLedgEntry."Pmt. Disc. Given (LCY)" <> 0) AND
                   (CustLedgEntry."Journal Batch Name" = '')
                THEN
                    MESSAGE(Text006, SELECTSTR(FromDocType + 1, Text007), FromDocNo);
            END;
        END;
    END;

    LOCAL PROCEDURE WarnPurchInvoicePmtDisc(VAR ToPurchHeader: Record 38; VAR FromPurchHeader: Record 38; FromDocType: Option; FromDocNo: Code[20]);
    VAR
        VendLedgEntry: Record 25;
    BEGIN
        IF HideDialog THEN
            EXIT;

        IF IncludeHeader AND
           (ToPurchHeader."Document Type" IN
             [ToPurchHeader."Document Type"::"Return Order", ToPurchHeader."Document Type"::"Credit Memo"])
        THEN BEGIN
            VendLedgEntry.SETRANGE("Document Type", FromPurchHeader."Document Type"::Invoice);
            VendLedgEntry.SETRANGE("Document No.", FromDocNo);
            IF VendLedgEntry.FINDFIRST THEN BEGIN
                IF (VendLedgEntry."Pmt. Disc. Rcd.(LCY)" <> 0) AND
                   (VendLedgEntry."Journal Batch Name" = '')
                THEN
                    MESSAGE(Text009, SELECTSTR(FromDocType + 1, Text007), FromDocNo);
            END;
        END;
    END;

    LOCAL PROCEDURE CheckItemAvailable(VAR ToSalesHeader: Record 36; VAR ToSalesLine: Record 37);
    BEGIN
        IF HideDialog THEN
            EXIT;

        IF ToSalesLine."Shipment Date" = 0D THEN BEGIN
            IF ToSalesHeader."Shipment Date" <> 0D THEN
                ToSalesLine.VALIDATE("Shipment Date", ToSalesHeader."Shipment Date")
            ELSE
                ToSalesLine.VALIDATE("Shipment Date", WORKDATE);
        END;

        ToSalesLine."Document Type" := ToSalesHeader."Document Type";
        ToSalesLine."Document No." := ToSalesHeader."No.";
        ToSalesLine."Line No." := 0;
        ToSalesLine.Type := ToSalesLine.Type::Item;
        ToSalesLine."Purchase Order No." := '';
        ToSalesLine."Purch. Order Line No." := 0;
        ToSalesLine."Drop Shipment" := FALSE;
        ItemCheckAvail.SalesLineCheck(ToSalesLine);
    END;

    /* /*BEGIN
END.*/
}







