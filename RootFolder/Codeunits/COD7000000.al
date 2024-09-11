Codeunit 50033 "CarteraManagement 1"
{


    // Permissions = TableData 21 = m,
    //             TableData 25 = m,
    //             TableData 254 = imd,
    //             TableData 7000002 = m,
    //             TableData 7000003 = m,
    //             TableData 7000004 = m,
    //             TableData 7000005 = m;
    // trigger OnRun()
    // BEGIN
    // END;

    VAR
        Text1100000: TextConst ENU = 'The Bill Group does not exist.', ESP = 'La remesa no existe.';
        Text1100001: TextConst ENU = 'This Bill Group has already been printed. Proceed anyway?', ESP = 'La remesa ya se ha impreso. �Confirma qu� desea continuar?';
        Text1100002: TextConst ENU = 'The process has been interrupted to respect the warning.', ESP = 'Se ha interrumpido el proceso para respetar la advertencia.';
        Text1100003: TextConst ENU = 'The Payment Order does not exist.', ESP = 'La orden de pago no existe.';
        Text1100004: TextConst ENU = 'This Payment Order has already been printed. Proceed anyway?', ESP = 'La orden de pago ya se ha impreso. �Confirma qu� desea continuar?';
        Text1100005: TextConst ENU = 'The update has been interrupted to respect the warning.', ESP = 'Se ha interrumpido la actualizaci�n para respetar la advertencia.';
        Text1100006: TextConst ENU = 'Document settlement %1/%2', ESP = 'Liq. documento %1/%2';
        Text1100007: TextConst ENU = 'Bill %1/%2 settl. rev.', ESP = 'Reversi�n efecto %1/%2';
        Text1100008: TextConst ENU = 'Redrawing a settled bill is only possible for bills in posted or closed bill groups.', ESP = 'S�lo se pueden recircular efectos liquidados que pertenecen a remesas registradas o cerradas.';
        Text1100009: TextConst ENU = 'Redrawing a settled bill is only possible for bills in posted or closed payment orders.', ESP = 'S�lo se pueden recircular efectos liquidados que pertenecen a �rdenes de pago registradas o cerradas.';
        VATPostingSetup: Record 325;
        VATEntryNo: Integer;
        VATUnrealAcc: Code[20];
        VATAcc: Code[20];
        TotalVATAmount: Decimal;
        Text1100010: TextConst ENU = 'The document %1/%2 is marked to apply.', ESP = 'El documento %1/%2 est� marcado para liquidar.';
        GenJnlPostLine: Codeunit 12;
        ElectPmtMgmt: Codeunit 10701;

    // PROCEDURE CategorizeDocs(VAR Doc: Record 7000002);
    // BEGIN
    //     REPORT.RUNMODAL(REPORT::"Categorize Documents", TRUE, FALSE, Doc);
    // END;

    // PROCEDURE DecategorizeDocs(VAR Doc: Record 7000002);
    // BEGIN
    //     Doc.MODIFYALL("Category Code", '');
    // END;

    // PROCEDURE CategorizePostedDocs(VAR PostedDoc: Record 7000003);
    // BEGIN
    //     REPORT.RUNMODAL(REPORT::"Categorize Posted Documents", TRUE, FALSE, PostedDoc);
    // END;

    // PROCEDURE DecategorizePostedDocs(VAR PostedDoc: Record 7000003);
    // BEGIN
    //     PostedDoc.MODIFYALL("Category Code", '');
    // END;

    // PROCEDURE UpdateStatistics(VAR Doc2: Record 7000002; VAR CurrTotalAmount: Decimal; VAR ShowCurrent: Boolean);
    // VAR
    //     Doc: Record 7000002;
    // BEGIN
    //     WITH Doc DO BEGIN
    //         COPY(Doc2);
    //         SETCURRENTKEY(Type, "Bill Gr./Pmt. Order No.", "Collection Agent", "Due Date", "Global Dimension 1 Code",
    //           "Global Dimension 2 Code", "Category Code", "Posting Date", "Document No.", Accepted, "Currency Code", "Document Type");
    //         ShowCurrent := CALCSUMS("Remaining Amt. (LCY)");
    //         IF ShowCurrent THEN
    //             CurrTotalAmount := "Remaining Amt. (LCY)"
    //         ELSE
    //             CurrTotalAmount := 0;
    //     END;
    // END;

    // PROCEDURE NavigateDoc(VAR CarteraDoc: Record 7000002);
    // VAR
    //     Navigate: Page 344;
    //     VendLedgEntry: Record 25;
    //     CustLedgEntry: Record 21;
    // BEGIN
    //     WITH CarteraDoc DO BEGIN
    //         CASE Type OF
    //             Type::Receivable:
    //                 BEGIN
    //                     IF NOT CustLedgEntry.GET("Entry No.") THEN
    //                         EXIT;
    //                     Navigate.SetDoc(CustLedgEntry."Posting Date", CustLedgEntry."Document No.");
    //                 END;
    //             Type::Payable:
    //                 BEGIN
    //                     IF NOT VendLedgEntry.GET("Entry No.") THEN
    //                         EXIT;
    //                     Navigate.SetDoc(VendLedgEntry."Posting Date", VendLedgEntry."Document No.");
    //                 END;
    //         END;
    //         Navigate.RUN;
    //     END;
    // END;

    // PROCEDURE NavigatePostedDoc(VAR PostedCarteraDoc: Record 7000003);
    // VAR
    //     Navigate: Page 344;
    //     VendLedgEntry: Record 25;
    //     CustLedgEntry: Record 21;
    // BEGIN
    //     WITH PostedCarteraDoc DO BEGIN
    //         CASE Type OF
    //             Type::Receivable:
    //                 BEGIN
    //                     IF NOT CustLedgEntry.GET("Entry No.") THEN
    //                         EXIT;
    //                     Navigate.SetDoc(CustLedgEntry."Posting Date", CustLedgEntry."Document No.");
    //                 END;
    //             Type::Payable:
    //                 BEGIN
    //                     IF NOT VendLedgEntry.GET("Entry No.") THEN
    //                         EXIT;
    //                     Navigate.SetDoc(VendLedgEntry."Posting Date", VendLedgEntry."Document No.");
    //                 END;
    //         END;
    //         Navigate.RUN;
    //     END;
    // END;

    // PROCEDURE NavigateClosedDoc(VAR ClosedCarteraDoc: Record 7000004);
    // VAR
    //     Navigate: Page 344;
    //     VendLedgEntry: Record 25;
    //     CustLedgEntry: Record 21;
    // BEGIN
    //     WITH ClosedCarteraDoc DO BEGIN
    //         CASE Type OF
    //             Type::Receivable:
    //                 BEGIN
    //                     IF NOT CustLedgEntry.GET("Entry No.") THEN
    //                         EXIT;
    //                     Navigate.SetDoc(CustLedgEntry."Posting Date", CustLedgEntry."Document No.");
    //                 END;
    //             Type::Payable:
    //                 BEGIN
    //                     IF NOT VendLedgEntry.GET("Entry No.") THEN
    //                         EXIT;
    //                     Navigate.SetDoc(VendLedgEntry."Posting Date", VendLedgEntry."Document No.");
    //                 END;
    //         END;
    //         Navigate.RUN;
    //     END;
    // END;

    // PROCEDURE InsertReceivableDocs(VAR CarteraDoc2: Record 7000002);
    // VAR
    //     CarteraDoc: Record 7000002;
    //     BankAcc: Record 270;
    //     BillGr: Record 7000005;
    //     CarteraSetup: Record 7000016;
    //     CustLedgEntry: Record 21;
    //     CarteraDocuments: Page 7000003;
    //     CheckDiscCreditLimit: Page 7000037;
    //     SelectedAmount: Decimal;
    //     GroupNo: Code[20];
    //     Cust: Record 18;
    // BEGIN
    //     CarteraDoc2.FILTERGROUP(2);
    //     CarteraDoc2.SETRANGE("Bill Gr./Pmt. Order No.");
    //     CarteraDoc2.FILTERGROUP(0);
    //     GroupNo := CarteraDoc2.GETRANGEMIN("Bill Gr./Pmt. Order No.");
    //     IF NOT BillGr.GET(GroupNo) THEN
    //         ERROR(Text1100000);

    //     IF BillGr."No. Printed" <> 0 THEN
    //         IF NOT CONFIRM(Text1100001, FALSE) THEN
    //             EXIT;

    //     WITH CarteraDoc DO BEGIN
    //         RESET;
    //         SETCURRENTKEY(Type, "Collection Agent", "Bill Gr./Pmt. Order No.", "Currency Code", Accepted);
    //         FILTERGROUP(2);
    //         SETRANGE(Type, Type::Receivable);
    //         FILTERGROUP(0);
    //         SETRANGE("Bill Gr./Pmt. Order No.", '');
    //         SETRANGE("Currency Code", BillGr."Currency Code");
    //         SETFILTER(Accepted, '<>%1', Accepted::No);
    //         SETRANGE("Collection Agent", "Collection Agent"::Bank);
    //         IF BillGr.Factoring <> BillGr.Factoring::" " THEN
    //             SETFILTER("Document Type", '<>%1', "Document Type"::Bill)
    //         ELSE
    //             SETRANGE("Document Type", "Document Type"::Bill);
    //         OnInsertReceivableDocsOnAfterSetFilters(CarteraDoc);
    //         CarteraDocuments.SETTABLEVIEW(CarteraDoc);
    //         CarteraDocuments.LOOKUPMODE(TRUE);
    //         IF CarteraDocuments.RUNMODAL <> ACTION::LookupOK THEN
    //             EXIT;
    //         CarteraDocuments.GetSelected(CarteraDoc);
    //         CLEAR(CarteraDocuments);
    //         IF NOT FIND('-') THEN
    //             EXIT;

    //         IF (BillGr."Dealing Type" = BillGr."Dealing Type"::Discount) AND
    //            BankAcc.GET(BillGr."Bank Account No.") AND
    //            (BillGr.Factoring = BillGr.Factoring::" ")
    //         THEN BEGIN
    //             CarteraSetup.GET;
    //             IF CarteraSetup."Bills Discount Limit Warnings" THEN BEGIN
    //                 SelectedAmount := 0;
    //                 REPEAT
    //                     SelectedAmount := SelectedAmount + "Remaining Amt. (LCY)";
    //                 UNTIL NEXT = 0;
    //                 BillGr.CALCFIELDS(Amount);
    //                 BankAcc.CALCFIELDS("Posted Receiv. Bills Rmg. Amt.");
    //                 IF BillGr.Amount + SelectedAmount + BankAcc."Posted Receiv. Bills Rmg. Amt." > BankAcc."Credit Limit for Discount"
    //                 THEN BEGIN
    //                     CheckDiscCreditLimit.SETRECORD(BankAcc);
    //                     CheckDiscCreditLimit.SetValues(BillGr.Amount, SelectedAmount);
    //                     IF CheckDiscCreditLimit.RUNMODAL <> ACTION::Yes THEN
    //                         ERROR(Text1100002);
    //                     CLEAR(CheckDiscCreditLimit);
    //                 END;
    //             END;
    //         END;

    //         // check the selected bills and insert them
    //         SETCURRENTKEY(Type, "Entry No.");
    //         FIND('-');
    //         REPEAT
    //             IF CustLedgEntry.GET("Entry No.") THEN
    //                 IF CustLedgEntry."Applies-to ID" <> '' THEN
    //                     ERROR(Text1100010, "Document No.", "No.");
    //             TESTFIELD(Type, Type::Receivable);
    //             TESTFIELD("Bill Gr./Pmt. Order No.", '');
    //             TESTFIELD("Currency Code", BillGr."Currency Code");
    //             IF Cust."No." <> "Account No." THEN
    //                 Cust.GET("Account No.");
    //             Cust.CheckBlockedCustOnJnls(Cust, Enum::"Gen. Journal Document Type".FromInteger(GetDocType("Document Type")), FALSE);
    //             IF Accepted = Accepted::No THEN
    //                 FIELDERROR(Accepted);
    //             TESTFIELD("Collection Agent", "Collection Agent"::Bank);
    //             "Bill Gr./Pmt. Order No." := GroupNo;
    //             MODIFY;
    //             IF CustLedgEntry.GET("Entry No.") THEN BEGIN
    //                 CustLedgEntry."Document Situation" := CustLedgEntry."Document Situation"::"BG/PO";
    //                 CustLedgEntry.MODIFY;
    //                 "Direct Debit Mandate ID" := CustLedgEntry."Direct Debit Mandate ID";
    //             END;
    //             OnAfterInsertReceivableDocs(CarteraDoc, BillGr);
    //         UNTIL NEXT = 0;

    //         BillGr."No. Printed" := 0;
    //         BillGr.MODIFY;
    //     END;
    // END;

    // PROCEDURE InsertPayableDocs(VAR CarteraDoc2: Record 7000002);
    // VAR
    //     CarteraDoc: Record 7000002;
    //     PmtOrd: Record 7000020;
    //     CarteraSetup: Record 7000016;
    //     VendLedgEntry: Record 25;
    //     CarteraDocuments: Page 7000003;
    //     GroupNo: Code[20];
    //     Vend: Record 23;
    // BEGIN
    //     CarteraDoc2.FILTERGROUP(2);
    //     CarteraDoc2.SETRANGE("Bill Gr./Pmt. Order No.");
    //     CarteraDoc2.FILTERGROUP(0);
    //     GroupNo := CarteraDoc2.GETRANGEMIN("Bill Gr./Pmt. Order No.");
    //     IF NOT PmtOrd.GET(GroupNo) THEN
    //         ERROR(Text1100003);

    //     IF PmtOrd."No. Printed" <> 0 THEN
    //         IF NOT CONFIRM(Text1100004, FALSE) THEN
    //             EXIT;

    //     CarteraSetup.GET;
    //     WITH CarteraDoc DO BEGIN
    //         RESET;
    //         SETCURRENTKEY(Type, "Collection Agent", "Bill Gr./Pmt. Order No.", "Currency Code", Accepted);
    //         FILTERGROUP(2);
    //         SETRANGE(Type, Type::Payable);
    //         FILTERGROUP(0);
    //         SETRANGE("Bill Gr./Pmt. Order No.", '');
    //         SETRANGE("Currency Code", PmtOrd."Currency Code");
    //         SETFILTER(Accepted, '<>%1', Accepted::No);
    //         SETRANGE("Collection Agent", "Collection Agent"::Bank);
    //         SETRANGE("On Hold", FALSE);
    //         OnInsertPayableDocsOnAfterSetFilters(CarteraDoc);
    //         CarteraDocuments.SETTABLEVIEW(CarteraDoc);
    //         CarteraDocuments.LOOKUPMODE(TRUE);
    //         IF CarteraDocuments.RUNMODAL <> ACTION::LookupOK THEN
    //             EXIT;
    //         CarteraDocuments.GetSelected(CarteraDoc);
    //         CLEAR(CarteraDocuments);
    //         IF NOT FIND('-') THEN
    //             EXIT;

    //         // check the selected bills and insert them
    //         SETCURRENTKEY(Type, "Entry No.");
    //         FIND('-');
    //         REPEAT
    //             IF VendLedgEntry.GET("Entry No.") THEN
    //                 IF VendLedgEntry."Applies-to ID" <> '' THEN
    //                     ERROR(Text1100010, "Document No.", "No.");
    //             TESTFIELD(Type, Type::Payable);
    //             TESTFIELD("Bill Gr./Pmt. Order No.", '');
    //             TESTFIELD("Currency Code", PmtOrd."Currency Code");
    //             IF Vend."No." <> "Account No." THEN
    //                 Vend.GET("Account No.");

    //             IF PmtOrd."Export Electronic Payment" THEN
    //                 ElectPmtMgmt.GetTransferType("Account No.", "Remaining Amount", "Transfer Type", FALSE);

    //             Vend.CheckBlockedVendOnJnls(Vend, Enum::"Gen. Journal Document Type".FromInteger(GetDocType("Document Type")), FALSE);
    //             IF Accepted = Accepted::No THEN
    //                 FIELDERROR(Accepted);
    //             TESTFIELD("Collection Agent", "Collection Agent"::Bank);
    //             "Bill Gr./Pmt. Order No." := GroupNo;
    //             MODIFY(TRUE);
    //             IF VendLedgEntry.GET("Entry No.") THEN BEGIN
    //                 VendLedgEntry."Document Situation" := VendLedgEntry."Document Situation"::"BG/PO";
    //                 VendLedgEntry.MODIFY;
    //             END;
    //             OnAfterInsertPayableDocs(CarteraDoc, PmtOrd);
    //         UNTIL NEXT = 0;

    //         PmtOrd."No. Printed" := 0;
    //         PmtOrd.MODIFY;
    //     END;
    // END;

    // PROCEDURE RemoveReceivableDocs(VAR Doc2: Record 7000002);
    // VAR
    //     BillGr: Record 7000005;
    //     CustLedgEntry: Record 21;
    // BEGIN
    //     WITH Doc2 DO
    //         IF FIND('-') THEN BEGIN
    //             BillGr.GET("Bill Gr./Pmt. Order No.");
    //             IF BillGr."No. Printed" <> 0 THEN
    //                 IF NOT CONFIRM(Text1100001, FALSE) THEN
    //                     EXIT;
    //             BillGr."No. Printed" := 0;
    //             REPEAT
    //                 RemoveReceivableError(Doc2);
    //                 "Bill Gr./Pmt. Order No." := '';
    //                 MODIFY;
    //                 IF CustLedgEntry.GET("Entry No.") THEN BEGIN
    //                     CustLedgEntry."Document Situation" := CustLedgEntry."Document Situation"::Cartera;
    //                     CustLedgEntry.MODIFY;
    //                 END;
    //             UNTIL NEXT = 0;
    //             BillGr.MODIFY;
    //         END;
    // END;

    // PROCEDURE RemovePayableDocs(VAR Doc2: Record 7000002);
    // VAR
    //     PmtOrd: Record 7000020;
    //     VendLedgEntry: Record 25;
    // BEGIN
    //     WITH Doc2 DO
    //         IF FIND('-') THEN BEGIN
    //             PmtOrd.GET("Bill Gr./Pmt. Order No.");
    //             IF PmtOrd."No. Printed" <> 0 THEN
    //                 IF NOT CONFIRM(Text1100004, FALSE) THEN
    //                     EXIT;
    //             PmtOrd."No. Printed" := 0;
    //             REPEAT
    //                 RemovePayableError(Doc2);
    //                 "Bill Gr./Pmt. Order No." := '';
    //                 MODIFY;
    //                 IF VendLedgEntry.GET("Entry No.") THEN BEGIN
    //                     VendLedgEntry."Document Situation" := VendLedgEntry."Document Situation"::Cartera;
    //                     VendLedgEntry.MODIFY;
    //                 END;
    //             UNTIL NEXT = 0;
    //             PmtOrd.MODIFY;
    //         END;
    // END;

    // PROCEDURE CheckDiscCreditLimit(VAR BillGr: Record 7000005);
    // VAR
    //     CarteraSetup: Record 7000016;
    //     BankAcc: Record 270;
    //     CheckDiscCreditLimit: Page 7000037;
    // BEGIN
    //     WITH BillGr DO BEGIN
    //         CarteraSetup.GET;
    //         IF NOT CarteraSetup."Bills Discount Limit Warnings" THEN
    //             EXIT;
    //         IF ("Dealing Type" = "Dealing Type"::Discount) AND BankAcc.GET("Bank Account No.") THEN BEGIN
    //             BankAcc.CALCFIELDS("Posted Receiv. Bills Rmg. Amt.");
    //             CALCFIELDS(Amount);
    //             IF Amount + BankAcc."Posted Receiv. Bills Rmg. Amt." > BankAcc."Credit Limit for Discount" THEN BEGIN
    //                 CheckDiscCreditLimit.SETRECORD(BankAcc);
    //                 CheckDiscCreditLimit.SetValues(Amount, 0);
    //                 IF CheckDiscCreditLimit.RUNMODAL <> ACTION::Yes THEN
    //                     ERROR(Text1100005);
    //                 CLEAR(CheckDiscCreditLimit);
    //             END;
    //         END;
    //     END;
    // END;

    // PROCEDURE CreateReceivableDocPayment(VAR GenJnlLine2: Record 81; VAR CustLedgEntry: Record 21);
    // VAR
    //     PostedDoc: Record 7000003;
    // BEGIN
    //     WITH GenJnlLine2 DO BEGIN
    //         "Account Type" := "Account Type"::Customer;
    //         VALIDATE("Account No.", CustLedgEntry."Customer No.");
    //         "Document Type" := "Document Type"::" ";
    //         "Document No." := CustLedgEntry."Document No.";
    //         "Bill No." := CustLedgEntry."Bill No.";
    //         Description := STRSUBSTNO(
    //             Text1100006,
    //             CustLedgEntry."Document No.",
    //             CustLedgEntry."Bill No.");
    //         VALIDATE("Currency Code", CustLedgEntry."Currency Code");
    //         CustLedgEntry.CALCFIELDS("Remaining Amount", "Remaining Amt. (LCY)");
    //         CASE CustLedgEntry."Document Situation" OF
    //             CustLedgEntry."Document Situation"::"Posted BG/PO":
    //                 BEGIN
    //                     PostedDoc.GET(PostedDoc.Type::Receivable, CustLedgEntry."Entry No.");
    //                     VALIDATE(Amount, -PostedDoc."Remaining Amount");
    //                 END;
    //             CustLedgEntry."Document Situation"::"Closed BG/PO", CustLedgEntry."Document Situation"::"Closed Documents":
    //                 VALIDATE(Amount, -CustLedgEntry."Remaining Amount");
    //         END;
    //         "Dimension Set ID" := GetCombinedDimSetID(GenJnlLine2, CustLedgEntry."Dimension Set ID");
    //         "System-Created Entry" := TRUE;
    //         "Applies-to Doc. Type" := "Document Type"::Bill;
    //         "Applies-to Doc. No." := CustLedgEntry."Document No.";
    //         "Applies-to Bill No." := CustLedgEntry."Bill No.";
    //     END;

    //     OnAfterCreateReceivableDocPayment(GenJnlLine2, CustLedgEntry);
    // END;

    // PROCEDURE ReverseReceivableDocPayment(VAR GenJnlLine2: Record 81; VAR CustLedgEntry: Record 21);
    // VAR
    //     PostedDoc: Record 7000003;
    //     ClosedDoc: Record 7000004;
    //     PostedBillGr: Record 7000006;
    //     ClosedBillGr: Record 7000007;
    // BEGIN
    //     WITH GenJnlLine2 DO BEGIN
    //         "Account Type" := "Account Type"::"Bank Account";
    //         "Document No." := CustLedgEntry."Document No.";
    //         "Bill No." := CustLedgEntry."Bill No.";
    //         Description := STRSUBSTNO(
    //             Text1100007,
    //             CustLedgEntry."Document No.",
    //             CustLedgEntry."Bill No.");
    //         VALIDATE("Currency Code", CustLedgEntry."Currency Code");
    //         "System-Created Entry" := TRUE;
    //         IF PostedDoc.GET(PostedDoc.Type::Receivable, CustLedgEntry."Entry No.") THEN BEGIN
    //             PostedBillGr.GET(PostedDoc."Bill Gr./Pmt. Order No.");
    //             VALIDATE("Account No.", PostedBillGr."Bank Account No.");
    //             VALIDATE(Amount, -PostedDoc."Amount for Collection");
    //             PostedDoc.TESTFIELD(Redrawn, FALSE);
    //             PostedDoc.Redrawn := TRUE;
    //             PostedDoc.MODIFY;
    //         END ELSE
    //             IF ClosedDoc.GET(ClosedDoc.Type::Receivable, CustLedgEntry."Entry No.") THEN BEGIN
    //                 IF ClosedDoc."Bill Gr./Pmt. Order No." = '' THEN
    //                     ERROR(Text1100008);
    //                 ClosedBillGr.GET(ClosedDoc."Bill Gr./Pmt. Order No.");
    //                 VALIDATE("Account No.", ClosedBillGr."Bank Account No.");
    //                 VALIDATE(Amount, -ClosedDoc."Amount for Collection");
    //                 ClosedDoc.TESTFIELD(Redrawn, FALSE);
    //                 ClosedDoc.Redrawn := TRUE;
    //                 ClosedDoc.MODIFY;
    //             END;
    //         "Dimension Set ID" := GetCombinedDimSetID(GenJnlLine2, CustLedgEntry."Dimension Set ID");
    //     END;

    //     OnAfterReverseReceivableDocPayment(GenJnlLine2, CustLedgEntry);
    // END;

    // PROCEDURE CreatePayableDocPayment(VAR GenJnlLine2: Record 81; VAR VendLedgEntry: Record 25);
    // VAR
    //     PostedDoc: Record 7000003;
    // BEGIN
    //     WITH GenJnlLine2 DO BEGIN
    //         "Account Type" := "Account Type"::Vendor;
    //         VALIDATE("Account No.", VendLedgEntry."Vendor No.");
    //         "Document Type" := "Document Type"::" ";
    //         "Document No." := VendLedgEntry."Document No.";
    //         "Bill No." := VendLedgEntry."Bill No.";
    //         Description := STRSUBSTNO(
    //             Text1100006,
    //             VendLedgEntry."Document No.",
    //             VendLedgEntry."Bill No.");
    //         VALIDATE("Currency Code", VendLedgEntry."Currency Code");
    //         CASE VendLedgEntry."Document Situation" OF
    //             VendLedgEntry."Document Situation"::"Posted BG/PO":
    //                 BEGIN
    //                     PostedDoc.GET(PostedDoc.Type::Payable, VendLedgEntry."Entry No.");
    //                     VALIDATE(Amount, -PostedDoc."Remaining Amount");
    //                 END;
    //             VendLedgEntry."Document Situation"::"Closed BG/PO":
    //                 VALIDATE(Amount, -VendLedgEntry."Remaining Amount");
    //         END;
    //         "Dimension Set ID" := GetCombinedDimSetID(GenJnlLine2, VendLedgEntry."Dimension Set ID");
    //         "System-Created Entry" := TRUE;
    //         "Applies-to Doc. Type" := "Document Type"::Bill;
    //         "Applies-to Doc. No." := VendLedgEntry."Document No.";
    //         "Applies-to Bill No." := VendLedgEntry."Bill No.";
    //     END;

    //     OnAfterCreatePayableDocPayment(GenJnlLine2, VendLedgEntry);
    // END;

    // PROCEDURE ReversePayableDocPayment(VAR GenJnlLine2: Record 81; VAR VendLedgEntry: Record 25);
    // VAR
    //     PostedDoc: Record 7000003;
    //     ClosedDoc: Record 7000004;
    //     PostedPmtOrd: Record 7000021;
    //     ClosedPmtOrd: Record 7000022;
    // BEGIN
    //     WITH GenJnlLine2 DO BEGIN
    //         "Account Type" := "Account Type"::"Bank Account";
    //         "Document No." := VendLedgEntry."Document No.";
    //         "Bill No." := VendLedgEntry."Bill No.";
    //         Description := STRSUBSTNO(
    //             Text1100007,
    //             VendLedgEntry."Document No.",
    //             VendLedgEntry."Bill No.");
    //         VALIDATE("Currency Code", VendLedgEntry."Currency Code");
    //         "System-Created Entry" := TRUE;
    //         IF PostedDoc.GET(PostedDoc.Type::Payable, VendLedgEntry."Entry No.") THEN BEGIN
    //             PostedPmtOrd.GET(PostedDoc."Bill Gr./Pmt. Order No.");
    //             VALIDATE("Account No.", PostedPmtOrd."Bank Account No.");
    //             VALIDATE(Amount, PostedDoc."Amount for Collection");
    //             PostedDoc.TESTFIELD(Redrawn, FALSE);
    //             PostedDoc.Redrawn := TRUE;
    //             PostedDoc.MODIFY;
    //         END ELSE
    //             IF ClosedDoc.GET(ClosedDoc.Type::Payable, VendLedgEntry."Entry No.") THEN BEGIN
    //                 IF ClosedDoc."Bill Gr./Pmt. Order No." = '' THEN
    //                     ERROR(Text1100009);
    //                 ClosedPmtOrd.GET(ClosedDoc."Bill Gr./Pmt. Order No.");
    //                 VALIDATE("Account No.", ClosedPmtOrd."Bank Account No.");
    //                 VALIDATE(Amount, ClosedDoc."Amount for Collection");
    //                 ClosedDoc.TESTFIELD(Redrawn, FALSE);
    //                 ClosedDoc.Redrawn := TRUE;
    //                 ClosedDoc.MODIFY;
    //             END;
    //         "Dimension Set ID" := GetCombinedDimSetID(GenJnlLine2, VendLedgEntry."Dimension Set ID");
    //     END;

    //     OnAfterReversePayableDocPayment(GenJnlLine2, VendLedgEntry);
    // END;

    // //[External]
    // PROCEDURE CustUnrealizedVAT2(CustLedgEntry2: Record 21; AmountLCY: Decimal; GenJnlLine: Record 81; VAR ExistVATEntry: Boolean; VAR FirstVATEntry: Integer; VAR LastVATEntry: Integer; VAR NoRealVATBuffer: Record 7000012; IsFromJournal: Boolean; PostedDocumentNo: Code[20]);
    // VAR
    //     CustLedgEntry3: Record 21;
    //     GenJnlPostLine2: codeunit 50101;
    // BEGIN
    //     IF GenJnlPostLine2.CustFindVATSetup(VATPostingSetup, CustLedgEntry2, IsFromJournal) THEN BEGIN
    //         CustLedgEntry3.SETCURRENTKEY("Document No.", "Document Type", "Customer No.");
    //         CustLedgEntry3.SETRANGE("Document Type", CustLedgEntry3."Document Type"::Invoice);
    //         CustLedgEntry3.SETRANGE("Document No.", CustLedgEntry2."Document No.");

    //         IF CustLedgEntry3.FINDFIRST THEN BEGIN
    //             CustLedgEntry3.Open := TRUE;
    //             CustUnrealizedVAT(
    //               CustLedgEntry3, -AmountLCY, GenJnlLine, ExistVATEntry, FirstVATEntry, LastVATEntry, NoRealVATBuffer, PostedDocumentNo);
    //         END;
    //     END ELSE
    //         EXIT;
    // END;

    // LOCAL PROCEDURE CustUnrealizedVAT(VAR CustLedgEntry2: Record 21; SettledAmount: Decimal; GenJnlLine: Record 81; VAR ExistVATEntry: Boolean; VAR FirstVATEntryNo: Integer; VAR LastVATEntryNo: Integer; VAR NoRealVATBuffer: Record 7000012; PostedDocumentNo: Code[20]);
    // VAR
    //     VATEntry: Record 254;
    //     VATEntry2: Record 254;
    //     VATEntry3: Record 254;
    //     PaymentTerms: Record 3;
    //     SalesInvHeader: Record 112;
    //     VATPart: Decimal;
    //     VATAmount: Decimal;
    //     VATBase: Decimal;
    //     VATAmountAddCurr: Decimal;
    //     VATBaseAddCurr: Decimal;
    //     CurrencyFactor: Decimal;
    //     SalesVATAccount: Code[20];
    //     SalesVATUnrealAccount: Code[20];
    //     LastConnectionNo: Integer;
    //     Test1: Boolean;
    //     Test2: Boolean;
    //     PaymentTermsCode: Code[20];
    // BEGIN
    //     IF PostedDocumentNo <> '' THEN BEGIN
    //         SalesInvHeader.GET(PostedDocumentNo);
    //         PaymentTermsCode := SalesInvHeader."Payment Terms Code";
    //     END;

    //     CustLedgEntry2.CALCFIELDS(
    //       Amount,
    //       "Amount (LCY)",
    //       "Remaining Amount",
    //       "Remaining Amt. (LCY)",
    //       "Original Amt. (LCY)");
    //     CurrencyFactor := CustLedgEntry2.Amount / CustLedgEntry2."Amount (LCY)";
    //     VATEntry2.RESET;
    //     VATEntry2.SETCURRENTKEY("Transaction No.");
    //     VATEntry2.SETRANGE("Transaction No.", CustLedgEntry2."Transaction No.");

    //     IF VATEntry2.FIND('-') THEN BEGIN
    //         LastConnectionNo := 0;
    //         REPEAT
    //             IF LastConnectionNo <> VATEntry2."Sales Tax Connection No." THEN
    //                 LastConnectionNo := VATEntry2."Sales Tax Connection No.";

    //             VATEntry3.RESET;
    //             IF VATEntry3.FINDLAST THEN
    //                 VATEntryNo := VATEntry3."Entry No." + 1;

    //             IF (VATEntry2.Type.AsInteger() <> 0) AND
    //                (VATEntry2.Amount = 0) AND
    //                (VATEntry2.Base = 0)
    //             THEN BEGIN
    //                 CASE VATEntry2."VAT Calculation Type" OF
    //                     VATEntry2."VAT Calculation Type"::"Normal VAT",
    //                   VATEntry2."VAT Calculation Type"::"Reverse Charge VAT",
    //                   VATEntry2."VAT Calculation Type"::"Full VAT":
    //                         VATPostingSetup.GET(
    //                           VATEntry2."VAT Bus. Posting Group", VATEntry2."VAT Prod. Posting Group");
    //                 END;
    //                 IF (VATPostingSetup."Unrealized VAT Type" > 0) AND
    //                    ((VATEntry2."Remaining Unrealized Amount" <> 0) OR
    //                     (VATEntry2."Remaining Unrealized Base" <> 0))
    //                 THEN BEGIN
    //                     IF NOT CustLedgEntry2.Open THEN
    //                         VATPart := 1
    //                     ELSE
    //                         IF CustLedgEntry2."Currency Code" = '' THEN
    //                             VATPart := -SettledAmount / CustLedgEntry2."Original Amt. (LCY)"
    //                         ELSE
    //                             VATPart :=
    //                               -SettledAmount *
    //                               (CustLedgEntry2."Original Amt. (LCY)" / CustLedgEntry2.Amount) / CustLedgEntry2."Original Amt. (LCY)";
    //                 END;
    //                 IF VATPart <> 0 THEN BEGIN
    //                     CASE VATEntry2."VAT Calculation Type" OF
    //                         VATEntry2."VAT Calculation Type"::"Normal VAT",
    //                         VATEntry2."VAT Calculation Type"::"Reverse Charge VAT",
    //                         VATEntry2."VAT Calculation Type"::"Full VAT":
    //                             BEGIN
    //                                 VATPostingSetup.TESTFIELD("Sales VAT Account");
    //                                 VATPostingSetup.TESTFIELD("Sales VAT Unreal. Account");
    //                                 SalesVATAccount := VATPostingSetup."Sales VAT Account";
    //                                 SalesVATUnrealAccount := VATPostingSetup."Sales VAT Unreal. Account";
    //                             END;
    //                     END;
    //                     PaymentTerms.GET(PaymentTermsCode);
    //                     IF PaymentTerms."VAT distribution" = PaymentTerms."VAT distribution"::"First Installment" THEN
    //                         VATPart := 1;

    //                     IF VATPart = 1 THEN BEGIN
    //                         VATAmount := VATEntry2."Remaining Unrealized Amount";
    //                         VATBase := VATEntry2."Remaining Unrealized Base";
    //                         VATAmountAddCurr := VATEntry2."Add.-Curr. Rem. Unreal. Amount";
    //                         VATBaseAddCurr := VATEntry2."Add.-Curr. Rem. Unreal. Base";
    //                     END ELSE BEGIN
    //                         VATAmount := ROUND(VATEntry2."Unrealized Amount" * VATPart);
    //                         VATBase := ROUND(VATEntry2."Unrealized Base" * VATPart);
    //                     END;

    //                     VATUnrealAcc := SalesVATUnrealAccount;
    //                     VATAcc := SalesVATAccount;
    //                     IF CustLedgEntry2."Currency Code" = '' THEN
    //                         TotalVATAmount := VATAmount
    //                     ELSE
    //                         TotalVATAmount := VATAmount * CurrencyFactor;

    //                     IF NoRealVATBuffer.GET(SalesVATUnrealAccount, SalesVATAccount, VATEntry2."Entry No.") THEN BEGIN
    //                         NoRealVATBuffer.Amount := NoRealVATBuffer.Amount + TotalVATAmount;
    //                     END ELSE BEGIN
    //                         NoRealVATBuffer.INIT;
    //                         NoRealVATBuffer.Account := SalesVATUnrealAccount;
    //                         NoRealVATBuffer."Balance Account" := SalesVATAccount;
    //                         NoRealVATBuffer.Amount := TotalVATAmount;
    //                         NoRealVATBuffer."Entry No." := VATEntry2."Entry No.";
    //                         NoRealVATBuffer.INSERT;
    //                     END;

    //                     VATEntry := VATEntry2;
    //                     VATEntry."Entry No." := VATEntryNo;
    //                     VATEntry."Posting Date" := GenJnlLine."Posting Date";
    //                     VATEntry."Document No." := GenJnlLine."Document No.";
    //                     VATEntry."External Document No." := GenJnlLine."External Document No.";
    //                     VATEntry."Document Type" := GenJnlLine."Document Type";
    //                     VATEntry.Amount := VATAmount;
    //                     VATEntry.Base := VATBase;
    //                     VATEntry."Unrealized Amount" := 0;
    //                     VATEntry."Unrealized Base" := 0;
    //                     VATEntry."Remaining Unrealized Amount" := 0;
    //                     VATEntry."Remaining Unrealized Base" := 0;
    //                     VATEntry."Additional-Currency Amount" := VATAmountAddCurr;
    //                     VATEntry."Additional-Currency Base" := VATBaseAddCurr;
    //                     VATEntry."Add.-Currency Unrealized Amt." := 0;
    //                     VATEntry."Add.-Currency Unrealized Base" := 0;
    //                     VATEntry."Add.-Curr. Rem. Unreal. Amount" := 0;
    //                     VATEntry."Add.-Curr. Rem. Unreal. Base" := 0;
    //                     VATEntry."User ID" := USERID;
    //                     VATEntry."Source Code" := GenJnlLine."Source Code";
    //                     VATEntry."Reason Code" := GenJnlLine."Reason Code";
    //                     VATEntry."Closed by Entry No." := 0;
    //                     VATEntry.Closed := FALSE;
    //                     VATEntry."Transaction No." := CustLedgEntry2."Transaction No.";
    //                     VATEntry."Unrealized VAT Entry No." := VATEntry2."Entry No.";
    //                     VATEntry.UpdateRates(VATPostingSetup);
    //                     Test1 := VATEntry.INSERT;

    //                     VATEntry2."Remaining Unrealized Amount" :=
    //                       VATEntry2."Remaining Unrealized Amount" - VATEntry.Amount;
    //                     VATEntry2."Remaining Unrealized Base" :=
    //                       VATEntry2."Remaining Unrealized Base" - VATEntry.Base;
    //                     VATEntry2."Add.-Curr. Rem. Unreal. Amount" :=
    //                       VATEntry2."Add.-Curr. Rem. Unreal. Amount" - VATEntry."Additional-Currency Amount";
    //                     VATEntry2."Add.-Curr. Rem. Unreal. Base" :=
    //                       VATEntry2."Add.-Curr. Rem. Unreal. Base" - VATEntry."Additional-Currency Base";
    //                     Test2 := VATEntry2.MODIFY;
    //                     LastVATEntryNo := VATEntryNo;
    //                 END;
    //             END;

    //             IF NOT ExistVATEntry THEN
    //                 FirstVATEntryNo := LastVATEntryNo;
    //             ExistVATEntry := Test1 AND Test2;

    //         UNTIL VATEntry2.NEXT = 0;
    //     END;
    // END;

    // //[External]
    // PROCEDURE VendUnrealizedVAT2(VendLedgEntry2: Record 25; AmountLCY: Decimal; GenJnlLine: Record 81; VAR ExistVATEntry: Boolean; VAR FirstVATEntry: Integer; VAR LastVATEntry: Integer; VAR NoRealVATBuffer: Record 7000012; IsFromJournal: Boolean; PostedDocumentNo: Code[20]);
    // VAR
    //     VendLedgEntry3: Record 25;
    //     GenJnlPostLine2: codeunit 50101;
    // BEGIN
    //     IF GenJnlPostLine2.VendFindVATSetup(VATPostingSetup, VendLedgEntry2, IsFromJournal) THEN BEGIN
    //         VendLedgEntry3.SETCURRENTKEY("Document No.", "Document Type", "Vendor No.");
    //         VendLedgEntry3.SETRANGE("Document Type", VendLedgEntry3."Document Type"::Invoice);
    //         VendLedgEntry3.SETRANGE("Document No.", VendLedgEntry2."Document No.");

    //         IF VendLedgEntry3.FINDFIRST THEN BEGIN
    //             VendLedgEntry3.Open := TRUE;
    //             VendUnrealizedVAT(
    //               VendLedgEntry3, -AmountLCY, GenJnlLine, ExistVATEntry, FirstVATEntry, LastVATEntry, NoRealVATBuffer, PostedDocumentNo);
    //         END;
    //     END ELSE
    //         EXIT;
    // END;

    LOCAL PROCEDURE VendUnrealizedVAT(VAR VendLedgEntry2: Record 25; SettledAmount: Decimal; GenJnlLine: Record 81; VAR ExistVATEntry: Boolean; VAR FirstVATEntryNo: Integer; VAR LastVATEntryNo: Integer; VAR NoRealVATBuffer: Record 7000012; PostedDocumentNo: Code[20]);
    VAR
        VATEntry: Record 254;
        VATEntry2: Record 254;
        VATEntry3: Record 254;
        PurchInvHeader: Record 122;
        PaymentTerms: Record 3;
        VATPart: Decimal;
        VATAmount: Decimal;
        VATBase: Decimal;
        VATAmountAddCurr: Decimal;
        VATBaseAddCurr: Decimal;
        CurrencyFactor: Decimal;
        PurchVATAccount: Code[20];
        PurchVATUnrealAccount: Code[20];
        LastConnectionNo: Integer;
        Test1: Boolean;
        Test2: Boolean;
        PaymentTermsCode: Code[20];
        ReverseChrgVATAcc: Code[20];
        ReverseChrgVATUnrealAcc: Code[20];
    BEGIN
        IF PostedDocumentNo <> '' THEN BEGIN
            PurchInvHeader.GET(PostedDocumentNo);
            PaymentTermsCode := PurchInvHeader."Payment Terms Code";
        END;

        VendLedgEntry2.CALCFIELDS(
          Amount,
          "Amount (LCY)",
          "Remaining Amount",
          "Remaining Amt. (LCY)",
          "Original Amt. (LCY)");
        CurrencyFactor := VendLedgEntry2.Amount / VendLedgEntry2."Amount (LCY)";
        VATEntry2.RESET;
        VATEntry2.SETCURRENTKEY("Transaction No.");
        VATEntry2.SETRANGE("Transaction No.", VendLedgEntry2."Transaction No.");

        //JAV 18/10/20: - QB 1.06.21 Evitar en la funci�n VendUnrealizedVAT que al crear movimientos de IVA no realziado entre en bucle con los registros nuevos que ha creado
        VATEntry3.RESET;
        IF VATEntry3.FINDLAST THEN
            VATEntry2.SETRANGE("Entry No.", 0, VATEntry3."Entry No.");
        //JAV fin

        IF VATEntry2.FIND('-') THEN BEGIN
            LastConnectionNo := 0;
            REPEAT
                IF LastConnectionNo <> VATEntry2."Sales Tax Connection No." THEN
                    LastConnectionNo := VATEntry2."Sales Tax Connection No.";

                VATEntry3.RESET;
                IF VATEntry3.FINDLAST THEN
                    VATEntryNo := VATEntry3."Entry No." + 1;

                IF (VATEntry2.Type.AsInteger() <> 0) AND
                   (VATEntry2.Amount = 0) AND
                   (VATEntry2.Base = 0)
                THEN BEGIN
                    CASE VATEntry2."VAT Calculation Type" OF
                        VATEntry2."VAT Calculation Type"::"Normal VAT",
                      VATEntry2."VAT Calculation Type"::"Reverse Charge VAT",
                      VATEntry2."VAT Calculation Type"::"Full VAT":
                            VATPostingSetup.GET(
                              VATEntry2."VAT Bus. Posting Group", VATEntry2."VAT Prod. Posting Group");
                    END;
                    IF (VATPostingSetup."Unrealized VAT Type" > 0) AND
                       ((VATEntry2."Remaining Unrealized Amount" <> 0) OR
                        (VATEntry2."Remaining Unrealized Base" <> 0))
                    THEN BEGIN
                        IF NOT VendLedgEntry2.Open THEN
                            VATPart := 1
                        ELSE
                            IF VendLedgEntry2."Currency Code" = '' THEN
                                VATPart := -SettledAmount / VendLedgEntry2."Original Amt. (LCY)"
                            ELSE
                                VATPart :=
                                  -SettledAmount *
                                  (VendLedgEntry2."Original Amt. (LCY)" / VendLedgEntry2.Amount) / VendLedgEntry2."Original Amt. (LCY)";
                    END;
                    IF VATPart <> 0 THEN BEGIN
                        CASE VATEntry2."VAT Calculation Type" OF
                            VATEntry2."VAT Calculation Type"::"Normal VAT",
                            VATEntry2."VAT Calculation Type"::"Reverse Charge VAT",
                            VATEntry2."VAT Calculation Type"::"Full VAT":
                                BEGIN
                                    VATPostingSetup.TESTFIELD("Purchase VAT Account");
                                    VATPostingSetup.TESTFIELD("Purch. VAT Unreal. Account");
                                    IF VATEntry2."VAT Calculation Type" = VATEntry2."VAT Calculation Type"::"Reverse Charge VAT" THEN BEGIN
                                        VATPostingSetup.TESTFIELD("Reverse Chrg. VAT Acc.");
                                        VATPostingSetup.TESTFIELD("Reverse Chrg. VAT Unreal. Acc.");
                                        ReverseChrgVATAcc := VATPostingSetup."Reverse Chrg. VAT Acc.";
                                        ReverseChrgVATUnrealAcc := VATPostingSetup."Reverse Chrg. VAT Unreal. Acc.";
                                    END;
                                    PurchVATAccount := VATPostingSetup."Purchase VAT Account";
                                    PurchVATUnrealAccount := VATPostingSetup."Purch. VAT Unreal. Account";
                                END;
                        END;
                        PaymentTerms.GET(PaymentTermsCode);
                        IF PaymentTerms."VAT distribution" = PaymentTerms."VAT distribution"::"First Installment" THEN
                            VATPart := 1;

                        IF VATPart = 1 THEN BEGIN
                            VATAmount := VATEntry2."Remaining Unrealized Amount";
                            VATBase := VATEntry2."Remaining Unrealized Base";
                            VATAmountAddCurr := VATEntry2."Add.-Curr. Rem. Unreal. Amount";
                            VATBaseAddCurr := VATEntry2."Add.-Curr. Rem. Unreal. Base";
                        END ELSE BEGIN
                            VATAmount := ROUND(VATEntry2."Unrealized Amount" * VATPart);
                            VATBase := ROUND(VATEntry2."Unrealized Base" * VATPart);
                        END;

                        VATUnrealAcc := PurchVATUnrealAccount;
                        VATAcc := PurchVATAccount;
                        IF VendLedgEntry2."Currency Code" = '' THEN
                            TotalVATAmount := VATAmount
                        ELSE
                            TotalVATAmount := VATAmount * CurrencyFactor;

                        IF NoRealVATBuffer.GET(PurchVATUnrealAccount, PurchVATAccount, VATEntry2."Entry No.") THEN BEGIN
                            NoRealVATBuffer.Amount := NoRealVATBuffer.Amount + TotalVATAmount;
                        END ELSE BEGIN
                            NoRealVATBuffer.INIT;
                            NoRealVATBuffer.Account := PurchVATUnrealAccount;
                            NoRealVATBuffer."Balance Account" := PurchVATAccount;
                            NoRealVATBuffer.Amount := TotalVATAmount;
                            NoRealVATBuffer."Entry No." := VATEntry2."Entry No.";
                            NoRealVATBuffer.INSERT;
                        END;

                        IF VATEntry2."VAT Calculation Type" = VATEntry2."VAT Calculation Type"::"Reverse Charge VAT" THEN
                            IF NoRealVATBuffer.GET(ReverseChrgVATAcc, ReverseChrgVATUnrealAcc, VATEntry2."Entry No.") THEN
                                NoRealVATBuffer.Amount := NoRealVATBuffer.Amount + TotalVATAmount
                            ELSE BEGIN
                                NoRealVATBuffer.INIT;
                                NoRealVATBuffer.Account := ReverseChrgVATAcc;
                                NoRealVATBuffer."Balance Account" := ReverseChrgVATUnrealAcc;
                                NoRealVATBuffer.Amount := TotalVATAmount;
                                NoRealVATBuffer."Entry No." := VATEntry2."Entry No.";
                                NoRealVATBuffer.INSERT;
                            END;

                        VATEntry := VATEntry2;
                        VATEntry."Entry No." := VATEntryNo;
                        VATEntry."Posting Date" := GenJnlLine."Posting Date";
                        VATEntry."Document No." := GenJnlLine."Document No.";
                        VATEntry."External Document No." := GenJnlLine."External Document No.";
                        VATEntry."Document Type" := GenJnlLine."Document Type";
                        VATEntry.Amount := VATAmount;
                        VATEntry.Base := VATBase;
                        VATEntry."Unrealized Amount" := 0;
                        VATEntry."Unrealized Base" := 0;
                        VATEntry."Remaining Unrealized Amount" := 0;
                        VATEntry."Remaining Unrealized Base" := 0;
                        VATEntry."Additional-Currency Amount" := VATAmountAddCurr;
                        VATEntry."Additional-Currency Base" := VATBaseAddCurr;
                        VATEntry."Add.-Currency Unrealized Amt." := 0;
                        VATEntry."Add.-Currency Unrealized Base" := 0;
                        VATEntry."Add.-Curr. Rem. Unreal. Amount" := 0;
                        VATEntry."Add.-Curr. Rem. Unreal. Base" := 0;
                        VATEntry."User ID" := USERID;
                        VATEntry."Source Code" := GenJnlLine."Source Code";
                        VATEntry."Reason Code" := GenJnlLine."Reason Code";
                        VATEntry."Closed by Entry No." := 0;
                        VATEntry.Closed := FALSE;
                        VATEntry."Transaction No." := VendLedgEntry2."Transaction No.";
                        VATEntry."Unrealized VAT Entry No." := VATEntry2."Entry No.";
                        VATEntry.UpdateRates(VATPostingSetup);
                        Test1 := VATEntry.INSERT;

                        VATEntry2."Remaining Unrealized Amount" :=
                          VATEntry2."Remaining Unrealized Amount" - VATEntry.Amount;
                        VATEntry2."Remaining Unrealized Base" :=
                          VATEntry2."Remaining Unrealized Base" - VATEntry.Base;
                        VATEntry2."Add.-Curr. Rem. Unreal. Amount" :=
                          VATEntry2."Add.-Curr. Rem. Unreal. Amount" - VATEntry."Additional-Currency Amount";
                        VATEntry2."Add.-Curr. Rem. Unreal. Base" :=
                          VATEntry2."Add.-Curr. Rem. Unreal. Base" - VATEntry."Additional-Currency Base";
                        Test2 := VATEntry2.MODIFY;
                        LastVATEntryNo := VATEntryNo;
                    END;
                END;

                IF NOT ExistVATEntry THEN
                    FirstVATEntryNo := LastVATEntryNo;
                ExistVATEntry := Test1 AND Test2;

            UNTIL VATEntry2.NEXT = 0;
        END;
    END;

    // PROCEDURE GetLastDate(CurrCode: Code[10]; DocPostDate: Date; Type: Option "Receivable","Payable"): Date;
    // VAR
    //     ExchRateAdjReg: Record 86;
    // BEGIN
    //     ExchRateAdjReg.SETRANGE("Currency Code", CurrCode);
    //     IF Type = Type::Receivable THEN
    //         ExchRateAdjReg.SETRANGE("Account Type", ExchRateAdjReg."Account Type"::Customer)
    //     ELSE
    //         ExchRateAdjReg.SETRANGE("Account Type", ExchRateAdjReg."Account Type"::Vendor);
    //     IF ExchRateAdjReg.FINDLAST THEN
    //         IF ExchRateAdjReg."Creation Date" > DocPostDate THEN
    //             EXIT(ExchRateAdjReg."Creation Date")
    //         ELSE
    //             EXIT(DocPostDate)
    //     ELSE
    //         EXIT(DocPostDate);
    // END;

    // //[External]
    // PROCEDURE GetGainLoss(PostingDate: Date; PostingDate2: Date; AmountFCY: Decimal; CurrencyCode: Code[10]): Decimal;
    // BEGIN
    //     EXIT(
    //       GetAmountLCYBasedOnCurrencyDate(PostingDate2, CurrencyCode, AmountFCY) -
    //       GetAmountLCYBasedOnCurrencyDate(PostingDate, CurrencyCode, AmountFCY));
    // END;

    // //[External]
    // PROCEDURE GetCurrFactorGainLoss(CurrFactor1: Decimal; CurrFactor2: Decimal; AmountFCY: Decimal; CurrencyCode: Code[10]): Decimal;
    // BEGIN
    //     EXIT(
    //       GetAmountLCYBasedOnCurrencyFactor(CurrencyCode, CurrFactor2, AmountFCY) -
    //       GetAmountLCYBasedOnCurrencyFactor(CurrencyCode, CurrFactor1, AmountFCY));
    // END;

    // //[External]
    // PROCEDURE CheckFromRedrawnDoc(DocNo: Code[20]): Boolean;
    // BEGIN
    //     IF STRPOS(DocNo, '-') = 0 THEN
    //         EXIT(FALSE);

    //     EXIT(TRUE);
    // END;

    // LOCAL PROCEDURE GetDocType(Type: Option "Invoice","","Bill"): Integer;
    // VAR
    //     DocType: Option " ","Payment","Invoice","Credit Memo","Finance Charge Memo","Reminder","Refund";
    // BEGIN
    //     CASE Type OF
    //         Type::Invoice, Type::Bill:
    //             DocType := DocType::Payment;
    //         ELSE
    //             DocType := DocType::" ";
    //     END;

    //     EXIT(DocType);
    // END;

    // LOCAL PROCEDURE RemovePayableError(CarteraDoc: Record 7000002);
    // VAR
    //     PaymentJnlExportErrorText: Record 1228;
    // BEGIN
    //     PaymentJnlExportErrorText.SETRANGE("Document No.", CarteraDoc."Bill Gr./Pmt. Order No.");
    //     PaymentJnlExportErrorText.SETRANGE("Journal Line No.", CarteraDoc."Entry No.");
    //     PaymentJnlExportErrorText.DELETEALL(TRUE);
    // END;

    // LOCAL PROCEDURE RemoveReceivableError(CarteraDoc: Record 7000002);
    // VAR
    //     PaymentJnlExportErrorText: Record 1228;
    // BEGIN
    //     PaymentJnlExportErrorText.SETRANGE("Journal Template Name", '');
    //     PaymentJnlExportErrorText.SETRANGE("Journal Batch Name", FORMAT(DATABASE::"Bill Group"));
    //     PaymentJnlExportErrorText.SETRANGE("Document No.", CarteraDoc."Bill Gr./Pmt. Order No.");
    //     PaymentJnlExportErrorText.SETRANGE("Journal Line No.", CarteraDoc."Entry No.");
    //     PaymentJnlExportErrorText.DELETEALL(TRUE);
    // END;

    // //[External]
    // PROCEDURE GetDimSetIDFromCustLedgEntry(GenJnlLine: Record 81; CustLedgEntry: Record 21; IsPostedDoc: Boolean) DimSetID: Integer;
    // VAR
    //     PostedCarteraDoc: Record 7000003;
    //     ClosedCarteraDoc: Record 7000004;
    // BEGIN
    //     IF IsPostedDoc THEN BEGIN
    //         PostedCarteraDoc.SETRANGE(Type, PostedCarteraDoc.Type::Receivable);
    //         PostedCarteraDoc.SETRANGE("Document No.", CustLedgEntry."Document No.");
    //         IF CustLedgEntry."Document Type" = CustLedgEntry."Document Type"::Bill THEN
    //             PostedCarteraDoc.SETRANGE("No.", CustLedgEntry."Bill No.");
    //         PostedCarteraDoc.FINDLAST;
    //         DimSetID := PostedCarteraDoc."Dimension Set ID";
    //     END ELSE BEGIN
    //         ClosedCarteraDoc.SETRANGE(Type, ClosedCarteraDoc.Type::Receivable);
    //         ClosedCarteraDoc.SETRANGE("Document No.", CustLedgEntry."Document No.");
    //         IF CustLedgEntry."Document Type" = CustLedgEntry."Document Type"::Bill THEN
    //             ClosedCarteraDoc.SETRANGE("No.", CustLedgEntry."Bill No.");
    //         ClosedCarteraDoc.FINDLAST;
    //         DimSetID := ClosedCarteraDoc."Dimension Set ID";
    //     END;
    //     EXIT(GetCombinedDimSetID(GenJnlLine, DimSetID));
    // END;

    // //[External]
    // PROCEDURE GetDimSetIDFromCustPostDocBuffer(GenJnlLine: Record 81; CustLedgEntry: Record 21; VAR PostDocBuffer: Record 7000003): Integer;
    // BEGIN
    //     PostDocBuffer.SETRANGE(Type, PostDocBuffer.Type::Receivable);
    //     PostDocBuffer.SETRANGE("Document No.", CustLedgEntry."Document No.");
    //     IF CustLedgEntry."Document Type" = CustLedgEntry."Document Type"::Bill THEN
    //         PostDocBuffer.SETRANGE("No.", CustLedgEntry."Bill No.");
    //     PostDocBuffer.FINDLAST;
    //     PostDocBuffer.RESET;
    //     EXIT(GetCombinedDimSetID(GenJnlLine, PostDocBuffer."Dimension Set ID"));
    // END;

    // //[External]
    // PROCEDURE GetCombinedDimSetID(GenJnlLine: Record 81; DimSetID: Integer): Integer;
    // VAR
    //     DimensioMgt: Codeunit 408;
    //     DimensionSetIDArr: ARRAY[10] OF Integer;
    // BEGIN
    //     WITH GenJnlLine DO BEGIN
    //         DimensionSetIDArr[1] := "Dimension Set ID";
    //         DimensionSetIDArr[2] := DimSetID;
    //         EXIT(
    //           DimensioMgt.GetCombinedDimensionSetID(DimensionSetIDArr, "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code"));
    //     END;
    // END;

    // LOCAL PROCEDURE GetAmountLCYBasedOnCurrencyDate(PostingDate: Date; CurrencyCode: Code[10]; AmountFCY: Decimal): Decimal;
    // VAR
    //     TempGenJournalLine: Record 81 TEMPORARY;
    // BEGIN
    //     TempGenJournalLine.INIT;
    //     TempGenJournalLine."Posting Date" := PostingDate;
    //     TempGenJournalLine.VALIDATE("Account Type", TempGenJournalLine."Account Type"::"G/L Account");
    //     TempGenJournalLine.VALIDATE("Currency Code", CurrencyCode);
    //     TempGenJournalLine.VALIDATE(Amount, AmountFCY);
    //     TempGenJournalLine.INSERT;
    //     EXIT(TempGenJournalLine."Amount (LCY)");
    // END;

    // LOCAL PROCEDURE GetAmountLCYBasedOnCurrencyFactor(CurrencyCode: Code[10]; CurrencyFactor: Decimal; AmountFCY: Decimal): Decimal;
    // VAR
    //     TempGenJournalLine: Record 81 TEMPORARY;
    // BEGIN
    //     TempGenJournalLine.INIT;
    //     TempGenJournalLine.VALIDATE("Currency Code", CurrencyCode);
    //     TempGenJournalLine.VALIDATE("Currency Factor", CurrencyFactor);
    //     TempGenJournalLine.VALIDATE(Amount, AmountFCY);
    //     TempGenJournalLine.INSERT;
    //     EXIT(TempGenJournalLine."Amount (LCY)");
    // END;

    // //[IntegrationEvent]
    // LOCAL PROCEDURE OnAfterCreatePayableDocPayment(VAR GenJournalLine: Record 81; VAR VendorLedgerEntry: Record 25);
    // BEGIN
    // END;

    // //[IntegrationEvent]
    // LOCAL PROCEDURE OnAfterCreateReceivableDocPayment(VAR GenJournalLine: Record 81; VAR CustLedgerEntry: Record 21);
    // BEGIN
    // END;

    // [IntegrationEvent(true, false)]
    // LOCAL PROCEDURE OnAfterInsertPayableDocs(VAR CarteraDoc: Record 7000002; VAR PaymentOrder: Record 7000020);
    // BEGIN
    // END;

    // //[IntegrationEvent]
    // LOCAL PROCEDURE OnAfterInsertReceivableDocs(VAR CarteraDoc: Record 7000002; VAR BillGroup: Record 7000005);
    // BEGIN
    // END;

    // //[IntegrationEvent]
    // LOCAL PROCEDURE OnAfterReversePayableDocPayment(VAR GenJournalLine: Record 81; VAR VendorLedgerEntry: Record 25);
    // BEGIN
    // END;

    // //[IntegrationEvent]
    // LOCAL PROCEDURE OnAfterReverseReceivableDocPayment(VAR GenJournalLine: Record 81; VAR CustLedgerEntry: Record 21);
    // BEGIN
    // END;

    // [IntegrationEvent(true, false)]
    // LOCAL PROCEDURE OnInsertPayableDocsOnAfterSetFilters(VAR CarteraDoc: Record 7000002);
    // BEGIN
    // END;

    // //[IntegrationEvent]
    // LOCAL PROCEDURE OnInsertReceivableDocsOnAfterSetFilters(VAR CarteraDoc: Record 7000002);
    // BEGIN
    // END;


    /*BEGIN
    /*{
          JAV 18/10/20: - QB 1.06.21 Evitar en la funci�n VendUnrealizedVAT que al crear movimientos de IVA no realziado entre en bucle con los registros nuevos que ha creado
        }
    END.*/
}









