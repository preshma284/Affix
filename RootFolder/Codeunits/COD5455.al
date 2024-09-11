Codeunit 50909 "Graph Data Setup 1"
{
  
  
    trigger OnRun()
BEGIN
            OnCreateIntegrationMappings;
          END;

    //[External]
    PROCEDURE AddIntgrationFieldMapping(MappingName : Text[20];NavFieldNo : Integer;IntegrationFieldNo : Integer;ValidateField : Boolean);
    VAR
      IntegrationFieldMapping : Record 5336;
    BEGIN
      WITH IntegrationFieldMapping DO BEGIN
        INIT;
        "Integration Table Mapping Name" := MappingName;
        "Field No." := NavFieldNo;
        "Integration Table Field No." := IntegrationFieldNo;
        Direction := Direction::Bidirectional;
        "Validate Field" := ValidateField;
        INSERT(TRUE);
      END;
    END;

    //[External]
    PROCEDURE AddIntegrationTableMapping(MappingName : Code[20];TableID : Integer;IntTableID : Integer;IntTableUIDFldNo : Integer;IntTableModFldNo : Integer;ParentName : Text[20];IntTableDeltaTokenFldNo : Integer;IntTableChangeKeyFldNo : Integer;IntTableStateFldNo : Integer);
    VAR
      IntegrationTableMapping : Record 5335;
    BEGIN
      WITH IntegrationTableMapping DO BEGIN
        INIT;
        Name := MappingName;
        "Table ID" := TableID;
        "Integration Table ID" := IntTableID;
        "Integration Table UID Fld. No." := IntTableUIDFldNo;
        "Int. Tbl. Modified On Fld. No." := IntTableModFldNo;
        "Synch. Codeunit ID" := CODEUNIT::"Graph Integration Table Sync 1";
        Direction := Direction::Bidirectional;
        "Synch. Only Coupled Records" := FALSE;
        "Parent Name" := ParentName;
        "Int. Tbl. Delta Token Fld. No." := IntTableDeltaTokenFldNo;
        "Int. Tbl. ChangeKey Fld. No." := IntTableChangeKeyFldNo;
        "Int. Tbl. State Fld. No." := IntTableStateFldNo;
        IF NOT INSERT(TRUE) THEN
          MODIFY(TRUE);
      END;
    END;

    //[External]
    PROCEDURE CanSyncRecord(EntityRecRef : RecordRef) CanSync : Boolean;
    VAR
      IntegrationFieldMapping : Record 5336;
      EmptyRecordRef : RecordRef;
      FieldRef : FieldRef;
      EmptyFieldRef : FieldRef;
      MappingName : Code[20];
      Handled : Boolean;
    BEGIN
      // Determines whether the record is empty based on the fields
      // within the integration field mapping table

      OnCheckCanSyncRecord(EntityRecRef,CanSync,Handled);
      IF Handled THEN
        EXIT;

      EmptyRecordRef.OPEN(EntityRecRef.NUMBER);
      EmptyRecordRef.INIT;

      MappingName := GetMappingCodeForTable(EntityRecRef.NUMBER);
      IntegrationFieldMapping.SETRANGE("Integration Table Mapping Name",MappingName);
      IF IntegrationFieldMapping.FINDSET THEN
        REPEAT
          FieldRef := EntityRecRef.FIELD(IntegrationFieldMapping."Field No.");
          EmptyFieldRef := EmptyRecordRef.FIELD(IntegrationFieldMapping."Field No.");
          CanSync := FieldRef.VALUE <> EmptyFieldRef.VALUE;
        UNTIL (IntegrationFieldMapping.NEXT = 0) OR CanSync;
    END;

    //[External]
    PROCEDURE ClearIntegrationMapping(MappingCode : Code[20]);
    VAR
      IntegrationTableMapping : Record 5335;
    BEGIN
      IntegrationTableMapping.SETRANGE(Name,MappingCode);
      IntegrationTableMapping.DELETEALL(TRUE);
    END;

    //[External]
    PROCEDURE CreateIntegrationMapping(MappingCode : Code[20]);
    BEGIN
      IF IntegrationMappingExists(MappingCode) THEN
        ClearIntegrationMapping(MappingCode);
      AddIntegrationMapping(MappingCode);
    END;

    //[External]
    PROCEDURE GetGraphRecord(VAR GraphRecordRef : RecordRef;DestinationGraphID : Text[250];TableID : Integer) Found : Boolean;
    BEGIN
      OnGetGraphRecord(GraphRecordRef,DestinationGraphID,TableID,Found);
    END;

    //[External]
    PROCEDURE GetInboundTableID(MappingCode : Code[20]) TableID : Integer;
    BEGIN
      OnGetInboundTableID(MappingCode,TableID);
    END;

    //[External]
    PROCEDURE GetIntegrationTableMapping(VAR IntegrationTableMapping : Record 5335;MappingCode : Code[20]);
    VAR
      GraphDataSetup : Codeunit 50909;
      IntegrationManagement : Codeunit 50845;
      InsertEnabled : Boolean;
      ModifyEnabled : Boolean;
      DeleteEnabled : Boolean;
      RenameEnabled : Boolean;
    BEGIN
      IF NOT IntegrationTableMapping.GET(MappingCode) THEN BEGIN
        GraphDataSetup.CreateIntegrationMapping(MappingCode);
        IntegrationTableMapping.GET(MappingCode)
      END;

      // This code is needed to make sure the integration for the table is set
      IntegrationManagement.GetDatabaseTableTriggerSetup(
        IntegrationTableMapping."Table ID",InsertEnabled,ModifyEnabled,DeleteEnabled,RenameEnabled);
    END;

    //[External]
    PROCEDURE GetMappingCodeForTable(TableID : Integer) MappingCode : Code[20];
    BEGIN
      OnGetMappingCodeForTable(TableID,MappingCode);
    END;

    //[External]
    PROCEDURE IntegrationMappingExists(MappingCode : Code[20]) : Boolean;
    VAR
      IntegrationTableMapping : Record 5335;
      IntegrationFieldMapping : Record 5336;
    BEGIN
      IF NOT IntegrationTableMapping.GET(MappingCode) THEN
        EXIT(FALSE);

      IntegrationFieldMapping.SETRANGE("Integration Table Mapping Name",MappingCode);
      EXIT(NOT IntegrationFieldMapping.ISEMPTY);
    END;

    LOCAL PROCEDURE AddIntegrationMapping(MappingCode : Code[20]);
    VAR
      TableID : Integer;
    BEGIN
      OnGetInboundTableID(MappingCode,TableID);
      OnAddIntegrationMapping(MappingCode);
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAddIntegrationMapping(MappingCode : Code[20]);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnCheckCanSyncRecord(EntityRecordRef : RecordRef;VAR CanSyncRecord : Boolean;VAR Handled : Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnCreateIntegrationMappings();
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnGetGraphRecord(VAR GraphRecordRef : RecordRef;DestinationGraphID : Text[250];TableID : Integer;VAR Found : Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnGetInboundTableID(MappingCode : Code[20];VAR TableID : Integer);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnGetMappingCodeForTable(TableID : Integer;VAR MappingCode : Code[20]);
    BEGIN
    END;

    /* /*BEGIN
END.*/
}







