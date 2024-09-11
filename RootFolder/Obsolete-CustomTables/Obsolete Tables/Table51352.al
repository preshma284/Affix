table 51352 "Graph Integration Record1"
{


    CaptionML = ENU = 'Graph Integration Record', ESP = 'Registro de integraci�n de Graph';

    fields
    {
        field(2; "Graph ID"; Text[250])
        {
            CaptionML = ENU = 'Graph ID', ESP = 'Id. de Graph';


        }
        field(3; "Integration ID"; GUID)
        {
            TableRelation = "Integration Record 1"."Integration ID";
            CaptionML = ENU = 'Integration ID', ESP = 'Id. de integraci�n';


        }
        field(4; "Last Synch. Modified On"; DateTime)
        {
            CaptionML = ENU = 'Last Synch. Modified On', ESP = 'Fecha de �ltima modificaci�n de sincronizaci�n';


        }
        field(5; "Last Synch. Graph Modified On"; DateTime)
        {
            CaptionML = ENU = 'Last Synch. Graph Modified On', ESP = 'Fecha de �ltima modificaci�n de Graph de sincronizaci�n';


        }
        field(6; "Table ID"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Integration Record 1"."Table ID" WHERE("Integration ID" = FIELD("Integration ID")));
            CaptionML = ENU = 'Table ID', ESP = 'Id. de tabla';


        }
        field(7; "ChangeKey"; Text[250])
        {
            CaptionML = ENU = 'ChangeKey', ESP = 'ChangeKey';


        }
        field(8; "XRMId"; GUID)
        {
            CaptionML = ENU = 'XRMId', ESP = 'XRMId';
            ;


        }
    }
    keys
    {
        key(key1; "Graph ID", "Integration ID")
        {
            Clustered = true;
        }
        key(key2; "Integration ID")
        {
            ;
        }
        key(key3; "Last Synch. Modified On", "Integration ID")
        {
            ;
        }
    }
    fieldgroups
    {
    }

    var
        //       IntegrationRecordNotFoundErr@1000 :
        IntegrationRecordNotFoundErr:
// "%1 = record id"
TextConst ENU = 'The integration record for entity %1 was not found.', ESP = 'No se encontr� el registro de integraci�n de la entidad %1.';
        //       GraphIdAlreadyMappedErr@1003 :
        GraphIdAlreadyMappedErr:
// %1 ID of the record, %2 ID of the already mapped record
TextConst ENU = 'Cannot couple %1 to this Microsoft Graph record, because the Microsoft Graph record is already coupled to %2.', ESP = 'No se puede emparejar %1 con este registro de Microsoft Graph porque este �ltimo ya est� emparejado con %2.';
        //       RecordIdAlreadyMappedErr@1004 :
        RecordIdAlreadyMappedErr:
// %1 ID from the record, %2 ID of the already mapped record
TextConst ENU = 'Cannot couple the Microsoft Graph record to %1, because %1 is already coupled to another Microsoft Graph record.', ESP = 'No se puede emparejar el registro de Microsoft Graph con %1 porque %1 ya est� emparejado con el registro de Microsoft Graph.';


    //     procedure IsRecordCoupled (DestinationRecordID@1001 :
    procedure IsRecordCoupled(DestinationRecordID: RecordID): Boolean;
    var
        //       GraphID@1002 :
        GraphID: Text[250];
    begin
        exit(FindIDFromRecordID(DestinationRecordID, GraphID));
    end;


    //     procedure FindRecordIDFromID (SourceGraphID@1001 : Text[250];DestinationTableID@1004 : Integer;var DestinationRecordId@1002 :
    procedure FindRecordIDFromID(SourceGraphID: Text[250]; DestinationTableID: Integer; var DestinationRecordId: RecordID): Boolean;
    var
        //       GraphIntegrationRecord@1003 :
        GraphIntegrationRecord: Record 51352;
        //       IntegrationRecord@1005 :
        IntegrationRecord: Record "Integration Record 1";
    begin
        if FindRowFromGraphID(SourceGraphID, DestinationTableID, GraphIntegrationRecord) then
            if IntegrationRecord.FindByIntegrationId(GraphIntegrationRecord."Integration ID") then begin
                DestinationRecordId := IntegrationRecord."Record ID";
                exit(TRUE);
            end;

        exit(FALSE);
    end;


    //     procedure FindIDFromRecordID (SourceRecordID@1001 : RecordID;var DestinationGraphID@1002 :
    procedure FindIDFromRecordID(SourceRecordID: RecordID; var DestinationGraphID: Text[250]): Boolean;
    var
        //       GraphIntegrationRecord@1004 :
        GraphIntegrationRecord: Record 51352;
    begin
        if not FindRowFromRecordID(SourceRecordID, GraphIntegrationRecord) then
            exit(FALSE);

        DestinationGraphID := GraphIntegrationRecord."Graph ID";
        exit(TRUE);
    end;

    //     LOCAL procedure FindIntegrationIDFromGraphID (SourceGraphID@1002 : Text[250];DestinationTableID@1004 : Integer;var DestinationIntegrationID@1001 :
    LOCAL procedure FindIntegrationIDFromGraphID(SourceGraphID: Text[250]; DestinationTableID: Integer; var DestinationIntegrationID: GUID): Boolean;
    var
        //       GraphIntegrationRecord@1000 :
        GraphIntegrationRecord: Record 51352;
    begin
        if FindRowFromGraphID(SourceGraphID, DestinationTableID, GraphIntegrationRecord) then begin
            DestinationIntegrationID := GraphIntegrationRecord."Integration ID";
            exit(TRUE);
        end;

        exit(FALSE);
    end;


    //     procedure CoupleGraphIDToRecordID (GraphID@1000 : Text[250];RecordID@1001 :
    procedure CoupleGraphIDToRecordID(GraphID: Text[250]; RecordID: RecordID)
    var
        //       GraphIntegrationRecord@1003 :
        GraphIntegrationRecord: Record 51352;
        //       IntegrationRecord@1004 :
        IntegrationRecord: Record "Integration Record 1";
        //       GraphIntegrationRecord2@1006 :
        GraphIntegrationRecord2: Record 51352;
        //       ErrGraphID@1005 :
        ErrGraphID: Text[250];
    begin
        if not IntegrationRecord.FindByRecordId(RecordID) then
            ERROR(IntegrationRecordNotFoundErr, FORMAT(RecordID, 0, 1));

        // Find coupling between GraphID and TableNo
        if not FindRowFromGraphID(GraphID, RecordID.TABLENO, GraphIntegrationRecord) then
            // Find rogue coupling beteen GraphID and table 0
            if not FindRowFromGraphID(GraphID, 0, GraphIntegrationRecord) then begin
                // Find other coupling to the record
                if GraphIntegrationRecord2.FindIDFromRecordID(RecordID, ErrGraphID) then
                    ERROR(RecordIdAlreadyMappedErr, FORMAT(RecordID, 0, 1));

                InsertGraphIntegrationRecord(GraphID, IntegrationRecord, RecordID);
                exit;
            end;

        // Update Integration ID
        if GraphIntegrationRecord."Integration ID" <> IntegrationRecord."Integration ID" then begin
            if GraphIntegrationRecord2.FindIDFromRecordID(RecordID, ErrGraphID) then
                ERROR(RecordIdAlreadyMappedErr, FORMAT(RecordID, 0, 1));
            GraphIntegrationRecord.RENAME(GraphIntegrationRecord."Graph ID", IntegrationRecord."Integration ID");
        end;
    end;


    //     procedure CoupleRecordIdToGraphID (RecordID@1001 : RecordID;GraphID@1000 :
    procedure CoupleRecordIdToGraphID(RecordID: RecordID; GraphID: Text[250])
    var
        //       GraphIntegrationRecord@1003 :
        GraphIntegrationRecord: Record 51352;
        //       IntegrationRecord@1004 :
        IntegrationRecord: Record "Integration Record 1";
    begin
        if not IntegrationRecord.FindByRecordId(RecordID) then
            ERROR(IntegrationRecordNotFoundErr, FORMAT(RecordID, 0, 1));

        if not FindRowFromIntegrationID(IntegrationRecord."Integration ID", GraphIntegrationRecord) then begin
            AssertRecordIDCanBeCoupled(RecordID, GraphID);
            InsertGraphIntegrationRecord(GraphID, IntegrationRecord, RecordID);
        end else
            if GraphIntegrationRecord."Graph ID" <> GraphID then begin
                AssertRecordIDCanBeCoupled(RecordID, GraphID);
                GraphIntegrationRecord.RENAME(GraphID, GraphIntegrationRecord."Integration ID");
            end;
    end;


    //     procedure RemoveCouplingToRecord (RecordID@1000 :
    procedure RemoveCouplingToRecord(RecordID: RecordID): Boolean;
    var
        //       GraphIntegrationRecord@1002 :
        GraphIntegrationRecord: Record 51352;
        //       IntegrationRecord@1001 :
        IntegrationRecord: Record "Integration Record 1";
    begin
        if not IntegrationRecord.FindByRecordId(RecordID) then
            ERROR(IntegrationRecordNotFoundErr, FORMAT(RecordID, 0, 1));

        if FindRowFromIntegrationID(IntegrationRecord."Integration ID", GraphIntegrationRecord) then begin
            GraphIntegrationRecord.DELETE(TRUE);
            exit(TRUE);
        end;
    end;


    //     procedure RemoveCouplingToGraphID (GraphID@1000 : Text[250];DestinationTableID@1003 :
    procedure RemoveCouplingToGraphID(GraphID: Text[250]; DestinationTableID: Integer): Boolean;
    var
        //       GraphIntegrationRecord@1002 :
        GraphIntegrationRecord: Record 51352;
    begin
        if FindRowFromGraphID(GraphID, DestinationTableID, GraphIntegrationRecord) then begin
            GraphIntegrationRecord.DELETE(TRUE);
            exit(TRUE);
        end;
    end;


    //     procedure AssertRecordIDCanBeCoupled (RecordID@1001 : RecordID;GraphID@1000 :
    procedure AssertRecordIDCanBeCoupled(RecordID: RecordID; GraphID: Text[250])
    var
        //       GraphIntegrationRecord@1003 :
        GraphIntegrationRecord: Record 51352;
        //       ErrRecordID@1004 :
        ErrRecordID: RecordID;
        //       ErrIntegrationID@1005 :
        ErrIntegrationID: GUID;
    begin
        if FindIntegrationIDFromGraphID(GraphID, RecordID.TABLENO, ErrIntegrationID) then
            if not UncoupleGraphIDIfRecordDeleted(ErrIntegrationID) then begin
                GraphIntegrationRecord.FindRecordIDFromID(GraphID, RecordID.TABLENO, ErrRecordID);
                ERROR(GraphIdAlreadyMappedErr, FORMAT(RecordID, 0, 1), ErrRecordID);
            end;
    end;


    //     procedure SetLastSynchModifiedOns (SourceGraphID@1001 : Text[250];DestinationTableID@1005 : Integer;GraphLastModifiedOn@1000 : DateTime;LastModifiedOn@1003 :
    procedure SetLastSynchModifiedOns(SourceGraphID: Text[250]; DestinationTableID: Integer; GraphLastModifiedOn: DateTime; LastModifiedOn: DateTime)
    var
        //       GraphIntegrationRecord@1004 :
        GraphIntegrationRecord: Record 51352;
    begin
        if not FindRowFromGraphID(SourceGraphID, DestinationTableID, GraphIntegrationRecord) then
            exit;

        WITH GraphIntegrationRecord DO begin
            "Last Synch. Graph Modified On" := GraphLastModifiedOn;
            "Last Synch. Modified On" := LastModifiedOn;
            MODIFY(TRUE);
            COMMIT;
        end;
    end;


    //     procedure SetLastSynchGraphModifiedOn (GraphID@1001 : Text[250];DestinationTableID@1003 : Integer;GraphLastModifiedOn@1000 :
    procedure SetLastSynchGraphModifiedOn(GraphID: Text[250]; DestinationTableID: Integer; GraphLastModifiedOn: DateTime)
    var
        //       GraphIntegrationRecord@1004 :
        GraphIntegrationRecord: Record 51352;
    begin
        if not FindRowFromGraphID(GraphID, DestinationTableID, GraphIntegrationRecord) then
            exit;

        GraphIntegrationRecord."Last Synch. Graph Modified On" := GraphLastModifiedOn;
        GraphIntegrationRecord.MODIFY(TRUE);
        COMMIT;
    end;


    //     procedure IsModifiedAfterLastSynchonizedGraphRecord (GraphID@1000 : Text[250];DestinationTableID@1004 : Integer;CurrentModifiedOn@1002 :
    procedure IsModifiedAfterLastSynchonizedGraphRecord(GraphID: Text[250]; DestinationTableID: Integer; CurrentModifiedOn: DateTime): Boolean;
    var
        //       GraphIntegrationRecord@1003 :
        GraphIntegrationRecord: Record 51352;
        //       IntegrationTableMapping@1001 :
        IntegrationTableMapping: Record 5335;
        //       GraphDataSetup@1005 :
        GraphDataSetup: Codeunit 50909;
        //       TypeHelper@1007 :
        TypeHelper: Codeunit 10;
        //       GraphRecordRef@1006 :
        GraphRecordRef: RecordRef;
        //       GraphChangeKey@1009 :
        GraphChangeKey: Text[250];
    begin
        if not FindRowFromGraphID(GraphID, DestinationTableID, GraphIntegrationRecord) then
            exit(FALSE);

        GraphIntegrationRecord.CALCFIELDS("Table ID");
        IntegrationTableMapping.FindMappingForTable(GraphIntegrationRecord."Table ID");
        if IntegrationTableMapping."Int. Tbl. ChangeKey Fld. No." <> 0 then
            if GraphDataSetup.GetGraphRecord(GraphRecordRef, GraphID, GraphIntegrationRecord."Table ID") then begin
                GraphChangeKey := GraphRecordRef.FIELD(IntegrationTableMapping."Int. Tbl. ChangeKey Fld. No.").VALUE;
                exit(GraphChangeKey <> GraphIntegrationRecord.ChangeKey);
            end;

        exit(TypeHelper.CompareDateTime(CurrentModifiedOn, GraphIntegrationRecord."Last Synch. Graph Modified On") > 0);
    end;


    //     procedure IsModifiedAfterLastSynchronizedRecord (RecordID@1001 : RecordID;CurrentModifiedOn@1000 :
    procedure IsModifiedAfterLastSynchronizedRecord(RecordID: RecordID; CurrentModifiedOn: DateTime): Boolean;
    var
        //       GraphIntegrationRecord@1003 :
        GraphIntegrationRecord: Record 51352;
        //       TypeHelper@1002 :
        TypeHelper: Codeunit 10;
    begin
        if not FindRowFromRecordID(RecordID, GraphIntegrationRecord) then
            exit(FALSE);

        exit(TypeHelper.CompareDateTime(CurrentModifiedOn, GraphIntegrationRecord."Last Synch. Modified On") > 0);
    end;

    //     LOCAL procedure UncoupleGraphIDIfRecordDeleted (IntegrationID@1001 :
    LOCAL procedure UncoupleGraphIDIfRecordDeleted(IntegrationID: GUID): Boolean;
    var
        //       IntegrationRecord@1000 :
        IntegrationRecord: Record "Integration Record 1";
        //       GraphIntegrationRecord@1003 :
        GraphIntegrationRecord: Record 51352;
    begin
        IntegrationRecord.FindByIntegrationId(IntegrationID);
        if IntegrationRecord."Deleted On" <> 0DT then begin
            if FindRowFromIntegrationID(IntegrationID, GraphIntegrationRecord) then
                GraphIntegrationRecord.DELETE;
            exit(TRUE);
        end;

        exit(FALSE);
    end;


    //     procedure DeleteIfRecordDeleted (GraphID@1001 : Text[250];DestinationTableID@1002 :
    procedure DeleteIfRecordDeleted(GraphID: Text[250]; DestinationTableID: Integer): Boolean;
    var
        //       IntegrationID@1004 :
        IntegrationID: GUID;
    begin
        if not FindIntegrationIDFromGraphID(GraphID, DestinationTableID, IntegrationID) then
            exit(FALSE);

        exit(UncoupleGraphIDIfRecordDeleted(IntegrationID));
    end;

    //     LOCAL procedure FindRowFromRecordID (SourceRecordID@1000 : RecordID;var GraphIntegrationRecord@1001 :
    LOCAL procedure FindRowFromRecordID(SourceRecordID: RecordID; var GraphIntegrationRecord: Record 51352): Boolean;
    var
        //       IntegrationRecord@1002 :
        IntegrationRecord: Record "Integration Record 1";
    begin
        if not IntegrationRecord.FindByRecordId(SourceRecordID) then
            exit(FALSE);
        exit(FindRowFromIntegrationID(IntegrationRecord."Integration ID", GraphIntegrationRecord));
    end;

    //     LOCAL procedure FindRowFromGraphID (GraphID@1001 : Text[250];DestinationTableID@1003 : Integer;var GraphIntegrationRecord@1000 :
    LOCAL procedure FindRowFromGraphID(GraphID: Text[250]; DestinationTableID: Integer; var GraphIntegrationRecord: Record 51352): Boolean;
    begin
        GraphIntegrationRecord.SETRANGE("Graph ID", GraphID);
        GraphIntegrationRecord.SETFILTER("Table ID", FORMAT(DestinationTableID));
        exit(GraphIntegrationRecord.FINDFIRST);
    end;

    //     LOCAL procedure FindRowFromIntegrationID (IntegrationID@1001 : GUID;var GraphIntegrationRecord@1000 :
    LOCAL procedure FindRowFromIntegrationID(IntegrationID: GUID; var GraphIntegrationRecord: Record 51352): Boolean;
    begin
        GraphIntegrationRecord.SETCURRENTKEY("Integration ID");
        GraphIntegrationRecord.SETFILTER("Integration ID", IntegrationID);
        exit(GraphIntegrationRecord.FINDFIRST);
    end;

    //     LOCAL procedure InsertGraphIntegrationRecord (GraphID@1002 : Text[250];var IntegrationRecord@1001 : Record 5151;RecordID@1000 :
    LOCAL procedure InsertGraphIntegrationRecord(GraphID: Text[250]; var IntegrationRecord: Record "Integration Record 1"; RecordID: RecordID)
    var
        //       GraphIntegrationRecord@1005 :
        GraphIntegrationRecord: Record 51352;
    //       GraphIntContact@1006 :
    // GraphIntContact: Codeunit 5461;
    begin
        GraphIntegrationRecord."Graph ID" := GraphID;
        GraphIntegrationRecord."Integration ID" := IntegrationRecord."Integration ID";
        GraphIntegrationRecord."Table ID" := RecordID.TABLENO;
        // GraphIntContact.SetXRMId(GraphIntegrationRecord);

        GraphIntegrationRecord.INSERT(TRUE);
    end;

    /*begin
    end.
  */
}



