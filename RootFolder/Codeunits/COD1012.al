Codeunit 50012 "Job Jnl.-Post Line 1"
{


    TableNo = 210;
    Permissions = TableData 169 = imd,
                TableData 241 = imd,
                TableData 5802 = rimd;
    trigger OnRun()
    BEGIN
        GetGLSetup;
        RunWithCheck(Rec);
    END;

    VAR
        Cust: Record 18;
        Job: Record 167;
        JobTask: Record 1001;
        JobLedgEntry: Record 169;
        JobJnlLine: Record 210;
        JobJnlLine2: Record 210;
        ResJnlLine: Record 207;
        ItemJnlLine: Record 83;
        JobReg: Record 241;
        GLSetup: Record 98;
        CurrExchRate: Record 330;
        Currency: Record 4;
        Location: Record 14;
        Item: Record 27;
        JobJnlCheckLine: Codeunit 1011;
        ResJnlPostLine: Codeunit 212;
        ItemJnlPostLine: Codeunit 22;
        JobPostLine: Codeunit 1001;
        WhseJnlRegisterLine: Codeunit 7301;
        GLSetupRead: Boolean;
        NextEntryNo: Integer;
        GLEntryNo: Integer;
        "------------------------------ QB": Integer;
        QBCodeunitPublisher: Codeunit 7207352;
        FunctionQB: Codeunit 7207272;
        ExitBool: Boolean;
        Text000: TextConst ENU = '"The Job Planning Line No. field must have a value when reservation entries exist. Journal Template Name=%1, Job Journal Batch Name=%2, Line No.=%3. It cannot be zero or empty."', ESP = '"El campo N§ l¡nea planificaci¢n proyecto debe tener un valor cuando hay movs. reserva. Nombre libro diario=%1, Nombre secci¢n diario proyecto=%2, N§ l¡nea=%3. No puede ser cero ni estar vac¡o."';

    //[External]
    PROCEDURE RunWithCheck(VAR JobJnlLine2: Record 210): Integer;
    VAR
        JobLedgEntryNo: Integer;
    BEGIN
        JobJnlLine.COPY(JobJnlLine2);
        QBCodeunitPublisher.OnRunWithCheckJobJnlPostLine(JobJnlLine, ExitBool);
        IF ExitBool = TRUE THEN
            EXIT;
        JobLedgEntryNo := Code(TRUE);
        JobJnlLine2 := JobJnlLine;
        EXIT(JobLedgEntryNo);
    END;

    LOCAL PROCEDURE Code(CheckLine: Boolean): Integer;
    VAR
        ItemLedgEntry: Record 32;
        ResLedgEntry: Record 203;
        ValueEntry: Record 5802;
        JobLedgEntry2: Record 169;
        JobPlanningLine: Record 1003;
        TempTrackingSpecification: Record 336 TEMPORARY;
        ItemJnlLine2: Record 83;
        JobJnlLineReserve: Codeunit 99000844;
        JobLedgEntryNo: Integer;
        SkipJobLedgerEntry: Boolean;
        ApplyToJobContractEntryNo: Boolean;
        TempRemainingQty: Decimal;
        RemainingAmount: Decimal;
        RemainingAmountLCY: Decimal;
        RemainingQtyToTrack: Decimal;
    BEGIN
        OnBeforeCode(JobJnlLine);

        GetGLSetup;

        WITH JobJnlLine DO BEGIN
            IF EmptyLine THEN
                EXIT;

            //RE001>>
            IF Quantity = 0 THEN
                EXIT;
            //RE001<<

            IF CheckLine THEN
                JobJnlCheckLine.RunCheck(JobJnlLine);

            //IF JobLedgEntry."Entry No." = 0 THEN BEGIN  //QB2517
            JobLedgEntry.LOCKTABLE;
            IF JobLedgEntry.FINDLAST THEN
                NextEntryNo := JobLedgEntry."Entry No.";
            NextEntryNo := NextEntryNo + 1;
            //END;

            IF "Document Date" = 0D THEN
                "Document Date" := "Posting Date";

            IF JobReg."No." = 0 THEN BEGIN
                JobReg.LOCKTABLE;
                IF (NOT JobReg.FINDLAST) OR (JobReg."To Entry No." <> 0) THEN BEGIN
                    JobReg.INIT;
                    JobReg."No." := JobReg."No." + 1;
                    JobReg."From Entry No." := NextEntryNo;
                    JobReg."To Entry No." := NextEntryNo;
                    JobReg."Creation Date" := TODAY;
                    JobReg."Creation Time" := TIME;
                    JobReg."Source Code" := "Source Code";
                    JobReg."Journal Batch Name" := "Journal Batch Name";
                    JobReg."User ID" := USERID;
                    JobReg.INSERT;
                END;
            END;
            Job.GET("Job No.");
            Job.TestBlocked;
            IF Job."Job Type" = Job."Job Type"::Operative THEN BEGIN //QB2517
                Job.TESTFIELD("Bill-to Customer No.");
                Cust.GET(Job."Bill-to Customer No.");
            END;
            TESTFIELD("Currency Code", Job."Currency Code");
            IF NOT FunctionQB.AccessToQuobuilding THEN BEGIN //QB2517
                JobTask.GET("Job No.", "Job Task No.");
                JobTask.TESTFIELD("Job Task Type", JobTask."Job Task Type"::Posting);
            END;
            JobJnlLine2 := JobJnlLine;

            OnAfterCopyJobJnlLine(JobJnlLine, JobJnlLine2);

            JobJnlLine2."Source Currency Total Cost" := 0;
            JobJnlLine2."Source Currency Total Price" := 0;
            JobJnlLine2."Source Currency Line Amount" := 0;

            GetGLSetup;
            IF (GLSetup."Additional Reporting Currency" <> '') AND
               (JobJnlLine2."Source Currency Code" <> GLSetup."Additional Reporting Currency")
            THEN
                UpdateJobJnlLineSourceCurrencyAmounts(JobJnlLine2);

            IF JobJnlLine2."Entry Type" = JobJnlLine2."Entry Type"::Usage THEN BEGIN
                CASE Type OF
                    Type::Resource:
                        BEGIN
                            ResJnlLine.INIT;
                            ResJnlLine.CopyFromJobJnlLine(JobJnlLine2);
                            ResLedgEntry.LOCKTABLE;
                            ResJnlPostLine.RunWithCheck(ResJnlLine);
                            JobJnlLine2."Resource Group No." := ResJnlLine."Resource Group No.";
                            JobLedgEntryNo := CreateJobLedgEntry(JobJnlLine2);
                        END;
                    Type::Item:
                        BEGIN
                            IF NOT "Job Posting Only" THEN BEGIN
                                InitItemJnlLine;
                                JobJnlLineReserve.TransJobJnlLineToItemJnlLine(JobJnlLine2, ItemJnlLine, ItemJnlLine."Quantity (Base)");

                                ApplyToJobContractEntryNo := FALSE;
                                IF JobPlanningLine.GET("Job No.", "Job Task No.", "Job Planning Line No.") THEN
                                    ApplyToJobContractEntryNo := TRUE
                                ELSE
                                    IF JobPlanningReservationExists(JobJnlLine2."No.", JobJnlLine2."Job No.") THEN
                                        IF ApplyToMatchingJobPlanningLine(JobJnlLine2, JobPlanningLine) THEN
                                            ApplyToJobContractEntryNo := TRUE;

                                IF ApplyToJobContractEntryNo THEN
                                    ItemJnlLine."Job Contract Entry No." := JobPlanningLine."Job Contract Entry No.";

                                ItemLedgEntry.LOCKTABLE;
                                ItemJnlLine2 := ItemJnlLine;
                                ItemJnlPostLine.RunWithCheck(ItemJnlLine);
                                ItemJnlPostLine.CollectTrackingSpecification(TempTrackingSpecification);
                                PostWhseJnlLine(ItemJnlLine2, ItemJnlLine2.Quantity, ItemJnlLine2."Quantity (Base)", TempTrackingSpecification);
                            END;
                            IF NOT JobJnlLine2."Activation Entry" THEN BEGIN //QB2517
                                IF GetJobConsumptionValueEntry(ValueEntry, JobJnlLine) THEN BEGIN
                                    RemainingAmount := JobJnlLine2."Line Amount";
                                    RemainingAmountLCY := JobJnlLine2."Line Amount (LCY)";
                                    RemainingQtyToTrack := JobJnlLine2.Quantity;

                                    REPEAT
                                        SkipJobLedgerEntry := FALSE;
                                        IF ItemLedgEntry.GET(ValueEntry."Item Ledger Entry No.") THEN BEGIN
                                            JobLedgEntry2.SETRANGE("Ledger Entry Type", JobLedgEntry2."Ledger Entry Type"::Item);
                                            JobLedgEntry2.SETRANGE("Ledger Entry No.", ItemLedgEntry."Entry No.");
                                            // The following code is only to secure that JLEs created at receipt in version 6.0 or earlier,
                                            // are not created again at point of invoice (6.0 SP1 and newer).
                                            IF JobLedgEntry2.FINDFIRST AND (JobLedgEntry2.Quantity = -ItemLedgEntry.Quantity) THEN
                                                SkipJobLedgerEntry := TRUE
                                            ELSE BEGIN
                                                JobJnlLine2."Serial No." := ItemLedgEntry."Serial No.";
                                                JobJnlLine2."Lot No." := ItemLedgEntry."Lot No.";
                                            END;
                                        END;
                                        IF NOT SkipJobLedgerEntry THEN BEGIN
                                            TempRemainingQty := JobJnlLine2."Remaining Qty.";
                                            JobJnlLine2.Quantity := -ValueEntry."Invoiced Quantity" / "Qty. per Unit of Measure";
                                            JobJnlLine2."Quantity (Base)" := ROUND(JobJnlLine2.Quantity * "Qty. per Unit of Measure", 0.00001);
                                            IF "Currency Code" <> '' THEN
                                                Currency.GET("Currency Code")
                                            ELSE
                                                Currency.InitRoundingPrecision;

                                            UpdateJobJnlLineTotalAmounts(JobJnlLine2, Currency."Amount Rounding Precision");
                                            UpdateJobJnlLineAmount(
                                              JobJnlLine2, RemainingAmount, RemainingAmountLCY, RemainingQtyToTrack, Currency."Amount Rounding Precision");

                                            JobJnlLine2.VALIDATE("Remaining Qty.", TempRemainingQty);
                                            JobJnlLine2."Ledger Entry Type" := "Ledger Entry Type"::Item;
                                            JobJnlLine2."Ledger Entry No." := ValueEntry."Item Ledger Entry No.";
                                            JobLedgEntryNo := CreateJobLedgEntry(JobJnlLine2);
                                            ValueEntry."Job Ledger Entry No." := JobLedgEntryNo;
                                            ValueEntry.MODIFY(TRUE);
                                        END;
                                    UNTIL ValueEntry.NEXT = 0;
                                END;
                            END ELSE
                                JobLedgEntryNo := CreateJobLedgEntry(JobJnlLine2);
                        END;
                    Type::"G/L Account":
                        JobLedgEntryNo := CreateJobLedgEntry(JobJnlLine2);
                END;
            END ELSE
                JobLedgEntryNo := CreateJobLedgEntry(JobJnlLine2);
        END;

        OnAfterRunCode(JobJnlLine2, JobLedgEntryNo);

        EXIT(JobLedgEntryNo);
    END;

    LOCAL PROCEDURE GetGLSetup();
    BEGIN
        IF NOT GLSetupRead THEN
            GLSetup.GET;
        GLSetupRead := TRUE;
    END;

    //[External]
    PROCEDURE CreateJobLedgEntry(JobJnlLine2: Record 210): Integer;
    VAR
        ResLedgEntry: Record 203;
        JobPlanningLine: Record 1003;
        Job: Record 167;
        JobTransferLine: Codeunit 1004;
        JobLinkUsage: Codeunit 1026;
        JobLedgEntryNo: Integer;
        IsHandled: Boolean;
    BEGIN
        IsHandled := FALSE;
        OnBeforeCreateJobLedgEntry(JobJnlLine2, IsHandled);
        IF IsHandled THEN
            EXIT;

        SetCurrency(JobJnlLine2);

        JobLedgEntry.INIT;
        JobTransferLine.FromJnlLineToLedgEntry(JobJnlLine2, JobLedgEntry);

        IF JobJnlLine2."Job Posting Only" THEN  //QB2517
            QBCodeunitPublisher.OnInitCreateJobLedgEntryJobJnlPostLine(JobLedgEntry, JobJnlLine2)
        ELSE BEGIN
            IF JobLedgEntry."Entry Type" = JobLedgEntry."Entry Type"::Sale THEN BEGIN
                JobLedgEntry.Quantity := -JobJnlLine2.Quantity;
                JobLedgEntry."Quantity (Base)" := -JobJnlLine2."Quantity (Base)";
                JobLedgEntry."Total Cost (LCY)" := -JobJnlLine2."Total Cost (LCY)";
                JobLedgEntry."Total Cost" := -JobJnlLine2."Total Cost";
                JobLedgEntry."Total Price (LCY)" := -JobJnlLine2."Total Price (LCY)";
                JobLedgEntry."Total Price" := -JobJnlLine2."Total Price";
                JobLedgEntry."Line Amount (LCY)" := -JobJnlLine2."Line Amount (LCY)";
                JobLedgEntry."Line Amount" := -JobJnlLine2."Line Amount";
                JobLedgEntry."Line Discount Amount (LCY)" := -JobJnlLine2."Line Discount Amount (LCY)";
                JobLedgEntry."Line Discount Amount" := -JobJnlLine2."Line Discount Amount";
            END ELSE BEGIN
                JobLedgEntry.Quantity := JobJnlLine2.Quantity;
                JobLedgEntry."Quantity (Base)" := JobJnlLine2."Quantity (Base)";
                JobLedgEntry."Total Cost (LCY)" := JobJnlLine2."Total Cost (LCY)";
                JobLedgEntry."Total Cost" := JobJnlLine2."Total Cost";
                JobLedgEntry."Total Price (LCY)" := JobJnlLine2."Total Price (LCY)";
                JobLedgEntry."Total Price" := JobJnlLine2."Total Price";
                JobLedgEntry."Line Amount (LCY)" := JobJnlLine2."Line Amount (LCY)";
                JobLedgEntry."Line Amount" := JobJnlLine2."Line Amount";
                JobLedgEntry."Line Discount Amount (LCY)" := JobJnlLine2."Line Discount Amount (LCY)";
                JobLedgEntry."Line Discount Amount" := JobJnlLine2."Line Discount Amount";
            END;
            JobLedgEntry."Additional-Currency Total Cost" := -JobLedgEntry."Additional-Currency Total Cost";
            JobLedgEntry."Add.-Currency Total Price" := -JobLedgEntry."Add.-Currency Total Price";
            JobLedgEntry."Add.-Currency Line Amount" := -JobLedgEntry."Add.-Currency Line Amount";
        END;
        JobLedgEntry."Entry No." := NextEntryNo;
        JobLedgEntry."No. Series" := JobJnlLine2."Posting No. Series";
        JobLedgEntry."Original Unit Cost (LCY)" := JobLedgEntry."Unit Cost (LCY)";
        JobLedgEntry."Original Total Cost (LCY)" := JobLedgEntry."Total Cost (LCY)";
        JobLedgEntry."Original Unit Cost" := JobLedgEntry."Unit Cost";
        JobLedgEntry."Original Total Cost" := JobLedgEntry."Total Cost";
        JobLedgEntry."Original Total Cost (ACY)" := JobLedgEntry."Additional-Currency Total Cost";
        QBCodeunitPublisher.OnTypeSaleCreateJobLedgEntryJobJnlPostLine(JobLedgEntry);
        JobLedgEntry."Dimension Set ID" := JobJnlLine2."Dimension Set ID";

        WITH JobJnlLine2 DO
            CASE Type OF
                Type::Resource:
                    BEGIN
                        IF "Entry Type" = "Entry Type"::Usage THEN BEGIN
                            IF ResLedgEntry.FINDLAST THEN BEGIN
                                JobLedgEntry."Ledger Entry Type" := JobLedgEntry."Ledger Entry Type"::Resource;
                                JobLedgEntry."Ledger Entry No." := ResLedgEntry."Entry No.";
                            END;
                        END;
                    END;
                Type::Item:
                    BEGIN
                        JobLedgEntry."Ledger Entry Type" := "Ledger Entry Type"::Item;
                        JobLedgEntry."Ledger Entry No." := "Ledger Entry No.";
                        JobLedgEntry."Serial No." := "Serial No.";
                        JobLedgEntry."Lot No." := "Lot No.";
                    END;
                Type::"G/L Account":
                    BEGIN
                        JobLedgEntry."Ledger Entry Type" := JobLedgEntry."Ledger Entry Type"::" ";
                        IF GLEntryNo > 0 THEN BEGIN
                            JobLedgEntry."Ledger Entry Type" := JobLedgEntry."Ledger Entry Type"::"G/L Account";
                            JobLedgEntry."Ledger Entry No." := GLEntryNo;
                            GLEntryNo := 0;
                        END;
                    END;
            END;
        IF JobLedgEntry."Entry Type" = JobLedgEntry."Entry Type"::Sale THEN BEGIN
            JobLedgEntry."Serial No." := JobJnlLine2."Serial No.";
            JobLedgEntry."Lot No." := JobJnlLine2."Lot No.";
        END;
        QBCodeunitPublisher.OnJobEntryCreateJobLedgEntryJobJnlPostLine(JobJnlLine2, JobLedgEntry);
        JobLedgEntry.INSERT(TRUE);

        JobReg."To Entry No." := NextEntryNo;
        JobReg.MODIFY;

        JobLedgEntryNo := JobLedgEntry."Entry No.";
        OnBeforeApplyUsageLink(JobLedgEntry);

        IF JobLedgEntry."Entry Type" = JobLedgEntry."Entry Type"::Usage THEN BEGIN
            // Usage Link should be applied if it is enabled for the job,
            // if a Job Planning Line number is defined or if it is enabled for a Job Planning Line.
            Job.GET(JobLedgEntry."Job No.");
            IF Job."Apply Usage Link" OR
               (JobJnlLine2."Job Planning Line No." <> 0) OR
               JobLinkUsage.FindMatchingJobPlanningLine(JobPlanningLine, JobLedgEntry)
            THEN BEGIN
                JobLinkUsage.ApplyUsage(JobLedgEntry, JobJnlLine2);
                CLEAR(JobLedgEntry);
            END ELSE
                JobPostLine.InsertPlLineFromLedgEntry(JobLedgEntry)
        END;

        NextEntryNo := NextEntryNo + 1;
        OnAfterApplyUsageLink(JobLedgEntry);

        EXIT(JobLedgEntryNo);
    END;

    LOCAL PROCEDURE SetCurrency(JobJnlLine: Record 210);
    BEGIN
        IF JobJnlLine."Currency Code" = '' THEN BEGIN
            CLEAR(Currency);
            Currency.InitRoundingPrecision
        END ELSE BEGIN
            Currency.GET(JobJnlLine."Currency Code");
            Currency.TESTFIELD("Amount Rounding Precision");
            Currency.TESTFIELD("Unit-Amount Rounding Precision");
        END;
    END;

    LOCAL PROCEDURE PostWhseJnlLine(ItemJnlLine: Record 83; OriginalQuantity: Decimal; OriginalQuantityBase: Decimal; VAR TempTrackingSpecification: Record 336 TEMPORARY);
    VAR
        WarehouseJournalLine: Record 7311;
        TempWarehouseJournalLine: Record 7311 TEMPORARY;
        ItemTrackingManagement: Codeunit 6500;
        WMSManagement: Codeunit 7302;
    BEGIN
        WITH ItemJnlLine DO BEGIN
            IF "Entry Type" IN ["Entry Type"::Consumption, "Entry Type"::Output] THEN
                EXIT;

            Quantity := OriginalQuantity;
            "Quantity (Base)" := OriginalQuantityBase;
            GetLocation("Location Code");
            IF Location."Bin Mandatory" THEN
                IF WMSManagement.CreateWhseJnlLine(ItemJnlLine, 0, WarehouseJournalLine, FALSE) THEN BEGIN
                    TempTrackingSpecification.MODIFYALL("Source Type", DATABASE::"Job Journal Line");
                    ItemTrackingManagement.SplitWhseJnlLine(WarehouseJournalLine, TempWarehouseJournalLine, TempTrackingSpecification, FALSE);
                    IF TempWarehouseJournalLine.FIND('-') THEN
                        REPEAT
                            WMSManagement.CheckWhseJnlLine(TempWarehouseJournalLine, 1, 0, FALSE);
                            WhseJnlRegisterLine.RegisterWhseJnlLine(TempWarehouseJournalLine);
                        UNTIL TempWarehouseJournalLine.NEXT = 0;
                END;
        END;
    END;

    LOCAL PROCEDURE GetLocation(LocationCode: Code[10]);
    BEGIN
        IF LocationCode = '' THEN
            CLEAR(Location)
        ELSE
            IF Location.Code <> LocationCode THEN
                Location.GET(LocationCode);
    END;


    LOCAL PROCEDURE InitItemJnlLine();
    BEGIN
        WITH ItemJnlLine DO BEGIN
            INIT;
            CopyFromJobJnlLine(JobJnlLine2);

            "Source Type" := "Source Type"::Customer;
            "Source No." := Job."Bill-to Customer No.";

            Item.GET(JobJnlLine2."No.");
            "Inventory Posting Group" := Item."Inventory Posting Group";
            "Item Category Code" := Item."Item Category Code";
        END;
    END;

    LOCAL PROCEDURE UpdateJobJnlLineTotalAmounts(VAR JobJnlLineToUpdate: Record 210; AmtRoundingPrecision: Decimal);
    BEGIN
        WITH JobJnlLineToUpdate DO BEGIN
            "Total Cost" := ROUND("Unit Cost" * Quantity, AmtRoundingPrecision);
            "Total Cost (LCY)" := ROUND("Unit Cost (LCY)" * Quantity, AmtRoundingPrecision);
            "Total Price" := ROUND("Unit Price" * Quantity, AmtRoundingPrecision);
            "Total Price (LCY)" := ROUND("Unit Price (LCY)" * Quantity, AmtRoundingPrecision);
        END;
    END;

    LOCAL PROCEDURE UpdateJobJnlLineAmount(VAR JobJnlLineToUpdate: Record 210; VAR RemainingAmount: Decimal; VAR RemainingAmountLCY: Decimal; VAR RemainingQtyToTrack: Decimal; AmtRoundingPrecision: Decimal);
    BEGIN
        WITH JobJnlLineToUpdate DO BEGIN
            "Line Amount" := ROUND(RemainingAmount * Quantity / RemainingQtyToTrack, AmtRoundingPrecision);
            "Line Amount (LCY)" := ROUND(RemainingAmountLCY * Quantity / RemainingQtyToTrack, AmtRoundingPrecision);

            RemainingAmount -= "Line Amount";
            RemainingAmountLCY -= "Line Amount (LCY)";
            RemainingQtyToTrack -= Quantity;
        END;
    END;

    LOCAL PROCEDURE UpdateJobJnlLineSourceCurrencyAmounts(VAR JobJnlLine: Record 210);
    BEGIN
        WITH JobJnlLine DO BEGIN
            Currency.GET(GLSetup."Additional Reporting Currency");
            Currency.TESTFIELD("Amount Rounding Precision");
            "Source Currency Total Cost" :=
              ROUND(
                CurrExchRate.ExchangeAmtLCYToFCY(
                  "Posting Date",
                  GLSetup."Additional Reporting Currency", "Total Cost (LCY)",
                  CurrExchRate.ExchangeRate(
                    "Posting Date", GLSetup."Additional Reporting Currency")),
                Currency."Amount Rounding Precision");
            "Source Currency Total Price" :=
              ROUND(
                CurrExchRate.ExchangeAmtLCYToFCY(
                  "Posting Date",
                  GLSetup."Additional Reporting Currency", "Total Price (LCY)",
                  CurrExchRate.ExchangeRate(
                    "Posting Date", GLSetup."Additional Reporting Currency")),
                Currency."Amount Rounding Precision");
            "Source Currency Line Amount" :=
              ROUND(
                CurrExchRate.ExchangeAmtLCYToFCY(
                  "Posting Date",
                  GLSetup."Additional Reporting Currency", "Line Amount (LCY)",
                  CurrExchRate.ExchangeRate(
                    "Posting Date", GLSetup."Additional Reporting Currency")),
                Currency."Amount Rounding Precision");
        END;
    END;

    LOCAL PROCEDURE JobPlanningReservationExists(ItemNo: Code[20]; JobNo: Code[20]): Boolean;
    VAR
        ReservationEntry: Record 337;
    BEGIN
        WITH ReservationEntry DO BEGIN
            SETRANGE("Item No.", ItemNo);
            SETRANGE("Source Type", DATABASE::"Job Planning Line");
            SETRANGE("Source Subtype", Job.Status::Open);
            SETRANGE("Source ID", JobNo);
            EXIT(NOT ISEMPTY);
        END;
    END;

    LOCAL PROCEDURE GetJobConsumptionValueEntry(VAR ValueEntry: Record 5802; JobJournalLine: Record 210): Boolean;
    BEGIN
        WITH JobJournalLine DO BEGIN
            ValueEntry.SETCURRENTKEY("Job No.", "Job Task No.", "Document No.");
            ValueEntry.SETRANGE("Item No.", "No.");
            ValueEntry.SETRANGE("Job No.", "Job No.");
            ValueEntry.SETRANGE("Job Task No.", "Job Task No.");
            ValueEntry.SETRANGE("Document No.", "Document No.");
            IF FunctionQB.AccessToQuobuilding THEN //QB2517
                QBCodeunitPublisher.OnGetJobConsumptionValueEntryJobJnlPostLine(ValueEntry)
            ELSE
                ValueEntry.SETRANGE("Item Ledger Entry Type", ValueEntry."Item Ledger Entry Type"::"Negative Adjmt.");
            ValueEntry.SETRANGE("Job Ledger Entry No.", 0);
            OnGetJobConsumptionValueEntryFilter(ValueEntry, JobJnlLine);
        END;
        EXIT(ValueEntry.FINDSET);
    END;

    LOCAL PROCEDURE ApplyToMatchingJobPlanningLine(VAR JobJnlLine: Record 210; VAR JobPlanningLine: Record 1003): Boolean;
    VAR
        Job: Record 167;
        JobLedgEntry: Record 169;
        JobTransferLine: Codeunit 1004;
        JobLinkUsage: Codeunit 1026;
    BEGIN
        IF JobLedgEntry."Entry Type" <> JobLedgEntry."Entry Type"::Usage THEN
            EXIT(FALSE);

        Job.GET(JobJnlLine."Job No.");
        JobLedgEntry.INIT;
        JobTransferLine.FromJnlLineToLedgEntry(JobJnlLine, JobLedgEntry);
        JobLedgEntry.Quantity := JobJnlLine.Quantity;
        JobLedgEntry."Quantity (Base)" := JobJnlLine."Quantity (Base)";

        IF JobLinkUsage.FindMatchingJobPlanningLine(JobPlanningLine, JobLedgEntry) THEN BEGIN
            JobJnlLine.VALIDATE("Job Planning Line No.", JobPlanningLine."Line No.");
            JobJnlLine.MODIFY(TRUE);
            EXIT(TRUE);
        END;
        EXIT(FALSE);
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterApplyUsageLink(VAR JobLedgerEntry: Record 169);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterCopyJobJnlLine(VAR JobJournalLine: Record 210; JobJournalLine2: Record 210);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterRunCode(VAR JobJournalLine: Record 210; JobLedgEntryNo: Integer);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeCode(VAR JobJournalLine: Record 210);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeApplyUsageLink(VAR JobLedgerEntry: Record 169);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeCreateJobLedgEntry(VAR JobJournalLine: Record 210; VAR IsHandled: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnGetJobConsumptionValueEntryFilter(VAR ValueEntry: Record 5802; JobJournalLine: Record 210);
    BEGIN
    END;

    PROCEDURE ResetJobLedgEntry();
    BEGIN
        CLEAR(JobLedgEntry); //QB2517
    END;

    /*BEGIN
/*{
      REE001 NZG  24/01/18  : A¤adir codigo para excluir el registro si la cantidad es 0
    }
END.*/
}









