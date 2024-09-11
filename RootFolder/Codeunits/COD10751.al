Codeunit 51301 "SII Job Management 1"
{


    trigger OnRun()
    BEGIN
    END;

    VAR
        JobQueueManagement: Codeunit 456;
        JobQueueEntryStartedTxt: TextConst ENU = 'The job queue entry for detection of missing SII entries has started.', ESP = 'Se ha iniciado el movimiento de cola de proyectos para la detecci�n de movimientos SII que faltan.';

    PROCEDURE RenewJobQueueEntry(JobType: Option "HandlePending","HandleCommError","InitialUpload");
    VAR
        TempJobQueueEntry: Record 472 TEMPORARY;
    BEGIN
        IF JobQueueEntryExists(JobType, TempJobQueueEntry) THEN
            IF NOT TempJobQueueEntry.Scheduled THEN
                JobQueueManagement.DeleteJobQueueEntries(TempJobQueueEntry."Object Type to Run", TempJobQueueEntry."Object ID to Run");
        CreateJobQueueEntry(JobType);
    END;

    LOCAL PROCEDURE JobQueueEntryExists(JobType: Option "HandlePending","HandleCommError","InitialUpload"; VAR TempJobQueueEntryFound: Record 472 TEMPORARY): Boolean;
    VAR
        JobQueueEntry: Record 472;
    BEGIN
        JobQueueEntry.RESET;
        JobQueueEntry.SETRANGE("Object Type to Run", JobQueueEntry."Object Type to Run"::Codeunit);

        CASE JobType OF
            JobType::HandlePending:
                JobQueueEntry.SETRANGE("Object ID to Run", CODEUNIT::"SII Job Upload Pending Docs. 1");
            JobType::HandleCommError:
                JobQueueEntry.SETRANGE("Object ID to Run", CODEUNIT::"SII Job Retry Comm. Error");
            JobType::InitialUpload:
                JobQueueEntry.SETRANGE("Object ID to Run", CODEUNIT::"SII Initial Doc. Upload 1");
        END;

        IF JobQueueEntry.FINDFIRST THEN BEGIN
            TempJobQueueEntryFound.COPY(JobQueueEntry);
            EXIT(TRUE);
        END;

        EXIT(FALSE);
    END;

    LOCAL PROCEDURE CreateJobQueueEntry(JobType: Option "HandlePending","HandleCommError","InitialUpload");
    VAR
        JobQueueEntry: Record 472;
    BEGIN
        JobQueueEntry."Recurring Job" := FALSE;
        JobQueueEntry."Object Type to Run" := JobQueueEntry."Object Type to Run"::Codeunit;

        CASE JobType OF
            JobType::HandlePending:
                JobQueueEntry."Object ID to Run" := CODEUNIT::"SII Job Upload Pending Docs. 1";
            JobType::HandleCommError:
                JobQueueEntry."Object ID to Run" := CODEUNIT::"SII Job Retry Comm. Error";
            JobType::InitialUpload:
                JobQueueEntry."Object ID to Run" := CODEUNIT::"SII Initial Doc. Upload 1";
        END;

        JobQueueEntry."Earliest Start Date/Time" := CURRENTDATETIME + PeriodInSeconds(JobType) * 1000;
        JobQueueEntry."Report Output Type" := JobQueueEntry."Report Output Type"::"None (Processing only)";
        JobQueueManagement.CreateJobQueueEntry(JobQueueEntry);
        JobQueueEntry.VALIDATE("Notify On Success", FALSE);
        JobQueueEntry.MODIFY(TRUE);

        JobQueueManagement.StartInactiveJobQueueEntries(
          JobQueueEntry."Object Type to Run", JobQueueEntry."Object ID to Run");
    END;

    LOCAL PROCEDURE PeriodInSeconds(JobType: Option "HandlePending","HandleCommError","InitialUpload"): Integer;
    BEGIN
        CASE JobType OF
            JobType::HandlePending:
                EXIT(5);
            JobType::HandleCommError:
                EXIT(24 * 3600);
            JobType::InitialUpload:
                EXIT(5);
        END;
    END;

    //[External]
    PROCEDURE CreateAndStartJobQueueEntryForMissingEntryDetection(UpdateFrequency: Option "Never","Daily","Weekly");
    VAR
        JobQueueEntry: Record 472;
        JobQueueManagement: Codeunit 456;
        SIIRecreateMissingEntries: Codeunit 10757;
    BEGIN
        IF UpdateFrequency = UpdateFrequency::Never THEN
            EXIT;

        IF JobQueueEntryForMissingEntryDetectionExists(JobQueueEntry) THEN
            EXIT;

        CLEAR(JobQueueEntry);
        JobQueueEntry."Earliest Start Date/Time" := CURRENTDATETIME + 1000;
        JobQueueEntry."No. of Minutes between Runs" := UpdateFrequencyToNoOfMinutes(UpdateFrequency);
        JobQueueEntry."Object Type to Run" := JobQueueEntry."Object Type to Run"::Codeunit;
        JobQueueEntry."Object ID to Run" := CODEUNIT::"SII Recreate Missing Entries";
        JobQueueEntry."Maximum No. of Attempts to Run" := 2;
        JobQueueEntry.Status := JobQueueEntry.Status::Ready;
        JobQueueEntry."Rerun Delay (sec.)" := 30;
        JobQueueManagement.CreateJobQueueEntry(JobQueueEntry);
        CODEUNIT.RUN(CODEUNIT::"Job Queue - Enqueue", JobQueueEntry);
        SIIRecreateMissingEntries.SendTraceTagOn(JobQueueEntryStartedTxt);
    END;

    //[External]
    PROCEDURE DeleteJobQueueEntriesForMissingEntryDetection();
    VAR
        JobQueueEntry: Record 472;
        JobQueueManagement: Codeunit 456;
    BEGIN
        JobQueueManagement.DeleteJobQueueEntries(JobQueueEntry."Object Type to Run"::Codeunit, CODEUNIT::"SII Recreate Missing Entries");
    END;

    //[External]
    PROCEDURE JobQueueEntryForMissingEntryDetectionExists(VAR JobQueueEntry: Record 472): Boolean;
    BEGIN
        JobQueueEntry.SETRANGE("Object Type to Run", JobQueueEntry."Object Type to Run"::Codeunit);
        JobQueueEntry.SETRANGE("Object ID to Run", CODEUNIT::"SII Recreate Missing Entries");
        EXIT(JobQueueEntry.FINDFIRST);
    END;

    //[External]
    PROCEDURE RestartJobQueueEntryForMissingEntryCheck(AutomaticMissingEntryCheck: Option);
    BEGIN
        DeleteJobQueueEntriesForMissingEntryDetection;
        CreateAndStartJobQueueEntryForMissingEntryDetection(AutomaticMissingEntryCheck);
    END;

    LOCAL PROCEDURE UpdateFrequencyToNoOfMinutes(UpdateFrequency: Option "Never","Daily","Weekly"): Integer;
    BEGIN
        CASE UpdateFrequency OF
            UpdateFrequency::Daily:
                EXIT(60 * 24);
            UpdateFrequency::Weekly:
                EXIT(60 * 24 * 7);
        END;
    END;

    /* /*BEGIN
END.*/
}









