Codeunit 50917 "Graph Mgt - General Tools 1"
{


    Permissions = TableData 112 = rimd,
                TableData 114 = rimd,
                TableData 122 = rimd;
    trigger OnRun()
    BEGIN
        ApiSetup;
    END;

    VAR
        CannotChangeIDErr: TextConst ENU = 'Value of Id is immutable.', ESP = 'Value of Id is immutable.';
        CannotChangeLastDateTimeModifiedErr: TextConst ENU = 'Value of LastDateTimeModified is immutable.', ESP = 'Value of LastDateTimeModified is immutable.';
        MissingFieldValueErr: TextConst ENU = '%1 must be specified.', ESP = '%1 must be specified.';
        AggregateErrorTxt: TextConst ENU = 'AL APIAggregate', ESP = 'AL APIAggregate';
        AggregateIsMissingMainRecordTxt: TextConst ENU = 'Aggregate does not have main record.', ESP = 'Aggregate does not have main record.';


    //[External]
    PROCEDURE UpdateIntegrationRecords(VAR SourceRecordRef: RecordRef; FieldNumber: Integer; OnlyRecordsWithoutID: Boolean);
    VAR
        IntegrationRecord: Record 51251;
        UpdatedIntegrationRecord: Record 51251;
        IntegrationManagement: Codeunit 50845;
        FilterFieldRef: FieldRef;
        IDFieldRef: FieldRef;
        NullGuid: GUID;
    BEGIN
        IF OnlyRecordsWithoutID THEN BEGIN
            FilterFieldRef := SourceRecordRef.FIELD(FieldNumber);
            FilterFieldRef.SETRANGE(NullGuid);
        END;

        IF SourceRecordRef.FINDSET THEN
            REPEAT
                IDFieldRef := SourceRecordRef.FIELD(FieldNumber);
                IF NOT IntegrationRecord.GET(IDFieldRef.VALUE) THEN BEGIN
                    IntegrationManagement.InsertUpdateIntegrationRecord(SourceRecordRef, CURRENTDATETIME);
                    IF ISNULLGUID(FORMAT(IDFieldRef.VALUE)) THEN BEGIN
                        UpdatedIntegrationRecord.SETRANGE("Record ID", SourceRecordRef.RECORDID);
                        UpdatedIntegrationRecord.FINDFIRST;
                        IDFieldRef.VALUE := IntegrationManagement.GetIdWithoutBrackets(UpdatedIntegrationRecord."Integration ID");
                    END;

                    SourceRecordRef.MODIFY(FALSE);
                END;
            UNTIL SourceRecordRef.NEXT = 0;
    END;



    //[External]
    PROCEDURE HandleGetPredefinedIdValue(VAR Id: GUID; VAR RecRef: RecordRef; VAR Handled: Boolean; DatabaseNumber: Integer; RecordFieldNumber: Integer);
    VAR
        IntegrationRecord: Record 51251;
        IdFieldRef: FieldRef;
        FieldValue: GUID;
    BEGIN
        IF Handled THEN
            EXIT;

        IF RecRef.NUMBER <> DatabaseNumber THEN
            EXIT;

        IdFieldRef := RecRef.FIELD(RecordFieldNumber);
        FieldValue := FORMAT(IdFieldRef.VALUE);

        IF ISNULLGUID(FieldValue) THEN
            EXIT;

        EVALUATE(Id, FieldValue);
        IF IntegrationRecord.GET(Id) THEN BEGIN
            CLEAR(Id);
            EXIT;
        END;

        Handled := TRUE;
    END;

    PROCEDURE InsertOrUpdateODataType(NewKey: Code[50]; NewDescription: Text[250]; OdmDefinition: Text);
    VAR
        ODataEdmType: Record 2000000179;
        ODataOutStream: OutStream;
        RecordExist: Boolean;
    BEGIN
        IF NOT ODataEdmType.WRITEPERMISSION THEN
            EXIT;

        RecordExist := ODataEdmType.GET(NewKey);

        IF NOT RecordExist THEN BEGIN
            CLEAR(ODataEdmType);
            ODataEdmType.Key := NewKey;
        END;

        ODataEdmType.VALIDATE(Description, NewDescription);
        ODataEdmType."Edm Xml".CREATEOUTSTREAM(ODataOutStream, TEXTENCODING::UTF8);
        ODataOutStream.WRITETEXT(OdmDefinition);

        IF RecordExist THEN
            ODataEdmType.MODIFY(TRUE)
        ELSE
            ODataEdmType.INSERT(TRUE);
    END;

    //[Internal]
    PROCEDURE ProcessNewRecordFromAPI(VAR InsertedRecordRef: RecordRef; VAR TempFieldSet: Record 2000000041; ModifiedDateTime: DateTime);
    VAR
        IntegrationManagement: Codeunit 50845;
        ConfigTemplateManagement: Codeunit 8612;
        UpdatedRecRef: RecordRef;
    BEGIN
        // IF ConfigTemplateManagement.ApplyTemplate(InsertedRecordRef,TempFieldSet,UpdatedRecRef) THEN
        //   InsertedRecordRef := UpdatedRecRef.DUPLICATE;

        IntegrationManagement.InsertUpdateIntegrationRecord(InsertedRecordRef, ModifiedDateTime);
    END;

    //[IntegrationEvent]
    PROCEDURE ApiSetup();
    BEGIN
    END;

    //[External]
    PROCEDURE IsApiEnabled(): Boolean;
    VAR
        ServerConfigSettingHandler: Codeunit 6723;
        Handled: Boolean;
        IsAPIEnabled: Boolean;
    BEGIN
        OnGetIsAPIEnabled(Handled, IsAPIEnabled);
        IF Handled THEN
            EXIT(IsAPIEnabled);

        EXIT(ServerConfigSettingHandler.GetApiServicesEnabled);
    END;


    [EventSubscriber(ObjectType::Codeunit, 50845, OnGetIntegrationActivated, '', true, true)]
    LOCAL PROCEDURE OnGetIntegrationActivated(VAR IsSyncEnabled: Boolean);
    VAR
        ApiWebService: Record 2000000193;
        ODataEdmType: Record 2000000179;
        ForceIsApiEnabledVerification: Boolean;
    BEGIN
        OnForceIsApiEnabledVerification(ForceIsApiEnabledVerification);

        IF NOT ForceIsApiEnabledVerification AND IsSyncEnabled THEN
            EXIT;

        IF ForceIsApiEnabledVerification THEN
            IF NOT IsApiEnabled THEN
                EXIT;

        IF NOT ApiWebService.READPERMISSION THEN
            EXIT;

        ApiWebService.SETRANGE("Object Type", ApiWebService."Object Type"::Page);
        ApiWebService.SETRANGE(Published, TRUE);
        IF ApiWebService.ISEMPTY THEN
            EXIT;
        IF NOT ODataEdmType.READPERMISSION THEN
            EXIT;

        IsSyncEnabled := NOT ODataEdmType.ISEMPTY;
    END;



    [EventSubscriber(ObjectType::Codeunit, 2, OnCompanyInitialize, '', true, true)]
    LOCAL PROCEDURE InitDemoCompanyApisForSaaS();
    VAR
        CompanyInformation: Record 79;
        APIEntitiesSetup: Record 5466;
        PermissionManager: Codeunit 9002;
        PermissionManager1: Codeunit 51256;
        GraphMgtGeneralTools: Codeunit 5465;
    BEGIN
        IF NOT PermissionManager1.SoftwareAsAService THEN
            EXIT;

        IF NOT CompanyInformation.GET THEN
            EXIT;

        IF NOT CompanyInformation."Demo Company" THEN
            EXIT;

        APIEntitiesSetup.SafeGet;

        IF APIEntitiesSetup."Demo Company API Initialized" THEN
            EXIT;

        GraphMgtGeneralTools.ApiSetup;

        APIEntitiesSetup.SafeGet;
        APIEntitiesSetup.VALIDATE("Demo Company API Initialized", TRUE);
        APIEntitiesSetup.MODIFY(TRUE);
    END;



    //[External]
    PROCEDURE CleanAggregateWithoutParent(MainRecordVariant: Variant);
    VAR
        MainRecordRef: RecordRef;
    BEGIN
        MainRecordRef.GETTABLE(MainRecordVariant);
        MainRecordRef.DELETE;
        //SENDTRACETAG('00001QW',AggregateErrorTxt,VERBOSITY::Error,AggregateIsMissingMainRecordTxt,DATACLASSIFICATION::SystemMetadata);
        Session.LogMessage('00001QW', AggregateIsMissingMainRecordTxt, Verbosity::Error, DataClassification::SystemMetadata, TelemetryScope::ExtensionPublisher, 'Category', AggregateErrorTxt);
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnGetIsAPIEnabled(VAR Handled: Boolean; VAR IsAPIEnabled: Boolean);
    BEGIN
    END;


    //[IntegrationEvent]
    LOCAL PROCEDURE OnForceIsApiEnabledVerification(VAR ForceIsApiEnabledVerification: Boolean);
    BEGIN
    END;

    /* /*BEGIN
END.*/
}







