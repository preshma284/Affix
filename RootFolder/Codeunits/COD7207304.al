Codeunit 7207304 "Post Expense Notes"
{


    TableNo = 7207320;
    Permissions = TableData 25 = rimd,
                TableData 7207323 = rimd,
                TableData 7207324 = rimd;
    trigger OnRun()
    VAR
        UpdateAnalysisView: Codeunit 410;
    BEGIN
        IF PostingDateExists AND (ReplacePostingDate OR (rec."Posting Date" = 0D)) THEN
            rec.VALIDATE(rec."Posting Date", PostingDate);

        CLEARALL;
        ExpenseNotesHeader.COPY(Rec);

        WITH ExpenseNotesHeader DO BEGIN

            CheckDim;

            QuoBuildingSetup.GET;
            QuoBuildingSetup.TESTFIELD("Expense Notes Book");
            QuoBuildingSetup.TESTFIELD("Expense Notes Batch Book");

            GenJournalLine.LOCKTABLE;

            GenJournalLine.RESET;
            GenJournalLine.SETRANGE("Journal Template Name", QuoBuildingSetup."Expense Notes Book");
            GenJournalLine.SETRANGE("Journal Batch Name", QuoBuildingSetup."Expense Notes Batch Book");
            GenJournalLine.DELETEALL;

            //Comprobamos los campos obligatorios
            TESTFIELD(Employee);
            TESTFIELD("Expense Note Date");
            TESTFIELD("Posting Date");
            TESTFIELD("Payment Method Code");
            PurchaseConfig.GET;
            PurchaseConfig.TESTFIELD("Invoice Exp. Notes No. Series");

            //Comprobamos los campos que deben de ser obligatorios al registrar el documento.
            Vendor.GET(Employee);
            Vendor.TESTFIELD(Blocked, 0);

            Window.OPEN(
              '#1#################################\\' +
              Text005 +
              Text006 +
              Text007 +
              Text7000000);

            Window.UPDATE(1, STRSUBSTNO('%1', "No."));
            //Comprobamos que el n� de serie de registro este relleno
            TESTFIELD("Posting No. Series");

            //Bloqueamos las tablas a usar
            IF RECORDLEVELLOCKING THEN BEGIN
                ExpenseNotesLines.LOCKTABLE;
                GLEntry.LOCKTABLE;
                IF GLEntry.FIND('+') THEN;
            END;


            //Tomamos el c�d. de origen.
            SourceCodeSetup.GET;
            SourceCodeSetup.TESTFIELD(SourceCodeSetup."Expense Notes");
            SrcCode := SourceCodeSetup."Expense Notes";

            //Creo el documento que ir� al hist�rico de notas de gasto
            HistExpenseNotesHeader.INIT;
            HistExpenseNotesHeader.TRANSFERFIELDS(ExpenseNotesHeader);
            //HistExpenseNotesHeader."Pre-Assigned No. Series" :=  ExpenseNotesHeader."Posting No. Series";
            HistExpenseNotesHeader."No." := NoSeriesMgt.GetNextNo(ExpenseNotesHeader."Posting No. Series", ExpenseNotesHeader."Posting Date", TRUE);
            Window.UPDATE(1, STRSUBSTNO(Text010, "No.", HistExpenseNotesHeader."No."));
            HistExpenseNotesHeader."Source Code" := SrcCode;
            HistExpenseNotesHeader."User ID" := USERID;

            // Lineas
            ExpenseNotesLines.RESET;
            ExpenseNotesLines.SETRANGE("Document No.", "No.");
            LineCount := 0;
            IF ExpenseNotesLines.FIND('-') THEN BEGIN
                REPEAT
                    LineCount := LineCount + 1;
                    Window.UPDATE(2, LineCount);
                    FunCheckLine;
                    FunCreateEntries;
                UNTIL ExpenseNotesLines.NEXT = 0;
            END ELSE
                ERROR(Text001);


            FunGenEmployeePayment;
            FunGenPIT;

            //Q18513+ CPA 23/12/22. Evitar Commit antes de archivar la nota de gastos
            //Movemos la l�nea m�s abajo
            //cduGenJnlPostBatch.RUN(GenJournalLine);
            //Q18513- CPA 23/12/22. Evitar Commit antes de archivar la nota de gastos

            HistExpenseNotesHeader."Dimension Set ID" := ExpenseNotesHeader."Dimension Set ID";
            HistExpenseNotesHeader.INSERT;
            CopyCommentLines(ExpenseNotesHeader."No.", HistExpenseNotesHeader."No.");

            //JAV 29/06/22: - QB 1.10.57 Pasar el documento asociado al hist�rico
            IncomingDocument.RESET;
            IncomingDocument.SETRANGE("Document No.", ExpenseNotesHeader."No.");
            IF (IncomingDocument.FINDSET) THEN
                REPEAT
                    IncomingDocument2.UpdateIncomingDocumentFromPosting(IncomingDocument."Entry No.", ExpenseNotesHeader."Posting Date", HistExpenseNotesHeader."No.");
                UNTIL (IncomingDocument.NEXT = 0);

            // Lineas
            ExpenseNotesLines.RESET;
            ExpenseNotesLines.SETRANGE("Document No.", "No.");
            LineCount := 0;
            IF ExpenseNotesLines.FINDSET THEN BEGIN
                REPEAT
                    LineCount := LineCount + 1;
                    Window.UPDATE(2, LineCount);
                    HistExpenseNotesLines.INIT;
                    HistExpenseNotesLines.TRANSFERFIELDS(ExpenseNotesLines);
                    HistExpenseNotesLines."Document No." := HistExpenseNotesHeader."No.";
                    HistExpenseNotesLines."Dimension Set ID" := ExpenseNotesLines."Dimension Set ID";
                    HistExpenseNotesLines.INSERT;
                UNTIL ExpenseNotesLines.NEXT = 0;
            END;

            DELETE;
            ExpenseNotesLines.DELETEALL;

            CommentLinesExpenNotes.SETRANGE("No.", "No.");
            CommentLinesExpenNotes.DELETEALL;

            //Q18513+. CPA 23/12/2022 Evitar Commit antes de archivar la nota de gastos
            //C�digo copiado de m�s arriba
            cduGenJnlPostBatch.RUN(GenJournalLine);
            //Q18513-. CPA 23/12/2022 Evitar Commit antes de archivar la nota de gastos

            COMMIT;
            FunApplyEmployee;


            CLEAR(GenJournalLine);
            Window.CLOSE;

            UpdateAnalysisView.UpdateAll(0, TRUE);

            Rec := ExpenseNotesHeader;

        END;
    END;

    VAR
        PostingDateExists: Boolean;
        ReplacePostingDate: Boolean;
        PostingDate: Date;
        ExpenseNotesHeader: Record 7207320;
        QuoBuildingSetup: Record 7207278;
        GenJournalLine: Record 81;
        Text032: TextConst ENU = 'The combination of dimensions used in %1 %2 is blocked.', ESP = 'La combinaci�n de dimensiones utilizadas en el documento %1 est� bloqueada.';
        DimMgt: Codeunit 408;
        Text035: TextConst ENU = 'The dimensions used in %1 %2, line no. %3 are invalid.', ESP = 'Las dim. usadas en %1 %2, no. l�n. %3 son inv�lidas';
        Text034: TextConst ENU = 'The dimensions used in %1 %2 are invalid.', ESP = 'Las dimensiones usadas en %1 %2 son inv�lidas';
        Text033: TextConst ENU = 'The combination of dimensions used in %1 %2, line no. %3 is blocked.', ESP = 'La combinaci�n de dimensiones utilizadas en el documento %1  n� l�nea %3 est� bloqueada.';
        PurchaseConfig: Record 312;
        Vendor: Record 23;
        Text005: TextConst ENU = 'Posting lines              #2######\', ESP = 'Registrando l�neas         #2######\';
        Text007: TextConst ENU = 'Posting to vendors         #4######\', ESP = 'Registrando pagos          #4######\';
        Text006: TextConst ENU = 'Posting lines         #2######', ESP = 'Registrando Facturas       #3######\';
        Text7000000: TextConst ENU = 'Creating documents         #6######', ESP = 'Creando documentos         #6######';
        Window: Dialog;
        ExpenseNotesLines: Record 7207321;
        HistExpenseNotesHeader: Record 7207323;
        HistExpenseNotesLines: Record 7207324;
        SourceCodeSetup: Record 242;
        GLSetup: Record 98;
        GLEntry: Record 17;
        SrcCode: Code[10];
        Text010: TextConst ENU = '%1 %2 -> Invoice %3', ESP = '%1 -> Documento %2';
        LineCount: Integer;
        decAmountPITWithholding: Decimal;
        decAmountPayment: Decimal;
        intCountPayments: Integer;
        TipVendMov: Option "Invoice","Credit Memo";
        NoSeriesMgt: Codeunit 396;
        Text001: TextConst ENU = 'There is nothing to post.', ESP = 'No hay nada que registrar.';
        LineNumber: Integer;
        intCountInvoice: Integer;
        codeNumberInvoice: Code[20];
        GLAccount: Record 15;
        optDocType: Option " ","Invoice","Bill";
        cduGenJnlPostBatch: Codeunit 13;
        CommentLinesExpenNotes: Record 7207322;
        CommentLinesExpenNotes2: Record 7207322;
        GenJnlBatch: Record 232;
        IncomingDocument: Record 130;
        IncomingDocument2: Record 130;

    LOCAL PROCEDURE CheckDim();
    VAR
        ExpenseNotesLines2: Record 7207321;
    BEGIN
        ExpenseNotesLines2."Line No" := 0;
        CheckDimValuePosting(ExpenseNotesLines2);
        CheckDimComb(ExpenseNotesLines2);

        ExpenseNotesLines2.SETRANGE("Document No.", ExpenseNotesHeader."No.");
        IF ExpenseNotesLines2.FINDSET THEN
            REPEAT
                CheckDimComb(ExpenseNotesLines2);
                CheckDimValuePosting(ExpenseNotesLines2);
            UNTIL ExpenseNotesLines2.NEXT = 0;
    END;

    LOCAL PROCEDURE CheckDimComb(ExpenseNotesLines2: Record 7207321);
    BEGIN
        IF ExpenseNotesLines2."Line No" = 0 THEN
            IF NOT DimMgt.CheckDimIDComb(ExpenseNotesHeader."Dimension Set ID") THEN
                ERROR(
                  Text032,
                  ExpenseNotesHeader."No.", DimMgt.GetDimCombErr);

        IF ExpenseNotesLines2."Line No" <> 0 THEN
            IF NOT DimMgt.CheckDimIDComb(ExpenseNotesLines2."Dimension Set ID") THEN
                ERROR(
                  Text033,
                  ExpenseNotesHeader."No.", ExpenseNotesLines2."Line No", DimMgt.GetDimCombErr);
    END;

    LOCAL PROCEDURE CheckDimValuePosting(ExpenseNotesLines2: Record 7207321);
    VAR
        TableIDArr: ARRAY[10] OF Integer;
        NumberArr: ARRAY[10] OF Code[20];
    BEGIN
        IF ExpenseNotesLines2."Line No" = 0 THEN BEGIN
            TableIDArr[1] := DATABASE::Vendor;
            NumberArr[1] := ExpenseNotesHeader.Employee;
            IF NOT DimMgt.CheckDimValuePosting(TableIDArr, NumberArr, ExpenseNotesHeader."Dimension Set ID") THEN
                ERROR(
                  Text034,
                  ExpenseNotesHeader."No.", DimMgt.GetDimValuePostingErr);
        END ELSE BEGIN
            TableIDArr[1] := DATABASE::Vendor;
            NumberArr[1] := ExpenseNotesLines2."Vendor No.";
            TableIDArr[2] := DATABASE::Job;
            NumberArr[2] := ExpenseNotesLines2."Job No.";

            IF NOT DimMgt.CheckDimValuePosting(TableIDArr, NumberArr, ExpenseNotesLines2."Dimension Set ID") THEN
                ERROR(
                  Text035,
                  ExpenseNotesHeader."No.", ExpenseNotesLines2."Line No", DimMgt.GetDimValuePostingErr);
        END;
    END;

    PROCEDURE FunCheckLine();
    BEGIN
        //Comprobamos los campos obligatorio de la l�nea de la nota de gasto.
        WITH ExpenseNotesLines DO BEGIN
            TESTFIELD("Job No.");
            TESTFIELD("Expense Date");
            TESTFIELD("Expense Account");
            TESTFIELD(Quantity);
            TESTFIELD("Price Cost");
            IF "Payment Charge Enterprise" THEN
                TESTFIELD("Bal. Account Payment");
            IF "Vendor No." <> '' THEN
                TESTFIELD("No Document Vendor");
        END;
    END;

    PROCEDURE FunCreateEntries();
    BEGIN
        //Generamos los distintos apuntes que genera la l�nea de la nota de gasto.
        WITH ExpenseNotesLines DO BEGIN
            FunGenExpenseAccount;
            IF NOT "Payment Charge Enterprise" THEN
                decAmountPayment += "Total Amount";

            decAmountPITWithholding += "Withholding Amount";

            IF "Vendor No." <> '' THEN BEGIN
                IF ExpenseNotesLines."Total Amount" > 0 THEN
                    TipVendMov := TipVendMov::Invoice
                ELSE
                    TipVendMov := TipVendMov::"Credit Memo";
                FunGenVendorInvoice;
            END;
            IF "Payment Charge Enterprise" THEN BEGIN
                intCountPayments += 1;
                Window.UPDATE(3, intCountPayments);
                FunGenEnterprisePayment;
            END ELSE BEGIN
                IF "Vendor No." <> '' THEN BEGIN
                    intCountPayments += 1;
                    Window.UPDATE(3, intCountPayments);
                    FunGenVendorPayment;
                END;
            END;
        END;
    END;

    PROCEDURE FunGenExpenseAccount();
    VAR
        GenJnlPostLine: Codeunit 12;
        JobJournalLine: Record 210;
        cduJobJnlPostLine: Codeunit 1012;
    BEGIN
        IF (ExpenseNotesLines."Vendor No." <> '') THEN
            EXIT;

        intCountPayments += 1;
        Window.UPDATE(3, intCountPayments);

        WITH ExpenseNotesLines DO BEGIN
            GenJournalLine.INIT;
            GenJournalLine."Journal Template Name" := QuoBuildingSetup."Expense Notes Book";
            GenJournalLine."Journal Batch Name" := QuoBuildingSetup."Expense Notes Batch Book";
            LineNumber += 10000;
            GenJournalLine."Line No." := LineNumber;
            GenJournalLine.INSERT(TRUE);

            GenJournalLine."Posting Date" := ExpenseNotesHeader."Posting Date";
            GenJournalLine."Document No." := HistExpenseNotesHeader."No.";
            GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
            GenJournalLine.VALIDATE("Account No.", "Expense Account");
            GenJournalLine.VALIDATE("Currency Code", "Currency Code");
            GenJournalLine.VALIDATE(Amount, ExpenseNotesLines."Total Amount");

            GenJournalLine.VALIDATE("Job No.", "Job No.");
            GenJournalLine."External Document No." := HistExpenseNotesHeader."No.";
            GenJournalLine.Correction := FALSE;
            GenJournalLine."System-Created Entry" := TRUE;
            GenJournalLine."Source Type" := GenJournalLine."Source Type"::Vendor;
            GenJournalLine."Source No." := ExpenseNotesHeader.Employee;
            GenJournalLine."Source Code" := SrcCode;
            GenJournalLine."Piecework Code" := "No. Job Unit";
            GenJournalLine."Job Task No." := "Job Task No.";
            GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", ExpenseNotesLines."Shortcut Dimension 1 Code");
            GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", ExpenseNotesLines."Shortcut Dimension 2 Code");
            GenJournalLine."Gen. Posting Type" := GenJournalLine."Gen. Posting Type"::" ";
            GenJournalLine.VALIDATE("Gen. Bus. Posting Group", '');
            GenJournalLine.VALIDATE("Gen. Prod. Posting Group", '');
            GenJournalLine.VALIDATE("VAT Bus. Posting Group", '');
            GenJournalLine.VALIDATE("VAT Prod. Posting Group", '');
            GenJournalLine.Description := ExpenseNotesLines.Description;
            GenJournalLine."Dimension Set ID" := "Dimension Set ID";
            //GenJournalLine."OLD_Skip No. Series Control" := TRUE;
            GenJournalLine.MODIFY(TRUE);
        END;
    END;

    PROCEDURE FunGenVendorInvoice();
    VAR
        GLAccount: Record 15;
        GenJnlPostLine: Codeunit 12;
        JobJournalLine: Record 210;
        cduJobJnlPostLine: Codeunit 1012;
    BEGIN
        WITH ExpenseNotesLines DO BEGIN
            IF (ExpenseNotesLines."Vendor No." <> '') THEN BEGIN
                GenJournalLine.RESET;
                GenJournalLine.SETRANGE("Journal Template Name", QuoBuildingSetup."Expense Notes Book");
                GenJournalLine.SETRANGE("Journal Batch Name", QuoBuildingSetup."Expense Notes Batch Book");
                GenJournalLine.SETRANGE("Account Type", GenJournalLine."Account Type"::Vendor);
                GenJournalLine.SETRANGE("Posting Date", ExpenseNotesHeader."Posting Date");
                IF TipVendMov = TipVendMov::Invoice THEN
                    GenJournalLine.SETRANGE("Document Type", GenJournalLine."Document Type"::Invoice)
                ELSE
                    GenJournalLine.SETRANGE("Document Type", GenJournalLine."Document Type"::"Credit Memo");
                GenJournalLine.SETRANGE("Document Date", ExpenseNotesLines."Expense Date");
                GenJournalLine.SETRANGE("Account No.", ExpenseNotesLines."Vendor No.");
                GenJournalLine.SETRANGE("Currency Code", "Currency Code");
                GenJournalLine.SETRANGE("Shortcut Dimension 1 Code", "Shortcut Dimension 1 Code");
                GenJournalLine.SETRANGE("Shortcut Dimension 2 Code", "Shortcut Dimension 2 Code");
                GenJournalLine.SETRANGE("External Document No.", "No Document Vendor");
                GenJournalLine.SETRANGE("Expense Note Code", HistExpenseNotesHeader."No.");
                IF NOT GenJournalLine.FINDFIRST THEN BEGIN
                    intCountInvoice += 1;
                    Window.UPDATE(3, intCountInvoice);
                    codeNumberInvoice := NoSeriesMgt.GetNextNo(PurchaseConfig."Invoice Exp. Notes No. Series", ExpenseNotesHeader."Posting Date", TRUE);

                    GenJournalLine.INIT;
                    GenJournalLine."Journal Template Name" := QuoBuildingSetup."Expense Notes Book";
                    GenJournalLine."Journal Batch Name" := QuoBuildingSetup."Expense Notes Batch Book";
                    LineNumber += 10000;
                    GenJournalLine."Line No." := LineNumber;
                    GenJournalLine.INSERT(TRUE);
                    GenJournalLine."Document No." := codeNumberInvoice;
                    GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                    GenJournalLine."Posting Date" := ExpenseNotesHeader."Posting Date";
                    //GenJournalLine."OLD_Skip No. Series Control" := TRUE;
                    IF TipVendMov = TipVendMov::Invoice THEN
                        GenJournalLine."Document Type" := GenJournalLine."Document Type"::Invoice
                    ELSE
                        GenJournalLine."Document Type" := GenJournalLine."Document Type"::"Credit Memo";

                    GenJournalLine."Document Date" := ExpenseNotesLines."Expense Date";
                    GenJournalLine.VALIDATE("Account No.", ExpenseNotesLines."Vendor No.");
                    GenJournalLine.Description := ExpenseNotesLines.Description;
                    GenJournalLine.VALIDATE("Currency Code", "Currency Code");
                    GenJournalLine.VALIDATE(Amount, -ExpenseNotesLines."Total Amount");
                    GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", "Shortcut Dimension 1 Code");
                    GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", "Shortcut Dimension 2 Code");
                    GenJournalLine."Source Code" := SrcCode;
                    GenJournalLine."System-Created Entry" := TRUE;
                    GenJournalLine."Due Date" := ExpenseNotesHeader."Posting Date";
                    GenJournalLine."External Document No." := "No Document Vendor";
                    GenJournalLine."Expense Note Code" := HistExpenseNotesHeader."No.";
                    GenJournalLine."Dimension Set ID" := ExpenseNotesLines."Dimension Set ID";
                    GenJournalLine.MODIFY(TRUE);
                END ELSE BEGIN
                    codeNumberInvoice := GenJournalLine."Document No.";
                    GenJournalLine.VALIDATE(Amount, GenJournalLine.Amount - ExpenseNotesLines."Total Amount");
                    //GenJournalLine."OLD_Skip No. Series Control" := TRUE;
                    GenJournalLine.MODIFY(TRUE);
                END;
            END;

            GenJournalLine.RESET;
            GenJournalLine.INIT;
            GenJournalLine."Journal Template Name" := QuoBuildingSetup."Expense Notes Book";
            GenJournalLine."Journal Batch Name" := QuoBuildingSetup."Expense Notes Batch Book";
            LineNumber += 10000;
            GenJournalLine."Line No." := LineNumber;
            GenJournalLine.INSERT(TRUE);

            GenJournalLine."Document No." := codeNumberInvoice;
            GenJournalLine."Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
            GenJournalLine."Posting Date" := ExpenseNotesHeader."Posting Date";
            //GenJournalLine."OLD_Skip No. Series Control" := TRUE;
            IF (ExpenseNotesLines."Vendor No." <> '') THEN
                IF TipVendMov = TipVendMov::Invoice THEN
                    GenJournalLine."Document Type" := GenJournalLine."Document Type"::Invoice
                ELSE
                    GenJournalLine."Document Type" := GenJournalLine."Document Type"::"Credit Memo"
            ELSE
                GenJournalLine."Document Type" := GenJournalLine."Document Type"::" ";
            GenJournalLine.VALIDATE("Account No.", ExpenseNotesLines."Expense Account");
            GenJournalLine.Description := ExpenseNotesLines.Description;
            GenJournalLine.VALIDATE("VAT Bus. Posting Group", "VAT Business Posting Group");
            GenJournalLine.VALIDATE("VAT Prod. Posting Group", "VAT Product Posting Group");

            GenJournalLine.VALIDATE("Currency Code", "Currency Code");
            GenJournalLine.VALIDATE(Amount, ExpenseNotesLines."Total Amount");
            GenJournalLine.VALIDATE("Job No.", "Job No.");
            GenJournalLine."Source Type" := GenJournalLine."Source Type"::Vendor;
            GenJournalLine."Source No." := ExpenseNotesLines."Vendor No.";
            GenJournalLine."Source Code" := SrcCode;
            GenJournalLine."System-Created Entry" := TRUE;
            GenJournalLine."Due Date" := ExpenseNotesHeader."Posting Date";
            GenJournalLine.VALIDATE("Bill-to/Pay-to No.", "Vendor No.");
            GenJournalLine."External Document No." := "No Document Vendor";
            GenJournalLine."Expense Note Code" := HistExpenseNotesHeader."No.";
            GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", ExpenseNotesLines."Shortcut Dimension 1 Code");
            GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", ExpenseNotesLines."Shortcut Dimension 2 Code");
            GenJournalLine."Piecework Code" := ExpenseNotesLines."No. Job Unit";
            GenJournalLine."Job Task No." := ExpenseNotesLines."Job Task No.";
            GenJournalLine."Dimension Set ID" := ExpenseNotesLines."Dimension Set ID";
            GenJournalLine.MODIFY(TRUE);
        END;
    END;

    PROCEDURE FunGenEnterprisePayment();
    VAR
        GLAccount: Record 15;
        GenJnlPostLine: Codeunit 12;
        JobJournalLine: Record 210;
        cduJobJnlPostLine: Codeunit 1012;
    BEGIN
        WITH ExpenseNotesLines DO BEGIN
            IF (ExpenseNotesLines."Vendor No." <> '') THEN BEGIN
                GenJournalLine.INIT;
                GenJournalLine."Journal Template Name" := QuoBuildingSetup."Expense Notes Book";
                GenJournalLine."Journal Batch Name" := QuoBuildingSetup."Expense Notes Batch Book";
                LineNumber += 10000;
                GenJournalLine."Line No." := LineNumber;
                GenJournalLine.INSERT(TRUE);

                GenJournalLine."Document No." := HistExpenseNotesHeader."No.";
                GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                GenJournalLine."Posting Date" := ExpenseNotesHeader."Posting Date";
                GenJournalLine."Document Type" := GenJournalLine."Document Type"::Payment;
                GenJournalLine.VALIDATE("Account No.", ExpenseNotesLines."Vendor No.");
                IF ExpenseNotesHeader."Posting Description" <> '' THEN
                    GenJournalLine.Description := UPPERCASE(ExpenseNotesHeader."Posting Description")
                ELSE
                    GenJournalLine.Description := UPPERCASE(ExpenseNotesHeader."Expense Description");
                GenJournalLine.VALIDATE("Currency Code", "Currency Code");
                GenJournalLine.VALIDATE(Amount, ExpenseNotesLines."Total Amount");
                GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", "Shortcut Dimension 1 Code");
                GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", "Shortcut Dimension 2 Code");
                GenJournalLine."Source Code" := SrcCode;
                GenJournalLine."System-Created Entry" := TRUE;
                GenJournalLine."Due Date" := ExpenseNotesHeader."Posting Date";
                GenJournalLine."Bill-to/Pay-to No." := "Vendor No.";
                GenJournalLine."External Document No." := "No Document Vendor";
                IF TipVendMov = TipVendMov::Invoice THEN
                    GenJournalLine."Applies-to Doc. Type" := GenJournalLine."Applies-to Doc. Type"::Invoice
                ELSE
                    GenJournalLine."Applies-to Doc. Type" := GenJournalLine."Applies-to Doc. Type"::"Credit Memo";
                GenJournalLine."Applies-to Doc. No." := codeNumberInvoice;
                GenJournalLine."Expense Note Code" := HistExpenseNotesHeader."No.";
                GenJournalLine.MODIFY(TRUE);
            END;
            //GenJournalLine."OLD_Skip No. Series Control" := TRUE;
            GenJournalLine."Journal Template Name" := QuoBuildingSetup."Expense Notes Book";
            GenJournalLine."Journal Batch Name" := QuoBuildingSetup."Expense Notes Batch Book";
            LineNumber += 10000;
            GenJournalLine."Line No." := LineNumber;
            GenJournalLine.INSERT(TRUE);
            GenJournalLine."Document No." := HistExpenseNotesHeader."No.";
            IF ExpenseNotesLines."Bal. Account Type" = ExpenseNotesLines."Bal. Account Type"::" " THEN BEGIN
                GenJournalLine."Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
            END ELSE BEGIN
                GenJournalLine."Account Type" := GenJournalLine."Bal. Account Type"::"Bank Account";
            END;
            GenJournalLine."Posting Date" := ExpenseNotesHeader."Posting Date";
            GenJournalLine."Document Type" := GenJournalLine."Document Type"::Payment;
            GenJournalLine.VALIDATE("Account No.", ExpenseNotesLines."Bal. Account Payment");
            IF ExpenseNotesHeader."Posting Description" <> '' THEN
                GenJournalLine.Description := UPPERCASE(ExpenseNotesHeader."Posting Description")
            ELSE
                GenJournalLine.Description := UPPERCASE(ExpenseNotesHeader."Expense Description");
            GenJournalLine.VALIDATE("Currency Code", "Currency Code");
            GenJournalLine.VALIDATE(Amount, -ExpenseNotesLines."Total Amount");
            GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", "Shortcut Dimension 1 Code");
            GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", "Shortcut Dimension 2 Code");
            GenJournalLine."Source Code" := SrcCode;
            GenJournalLine."System-Created Entry" := TRUE;
            GenJournalLine."Due Date" := ExpenseNotesHeader."Posting Date";
            GenJournalLine."External Document No." := "No Document Vendor";
            IF GenJournalLine."Account Type" = GenJournalLine."Account Type"::"G/L Account" THEN BEGIN
                GLAccount.GET(GenJournalLine."Account No.");
                IF GLAccount."Income/Balance" = GLAccount."Income/Balance"::"Income Statement" THEN
                    GenJournalLine.VALIDATE("Job No.", "Job No.");
            END;
            GenJournalLine."Applies-to Doc. Type" := GenJournalLine."Applies-to Doc. Type"::" ";
            GenJournalLine."Applies-to Doc. No." := '';
            GenJournalLine.MODIFY(TRUE);
        END;
    END;

    PROCEDURE FunGenVendorPayment();
    VAR
        GLAccount: Record 15;
        GenJnlPostLine: Codeunit 12;
        JobJournalLine: Record 210;
        cduJobJnlPostLine: Codeunit 1012;
    BEGIN
        IF (ExpenseNotesLines."Vendor No." = '') THEN
            EXIT;
        WITH ExpenseNotesLines DO BEGIN
            GenJournalLine.RESET;
            GenJournalLine.SETRANGE("Journal Template Name", QuoBuildingSetup."Expense Notes Book");
            GenJournalLine.SETRANGE("Journal Batch Name", QuoBuildingSetup."Expense Notes Batch Book");
            GenJournalLine.SETRANGE("Document No.", HistExpenseNotesHeader."No.");
            GenJournalLine.SETRANGE("Account Type", GenJournalLine."Bal. Account Type"::Vendor);
            GenJournalLine.SETRANGE("Posting Date", ExpenseNotesHeader."Posting Date");
            GenJournalLine.SETRANGE("Document Type", GenJournalLine."Document Type"::Payment);
            GenJournalLine.SETRANGE("Account No.", "Vendor No.");
            GenJournalLine.SETRANGE("Currency Code", "Currency Code");
            GenJournalLine.SETRANGE("Shortcut Dimension 1 Code", "Shortcut Dimension 1 Code");
            GenJournalLine.SETRANGE("Shortcut Dimension 2 Code", "Shortcut Dimension 2 Code");
            GenJournalLine.SETRANGE("External Document No.", "No Document Vendor");
            IF TipVendMov = TipVendMov::Invoice THEN
                GenJournalLine.SETRANGE("Applies-to Doc. Type", GenJournalLine."Applies-to Doc. Type"::Invoice)
            ELSE
                GenJournalLine.SETRANGE("Applies-to Doc. Type", GenJournalLine."Applies-to Doc. Type"::"Credit Memo");
            GenJournalLine.SETRANGE("Applies-to Doc. No.", codeNumberInvoice);
            GenJournalLine.SETRANGE("Expense Note Code", HistExpenseNotesHeader."No.");
            IF NOT GenJournalLine.FINDFIRST THEN BEGIN
                GenJournalLine.INIT;
                GenJournalLine."Journal Template Name" := QuoBuildingSetup."Expense Notes Book";
                GenJournalLine."Journal Batch Name" := QuoBuildingSetup."Expense Notes Batch Book";
                LineNumber += 10000;
                GenJournalLine."Line No." := LineNumber;
                GenJournalLine.INSERT(TRUE);

                GenJournalLine."Document No." := HistExpenseNotesHeader."No.";
                GenJournalLine."Account Type" := GenJournalLine."Bal. Account Type"::Vendor;
                GenJournalLine."Posting Date" := ExpenseNotesHeader."Posting Date";
                GenJournalLine.VALIDATE("Account No.", "Vendor No.");
                //GenJournalLine."OLD_Skip No. Series Control" := TRUE;
                IF ExpenseNotesHeader."Posting Description" <> '' THEN
                    GenJournalLine.Description := UPPERCASE(ExpenseNotesHeader."Posting Description")
                ELSE
                    GenJournalLine.Description := UPPERCASE(ExpenseNotesHeader."Expense Description");
                GenJournalLine."Document Type" := GenJournalLine."Document Type"::Payment;
                GenJournalLine.VALIDATE("Account No.", "Vendor No.");
                GenJournalLine.VALIDATE("Currency Code", "Currency Code");
                GenJournalLine.VALIDATE(Amount, ExpenseNotesLines."Total Amount");
                GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", "Shortcut Dimension 1 Code");
                GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", "Shortcut Dimension 2 Code");
                GenJournalLine."Source Code" := SrcCode;
                GenJournalLine."System-Created Entry" := TRUE;
                GenJournalLine."Due Date" := ExpenseNotesHeader."Posting Date";
                GenJournalLine."External Document No." := "No Document Vendor";
                IF TipVendMov = TipVendMov::Invoice THEN
                    GenJournalLine."Applies-to Doc. Type" := GenJournalLine."Applies-to Doc. Type"::Invoice
                ELSE
                    GenJournalLine."Applies-to Doc. Type" := GenJournalLine."Applies-to Doc. Type"::"Credit Memo";
                GenJournalLine."Applies-to Doc. No." := codeNumberInvoice;
                GenJournalLine."Expense Note Code" := HistExpenseNotesHeader."No.";
                GenJournalLine.MODIFY(TRUE);
            END ELSE BEGIN
                GenJournalLine.VALIDATE(Amount, GenJournalLine.Amount + ExpenseNotesLines."Total Amount");
                //GenJournalLine."OLD_Skip No. Series Control" := TRUE;
                GenJournalLine.MODIFY(TRUE);
            END;
            GenJournalLine.RESET;
        END;
    END;

    PROCEDURE FunGenEmployeePayment();
    VAR
        GenJnlPostLine: Codeunit 12;
        recLinDiaProyecto: Record 210;
        cduRegDiario: Codeunit 1012;
        locExpenseLines: Record 7207321;
        locTotalWithholding: Decimal;
        locVendor: Record 23;
        locPayMethod: Record 289;
    BEGIN
        IF decAmountPayment = 0 THEN
            EXIT;

        intCountPayments += 1;
        Window.UPDATE(3, intCountPayments);

        optDocType := optDocType::" ";
        locVendor.GET(ExpenseNotesHeader.Employee);
        locPayMethod.GET(ExpenseNotesHeader."Payment Method Code");

        //JAV 08/03/22: - QB 1.10.23 Las notas de gastos no pueden generar una factura, entre otras cosas no lleva IVA ni puede ir al SII
        //IF locPayMethod."Invoices to Cartera" THEN
        //  optDocType := optDocType::Invoice
        //ELSE
        IF locPayMethod."Create Bills" THEN
            optDocType := optDocType::Bill
        ELSE
            optDocType := optDocType::" ";

        WITH ExpenseNotesLines DO BEGIN
            GenJournalLine.INIT;
            GenJournalLine."Journal Template Name" := QuoBuildingSetup."Expense Notes Book";
            GenJournalLine."Journal Batch Name" := QuoBuildingSetup."Expense Notes Batch Book";
            LineNumber += 10000;
            GenJournalLine."Line No." := LineNumber;
            GenJournalLine.INSERT(TRUE);
            GenJournalLine."Posting Date" := ExpenseNotesHeader."Posting Date";
            GenJournalLine."Document No." := HistExpenseNotesHeader."No.";
            //GenJournalLine."OLD_Skip No. Series Control" := TRUE;
            CASE optDocType OF
                optDocType::" ":
                    BEGIN
                        GenJournalLine."Document Type" := GenJournalLine."Document Type"::" ";
                        GenJournalLine."Document Date" := 0D;
                        GenJournalLine."Due Date" := 0D;
                    END;
                optDocType::Invoice:
                    BEGIN
                        GenJournalLine."Document Type" := GenJournalLine."Document Type"::Invoice;
                        GenJournalLine."Document Date" := GenJournalLine."Posting Date";
                        GenJournalLine."Due Date" := GenJournalLine."Posting Date";
                    END;
                optDocType::Bill:
                    BEGIN
                        GenJournalLine."Document Type" := GenJournalLine."Document Type"::Bill;
                        GenJournalLine."Bill No." := '1';
                        GenJournalLine."Document Date" := GenJournalLine."Posting Date";
                        GenJournalLine."Due Date" := GenJournalLine."Posting Date";
                    END;
            END;

            GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
            GenJournalLine.VALIDATE("Account No.", ExpenseNotesHeader.Employee);
            GenJournalLine.VALIDATE("Currency Code", "Currency Code");
            IF ExpenseNotesHeader."Posting Description" <> '' THEN
                GenJournalLine.Description := UPPERCASE(ExpenseNotesHeader."Posting Description")
            ELSE BEGIN
                GenJournalLine.Description := UPPERCASE(ExpenseNotesHeader."Expense Description");
            END;

            GenJournalLine.VALIDATE(Amount, -decAmountPayment);
            GenJournalLine."External Document No." := HistExpenseNotesHeader."No.";
            GenJournalLine."Gen. Bus. Posting Group" := '';
            GenJournalLine."Gen. Prod. Posting Group" := '';
            IF optDocType = optDocType::" " THEN
                GenJournalLine."Payment Terms Code" := '';

            GenJournalLine."Payment Method Code" := ExpenseNotesHeader."Payment Method Code";
            GenJournalLine.Correction := FALSE;
            GenJournalLine."System-Created Entry" := TRUE;
            GenJournalLine."Source Type" := GenJournalLine."Source Type"::Vendor;
            GenJournalLine."Source No." := ExpenseNotesHeader.Employee;
            GenJournalLine."Source Code" := SrcCode;
            GenJournalLine."Piecework Code" := "No. Job Unit";
            GenJournalLine."Job Task No." := "Job Task No.";
            GenJournalLine."Expense Note Code" := HistExpenseNotesHeader."No.";
            GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", ExpenseNotesHeader."Shortcut Dimension 1 Code");
            GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", ExpenseNotesHeader."Shortcut Dimension 2 Code");
            GenJournalLine."Dimension Set ID" := ExpenseNotesHeader."Dimension Set ID";
            GenJournalLine.MODIFY(TRUE);

            IF (ExpenseNotesHeader."Bal. Account Type" <> ExpenseNotesHeader."Bal. Account Type"::" ") AND
               (ExpenseNotesHeader."Bal. Account Code" <> '') THEN BEGIN
                locTotalWithholding := 0;
                locExpenseLines.SETRANGE("Document No.", ExpenseNotesHeader."No.");
                IF locExpenseLines.FIND('-') THEN BEGIN
                    REPEAT
                        locTotalWithholding := locTotalWithholding + locExpenseLines."Withholding Amount";
                    UNTIL locExpenseLines.NEXT = 0;
                END;
                GenJournalLine.INIT;
                GenJournalLine."Journal Template Name" := QuoBuildingSetup."Expense Notes Book";
                GenJournalLine."Journal Batch Name" := QuoBuildingSetup."Expense Notes Batch Book";
                LineNumber += 10000;
                GenJournalLine."Line No." := LineNumber;
                GenJournalLine.INSERT(TRUE);
                GenJournalLine."Posting Date" := ExpenseNotesHeader."Posting Date";
                IF decAmountPayment - locTotalWithholding > 0 THEN
                    GenJournalLine."Document Type" := GenJournalLine."Document Type"::Payment
                ELSE
                    GenJournalLine."Document Type" := GenJournalLine."Document Type"::" ";
                GenJournalLine."Document No." := HistExpenseNotesHeader."No.";
                GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                GenJournalLine.VALIDATE("Account No.", ExpenseNotesHeader.Employee);
                IF ExpenseNotesHeader."Posting Description" <> '' THEN
                    GenJournalLine.Description := UPPERCASE(ExpenseNotesHeader."Posting Description")
                ELSE
                    GenJournalLine.Description := UPPERCASE(ExpenseNotesHeader."Expense Description");
                GenJournalLine.VALIDATE("Currency Code", "Currency Code");
                GenJournalLine.VALIDATE(Amount, decAmountPayment - locTotalWithholding);

                GenJournalLine."External Document No." := HistExpenseNotesHeader."No.";
                GenJournalLine."Gen. Bus. Posting Group" := '';
                GenJournalLine."Gen. Prod. Posting Group" := '';
                GenJournalLine."Payment Terms Code" := '';
                GenJournalLine.Correction := FALSE;
                GenJournalLine."System-Created Entry" := TRUE;
                GenJournalLine."Source Type" := GenJournalLine."Source Type"::Vendor;
                GenJournalLine."Source No." := ExpenseNotesHeader.Employee;
                GenJournalLine."Source Code" := SrcCode;
                GenJournalLine."Piecework Code" := "No. Job Unit";
                GenJournalLine."Job Task No." := "Job Task No.";
                GenJournalLine."Expense Note Code" := HistExpenseNotesHeader."No.";
                IF ExpenseNotesHeader."Bal. Account Type" = ExpenseNotesHeader."Bal. Account Type"::Account THEN BEGIN
                    GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
                END ELSE BEGIN
                    GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"Bank Account";
                END;
                GenJournalLine.VALIDATE("Bal. Account No.", ExpenseNotesHeader."Bal. Account Code");
                GenJournalLine."Bal. Gen. Posting Type" := GenJournalLine."Bal. Gen. Posting Type"::" ";
                GenJournalLine."Bal. Gen. Bus. Posting Group" := '';
                GenJournalLine."Bal. Gen. Prod. Posting Group" := '';
                GenJournalLine."Bal. VAT Bus. Posting Group" := '';
                GenJournalLine."Bal. VAT Prod. Posting Group" := '';
                CASE optDocType OF
                    optDocType::" ":
                        BEGIN
                            GenJournalLine."Applies-to Doc. Type" := GenJournalLine."Applies-to Doc. Type"::" ";
                            GenJournalLine."Applies-to Bill No." := '';
                        END;
                    optDocType::Invoice:
                        BEGIN
                            GenJournalLine."Applies-to Doc. Type" := GenJournalLine."Applies-to Doc. Type"::Invoice;
                            GenJournalLine."Applies-to Bill No." := '';
                        END;
                    optDocType::Bill:
                        BEGIN
                            GenJournalLine."Applies-to Doc. Type" := GenJournalLine."Applies-to Doc. Type"::Bill;
                            GenJournalLine."Applies-to Bill No." := '1';
                        END;
                END;
                GenJournalLine."Applies-to Doc. No." := GenJournalLine."Document No.";
                GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", ExpenseNotesHeader."Shortcut Dimension 1 Code");
                GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", ExpenseNotesHeader."Shortcut Dimension 2 Code");
                GenJournalLine."Dimension Set ID" := ExpenseNotesHeader."Dimension Set ID";
                GenJournalLine.MODIFY(TRUE);
            END;

        END;
    END;

    PROCEDURE FunGenPIT();
    VAR
        locWithholdingGroup: Record 7207330;
        locGLAccount: Record 15;
        GenJnlPostLine: Codeunit 12;
    BEGIN
        IF ((decAmountPayment = 0) OR (decAmountPITWithholding = 0)) THEN
            EXIT;

        WITH ExpenseNotesLines DO BEGIN
            GenJournalLine.INIT;
            GenJournalLine."Journal Template Name" := QuoBuildingSetup."Expense Notes Book";
            GenJournalLine."Journal Batch Name" := QuoBuildingSetup."Expense Notes Batch Book";
            LineNumber += 10000;
            GenJournalLine."Line No." := LineNumber;
            GenJournalLine.INSERT(TRUE);

            GenJournalLine."Document No." := HistExpenseNotesHeader."No.";
            GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
            GenJournalLine."Posting Date" := ExpenseNotesHeader."Posting Date";
            GenJournalLine."Document Type" := GenJournalLine."Document Type"::" ";
            GenJournalLine.VALIDATE("Account No.", HistExpenseNotesHeader.Employee);
            //GenJournalLine."OLD_Skip No. Series Control" := TRUE;
            IF ExpenseNotesHeader."Posting Description" <> '' THEN
                GenJournalLine.Description := UPPERCASE(ExpenseNotesHeader."Posting Description")
            ELSE
                GenJournalLine.Description := UPPERCASE(ExpenseNotesHeader."Expense Description");

            GenJournalLine.VALIDATE("Currency Code", "Currency Code");
            GenJournalLine.VALIDATE(Amount, decAmountPITWithholding);
            GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", ExpenseNotesHeader."Shortcut Dimension 1 Code");
            GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", ExpenseNotesHeader."Shortcut Dimension 2 Code");
            GenJournalLine."Source Code" := SrcCode;
            GenJournalLine."System-Created Entry" := TRUE;
            CASE optDocType OF
                optDocType::" ":
                    GenJournalLine."Applies-to Doc. Type" := GenJournalLine."Applies-to Doc. Type"::" ";
                optDocType::Invoice:
                    GenJournalLine."Applies-to Doc. Type" := GenJournalLine."Applies-to Doc. Type"::Invoice;
                optDocType::Bill:
                    GenJournalLine."Applies-to Doc. Type" := GenJournalLine."Applies-to Doc. Type"::Bill;
            END;
            GenJournalLine."Applies-to Doc. No." := HistExpenseNotesHeader."No.";
            GenJournalLine."Due Date" := ExpenseNotesHeader."Posting Date";
            GenJournalLine."Bill-to/Pay-to No." := HistExpenseNotesHeader.Employee;
            GenJournalLine."QW Withholding Type" := GenJournalLine."QW Withholding Type"::PIT;

            ExpenseNotesHeader.TESTFIELD("PIT Withholding Group");
            locWithholdingGroup.GET(locWithholdingGroup."Withholding Type"::PIT, ExpenseNotesHeader."PIT Withholding Group");
            GenJournalLine."QW Withholding Group" := ExpenseNotesHeader."PIT Withholding Group";

            GenJournalLine."QW Withholding Due Date" := CALCDATE(locWithholdingGroup."Warranty Period", GenJournalLine."Posting Date");

            locWithholdingGroup.TESTFIELD("Withholding Account");
            locGLAccount.GET(locWithholdingGroup."Withholding Account");
            GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
            GenJournalLine.VALIDATE("Bal. Account No.", locWithholdingGroup."Withholding Account");
            GenJournalLine."Document Date" := ExpenseNotesHeader."Posting Date";
            GenJournalLine."External Document No." := HistExpenseNotesHeader."No.";
            ExpenseNotesHeader.CALCFIELDS(Amount);
            GenJournalLine."QW Withholding Base" := ExpenseNotesHeader.Amount;
            GenJournalLine."Dimension Set ID" := ExpenseNotesHeader."Dimension Set ID";
            GenJournalLine.MODIFY(TRUE);
        END;
    END;

    LOCAL PROCEDURE CopyCommentLines(FromNumber: Code[20]; ToNumber: Code[20]);
    BEGIN
        CommentLinesExpenNotes.SETRANGE("Document Type", CommentLinesExpenNotes."Document Type"::"Expense Notes");
        CommentLinesExpenNotes.SETRANGE("No.", FromNumber);
        IF NOT CommentLinesExpenNotes.FINDFIRST THEN BEGIN
            REPEAT
                CommentLinesExpenNotes2.INIT;
                CommentLinesExpenNotes2 := CommentLinesExpenNotes;
                CommentLinesExpenNotes2."Document Type" := CommentLinesExpenNotes2."Document Type"::"Expense Notes Hist.";
                CommentLinesExpenNotes2."No." := ToNumber;
                CommentLinesExpenNotes2.INSERT;
            UNTIL CommentLinesExpenNotes.NEXT = 0;
        END;
    END;

    PROCEDURE FunApplyEmployee();
    VAR
        locVendorLedgerEntry: Record 25;
        VendEntryApplyPostedEntries: Codeunit 227;
        VendEntryApplyPostedEntries1: Codeunit 50274;
    BEGIN
        IF ExpenseNotesHeader."Applies-to Doc. No." = '' THEN
            EXIT;
        locVendorLedgerEntry.RESET;
        locVendorLedgerEntry.SETCURRENTKEY("Vendor No.", "Posting Date", "Currency Code");
        locVendorLedgerEntry.SETRANGE("Vendor No.", ExpenseNotesHeader.Employee);
        locVendorLedgerEntry.SETRANGE("Document Type", ExpenseNotesHeader."Applies-to Doc. Type");
        locVendorLedgerEntry.SETRANGE("Document No.", ExpenseNotesHeader."Applies-to Doc. No.");
        IF locVendorLedgerEntry.FIND('-') THEN BEGIN
            locVendorLedgerEntry."Applies-to ID" := HistExpenseNotesHeader."No.";
            locVendorLedgerEntry.CALCFIELDS(locVendorLedgerEntry."Remaining Amount");
            locVendorLedgerEntry."Amount to Apply" := locVendorLedgerEntry."Remaining Amount";
            locVendorLedgerEntry.MODIFY;
        END;

        locVendorLedgerEntry.RESET;
        locVendorLedgerEntry.SETCURRENTKEY("Vendor No.", "Posting Date", "Currency Code");
        locVendorLedgerEntry.SETRANGE("Vendor No.", ExpenseNotesHeader.Employee);
        locVendorLedgerEntry.SETRANGE("Document No.", HistExpenseNotesHeader."No.");
        locVendorLedgerEntry.SETRANGE(Open, TRUE);
        IF locVendorLedgerEntry.FINDSET(TRUE) THEN BEGIN
            locVendorLedgerEntry.MODIFYALL(locVendorLedgerEntry."Applies-to ID", HistExpenseNotesHeader."No.");
            locVendorLedgerEntry.FINDSET(TRUE);
            REPEAT
                locVendorLedgerEntry.CALCFIELDS(locVendorLedgerEntry."Remaining Amount");
                locVendorLedgerEntry."Amount to Apply" := locVendorLedgerEntry."Remaining Amount";
                locVendorLedgerEntry.MODIFY;
            UNTIL locVendorLedgerEntry.NEXT = 0;
        END;
        COMMIT;

        locVendorLedgerEntry.SETCURRENTKEY("Vendor No.", "Applies-to ID", Open, Positive, "Due Date");
        locVendorLedgerEntry.SETRANGE("Vendor No.", ExpenseNotesHeader.Employee);
        locVendorLedgerEntry.SETRANGE("Applies-to ID", HistExpenseNotesHeader."No.");
        locVendorLedgerEntry.SETRANGE(Open, TRUE);
        IF NOT locVendorLedgerEntry.FINDFIRST THEN BEGIN
            //JAV 06/07/22: - QB 1.10.59 Se cambia la llamada al registro para usar la CU 227 de manera est�ndar sin necesidad de modificaciones
            CLEAR(VendEntryApplyPostedEntries);
            //VendEntryApplyPostedEntries.QB_FunMakeQuestion(TRUE,HistExpenseNotesHeader."No.",HistExpenseNotesHeader."Posting Date");
            //VendEntryApplyPostedEntries.RUN(locVendorLedgerEntry);
            VendEntryApplyPostedEntries1.Apply(locVendorLedgerEntry, HistExpenseNotesHeader."No.", HistExpenseNotesHeader."Posting Date");
        END;
    END;

    /*BEGIN
/*{
      JAV 23/03/22: - QB 1.10.27 Se elimina el manejo del campo "Skip No. Series Control" que no se emplea para nada
      JAV 06/07/22: - QB 1.10.59 Se cambia la llamada al registro para usar la CU 227 de manera est�ndar sin necesidad de modificaciones
      CPA 23/12/22: - Q18513. Evitar Commit antes de archivar la nota de gastos
    }
END.*/
}







