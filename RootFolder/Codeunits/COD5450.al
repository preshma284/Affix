Codeunit 50904 "Graph Subscription Management"
{
  
  
    Permissions=TableData 2000000199=rimd;
    trigger OnRun()
VAR
            GraphSyncRunner : Codeunit 50906;
            SyncMode : Option;
          BEGIN
            SyncMode := SyncModeOption::Delta;
            CheckGraphSubscriptions(SyncMode);

            CASE SyncMode OF
              SyncModeOption::Full:
                GraphSyncRunner.RunFullSync;
              SyncModeOption::Delta:
                GraphSyncRunner.RunDeltaSync;
            END;
          END;
    VAR
      ClientTypeManagement : Codeunit 50192;
      SyncModeOption : Option "Full","Delta";
      ChangeType : Option "Created","Updated","Deleted","Missed";
      SubscriptionRefreshTasksTxt : TextConst ENU='Scheduled %1 future tasks to keep graph subscriptions up to date.',ESP='Scheduled %1 future tasks to keep graph subscriptions up to date.';

    //[External]
    PROCEDURE AddOrUpdateGraphSubscription(VAR FirstTimeSync : Boolean;WebhookExists : Boolean;VAR WebhookSubscription : Record 2000000199;EntityEndpoint : Text[250]);
    VAR
      // GraphSubscription : Record 5455;
      WebhookManagement : Codeunit 5377;
    BEGIN
      FirstTimeSync := FirstTimeSync OR NOT WebhookExists;
      // CASE TRUE OF
      //   NOT WebhookExists:
      //     CreateNewWebhookSubscription(GraphSubscription,WebhookSubscription,EntityEndpoint);
      //   NOT GraphSubscription.GET(WebhookSubscription."Subscription ID"):
      //     CreateNewGraphSubscription(GraphSubscription,WebhookSubscription,EntityEndpoint);
      //   GraphSubscription.NotificationUrl <> WebhookManagement.GetNotificationUrl:
      //     BEGIN
      //       IF GraphSubscription.DELETE THEN;
      //       CreateNewGraphSubscription(GraphSubscription,WebhookSubscription,EntityEndpoint);
      //     END;
      //   ELSE BEGIN
      //     GraphSubscription.ExpirationDateTime := CURRENTDATETIME + GetMaximumExpirationDateTimeOffset;
      //     GraphSubscription.Type := GetGraphSubscriptionType;
      //     IF GraphSubscription.MODIFY THEN;
      //   END;
      // END;
    END;

    //[External]
    PROCEDURE CleanExistingWebhookSubscription(ResourceUrl : Text[250];CompName : Text[30]);
    VAR
      WebhookSubscription : Record 2000000199;
      WebhookSubscription2 : Record 2000000199;
    BEGIN
      IF WebhookSubscription.FINDSET THEN
        REPEAT
          IF (WebhookSubscription.Endpoint = ResourceUrl) AND
             (WebhookSubscription."Company Name" = CompName)
          THEN BEGIN
            WebhookSubscription2.GET(WebhookSubscription."Subscription ID",WebhookSubscription.Endpoint);
            WebhookSubscription2.DELETE;
          END;
        UNTIL WebhookSubscription.NEXT = 0;
    END;

    //[External]
    PROCEDURE GetDestinationRecordRef(VAR NAVRecordRef : RecordRef;WebhookNotification : Record 2000000194;TableID : Integer) Retrieved : Boolean;
    VAR
      GraphIntegrationRecord : Record 51352;
      DestinationRecordId : RecordID;
    BEGIN
      IF GraphIntegrationRecord.FindRecordIDFromID(WebhookNotification."Resource ID",TableID,DestinationRecordId) THEN
        Retrieved := NAVRecordRef.GET(DestinationRecordId);
    END;

    //[External]
    PROCEDURE GetGraphSubscriptionType() : Text[250];
    BEGIN
      EXIT('#Microsoft.OutlookServices.PushSubscription');
    END;

    //[External]
    PROCEDURE GetGraphSubscriptionCreatedChangeType() : Text[50];
    BEGIN
      EXIT(FORMAT(ChangeType::Created,0,0));
    END;

    //[External]
    PROCEDURE GetMaximumExpirationDateTimeOffset() : Integer;
    BEGIN
      // Maximum expiration datetime is 4230 minutes as documented in https://dev.office.com/blogs/Microsoft-Graph-webhooks-update-March-2016
      EXIT(4230 * 60 * 1000);
    END;

    //[External]
    PROCEDURE GetSourceRecordRef(VAR GraphRecordRef : RecordRef;WebhookNotification : Record 2000000194;IntegrationTableID : Integer) Retrieved : Boolean;
    BEGIN
      OnGetSourceRecordRef(GraphRecordRef,WebhookNotification,IntegrationTableID,Retrieved);
    END;

    //[External]
    PROCEDURE TraceCategory() : Text;
    BEGIN
      EXIT('AL SyncEngine');
    END;

    //[External]
    PROCEDURE UpdateGraphOnAfterDelete(VAR EntityRecordRef : RecordRef);
    VAR
      // IntegrationRecordArchive : Record 5152;
      GraphSyncRunner : Codeunit 50906;
    BEGIN
      IF EntityRecordRef.ISTEMPORARY THEN
        EXIT;

      IF ClientTypeManagement.GetCurrentClientType = CLIENTTYPE::Background THEN
        EXIT;

      IF NOT GraphSyncRunner.IsGraphSyncEnabled THEN
        EXIT;

      // IF NOT IntegrationRecordArchive.FindByRecordId(EntityRecordRef.RECORDID) THEN
      //   EXIT;

      // IF CanScheduleSyncTasks THEN
      //   TASKSCHEDULER.CREATETASK(CODEUNIT::"Graph Sync. Runner - OnDelete",0,TRUE,COMPANYNAME,0DT,IntegrationRecordArchive.RECORDID)
      // ELSE
      //   CODEUNIT.RUN(CODEUNIT::"Graph Sync. Runner - OnDelete",IntegrationRecordArchive);
    END;

    //[External]
    PROCEDURE UpdateGraphOnAfterInsert(VAR EntityRecordRef : RecordRef);
    VAR
      GraphDataSetup : Codeunit 50909;
      GraphSyncRunner : Codeunit 50906;
    BEGIN
      IF EntityRecordRef.ISTEMPORARY THEN
        EXIT;

      IF NOT GraphSyncRunner.IsGraphSyncEnabled THEN
        EXIT;

      IF NOT CanSyncOnInsert THEN
        EXIT;

      IF NOT GraphDataSetup.CanSyncRecord(EntityRecordRef) THEN
        EXIT;

      // When a record is inserted, schedule a sync after a short period of time
      RescheduleTask(CODEUNIT::"Graph Subscription Management",CODEUNIT::"Graph Delta Sync 1",0,10000);
    END;

    //[External]
    PROCEDURE UpdateGraphOnAfterModify(VAR EntityRecordRef : RecordRef);
    VAR
      IntegrationRecord : Record 51251;
      GraphSyncRunner : Codeunit 50906;
    BEGIN
      IF EntityRecordRef.ISTEMPORARY THEN
        EXIT;

      IF ClientTypeManagement.GetCurrentClientType = CLIENTTYPE::Background THEN
        EXIT;

      IF NOT GraphSyncRunner.IsGraphSyncEnabled THEN
        EXIT;

      IF NOT IntegrationRecord.FindByRecordId(EntityRecordRef.RECORDID) THEN
        EXIT;

      RescheduleTask(CODEUNIT::"Graph Sync. Runner - OnModify",0,IntegrationRecord.RECORDID,10000);
      IF NOT CanScheduleSyncTasks THEN
        CODEUNIT.RUN(CODEUNIT::"Graph Sync. Runner - OnModify",IntegrationRecord);
    END;

    LOCAL PROCEDURE CanRefreshSubscriptions() : Boolean;
    VAR
      ScheduledTask : Record 2000000175;
    BEGIN
      IF CURRENTCLIENTTYPE = CLIENTTYPE::Background THEN
        EXIT(FALSE);

      // Always allow this for UI sessions
      IF CURRENTCLIENTTYPE IN [CLIENTTYPE::Phone,CLIENTTYPE::Tablet,CLIENTTYPE::Web,CLIENTTYPE::Windows] THEN
        EXIT(TRUE);

      ScheduledTask.SETRANGE(Company,COMPANYNAME);
      ScheduledTask.SETRANGE("Run Codeunit",CODEUNIT::"Graph Subscription Management");

      // In other cases (web services), we need to apply a threshold
      // The maximum number of refresh tasks is around 20. If we are
      // already at that number, do not schedule more delta syncs.
      EXIT(ScheduledTask.COUNT < 20);
    END;

    LOCAL PROCEDURE CanScheduleSyncTasks() AllowBackgroundSessions : Boolean;
    BEGIN
      IF TASKSCHEDULER.CANCREATETASK THEN BEGIN
        AllowBackgroundSessions := TRUE;
        OnBeforeRunGraphSyncBackgroundSession(AllowBackgroundSessions);
      END;
    END;

    LOCAL PROCEDURE CanSyncOnInsert() CanSync : Boolean;
    BEGIN
      CanSync := NOT GUIALLOWED;
      OnCanSyncOnInsert(CanSync);
    END;

    LOCAL PROCEDURE CheckGraphSubscriptions(VAR SyncMode : Option);
    VAR
      GraphConnectionSetup : Codeunit 5456;
      FirstTimeSync : Boolean;
    BEGIN
      GraphConnectionSetup.RegisterConnections;
      OnBeforeAddOrUpdateGraphSubscriptions(FirstTimeSync);
      IF FirstTimeSync THEN
        SyncMode := SyncModeOption::Full
      ELSE
        SyncMode := SyncModeOption::Delta;
    END;

    // LOCAL PROCEDURE CreateNewGraphSubscription(VAR GraphSubscription : Record 5455;VAR WebhookSubscription : Record 2000000199;EntityEndpoint : Text[250]);
    // BEGIN
    //   IF GraphSubscription.CreateGraphSubscription(GraphSubscription,EntityEndpoint) THEN
    //     IF WebhookSubscription.DELETE THEN
    //       IF GraphSubscription.CreateWebhookSubscription(WebhookSubscription) THEN
    //         COMMIT;
    // END;

    // LOCAL PROCEDURE CreateNewWebhookSubscription(VAR GraphSubscription : Record 5455;VAR WebhookSubscription : Record 2000000199;EntityEndpoint : Text[250]);
    // BEGIN
    //   IF GraphSubscription.CreateGraphSubscription(GraphSubscription,EntityEndpoint) THEN
    //     IF GraphSubscription.CreateWebhookSubscription(WebhookSubscription) THEN
    //       COMMIT;
    // END;

    LOCAL PROCEDURE RescheduleTask(CodeunitID : Integer;FailureCodeunitID : Integer;RecordID : Variant;DelayMillis : Integer);
    VAR
      ScheduledTask : Record 2000000175;
      NextTask : DateTime;
    BEGIN
      NextTask := CURRENTDATETIME + DelayMillis;

      ScheduledTask.SETRANGE(Company,COMPANYNAME);
      ScheduledTask.SETRANGE("Run Codeunit",CodeunitID);
      ScheduledTask.SETFILTER("Not Before",'<%1',NextTask);

      IF RecordID.ISRECORDID THEN
        ScheduledTask.SETRANGE(Record,RecordID);

      IF ScheduledTask.FINDFIRST THEN
        TASKSCHEDULER.CANCELTASK(ScheduledTask.ID);

      OnScheduleSyncTask(CodeunitID,FailureCodeunitID,NextTask,RecordID);
    END;

    LOCAL PROCEDURE ScheduleFutureSubscriptionRefreshes();
    VAR
      ScheduledTask : Record 2000000175;
      DistanceIntoFuture : BigInteger;
      MaximumFutureRefresh : BigInteger;
      MillisecondsPerDay : BigInteger;
      RefreshFrequency : Decimal;
      MaximumDaysIntoFuture : Integer;
      MaximumNumberOfTasks : Integer;
      TasksToCreate : Integer;
      i : Integer;
      BufferTime : Integer;
      LastTaskNotBefore : DateTime;
      TasksCreated : Integer;
    BEGIN
      // Refreshes the graph webhook subscriptions every period of (webhook max expiry) / 2
      // up to 30 days in the future. This is so that users who do not frequently sign in to
      // the system but may use it through APIs or other means do not get stale data as easily.

      BufferTime := 15000;
      MaximumDaysIntoFuture := 30;
      MillisecondsPerDay := 86400000;
      RefreshFrequency := GetMaximumExpirationDateTimeOffset / 2;
      MaximumFutureRefresh := MaximumDaysIntoFuture * MillisecondsPerDay;
      MaximumNumberOfTasks := ROUND(MaximumFutureRefresh / RefreshFrequency,1,'=');

      ScheduledTask.SETRANGE(Company,COMPANYNAME);
      ScheduledTask.SETRANGE("Run Codeunit",CODEUNIT::"Graph Subscription Management");
      TasksToCreate := MaximumNumberOfTasks - ScheduledTask.COUNT;
      FOR i := MaximumNumberOfTasks DOWNTO MaximumNumberOfTasks - TasksToCreate + 1 DO BEGIN
        DistanceIntoFuture := i * RefreshFrequency + BufferTime;
        OnScheduleSyncTask(
          CODEUNIT::"Graph Subscription Management",CODEUNIT::"Graph Delta Sync 1",CURRENTDATETIME + DistanceIntoFuture,0);
        TasksCreated += 1;
      END;

      // Make sure we always have a task scheduled at the end of the period
      LastTaskNotBefore := CREATEDATETIME(TODAY + MaximumDaysIntoFuture,0T) - RefreshFrequency;
      ScheduledTask.SETFILTER("Not Before",'>%1',LastTaskNotBefore);
      IF ScheduledTask.ISEMPTY THEN BEGIN
        DistanceIntoFuture := MaximumNumberOfTasks * RefreshFrequency;
        OnScheduleSyncTask(
          CODEUNIT::"Graph Subscription Management",CODEUNIT::"Graph Delta Sync 1",CURRENTDATETIME + DistanceIntoFuture,0);
        TasksCreated += 1;
      END;

      // Schedule one to happen immediately so that a delta sync will be triggered by the call
      OnScheduleSyncTask(CODEUNIT::"Graph Subscription Management",CODEUNIT::"Graph Delta Sync 1",CURRENTDATETIME + BufferTime,0);
      TasksCreated += 1;

      TasksToCreate := TasksCreated;
      //SENDTRACETAG('0000170',TraceCategory,VERBOSITY::Normal,STRSUBSTNO(SubscriptionRefreshTasksTxt,TasksToCreate),DATACLASSIFICATION::SystemMetadata);
        Session.LogMessage('0000170',SubscriptionRefreshTasksTxt,VERBOSITY::Normal,DATACLASSIFICATION::SystemMetadata,TelemetryScope::ExtensionPublisher, 'Category', SubscriptionRefreshTasksTxt);
    END;

    // [EventSubscriber(ObjectType::Codeunit, 40, OnAfterCompanyOpen, '', true, true)]
    LOCAL PROCEDURE AddOrUpdateGraphSubscriptionOnAfterCompanyOpen();
    VAR
      GraphSyncRunner : Codeunit 50906;
      WebhookManagement : Codeunit 5377;
    BEGIN
      IF GETDEFAULTTABLECONNECTION(TABLECONNECTIONTYPE::MicrosoftGraph) <> '' THEN
        EXIT;

      IF NOT WebhookManagement.IsCurrentClientTypeAllowed THEN
        EXIT;

      IF NOT WebhookManagement.IsSyncAllowed THEN
        EXIT;

      IF NOT GraphSyncRunner.IsGraphSyncEnabled THEN
        EXIT;

      IF CanRefreshSubscriptions THEN
        ScheduleFutureSubscriptionRefreshes;
    END;

    [EventSubscriber(ObjectType::Codeunit, 50904, OnScheduleSyncTask, '', true, true)]
    LOCAL PROCEDURE InvokeTaskSchedulerOnScheduleSyncTask(CodeunitID : Integer;FailureCodeunitID : Integer;NotBefore : DateTime;RecordID : Variant);
    BEGIN
      IF CanScheduleSyncTasks THEN BEGIN
        IF RecordID.ISRECORDID THEN
          TASKSCHEDULER.CREATETASK(CodeunitID,FailureCodeunitID,TRUE,COMPANYNAME,NotBefore,RecordID)
        ELSE
          TASKSCHEDULER.CREATETASK(CodeunitID,FailureCodeunitID,TRUE,COMPANYNAME,NotBefore);
      END;
    END;

    [EventSubscriber(ObjectType::Table, 2000000194, OnAfterInsertEvent, '', true, true)]
    LOCAL PROCEDURE SyncToNavOnWebhookNotificationInsert(VAR Rec : Record 2000000194;RunTrigger : Boolean);
    VAR
      GraphSyncRunner : Codeunit 50906;
    BEGIN
      IF NOT GraphSyncRunner.IsGraphSyncEnabled THEN
        EXIT;

      IF CanScheduleSyncTasks THEN
        TASKSCHEDULER.CREATETASK(CODEUNIT::"Graph Webhook Sync To NAV 1",0,TRUE,COMPANYNAME,0DT,Rec.RECORDID)
      ELSE
        CODEUNIT.RUN(CODEUNIT::"Graph Webhook Sync To NAV 1",Rec);
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeAddOrUpdateGraphSubscriptions(VAR FirstTimeSync : Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeRunGraphSyncBackgroundSession(VAR AllowBackgroundSessions : Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnCanSyncOnInsert(VAR CanSync : Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnGetSourceRecordRef(VAR GraphRecordRef : RecordRef;WebhookNotification : Record 2000000194;IntegrationTableID : Integer;VAR Retrieved : Boolean);
    BEGIN
    END;

    [IntegrationEvent(false,false)]
    LOCAL PROCEDURE OnScheduleSyncTask(CodeunitID : Integer;FailureCodeunitID : Integer;NotBefore : DateTime;RecordID : Variant);
    BEGIN
    END;

    /* /*BEGIN
END.*/
}







