table 51285 "Outlook Synch. User Setup 1"
{


    CaptionML = ENU = 'Outlook Synch. User Setup', ESP = 'Configuraci�n usuario sinc. Outlook';
    PasteIsValid = false;

    fields
    {
        field(1; "User ID"; Code[50])
        {
            TableRelation = User."User Name";


            ValidateTableRelation = false;
            //TestTableRelation=false;
            DataClassification = EndUserIdentifiableInformation;
            CaptionML = ENU = 'User ID', ESP = 'Id. usuario';
            NotBlank = true;

            trigger OnValidate();
            var
                UserMgt1: Codeunit "User Management 1";
            BEGIN
                UserMgt1.ValidateUserID("User ID");
            END;

            trigger OnLookup();
            var
                UserMgt1: Codeunit "User Management 1";
            BEGIN
                UserMgt1.LookupUserID("User ID");
            END;


        }
        field(2; "Synch. Entity Code"; Code[10])
        {
            TableRelation = "Outlook Synch. Entity 1"."Code";


            CaptionML = ENU = 'Synch. Entity Code', ESP = 'C�digo entidad sinc.';
            NotBlank = true;

            trigger OnValidate();
            BEGIN
                IF "Synch. Entity Code" = xRec."Synch. Entity Code" THEN
                    EXIT;

                OSynchEntity.GET("Synch. Entity Code");
                OSynchEntity.TESTFIELD(Description);
                OSynchEntity.TESTFIELD("Table No.");
                OSynchEntity.TESTFIELD("Outlook Item");

                CALCFIELDS(Description, "No. of Elements");
            END;


        }
        field(3; "Description"; Text[80])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Outlook Synch. Entity 1"."Description" WHERE("Code" = FIELD("Synch. Entity Code")));
            CaptionML = ENU = 'Description', ESP = 'Descripci�n';
            Editable = false;


        }
        field(4; "Condition"; Text[250])
        {
            CaptionML = ENU = 'Condition', ESP = 'Condici�n';
            Editable = false;


        }
        field(5; "Synch. Direction"; Option)
        {
            OptionMembers = "Bidirectional","Microsoft Dynamics NAV to Outlook","Outlook to Microsoft Dynamics NAV";

            CaptionML = ENU = 'Synch. Direction', ESP = 'Direcci�n sinc.';
            OptionCaptionML = ENU = 'Bidirectional,Microsoft Dynamics NAV to Outlook,Outlook to Microsoft Dynamics NAV', ESP = 'Bidireccional,Microsoft Dynamics NAV a Outlook,Outlook a Microsoft Dynamics NAV';


            trigger OnValidate();
            VAR
                //                                                                 OSynchDependency@1000 :
                OSynchDependency: Record "Outlook Synch. Dependency 1";
                //                                                                 RecRef@1002 :
                RecRef: RecordRef;
                //                                                                 FldRef@1001 :
                FldRef: FieldRef;
            BEGIN
                IF "Synch. Direction" = xRec."Synch. Direction" THEN
                    EXIT;

                IF "Synch. Direction" = "Synch. Direction"::Bidirectional THEN
                    EXIT;

                CALCFIELDS("No. of Elements");
                IF "No. of Elements" <> 0 THEN BEGIN
                    OSynchSetupDetail.RESET;
                    OSynchSetupDetail.SETRANGE("User ID", "User ID");
                    OSynchSetupDetail.SETRANGE("Synch. Entity Code", "Synch. Entity Code");
                    IF OSynchSetupDetail.FIND('-') THEN
                        REPEAT
                            OSynchEntityElement.GET(OSynchSetupDetail."Synch. Entity Code", OSynchSetupDetail."Element No.");
                            MODIFY;
                            OSynchEntityElement.CALCFIELDS("No. of Dependencies");
                            IF OSynchEntityElement."No. of Dependencies" > 0 THEN
                                IF NOT OSynchSetupMgt.CheckOCollectionAvailability(OSynchEntityElement, "User ID") THEN
                                    "Synch. Direction" := xRec."Synch. Direction";
                        UNTIL OSynchSetupDetail.NEXT = 0;
                END;

                OSynchDependency.RESET;
                OSynchDependency.SETRANGE("Depend. Synch. Entity Code", "Synch. Entity Code");
                IF OSynchDependency.FIND('-') THEN
                    REPEAT
                        IF OSynchUserSetup.GET("User ID", OSynchDependency."Synch. Entity Code") THEN
                            IF OSynchSetupDetail.GET(
                                 OSynchUserSetup."User ID",
                                 OSynchUserSetup."Synch. Entity Code",
                                 OSynchDependency."Element No.")
                            THEN
                                IF "Synch. Direction" <> OSynchUserSetup."Synch. Direction" THEN BEGIN
                                    CLEAR(RecRef);
                                    CLEAR(FldRef);
                                    RecRef.GETTABLE(Rec);
                                    FldRef := RecRef.FIELD(FIELDNO("Synch. Direction"));
                                    ERROR(
                                      Text001,
                                      FIELDCAPTION("Synch. Direction"),
                                      SELECTSTR(OSynchUserSetup."Synch. Direction"::Bidirectional + 1, FldRef.OPTIONSTRING),
                                      OSynchDependency."Synch. Entity Code");
                                END;
                    UNTIL OSynchDependency.NEXT = 0;
            END;


        }
        field(6; "Last Synch. Time"; DateTime)
        {
            CaptionML = ENU = 'Last Synch. Time', ESP = '�ltima sinc.';


        }
        field(7; "Record GUID"; GUID)
        {
            DataClassification = SystemMetadata;
            CaptionML = ENU = 'Record GUID', ESP = 'GUID registro';
            Editable = false;


        }
        field(8; "No. of Elements"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Outlook Synch. Setup Detail 1" WHERE("User ID" = FIELD("User ID"),
                                                                                                          "Synch. Entity Code" = FIELD("Synch. Entity Code"),
                                                                                                         "Outlook Collection" = FILTER(<> '')));
            CaptionML = ENU = 'No. of Elements', ESP = 'N� elementos';
            Editable = false;


        }
    }
    keys
    {
        key(key1; "User ID", "Synch. Entity Code")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       OSynchEntity@1004 :
        OSynchEntity: Record "Outlook Synch. Entity 1";
        //       OSynchEntityElement@1002 :
        OSynchEntityElement: Record "Outlook Synch. Entity Element1";
        //       OSynchFilter@1000 :
        OSynchFilter: Record "Outlook Synch. Filter 1";
        //       OSynchUserSetup@1005 :
        OSynchUserSetup: Record "Outlook Synch. User Setup 1";
        //       OSynchSetupDetail@1003 :
        OSynchSetupDetail: Record "Outlook Synch. Setup Detail 1";
        //       UserMgt@1001 :
        UserMgt: Codeunit 418;
        //       OSynchSetupMgt@1008 :
        OSynchSetupMgt: Codeunit 50849;
        //       Text001@1007 :
        Text001: TextConst ENU = 'The value of the %1 field must either be %2 or match the synchronization direction of the %3 entity because these entities are dependent.', ESP = 'El valor del campo %1 debe ser %2 o coincidir con la direcci�n de sincronizaci�n del objeto %3 porque estos objetos son dependientes.';
        //       Text002@1009 :
        Text002: TextConst ENU = 'The %1 entity is used for the synchronization of one or more Outlook item collections.\if you delete this entity, all collections will be removed from synchronization. Do you want to proceed?', ESP = 'El objeto %1 se utiliza para la sincronizaci�n de una o m�s colecciones de elementos de Outlook.\Si elimina este objeto, todas las colecciones se eliminar�n de la sincronizaci�n. �Desea continuar?';




    trigger OnInsert();
    begin
        if ISNULLGUID("Record GUID") then
            "Record GUID" := CREATEGUID;
    end;

    trigger OnDelete();
    begin
        if not CheckSetupDetail(Rec) then
            ERROR('');

        OSynchSetupDetail.RESET;
        OSynchSetupDetail.SETRANGE("User ID", "User ID");
        OSynchSetupDetail.SETRANGE("Synch. Entity Code", "Synch. Entity Code");
        OSynchSetupDetail.DELETEALL;

        OSynchFilter.RESET;
        OSynchFilter.SETRANGE("Record GUID", "Record GUID");
        OSynchFilter.DELETEALL;
    end;

    trigger OnRename();
    begin
        if not CheckSetupDetail(xRec) then
            ERROR('');

        if xRec."Synch. Entity Code" = "Synch. Entity Code" then
            exit;

        Condition := '';
        "Synch. Direction" := "Synch. Direction"::Bidirectional;
        "Last Synch. Time" := 0DT;

        OSynchSetupDetail.RESET;
        OSynchSetupDetail.SETRANGE("User ID", "User ID");
        OSynchSetupDetail.SETRANGE("Synch. Entity Code", xRec."Synch. Entity Code");
        OSynchSetupDetail.DELETEALL;

        OSynchFilter.RESET;
        OSynchFilter.SETRANGE("Record GUID", "Record GUID");
        OSynchFilter.DELETEALL;
    end;



    // procedure CheckSetupDetail (OSynchUserSetup1@1002 :
    procedure CheckSetupDetail(OSynchUserSetup1: Record "Outlook Synch. User Setup 1"): Boolean;
    var
        //       OSynchDependency@1003 :
        OSynchDependency: Record "Outlook Synch. Dependency 1";
    begin
        OSynchSetupDetail.RESET;
        OSynchSetupDetail.SETRANGE("User ID", OSynchUserSetup1."User ID");
        if OSynchSetupDetail.FIND('-') then
            repeat
                if OSynchDependency.GET(
                     OSynchSetupDetail."Synch. Entity Code",
                     OSynchSetupDetail."Element No.",
                     OSynchUserSetup1."Synch. Entity Code")
                then
                    OSynchSetupDetail.MARK(TRUE);
            until OSynchSetupDetail.NEXT = 0;

        OSynchSetupDetail.MARKEDONLY(TRUE);
        if OSynchSetupDetail.COUNT > 0 then begin
            if CONFIRM(Text002, FALSE, OSynchUserSetup1."Synch. Entity Code") then begin
                OSynchSetupDetail.DELETEALL;
                exit(TRUE);
            end;
            exit(FALSE);
        end;
        exit(TRUE);
    end;

    /*begin
    end.
  */
}



