Codeunit 50100 "Gen. Jnl.-Check Line 1"
{


    TableNo = 81;
    Permissions = TableData 252 = rimd;
    trigger OnRun()
    BEGIN
        RunCheck(Rec);
    END;

    VAR
        Text000: TextConst ENU = 'can only be a closing date for G/L entries', ESP = 's�lo puede ser una fecha �ltima para movs. de cuentas';
        Text001: TextConst ENU = 'is not within your range of allowed posting dates', ESP = 'no est� dentro del periodo de fechas de registro permitidas';
        Text002: TextConst ENU = '%1 or %2 must be G/L Account or Bank Account.', ESP = '%1 o %2 deben ser de tipo Cuenta o Banco.';
        Text003: TextConst ENU = 'must have the same sign as %1', ESP = 'debe tener el mismo signo que %1.';
        Text004: TextConst ENU = 'You must not specify %1 when %2 is %3.', ESP = 'No se debe especificar %1 cuando %2 es %3.';
        Text005: TextConst ENU = '%1 + %2 must be %3.', ESP = '%1 + %2 debe ser %3.';
        Text006: TextConst ENU = '%1 + %2 must be -%3.', ESP = '%1 + %2 debe ser -%3.';
        Text007: TextConst ENU = 'must be positive', ESP = 'debe ser positivo';
        Text008: TextConst ENU = 'must be negative', ESP = 'debe ser negativo';
        Text009: TextConst ENU = 'must have a different sign than %1', ESP = 'debe ser de signo diferente a %1';
        Text010: TextConst ENU = '%1 %2 and %3 %4 is not allowed.', ESP = '%1 %2  y %3 %4 no est� permit.';
        Text011: TextConst ENU = 'The combination of dimensions used in %1 %2, %3, %4 is blocked. %5', ESP = 'La combin. de dimensiones utilizada en %1 %2, %3, %4 est� bloq. %5';
        Text012: TextConst ENU = 'A dimension used in %1 %2, %3, %4 has caused an error. %5', ESP = 'La dimensi�n util. en %1 %2, %3, %4 ha causado error. %5';
        GLSetup: Record 98;
        GenJnlTemplate: Record 80;
        CostAccSetup: Record 1108;
        CarteraSetup: Record 7000016;
        DimMgt: Codeunit 408;
        DimMgt1: Codeunit 50361;
        CostAccMgt: Codeunit 1100;
        DocPost: Codeunit 7000006;
        GenJnlTemplateFound: Boolean;
        OverrideDimErr: Boolean;
        SalesDocAlreadyExistsErr: TextConst ENU = 'Sales %1 %2 already exists.', ESP = 'Ya existe la venta  %1 %2.';
        PurchDocAlreadyExistsErr: TextConst ENU = 'Purchase %1 %2 already exists.', ESP = 'Ya existe la compra %1 %2.';
        IsBatchMode: Boolean;
        QBCodeunitPublisher: Codeunit 7207352;
        EmployeeBalancingDocTypeErr: TextConst ENU = 'must be empty or set to Payment when Balancing Account Type field is set to Employee', ESP = 'no debe contener ning�n valor o se debe establecer en Pago cuando el campo Tipo de cuenta de contrapartida est� establecido en Empleado';
        EmployeeAccountDocTypeErr: TextConst ENU = 'must be empty or set to Payment when Account Type field is set to Employee', ESP = 'no debe contener ning�n valor o se debe establecer en Pago cuando el campo Tipo de cuenta est� establecido en Empleado';
        FunctionQB: Codeunit 7207272;

    //[External]
    PROCEDURE RunCheck(VAR GenJnlLine: Record 81);
    VAR
        PaymentTerms: Record 3;
        ICGLAcount: Record 410;
    BEGIN
        OnBeforeRunCheck(GenJnlLine);

        GLSetup.GET;
        WITH GenJnlLine DO BEGIN
            IF EmptyLine THEN
                EXIT;

            IF NOT GenJnlTemplateFound THEN BEGIN
                IF GenJnlTemplate.GET("Journal Template Name") THEN;
                GenJnlTemplateFound := TRUE;
            END;

            CheckDates(GenJnlLine);
            ValidateSalesPersonPurchaserCode(GenJnlLine);

            TESTFIELD("Document No.");
            IF ("Document Type" = "Document Type"::Invoice) AND ("Document Date" <> 0D) AND ("Payment Terms Code" <> '') THEN
                IF PaymentTerms.GET("Payment Terms Code") THEN
                    PaymentTerms.VerifyMaxNoDaysTillDueDate("Due Date", "Document Date", FIELDCAPTION("Due Date"));

            IF (("Document Type" IN ["Document Type"::Bill, "Document Type"::Invoice, "Document Type"::"Credit Memo"]) OR
               ("Applies-to Doc. Type" IN ["Applies-to Doc. Type"::Bill, "Applies-to Doc. Type"::Invoice])) AND
               CarteraSetup.READPERMISSION
            THEN
                DocPost.CheckGenJnlLine(GenJnlLine);

            IF ("Account Type" IN
                ["Account Type"::Customer,
                 "Account Type"::Vendor,
                 "Account Type"::"Fixed Asset",
                 "Account Type"::"IC Partner"]) AND
               ("Bal. Account Type" IN
                ["Bal. Account Type"::Customer,
                 "Bal. Account Type"::Vendor,
                 "Bal. Account Type"::"Fixed Asset",
                 "Bal. Account Type"::"IC Partner"])
            THEN
                ERROR(
                  Text002,
                  FIELDCAPTION("Account Type"), FIELDCAPTION("Bal. Account Type"));

            IF "Bal. Account No." = '' THEN
                TESTFIELD("Account No.");

            IF NeedCheckZeroAmount AND NOT (IsRecurring AND IsBatchMode) THEN
                TESTFIELD(Amount);

            IF ((Amount < 0) XOR ("Amount (LCY)" < 0)) AND (Amount <> 0) AND ("Amount (LCY)" <> 0) THEN
                FIELDERROR("Amount (LCY)", STRSUBSTNO(Text003, FIELDCAPTION(Amount)));

            IF ("Account Type" = "Account Type"::"G/L Account") AND
               ("Bal. Account Type" = "Bal. Account Type"::"G/L Account")
            THEN
                TESTFIELD("Applies-to Doc. No.", '');

            IF ("Recurring Method" IN
                ["Recurring Method"::"B  Balance", "Recurring Method"::"RB Reversing Balance"]) AND
               ("Currency Code" <> '')
            THEN
                ERROR(
                  Text004,
                  FIELDCAPTION("Currency Code"), FIELDCAPTION("Recurring Method"), "Recurring Method");

            IF "Account No." <> '' THEN
                CheckAccountNo(GenJnlLine);

            IF "Bal. Account No." <> '' THEN
                CheckBalAccountNo(GenJnlLine);

            IF "IC Account No." <> '' THEN
                IF ICGLAcount.GET("IC Account No.") THEN
                    ICGLAcount.TESTFIELD(Blocked, FALSE);

            IF (("Account Type" = "Account Type"::"G/L Account") AND
                ("Bal. Account Type" = "Bal. Account Type"::"G/L Account")) OR
               (("Document Type" <> "Document Type"::Invoice) AND
                (NOT
                 (("Document Type" = "Document Type"::"Credit Memo") AND
                  CalcPmtDiscOnCrMemos("Payment Terms Code"))))
            THEN BEGIN
                TESTFIELD("Pmt. Discount Date", 0D);
                TESTFIELD("Payment Discount %", 0);
            END;

            IF (("Account Type" = "Account Type"::"G/L Account") AND
                ("Bal. Account Type" = "Bal. Account Type"::"G/L Account")) OR
               ("Applies-to Doc. No." <> '')
            THEN
                TESTFIELD("Applies-to ID", '');

            IF ("Account Type" <> "Account Type"::"Bank Account") AND
               ("Bal. Account Type" <> "Bal. Account Type"::"Bank Account")
            THEN
                TESTFIELD("Bank Payment Type", "Bank Payment Type"::" ");

            IF ("Account Type" = "Account Type"::"Fixed Asset") OR
               ("Bal. Account Type" = "Bal. Account Type"::"Fixed Asset")
            THEN
                CODEUNIT.RUN(CODEUNIT::"FA Jnl.-Check Line", GenJnlLine);

            IF ("Account Type" <> "Account Type"::"Fixed Asset") AND
               ("Bal. Account Type" <> "Bal. Account Type"::"Fixed Asset")
            THEN BEGIN
                TESTFIELD("Depreciation Book Code", '');
                TESTFIELD("FA Posting Type", 0);
            END;

            IF NOT OverrideDimErr THEN
                CheckDimensions(GenJnlLine);
        END;

        IF CostAccSetup.GET THEN
            CostAccMgt.CheckValidCCAndCOInGLEntry(GenJnlLine."Dimension Set ID");

        OnAfterCheckGenJnlLine(GenJnlLine);
    END;

    LOCAL PROCEDURE CalcPmtDiscOnCrMemos(PaymentTermsCode: Code[10]): Boolean;
    VAR
        PaymentTerms: Record 3;
    BEGIN
        IF PaymentTermsCode <> '' THEN BEGIN
            PaymentTerms.GET(PaymentTermsCode);
            EXIT(PaymentTerms."Calc. Pmt. Disc. on Cr. Memos");
        END;
    END;

    //[External]
    PROCEDURE DateNotAllowed(PostingDate: Date) DateIsNotAllowed: Boolean;
    VAR
        UserSetupManagement: Codeunit 5700;
    BEGIN
        DateIsNotAllowed := NOT UserSetupManagement.IsPostingDateValid(PostingDate);
        OnAfterDateNoAllowed(PostingDate, DateIsNotAllowed);
        EXIT(DateIsNotAllowed);
    END;

    LOCAL PROCEDURE ErrorIfPositiveAmt(GenJnlLine: Record 81);
    VAR
        RaiseError: Boolean;
    BEGIN
        RaiseError := GenJnlLine.Amount > 0;
        OnBeforeErrorIfPositiveAmt(GenJnlLine, RaiseError);
        IF RaiseError THEN
            GenJnlLine.FIELDERROR(Amount, Text008);
    END;

    LOCAL PROCEDURE ErrorIfNegativeAmt(GenJnlLine: Record 81);
    VAR
        RaiseError: Boolean;
    BEGIN
        RaiseError := GenJnlLine.Amount < 0;
        OnBeforeErrorIfNegativeAmt(GenJnlLine, RaiseError);
        IF RaiseError THEN
            GenJnlLine.FIELDERROR(Amount, Text007);
    END;

    //[External]
    PROCEDURE SetOverDimErr();
    BEGIN
        OverrideDimErr := TRUE;
    END;

    LOCAL PROCEDURE CheckDates(GenJnlLine: Record 81);
    VAR
        AccountingPeriodMgt: Codeunit 360;
        DateCheckDone: Boolean;
    BEGIN
        WITH GenJnlLine DO BEGIN
            TESTFIELD("Posting Date");
            IF "Posting Date" <> NORMALDATE("Posting Date") THEN BEGIN
                IF ("Account Type" <> "Account Type"::"G/L Account") OR
                   ("Bal. Account Type" <> "Bal. Account Type"::"G/L Account")
                THEN
                    FIELDERROR("Posting Date", Text000);
                AccountingPeriodMgt.CheckPostingDateInFiscalYear("Posting Date");
            END;

            OnBeforeDateNotAllowed(GenJnlLine, DateCheckDone);
            IF NOT DateCheckDone THEN
                IF DateNotAllowed("Posting Date") THEN
                    FIELDERROR("Posting Date", Text001);

            IF "Document Date" <> 0D THEN
                IF ("Document Date" <> NORMALDATE("Document Date")) AND
                   (("Account Type" <> "Account Type"::"G/L Account") OR
                    ("Bal. Account Type" <> "Bal. Account Type"::"G/L Account"))
                THEN
                    FIELDERROR("Document Date", Text000);
        END;
    END;

    LOCAL PROCEDURE CheckAccountNo(GenJnlLine: Record 81);
    VAR
        ICPartner: Record 413;
        CheckDone: Boolean;
    BEGIN
        OnBeforeCheckAccountNo(GenJnlLine, CheckDone);
        IF CheckDone THEN
            EXIT;

        WITH GenJnlLine DO
            CASE "Account Type" OF
                "Account Type"::"G/L Account":
                    BEGIN
                        IF ("Gen. Bus. Posting Group" <> '') OR ("Gen. Prod. Posting Group" <> '') OR
                           ("VAT Bus. Posting Group" <> '') OR ("VAT Prod. Posting Group" <> '')
                        THEN
                            TESTFIELD("Gen. Posting Type");

                        CheckGenProdPostingGroupWhenAdjustForPmtDisc(GenJnlLine);

                        IF ("Gen. Posting Type" <> "Gen. Posting Type"::" ") AND
                           ("VAT Posting" = "VAT Posting"::"Automatic VAT Entry")
                        THEN BEGIN
                            IF "VAT Amount" + "VAT Base Amount" <> Amount THEN
                                ERROR(
                                  Text005, FIELDCAPTION("VAT Amount"), FIELDCAPTION("VAT Base Amount"),
                                  FIELDCAPTION(Amount));
                            IF "Currency Code" <> '' THEN
                                IF "VAT Amount (LCY)" + "VAT Base Amount (LCY)" <> "Amount (LCY)" THEN
                                    ERROR(
                                      Text005, FIELDCAPTION("VAT Amount (LCY)"),
                                      FIELDCAPTION("VAT Base Amount (LCY)"), FIELDCAPTION("Amount (LCY)"));
                        END;
                    END;
                "Account Type"::Customer, "Account Type"::Vendor, "Account Type"::Employee:
                    BEGIN
                        TESTFIELD("Gen. Posting Type", 0);
                        TESTFIELD("Gen. Bus. Posting Group", '');
                        TESTFIELD("Gen. Prod. Posting Group", '');
                        TESTFIELD("VAT Bus. Posting Group", '');
                        TESTFIELD("VAT Prod. Posting Group", '');

                        IF (("Account Type" = "Account Type"::Customer) AND
                            ("Bal. Gen. Posting Type" = "Bal. Gen. Posting Type"::Purchase)) OR
                           (("Account Type" = "Account Type"::Vendor) AND
                            ("Bal. Gen. Posting Type" = "Bal. Gen. Posting Type"::Sale))
                        THEN
                            ERROR(
                              Text010,
                              FIELDCAPTION("Account Type"), "Account Type",
                              FIELDCAPTION("Bal. Gen. Posting Type"), "Bal. Gen. Posting Type");

                        CheckDocType(GenJnlLine);

                        IF NOT "System-Created Entry" AND
                           (((Amount < 0) XOR ("Sales/Purch. (LCY)" < 0)) AND (Amount <> 0) AND ("Sales/Purch. (LCY)" <> 0))
                        THEN
                            FIELDERROR("Sales/Purch. (LCY)", STRSUBSTNO(Text003, FIELDCAPTION(Amount)));
                        //-QB 1.09.20  SE CONDICIONA EL TESTFIELD A QUE ESTEMOS EN QUOBUUILDING
                        IF NOT FunctionQB.AccessToQuobuilding THEN
                            //+QB 1.09.20
                            TESTFIELD("Job No.", '');

                        CheckICPartner("Account Type".AsInteger(), "Account No.", "Document Type");//enum to option
                    END;
                "Account Type"::"Bank Account":
                    BEGIN
                        TESTFIELD("Gen. Posting Type", 0);
                        TESTFIELD("Gen. Bus. Posting Group", '');
                        TESTFIELD("Gen. Prod. Posting Group", '');
                        TESTFIELD("VAT Bus. Posting Group", '');
                        TESTFIELD("VAT Prod. Posting Group", '');
                        TESTFIELD("Job No.", '');
                        IF (Amount < 0) AND ("Bank Payment Type" = "Bank Payment Type"::"Computer Check") THEN
                            TESTFIELD("Check Printed", TRUE);
                        IF ("Bank Payment Type" = "Bank Payment Type"::"Electronic Payment") OR
                           ("Bank Payment Type" = "Bank Payment Type"::"Electronic Payment-IAT")
                        THEN
                            TESTFIELD("Exported to Payment File", TRUE);
                    END;
                "Account Type"::"IC Partner":
                    BEGIN
                        ICPartner.GET("Account No.");
                        ICPartner.CheckICPartner;
                        IF "Journal Template Name" <> '' THEN
                            IF GenJnlTemplate.Type <> GenJnlTemplate.Type::Intercompany THEN
                                FIELDERROR("Account Type");
                    END;
            END;
    END;

    LOCAL PROCEDURE CheckBalAccountNo(GenJnlLine: Record 81);
    VAR
        ICPartner: Record 413;
        CheckDone: Boolean;
    BEGIN
        OnBeforeCheckBalAccountNo(GenJnlLine, CheckDone);
        IF CheckDone THEN
            EXIT;

        WITH GenJnlLine DO
            CASE "Bal. Account Type" OF
                "Bal. Account Type"::"G/L Account":
                    BEGIN
                        IF ("Bal. Gen. Bus. Posting Group" <> '') OR ("Bal. Gen. Prod. Posting Group" <> '') OR
                           ("Bal. VAT Bus. Posting Group" <> '') OR ("Bal. VAT Prod. Posting Group" <> '')
                        THEN
                            TESTFIELD("Bal. Gen. Posting Type");

                        CheckBalGenProdPostingGroupWhenAdjustForPmtDisc(GenJnlLine);

                        IF ("Bal. Gen. Posting Type" <> "Bal. Gen. Posting Type"::" ") AND
                           ("VAT Posting" = "VAT Posting"::"Automatic VAT Entry")
                        THEN BEGIN
                            IF "Bal. VAT Amount" + "Bal. VAT Base Amount" <> -Amount THEN
                                ERROR(
                                  Text006, FIELDCAPTION("Bal. VAT Amount"), FIELDCAPTION("Bal. VAT Base Amount"),
                                  FIELDCAPTION(Amount));
                            IF "Currency Code" <> '' THEN
                                IF "Bal. VAT Amount (LCY)" + "Bal. VAT Base Amount (LCY)" <> -"Amount (LCY)" THEN
                                    ERROR(
                                      Text006, FIELDCAPTION("Bal. VAT Amount (LCY)"),
                                      FIELDCAPTION("Bal. VAT Base Amount (LCY)"), FIELDCAPTION("Amount (LCY)"));
                        END;

                        QBCodeunitPublisher.AdditionalControlGenJnlCheckLine(GenJnlLine);

                    END;
                "Bal. Account Type"::Customer, "Bal. Account Type"::Vendor, "Bal. Account Type"::Employee:
                    BEGIN
                        TESTFIELD("Bal. Gen. Posting Type", 0);
                        TESTFIELD("Bal. Gen. Bus. Posting Group", '');
                        TESTFIELD("Bal. Gen. Prod. Posting Group", '');
                        TESTFIELD("Bal. VAT Bus. Posting Group", '');
                        TESTFIELD("Bal. VAT Prod. Posting Group", '');

                        IF (("Bal. Account Type" = "Bal. Account Type"::Customer) AND
                            ("Gen. Posting Type" = "Gen. Posting Type"::Purchase)) OR
                           (("Bal. Account Type" = "Bal. Account Type"::Vendor) AND
                            ("Gen. Posting Type" = "Gen. Posting Type"::Sale))
                        THEN
                            ERROR(
                              Text010,
                              FIELDCAPTION("Bal. Account Type"), "Bal. Account Type",
                              FIELDCAPTION("Gen. Posting Type"), "Gen. Posting Type");

                        CheckBalDocType(GenJnlLine);

                        IF ((Amount > 0) XOR ("Sales/Purch. (LCY)" < 0)) AND (Amount <> 0) AND ("Sales/Purch. (LCY)" <> 0) THEN
                            FIELDERROR("Sales/Purch. (LCY)", STRSUBSTNO(Text009, FIELDCAPTION(Amount)));

                        //JAV 03/12/20: - QB 1.07.10 Si es un movimiento WIP si puede tener proyecto
                        //TESTFIELD("Job No.",'');
                        IF ("Document Type" <> "Document Type"::WIP) THEN
                            TESTFIELD("Job No.", '');
                        //JAV fin

                        CheckICPartner("Bal. Account Type".AsInteger(), "Bal. Account No.", "Document Type");//enum to option
                    END;
                "Bal. Account Type"::"Bank Account":
                    BEGIN
                        TESTFIELD("Bal. Gen. Posting Type", 0);
                        TESTFIELD("Bal. Gen. Bus. Posting Group", '');
                        TESTFIELD("Bal. Gen. Prod. Posting Group", '');
                        TESTFIELD("Bal. VAT Bus. Posting Group", '');
                        TESTFIELD("Bal. VAT Prod. Posting Group", '');
                        IF (Amount > 0) AND ("Bank Payment Type" = "Bank Payment Type"::"Computer Check") THEN
                            TESTFIELD("Check Printed", TRUE);
                        IF ("Bank Payment Type" = "Bank Payment Type"::"Electronic Payment") OR
                           ("Bank Payment Type" = "Bank Payment Type"::"Electronic Payment-IAT")
                        THEN
                            TESTFIELD("Exported to Payment File", TRUE);
                    END;
                "Bal. Account Type"::"IC Partner":
                    BEGIN
                        ICPartner.GET("Bal. Account No.");
                        ICPartner.CheckICPartner;
                        IF GenJnlTemplate.Type <> GenJnlTemplate.Type::Intercompany THEN
                            FIELDERROR("Bal. Account Type");
                    END;
            END;
    END;

    //[External]
    PROCEDURE CheckSalesDocNoIsNotUsed(DocType: Enum "Gen. Journal Document Type"; DocNo: Code[20]);
    VAR
        OldCustLedgEntry: Record 21;
        IsHandled: Boolean;
    BEGIN
        IsHandled := FALSE;
        OnBeforeCheckSalesDocNoIsNotUsed(DocType, DocNo, IsHandled);
        IF IsHandled THEN
            EXIT;

        OldCustLedgEntry.SETRANGE("Document No.", DocNo);
        OldCustLedgEntry.SETRANGE("Document Type", DocType);
        IF OldCustLedgEntry.FINDFIRST THEN
            ERROR(SalesDocAlreadyExistsErr, OldCustLedgEntry."Document Type", DocNo);
    END;

    //[External]
    PROCEDURE CheckPurchDocNoIsNotUsed(DocType: Enum "Gen. Journal Document Type"; DocNo: Code[20]);
    VAR
        OldVendLedgEntry: Record 25;
        IsHandled: Boolean;
    BEGIN
        IsHandled := FALSE;
        OnBeforeCheckPurchDocNoIsNotUsed(DocType, DocNo, IsHandled);
        IF IsHandled THEN
            EXIT;

        OldVendLedgEntry.SETRANGE("Document No.", DocNo);
        OldVendLedgEntry.SETRANGE("Document Type", DocType);
        IF OldVendLedgEntry.FINDFIRST THEN
            ERROR(PurchDocAlreadyExistsErr, OldVendLedgEntry."Document Type", DocNo);
    END;

    LOCAL PROCEDURE CheckDocType(GenJnlLine: Record 81);
    VAR
        IsPayment: Boolean;
        IsHandled: Boolean;
    BEGIN
        IsHandled := FALSE;
        OnBeforeCheckDocType(GenJnlLine, IsHandled);
        IF IsHandled THEN
            EXIT;

        WITH GenJnlLine DO
            IF "Document Type".AsInteger() <> 0 THEN BEGIN
                IF ("Account Type" = "Account Type"::Employee) AND NOT
                   ("Document Type" IN ["Document Type"::Payment, "Document Type"::" "])
                THEN
                    FIELDERROR("Document Type", EmployeeAccountDocTypeErr);

                IsPayment := "Document Type" IN ["Document Type"::Payment, "Document Type"::"Credit Memo"];
                IF IsPayment XOR (("Account Type" = "Account Type"::Customer) XOR IsVendorPaymentToCrMemo(GenJnlLine)) THEN
                    ErrorIfNegativeAmt(GenJnlLine)
                ELSE
                    ErrorIfPositiveAmt(GenJnlLine);
            END;
    END;

    LOCAL PROCEDURE CheckBalDocType(GenJnlLine: Record 81);
    VAR
        IsPayment: Boolean;
        IsHandled: Boolean;
    BEGIN
        IsHandled := FALSE;
        OnBeforeCheckBalDocType(GenJnlLine, IsHandled);
        IF IsHandled THEN
            EXIT;

        WITH GenJnlLine DO
            IF "Document Type".AsInteger() <> 0 THEN BEGIN
                IF ("Bal. Account Type" = "Bal. Account Type"::Employee) AND NOT
                   ("Document Type" IN ["Document Type"::Payment, "Document Type"::" "])
                THEN
                    FIELDERROR("Document Type", EmployeeBalancingDocTypeErr);

                IsPayment := "Document Type" IN ["Document Type"::Payment, "Document Type"::"Credit Memo"];
                IF IsPayment = ("Bal. Account Type" = "Bal. Account Type"::Customer) THEN
                    ErrorIfNegativeAmt(GenJnlLine)
                ELSE
                    ErrorIfPositiveAmt(GenJnlLine);
            END;
    END;

    LOCAL PROCEDURE CheckICPartner(AccountType: Option "G/L Account","Customer","Vendor","Bank Account","Fixed Asset","IC Partner","Employee"; AccountNo: Code[20]; DocumentType: Enum "Gen. Journal Document Type");
    VAR
        Customer: Record 18;
        Vendor: Record 23;
        ICPartner: Record 413;
        Employee: Record 5200;
        CheckDone: Boolean;
    BEGIN
        OnBeforeCheckICPartner(AccountType, AccountNo, DocumentType, CheckDone);
        IF CheckDone THEN
            EXIT;

        CASE AccountType OF
            AccountType::Customer:
                IF Customer.GET(AccountNo) THEN BEGIN
                    Customer.CheckBlockedCustOnJnls(Customer, DocumentType, TRUE);//option to enum
                    IF (Customer."IC Partner Code" <> '') AND (GenJnlTemplate.Type = GenJnlTemplate.Type::Intercompany) AND
                       ICPartner.GET(Customer."IC Partner Code")
                    THEN
                        ICPartner.CheckICPartnerIndirect(FORMAT(AccountType), AccountNo);
                END;
            AccountType::Vendor:
                IF Vendor.GET(AccountNo) THEN BEGIN
                    Vendor.CheckBlockedVendOnJnls(Vendor, DocumentType, TRUE);//option to enum
                    IF (Vendor."IC Partner Code" <> '') AND (GenJnlTemplate.Type = GenJnlTemplate.Type::Intercompany) AND
                       ICPartner.GET(Vendor."IC Partner Code")
                    THEN
                        ICPartner.CheckICPartnerIndirect(FORMAT(AccountType), AccountNo);
                END;
            AccountType::Employee:
                IF Employee.GET(AccountNo) THEN
                    Employee.CheckBlockedEmployeeOnJnls(TRUE)
        END;
    END;

    LOCAL PROCEDURE CheckDimensions(GenJnlLine: Record 81);
    VAR
        TableID: ARRAY[10] OF Integer;
        No: ARRAY[10] OF Code[20];
        CheckDone: Boolean;
    BEGIN
        OnBeforeCheckDimensions(GenJnlLine, CheckDone);
        IF CheckDone THEN
            EXIT;

        WITH GenJnlLine DO BEGIN
            IF NOT DimMgt.CheckDimIDComb("Dimension Set ID") THEN
                ThrowGenJnlLineError(GenJnlLine, Text011, DimMgt.GetDimCombErr);

            TableID[1] := DimMgt1.TypeToTableID1("Account Type");//enum to option
            No[1] := "Account No.";
            TableID[2] := DimMgt1.TypeToTableID1("Bal. Account Type");//enum to option
            No[2] := "Bal. Account No.";
            TableID[3] := DATABASE::Job;
            No[3] := "Job No.";
            TableID[4] := DATABASE::"Salesperson/Purchaser";
            No[4] := "Salespers./Purch. Code";
            TableID[5] := DATABASE::Campaign;
            No[5] := "Campaign No.";
            IF NOT DimMgt.CheckDimValuePosting(TableID, No, "Dimension Set ID") THEN
                ThrowGenJnlLineError(GenJnlLine, Text012, DimMgt.GetDimValuePostingErr);
        END;
    END;

    LOCAL PROCEDURE IsVendorPaymentToCrMemo(GenJournalLine: Record 81): Boolean;
    VAR
        GenJournalTemplate: Record 80;
    BEGIN
        WITH GenJournalLine DO BEGIN
            IF ("Account Type" = "Account Type"::Vendor) AND
               ("Document Type" = "Document Type"::Payment) AND
               ("Applies-to Doc. Type" = "Applies-to Doc. Type"::"Credit Memo") AND
               ("Applies-to Doc. No." <> '')
            THEN BEGIN
                GenJournalTemplate.GET("Journal Template Name");
                EXIT(GenJournalTemplate.Type = GenJournalTemplate.Type::Payments);
            END;
            EXIT(FALSE);
        END;
    END;

    LOCAL PROCEDURE ThrowGenJnlLineError(GenJournalLine: Record 81; ErrorTemplate: Text; ErrorText: Text);
    BEGIN
        WITH GenJournalLine DO
            IF "Line No." <> 0 THEN
                ERROR(
                  ErrorTemplate,
                  TABLECAPTION, "Journal Template Name", "Journal Batch Name", "Line No.",
                  ErrorText);
        ERROR(ErrorText);
    END;

    //[External]
    PROCEDURE SetBatchMode(NewBatchMode: Boolean);
    BEGIN
        IsBatchMode := NewBatchMode;
    END;

    LOCAL PROCEDURE CheckGenProdPostingGroupWhenAdjustForPmtDisc(GenJnlLine: Record 81);
    VAR
        VATPostingSetup: Record 325;
    BEGIN
        WITH GenJnlLine DO BEGIN
            IF "System-Created Entry" OR
               NOT ("Gen. Posting Type" IN ["Gen. Posting Type"::Purchase, "Gen. Posting Type"::Sale]) OR
               NOT ("Document Type" IN ["Document Type"::Invoice, "Document Type"::"Credit Memo"])
            THEN
                EXIT;

            IF VATPostingSetup.GET("VAT Bus. Posting Group", "VAT Prod. Posting Group") AND
               VATPostingSetup."Adjust for Payment Discount"
            THEN
                TESTFIELD("Gen. Prod. Posting Group");
        END;
    END;

    LOCAL PROCEDURE CheckBalGenProdPostingGroupWhenAdjustForPmtDisc(GenJnlLine: Record 81);
    VAR
        VATPostingSetup: Record 325;
    BEGIN
        WITH GenJnlLine DO BEGIN
            IF "System-Created Entry" OR
               NOT ("Bal. Gen. Posting Type" IN ["Bal. Gen. Posting Type"::Purchase, "Bal. Gen. Posting Type"::Sale]) OR
               NOT ("Document Type" IN ["Document Type"::Invoice, "Document Type"::"Credit Memo"])
            THEN
                EXIT;

            IF VATPostingSetup.GET("Bal. VAT Bus. Posting Group", "Bal. VAT Prod. Posting Group") AND
               VATPostingSetup."Adjust for Payment Discount"
            THEN
                TESTFIELD("Bal. Gen. Prod. Posting Group");
        END;
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterCheckGenJnlLine(VAR GenJournalLine: Record 81);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterDateNoAllowed(PostingDate: Date; VAR DateIsNotAllowed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeDateNotAllowed(GenJnlLine: Record 81; VAR DateCheckDone: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeCheckAccountNo(VAR GenJnlLine: Record 81; VAR CheckDone: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeCheckBalAccountNo(VAR GenJnlLine: Record 81; VAR CheckDone: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeCheckDimensions(VAR GenJnlLine: Record 81; VAR CheckDone: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeCheckDocType(GenJournalLine: Record 81; VAR IsHandled: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeCheckBalDocType(GenJournalLine: Record 81; VAR IsHandled: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeCheckICPartner(AccountType: Option "G/L Account","Customer","Vendor","Bank Account","Fixed Asset","IC Partner"; AccountNo: Code[20]; DocumentType: Enum "Gen. Journal Document Type"; VAR CheckDone: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeCheckSalesDocNoIsNotUsed(DocType: Enum "Gen. Journal Document Type"; DocNo: Code[20]; VAR IsHandled: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeCheckPurchDocNoIsNotUsed(DocType: Enum "Gen. Journal Document Type"; DocNo: Code[20]; VAR IsHandled: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeErrorIfNegativeAmt(GenJnlLine: Record 81; VAR RaiseError: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeErrorIfPositiveAmt(GenJnlLine: Record 81; VAR RaiseError: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeRunCheck(VAR GenJournalLine: Record 81);
    BEGIN
    END;



    /*BEGIN
/*{
      QB_180720: Condici�n para no chequear los movs. de retenci�n.
      JAV 24/10/19: - Se elimina QB_180720 pues ya no tiene sentido con las nuevas retenciones
      QB 1.09.20 05/10/21
    }
END.*/
}








