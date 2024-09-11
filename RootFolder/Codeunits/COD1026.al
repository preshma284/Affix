Codeunit 50014 "Job Link Usage 1"
{


    Permissions = TableData 1020 = rimd;
    trigger OnRun()
    BEGIN
    END;

    VAR
        Text001: TextConst ENU = 'The specified %1 does not have %2 enabled.', ESP = 'La %1 especificada no tiene %2 activado.';
        ConfirmUsageWithBlankLineTypeQst: TextConst ENU = 'Usage will not be linked to the job planning line because the Line Type field is empty.\\Do you want to continue?', ESP = 'No se vincular  el uso a la l¡nea de planificaci¢n del proyecto, porque el campo de tipo de l¡nea est  vac¡o.\\¨Desea continuar?';

    //[External]
    PROCEDURE ApplyUsage(JobLedgerEntry: Record 169; JobJournalLine: Record 210);
    BEGIN
        IF JobJournalLine."Job Planning Line No." = 0 THEN
            MatchUsageUnspecified(JobLedgerEntry, JobJournalLine."Line Type" = JobJournalLine."Line Type"::" ")
        ELSE
            MatchUsageSpecified(JobLedgerEntry, JobJournalLine);
    END;

    LOCAL PROCEDURE MatchUsageUnspecified(JobLedgerEntry: Record 169; EmptyLineType: Boolean);
    VAR
        JobPlanningLine: Record 1003;
        JobUsageLink: Record 1020;
        Confirmed: Boolean;
        MatchedQty: Decimal;
        MatchedTotalCost: Decimal;
        MatchedLineAmount: Decimal;
        RemainingQtyToMatch: Decimal;
        FunctionQB: Codeunit 7207272;
    BEGIN
        RemainingQtyToMatch := JobLedgerEntry."Quantity (Base)";
        REPEAT
            IF NOT FindMatchingJobPlanningLine(JobPlanningLine, JobLedgerEntry) THEN
                IF EmptyLineType THEN BEGIN
                    IF NOT FunctionQB.AccessToQuobuilding THEN BEGIN //QB
                        Confirmed := CONFIRM(ConfirmUsageWithBlankLineTypeQst, FALSE);
                        IF NOT Confirmed THEN
                            ERROR('');
                    END;
                    RemainingQtyToMatch := 0;
                END ELSE BEGIN
                    IF NOT FunctionQB.AccessToQuobuilding THEN //QB
                        CreateJobPlanningLine(JobPlanningLine, JobLedgerEntry, RemainingQtyToMatch)
                    ELSE
                        RemainingQtyToMatch := 0; //QB
                END;

            IF RemainingQtyToMatch <> 0 THEN BEGIN
                JobUsageLink.Create(JobPlanningLine, JobLedgerEntry);
                IF ABS(RemainingQtyToMatch) > ABS(JobPlanningLine."Remaining Qty. (Base)") THEN
                    MatchedQty := JobPlanningLine."Remaining Qty. (Base)"
                ELSE
                    MatchedQty := RemainingQtyToMatch;
                MatchedTotalCost := (JobLedgerEntry."Total Cost" / JobLedgerEntry."Quantity (Base)") * MatchedQty;
                MatchedLineAmount := (JobLedgerEntry."Line Amount" / JobLedgerEntry."Quantity (Base)") * MatchedQty;

                OnBeforeJobPlanningLineUse(JobPlanningLine, JobLedgerEntry);
                JobPlanningLine.Use(CalcQtyFromBaseQty(MatchedQty, JobPlanningLine."Qty. per Unit of Measure"),
                  MatchedTotalCost, MatchedLineAmount, JobLedgerEntry."Posting Date", JobLedgerEntry."Currency Factor");
                RemainingQtyToMatch -= MatchedQty;
            END;
        UNTIL RemainingQtyToMatch = 0;
    END;

    LOCAL PROCEDURE MatchUsageSpecified(JobLedgerEntry: Record 169; JobJournalLine: Record 210);
    VAR
        JobPlanningLine: Record 1003;
        JobUsageLink: Record 1020;
        TotalRemainingQtyPrePostBase: Decimal;
        PostedQtyBase: Decimal;
        TotalQtyBase: Decimal;
    BEGIN
        JobPlanningLine.GET(JobLedgerEntry."Job No.", JobLedgerEntry."Job Task No.", JobJournalLine."Job Planning Line No.");
        IF NOT JobPlanningLine."Usage Link" THEN
            ERROR(Text001, JobPlanningLine.TABLECAPTION, JobPlanningLine.FIELDCAPTION("Usage Link"));

        PostedQtyBase := JobPlanningLine."Quantity (Base)" - JobPlanningLine."Remaining Qty. (Base)";
        TotalRemainingQtyPrePostBase := JobJournalLine."Quantity (Base)" + JobJournalLine."Remaining Qty. (Base)";
        TotalQtyBase := PostedQtyBase + TotalRemainingQtyPrePostBase;
        JobPlanningLine.SetBypassQtyValidation(TRUE);
        JobPlanningLine.VALIDATE(Quantity, CalcQtyFromBaseQty(TotalQtyBase, JobPlanningLine."Qty. per Unit of Measure"));
        JobPlanningLine.VALIDATE("Serial No.", JobLedgerEntry."Serial No.");
        JobPlanningLine.VALIDATE("Lot No.", JobLedgerEntry."Lot No.");
        JobPlanningLine.Use(CalcQtyFromBaseQty(JobLedgerEntry."Quantity (Base)", JobPlanningLine."Qty. per Unit of Measure"),
          JobLedgerEntry."Total Cost", JobLedgerEntry."Line Amount", JobLedgerEntry."Posting Date", JobLedgerEntry."Currency Factor");
        JobUsageLink.Create(JobPlanningLine, JobLedgerEntry);
    END;

    //[External]
    PROCEDURE FindMatchingJobPlanningLine(VAR JobPlanningLine: Record 1003; JobLedgerEntry: Record 169): Boolean;
    VAR
        Resource: Record 156;
        Filter: Text;
        JobPlanningLineFound: Boolean;
    BEGIN
        JobPlanningLine.RESET;
        JobPlanningLine.SETCURRENTKEY("Job No.", "Schedule Line", Type, "No.", "Planning Date");
        JobPlanningLine.SETRANGE("Job No.", JobLedgerEntry."Job No.");
        JobPlanningLine.SETRANGE("Job Task No.", JobLedgerEntry."Job Task No.");
        JobPlanningLine.SETRANGE(Type, JobLedgerEntry.Type);
        JobPlanningLine.SETRANGE("No.", JobLedgerEntry."No.");
        JobPlanningLine.SETRANGE("Location Code", JobLedgerEntry."Location Code");
        JobPlanningLine.SETRANGE("Schedule Line", TRUE);
        JobPlanningLine.SETRANGE("Usage Link", TRUE);

        IF JobLedgerEntry.Type = JobLedgerEntry.Type::Resource THEN BEGIN
            Filter := Resource.GetUnitOfMeasureFilter(JobLedgerEntry."No.", JobLedgerEntry."Unit of Measure Code");
            JobPlanningLine.SETFILTER("Unit of Measure Code", Filter);
        END;

        IF (JobLedgerEntry."Line Type" = JobLedgerEntry."Line Type"::Billable) OR
           (JobLedgerEntry."Line Type" = JobLedgerEntry."Line Type"::"Both Budget and Billable")
        THEN
            JobPlanningLine.SETRANGE("Contract Line", TRUE);

        IF JobLedgerEntry.Quantity > 0 THEN
            JobPlanningLine.SETFILTER("Remaining Qty.", '>0')
        ELSE
            JobPlanningLine.SETFILTER("Remaining Qty.", '<0');

        CASE JobLedgerEntry.Type OF
            JobLedgerEntry.Type::Item:
                JobPlanningLine.SETRANGE("Variant Code", JobLedgerEntry."Variant Code");
            JobLedgerEntry.Type::Resource:
                JobPlanningLine.SETRANGE("Work Type Code", JobLedgerEntry."Work Type Code");
        END;

        // Match most specific Job Planning Line.
        IF JobPlanningLine.FINDFIRST THEN
            EXIT(TRUE);

        JobPlanningLine.SETRANGE("Variant Code", '');
        JobPlanningLine.SETRANGE("Work Type Code", '');

        // Match Location Code, while Variant Code and Work Type Code are blank.
        IF JobPlanningLine.FINDFIRST THEN
            EXIT(TRUE);

        JobPlanningLine.SETRANGE("Location Code", '');

        CASE JobLedgerEntry.Type OF
            JobLedgerEntry.Type::Item:
                JobPlanningLine.SETRANGE("Variant Code", JobLedgerEntry."Variant Code");
            JobLedgerEntry.Type::Resource:
                JobPlanningLine.SETRANGE("Work Type Code", JobLedgerEntry."Work Type Code");
        END;

        // Match Variant Code / Work Type Code, while Location Code is blank.
        IF JobPlanningLine.FINDFIRST THEN
            EXIT(TRUE);

        JobPlanningLine.SETRANGE("Variant Code", '');
        JobPlanningLine.SETRANGE("Work Type Code", '');

        // Match unspecific Job Planning Line.
        IF JobPlanningLine.FINDFIRST THEN
            EXIT(TRUE);

        JobPlanningLineFound := FALSE;
        OnAfterFindMatchingJobPlanningLine(JobPlanningLine, JobLedgerEntry, JobPlanningLineFound);
        EXIT(JobPlanningLineFound);
    END;

    LOCAL PROCEDURE CreateJobPlanningLine(VAR JobPlanningLine: Record 1003; JobLedgerEntry: Record 169; RemainingQtyToMatch: Decimal);
    VAR
        Job: Record 167;
        JobPostLine: Codeunit 1001;
    BEGIN
        RemainingQtyToMatch := CalcQtyFromBaseQty(RemainingQtyToMatch, JobLedgerEntry."Qty. per Unit of Measure");

        CASE JobLedgerEntry."Line Type" OF
            JobLedgerEntry."Line Type"::" ":
                JobLedgerEntry."Line Type" := JobLedgerEntry."Line Type"::Budget;
            JobLedgerEntry."Line Type"::Billable:
                JobLedgerEntry."Line Type" := JobLedgerEntry."Line Type"::"Both Budget and Billable";
        END;
        JobPlanningLine.RESET;
        JobPostLine.InsertPlLineFromLedgEntry(JobLedgerEntry);
        // Retrieve the newly created Job PlanningLine.
        JobPlanningLine.SETRANGE("Job No.", JobLedgerEntry."Job No.");
        JobPlanningLine.SETRANGE("Job Task No.", JobLedgerEntry."Job Task No.");
        JobPlanningLine.SETRANGE("Schedule Line", TRUE);
        JobPlanningLine.FINDLAST;
        JobPlanningLine.VALIDATE("Usage Link", TRUE);
        JobPlanningLine.VALIDATE(Quantity, RemainingQtyToMatch);
        OnBeforeModifyJobPlanningLine(JobPlanningLine, JobLedgerEntry);
        JobPlanningLine.MODIFY;

        // If type is Both Budget And Billable and that type isn't allowed,
        // retrieve the Billabe line and modify the quantity as well.
        // Do the same if the type is G/L Account (Job Planning Lines will always be split in one Budget and one Billable line).
        Job.GET(JobLedgerEntry."Job No.");
        IF (JobLedgerEntry."Line Type" = JobLedgerEntry."Line Type"::"Both Budget and Billable") AND
           ((NOT Job."Allow Schedule/Contract Lines") OR (JobLedgerEntry.Type = JobLedgerEntry.Type::"G/L Account"))
        THEN BEGIN
            JobPlanningLine.GET(JobLedgerEntry."Job No.", JobLedgerEntry."Job Task No.", JobPlanningLine."Line No." + 10000);
            JobPlanningLine.VALIDATE(Quantity, RemainingQtyToMatch);
            JobPlanningLine.MODIFY;
            JobPlanningLine.GET(JobLedgerEntry."Job No.", JobLedgerEntry."Job Task No.", JobPlanningLine."Line No." - 10000);
        END;
    END;

    LOCAL PROCEDURE CalcQtyFromBaseQty(BaseQty: Decimal; QtyPerUnitOfMeasure: Decimal): Decimal;
    BEGIN
        IF QtyPerUnitOfMeasure <> 0 THEN
            EXIT(ROUND(BaseQty / QtyPerUnitOfMeasure, 0.00001));
        EXIT(BaseQty);
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterFindMatchingJobPlanningLine(VAR JobPlanningLine: Record 1003; JobLedgerEntry: Record 169; VAR JobPlanningLineFound: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeModifyJobPlanningLine(VAR JobPlanningLine: Record 1003; JobLedgerEntry: Record 169);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeJobPlanningLineUse(VAR JobPlanningLine: Record 1003; JobLedgerEntry: Record 169);
    BEGIN
    END;

    /* /*BEGIN
END.*/
}









