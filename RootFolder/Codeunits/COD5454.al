Codeunit 50908 "Graph Sync. Runner - OnDelete"
{


    // TableNo=5152;
    trigger OnRun()
    VAR
        IntegrationTableMapping: Record 5335;
        GraphIntegrationRecord: Record 51352;
        GraphConnectionSetup: Codeunit 5456;
        GraphDataSetup: Codeunit 50909;
        GraphIntegrationTableSync: Codeunit 50905;
        GraphSyncRunner: Codeunit 50906;
        GraphRecordRef: RecordRef;
        GraphIdFieldRef: FieldRef;
        SynchronizeConnectionName: Text;
        IntegrationMappingCode: Code[20];
    BEGIN
        // IF rec.ISTEMPORARY THEN
        //   EXIT;

        IF NOT GraphSyncRunner.IsGraphSyncEnabled THEN
            EXIT;

        IF NOT GraphConnectionSetup.CanRunSync THEN
            EXIT;

        GraphConnectionSetup.RegisterConnections;
        // SynchronizeConnectionName := GraphConnectionSetup.GetSynchronizeConnectionName(rec."Table ID");
        // IntegrationMappingCode := GraphDataSetup.GetMappingCodeForTable(rec."Table ID");

        SETDEFAULTTABLECONNECTION(TABLECONNECTIONTYPE::MicrosoftGraph, SynchronizeConnectionName, TRUE);
        GraphDataSetup.GetIntegrationTableMapping(IntegrationTableMapping, IntegrationMappingCode);

        // GraphIntegrationRecord.SETRANGE("Integration ID",rec."Integration ID");
        GraphIntegrationRecord.SETRANGE("Table ID", IntegrationTableMapping."Table ID");
        IF GraphIntegrationRecord.FINDFIRST THEN BEGIN
            GraphRecordRef.OPEN(IntegrationTableMapping."Integration Table ID");
            GraphIdFieldRef := GraphRecordRef.FIELD(IntegrationTableMapping."Integration Table UID Fld. No.");
            GraphIdFieldRef.SETRANGE(GraphIntegrationRecord."Graph ID");
            IF GraphRecordRef.FINDFIRST THEN
                GraphIntegrationTableSync.PerformRecordDeleteToIntegrationTable(IntegrationTableMapping, GraphRecordRef);
        END;
    END;

    /* /*BEGIN
END.*/
}







