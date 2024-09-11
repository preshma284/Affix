Codeunit 50009 "Job Post-Line 1"
{


    Permissions = TableData 169 = rm,
                TableData 1003 = rimd;
    trigger OnRun()
    BEGIN
    END;

    VAR
        TempSalesLineJob: Record 37 TEMPORARY;
        TempPurchaseLineJob: Record 39 TEMPORARY;
        TempJobJournalLine: Record 210 TEMPORARY;
        JobJnlPostLine: Codeunit 1012;
        JobTransferLine: Codeunit 1004;
        Text000: TextConst ENU = '"has been changed (initial a %1: %2= %3, %4= %5)"', ESP = '"se ha cambiado (inicial a %1: %2= %3, %4= %5)"';
        Text003: TextConst ENU = 'You cannot change the sales line because it is linked to\', ESP = 'No puede cambiar la l�n. venta porque est� vinculada a\';
        Text004: TextConst ENU = '" %1: %2= %3, %4= %5."', ESP = '" %1: %2= %3, %4= %5."';
        Text005: TextConst ENU = '"You must post more usage or credit the sale of %1 %2 in %3 %4 before you can post purchase credit memo %5 %6 = %7."', ESP = '"Debe registrar m�s uso o ingresar la venta de %1 %2 en %3 %4 antes de registrar el abono compra %5 %6 = %7."';
        "--------------------- QB": Integer;
        FunctionQB: Codeunit 7207272;

    //[External]
    PROCEDURE InsertPlLineFromLedgEntry(JobLedgEntry: Record 169);
    VAR
        JobPlanningLine: Record 1003;
    BEGIN
        IF JobLedgEntry."Line Type" = JobLedgEntry."Line Type"::" " THEN
            EXIT;
        CLEARALL;
        JobPlanningLine."Job No." := JobLedgEntry."Job No.";
        JobPlanningLine."Job Task No." := JobLedgEntry."Job Task No.";
        JobPlanningLine.SETRANGE("Job No.", JobPlanningLine."Job No.");
        JobPlanningLine.SETRANGE("Job Task No.", JobPlanningLine."Job Task No.");
        IF JobPlanningLine.FINDLAST THEN;
        JobPlanningLine."Line No." := JobPlanningLine."Line No." + 10000;
        JobPlanningLine.INIT;
        JobPlanningLine.RESET;
        CLEAR(JobTransferLine);
        JobTransferLine.FromJobLedgEntryToPlanningLine(JobLedgEntry, JobPlanningLine);
        PostPlanningLine(JobPlanningLine);
    END;

    LOCAL PROCEDURE PostPlanningLine(JobPlanningLine: Record 1003);
    VAR
        Job: Record 167;
    BEGIN
        IF JobPlanningLine."Line Type" = JobPlanningLine."Line Type"::"Both Budget and Billable" THEN BEGIN
            Job.GET(JobPlanningLine."Job No.");
            IF NOT Job."Allow Schedule/Contract Lines" OR
               (JobPlanningLine.Type = JobPlanningLine.Type::"G/L Account")
            THEN BEGIN
                JobPlanningLine.VALIDATE("Line Type", JobPlanningLine."Line Type"::Budget);
                JobPlanningLine.INSERT(TRUE);
                InsertJobUsageLink(JobPlanningLine);
                JobPlanningLine.VALIDATE("Qty. to Transfer to Journal", 0);
                JobPlanningLine.MODIFY(TRUE);
                JobPlanningLine."Job Contract Entry No." := 0;
                JobPlanningLine."Line No." := JobPlanningLine."Line No." + 10000;
                JobPlanningLine.VALIDATE("Line Type", JobPlanningLine."Line Type"::Billable);
            END;
        END;
        IF (JobPlanningLine.Type = JobPlanningLine.Type::"G/L Account") AND
           (JobPlanningLine."Line Type" = JobPlanningLine."Line Type"::Billable)
        THEN
            ChangeGLNo(JobPlanningLine);
        JobPlanningLine.INSERT(TRUE);
        JobPlanningLine.VALIDATE("Qty. to Transfer to Journal", 0);
        JobPlanningLine.MODIFY(TRUE);
        IF JobPlanningLine."Line Type" IN
           [JobPlanningLine."Line Type"::Budget, JobPlanningLine."Line Type"::"Both Budget and Billable"]
        THEN
            InsertJobUsageLink(JobPlanningLine);
    END;

    LOCAL PROCEDURE InsertJobUsageLink(JobPlanningLine: Record 1003);
    VAR
        JobUsageLink: Record 1020;
        JobLedgerEntry: Record 169;
    BEGIN
        IF NOT JobPlanningLine."Usage Link" THEN
            EXIT;
        JobLedgerEntry.GET(JobPlanningLine."Job Ledger Entry No.");
        JobUsageLink.Create(JobPlanningLine, JobLedgerEntry);
    END;

    //[External]
    PROCEDURE PostInvoiceContractLine(SalesHeader: Record 36; SalesLine: Record 37);
    VAR
        Job: Record 167;
        JobPlanningLine: Record 1003;
        JobPlanningLineInvoice: Record 1022;
        // EntryType: Option "Usage","Sale";
        EntryType: Enum "Job Journal Line Entry Type";
        JobLedgEntryNo: Integer;
        JobLineChecked: Boolean;
    BEGIN
        OnBeforePostInvoiceContractLine(SalesHeader, SalesLine);

        JobPlanningLine.SETCURRENTKEY("Job Contract Entry No.");
        JobPlanningLine.SETRANGE("Job Contract Entry No.", SalesLine."Job Contract Entry No.");
        JobPlanningLine.FINDFIRST;
        Job.GET(JobPlanningLine."Job No.");

        IF Job."Invoice Currency Code" = '' THEN BEGIN
            Job.TESTFIELD("Currency Code", SalesHeader."Currency Code");
            Job.TESTFIELD("Currency Code", JobPlanningLine."Currency Code");
            SalesHeader.TESTFIELD("Currency Code", JobPlanningLine."Currency Code");
            SalesHeader.TESTFIELD("Currency Factor", JobPlanningLine."Currency Factor");
        END ELSE BEGIN
            Job.TESTFIELD("Currency Code", '');
            JobPlanningLine.TESTFIELD("Currency Code", '');
        END;

        //QB Facturaci�n multicliente
        IF NOT FunctionQB.AccessToQuobuilding THEN
            SalesHeader.TESTFIELD("Bill-to Customer No.", Job."Bill-to Customer No.");
        //QB end

        OnPostInvoiceContractLineBeforeCheckJobLine(SalesHeader, SalesLine, JobPlanningLine, JobLineChecked);
        IF NOT JobLineChecked THEN BEGIN
            JobPlanningLine.CALCFIELDS("Qty. Transferred to Invoice");
            IF JobPlanningLine.Type <> JobPlanningLine.Type::Text THEN
                JobPlanningLine.TESTFIELD("Qty. Transferred to Invoice");
        END;

        ValidateRelationship(SalesHeader, SalesLine, JobPlanningLine);

        CASE SalesHeader."Document Type" OF
            SalesHeader."Document Type"::Invoice:
                IF JobPlanningLineInvoice.GET(JobPlanningLine."Job No.", JobPlanningLine."Job Task No.", JobPlanningLine."Line No.",
                     JobPlanningLineInvoice."Document Type"::Invoice, SalesHeader."No.", SalesLine."Line No.")
                THEN BEGIN
                    JobPlanningLineInvoice.DELETE(TRUE);
                    JobPlanningLineInvoice."Document Type" := JobPlanningLineInvoice."Document Type"::"Posted Invoice";
                    JobPlanningLineInvoice."Document No." := SalesLine."Document No.";
                    JobLedgEntryNo := FindNextJobLedgEntryNo(JobPlanningLineInvoice);
                    JobPlanningLineInvoice.INSERT(TRUE);

                    JobPlanningLineInvoice."Invoiced Date" := SalesHeader."Posting Date";
                    JobPlanningLineInvoice."Invoiced Amount (LCY)" :=
                      CalcLineAmountLCY(JobPlanningLine, JobPlanningLineInvoice."Quantity Transferred");
                    JobPlanningLineInvoice."Invoiced Cost Amount (LCY)" :=
                      JobPlanningLineInvoice."Quantity Transferred" * JobPlanningLine."Unit Cost (LCY)";
                    JobPlanningLineInvoice."Job Ledger Entry No." := JobLedgEntryNo;
                    JobPlanningLineInvoice.MODIFY;
                END;
            SalesHeader."Document Type"::"Credit Memo":
                IF JobPlanningLineInvoice.GET(JobPlanningLine."Job No.", JobPlanningLine."Job Task No.", JobPlanningLine."Line No.",
                     JobPlanningLineInvoice."Document Type"::"Credit Memo", SalesHeader."No.", SalesLine."Line No.")
                THEN BEGIN
                    JobPlanningLineInvoice.DELETE(TRUE);
                    JobPlanningLineInvoice."Document Type" := JobPlanningLineInvoice."Document Type"::"Posted Credit Memo";
                    JobPlanningLineInvoice."Document No." := SalesLine."Document No.";
                    JobLedgEntryNo := FindNextJobLedgEntryNo(JobPlanningLineInvoice);
                    JobPlanningLineInvoice.INSERT(TRUE);

                    JobPlanningLineInvoice."Invoiced Date" := SalesHeader."Posting Date";
                    JobPlanningLineInvoice."Invoiced Amount (LCY)" :=
                      CalcLineAmountLCY(JobPlanningLine, JobPlanningLineInvoice."Quantity Transferred");
                    JobPlanningLineInvoice."Invoiced Cost Amount (LCY)" :=
                      JobPlanningLineInvoice."Quantity Transferred" * JobPlanningLine."Unit Cost (LCY)";
                    JobPlanningLineInvoice."Job Ledger Entry No." := JobLedgEntryNo;
                    JobPlanningLineInvoice.MODIFY;
                END;
        END;

        OnBeforeJobPlanningLineUpdateQtyToInvoice(SalesHeader, SalesLine, JobPlanningLine, JobPlanningLineInvoice, JobLedgEntryNo);

        JobPlanningLine.UpdateQtyToInvoice;
        JobPlanningLine.MODIFY;

        OnAfterJobPlanningLineModify(JobPlanningLine);

        IF JobPlanningLine.Type <> JobPlanningLine.Type::Text THEN
            PostJobOnSalesLine(JobPlanningLine, SalesHeader, SalesLine, EntryType::Sale);

        OnAfterPostInvoiceContractLine(SalesHeader, SalesLine);
    END;

    LOCAL PROCEDURE ValidateRelationship(SalesHeader: Record 36; SalesLine: Record 37; JobPlanningLine: Record 1003);
    VAR
        JobTask: Record 1001;
        Txt: Text[500];
    BEGIN
        JobTask.GET(JobPlanningLine."Job No.", JobPlanningLine."Job Task No.");
        Txt := STRSUBSTNO(Text000,
            JobTask.TABLECAPTION, JobTask.FIELDCAPTION("Job No."), JobTask."Job No.",
            JobTask.FIELDCAPTION("Job Task No."), JobTask."Job Task No.");

        IF JobPlanningLine.Type = JobPlanningLine.Type::Text THEN
            IF SalesLine.Type <> SalesLine.Type::" " THEN
                SalesLine.FIELDERROR(Type, Txt);
        IF JobPlanningLine.Type = JobPlanningLine.Type::Resource THEN
            IF SalesLine.Type <> SalesLine.Type::Resource THEN
                SalesLine.FIELDERROR(Type, Txt);
        IF JobPlanningLine.Type = JobPlanningLine.Type::Item THEN
            IF SalesLine.Type <> SalesLine.Type::Item THEN
                SalesLine.FIELDERROR(Type, Txt);
        IF JobPlanningLine.Type = JobPlanningLine.Type::"G/L Account" THEN
            IF SalesLine.Type <> SalesLine.Type::"G/L Account" THEN
                SalesLine.FIELDERROR(Type, Txt);

        IF SalesLine."No." <> JobPlanningLine."No." THEN
            SalesLine.FIELDERROR("No.", Txt);
        IF SalesLine."Location Code" <> JobPlanningLine."Location Code" THEN
            SalesLine.FIELDERROR("Location Code", Txt);
        IF SalesLine."Work Type Code" <> JobPlanningLine."Work Type Code" THEN
            SalesLine.FIELDERROR("Work Type Code", Txt);
        IF SalesLine."Unit of Measure Code" <> JobPlanningLine."Unit of Measure Code" THEN
            SalesLine.FIELDERROR("Unit of Measure Code", Txt);
        IF SalesLine."Variant Code" <> JobPlanningLine."Variant Code" THEN
            SalesLine.FIELDERROR("Variant Code", Txt);
        IF SalesLine."Gen. Prod. Posting Group" <> JobPlanningLine."Gen. Prod. Posting Group" THEN
            SalesLine.FIELDERROR("Gen. Prod. Posting Group", Txt);
        IF SalesLine."Line Discount %" <> JobPlanningLine."Line Discount %" THEN
            SalesLine.FIELDERROR("Line Discount %", Txt);
        IF JobPlanningLine."Unit Cost (LCY)" <> SalesLine."Unit Cost (LCY)" THEN
            SalesLine.FIELDERROR("Unit Cost (LCY)", Txt);
        IF SalesLine.Type = SalesLine.Type::" " THEN BEGIN
            IF SalesLine."Line Amount" <> 0 THEN
                SalesLine.FIELDERROR("Line Amount", Txt);
        END;
        IF SalesHeader."Prices Including VAT" THEN BEGIN
            IF JobPlanningLine."VAT %" <> SalesLine."VAT %" THEN
                SalesLine.FIELDERROR("VAT %", Txt);
        END;
    END;

    //[External]
    PROCEDURE PostJobOnSalesLine(JobPlanningLine: Record 1003; SalesHeader: Record 36; SalesLine: Record 37; EntryType: Enum "Job Journal Line Entry Type");
    VAR
        JobJnlLine: Record 210;
    BEGIN
        JobTransferLine.FromPlanningSalesLineToJnlLine(JobPlanningLine, SalesHeader, SalesLine, JobJnlLine, EntryType); //option to enum
        IF SalesLine.Type = SalesLine.Type::"G/L Account" THEN BEGIN
            TempSalesLineJob := SalesLine;
            TempSalesLineJob.INSERT;
            InsertTempJobJournalLine(JobJnlLine, TempSalesLineJob."Line No.");
        END ELSE
            JobJnlPostLine.RunWithCheck(JobJnlLine);
    END;

    LOCAL PROCEDURE CalcLineAmountLCY(JobPlanningLine: Record 1003; Qty: Decimal): Decimal;
    VAR
        TotalPrice: Decimal;
    BEGIN
        TotalPrice := ROUND(Qty * JobPlanningLine."Unit Price (LCY)", 0.01);
        EXIT(TotalPrice - ROUND(TotalPrice * JobPlanningLine."Line Discount %" / 100, 0.01));
    END;

    //[External]
    PROCEDURE PostGenJnlLine(GenJnlLine: Record 81; GLEntry: Record 17);
    VAR
        JobJnlLine: Record 210;
        Job: Record 167;
        JT: Record 1001;
        SourceCodeSetup: Record 242;
        JobTransferLine: Codeunit 1004;
    BEGIN
        IF GenJnlLine."System-Created Entry" THEN
            EXIT;
        IF GenJnlLine."Job No." = '' THEN
            EXIT;
        SourceCodeSetup.GET;
        IF GenJnlLine."Source Code" = SourceCodeSetup."Job G/L WIP" THEN
            EXIT;
        GenJnlLine.TESTFIELD("Job Task No.");
        GenJnlLine.TESTFIELD("Job Quantity");
        Job.LOCKTABLE;
        JT.LOCKTABLE;
        Job.GET(GenJnlLine."Job No.");
        GenJnlLine.TESTFIELD("Job Currency Code", Job."Currency Code");
        JT.GET(GenJnlLine."Job No.", GenJnlLine."Job Task No.");
        JT.TESTFIELD("Job Task Type", JT."Job Task Type"::Posting);
        JobTransferLine.FromGenJnlLineToJnlLine(GenJnlLine, JobJnlLine);

        JobJnlPostLine.SetGLEntryNo(GLEntry."Entry No.");
        JobJnlPostLine.RunWithCheck(JobJnlLine);
        JobJnlPostLine.SetGLEntryNo(0);
    END;

    //[External]
    PROCEDURE PostJobOnPurchaseLine(VAR PurchHeader: Record 38; VAR PurchInvHeader: Record 122; VAR PurchCrMemoHdr: Record 124; PurchLine: Record 39; Sourcecode: Code[10]);
    VAR
        JobJnlLine: Record 210;
        Job: Record 167;
        JobTask: Record 1001;
        IsHandled: Boolean;
    BEGIN
        IsHandled := FALSE;
        OnBeforePostJobOnPurchaseLine(PurchHeader, PurchInvHeader, PurchCrMemoHdr, PurchLine, JobJnlLine, IsHandled);
        IF IsHandled THEN
            EXIT;

        //JMMA QUOBUILDING
        //IF (PurchLine.Type <> PurchLine.Type::Item) AND (PurchLine.Type <> PurchLine.Type::"G/L Account") THEN
        //  EXIT;

        CLEAR(JobJnlLine);
        PurchLine.TESTFIELD("Job No.");
        IF NOT FunctionQB.AccessToQuobuilding THEN //QB2516
            PurchLine.TESTFIELD("Job Task No.");
        Job.LOCKTABLE;
        JobTask.LOCKTABLE;
        Job.GET(PurchLine."Job No.");
        IF NOT FunctionQB.AccessToQuobuilding THEN BEGIN //QB2516
            PurchLine.TESTFIELD("Job Currency Code", Job."Currency Code");
            JobTask.GET(PurchLine."Job No.", PurchLine."Job Task No.");
        END;

        JobTransferLine.FromPurchaseLineToJnlLine(
          PurchHeader, PurchInvHeader, PurchCrMemoHdr, PurchLine, Sourcecode, JobJnlLine);
        JobJnlLine."Job Posting Only" := TRUE;

        IF PurchLine.Type = PurchLine.Type::"G/L Account" THEN BEGIN
            TempPurchaseLineJob := PurchLine;
            TempPurchaseLineJob.INSERT;
            InsertTempJobJournalLine(JobJnlLine, TempPurchaseLineJob."Line No.");
        END ELSE
            JobJnlPostLine.RunWithCheck(JobJnlLine);
    END;

    //[External]
    PROCEDURE TestSalesLine(VAR SalesLine: Record 37);
    VAR
        JT: Record 1001;
        JobPlanningLine: Record 1003;
        Txt: Text[250];
    BEGIN
        IF SalesLine."Job Contract Entry No." = 0 THEN
            EXIT;
        JobPlanningLine.SETCURRENTKEY("Job Contract Entry No.");
        JobPlanningLine.SETRANGE("Job Contract Entry No.", SalesLine."Job Contract Entry No.");
        IF JobPlanningLine.FINDFIRST THEN BEGIN
            JT.GET(JobPlanningLine."Job No.", JobPlanningLine."Job Task No.");
            Txt := Text003 + STRSUBSTNO(Text004,
                JT.TABLECAPTION, JT.FIELDCAPTION("Job No."), JT."Job No.",
                JT.FIELDCAPTION("Job Task No."), JT."Job Task No.");
            ERROR(Txt);
        END;
    END;

    LOCAL PROCEDURE ChangeGLNo(VAR JobPlanningLine: Record 1003);
    VAR
        GLAcc: Record 15;
        Job: Record 167;
        JT: Record 1001;
        JobPostingGr: Record 208;
        Cust: Record 18;
    BEGIN
        JT.GET(JobPlanningLine."Job No.", JobPlanningLine."Job Task No.");
        Job.GET(JobPlanningLine."Job No.");
        Cust.GET(Job."Bill-to Customer No.");
        IF JT."Job Posting Group" <> '' THEN
            JobPostingGr.GET(JT."Job Posting Group")
        ELSE BEGIN
            Job.TESTFIELD("Job Posting Group");
            JobPostingGr.GET(Job."Job Posting Group");
        END;
        IF JobPostingGr."G/L Expense Acc. (Contract)" = '' THEN
            EXIT;
        GLAcc.GET(JobPostingGr."G/L Expense Acc. (Contract)");
        GLAcc.CheckGLAcc;
        JobPlanningLine."No." := GLAcc."No.";
        JobPlanningLine."Gen. Bus. Posting Group" := Cust."Gen. Bus. Posting Group";
        JobPlanningLine."Gen. Prod. Posting Group" := GLAcc."Gen. Prod. Posting Group";
    END;

    //[External]
    PROCEDURE CheckItemQuantityPurchCredit(VAR PurchaseHeader: Record 38; VAR PurchaseLine: Record 39);
    VAR
        Item: Record 27;
        Job: Record 167;
        IsHandled: Boolean;
    BEGIN
        IsHandled := FALSE;
        OnBeforeCheckItemQuantityPurchCredit(PurchaseHeader, PurchaseLine, IsHandled);
        IF IsHandled THEN
            EXIT;

        Job.GET(PurchaseLine."Job No.");
        IF Job.GetQuantityAvailable(PurchaseLine."No.", PurchaseLine."Location Code", PurchaseLine."Variant Code", 0, 2) <
           -PurchaseLine."Return Qty. to Ship (Base)"
        THEN
            ERROR(
              Text005, Item.TABLECAPTION, PurchaseLine."No.", Job.TABLECAPTION,
              PurchaseLine."Job No.", PurchaseHeader."No.",
              PurchaseLine.FIELDCAPTION("Line No."), PurchaseLine."Line No.");
    END;

    //[External]
    PROCEDURE PostPurchaseGLAccounts(TempInvoicePostBuffer: Record 55 TEMPORARY; GLEntryNo: Integer);
    VAR
        IsHandled: Boolean;
    BEGIN
        WITH TempPurchaseLineJob DO BEGIN
            RESET;
            SETRANGE("Job No.", TempInvoicePostBuffer."Job No.");
            SETRANGE("No.", TempInvoicePostBuffer."G/L Account");
            SETRANGE("Gen. Bus. Posting Group", TempInvoicePostBuffer."Gen. Bus. Posting Group");
            SETRANGE("Gen. Prod. Posting Group", TempInvoicePostBuffer."Gen. Prod. Posting Group");
            SETRANGE("VAT Bus. Posting Group", TempInvoicePostBuffer."VAT Bus. Posting Group");
            SETRANGE("VAT Prod. Posting Group", TempInvoicePostBuffer."VAT Prod. Posting Group");
            IF FINDSET THEN BEGIN
                REPEAT
                    TempJobJournalLine.RESET;
                    TempJobJournalLine.SETRANGE("Line No.", "Line No.");
                    TempJobJournalLine.FINDFIRST;
                    JobJnlPostLine.SetGLEntryNo(GLEntryNo);
                    IsHandled := FALSE;
                    OnPostPurchaseGLAccountsOnBeforeJobJnlPostLine(TempJobJournalLine, TempPurchaseLineJob, IsHandled);
                    IF NOT IsHandled THEN
                        JobJnlPostLine.RunWithCheck(TempJobJournalLine);
                UNTIL NEXT = 0;
                DELETEALL;
            END;
        END;
    END;

    //[External]
    PROCEDURE PostSalesGLAccounts(TempInvoicePostBuffer: Record 55 TEMPORARY; GLEntryNo: Integer);
    BEGIN
        WITH TempSalesLineJob DO BEGIN
            RESET;
            SETRANGE("Job No.", TempInvoicePostBuffer."Job No.");
            SETRANGE("No.", TempInvoicePostBuffer."G/L Account");
            SETRANGE("Gen. Bus. Posting Group", TempInvoicePostBuffer."Gen. Bus. Posting Group");
            SETRANGE("Gen. Prod. Posting Group", TempInvoicePostBuffer."Gen. Prod. Posting Group");
            SETRANGE("VAT Bus. Posting Group", TempInvoicePostBuffer."VAT Bus. Posting Group");
            SETRANGE("VAT Prod. Posting Group", TempInvoicePostBuffer."VAT Prod. Posting Group");
            IF FINDSET THEN BEGIN
                REPEAT
                    TempJobJournalLine.RESET;
                    TempJobJournalLine.SETRANGE("Line No.", "Line No.");
                    TempJobJournalLine.FINDFIRST;
                    JobJnlPostLine.SetGLEntryNo(GLEntryNo);
                    OnPostSalesGLAccountsOnBeforeJobJnlPostLine(TempJobJournalLine, TempSalesLineJob);
                    JobJnlPostLine.RunWithCheck(TempJobJournalLine);
                UNTIL NEXT = 0;
                DELETEALL;
            END;
        END;
    END;

    LOCAL PROCEDURE InsertTempJobJournalLine(JobJournalLine: Record 210; LineNo: Integer);
    BEGIN
        TempJobJournalLine := JobJournalLine;
        TempJobJournalLine."Line No." := LineNo;
        TempJobJournalLine.INSERT;
    END;

    LOCAL PROCEDURE FindNextJobLedgEntryNo(JobPlanningLineInvoice: Record 1022): Integer;
    VAR
        RelatedJobPlanningLineInvoice: Record 1022;
        JobLedgEntry: Record 169;
    BEGIN
        RelatedJobPlanningLineInvoice.SETRANGE("Document Type", JobPlanningLineInvoice."Document Type");
        RelatedJobPlanningLineInvoice.SETRANGE("Document No.", JobPlanningLineInvoice."Document No.");
        IF RelatedJobPlanningLineInvoice.FINDLAST THEN
            EXIT(RelatedJobPlanningLineInvoice."Job Ledger Entry No." + 1);
        IF JobLedgEntry.FINDLAST THEN
            EXIT(JobLedgEntry."Entry No." + 1);
        EXIT(1);
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterPostInvoiceContractLine(VAR SalesHeader: Record 36; VAR SalesLine: Record 37);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeCheckItemQuantityPurchCredit(VAR PurchaseHeader: Record 38; VAR PurchaseLine: Record 39; VAR IsHandled: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeJobPlanningLineUpdateQtyToInvoice(VAR SalesHeader: Record 36; VAR SalesLine: Record 37; VAR JobPlanningLine: Record 1003; VAR JobPlanningLineInvoice: Record 1022; JobLedgerEntryNo: Integer);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforePostInvoiceContractLine(VAR SalesHeader: Record 36; VAR SalesLine: Record 37);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforePostJobOnPurchaseLine(VAR PurchHeader: Record 38; VAR PurchInvHeader: Record 122; VAR PurchCrMemoHdr: Record 124; VAR PurchLine: Record 39; VAR JobJnlLine: Record 210; VAR IsHandled: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterJobPlanningLineModify(VAR JobPlanningLine: Record 1003);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnPostInvoiceContractLineBeforeCheckJobLine(SalesHeader: Record 36; VAR SalesLine: Record 37; VAR JobPlanningLine: Record 1003; VAR JobLineChecked: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnPostPurchaseGLAccountsOnBeforeJobJnlPostLine(VAR JobJournalLine: Record 210; PurchaseLine: Record 39; VAR IsHandled: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnPostSalesGLAccountsOnBeforeJobJnlPostLine(VAR JobJournalLine: Record 210; SalesLine: Record 37);
    BEGIN
    END;


    /* /*BEGIN
END.*/
}




