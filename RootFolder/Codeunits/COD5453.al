Codeunit 50907 "Graph Sync. Runner - OnModify"
{


    TableNo = 51251;
    trigger OnRun()
    VAR
        IntegrationTableMapping: Record 5335;
        GraphIntegrationRecord: Record 51352;
        GraphSyncRunner: Codeunit 50906;
        GraphConnectionSetup: Codeunit 5456;
        GraphDataSetup: Codeunit 50909;
        GraphIntegrationTableSync: Codeunit 50905;
        SourceRecordRef: RecordRef;
        IntegrationMappingCode: Code[20];
        InboundConnectionName: Text;
        SynchronizeConnectionName: Text;
        DestinationGraphId: Text[250];
        SyncOnRecordSkipped: Boolean;
    BEGIN
        IF rec.ISTEMPORARY THEN
            EXIT;

        IF NOT GraphSyncRunner.IsGraphSyncEnabled THEN
            EXIT;

        IF NOT GraphConnectionSetup.CanRunSync THEN
            EXIT;

        GraphConnectionSetup.RegisterConnections;
        IntegrationMappingCode := GraphDataSetup.GetMappingCodeForTable(rec."Table ID");
        SynchronizeConnectionName := GraphConnectionSetup.GetSynchronizeConnectionName(rec."Table ID");
        InboundConnectionName := GraphConnectionSetup.GetInboundConnectionName(rec."Table ID");

        SETDEFAULTTABLECONNECTION(TABLECONNECTIONTYPE::MicrosoftGraph, SynchronizeConnectionName, TRUE);

        GraphDataSetup.GetIntegrationTableMapping(IntegrationTableMapping, IntegrationMappingCode);
        SourceRecordRef.GET(rec."Record ID");

        SyncOnRecordSkipped := GraphIntegrationTableSync.PerformRecordSynchToIntegrationTable(IntegrationTableMapping, SourceRecordRef);

        // SyncOnRecordSkipped = TRUE when conflict is detected. In this case we force sync graph to nav
        IF SyncOnRecordSkipped AND GraphIntegrationRecord.FindIDFromRecordID(SourceRecordRef.RECORDID, DestinationGraphId) THEN BEGIN
            SETDEFAULTTABLECONNECTION(TABLECONNECTIONTYPE::MicrosoftGraph, InboundConnectionName, TRUE);
            GraphDataSetup.GetGraphRecord(SourceRecordRef, DestinationGraphId, rec."Table ID");
            GraphIntegrationTableSync.PerformRecordSynchFromIntegrationTable(IntegrationTableMapping, SourceRecordRef);
        END;
    END;

    /* /*BEGIN
END.*/
}







