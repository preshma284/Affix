Codeunit 50903 "Graph Webhook Sync To NAV 1"
{
  
  
    TableNo=2000000194;
    trigger OnRun()
VAR
            IntegrationSynchJobErrors : Record 5339;
            IntegrationTableMapping : Record 5335;
            WebhookSubscription : Record 2000000199;
            GraphDataSetup : Codeunit 50902;
            GraphConnectionSetup : Codeunit 5456;
            GraphIntegrationTableSync : Codeunit 50905;
            GraphSubscriptionManagement : Codeunit 50904;
            SourceRecordRef : RecordRef;
            DestinationRecordRef : RecordRef;
            InboundConnectionName : Text;
            EmptyGuid : GUID;
            IntegrationMappingCode : Code[20];
            TableID : Integer;
          BEGIN
            OnFindWebhookSubscription(WebhookSubscription,rec."Subscription ID",IntegrationMappingCode);
            IF IntegrationMappingCode = '' THEN
              EXIT;

            //SENDTRACETAG('000016Z',GraphSubscriptionManagement.TraceCategory,VERBOSITY::Verbose,STRSUBSTNO(ReceivedNotificationTxt,rec."Change Type",IntegrationMappingCode,rec."Resource ID"),DATACLASSIFICATION::SystemMetadata);
            Session.LogMessage('000016Z',ReceivedNotificationTxt,VERBOSITY::Verbose,DATACLASSIFICATION::SystemMetadata,TelemetryScope::ExtensionPublisher,GraphSubscriptionManagement.TraceCategory,ReceivedNotificationTxt);
            GraphConnectionSetup.RegisterConnections;
            // GraphDataSetup.GetIntegrationTableMapping(IntegrationTableMapping,IntegrationMappingCode);
            // TableID := GraphDataSetup.GetInboundTableID(IntegrationMappingCode);
            InboundConnectionName := GraphConnectionSetup.GetInboundConnectionName(TableID);
            SETDEFAULTTABLECONNECTION(TABLECONNECTIONTYPE::MicrosoftGraph,InboundConnectionName,TRUE);

            CASE DELCHR(rec."Change Type",'=',' ') OF
              GetGraphSubscriptionCreatedChangeType,
              GetGraphSubscriptionUpdatedChangeType:
                IF GraphSubscriptionManagement.GetSourceRecordRef(SourceRecordRef,Rec,IntegrationTableMapping."Integration Table ID") THEN
                  GraphIntegrationTableSync.PerformRecordSynchFromIntegrationTable(IntegrationTableMapping,SourceRecordRef);
              GetGraphSubscriptionDeletedChangeType:
                IF GraphSubscriptionManagement.GetDestinationRecordRef(DestinationRecordRef,Rec,IntegrationTableMapping."Table ID") THEN BEGIN
                  GraphIntegrationTableSync.PerformRecordDeleteFromIntegrationTable(IntegrationTableMapping,DestinationRecordRef);
                  ArchiveIntegrationRecords(Rec,DestinationRecordRef.NUMBER);
                END;
              GetGraphSubscriptionMissedChangeType:
                IntegrationSynchJobErrors.LogSynchError(EmptyGuid,rec.RECORDID,rec.RECORDID,
                  STRSUBSTNO(WebhookNotificationTxt,rec."Change Type",rec."Resource ID"));
              ELSE
                IntegrationSynchJobErrors.LogSynchError(EmptyGuid,rec.RECORDID,rec.RECORDID,
                  STRSUBSTNO(UnsupportedChangeTypeErr,rec."Change Type"));
            END;
          END;
    VAR
      ChangeType : Option "Created","Updated","Deleted","Missed";
      UnsupportedChangeTypeErr : TextConst ENU='The %1 change type is not supported.',ESP='No se admite el tipo de cambio %1.';
      WebhookNotificationTxt : TextConst ENU='"Change Type = %1, Resource ID = %2."',ESP='"Tipo de cambio = %1, Id. de recurso = %2."';
      ReceivedNotificationTxt : TextConst ENU='Received %1 notification for the %2 table mapping. Graph ID: %3.',ESP='Received %1 notification for the %2 table mapping. Graph ID: %3.';

    //[External]
    PROCEDURE GetGraphSubscriptionChangeTypes() : Text[250];
    BEGIN
      // Created,Updated,Deleted
      EXIT(STRSUBSTNO('%1,%2,%3',
          GetGraphSubscriptionCreatedChangeType,GetGraphSubscriptionUpdatedChangeType,GetGraphSubscriptionDeletedChangeType));
    END;

    //[External]
    PROCEDURE GetGraphSubscriptionCreatedChangeType() : Text[50];
    BEGIN
      EXIT(FORMAT(ChangeType::Created,0,0));
    END;

    //[External]
    PROCEDURE GetGraphSubscriptionUpdatedChangeType() : Text[50];
    BEGIN
      EXIT(FORMAT(ChangeType::Updated,0,0));
    END;

    //[External]
    PROCEDURE GetGraphSubscriptionDeletedChangeType() : Text[50];
    BEGIN
      EXIT(FORMAT(ChangeType::Deleted,0,0));
    END;

    //[External]
    PROCEDURE GetGraphSubscriptionMissedChangeType() : Text[50];
    BEGIN
      EXIT(FORMAT(ChangeType::Missed,0,0));
    END;

    LOCAL PROCEDURE ArchiveIntegrationRecords(WebhookNotification : Record 2000000194;TableId : Integer);
    VAR
      GraphIntegrationRecord : Record 51352;
      // GraphIntegrationRecArchive : Record 5452;
      OutputStream : OutStream;
    BEGIN
      GraphIntegrationRecord.SETRANGE("Graph ID",WebhookNotification."Resource ID");
      GraphIntegrationRecord.SETRANGE("Table ID",TableId);
      // IF GraphIntegrationRecord.FINDFIRST THEN BEGIN
      //   GraphIntegrationRecArchive.TRANSFERFIELDS(GraphIntegrationRecord);
      //   GraphIntegrationRecArchive."Webhook Notification".CREATEOUTSTREAM(OutputStream);
      //   OutputStream.WRITE(ReadWebhookNotificationDetails(WebhookNotification));
      //   IF GraphIntegrationRecArchive.INSERT THEN
      //     GraphIntegrationRecord.DELETE;
      // END;
    END;

    LOCAL PROCEDURE ReadWebhookNotificationDetails(WebhookNotification : Record 2000000194) WebhookNotificationDetails : Text;
    VAR
      InputStream : InStream;
    BEGIN
      IF WebhookNotification.Notification.HASVALUE THEN BEGIN
        WebhookNotification.CALCFIELDS(Notification);
        WebhookNotification.Notification.CREATEINSTREAM(InputStream);
        InputStream.READ(WebhookNotificationDetails);
      END ELSE
        WebhookNotificationDetails :=
          STRSUBSTNO(WebhookNotificationTxt,WebhookNotification."Change Type",WebhookNotification."Resource ID");
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnFindWebhookSubscription(VAR WebhookSubscription : Record 2000000199;SubscriptionID : Text[150];VAR IntegrationMappingCode : Code[20]);
    BEGIN
    END;

    /* /*BEGIN
END.*/
}







