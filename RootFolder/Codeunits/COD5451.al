Codeunit 50905 "Graph Integration Table Sync 1"
{


    TableNo = 5335;
    trigger OnRun()
    VAR
        GraphConnectionSetup: Codeunit 5456;
        GraphSubscriptionManagement: Codeunit 50904;
        SynchronizeConnectionName: Text;
    BEGIN
        GraphConnectionSetup.RegisterConnections;
        SynchronizeConnectionName := GraphConnectionSetup.GetSynchronizeConnectionName(rec."Table ID");
        SETDEFAULTTABLECONNECTION(TABLECONNECTIONTYPE::MicrosoftGraph, SynchronizeConnectionName, TRUE);

        IF NOT TryAccessGraph(Rec) THEN BEGIN
            // SENDTRACETAG('00001SP',GraphSubscriptionManagement.TraceCategory,VERBOSITY::Error,STRSUBSTNO(NoGraphAccessTxt,GETLASTERRORTEXT),DATACLASSIFICATION::SystemMetadata);
            Session.LogMessage('00001SP', NoGraphAccessTxt, VERBOSITY::Error, DATACLASSIFICATION::SystemMetadata, TelemetryScope::ExtensionPublisher, 'Category', NoGraphAccessTxt);
            EXIT;
        END;

        IF rec.Direction IN [rec.Direction::ToIntegrationTable, rec.Direction::Bidirectional] THEN
            PerformScheduledSynchToIntegrationTable(Rec);

        IF rec.Direction IN [rec.Direction::FromIntegrationTable, rec.Direction::Bidirectional] THEN
            PerformScheduledSynchFromIntegrationTable(Rec);
    END;

    VAR
        SkippingSyncTxt: TextConst ENU = 'Ignoring sync for record of table %1.', ESP = 'Ignoring sync for record of table %1.';
        NoGraphAccessTxt: TextConst ENU = 'Skipping synchronization due to an error accessing the Graph table. \\%1', ESP = 'Skipping synchronization due to an error accessing the Graph table. \\%1';

    LOCAL PROCEDURE PerformScheduledSynchToIntegrationTable(VAR IntegrationTableMapping: Record 5335);
    VAR
        IntegrationRecord: Record 51251;
        ModifiedOnIntegrationRecord: Record 51251;
        GraphIntegrationRecord: Record 51352;
        IntegrationTableSynch: Codeunit 5335;
        SourceRecordRef: RecordRef;
        DestinationRecordRef: RecordRef;
        LatestModifiedOn: DateTime;
        Found: Boolean;
        SkipSyncOnRecord: Boolean;
    BEGIN
        SourceRecordRef.OPEN(IntegrationTableMapping."Table ID");

        IntegrationRecord.SETRANGE("Table ID", IntegrationTableMapping."Table ID");
        IF IntegrationTableMapping."Synch. Modified On Filter" <> 0DT THEN
            IntegrationRecord.SETFILTER("Modified On", '>%1', IntegrationTableMapping."Synch. Modified On Filter");

        // Peform synch.
        IntegrationTableSynch.BeginIntegrationSynchJob(
          TABLECONNECTIONTYPE::MicrosoftGraph, IntegrationTableMapping, SourceRecordRef.NUMBER);

        LatestModifiedOn := 0DT;
        IF NOT IntegrationRecord.FINDSET THEN BEGIN
            IntegrationTableSynch.EndIntegrationSynchJob;
            EXIT;
        END;

        REPEAT
            Found := FALSE;
            SkipSyncOnRecord := FALSE;

            IF SourceRecordRef.GET(IntegrationRecord."Record ID") THEN
                Found := TRUE;

            IF NOT Found THEN
                IF GraphIntegrationRecord.IsRecordCoupled(IntegrationRecord."Record ID") THEN BEGIN
                    SourceRecordRef.GET(IntegrationRecord."Record ID");
                    Found := TRUE;
                END;

            OnBeforeSynchronizationStart(IntegrationTableMapping, SourceRecordRef, SkipSyncOnRecord);

            IF Found AND (NOT SkipSyncOnRecord) THEN
                IF IntegrationTableSynch.Synchronize(SourceRecordRef, DestinationRecordRef, FALSE, FALSE) THEN BEGIN
                    SaveChangeKeyFromDestinationRefToGraphIntegrationTable(IntegrationTableMapping, DestinationRecordRef);
                    ModifiedOnIntegrationRecord.FindByRecordId(SourceRecordRef.RECORDID);
                    IF ModifiedOnIntegrationRecord."Modified On" > LatestModifiedOn THEN
                        LatestModifiedOn := ModifiedOnIntegrationRecord."Modified On";
                END;
        UNTIL (IntegrationRecord.NEXT = 0);

        IntegrationTableSynch.EndIntegrationSynchJob;

        IF (LatestModifiedOn <> 0DT) AND (LatestModifiedOn > IntegrationTableMapping."Synch. Modified On Filter") THEN BEGIN
            IntegrationTableMapping."Synch. Modified On Filter" := LatestModifiedOn;
            IntegrationTableMapping.MODIFY(TRUE);
        END;
    END;

    LOCAL PROCEDURE PerformScheduledSynchFromIntegrationTable(VAR IntegrationTableMapping: Record 5335);
    VAR
        IntegrationTableSynch: Codeunit 5335;
        SourceRecordRef: RecordRef;
        SourceRecordRef2: RecordRef;
        DestinationRecordRef: RecordRef;
        SourceFieldRef: FieldRef;
        ModifiedOn: DateTime;
        LatestModifiedOn: DateTime;
        SkipSyncOnRecord: Boolean;
    BEGIN
        SourceRecordRef.OPEN(IntegrationTableMapping."Integration Table ID");
        IF IntegrationTableMapping."Graph Delta Token" <> '' THEN BEGIN
            SourceFieldRef := SourceRecordRef.FIELD(IntegrationTableMapping."Int. Tbl. Delta Token Fld. No.");
            SourceFieldRef.SETFILTER('<>%1', IntegrationTableMapping."Graph Delta Token");
        END;

        // Peform synch.
        IntegrationTableSynch.BeginIntegrationSynchJob(
          TABLECONNECTIONTYPE::MicrosoftGraph, IntegrationTableMapping, SourceRecordRef.NUMBER);

        LatestModifiedOn := 0DT;
        IF SourceRecordRef.FINDSET THEN BEGIN
            SaveDeltaTokenFromSourceRecRefToIntegrationTable(SourceRecordRef, IntegrationTableMapping);
            REPEAT
                SourceRecordRef2 := SourceRecordRef.DUPLICATE;
                SkipSyncOnRecord := FALSE;
                OnBeforeSynchronizationStart(IntegrationTableMapping, SourceRecordRef2, SkipSyncOnRecord);
                IF NOT SkipSyncOnRecord THEN
                    IF IntegrationTableSynch.Synchronize(SourceRecordRef2, DestinationRecordRef, TRUE, FALSE) THEN BEGIN
                        SaveChangeKeyFromDestinationRefToGraphIntegrationTable(IntegrationTableMapping, SourceRecordRef2);
                        ModifiedOn := IntegrationTableSynch.GetRowLastModifiedOn(IntegrationTableMapping, SourceRecordRef2);
                        IF ModifiedOn > LatestModifiedOn THEN
                            LatestModifiedOn := ModifiedOn;
                    END;
            UNTIL (SourceRecordRef.NEXT = 0);
        END;

        IntegrationTableSynch.EndIntegrationSynchJob;

        IF (LatestModifiedOn <> 0DT) AND (LatestModifiedOn > IntegrationTableMapping."Synch. Int. Tbl. Mod. On Fltr.") THEN BEGIN
            IntegrationTableMapping."Synch. Int. Tbl. Mod. On Fltr." := LatestModifiedOn;
            IntegrationTableMapping.MODIFY(TRUE);
        END;
    END;

    //[External]
    PROCEDURE PerformRecordSynchToIntegrationTable(VAR IntegrationTableMapping: Record 5335; SourceRecordRef: RecordRef): Boolean;
    VAR
        ModifiedOnIntegrationRecord: Record 51251;
        IntegrationTableSynch: Codeunit 5335;
        DestinationRecordRef: RecordRef;
        LatestModifiedOn: DateTime;
        SkipSyncOnRecord: Boolean;
    BEGIN
        IF GETDEFAULTTABLECONNECTION(TABLECONNECTIONTYPE::MicrosoftGraph) = '' THEN
            EXIT;

        // Peform synch.
        IntegrationTableSynch.BeginIntegrationSynchJob(
          TABLECONNECTIONTYPE::MicrosoftGraph, IntegrationTableMapping, SourceRecordRef.NUMBER);

        LatestModifiedOn := 0DT;

        OnBeforeSynchronizationStart(IntegrationTableMapping, SourceRecordRef, SkipSyncOnRecord);
        IF NOT SkipSyncOnRecord THEN
            IF IntegrationTableSynch.Synchronize(SourceRecordRef, DestinationRecordRef, FALSE, FALSE) THEN BEGIN
                SaveChangeKeyFromDestinationRefToGraphIntegrationTable(IntegrationTableMapping, DestinationRecordRef);
                ModifiedOnIntegrationRecord.FindByRecordId(SourceRecordRef.RECORDID);
                IF ModifiedOnIntegrationRecord."Modified On" > LatestModifiedOn THEN
                    LatestModifiedOn := ModifiedOnIntegrationRecord."Modified On";
            END;

        IntegrationTableSynch.EndIntegrationSynchJob;

        EXIT(SkipSyncOnRecord);
    END;

    //[External]
    PROCEDURE PerformRecordSynchFromIntegrationTable(VAR IntegrationTableMapping: Record 5335; SourceRecordRef: RecordRef);
    VAR
        IntegrationTableSynch: Codeunit 5335;
        DestinationRecordRef: RecordRef;
        ModifiedOn: DateTime;
        LatestModifiedOn: DateTime;
        SkipSyncOnRecord: Boolean;
    BEGIN
        IF GETDEFAULTTABLECONNECTION(TABLECONNECTIONTYPE::MicrosoftGraph) = '' THEN
            EXIT;

        // Peform synch.
        IntegrationTableSynch.BeginIntegrationSynchJob(
          TABLECONNECTIONTYPE::MicrosoftGraph, IntegrationTableMapping, SourceRecordRef.NUMBER);

        LatestModifiedOn := 0DT;
        OnBeforeSynchronizationStart(IntegrationTableMapping, SourceRecordRef, SkipSyncOnRecord);
        IF NOT SkipSyncOnRecord THEN
            IF IntegrationTableSynch.Synchronize(SourceRecordRef, DestinationRecordRef, TRUE, FALSE) THEN BEGIN
                SaveChangeKeyFromDestinationRefToGraphIntegrationTable(IntegrationTableMapping, SourceRecordRef);
                ModifiedOn := IntegrationTableSynch.GetRowLastModifiedOn(IntegrationTableMapping, SourceRecordRef);
                IF ModifiedOn > LatestModifiedOn THEN
                    LatestModifiedOn := ModifiedOn;
            END;

        IntegrationTableSynch.EndIntegrationSynchJob;
    END;

    //[External]
    PROCEDURE PerformRecordDeleteFromIntegrationTable(VAR IntegrationTableMapping: Record 5335; DestinationRecordRef: RecordRef);
    VAR
        IntegrationTableSynch: Codeunit 5335;
        SkipSyncOnRecord: Boolean;
    BEGIN
        IF GETDEFAULTTABLECONNECTION(TABLECONNECTIONTYPE::MicrosoftGraph) = '' THEN
            EXIT;

        IntegrationTableSynch.BeginIntegrationSynchJob(
          TABLECONNECTIONTYPE::MicrosoftGraph, IntegrationTableMapping, DestinationRecordRef.NUMBER);
        OnBeforeSynchronizationStart(IntegrationTableMapping, DestinationRecordRef, SkipSyncOnRecord);
        IntegrationTableSynch.Delete(DestinationRecordRef);
        IntegrationTableSynch.EndIntegrationSynchJob;
    END;

    //[External]
    PROCEDURE PerformRecordDeleteToIntegrationTable(VAR IntegrationTableMapping: Record 5335; DestinationRecordRef: RecordRef);
    VAR
        IntegrationTableSynch: Codeunit 5335;
        SkipSyncOnRecord: Boolean;
    BEGIN
        IF GETDEFAULTTABLECONNECTION(TABLECONNECTIONTYPE::MicrosoftGraph) = '' THEN
            EXIT;

        IntegrationTableSynch.BeginIntegrationSynchJob(
          TABLECONNECTIONTYPE::MicrosoftGraph, IntegrationTableMapping, DestinationRecordRef.NUMBER);
        OnBeforeSynchronizationStart(IntegrationTableMapping, DestinationRecordRef, SkipSyncOnRecord);
        IF IntegrationTableSynch.Delete(DestinationRecordRef) THEN
            ArchiveIntegrationRecords(DestinationRecordRef, IntegrationTableMapping);

        IntegrationTableSynch.EndIntegrationSynchJob;
    END;

    LOCAL PROCEDURE SaveDeltaTokenFromSourceRecRefToIntegrationTable(SourceRecRef: RecordRef; VAR IntegrationTableMapping: Record 5335);
    VAR
        DeltaTokenFieldRef: FieldRef;
    BEGIN
        IF IntegrationTableMapping."Int. Tbl. Delta Token Fld. No." > 0 THEN BEGIN
            DeltaTokenFieldRef := SourceRecRef.FIELD(IntegrationTableMapping."Int. Tbl. Delta Token Fld. No.");
            IntegrationTableMapping."Graph Delta Token" := DeltaTokenFieldRef.VALUE;
            IntegrationTableMapping.MODIFY;
        END;
    END;

    LOCAL PROCEDURE SaveChangeKeyFromDestinationRefToGraphIntegrationTable(IntegrationTableMapping: Record 5335; SourceRecRef: RecordRef);
    VAR
        GraphIntegrationRecord: Record 51352;
        ChangeKeyFieldRef: FieldRef;
        GraphIdFieldRef: FieldRef;
    BEGIN
        IF SourceRecRef.NUMBER = IntegrationTableMapping."Integration Table ID" THEN BEGIN
            ChangeKeyFieldRef := SourceRecRef.FIELD(IntegrationTableMapping."Int. Tbl. ChangeKey Fld. No.");
            GraphIdFieldRef := SourceRecRef.FIELD(IntegrationTableMapping."Integration Table UID Fld. No.");

            GraphIntegrationRecord.SETRANGE("Graph ID", FORMAT(GraphIdFieldRef.VALUE));
            GraphIntegrationRecord.SETRANGE("Table ID", IntegrationTableMapping."Table ID");
            IF GraphIntegrationRecord.FINDFIRST THEN BEGIN
                GraphIntegrationRecord.ChangeKey := ChangeKeyFieldRef.VALUE;
                GraphIntegrationRecord.MODIFY;
            END;
        END;
    END;

    //[External]
    PROCEDURE WasChangeKeyModifiedAfterLastRecordSynch(IntegrationTableMapping: Record 5335; VAR RecordRef: RecordRef): Boolean;
    VAR
        GraphIntegrationRecord: Record 51352;
        GraphRecordRef: RecordRef;
        ChangeKeyFieldRef: FieldRef;
        GraphIdFieldRef: FieldRef;
        DestinationGraphId: Text[250];
    BEGIN
        // If a changekey field is not present, default it to changed so that the sync is not skipped
        IF IntegrationTableMapping."Int. Tbl. ChangeKey Fld. No." = 0 THEN
            EXIT(TRUE);

        IF IntegrationTableMapping."Integration Table ID" = RecordRef.NUMBER THEN BEGIN
            ChangeKeyFieldRef := RecordRef.FIELD(IntegrationTableMapping."Int. Tbl. ChangeKey Fld. No.");
            GraphIdFieldRef := RecordRef.FIELD(IntegrationTableMapping."Integration Table UID Fld. No.");

            GraphIntegrationRecord.SETRANGE("Graph ID", FORMAT(GraphIdFieldRef.VALUE));
            GraphIntegrationRecord.SETRANGE("Table ID", IntegrationTableMapping."Table ID");
            IF NOT GraphIntegrationRecord.FINDFIRST THEN
                EXIT(TRUE);
            IF GraphIntegrationRecord.ChangeKey <> FORMAT(ChangeKeyFieldRef.VALUE) THEN
                EXIT(TRUE);
        END;

        IF IntegrationTableMapping."Table ID" = RecordRef.NUMBER THEN
            IF GraphIntegrationRecord.FindIDFromRecordID(RecordRef.RECORDID, DestinationGraphId) THEN BEGIN
                GraphRecordRef.OPEN(IntegrationTableMapping."Integration Table ID");
                GraphIdFieldRef := GraphRecordRef.FIELD(IntegrationTableMapping."Integration Table UID Fld. No.");
                GraphIdFieldRef.SETRANGE(DestinationGraphId);
                IF NOT GraphRecordRef.FINDFIRST THEN
                    EXIT(TRUE);

                ChangeKeyFieldRef := GraphRecordRef.FIELD(IntegrationTableMapping."Int. Tbl. ChangeKey Fld. No.");
                GraphIntegrationRecord.SETRANGE("Graph ID", DestinationGraphId);
                GraphIntegrationRecord.SETRANGE("Table ID", IntegrationTableMapping."Table ID");
                IF NOT GraphIntegrationRecord.FINDFIRST THEN
                    EXIT(TRUE);
                IF FORMAT(ChangeKeyFieldRef.VALUE) <> GraphIntegrationRecord.ChangeKey THEN
                    EXIT(TRUE);
            END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 50905, OnBeforeSynchronizationStart, '', true, true)]
    LOCAL PROCEDURE IgnoreSyncBasedOnChangekey(IntegrationTableMapping: Record 5335; SourceRecordRef: RecordRef; VAR IgnoreRecord: Boolean);
    VAR
        GraphSubscriptionManagement: Codeunit 50904;
    BEGIN
        IF IgnoreRecord OR (IntegrationTableMapping."Int. Tbl. ChangeKey Fld. No." = 0) THEN
            EXIT;
        IF WasChangeKeyModifiedAfterLastRecordSynch(IntegrationTableMapping, SourceRecordRef) THEN BEGIN
            IgnoreRecord := SourceRecordRef.NUMBER = IntegrationTableMapping."Table ID";
            IF IgnoreRecord THEN
                // SENDTRACETAG('00001BE',GraphSubscriptionManagement.TraceCategory,VERBOSITY::Verbose,STRSUBSTNO(SkippingSyncTxt,SourceRecordRef.NUMBER),DATACLASSIFICATION::SystemMetadata);
                Session.LogMessage('00001BE', SkippingSyncTxt, VERBOSITY::Verbose, DATACLASSIFICATION::SystemMetadata, TelemetryScope::ExtensionPublisher, 'Category', SkippingSyncTxt);
            EXIT;
        END;

        IgnoreRecord := SourceRecordRef.NUMBER = IntegrationTableMapping."Integration Table ID";
    END;

    LOCAL PROCEDURE ArchiveIntegrationRecords(RecordRef: RecordRef; IntegrationTableMapping: Record 5335);
    VAR
        GraphIntegrationRecord: Record 51352;
        // GraphIntegrationRecArchive : Record 5452;
        GraphIdFieldRef: FieldRef;
    BEGIN
        GraphIdFieldRef := RecordRef.FIELD(IntegrationTableMapping."Integration Table UID Fld. No.");
        GraphIntegrationRecord.SETRANGE("Graph ID", FORMAT(GraphIdFieldRef.VALUE));
        GraphIntegrationRecord.SETRANGE("Table ID", IntegrationTableMapping."Table ID");
        // IF GraphIntegrationRecord.FINDFIRST THEN BEGIN
        //   GraphIntegrationRecArchive.TRANSFERFIELDS(GraphIntegrationRecord);
        //   IF GraphIntegrationRecArchive.INSERT THEN
        //     GraphIntegrationRecord.DELETE;
        // END;
    END;

    [TryFunction]
    LOCAL PROCEDURE TryAccessGraph(IntegrationTableMapping: Record 5335);
    VAR
        GraphRecordRef: RecordRef;
    BEGIN
        // Attempt to call an operation on the graph. If it fails, then a sync shouldn't be attempted.
        GraphRecordRef.OPEN(IntegrationTableMapping."Integration Table ID");
        IF GraphRecordRef.ISEMPTY THEN;
    END;

    [IntegrationEvent(false, false)]
    LOCAL PROCEDURE OnBeforeSynchronizationStart(IntegrationTableMapping: Record 5335; SourceRecordRef: RecordRef; VAR IgnoreRecord: Boolean);
    BEGIN
    END;

    /* /*BEGIN
END.*/
}







