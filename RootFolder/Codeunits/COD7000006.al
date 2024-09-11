Codeunit 50035 "Document-Post 1"
{


    Permissions = TableData 21 = imd,
                TableData 25 = imd,
                TableData 379 = imd,
                TableData 380 = imd,
                TableData 7000002 = imd,
                TableData 7000003 = imd,
                TableData 7000004 = imd,
                TableData 7000006 = imd,
                TableData 7000007 = imd,
                TableData 7000021 = imd,
                TableData 7000022 = imd;
    trigger OnRun()
    BEGIN
    END;

    VAR
        Text1100000: TextConst ENU = 'must be of a type that creates bills', ESP = 'debe ser de un tipo que cree efectos';
        Text1100001: TextConst ENU = 'A customer or vendor must be specified when a bill is created.', ESP = 'Cuando se crea un efecto se debe indicar un cliente o proveedor.';
        Text1100002: TextConst ENU = 'A grouped document cannot be settled from a journal.\', ESP = 'Un documento remesado no se puede liquidar desde el diario.\';
        Text1100003: TextConst ENU = 'Remove Document %1/%2 from Group/Pmt. Order %3 and try again.\', ESP = 'Elimine documento %1/%2 de la remesa/orden pago %3 e int�ntelo de nuevo.\';
        Text1100004: TextConst ENU = 'Sales Bill %1/%2 already exists.', ESP = 'Ya existe efecto %1/%2';
        Text1100005: TextConst ENU = 'Purchase Document %1/%2 already exists.', ESP = 'Ya existe documento %1/%2';
        Text1100006: TextConst ENU = 'Receivable %1 %2/%3 cannot be applied to, because it is included in a posted Bill Group.', ESP = 'No se puede liquidar el cobro %1 %2/%3 ya que est� incluido en una remesa registrada.';
        Text1100007: TextConst ENU = 'Payable %1 %2/%3 cannot be applied to, because it is included in a posted Payment Order.', ESP = 'No se puede liquidar el pago %1 %2/%3 ya que est� incluido en una remesa registrada.';
        Text1100008: TextConst ENU = 'Date %1 is not within your range of allowed posting dates', ESP = 'La fecha %1 no est� comprendida en el periodo de fechas de registro permitidas.';
        Text1100009: TextConst ENU = '%1 must be entered.', ESP = 'Se debe indicar %1.';
        Text1100010: TextConst ENU = '%1 must be of a type that creates bills.', ESP = '%1 debe ser de un tipo que cree efectos.';
        Text1100011: TextConst ENU = 'A grouped document cannot be settled from a journal. Remove it from its group or payment order and try again.', ESP = 'Un documento remesado no se puede liquidar desde el diario. Elim�nelo de la orden de pago e int�ntelo de nuevo.';
        Text1100012: TextConst ENU = 'cannot be filtered when posting recurring journals', ESP = 'no puede contener un filtro cuando se registra un diario peri�dico';
        Text1100013: TextConst ENU = 'Do you want to post the journal lines and print the posting report?', ESP = '�Confirma que desea registrar las l�ns. de diario e imprimir el informe de reg.?';
        Text1100014: TextConst ENU = 'Do you want to post the journal lines?', ESP = '�Confirma que desea registrar las l�neas del diario?';
        Text1100015: TextConst ENU = 'There is nothing to post.', ESP = 'No hay nada que registrar.';
        Text1100016: TextConst ENU = 'The journal lines were successfully posted.', ESP = 'Se han registrado correctamente las l�neas del diario.';
        Text1100017: TextConst ENU = 'The journal lines were successfully posted. You are now in the %1 journal.', ESP = 'Se registraron correctamente las l�neas diario. Se encuentra en el diario %1.';
        QB_Preview: Boolean;

    //[External]
    PROCEDURE CheckGenJnlLine(VAR GenJnlLine: Record 81);
    VAR
        CarteraDoc: Record 7000002;
        PaymentMethod: Record 289;
        SystemCreated: Boolean;
    BEGIN
        WITH GenJnlLine DO BEGIN
            IF ("Document Type" = "Document Type"::Invoice) AND
               ("Account Type" IN ["Account Type"::Customer, "Account Type"::Vendor]) AND
               (Amount <> 0)
            THEN BEGIN
                TESTFIELD("Payment Method Code");
                TESTFIELD("Payment Terms Code");
            END;
            IF ("Document Type" = "Document Type"::Bill) AND
               (Amount <> 0)
            THEN BEGIN
                TESTFIELD("Bill No.");
                TESTFIELD("Due Date");
                TESTFIELD("Payment Method Code");
                PaymentMethod.GET("Payment Method Code");
                IF NOT PaymentMethod."Create Bills" THEN
                    FIELDERROR("Payment Method Code", Text1100000);
                IF NOT ("Account Type" IN ["Account Type"::Customer, "Account Type"::Vendor]) THEN
                    ERROR(Text1100001)
            END;
            IF "Document Type" = "Document Type"::"Credit Memo" THEN
                SystemCreated := FALSE
            ELSE
                SystemCreated := "System-Created Entry";
            IF ("Account Type" = "Account Type"::Customer) AND
               ("Applies-to Doc. Type" IN ["Applies-to Doc. Type"::Bill, "Applies-to Doc. Type"::Invoice]) AND
               NOT SystemCreated
            THEN BEGIN
                CarteraDoc.RESET;
                CarteraDoc.SETCURRENTKEY(Type, "Document No.");
                CarteraDoc.SETRANGE(Type, CarteraDoc.Type::Receivable);
                CarteraDoc.SETRANGE("Document No.", "Applies-to Doc. No.");
                IF "Applies-to Doc. Type" = "Applies-to Doc. Type"::Bill THEN
                    CarteraDoc.SETRANGE("No.", "Applies-to Bill No.")
                ELSE
                    CarteraDoc.SETRANGE("Document Type", CarteraDoc."Document Type"::Invoice);
                IF CarteraDoc.FINDFIRST AND (CarteraDoc."Bill Gr./Pmt. Order No." <> '') THEN
                    ERROR(
                      Text1100002 +
                      Text1100003,
                      CarteraDoc."Document No.", CarteraDoc."No.", CarteraDoc."Bill Gr./Pmt. Order No.");
            END;
            IF ("Account Type" = "Account Type"::Vendor) AND
               (("Applies-to Doc. Type" = "Applies-to Doc. Type"::Bill) OR ("Applies-to Doc. Type" = "Applies-to Doc. Type"::
                                                                            Invoice)) AND
               NOT SystemCreated
            THEN BEGIN
                CarteraDoc.RESET;
                CarteraDoc.SETCURRENTKEY(Type, "Document No.");
                CarteraDoc.SETRANGE(Type, CarteraDoc.Type::Payable);
                CarteraDoc.SETRANGE("Document No.", "Applies-to Doc. No.");
                IF "Applies-to Doc. Type" = "Applies-to Doc. Type"::Bill THEN
                    CarteraDoc.SETRANGE("No.", "Applies-to Bill No.")
                ELSE
                    CarteraDoc.SETRANGE("Document Type", CarteraDoc."Document Type"::Invoice);
                IF CarteraDoc.FINDFIRST AND (CarteraDoc."Bill Gr./Pmt. Order No." <> '') THEN
                    ERROR(
                      Text1100002 +
                      Text1100003,
                      CarteraDoc."Document No.", CarteraDoc."No.", CarteraDoc."Bill Gr./Pmt. Order No.");
            END;
        END;
    END;

    //[External]
    PROCEDURE CreateReceivableDoc(GenJnlLine: Record 81; VAR CVLedgEntryBuf: Record 382; IsFromJournal: Boolean);
    VAR
        CarteraDoc: Record 7000002;
        CompanyInfo: Record 79;
        OldCustLedgEntry: Record 21;
        CustBankAccCode: Record 287;
    BEGIN
        CarteraDoc.INIT;
        GJLInfoToDoc(GenJnlLine, CarteraDoc);
        WITH CVLedgEntryBuf DO BEGIN
            CarteraDoc.Type := CarteraDoc.Type::Receivable;
            CarteraDoc."Entry No." := "Entry No.";
            CarteraDoc."Remaining Amount" := "Remaining Amount";
            CarteraDoc."Remaining Amt. (LCY)" := "Remaining Amt. (LCY)";
            CarteraDoc."Original Amount" := "Remaining Amount";
            CarteraDoc."Original Amount (LCY)" := "Remaining Amt. (LCY)";
            IF CompanyInfo.GET AND CustBankAccCode.GET("CV No.", GenJnlLine."Recipient Bank Account") THEN
                CarteraDoc.Place := COPYSTR(CompanyInfo."Post Code", 1, 2) = COPYSTR(CustBankAccCode."Post Code", 1, 2);
            // Check the Doc no.
            OldCustLedgEntry.RESET;
            OldCustLedgEntry.SETCURRENTKEY("Document No.", "Document Type", "Customer No.");
            OldCustLedgEntry.SETRANGE("Document No.", "Document No.");
            IF GenJnlLine."Document Type" = GenJnlLine."Document Type"::Bill THEN
                OldCustLedgEntry.SETRANGE("Document Type", OldCustLedgEntry."Document Type"::Bill)
            ELSE
                IF GenJnlLine."Document Type" = GenJnlLine."Document Type"::Invoice THEN
                    OldCustLedgEntry.SETRANGE("Document Type", OldCustLedgEntry."Document Type"::Invoice);
            OldCustLedgEntry.SETRANGE("Bill No.", OldCustLedgEntry."Bill No.");
            IF OldCustLedgEntry.FINDFIRST THEN
                ERROR(
                  Text1100004,
                  "Document No.", OldCustLedgEntry."Bill No.");
        END;

        IF IsFromJournal THEN
            CarteraDoc."From Journal" := TRUE;

        OnBeforeCreateReceivableDoc(CarteraDoc, GenJnlLine);
        CarteraDoc.INSERT;
        OnAfterCreateReceivableDoc(CarteraDoc, GenJnlLine);
        // CVLedgEntryBuf."Document Situation" := CVLedgEntryBuf."Document Situation"::Cartera;
        // CVLedgEntryBuf."Document Status" := CVLedgEntryBuf."Document Status"::Open;
    END;

    //[External]
    PROCEDURE CreatePayableDoc(GenJnlLine: Record 81; VAR CVLedgEntryBuf: Record 382; IsFromJournal: Boolean);
    VAR
        CarteraDoc: Record 7000002;
        OldVendLedgEntry: Record 25;
        ElectPmtMgmt: Codeunit 10701;
    BEGIN
        CarteraDoc.INIT;
        GJLInfoToDoc(GenJnlLine, CarteraDoc);
        WITH CVLedgEntryBuf DO BEGIN
            CarteraDoc.Type := CarteraDoc.Type::Payable;
            CarteraDoc."Entry No." := "Entry No.";
            CarteraDoc."Remaining Amount" := -"Remaining Amount";
            CarteraDoc."Remaining Amt. (LCY)" := -"Remaining Amt. (LCY)";
            CarteraDoc."Original Amount" := -"Remaining Amount";
            CarteraDoc."Original Amount (LCY)" := -"Remaining Amt. (LCY)";
            // Check the Doc no.
            OldVendLedgEntry.RESET;
            OldVendLedgEntry.SETCURRENTKEY("Document No.", "Document Type", "Vendor No.");
            OldVendLedgEntry.SETRANGE("Document No.", "Document No.");
            IF GenJnlLine."Document Type" = GenJnlLine."Document Type"::Bill THEN
                OldVendLedgEntry.SETRANGE("Document Type", OldVendLedgEntry."Document Type"::Bill)
            ELSE
                IF GenJnlLine."Document Type" = GenJnlLine."Document Type"::Invoice THEN
                    OldVendLedgEntry.SETRANGE("Document Type", OldVendLedgEntry."Document Type"::Invoice);
            OldVendLedgEntry.SETRANGE("Bill No.", OldVendLedgEntry."Bill No.");
            IF OldVendLedgEntry.FINDFIRST THEN
                ERROR(
                  Text1100005,
                  "Document No.", OldVendLedgEntry."Bill No.");
        END;

        IF IsFromJournal THEN
            CarteraDoc."From Journal" := TRUE;

        ElectPmtMgmt.GetTransferType(CarteraDoc."Account No.", CarteraDoc."Remaining Amount", CarteraDoc."Transfer Type", TRUE);

        OnBeforeCreatePayableDoc(CarteraDoc, GenJnlLine);
        CarteraDoc.INSERT;
        OnAfterCreatePayableDoc(CarteraDoc, GenJnlLine);
        // CVLedgEntryBuf."Document Situation" := CVLedgEntryBuf."Document Situation"::Cartera;
        // CVLedgEntryBuf."Document Status" := CVLedgEntryBuf."Document Status"::Open;
    END;

    //[External]
    PROCEDURE GJLInfoToDoc(VAR GenJnlLine: Record 81; VAR CarteraDoc: Record 7000002);
    VAR
        PaymentMethod: Record 289;
        CompanyInfo: Record 79;
        CustBankAcc: Record 287;
        CustPmtAddress: Record 7000014;
        Cust: Record 18;
    BEGIN
        WITH GenJnlLine DO BEGIN
            CarteraDoc."No." := "Bill No.";
            CarteraDoc."Posting Date" := "Posting Date";
            CarteraDoc."Document No." := "Document No.";
            CarteraDoc."Original Document No." := "Document No.";
            CarteraDoc.Description := Description;
            CarteraDoc."Due Date" := "Due Date";
            CarteraDoc."Payment Method Code" := "Payment Method Code";
            PaymentMethod.GET("Payment Method Code");
            IF PaymentMethod."Submit for Acceptance" THEN
                CarteraDoc.Accepted := CarteraDoc.Accepted::No
            ELSE
                CarteraDoc.Accepted := CarteraDoc.Accepted::"Not Required";
            CarteraDoc."Collection Agent" := PaymentMethod."Collection Agent";
            CarteraDoc."Account No." := "Account No.";
            CarteraDoc."Currency Code" := "Currency Code";
            CarteraDoc."Cust./Vendor Bank Acc. Code" :=
              COPYSTR("Recipient Bank Account", 1, MAXSTRLEN(CarteraDoc."Cust./Vendor Bank Acc. Code"));
            CarteraDoc."Pmt. Address Code" := "Pmt. Address Code";
            CarteraDoc."Global Dimension 1 Code" := "Shortcut Dimension 1 Code";
            CarteraDoc."Global Dimension 2 Code" := "Shortcut Dimension 2 Code";
            CarteraDoc."Dimension Set ID" := "Dimension Set ID";
            CarteraDoc."Direct Debit Mandate ID" := "Direct Debit Mandate ID";
            CASE "Document Type" OF
                "Document Type"::Bill:
                    CarteraDoc."Document Type" := CarteraDoc."Document Type"::Bill;
                "Document Type"::Invoice:
                    CarteraDoc."Document Type" := CarteraDoc."Document Type"::Invoice;
                // "Document Type"::"Credit Memo":
                //     CarteraDoc."Document Type" := CarteraDoc."Document Type"::"1";
            END;
            IF "Account Type" = "Account Type"::Customer THEN BEGIN
                CompanyInfo.GET;
                IF "Recipient Bank Account" <> '' THEN BEGIN
                    CustBankAcc.GET("Account No.", "Recipient Bank Account");
                    CarteraDoc.Place := CompanyInfo."Post Code" = CustBankAcc."Post Code";
                    EXIT;
                END;
                IF "Pmt. Address Code" <> '' THEN BEGIN
                    CustPmtAddress.GET("Account No.", "Pmt. Address Code");
                    CarteraDoc.Place := CompanyInfo."Post Code" = CustPmtAddress."Post Code";
                    EXIT;
                END;
                Cust.GET("Account No.");
                CarteraDoc.Place := CompanyInfo."Post Code" = Cust."Post Code";
            END;
        END;
    END;

    //[External]
    PROCEDURE UpdateReceivableDoc(VAR CustLedgEntry: Record 21; VAR GenJnlLine: Record 81; AppliedAmountLCY: Decimal; VAR DocAmountLCY: Decimal; VAR RejDocAmountLCY: Decimal; VAR DiscDocAmountLCY: Decimal; VAR CollDocAmountLCY: Decimal; VAR DiscRiskFactAmountLCY: Decimal; VAR DiscUnriskFactAmountLCY: Decimal; VAR CollFactAmountLCY: Decimal);
    VAR
        CarteraDoc: Record 7000002;
        PostedCarteraDoc: Record 7000003;
        ClosedCarteraDoc: Record 7000004;
        CarteraDoc2: Record 7000002;
        PostedCarteraDoc2: Record 7000003;
        ClosedCarteraDoc2: Record 7000004;
        PostedBillGroup: Record 7000006;
        Currency: Record 4;
        DocLock: Boolean;
    BEGIN
        WITH CustLedgEntry DO BEGIN
            IF NOT DocLock THEN BEGIN
                DocLock := TRUE;
                CarteraDoc.LOCKTABLE;
                PostedCarteraDoc.LOCKTABLE;
                ClosedCarteraDoc.LOCKTABLE;
                IF CarteraDoc2.FINDLAST THEN;
                IF PostedCarteraDoc2.FINDLAST THEN;
                IF ClosedCarteraDoc2.FINDLAST THEN;
            END;
            IF "Remaining Amount" = 0 THEN
                "Remaining Amt. (LCY)" := 0;
            IF "Document Situation" <> "Document Situation"::Cartera THEN
                AppliedAmountLCY := ROUND(AppliedAmountLCY);
            CASE "Document Situation" OF
                "Document Situation"::" ", "Document Situation"::Cartera:
                    BEGIN
                        CarteraDoc.GET(CarteraDoc.Type::Receivable, "Entry No.");
                        IF CarteraDoc."Currency Code" = '' THEN
                            CarteraDoc."Remaining Amount" := CarteraDoc."Remaining Amount" + AppliedAmountLCY
                        ELSE BEGIN
                            Currency.GET(CarteraDoc."Currency Code");
                            Currency.InitRoundingPrecision;
                            CarteraDoc."Remaining Amount" :=
                              CarteraDoc."Remaining Amount" +
                              ROUND(AppliedAmountLCY * "Original Currency Factor", Currency."Amount Rounding Precision");
                        END;
                        CarteraDoc."Remaining Amt. (LCY)" :=
                          ROUND(CarteraDoc."Remaining Amount" / "Original Currency Factor", Currency."Amount Rounding Precision");

                        AppliedAmountLCY := ROUND(AppliedAmountLCY);
                        IF CarteraDoc."Document Type" = CarteraDoc."Document Type"::Bill THEN
                            DocAmountLCY := DocAmountLCY + AppliedAmountLCY;
                        CarteraDoc.ResetNoPrinted;
                        IF Open THEN
                            CarteraDoc.MODIFY
                        ELSE BEGIN
                            ClosedCarteraDoc.TRANSFERFIELDS(CarteraDoc);
                            ClosedCarteraDoc.Status := ClosedCarteraDoc.Status::Honored;
                            ClosedCarteraDoc."Honored/Rejtd. at Date" := GenJnlLine."Posting Date";
                            ClosedCarteraDoc."Bill Gr./Pmt. Order No." := '';
                            ClosedCarteraDoc."Remaining Amount" := 0;
                            ClosedCarteraDoc."Remaining Amt. (LCY)" := 0;
                            ClosedCarteraDoc."Amount for Collection" := 0;
                            ClosedCarteraDoc."Amt. for Collection (LCY)" := 0;
                            ClosedCarteraDoc.INSERT;
                            CarteraDoc.DELETE;
                            "Document Situation" := "Document Situation"::"Closed Documents";
                            "Document Status" := "Document Status"::Honored;
                            IF "Document Type" <> "Document Type"::Invoice THEN
                                MODIFY;
                        END;
                    END;
                "Document Situation"::"Posted BG/PO":
                    BEGIN
                        PostedCarteraDoc.GET(PostedCarteraDoc.Type::Receivable, "Entry No.");
                        PostedCarteraDoc."Remaining Amount" := "Remaining Amount";
                        PostedCarteraDoc."Remaining Amt. (LCY)" := "Remaining Amt. (LCY)";
                        IF PostedCarteraDoc.Factoring = PostedCarteraDoc.Factoring::" " THEN BEGIN
                            IF PostedCarteraDoc.Status = PostedCarteraDoc.Status::Rejected THEN
                                RejDocAmountLCY := RejDocAmountLCY + AppliedAmountLCY
                            ELSE
                                IF PostedCarteraDoc."Dealing Type" = PostedCarteraDoc."Dealing Type"::Discount THEN
                                    DiscDocAmountLCY := DiscDocAmountLCY + AppliedAmountLCY
                                ELSE
                                    CollDocAmountLCY := CollDocAmountLCY + AppliedAmountLCY;
                        END ELSE
                            CASE TRUE OF
                                PostedCarteraDoc."Dealing Type" = PostedCarteraDoc."Dealing Type"::Discount:
                                    BEGIN
                                        PostedBillGroup.GET(PostedCarteraDoc."Bill Gr./Pmt. Order No.");
                                        IF PostedBillGroup.Factoring = PostedBillGroup.Factoring::Risked THEN
                                            DiscRiskFactAmountLCY := DiscRiskFactAmountLCY + AppliedAmountLCY
                                        ELSE
                                            DiscUnriskFactAmountLCY := DiscUnriskFactAmountLCY + AppliedAmountLCY
                                    END;
                                ELSE
                                    CollFactAmountLCY := CollFactAmountLCY + AppliedAmountLCY;
                            END;

                        UpdateReceivableCurrFact(
                          PostedCarteraDoc, AppliedAmountLCY, DocAmountLCY, RejDocAmountLCY, DiscDocAmountLCY, CollDocAmountLCY,
                          DiscRiskFactAmountLCY, DiscUnriskFactAmountLCY, CollFactAmountLCY);
                        IF NOT Open THEN BEGIN
                            IF GenJnlLine."Document Type" <> GenJnlLine."Document Type"::Payment THEN
                                IF PostedCarteraDoc.Status = ClosedCarteraDoc.Status::Rejected THEN
                                    PostedCarteraDoc.Redrawn := TRUE;
                            PostedCarteraDoc.Status := PostedCarteraDoc.Status::Honored;
                            PostedCarteraDoc."Honored/Rejtd. at Date" := GenJnlLine."Posting Date";
                            PostedCarteraDoc."Remaining Amount" := 0;
                            PostedCarteraDoc."Remaining Amt. (LCY)" := 0;
                            "Document Status" := "Document Status"::Honored;
                            IF PostedCarteraDoc.Redrawn THEN
                                "Document Status" := "Document Status"::Redrawn;
                            MODIFY;
                        END;
                        PostedCarteraDoc.MODIFY;
                    END;
                "Document Situation"::"Closed BG/PO", "Document Situation"::"Closed Documents":
                    BEGIN
                        ClosedCarteraDoc.GET(ClosedCarteraDoc.Type::Receivable, "Entry No.");
                        ClosedCarteraDoc.TESTFIELD(Status, ClosedCarteraDoc.Status::Rejected);
                        ClosedCarteraDoc."Remaining Amount" := "Remaining Amount";
                        ClosedCarteraDoc."Remaining Amt. (LCY)" := "Remaining Amt. (LCY)";
                        IF NOT Open THEN BEGIN
                            IF GenJnlLine."Document Type" <> GenJnlLine."Document Type"::Payment THEN BEGIN
                                ClosedCarteraDoc.Redrawn := TRUE;
                                ClosedCarteraDoc.Status := ClosedCarteraDoc.Status::Rejected;
                                "Document Status" := "Document Status"::Rejected;
                            END ELSE
                                IF "Remaining Amount" = 0 THEN BEGIN
                                    ClosedCarteraDoc.Status := ClosedCarteraDoc.Status::Honored;
                                    "Document Status" := "Document Status"::Honored;
                                END;
                            ClosedCarteraDoc."Remaining Amount" := 0;
                            ClosedCarteraDoc."Remaining Amt. (LCY)" := 0;
                            ClosedCarteraDoc."Honored/Rejtd. at Date" := GenJnlLine."Posting Date";
                            IF ClosedCarteraDoc.Redrawn THEN
                                "Document Status" := "Document Status"::Redrawn;
                            MODIFY;
                        END;
                        ClosedCarteraDoc.MODIFY;
                        MODIFY;
                        IF (ClosedCarteraDoc."Document Type" = ClosedCarteraDoc."Document Type"::Bill) OR
                           (ClosedCarteraDoc."Document Type" = ClosedCarteraDoc."Document Type"::Invoice)
                        THEN
                            RejDocAmountLCY := RejDocAmountLCY + AppliedAmountLCY;
                    END;
            END;
        END;
    END;

    //[External]
    // PROCEDURE UpdatePayableDoc(VAR VendLedgEntry: Record 25; VAR GenJnlLine: Record 81; VAR DocAmountLCY: Decimal; AppliedAmountLCY: Decimal; VAR DocLock: Boolean; VAR CollDocAmountLCY: Decimal);
    // VAR
    //     CarteraDoc: Record 7000002;
    //     PostedCarteraDoc: Record 7000003;
    //     ClosedCarteraDoc: Record 7000004;
    //     CarteraDoc2: Record 7000002;
    //     PostedCarteraDoc2: Record 7000003;
    //     ClosedCarteraDoc2: Record 7000004;
    //     Currency: Record 4;
    // BEGIN
    //     WITH VendLedgEntry DO BEGIN
    //         IF NOT DocLock THEN BEGIN
    //             DocLock := TRUE;
    //             CarteraDoc.LOCKTABLE;
    //             PostedCarteraDoc.LOCKTABLE;
    //             IF CarteraDoc2.FINDLAST THEN;
    //             IF PostedCarteraDoc2.FINDLAST THEN;
    //             IF ClosedCarteraDoc2.FINDLAST THEN;
    //             ClosedCarteraDoc.LOCKTABLE;
    //         END;
    //         IF "Remaining Amount" = 0 THEN
    //             "Remaining Amt. (LCY)" := 0;
    //         IF "Document Situation" <> "Document Situation"::Cartera THEN
    //             AppliedAmountLCY := ROUND(AppliedAmountLCY);
    //         CASE "Document Situation" OF
    //             0, "Document Situation"::Cartera:
    //                 BEGIN
    //                     CarteraDoc.GET(CarteraDoc.Type::Payable, "Entry No.");
    //                     IF CarteraDoc."Currency Code" = '' THEN
    //                         CarteraDoc."Remaining Amount" := CarteraDoc."Remaining Amount" - AppliedAmountLCY
    //                     ELSE BEGIN
    //                         Currency.GET(CarteraDoc."Currency Code");
    //                         Currency.InitRoundingPrecision;
    //                         CarteraDoc."Remaining Amount" :=
    //                           CarteraDoc."Remaining Amount" -
    //                           ROUND(AppliedAmountLCY * "Original Currency Factor", Currency."Amount Rounding Precision");
    //                     END;
    //                     CarteraDoc."Remaining Amt. (LCY)" :=
    //                       ROUND(CarteraDoc."Remaining Amount" / "Original Currency Factor", Currency."Amount Rounding Precision");

    //                     AppliedAmountLCY := ROUND(AppliedAmountLCY);
    //                     IF CarteraDoc."Document Type" = CarteraDoc."Document Type"::Bill THEN
    //                         DocAmountLCY := DocAmountLCY + AppliedAmountLCY;
    //                     CarteraDoc.ResetNoPrinted;
    //                     IF Open THEN
    //                         CarteraDoc.MODIFY
    //                     ELSE BEGIN
    //                         ClosedCarteraDoc.TRANSFERFIELDS(CarteraDoc);
    //                         ClosedCarteraDoc.Status := ClosedCarteraDoc.Status::Honored;
    //                         ClosedCarteraDoc."Honored/Rejtd. at Date" := GenJnlLine."Posting Date";
    //                         ClosedCarteraDoc."Bill Gr./Pmt. Order No." := '';
    //                         ClosedCarteraDoc."Remaining Amount" := 0;
    //                         ClosedCarteraDoc."Remaining Amt. (LCY)" := 0;
    //                         ClosedCarteraDoc."Amount for Collection" := 0;
    //                         ClosedCarteraDoc."Amt. for Collection (LCY)" := 0;
    //                         ClosedCarteraDoc.INSERT;
    //                         CarteraDoc.DELETE;
    //                         "Document Situation" := "Document Situation"::"Closed Documents";
    //                         "Document Status" := "Document Status"::Honored;
    //                         IF "Document Type" <> "Document Type"::Invoice THEN
    //                             MODIFY;
    //                     END;
    //                 END;
    //             "Document Situation"::"Posted BG/PO":
    //                 BEGIN
    //                     PostedCarteraDoc.GET(PostedCarteraDoc.Type::Payable, "Entry No.");
    //                     PostedCarteraDoc."Remaining Amount" := -"Remaining Amount";
    //                     PostedCarteraDoc."Remaining Amt. (LCY)" := -"Remaining Amt. (LCY)";
    //                     CollDocAmountLCY := CollDocAmountLCY + AppliedAmountLCY;
    //                     UpdatePayableCurrFact(PostedCarteraDoc, AppliedAmountLCY, DocAmountLCY, CollDocAmountLCY);
    //                     IF NOT Open THEN BEGIN
    //                         IF PostedCarteraDoc.Status = ClosedCarteraDoc.Status::Rejected THEN
    //                             PostedCarteraDoc.Redrawn := TRUE;
    //                         PostedCarteraDoc.Status := PostedCarteraDoc.Status::Honored;
    //                         PostedCarteraDoc."Honored/Rejtd. at Date" := GenJnlLine."Posting Date";
    //                         PostedCarteraDoc."Remaining Amount" := 0;
    //                         PostedCarteraDoc."Remaining Amt. (LCY)" := 0;
    //                         "Document Status" := "Document Status"::Honored;
    //                         MODIFY;
    //                     END;
    //                     PostedCarteraDoc.MODIFY;
    //                 END;
    //             "Document Situation"::"Closed BG/PO":
    //                 BEGIN
    //                     ClosedCarteraDoc.GET(ClosedCarteraDoc.Type::Payable, "Entry No.");
    //                     ClosedCarteraDoc.TESTFIELD(Status, ClosedCarteraDoc.Status::Rejected);
    //                     ClosedCarteraDoc."Remaining Amount" := "Remaining Amount";
    //                     ClosedCarteraDoc."Remaining Amt. (LCY)" := "Remaining Amt. (LCY)";
    //                     IF NOT Open THEN BEGIN
    //                         IF ClosedCarteraDoc.Status = PostedCarteraDoc.Status::Rejected THEN
    //                             ClosedCarteraDoc.Redrawn := TRUE;
    //                         ClosedCarteraDoc.Status := ClosedCarteraDoc.Status::Honored;
    //                         ClosedCarteraDoc."Remaining Amount" := 0;
    //                         ClosedCarteraDoc."Remaining Amt. (LCY)" := 0;
    //                         ClosedCarteraDoc."Honored/Rejtd. at Date" := GenJnlLine."Posting Date";
    //                     END;
    //                     ClosedCarteraDoc.MODIFY;
    //                 END;
    //         END;
    //     END;
    // END;

    //[External]
    PROCEDURE CheckAppliedReceivableDoc(VAR OldCustLedgEntry: Record 21; SystemCreatedEntry: Boolean);
    BEGIN
        IF (OldCustLedgEntry."Document Situation" = OldCustLedgEntry."Document Situation"::"Posted BG/PO")
           AND NOT SystemCreatedEntry
        THEN
            ERROR(
              Text1100006,
              OldCustLedgEntry."Document Type", OldCustLedgEntry."Document No.",
              OldCustLedgEntry."Bill No.");
    END;

    //[External]
    PROCEDURE CheckAppliedPayableDoc(VAR OldVendLedgEntry: Record 25; SystemCreatedEntry: Boolean);
    BEGIN
        IF (OldVendLedgEntry."Document Situation" = OldVendLedgEntry."Document Situation"::"Posted BG/PO")
           AND NOT SystemCreatedEntry
        THEN
            ERROR(
              Text1100007,
              OldVendLedgEntry."Document Type", OldVendLedgEntry."Document No.",
              OldVendLedgEntry."Bill No.");
    END;

    //[External]
    PROCEDURE CheckPostingDate(CheckDate: Date);
    VAR
        GLSetup: Record 98;
        UserSetup: Record 91;
        AllowPostingTo: Date;
        AllowPostingFrom: Date;
    BEGIN
        GLSetup.GET;
        IF USERID <> '' THEN
            IF UserSetup.GET(USERID) THEN BEGIN
                AllowPostingFrom := UserSetup."Allow Posting From";
                AllowPostingTo := UserSetup."Allow Posting To";
            END;
        IF (AllowPostingFrom = 0D) AND (AllowPostingTo = 0D) THEN BEGIN
            AllowPostingFrom := GLSetup."Allow Posting From";
            AllowPostingTo := GLSetup."Allow Posting To";
        END;
        IF AllowPostingTo = 0D THEN
            AllowPostingTo := 19991231D;
        IF (CheckDate < AllowPostingFrom) OR (CheckDate > AllowPostingTo) THEN
            ERROR(Text1100008,
              CheckDate);
    END;

    //[External]
    PROCEDURE CloseBillGroupIfEmpty(PostedBillGroup: Record 7000006; PostingDate: Date);
    VAR
        PostedCarteraDoc: Record 7000003;
        ClosedCarteraDoc: Record 7000004;
        CustLedgEntry: Record 21;
        ClosedBillGroup: Record 7000007;
    BEGIN
        WITH PostedCarteraDoc DO BEGIN
            RESET;
            SETCURRENTKEY("Bill Gr./Pmt. Order No.", Status);
            SETRANGE("Bill Gr./Pmt. Order No.", PostedBillGroup."No.");
            SETRANGE(Type, Type::Receivable);
            SETRANGE(Status, Status::Open);
            IF NOT FIND('-') THEN BEGIN
                SETRANGE(Status);
                FIND('-');
                REPEAT
                    ClosedCarteraDoc.TRANSFERFIELDS(PostedCarteraDoc);
                    ClosedCarteraDoc.INSERT;
                    CustLedgEntry.GET(ClosedCarteraDoc."Entry No.");
                    CustLedgEntry."Document Situation" := CustLedgEntry."Document Situation"::"Closed BG/PO";
                    CustLedgEntry.MODIFY;
                UNTIL NEXT = 0;
                DELETEALL;
                ClosedBillGroup.TRANSFERFIELDS(PostedBillGroup);
                ClosedBillGroup."Closing Date" := PostingDate;
                ClosedBillGroup.INSERT;
                PostedBillGroup.DELETE;
            END;
        END;
    END;

    //[External]
    PROCEDURE ClosePmtOrdIfEmpty(PostedPmtOrd: Record 7000021; PostingDate: Date);
    VAR
        PostedCarteraDoc: Record 7000003;
        ClosedCarteraDoc: Record 7000004;
        VendLedgEntry: Record 25;
        ClosedPmtOrd: Record 7000022;
    BEGIN
        WITH PostedCarteraDoc DO BEGIN
            RESET;
            SETCURRENTKEY("Bill Gr./Pmt. Order No.", Status);
            SETRANGE("Bill Gr./Pmt. Order No.", PostedPmtOrd."No.");
            SETRANGE(Type, Type::Payable);
            SETRANGE(Status, Status::Open);
            IF NOT FIND('-') THEN BEGIN
                SETRANGE(Status);
                FIND('-');
                REPEAT
                    ClosedCarteraDoc.TRANSFERFIELDS(PostedCarteraDoc);
                    ClosedCarteraDoc.INSERT;
                    VendLedgEntry.GET(ClosedCarteraDoc."Entry No.");
                    VendLedgEntry."Document Situation" := VendLedgEntry."Document Situation"::"Closed BG/PO";
                    VendLedgEntry.MODIFY;
                UNTIL NEXT = 0;
                DELETEALL;
                ClosedPmtOrd.TRANSFERFIELDS(PostedPmtOrd);
                ClosedPmtOrd."Closing Date" := PostingDate;
                ClosedPmtOrd.INSERT;
                PostedPmtOrd.DELETE;
            END;
        END;
    END;

    //[External]
    PROCEDURE CheckDocInfo(VAR GenJnlLine: Record 81; VAR ErrorCounter: Integer; VAR ErrorText: ARRAY[50] OF Text[250]);
    VAR
        CarteraDoc: Record 7000002;
        PaymentMethod: Record 289;
    BEGIN
        WITH GenJnlLine DO BEGIN
            IF ("Document Type" = "Document Type"::Bill) AND
               (Amount <> 0)
            THEN BEGIN
                IF "Bill No." = '' THEN
                    AddError(
                      STRSUBSTNO(Text1100009, FIELDCAPTION("Bill No.")),
                      ErrorCounter,
                      ErrorText);
                IF "Due Date" = 0D THEN
                    AddError(
                      STRSUBSTNO(Text1100009, FIELDCAPTION("Due Date")),
                      ErrorCounter,
                      ErrorText);
                IF "Payment Method Code" = '' THEN
                    AddError(
                      STRSUBSTNO(Text1100009, FIELDCAPTION("Payment Method Code")), ErrorCounter, ErrorText);
                PaymentMethod.GET("Payment Method Code");
                IF NOT PaymentMethod."Create Bills" THEN
                    AddError(
                      STRSUBSTNO(Text1100010, FIELDCAPTION("Payment Method Code")), ErrorCounter, ErrorText);
                IF NOT ("Account Type" IN ["Account Type"::Customer, "Account Type"::Vendor]) THEN
                    AddError(Text1100001, ErrorCounter, ErrorText);
            END;
            IF ("Account Type" = "Account Type"::Customer) AND
               ("Applies-to Doc. Type" = "Applies-to Doc. Type"::Bill) AND
               NOT "System-Created Entry"
            THEN BEGIN
                CarteraDoc.RESET;
                CarteraDoc.SETCURRENTKEY(Type, "Document No.");
                CarteraDoc.SETRANGE(Type, CarteraDoc.Type::Receivable);
                CarteraDoc.SETRANGE("Document No.", "Applies-to Doc. No.");
                CarteraDoc.SETRANGE("No.", "Applies-to Bill No.");
                IF CarteraDoc.FINDFIRST AND (CarteraDoc."Bill Gr./Pmt. Order No." <> '') THEN
                    AddError(Text1100011, ErrorCounter, ErrorText);
            END;
        END;
    END;

    LOCAL PROCEDURE AddError(Text: Text[250]; VAR ErrorCounter: Integer; VAR ErrorText: ARRAY[50] OF Text[250]);
    BEGIN
        ErrorCounter := ErrorCounter + 1;
        ErrorText[ErrorCounter] := Text;
    END;

    //[External]
    PROCEDURE FindDisctdAmt(DocAmount: Decimal; CustomerNo: Code[20]; BankAccCode: Code[20]): Decimal;
    VAR
        CustRating: Record 7000023;
        BankAcc: Record 270;
    BEGIN
        BankAcc.GET(BankAccCode);
        BankAcc.TESTFIELD("Customer Ratings Code");
        CustRating.GET(BankAcc."Customer Ratings Code", BankAcc."Currency Code", CustomerNo);
        CustRating.TESTFIELD(CustRating."Risk Percentage");
        EXIT(DocAmount * CustRating."Risk Percentage" / 100);
    END;

    LOCAL PROCEDURE Code(VAR GenJnlLine: Record 81; VAR PostOk: Boolean; Print: Boolean);
    VAR
        GenJnlTemplate: Record 80;
        GenJnlPostBatch: Codeunit 13;
        TempJnlBatchName: Code[10];
        GLReg: Record 45;
    BEGIN
        WITH GenJnlLine DO BEGIN
            GenJnlTemplate.GET("Journal Template Name");
            GenJnlTemplate.TESTFIELD("Force Posting Report", FALSE);
            IF GenJnlTemplate.Recurring AND (GETFILTER("Posting Date") <> '') THEN
                FIELDERROR("Posting Date", Text1100012);

            IF Print THEN BEGIN
                IF NOT CONFIRM(Text1100013, FALSE) THEN
                    EXIT;
            END ELSE BEGIN
                IF NOT CONFIRM(Text1100014, FALSE) THEN
                    EXIT;
            END;

            TempJnlBatchName := "Journal Batch Name";

            IF Print THEN BEGIN
                GLReg.LOCKTABLE;
                IF GLReg.FINDLAST THEN;
            END;

            GenJnlPostBatch.RUN(GenJnlLine);
            CLEAR(GenJnlPostBatch);

            IF Print THEN BEGIN
                GLReg.SETRANGE("No.", GLReg."No." + 1, "Line No.");
                IF GLReg.GET("Line No.") THEN
                    REPORT.RUN(GenJnlTemplate."Posting Report ID", FALSE, FALSE, GLReg);
            END;

            IF "Line No." = 0 THEN
                MESSAGE(Text1100015)
            ELSE
                IF TempJnlBatchName = "Journal Batch Name" THEN BEGIN
                    MESSAGE(Text1100016);
                    PostOk := TRUE;
                END ELSE
                    MESSAGE(
                      Text1100017,
                      "Journal Batch Name");

            IF NOT FIND('=><') OR (TempJnlBatchName <> "Journal Batch Name") THEN BEGIN
                RESET;
                FILTERGROUP(2);
                SETRANGE("Journal Template Name", "Journal Template Name");
                SETRANGE("Journal Batch Name", "Journal Batch Name");
                FILTERGROUP(0);
                "Line No." := 1;
            END;
        END;
    END;

    //[External]
    PROCEDURE PostLines(VAR GenJnlLine2: Record 81; VAR PostOk: Boolean; Print: Boolean);
    VAR
        GenJnlLine: Record 81;
    BEGIN
        GenJnlLine.COPY(GenJnlLine2);
        Code(GenJnlLine, PostOk, Print);
        GenJnlLine2.COPY(GenJnlLine);
    END;

    //[External]
    PROCEDURE PostSettlement(VAR GenJournalLine: Record 81);
    VAR
        GenJournalLineToPost: Record 81;
        GenJnlPostLine: Codeunit 12;
        GenJnlPostLine2: codeunit 50101;
        UpdateAnalysisView: Codeunit 410;
    BEGIN
        IF GenJournalLine.FINDSET THEN
            REPEAT
                GenJournalLineToPost := GenJournalLine;
                GenJnlPostLine2.SetFromSettlement(TRUE);
                GenJnlPostLine.RUN(GenJournalLineToPost);
            UNTIL GenJournalLine.NEXT = 0;
        UpdateAnalysisView.UpdateAll(0, TRUE);
    END;

    //[External]
    PROCEDURE PostSettlementForPostedPmtOrder(VAR GenJournalLine: Record 81; PostingDate: Date);
    VAR
        GenJournalLineToPost: Record 81;
        PostedPmtOrder: Record 7000021;
        GenJnlPostLine: Codeunit 12;
        GenJnlPostLine2: codeunit 50101;
        UpdateAnalysisView: Codeunit 410;
    BEGIN
        IF GenJournalLine.FINDSET THEN
            REPEAT
                GenJournalLineToPost := GenJournalLine;
                GenJnlPostLine2.SetFromSettlement(TRUE);
                GenJnlPostLine.RUN(GenJournalLineToPost);
                IF PostedPmtOrder.GET(GenJournalLine."Document No.") THEN
                    ClosePmtOrdIfEmpty(PostedPmtOrder, PostingDate);
            UNTIL GenJournalLine.NEXT = 0;
        UpdateAnalysisView.UpdateAll(0, TRUE);
    END;

    //[External]
    PROCEDURE PostSettlementForPostedBillGroup(VAR GenJournalLine: Record 81; PostingDate: Date);
    VAR
        GenJournalLineToPost: Record 81;
        PostedBillGroup: Record 7000006;
        GenJnlPostLine: Codeunit 12;
        GenJnlPostLine2: codeunit 50101;
        UpdateAnalysisView: Codeunit 410;
    BEGIN
        IF GenJournalLine.FINDSET THEN
            REPEAT
                GenJournalLineToPost := GenJournalLine;
                GenJnlPostLine2.SetFromSettlement(TRUE);
                GenJnlPostLine.RUN(GenJournalLineToPost);
                IF PostedBillGroup.GET(GenJournalLine."Document No.") THEN
                    CloseBillGroupIfEmpty(PostedBillGroup, PostingDate);
            UNTIL GenJournalLine.NEXT = 0;
        UpdateAnalysisView.UpdateAll(0, TRUE);
    END;

    //[External]
    PROCEDURE InsertDtldCustLedgEntry(CustLedgEntry2: Record 21; Amount2: Decimal; Amount2LCY: Decimal; EntryType: Enum "Detailed CV Ledger Entry Type"; PostingDate: Date);
    VAR
        DtldCVLedgEntryBuf: Record 379;
        NextDtldBufferEntryNo: Integer;
    BEGIN
        CLEAR(DtldCVLedgEntryBuf);
        DtldCVLedgEntryBuf.RESET;
        IF DtldCVLedgEntryBuf.FINDLAST THEN
            NextDtldBufferEntryNo := DtldCVLedgEntryBuf."Entry No." + 1
        ELSE
            NextDtldBufferEntryNo := 1;

        CustLedgEntry2.CALCFIELDS(Amount);
        DtldCVLedgEntryBuf.INIT;
        DtldCVLedgEntryBuf."Entry No." := NextDtldBufferEntryNo;
        DtldCVLedgEntryBuf."Cust. Ledger Entry No." := CustLedgEntry2."Entry No.";
        //DtldCVLedgEntryBuf."Entry Type" := Enum::"Detailed CV Ledger Entry Type".FromInteger(EntryType); //option to enum
        DtldCVLedgEntryBuf."Entry Type" := EntryType;
        CASE TRUE OF
            EntryType = EntryType::Rejection:
                DtldCVLedgEntryBuf."Excluded from calculation" := TRUE;
            EntryType = EntryType::Redrawal:
                DtldCVLedgEntryBuf."Excluded from calculation" := TRUE;
        END;
        DtldCVLedgEntryBuf."Posting Date" := PostingDate;
        DtldCVLedgEntryBuf."Initial Entry Due Date" := CustLedgEntry2."Due Date";
        DtldCVLedgEntryBuf."Document Type" := CustLedgEntry2."Document Type";
        DtldCVLedgEntryBuf."Document No." := CustLedgEntry2."Document No.";
        DtldCVLedgEntryBuf.Amount := Amount2;
        DtldCVLedgEntryBuf."Amount (LCY)" := Amount2LCY;
        DtldCVLedgEntryBuf."Customer No." := CustLedgEntry2."Customer No.";
        DtldCVLedgEntryBuf."Currency Code" := CustLedgEntry2."Currency Code";
        DtldCVLedgEntryBuf."User ID" := USERID;
        DtldCVLedgEntryBuf."Initial Entry Global Dim. 1" := CustLedgEntry2."Global Dimension 1 Code";
        DtldCVLedgEntryBuf."Initial Entry Global Dim. 2" := CustLedgEntry2."Global Dimension 2 Code";
        DtldCVLedgEntryBuf."Bill No." := CustLedgEntry2."Bill No.";
        DtldCVLedgEntryBuf.INSERT(TRUE);
    END;

    //[External]
    PROCEDURE InsertDtldVendLedgEntry(VendLedgEntry2: Record 25; Amount2: Decimal; Amount2LCY: Decimal; EntryType: Enum "Detailed CV Ledger Entry Type"; PostingDate: Date);
    VAR
        DtldCVLedgEntryBuf: Record 380;
        NextDtldBufferEntryNo: Integer;
    BEGIN
        CLEAR(DtldCVLedgEntryBuf);
        DtldCVLedgEntryBuf.RESET;
        IF DtldCVLedgEntryBuf.FINDLAST THEN
            NextDtldBufferEntryNo := DtldCVLedgEntryBuf."Entry No." + 1
        ELSE
            NextDtldBufferEntryNo := 1;

        VendLedgEntry2.CALCFIELDS(Amount);
        DtldCVLedgEntryBuf.INIT;
        DtldCVLedgEntryBuf."Entry No." := NextDtldBufferEntryNo;
        DtldCVLedgEntryBuf."Vendor Ledger Entry No." := VendLedgEntry2."Entry No.";
        //DtldCVLedgEntryBuf."Entry Type" := Enum::"Detailed CV Ledger Entry Type".FromInteger(EntryType); //option to enum
        DtldCVLedgEntryBuf."Entry Type" := EntryType;
        CASE TRUE OF
            EntryType = EntryType::Rejection:
                DtldCVLedgEntryBuf."Excluded from calculation" := TRUE;
            EntryType = EntryType::Redrawal:
                DtldCVLedgEntryBuf."Excluded from calculation" := TRUE;
        END;
        DtldCVLedgEntryBuf."Posting Date" := PostingDate;
        DtldCVLedgEntryBuf."Initial Entry Due Date" := VendLedgEntry2."Due Date";
        DtldCVLedgEntryBuf."Document Type" := VendLedgEntry2."Document Type";
        DtldCVLedgEntryBuf."Document No." := VendLedgEntry2."Document No.";
        DtldCVLedgEntryBuf.Amount := Amount2;
        DtldCVLedgEntryBuf."Amount (LCY)" := Amount2LCY;
        DtldCVLedgEntryBuf."Vendor No." := VendLedgEntry2."Vendor No.";
        DtldCVLedgEntryBuf."Currency Code" := VendLedgEntry2."Currency Code";
        DtldCVLedgEntryBuf."User ID" := USERID;
        DtldCVLedgEntryBuf."Initial Entry Global Dim. 1" := VendLedgEntry2."Global Dimension 1 Code";
        DtldCVLedgEntryBuf."Initial Entry Global Dim. 2" := VendLedgEntry2."Global Dimension 2 Code";
        DtldCVLedgEntryBuf."Bill No." := VendLedgEntry2."Bill No.";
        DtldCVLedgEntryBuf.INSERT(TRUE);
    END;

    //[External]
    PROCEDURE GetFCYAppliedAmt(AppliedAmountLCY: Decimal; CurrCode: Code[20]; PostingDate: Date): Decimal;
    VAR
        CurrExchRate: Record 330;
        GLSetup: Record 98;
    BEGIN
        IF CurrCode <> '' THEN BEGIN
            GLSetup.GET;
            EXIT(
              ROUND(
                CurrExchRate.ExchangeAmtLCYToFCY(
                  PostingDate,
                  CurrCode,
                  AppliedAmountLCY,
                  CurrExchRate.ExchangeRate(PostingDate, CurrCode)),
                GLSetup."Amount Rounding Precision"));
        END;
        EXIT(AppliedAmountLCY);
    END;

    //[External]
    PROCEDURE UpdateReceivableCurrFact(PostedCarteraDoc: Record 7000003; AppliedAmountLCY: Decimal; VAR DocAmountLCY: Decimal; VAR RejDocAmountLCY: Decimal; VAR DiscDocAmountLCY: Decimal; VAR CollDocAmountLCY: Decimal; VAR DiscRiskFactAmountLCY: Decimal; VAR DiscUnriskFactAmountLCY: Decimal; VAR CollFactAmountLCY: Decimal);
    VAR
        SalesInvHeader: Record 112;
        PostedBillGroup: Record 7000006;
        CurrFact: Decimal;
        CurrExchRate: Record 330;
    BEGIN
        IF SalesInvHeader.GET(PostedCarteraDoc."Document No.") THEN
            IF SalesInvHeader."Currency Factor" <> 0 THEN BEGIN
                IF PostedBillGroup.GET(PostedCarteraDoc."Bill Gr./Pmt. Order No.") THEN;
                CurrFact := CurrExchRate.ExchangeRate(PostedBillGroup."Posting Date", PostedCarteraDoc."Currency Code");
                IF CurrFact <> SalesInvHeader."Currency Factor" THEN
                    IF PostedCarteraDoc.Factoring = PostedCarteraDoc.Factoring::" " THEN BEGIN
                        IF PostedCarteraDoc.Status = PostedCarteraDoc.Status::Rejected THEN
                            DocAmountLCY :=
                              GetCorrectAmounts(RejDocAmountLCY, AppliedAmountLCY, CurrFact, SalesInvHeader."Currency Factor", PostedCarteraDoc)
                        ELSE
                            IF PostedCarteraDoc."Dealing Type" = PostedCarteraDoc."Dealing Type"::Discount THEN
                                DocAmountLCY :=
                                  GetCorrectAmounts(DiscDocAmountLCY, AppliedAmountLCY, CurrFact, SalesInvHeader."Currency Factor", PostedCarteraDoc)
                            ELSE
                                DocAmountLCY :=
                                  GetCorrectAmounts(CollDocAmountLCY, AppliedAmountLCY, CurrFact, SalesInvHeader."Currency Factor", PostedCarteraDoc);
                    END ELSE
                        CASE TRUE OF
                            PostedCarteraDoc."Dealing Type" = PostedCarteraDoc."Dealing Type"::Discount:
                                BEGIN
                                    IF PostedBillGroup.GET(PostedCarteraDoc."Bill Gr./Pmt. Order No.") THEN;
                                    IF PostedBillGroup.Factoring = PostedBillGroup.Factoring::Risked THEN
                                        DocAmountLCY :=
                                          GetCorrectAmounts(
                                            DiscRiskFactAmountLCY, AppliedAmountLCY, CurrFact, SalesInvHeader."Currency Factor", PostedCarteraDoc)
                                    ELSE
                                        DocAmountLCY :=
                                          GetCorrectAmounts(
                                            DiscUnriskFactAmountLCY, AppliedAmountLCY, CurrFact, SalesInvHeader."Currency Factor", PostedCarteraDoc)
                                END;
                            ELSE
                                DocAmountLCY :=
                                  GetCorrectAmounts(CollFactAmountLCY, AppliedAmountLCY, CurrFact, SalesInvHeader."Currency Factor", PostedCarteraDoc)
                        END;
            END;
    END;

    //[External]
    PROCEDURE UpdatePayableCurrFact(PostedCarteraDoc: Record 7000003; AppliedAmountLCY: Decimal; VAR DocAmountLCY: Decimal; VAR CollDocAmountLCY: Decimal);
    VAR
        PurchInvHeader: Record 122;
        PostedPaymentOrder: Record 7000021;
        CurrExchRate: Record 330;
        CurrFact: Decimal;
    BEGIN
        IF PurchInvHeader.GET(PostedCarteraDoc."Document No.") THEN
            IF PurchInvHeader."Currency Factor" <> 0 THEN BEGIN
                IF PostedPaymentOrder.GET(PostedCarteraDoc."Bill Gr./Pmt. Order No.") THEN;
                CurrFact := CurrExchRate.ExchangeRate(PostedPaymentOrder."Posting Date", PostedCarteraDoc."Currency Code");
                IF CurrFact <> PurchInvHeader."Currency Factor" THEN
                    DocAmountLCY :=
                      GetCorrectAmounts(CollDocAmountLCY, AppliedAmountLCY, CurrFact, PurchInvHeader."Currency Factor", PostedCarteraDoc);
            END;
    END;

    //[External]
    PROCEDURE GetCorrectAmounts(VAR Amount: Decimal; AppliedAmountLCY: Decimal; CurrFact: Decimal; InvoiceCurrFact: Decimal; PostedCarteraDoc: Record 7000003): Decimal;
    VAR
        AuxAmount: Decimal;
        AuxAmount2: Decimal;
    BEGIN
        AuxAmount := Amount;
        Amount := ROUND(ROUND(AppliedAmountLCY * InvoiceCurrFact) / CurrFact);
        AuxAmount2 := AuxAmount - Amount;

        IF PostedCarteraDoc.Adjusted XOR PostedCarteraDoc.ReAdjusted THEN
            EXIT(0);
        IF PostedCarteraDoc.ReAdjusted THEN BEGIN
            Amount := Amount - PostedCarteraDoc."Adjusted Amount";
            EXIT(0);
        END;
        EXIT(AuxAmount2);
    END;

    //[External]
    PROCEDURE UpdateUnAppliedReceivableDoc(VAR CustLedgEntry: Record 21; VAR GenJnlLine: Record 81);
    VAR
        CarteraDoc: Record 7000002;
        PostedCarteraDoc: Record 7000003;
        ClosedCarteraDoc: Record 7000004;
        CarteraDoc2: Record 7000002;
        ClosedCarteraDoc2: Record 7000004;
        DocLock: Boolean;
        Text1100101: TextConst ENU = '" Remove it from its bill group and try again."', ESP = '" B�rrelo de la remesa e int�ntelo de nuevo."';
        Text1100102: TextConst ENU = '%1 cannot be unapplied, since it is included in a bill group.', ESP = 'El movimiento %1 est� incluido en una remesa y no se puede desliquidar.';
        InBillGroup: Boolean;
        DtldCustLedgEntry: Record 379;
        IsRejection: Boolean;
    BEGIN
        WITH CustLedgEntry DO BEGIN
            InBillGroup := FALSE;
            IF CarteraDoc.GET(CarteraDoc.Type::Receivable, "Entry No.") THEN
                IF CarteraDoc."Bill Gr./Pmt. Order No." <> '' THEN
                    InBillGroup := TRUE;
            IF PostedCarteraDoc.GET(PostedCarteraDoc.Type::Receivable, "Entry No.") THEN
                IF PostedCarteraDoc."Bill Gr./Pmt. Order No." <> '' THEN
                    InBillGroup := TRUE;
            IF ClosedCarteraDoc.GET(ClosedCarteraDoc.Type::Receivable, "Entry No.") THEN
                IF ClosedCarteraDoc."Bill Gr./Pmt. Order No." <> '' THEN
                    InBillGroup := TRUE;
            IF InBillGroup THEN
                ERROR(
                  Text1100102 +
                  Text1100101,
                  Description);
            CALCFIELDS("Remaining Amount", "Remaining Amt. (LCY)");
            IF NOT DocLock THEN BEGIN
                DocLock := TRUE;
                CarteraDoc.LOCKTABLE;
                ClosedCarteraDoc.LOCKTABLE;
                IF CarteraDoc2.FINDLAST THEN;
                IF ClosedCarteraDoc2.FINDLAST THEN;
            END;
            IF "Remaining Amount" = 0 THEN
                "Remaining Amt. (LCY)" := 0;
            CASE "Document Situation" OF
                "Document Situation"::Cartera:
                    BEGIN
                        CarteraDoc.GET(CarteraDoc.Type::Receivable, "Entry No.");
                        CarteraDoc."Remaining Amount" :=
                          CarteraDoc."Remaining Amount" + GetFCYAppliedAmt("Remaining Amt. (LCY)" - CarteraDoc."Remaining Amt. (LCY)",
                            CarteraDoc."Currency Code", GenJnlLine."Posting Date");
                        CarteraDoc."Remaining Amt. (LCY)" :=
                          CarteraDoc."Remaining Amt. (LCY)" + ("Remaining Amt. (LCY)" - CarteraDoc."Remaining Amt. (LCY)");
                        CarteraDoc.ResetNoPrinted;
                        IF Open THEN
                            CarteraDoc.MODIFY
                    END;
                "Document Situation"::"Closed Documents":
                    BEGIN
                        ClosedCarteraDoc.GET(ClosedCarteraDoc.Type::Receivable, "Entry No.");
                        IsRejection := FALSE;
                        DtldCustLedgEntry.SETCURRENTKEY("Cust. Ledger Entry No.", "Posting Date");
                        DtldCustLedgEntry.SETRANGE("Cust. Ledger Entry No.", "Entry No.");
                        IF DtldCustLedgEntry.FIND('-') THEN
                            REPEAT
                                IF DtldCustLedgEntry."Entry Type" = DtldCustLedgEntry."Entry Type"::Rejection THEN
                                    IsRejection := TRUE;
                            UNTIL DtldCustLedgEntry.NEXT = 0;

                        IF Open THEN
                            IF (IsRejection = TRUE) AND ("Remaining Amount" <> 0) THEN BEGIN
                                ClosedCarteraDoc."Remaining Amount" :=
                                  ClosedCarteraDoc."Remaining Amount" + ("Remaining Amount" - ClosedCarteraDoc."Remaining Amount");
                                ClosedCarteraDoc."Remaining Amt. (LCY)" := ClosedCarteraDoc."Remaining Amt. (LCY)" +
                                  ("Remaining Amt. (LCY)" - ClosedCarteraDoc."Remaining Amt. (LCY)");
                                ClosedCarteraDoc.Status := ClosedCarteraDoc.Status::Rejected;
                                ClosedCarteraDoc.MODIFY;
                                "Document Situation" := "Document Situation"::"Closed Documents";
                                "Document Status" := "Document Status"::Rejected;
                                MODIFY;
                            END ELSE BEGIN
                                CarteraDoc.TRANSFERFIELDS(ClosedCarteraDoc);
                                CarteraDoc.Type := CarteraDoc.Type::Receivable;
                                CarteraDoc."Remaining Amount" := CarteraDoc."Remaining Amount" + "Remaining Amount";
                                CarteraDoc."Remaining Amt. (LCY)" := CarteraDoc."Remaining Amt. (LCY)" + "Remaining Amt. (LCY)";
                                CarteraDoc.INSERT;
                                ClosedCarteraDoc.DELETE;
                                "Document Situation" := "Document Situation"::Cartera;
                                "Document Status" := "Document Status"::Open;
                                MODIFY;
                            END;
                        MODIFY;
                    END;
            END;
        END;
    END;

    //[External]
    PROCEDURE UpdateUnAppliedPayableDoc(VAR VendLedgEntry: Record 25; VAR GenJnlLine: Record 81; VAR DocLock: Boolean);
    VAR
        CarteraDoc: Record 7000002;
        PostedCarteraDoc: Record 7000003;
        ClosedCarteraDoc: Record 7000004;
        CarteraDoc2: Record 7000002;
        ClosedCarteraDoc2: Record 7000004;
        Text1100101: TextConst ENU = '" Remove it from its payment order and try again."', ESP = '" B�rrelo de la orden pago e int�ntelo de nuevo."';
        InBillGroup: Boolean;
        Text1100102: TextConst ENU = '%1 cannot be unapplied, since it is included in a payment order.', ESP = 'El movimiento %1 est� incluido en una orden de pago y no se puede desliquidar.';
    BEGIN
        WITH VendLedgEntry DO BEGIN
            InBillGroup := FALSE;
            IF CarteraDoc.GET(CarteraDoc.Type::Payable, "Entry No.") THEN
                IF CarteraDoc."Bill Gr./Pmt. Order No." <> '' THEN
                    InBillGroup := TRUE;
            IF PostedCarteraDoc.GET(PostedCarteraDoc.Type::Payable, "Entry No.") THEN
                IF PostedCarteraDoc."Bill Gr./Pmt. Order No." <> '' THEN
                    InBillGroup := TRUE;
            IF ClosedCarteraDoc.GET(ClosedCarteraDoc.Type::Payable, "Entry No.") THEN
                IF ClosedCarteraDoc."Bill Gr./Pmt. Order No." <> '' THEN
                    InBillGroup := TRUE;
            IF InBillGroup THEN
                ERROR(
                  Text1100102 +
                  Text1100101,
                  Description);
            CALCFIELDS("Remaining Amount", "Remaining Amt. (LCY)");
            IF NOT DocLock THEN BEGIN
                DocLock := TRUE;
                CarteraDoc.LOCKTABLE;
                IF CarteraDoc2.FINDLAST THEN;
                IF ClosedCarteraDoc2.FINDLAST THEN;
                ClosedCarteraDoc.LOCKTABLE;
            END;
            IF "Remaining Amount" = 0 THEN
                "Remaining Amt. (LCY)" := 0;
            CASE "Document Situation" OF
                "Document Situation"::Cartera:
                    BEGIN
                        CarteraDoc.GET(CarteraDoc.Type::Payable, "Entry No.");
                        CarteraDoc."Remaining Amount" :=
                          CarteraDoc."Remaining Amount" - GetFCYAppliedAmt("Remaining Amt. (LCY)" + CarteraDoc."Remaining Amt. (LCY)",
                            CarteraDoc."Currency Code", GenJnlLine."Posting Date");
                        CarteraDoc."Remaining Amt. (LCY)" :=
                          CarteraDoc."Remaining Amt. (LCY)" - ("Remaining Amt. (LCY)" + CarteraDoc."Remaining Amt. (LCY)");
                        CarteraDoc.ResetNoPrinted;
                        IF Open THEN
                            CarteraDoc.MODIFY
                    END;
                "Document Situation"::"Closed Documents":
                    BEGIN
                        ClosedCarteraDoc.GET(ClosedCarteraDoc.Type::Payable, "Entry No.");
                        IF Open THEN BEGIN
                            CarteraDoc.TRANSFERFIELDS(ClosedCarteraDoc);
                            CarteraDoc.Type := CarteraDoc.Type::Payable;
                            CarteraDoc."Remaining Amount" := CarteraDoc."Remaining Amount" - "Remaining Amount";
                            CarteraDoc."Remaining Amt. (LCY)" := CarteraDoc."Remaining Amt. (LCY)" - "Remaining Amt. (LCY)";
                            CarteraDoc.INSERT;
                            ClosedCarteraDoc.DELETE;
                            "Document Situation" := "Document Situation"::Cartera;
                            "Document Status" := "Document Status"::Open;
                            MODIFY;
                        END;
                        MODIFY;
                    END;
            END;
        END;
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterCreateReceivableDoc(VAR CarteraDoc: Record 7000002; GenJournalLine: Record 81);
    BEGIN
    END;

    [IntegrationEvent(true, false)]
    LOCAL PROCEDURE OnAfterCreatePayableDoc(VAR CarteraDoc: Record 7000002; GenJournalLine: Record 81);
    BEGIN
    END;

    [IntegrationEvent(true,false)]
    LOCAL PROCEDURE OnBeforeCreateReceivableDoc(VAR CarteraDoc: Record 7000002; GenJournalLine: Record 81);
    BEGIN
    END;

    [IntegrationEvent(true,false)]
    LOCAL PROCEDURE OnBeforeCreatePayableDoc(VAR CarteraDoc: Record 7000002; GenJournalLine: Record 81);
    BEGIN
    END;


    /* BEGIN
END.*/
}





