Codeunit 50906 "Graph Sync. Runner 1"
{


    trigger OnRun()
    BEGIN
        RunFullSync;
    END;

    VAR
        GraphDataSetup: Codeunit 50909;
        ALGraphSyncSynchronouslyCategoryTxt: TextConst ENU = 'AL Graph Sync Synchronously', ESP = 'AL Graph Sync Synchronously';

    //[External]
    PROCEDURE IsGraphSyncEnabled(): Boolean;
    VAR
        MarketingSetup: Record 5079;
        AuxSyncEnabled: Boolean;
    BEGIN
        IF CURRENTEXECUTIONMODE = EXECUTIONMODE::Debug THEN
            EXIT(FALSE);

        IF NOT MarketingSetup.GET THEN
            EXIT(FALSE);

        // IF MarketingSetup."Sync with Microsoft Graph" THEN
        //   EXIT(TRUE);

        OnCheckAuxiliarySyncEnabled(AuxSyncEnabled);
        EXIT(AuxSyncEnabled);
    END;

    //[External]
    PROCEDURE RunDeltaSync();
    BEGIN
        OnRunGraphDeltaSync;
    END;

    //[External]
    PROCEDURE RunDeltaSyncForEntity(TableID: Integer);
    VAR
        IntegrationTableMapping: Record 5335;
        IntegrationMappingCode: Code[20];
    BEGIN
        IntegrationMappingCode := GraphDataSetup.GetMappingCodeForTable(TableID);
        GraphDataSetup.GetIntegrationTableMapping(IntegrationTableMapping, IntegrationMappingCode);
        IF NOT IntegrationTableMapping.IsFullSyncAllowed THEN
            EXIT;

        IntegrationTableMapping.SetFullSyncStartAndCommit;
        RunIntegrationTableSynch(IntegrationTableMapping);

        IntegrationTableMapping.GET(IntegrationTableMapping.Name);
        IntegrationTableMapping.SetFullSyncEndAndCommit;

        OnAfterRunDeltaSyncForEntity(TableID);
    END;

    //[External]
    PROCEDURE RunFullSync();
    BEGIN
        OnRunGraphFullSync;
    END;

    //[External]
    PROCEDURE RunFullSyncForEntity(TableID: Integer);
    VAR
        IntegrationTableMapping: Record 5335;
        IntegrationMappingCode: Code[20];
    BEGIN
        IntegrationMappingCode := GraphDataSetup.GetMappingCodeForTable(TableID);
        GraphDataSetup.GetIntegrationTableMapping(IntegrationTableMapping, IntegrationMappingCode);
        IF NOT IntegrationTableMapping.IsFullSyncAllowed THEN
            EXIT;
        IntegrationTableMapping.SetFullSyncStartAndCommit;

        IntegrationTableMapping."Graph Delta Token" := '';
        IntegrationTableMapping.MODIFY(TRUE);

        CreateIntegrationRecordsForUncoupledRecords(IntegrationTableMapping."Table ID");
        RunIntegrationTableSynch(IntegrationTableMapping);

        IntegrationTableMapping.GET(IntegrationTableMapping.Name);
        IntegrationTableMapping.SetFullSyncEndAndCommit;

        OnAfterRunFullSyncForEntity(TableID);
    END;

    //[External]
    PROCEDURE RunIntegrationTableSynch(IntegrationTableMapping: Record 5335);
    VAR
        IntegrationManagement: Codeunit 50845;
        InsertEnabled: Boolean;
        ModifyEnabled: Boolean;
        DeleteEnabled: Boolean;
        RenameEnabled: Boolean;
    BEGIN
        IntegrationManagement.GetDatabaseTableTriggerSetup(
          IntegrationTableMapping."Table ID", InsertEnabled, ModifyEnabled, DeleteEnabled, RenameEnabled);
        CODEUNIT.RUN(IntegrationTableMapping."Synch. Codeunit ID", IntegrationTableMapping);
    END;

    LOCAL PROCEDURE CreateIntegrationRecordsForUncoupledRecords(TableId: Integer);
    VAR
        IntegrationRecord: Record 51251;
        NavRecordRef: RecordRef;
    BEGIN
        NavRecordRef.OPEN(TableId);

        IF NavRecordRef.FINDSET THEN
            REPEAT
                CLEAR(IntegrationRecord);
                IntegrationRecord.SETRANGE("Record ID", NavRecordRef.RECORDID);
                IF IntegrationRecord.ISEMPTY THEN BEGIN
                    CLEAR(IntegrationRecord);
                    IntegrationRecord."Record ID" := NavRecordRef.RECORDID;
                    IntegrationRecord."Table ID" := NavRecordRef.NUMBER;
                    IntegrationRecord.INSERT(TRUE);
                END;
            UNTIL NavRecordRef.NEXT = 0;
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnCheckAuxiliarySyncEnabled(VAR AuxSyncEnabled: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnRunGraphDeltaSync();
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnRunGraphFullSync();
    BEGIN
    END;

    //[External]
    PROCEDURE SyncFromGraphSynchronously(CodeunitId: Integer; TimeoutInSeconds: Integer);
    VAR
        SessionId: Integer;
        StartDateTime: DateTime;
        TimePassed: Duration;
        TimeoutReached: Boolean;
    BEGIN
        // Start session will use CPU time of main thread while main thread is SLEEPing
        // Taskscheduler cannot be used since it requires a COMMIT to start
        SessionId := 0;

        IF NOT STARTSESSION(SessionId, CodeunitId, COMPANYNAME) THEN BEGIN
            OnSyncSynchronouslyCannotStartSession('Codeunit: ' + FORMAT(CodeunitId));
            EXIT;
        END;

        StartDateTime := CURRENTDATETIME;

        REPEAT
            SLEEP(300);
            IF NOT ISSESSIONACTIVE(SessionId) THEN
                EXIT;

            TimePassed := CURRENTDATETIME - StartDateTime;
            TimeoutReached := TimePassed > TimeoutInSeconds * 1000;
        UNTIL TimeoutReached;

        OnSyncSynchronouslyTimeout('Codeunit: ' + FORMAT(CodeunitId));
    END;

    //[External]
    PROCEDURE GetDefaultSyncSynchronouslyTimeoutInSeconds(): Integer;
    BEGIN
        // User is waiting for the sync to complete
        // This value should not be too great
        EXIT(30);
    END;

    [IntegrationEvent(false, false)]
    LOCAL PROCEDURE OnSyncSynchronouslyCannotStartSession(AdditionalDetails: Text);
    BEGIN
    END;

    [IntegrationEvent(false, false)]
    LOCAL PROCEDURE OnSyncSynchronouslyTimeout(AdditionalDetails: Text);
    BEGIN
    END;

    [EventSubscriber(ObjectType::Codeunit, 50906, OnSyncSynchronouslyCannotStartSession, '', true, true)]
    LOCAL PROCEDURE HandleOnSyncSynchronouslyCannotStartSession(AdditionalDetails: Text);
    BEGIN
        // SENDTRACETAG('00001KX',ALGraphSyncSynchronouslyCategoryTxt,VERBOSITY::Error,'Could not start the session. ' + AdditionalDetails,DATACLASSIFICATION::SystemMetadata);
        Session.LogMessage('00001KX', ALGraphSyncSynchronouslyCategoryTxt, VERBOSITY::Error, DATACLASSIFICATION::SystemMetadata, TelemetryScope::ExtensionPublisher, 'Category', 'Could not start the session. ' + AdditionalDetails);
    END;

    [EventSubscriber(ObjectType::Codeunit, 50906, OnSyncSynchronouslyTimeout, '', true, true)]
    LOCAL PROCEDURE HandleOnSyncSynchronouslySessionTimeout(AdditionalDetails: Text);
    BEGIN
        // SENDTRACETAG('00001KY',ALGraphSyncSynchronouslyCategoryTxt,VERBOSITY::Error,'Timeout on the Forced Graph Sync. ' + AdditionalDetails,DATACLASSIFICATION::SystemMetadata);
        Session.LogMessage('00001KY', ALGraphSyncSynchronouslyCategoryTxt, VERBOSITY::Error, DATACLASSIFICATION::SystemMetadata, TelemetryScope::ExtensionPublisher, 'Category', 'Timeout on the Forced Graph Sync. ' + AdditionalDetails);
    END;

    //[IntegrationEvent]
    //[External]
    PROCEDURE OnAfterRunDeltaSyncForEntity(TableId: Integer);
    BEGIN
    END;

    //[IntegrationEvent]
    //[External]
    PROCEDURE OnAfterRunFullSyncForEntity(TableId: Integer);
    BEGIN
    END;

    /* /*BEGIN
END.*/
}







