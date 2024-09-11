Codeunit 50010 "Job Transfer Line 1"
{


    trigger OnRun()
    BEGIN
    END;

    VAR
        CurrencyExchRate: Record 330;
        Currency: Record 4;
        LCYCurrency: Record 4;
        CurrencyRoundingRead: Boolean;
        Text001: TextConst ENU = '%1 %2 does not exist.', ESP = 'No existe %1 %2.';

    //[External]
    PROCEDURE FromJnlLineToLedgEntry(JobJnlLine2: Record 210; VAR JobLedgEntry: Record 169);
    BEGIN
        JobLedgEntry."Job No." := JobJnlLine2."Job No.";
        JobLedgEntry."Job Task No." := JobJnlLine2."Job Task No.";
        JobLedgEntry."Job Posting Group" := JobJnlLine2."Posting Group";
        JobLedgEntry."Posting Date" := JobJnlLine2."Posting Date";
        JobLedgEntry."Document Date" := JobJnlLine2."Document Date";
        JobLedgEntry."Document No." := JobJnlLine2."Document No.";
        JobLedgEntry."External Document No." := JobJnlLine2."External Document No.";
        JobLedgEntry.Type := JobJnlLine2.Type;
        JobLedgEntry."No." := JobJnlLine2."No.";
        JobLedgEntry.Description := JobJnlLine2.Description;
        JobLedgEntry."Resource Group No." := JobJnlLine2."Resource Group No.";
        JobLedgEntry."Unit of Measure Code" := JobJnlLine2."Unit of Measure Code";
        JobLedgEntry."Location Code" := JobJnlLine2."Location Code";
        JobLedgEntry."Global Dimension 1 Code" := JobJnlLine2."Shortcut Dimension 1 Code";
        JobLedgEntry."Global Dimension 2 Code" := JobJnlLine2."Shortcut Dimension 2 Code";
        JobLedgEntry."Dimension Set ID" := JobJnlLine2."Dimension Set ID";
        JobLedgEntry."Work Type Code" := JobJnlLine2."Work Type Code";
        JobLedgEntry."Source Code" := JobJnlLine2."Source Code";
        JobLedgEntry."Entry Type" := JobJnlLine2."Entry Type";
        JobLedgEntry."Gen. Bus. Posting Group" := JobJnlLine2."Gen. Bus. Posting Group";
        JobLedgEntry."Gen. Prod. Posting Group" := JobJnlLine2."Gen. Prod. Posting Group";
        JobLedgEntry."Journal Batch Name" := JobJnlLine2."Journal Batch Name";
        JobLedgEntry."Reason Code" := JobJnlLine2."Reason Code";
        JobLedgEntry."Variant Code" := JobJnlLine2."Variant Code";
        JobLedgEntry."Bin Code" := JobJnlLine2."Bin Code";
        JobLedgEntry."Line Type" := JobJnlLine2."Line Type";
        JobLedgEntry."Currency Code" := JobJnlLine2."Currency Code";
        JobLedgEntry."Description 2" := JobJnlLine2."Description 2";
        IF JobJnlLine2."Currency Code" = '' THEN
            JobLedgEntry."Currency Factor" := 1
        ELSE
            JobLedgEntry."Currency Factor" := JobJnlLine2."Currency Factor";
        JobLedgEntry."User ID" := USERID;
        JobLedgEntry."Customer Price Group" := JobJnlLine2."Customer Price Group";

        JobLedgEntry."Transport Method" := JobJnlLine2."Transport Method";
        JobLedgEntry."Transaction Type" := JobJnlLine2."Transaction Type";
        JobLedgEntry."Transaction Specification" := JobJnlLine2."Transaction Specification";
        JobLedgEntry."Entry/Exit Point" := JobJnlLine2."Entry/Exit Point";
        JobLedgEntry.Area := JobJnlLine2.Area;
        JobLedgEntry."Country/Region Code" := JobJnlLine2."Country/Region Code";

        JobLedgEntry."Unit Price (LCY)" := JobJnlLine2."Unit Price (LCY)";
        JobLedgEntry."Additional-Currency Total Cost" :=
          -JobJnlLine2."Source Currency Total Cost";
        JobLedgEntry."Add.-Currency Total Price" :=
          -JobJnlLine2."Source Currency Total Price";
        JobLedgEntry."Add.-Currency Line Amount" :=
          -JobJnlLine2."Source Currency Line Amount";

        JobLedgEntry."Service Order No." := JobJnlLine2."Service Order No.";
        JobLedgEntry."Posted Service Shipment No." := JobJnlLine2."Posted Service Shipment No.";

        // Amounts
        JobLedgEntry."Qty. per Unit of Measure" := JobJnlLine2."Qty. per Unit of Measure";

        JobLedgEntry."Direct Unit Cost (LCY)" := JobJnlLine2."Direct Unit Cost (LCY)";
        JobLedgEntry."Unit Cost (LCY)" := JobJnlLine2."Unit Cost (LCY)";
        JobLedgEntry."Unit Cost" := JobJnlLine2."Unit Cost";
        JobLedgEntry."Unit Price" := JobJnlLine2."Unit Price";

        JobLedgEntry."Line Discount %" := JobJnlLine2."Line Discount %";

        OnAfterFromJnlLineToLedgEntry(JobLedgEntry, JobJnlLine2);
    END;

    //[External]
    PROCEDURE FromJnlToPlanningLine(JobJnlLine: Record 210; VAR JobPlanningLine: Record 1003);
    BEGIN
        JobPlanningLine."Job No." := JobJnlLine."Job No.";
        JobPlanningLine."Job Task No." := JobJnlLine."Job Task No.";
        JobPlanningLine."Planning Date" := JobJnlLine."Posting Date";
        JobPlanningLine."Currency Date" := JobJnlLine."Posting Date";
        JobPlanningLine.Type := JobJnlLine.Type;
        JobPlanningLine."No." := JobJnlLine."No.";
        JobPlanningLine."Document No." := JobJnlLine."Document No.";
        JobPlanningLine.Description := JobJnlLine.Description;
        JobPlanningLine."Description 2" := JobJnlLine."Description 2";
        JobPlanningLine."Unit of Measure Code" := JobJnlLine."Unit of Measure Code";
        JobPlanningLine.VALIDATE("Line Type", JobJnlLine."Line Type".AsInteger() - 1);
        JobPlanningLine."Currency Code" := JobJnlLine."Currency Code";
        JobPlanningLine."Currency Factor" := JobJnlLine."Currency Factor";
        JobPlanningLine."Resource Group No." := JobJnlLine."Resource Group No.";
        JobPlanningLine."Location Code" := JobJnlLine."Location Code";
        JobPlanningLine."Work Type Code" := JobJnlLine."Work Type Code";
        JobPlanningLine."Customer Price Group" := JobJnlLine."Customer Price Group";
        JobPlanningLine."Country/Region Code" := JobJnlLine."Country/Region Code";
        JobPlanningLine."Gen. Bus. Posting Group" := JobJnlLine."Gen. Bus. Posting Group";
        JobPlanningLine."Gen. Prod. Posting Group" := JobJnlLine."Gen. Prod. Posting Group";
        JobPlanningLine."Document Date" := JobJnlLine."Document Date";
        JobPlanningLine."Variant Code" := JobJnlLine."Variant Code";
        JobPlanningLine."Bin Code" := JobJnlLine."Bin Code";
        JobPlanningLine."Serial No." := JobJnlLine."Serial No.";
        JobPlanningLine."Lot No." := JobJnlLine."Lot No.";
        JobPlanningLine."Service Order No." := JobJnlLine."Service Order No.";
        JobPlanningLine."Ledger Entry Type" := JobJnlLine."Ledger Entry Type";
        JobPlanningLine."Ledger Entry No." := JobJnlLine."Ledger Entry No.";
        JobPlanningLine."System-Created Entry" := TRUE;

        // Amounts
        JobPlanningLine.Quantity := JobJnlLine.Quantity;
        JobPlanningLine."Quantity (Base)" := JobJnlLine."Quantity (Base)";
        IF JobPlanningLine."Usage Link" THEN BEGIN
            JobPlanningLine."Remaining Qty." := JobJnlLine.Quantity;
            JobPlanningLine."Remaining Qty. (Base)" := JobJnlLine."Quantity (Base)";
        END;
        JobPlanningLine."Qty. per Unit of Measure" := JobJnlLine."Qty. per Unit of Measure";

        JobPlanningLine."Direct Unit Cost (LCY)" := JobJnlLine."Direct Unit Cost (LCY)";
        JobPlanningLine."Unit Cost (LCY)" := JobJnlLine."Unit Cost (LCY)";
        JobPlanningLine."Unit Cost" := JobJnlLine."Unit Cost";

        JobPlanningLine."Total Cost (LCY)" := JobJnlLine."Total Cost (LCY)";
        JobPlanningLine."Total Cost" := JobJnlLine."Total Cost";

        JobPlanningLine."Unit Price (LCY)" := JobJnlLine."Unit Price (LCY)";
        JobPlanningLine."Unit Price" := JobJnlLine."Unit Price";

        JobPlanningLine."Total Price (LCY)" := JobJnlLine."Total Price (LCY)";
        JobPlanningLine."Total Price" := JobJnlLine."Total Price";

        JobPlanningLine."Line Amount (LCY)" := JobJnlLine."Line Amount (LCY)";
        JobPlanningLine."Line Amount" := JobJnlLine."Line Amount";

        JobPlanningLine."Line Discount %" := JobJnlLine."Line Discount %";

        JobPlanningLine."Line Discount Amount (LCY)" := JobJnlLine."Line Discount Amount (LCY)";
        JobPlanningLine."Line Discount Amount" := JobJnlLine."Line Discount Amount";

        OnAfterFromJnlToPlanningLine(JobPlanningLine, JobJnlLine);
    END;

    //[External]
    PROCEDURE FromPlanningSalesLineToJnlLine(JobPlanningLine: Record 1003; SalesHeader: Record 36; SalesLine: Record 37; VAR JobJnlLine: Record 210; EntryType: Enum "Job Journal Line Entry Type");
    VAR
        SourceCodeSetup: Record 242;
        JobTask: Record 1001;
    BEGIN
        OnBeforeFromPlanningSalesLineToJnlLine(JobPlanningLine, SalesHeader, SalesLine, JobJnlLine, EntryType);

        JobJnlLine."Job No." := JobPlanningLine."Job No.";
        JobJnlLine."Job Task No." := JobPlanningLine."Job Task No.";
        JobJnlLine.Type := JobPlanningLine.Type;
        JobTask.GET(JobPlanningLine."Job No.", JobPlanningLine."Job Task No.");
        JobJnlLine."Posting Date" := SalesHeader."Posting Date";
        JobJnlLine."Document Date" := SalesHeader."Document Date";
        JobJnlLine."Document No." := SalesLine."Document No.";
        //JobJnlLine."Entry Type" := Enum::"Job Journal Line Entry Type".FromInteger(EntryType);//option to enum
        JobJnlLine."Entry Type" := EntryType;
        JobJnlLine."Posting Group" := SalesLine."Posting Group";
        JobJnlLine."Gen. Bus. Posting Group" := SalesLine."Gen. Bus. Posting Group";
        JobJnlLine."Gen. Prod. Posting Group" := SalesLine."Gen. Prod. Posting Group";
        JobJnlLine."Serial No." := JobPlanningLine."Serial No.";
        JobJnlLine."Lot No." := JobPlanningLine."Lot No.";
        JobJnlLine."No." := JobPlanningLine."No.";
        JobJnlLine.Description := SalesLine.Description;
        JobJnlLine."Description 2" := SalesLine."Description 2";
        JobJnlLine."Unit of Measure Code" := JobPlanningLine."Unit of Measure Code";
        JobJnlLine.VALIDATE("Qty. per Unit of Measure", SalesLine."Qty. per Unit of Measure");
        JobJnlLine."Work Type Code" := JobPlanningLine."Work Type Code";
        JobJnlLine."Variant Code" := JobPlanningLine."Variant Code";
        JobJnlLine."Line Type" := Enum::"Job Line Type".FromInteger(JobPlanningLine."Line Type".AsInteger() + 1);
        JobJnlLine."Currency Code" := JobPlanningLine."Currency Code";
        JobJnlLine."Currency Factor" := JobPlanningLine."Currency Factor";
        JobJnlLine."Resource Group No." := JobPlanningLine."Resource Group No.";
        JobJnlLine."Customer Price Group" := JobPlanningLine."Customer Price Group";
        JobJnlLine."Location Code" := SalesLine."Location Code";
        JobJnlLine."Bin Code" := SalesLine."Bin Code";
        JobJnlLine."Service Order No." := JobPlanningLine."Service Order No.";
        SourceCodeSetup.GET;
        JobJnlLine."Source Code" := SourceCodeSetup.Sales;
        JobJnlLine."Reason Code" := SalesHeader."Reason Code";
        JobJnlLine."External Document No." := SalesHeader."External Document No.";

        JobJnlLine."Transport Method" := SalesLine."Transport Method";
        JobJnlLine."Transaction Type" := SalesLine."Transaction Type";
        JobJnlLine."Transaction Specification" := SalesLine."Transaction Specification";
        JobJnlLine."Entry/Exit Point" := SalesLine."Exit Point";
        JobJnlLine.Area := SalesLine.Area;
        JobJnlLine."Country/Region Code" := JobPlanningLine."Country/Region Code";

        JobJnlLine."Shortcut Dimension 1 Code" := SalesLine."Shortcut Dimension 1 Code";
        JobJnlLine."Shortcut Dimension 2 Code" := SalesLine."Shortcut Dimension 2 Code";
        JobJnlLine."Dimension Set ID" := SalesLine."Dimension Set ID";

        CASE SalesHeader."Document Type" OF
            SalesHeader."Document Type"::Invoice:
                JobJnlLine.VALIDATE(Quantity, SalesLine.Quantity);
            SalesHeader."Document Type"::"Credit Memo":
                JobJnlLine.VALIDATE(Quantity, -SalesLine.Quantity);
        END;

        JobJnlLine."Direct Unit Cost (LCY)" := JobPlanningLine."Direct Unit Cost (LCY)";
        IF (JobPlanningLine."Currency Code" = '') AND (SalesHeader."Currency Factor" <> 0) THEN BEGIN
            GetCurrencyRounding(SalesHeader."Currency Code");
            ValidateUnitCostAndPrice(
              JobJnlLine, SalesLine, SalesLine."Unit Cost (LCY)",
              JobPlanningLine."Unit Price");
        END ELSE
            ValidateUnitCostAndPrice(JobJnlLine, SalesLine, SalesLine."Unit Cost", JobPlanningLine."Unit Price");
        JobJnlLine.VALIDATE("Line Discount %", SalesLine."Line Discount %");

        OnAfterFromPlanningSalesLineToJnlLine(JobJnlLine, JobPlanningLine, SalesHeader, SalesLine, EntryType);
    END;

    //[External]
    PROCEDURE FromPlanningLineToJnlLine(JobPlanningLine: Record 1003; PostingDate: Date; JobJournalTemplateName: Code[10]; JobJournalBatchName: Code[10]; VAR JobJnlLine: Record 210);
    VAR
        JobTask: Record 1001;
        JobJnlLine2: Record 210;
        JobJournalTemplate: Record 209;
        JobJournalBatch: Record 237;
        NoSeriesMgt: Codeunit 396;
        ItemTrackingMgt: Codeunit 6500;
    BEGIN
        JobPlanningLine.TESTFIELD("Qty. to Transfer to Journal");

        IF NOT JobJournalTemplate.GET(JobJournalTemplateName) THEN
            ERROR(Text001, JobJournalTemplate.TABLECAPTION, JobJournalTemplateName);
        IF NOT JobJournalBatch.GET(JobJournalTemplateName, JobJournalBatchName) THEN
            ERROR(Text001, JobJournalBatch.TABLECAPTION, JobJournalBatchName);
        IF PostingDate = 0D THEN
            PostingDate := WORKDATE;

        JobJnlLine.INIT;
        JobJnlLine.VALIDATE("Journal Template Name", JobJournalTemplate.Name);
        JobJnlLine.VALIDATE("Journal Batch Name", JobJournalBatch.Name);
        JobJnlLine2.SETRANGE("Journal Template Name", JobJournalTemplate.Name);
        JobJnlLine2.SETRANGE("Journal Batch Name", JobJournalBatch.Name);
        IF JobJnlLine2.FINDLAST THEN
            JobJnlLine.VALIDATE("Line No.", JobJnlLine2."Line No." + 10000)
        ELSE
            JobJnlLine.VALIDATE("Line No.", 10000);

        JobJnlLine."Job No." := JobPlanningLine."Job No.";
        JobJnlLine."Job Task No." := JobPlanningLine."Job Task No.";

        IF JobPlanningLine."Usage Link" THEN BEGIN
            JobJnlLine."Job Planning Line No." := JobPlanningLine."Line No.";
            JobJnlLine."Line Type" := Enum::"Job Line Type".FromInteger(JobPlanningLine."Line Type".AsInteger() + 1);
        END;

        JobTask.GET(JobPlanningLine."Job No.", JobPlanningLine."Job Task No.");
        JobJnlLine."Posting Group" := JobTask."Job Posting Group";
        JobJnlLine."Posting Date" := PostingDate;
        JobJnlLine."Document Date" := PostingDate;
        IF JobJournalBatch."No. Series" <> '' THEN
            JobJnlLine."Document No." := NoSeriesMgt.GetNextNo(JobJournalBatch."No. Series", PostingDate, FALSE)
        ELSE
            JobJnlLine."Document No." := JobPlanningLine."Document No.";

        JobJnlLine.Type := JobPlanningLine.Type;
        JobJnlLine."No." := JobPlanningLine."No.";
        JobJnlLine."Entry Type" := JobJnlLine."Entry Type"::Usage;
        JobJnlLine."Gen. Bus. Posting Group" := JobPlanningLine."Gen. Bus. Posting Group";
        JobJnlLine."Gen. Prod. Posting Group" := JobPlanningLine."Gen. Prod. Posting Group";
        JobJnlLine."Serial No." := JobPlanningLine."Serial No.";
        JobJnlLine."Lot No." := JobPlanningLine."Lot No.";
        JobJnlLine.Description := JobPlanningLine.Description;
        JobJnlLine."Description 2" := JobPlanningLine."Description 2";
        JobJnlLine.VALIDATE("Unit of Measure Code", JobPlanningLine."Unit of Measure Code");
        JobJnlLine."Currency Code" := JobPlanningLine."Currency Code";
        JobJnlLine."Currency Factor" := JobPlanningLine."Currency Factor";
        JobJnlLine."Resource Group No." := JobPlanningLine."Resource Group No.";
        JobJnlLine."Location Code" := JobPlanningLine."Location Code";
        JobJnlLine."Work Type Code" := JobPlanningLine."Work Type Code";
        JobJnlLine."Customer Price Group" := JobPlanningLine."Customer Price Group";
        JobJnlLine."Variant Code" := JobPlanningLine."Variant Code";
        JobJnlLine."Bin Code" := JobPlanningLine."Bin Code";
        JobJnlLine."Service Order No." := JobPlanningLine."Service Order No.";
        JobJnlLine."Country/Region Code" := JobPlanningLine."Country/Region Code";
        JobJnlLine."Source Code" := JobJournalTemplate."Source Code";

        JobJnlLine.VALIDATE(Quantity, JobPlanningLine."Qty. to Transfer to Journal");
        JobJnlLine.VALIDATE("Qty. per Unit of Measure", JobPlanningLine."Qty. per Unit of Measure");
        JobJnlLine."Direct Unit Cost (LCY)" := JobPlanningLine."Direct Unit Cost (LCY)";
        JobJnlLine.VALIDATE("Unit Cost", JobPlanningLine."Unit Cost");
        JobJnlLine.VALIDATE("Unit Price", JobPlanningLine."Unit Price");
        JobJnlLine.VALIDATE("Line Discount %", JobPlanningLine."Line Discount %");

        OnAfterFromPlanningLineToJnlLine(JobJnlLine, JobPlanningLine);

        JobJnlLine.UpdateDimensions;
        ItemTrackingMgt.CopyItemTracking(JobPlanningLine.RowID1, JobJnlLine.RowID1, FALSE);

        JobJnlLine.INSERT(TRUE);
    END;

    //[External]
    PROCEDURE FromGenJnlLineToJnlLine(GenJnlLine: Record 81; VAR JobJnlLine: Record 210);
    VAR
        Job: Record 167;
        JobTask: Record 1001;
    BEGIN
        JobJnlLine."Job No." := GenJnlLine."Job No.";
        JobJnlLine."Job Task No." := GenJnlLine."Job Task No.";
        JobTask.GET(GenJnlLine."Job No.", GenJnlLine."Job Task No.");

        JobJnlLine."Posting Date" := GenJnlLine."Posting Date";
        JobJnlLine."Document Date" := GenJnlLine."Document Date";
        JobJnlLine."Document No." := GenJnlLine."Document No.";

        JobJnlLine."Currency Code" := GenJnlLine."Job Currency Code";
        JobJnlLine."Currency Factor" := GenJnlLine."Job Currency Factor";
        JobJnlLine."Entry Type" := JobJnlLine."Entry Type"::Usage;
        JobJnlLine."Line Type" := GenJnlLine."Job Line Type";
        JobJnlLine.Type := JobJnlLine.Type::"G/L Account";
        JobJnlLine."No." := GenJnlLine."Account No.";
        JobJnlLine.Description := GenJnlLine.Description;
        JobJnlLine."Unit of Measure Code" := GenJnlLine."Job Unit Of Measure Code";
        JobJnlLine."Gen. Bus. Posting Group" := GenJnlLine."Gen. Bus. Posting Group";
        JobJnlLine."Gen. Prod. Posting Group" := GenJnlLine."Gen. Prod. Posting Group";
        JobJnlLine."Source Code" := GenJnlLine."Source Code";
        JobJnlLine."Reason Code" := GenJnlLine."Reason Code";
        Job.GET(JobJnlLine."Job No.");
        JobJnlLine."Customer Price Group" := Job."Customer Price Group";
        JobJnlLine."External Document No." := GenJnlLine."External Document No.";
        JobJnlLine."Journal Batch Name" := GenJnlLine."Journal Batch Name";
        JobJnlLine."Shortcut Dimension 1 Code" := GenJnlLine."Shortcut Dimension 1 Code";
        JobJnlLine."Shortcut Dimension 2 Code" := GenJnlLine."Shortcut Dimension 2 Code";
        JobJnlLine."Dimension Set ID" := GenJnlLine."Dimension Set ID";

        JobJnlLine.Quantity := GenJnlLine."Job Quantity";
        JobJnlLine."Quantity (Base)" := GenJnlLine."Job Quantity";
        JobJnlLine."Qty. per Unit of Measure" := 1; // MP ??
        JobJnlLine."Job Planning Line No." := GenJnlLine."Job Planning Line No.";
        JobJnlLine."Remaining Qty." := GenJnlLine."Job Remaining Qty.";
        JobJnlLine."Remaining Qty. (Base)" := GenJnlLine."Job Remaining Qty.";

        JobJnlLine."Direct Unit Cost (LCY)" := GenJnlLine."Job Unit Cost (LCY)";
        JobJnlLine."Unit Cost (LCY)" := GenJnlLine."Job Unit Cost (LCY)";
        JobJnlLine."Unit Cost" := GenJnlLine."Job Unit Cost";

        JobJnlLine."Total Cost (LCY)" := GenJnlLine."Job Total Cost (LCY)";
        JobJnlLine."Total Cost" := GenJnlLine."Job Total Cost";

        JobJnlLine."Unit Price (LCY)" := GenJnlLine."Job Unit Price (LCY)";
        JobJnlLine."Unit Price" := GenJnlLine."Job Unit Price";

        JobJnlLine."Total Price (LCY)" := GenJnlLine."Job Total Price (LCY)";
        JobJnlLine."Total Price" := GenJnlLine."Job Total Price";

        JobJnlLine."Line Amount (LCY)" := GenJnlLine."Job Line Amount (LCY)";
        JobJnlLine."Line Amount" := GenJnlLine."Job Line Amount";

        JobJnlLine."Line Discount Amount (LCY)" := GenJnlLine."Job Line Disc. Amount (LCY)";
        JobJnlLine."Line Discount Amount" := GenJnlLine."Job Line Discount Amount";

        JobJnlLine."Line Discount %" := GenJnlLine."Job Line Discount %";

        OnAfterFromGenJnlLineToJnlLine(JobJnlLine, GenJnlLine);
    END;

    //[External]
    PROCEDURE FromJobLedgEntryToPlanningLine(JobLedgEntry: Record 169; VAR JobPlanningLine: Record 1003);
    VAR
        SalesPriceCalcMgt: Codeunit 7000;
    BEGIN
        JobPlanningLine."Job No." := JobLedgEntry."Job No.";
        JobPlanningLine."Job Task No." := JobLedgEntry."Job Task No.";
        JobPlanningLine."Planning Date" := JobLedgEntry."Posting Date";
        JobPlanningLine."Currency Date" := JobLedgEntry."Posting Date";
        JobPlanningLine."Document Date" := JobLedgEntry."Document Date";
        JobPlanningLine."Document No." := JobLedgEntry."Document No.";
        JobPlanningLine.Description := JobLedgEntry.Description;
        JobPlanningLine.Type := JobLedgEntry.Type;
        JobPlanningLine."No." := JobLedgEntry."No.";
        JobPlanningLine."Unit of Measure Code" := JobLedgEntry."Unit of Measure Code";
        JobPlanningLine.VALIDATE("Line Type", JobLedgEntry."Line Type".AsInteger() - 1);
        JobPlanningLine."Currency Code" := JobLedgEntry."Currency Code";
        IF JobLedgEntry."Currency Code" = '' THEN
            JobPlanningLine."Currency Factor" := 0
        ELSE
            JobPlanningLine."Currency Factor" := JobLedgEntry."Currency Factor";
        JobPlanningLine."Resource Group No." := JobLedgEntry."Resource Group No.";
        JobPlanningLine."Location Code" := JobLedgEntry."Location Code";
        JobPlanningLine."Work Type Code" := JobLedgEntry."Work Type Code";
        JobPlanningLine."Gen. Bus. Posting Group" := JobLedgEntry."Gen. Bus. Posting Group";
        JobPlanningLine."Gen. Prod. Posting Group" := JobLedgEntry."Gen. Prod. Posting Group";
        JobPlanningLine."Variant Code" := JobLedgEntry."Variant Code";
        JobPlanningLine."Bin Code" := JobLedgEntry."Bin Code";
        JobPlanningLine."Customer Price Group" := JobLedgEntry."Customer Price Group";
        JobPlanningLine."Country/Region Code" := JobLedgEntry."Country/Region Code";
        JobPlanningLine."Description 2" := JobLedgEntry."Description 2";
        JobPlanningLine."Serial No." := JobLedgEntry."Serial No.";
        JobPlanningLine."Lot No." := JobLedgEntry."Lot No.";
        JobPlanningLine."Service Order No." := JobLedgEntry."Service Order No.";
        JobPlanningLine."Job Ledger Entry No." := JobLedgEntry."Entry No.";
        JobPlanningLine."Ledger Entry Type" := JobLedgEntry."Ledger Entry Type";
        JobPlanningLine."Ledger Entry No." := JobLedgEntry."Ledger Entry No.";
        JobPlanningLine."System-Created Entry" := TRUE;

        // Function call to retrieve cost factor. Prices will be overwritten.
        SalesPriceCalcMgt.JobPlanningLineFindJTPrice(JobPlanningLine);

        // Amounts
        JobPlanningLine.Quantity := JobLedgEntry.Quantity;
        JobPlanningLine."Quantity (Base)" := JobLedgEntry."Quantity (Base)";
        IF JobPlanningLine."Usage Link" THEN BEGIN
            JobPlanningLine."Remaining Qty." := JobLedgEntry.Quantity;
            JobPlanningLine."Remaining Qty. (Base)" := JobLedgEntry."Quantity (Base)";
        END;
        JobPlanningLine."Qty. per Unit of Measure" := JobLedgEntry."Qty. per Unit of Measure";

        JobPlanningLine."Direct Unit Cost (LCY)" := JobLedgEntry."Direct Unit Cost (LCY)";
        JobPlanningLine."Unit Cost (LCY)" := JobLedgEntry."Unit Cost (LCY)";
        JobPlanningLine."Unit Cost" := JobLedgEntry."Unit Cost";

        JobPlanningLine."Total Cost (LCY)" := JobLedgEntry."Total Cost (LCY)";
        JobPlanningLine."Total Cost" := JobLedgEntry."Total Cost";

        JobPlanningLine."Unit Price (LCY)" := JobLedgEntry."Unit Price (LCY)";
        JobPlanningLine."Unit Price" := JobLedgEntry."Unit Price";

        JobPlanningLine."Total Price (LCY)" := JobLedgEntry."Total Price (LCY)";
        JobPlanningLine."Total Price" := JobLedgEntry."Total Price";

        JobPlanningLine."Line Amount (LCY)" := JobLedgEntry."Line Amount (LCY)";
        JobPlanningLine."Line Amount" := JobLedgEntry."Line Amount";

        JobPlanningLine."Line Discount %" := JobLedgEntry."Line Discount %";

        JobPlanningLine."Line Discount Amount (LCY)" := JobLedgEntry."Line Discount Amount (LCY)";
        JobPlanningLine."Line Discount Amount" := JobLedgEntry."Line Discount Amount";

        OnAfterFromJobLedgEntryToPlanningLine(JobPlanningLine, JobLedgEntry);
    END;

    //[External]
    PROCEDURE FromPurchaseLineToJnlLine(PurchHeader: Record 38; PurchInvHeader: Record 122; PurchCrMemoHeader: Record 124; PurchLine: Record 39; SourceCode: Code[10]; VAR JobJnlLine: Record 210);
    VAR
        Item: Record 27;
        JobTask: Record 1001;
        UOMMgt: Codeunit 5402;
        Factor: Decimal;
    BEGIN
        WITH PurchLine DO BEGIN
            JobJnlLine.DontCheckStdCost;
            JobJnlLine.VALIDATE("Job No.", "Job No.");
            JobJnlLine.VALIDATE("Job Task No.", "Job Task No.");

            //+QB No existen tareas en los proyectos de QB
            //JobTask.GET("Job No.","Job Task No.");
            IF JobTask.GET("Job No.", "Job Task No.") THEN;
            //-QB

            JobJnlLine.VALIDATE("Posting Date", PurchHeader."Posting Date");
            IF Type = Type::"G/L Account" THEN
                JobJnlLine.VALIDATE(Type, JobJnlLine.Type::"G/L Account")
            ELSE

                //+QB  Procesar los de tipo recurso
                IF Type = Type::Resource THEN
                    JobJnlLine.VALIDATE(Type, JobJnlLine.Type::Resource)
                ELSE
                    //-QB

                    JobJnlLine.VALIDATE(Type, JobJnlLine.Type::Item);
            JobJnlLine.VALIDATE("No.", "No.");
            JobJnlLine.VALIDATE("Variant Code", "Variant Code");
            IF UpdateBaseQtyForPurchLine(Item, PurchLine) THEN BEGIN
                JobJnlLine.VALIDATE("Unit of Measure Code", Item."Base Unit of Measure");
                JobJnlLine.VALIDATE(
                  Quantity, UOMMgt.CalcBaseQty("Qty. to Invoice", "Qty. per Unit of Measure"));
            END ELSE BEGIN
                JobJnlLine.VALIDATE("Unit of Measure Code", "Unit of Measure Code");
                JobJnlLine."Qty. per Unit of Measure" := "Qty. per Unit of Measure";
                IF "Qty. to Invoice" <> 0 THEN //QB
                    JobJnlLine.VALIDATE(Quantity, "Qty. to Invoice");
            END;

            IF PurchHeader."Document Type" IN [PurchHeader."Document Type"::"Return Order",
                                               PurchHeader."Document Type"::"Credit Memo"]
            THEN BEGIN
                JobJnlLine."Document No." := PurchCrMemoHeader."No.";
                JobJnlLine."External Document No." := PurchCrMemoHeader."Vendor Cr. Memo No.";
            END ELSE BEGIN
                JobJnlLine."Document No." := PurchInvHeader."No.";
                JobJnlLine."External Document No." := PurchHeader."Vendor Invoice No.";
            END;

            GetCurrencyRounding(JobJnlLine."Currency Code");

            JobJnlLine."Unit Cost (LCY)" := "Unit Cost (LCY)" / "Qty. per Unit of Measure";

            IF Type = Type::Item THEN BEGIN
                IF Item."Inventory Value Zero" THEN
                    JobJnlLine."Unit Cost (LCY)" := 0
                ELSE
                    IF Item."Costing Method" = Item."Costing Method"::Standard THEN
                        JobJnlLine."Unit Cost (LCY)" := Item."Standard Cost";
            END;
            JobJnlLine."Unit Cost (LCY)" := ROUND(JobJnlLine."Unit Cost (LCY)", LCYCurrency."Unit-Amount Rounding Precision");

            IF JobJnlLine."Currency Code" = '' THEN BEGIN
                JobJnlLine."Unit Cost" := JobJnlLine."Unit Cost (LCY)";
                JobJnlLine."Total Cost" :=
                  ROUND(JobJnlLine."Unit Cost (LCY)" * JobJnlLine.Quantity, LCYCurrency."Amount Rounding Precision");
            END ELSE
                IF JobJnlLine."Currency Code" = "Currency Code" THEN BEGIN
                    JobJnlLine."Unit Cost" := "Unit Cost";
                    JobJnlLine."Total Cost" :=
                      ROUND(JobJnlLine."Unit Cost" * JobJnlLine.Quantity, Currency."Amount Rounding Precision");
                END ELSE BEGIN
                    JobJnlLine."Unit Cost" :=
                      ROUND(
                        CurrencyExchRate.ExchangeAmtLCYToFCY(
                          PurchHeader."Posting Date",
                          JobJnlLine."Currency Code",
                          JobJnlLine."Unit Cost (LCY)",
                          JobJnlLine."Currency Factor"), Currency."Unit-Amount Rounding Precision");
                    JobJnlLine."Total Cost" := ROUND(JobJnlLine."Unit Cost" * JobJnlLine.Quantity, Currency."Amount Rounding Precision");
                END;

            IF (Type = Type::Item) AND Item."Inventory Value Zero" THEN
                JobJnlLine."Total Cost (LCY)" := 0
            ELSE
                JobJnlLine."Total Cost (LCY)" :=
                  ROUND(JobJnlLine."Unit Cost (LCY)" * JobJnlLine.Quantity, LCYCurrency."Amount Rounding Precision");

            IF "Currency Code" = '' THEN
                JobJnlLine."Direct Unit Cost (LCY)" := "Direct Unit Cost"
            ELSE
                JobJnlLine."Direct Unit Cost (LCY)" :=
                  CurrencyExchRate.ExchangeAmtFCYToLCY(
                    PurchHeader."Posting Date",
                    "Currency Code",
                    "Direct Unit Cost",
                    PurchHeader."Currency Factor");

            JobJnlLine."Unit Price (LCY)" := "Job Unit Price (LCY)";
            JobJnlLine."Unit Price" := "Job Unit Price";
            JobJnlLine."Line Discount %" := "Job Line Discount %";

            IF Quantity <> 0 THEN BEGIN
                GetCurrencyRounding(PurchHeader."Currency Code");

                Factor := "Qty. to Invoice" / Quantity;
                JobJnlLine."Total Price (LCY)" :=
                  ROUND("Job Total Price (LCY)" * Factor, LCYCurrency."Amount Rounding Precision");
                JobJnlLine."Total Price" :=
                  ROUND("Job Total Price" * Factor, Currency."Amount Rounding Precision");
                JobJnlLine."Line Amount (LCY)" :=
                  ROUND("Job Line Amount (LCY)" * Factor, LCYCurrency."Amount Rounding Precision");
                JobJnlLine."Line Amount" :=
                  ROUND("Job Line Amount" * Factor, Currency."Amount Rounding Precision");
                JobJnlLine."Line Discount Amount (LCY)" :=
                  ROUND("Job Line Disc. Amount (LCY)" * Factor, LCYCurrency."Amount Rounding Precision");
                JobJnlLine."Line Discount Amount" :=
                  ROUND("Job Line Discount Amount" * Factor, Currency."Amount Rounding Precision");
            END;

            JobJnlLine."Job Planning Line No." := "Job Planning Line No.";
            JobJnlLine."Remaining Qty." := "Job Remaining Qty.";
            JobJnlLine."Remaining Qty. (Base)" := "Job Remaining Qty. (Base)";
            JobJnlLine."Location Code" := "Location Code";
            JobJnlLine."Bin Code" := "Bin Code";
            JobJnlLine."Line Type" := "Job Line Type";
            JobJnlLine."Entry Type" := JobJnlLine."Entry Type"::Usage;
            JobJnlLine.Description := Description;
            JobJnlLine."Description 2" := "Description 2";
            JobJnlLine."Gen. Bus. Posting Group" := "Gen. Bus. Posting Group";
            JobJnlLine."Gen. Prod. Posting Group" := "Gen. Prod. Posting Group";
            JobJnlLine."Source Code" := SourceCode;
            JobJnlLine."Reason Code" := PurchHeader."Reason Code";
            JobJnlLine."Document Date" := PurchHeader."Document Date";
            JobJnlLine."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
            JobJnlLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
            JobJnlLine."Dimension Set ID" := "Dimension Set ID";
        END;

        OnAfterFromPurchaseLineToJnlLine(JobJnlLine, PurchHeader, PurchInvHeader, PurchCrMemoHeader, PurchLine, SourceCode);
    END;

    //[External]
    PROCEDURE FromSalesHeaderToPlanningLine(SalesLine: Record 37; CurrencyFactor: Decimal);
    VAR
        JobPlanningLine: Record 1003;
    BEGIN
        JobPlanningLine.SETCURRENTKEY("Job Contract Entry No.");
        JobPlanningLine.SETRANGE("Job Contract Entry No.", SalesLine."Job Contract Entry No.");
        IF JobPlanningLine.FINDFIRST THEN BEGIN
            // Update Prices
            IF JobPlanningLine."Currency Code" <> '' THEN BEGIN
                JobPlanningLine."Unit Price (LCY)" := SalesLine."Unit Price" / CurrencyFactor;
                JobPlanningLine."Total Price (LCY)" := JobPlanningLine."Unit Price (LCY)" * JobPlanningLine.Quantity;
                JobPlanningLine."Line Amount (LCY)" := JobPlanningLine."Total Price (LCY)";
                JobPlanningLine."Unit Price" := JobPlanningLine."Unit Price (LCY)";
                JobPlanningLine."Total Price" := JobPlanningLine."Total Price (LCY)";
                JobPlanningLine."Line Amount" := JobPlanningLine."Total Price (LCY)";
            END ELSE BEGIN
                JobPlanningLine."Unit Price (LCY)" := SalesLine."Unit Price" / CurrencyFactor;
                JobPlanningLine."Total Price (LCY)" := JobPlanningLine."Unit Price (LCY)" * JobPlanningLine.Quantity;
                JobPlanningLine."Line Amount (LCY)" := JobPlanningLine."Total Price (LCY)";
            END;
            OnAfterFromSalesHeaderToPlanningLine(JobPlanningLine, SalesLine, CurrencyFactor);
            JobPlanningLine.MODIFY;
        END;
    END;

    LOCAL PROCEDURE GetCurrencyRounding(CurrencyCode: Code[10]);
    BEGIN
        IF CurrencyRoundingRead THEN
            EXIT;
        CurrencyRoundingRead := TRUE;
        IF CurrencyCode = '' THEN
            Currency.InitRoundingPrecision
        ELSE BEGIN
            Currency.GET(CurrencyCode);
            Currency.TESTFIELD("Amount Rounding Precision");
        END;
        LCYCurrency.InitRoundingPrecision;
    END;

    LOCAL PROCEDURE DoUpdateUnitCost(SalesLine: Record 37): Boolean;
    VAR
        Item: Record 27;
    BEGIN
        IF SalesLine.Type = SalesLine.Type::Item THEN BEGIN
            Item.GET(SalesLine."No.");
            IF Item."Costing Method" = Item."Costing Method"::Standard THEN
                EXIT(FALSE); // Do not update Unit Cost in Job Journal Line, it is correct.
        END;

        EXIT(TRUE);
    END;

    LOCAL PROCEDURE ValidateUnitCostAndPrice(VAR JobJournalLine: Record 210; SalesLine: Record 37; UnitCost: Decimal; UnitPrice: Decimal);
    BEGIN
        IF DoUpdateUnitCost(SalesLine) THEN
            JobJournalLine.VALIDATE("Unit Cost", UnitCost);
        JobJournalLine.VALIDATE("Unit Price", UnitPrice);
    END;

    LOCAL PROCEDURE UpdateBaseQtyForPurchLine(VAR Item: Record 27; PurchLine: Record 39): Boolean;
    BEGIN
        IF PurchLine.Type = PurchLine.Type::Item THEN BEGIN
            Item.GET(PurchLine."No.");
            Item.TESTFIELD("Base Unit of Measure");
            EXIT(PurchLine."Unit of Measure Code" <> Item."Base Unit of Measure");
        END;
        EXIT(FALSE);
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterFromJnlLineToLedgEntry(VAR JobLedgerEntry: Record 169; JobJournalLine: Record 210);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterFromJnlToPlanningLine(VAR JobPlanningLine: Record 1003; JobJournalLine: Record 210);
    BEGIN
    END;

    //[IntegrationEvent]
    // LOCAL PROCEDURE OnAfterFromPlanningSalesLineToJnlLine(VAR JobJnlLine: Record 210; JobPlanningLine: Record 1003; SalesHeader: Record 36; SalesLine: Record 37; EntryType: Option "Usage","Sale");
    LOCAL PROCEDURE OnAfterFromPlanningSalesLineToJnlLine(VAR JobJnlLine: Record 210; JobPlanningLine: Record 1003; SalesHeader: Record 36; SalesLine: Record 37; EntryType: Enum "Job Journal Line Entry Type");

    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterFromPlanningLineToJnlLine(VAR JobJournalLine: Record 210; JobPlanningLine: Record 1003);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterFromGenJnlLineToJnlLine(VAR JobJnlLine: Record 210; GenJnlLine: Record 81);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterFromJobLedgEntryToPlanningLine(VAR JobPlanningLine: Record 1003; JobLedgEntry: Record 169);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterFromPurchaseLineToJnlLine(VAR JobJnlLine: Record 210; PurchHeader: Record 38; PurchInvHeader: Record 122; PurchCrMemoHeader: Record 124; PurchLine: Record 39; SourceCode: Code[10]);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterFromSalesHeaderToPlanningLine(VAR JobPlanningLine: Record 1003; SalesLine: Record 37; CurrencyFactor: Decimal);
    BEGIN
    END;

    //[IntegrationEvent]
    // LOCAL PROCEDURE OnBeforeFromPlanningSalesLineToJnlLine(VAR JobPlanningLine: Record 1003; VAR SalesHeader: Record 36; VAR SalesLine: Record 37; VAR JobJnlLine: Record 210; VAR EntryType: Option "Usage","Sale");
    LOCAL PROCEDURE OnBeforeFromPlanningSalesLineToJnlLine(VAR JobPlanningLine: Record 1003; VAR SalesHeader: Record 36; VAR SalesLine: Record 37; VAR JobJnlLine: Record 210; VAR EntryType:Enum "Job Journal Line Entry Type");
    
    BEGIN
    END;


    /*BEGIN
/*{
      QB
      JAV 04/07/22: - QB 1.10.58 Se elimina la funci�n RunAddFromPurchaseLineToJnlLineCJobTransferLine, su c�digo pasa al evento est�ndar OnAfterFromPurchaseLineToJnlLine
                                 Se traslada el c�digo en la codeunit 50010 "Job Transfer Line 1"
    }
END.*/
}


