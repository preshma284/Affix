Codeunit 50371 "User Management 1"
{


    Permissions = TableData 17 = rm,
                TableData 21 = rm,
                TableData 25 = rm,
                TableData 45 = rm,
                TableData 46 = rm,
                TableData 96 = rm,
                TableData 110 = rm,
                TableData 112 = rm,
                TableData 114 = rm,
                TableData 120 = rm,
                TableData 122 = rm,
                TableData 124 = rm,
                TableData 169 = rm,
                TableData 203 = rm,
                TableData 240 = rm,
                TableData 241 = rm,
                TableData 254 = rm,
                TableData 271 = rm,
                TableData 272 = rm,
                TableData 281 = rm,
                TableData 297 = rm,
                TableData 300 = rm,
                TableData 304 = rm,
                TableData 337 = rm,
                TableData 339 = rm,
                TableData 379 = rm,
                TableData 380 = rm,
                TableData 405 = rm,
                TableData 454 = rm,
                TableData 455 = rm,
                TableData 456 = rm,
                TableData 457 = rm,
                TableData 910 = rm,
                TableData 1104 = rm,
                TableData 1105 = rm,
                TableData 1109 = rm,
                TableData 1111 = rm,
                TableData 5065 = rm,
                TableData 5072 = rm,
                TableData 5601 = rm,
                TableData 5617 = rm,
                TableData 5625 = rm,
                TableData 5629 = rm,
                TableData 5636 = rm,
                TableData 5802 = rm,
                TableData 5907 = rm,
                TableData 5934 = rm,
                TableData 5969 = rm,
                TableData 5970 = rm,
                TableData 5990 = rm,
                TableData 5992 = rm,
                TableData 5994 = rm,
                TableData 6650 = rm,
                TableData 6660 = rm,
                TableData 7134 = rm,
                TableData 7312 = rm,
                TableData 7313 = rm;
    trigger OnRun()
    BEGIN
    END;

    VAR
        Text000: TextConst ENU = 'The user name %1 does not exist.', ESP = 'El nombre de usuario %1 no existe.';
        Text001: TextConst ENU = 'You are renaming an existing user. This will also update all related records. Are you sure that you want to rename the user?', ESP = 'Est� cambiando el nombre de un usuario existente. Esto tambi�n actualizar� todos los registros relacionados. �Est� seguro de que desea cambiar el nombre del usuario?';
        Text002: TextConst ENU = 'The account %1 already exists.', ESP = 'La cuenta %1 ya existe.';
        Text003: TextConst ENU = 'You do not have permissions for this action.', ESP = 'No tiene permisos para esta acci�n.';
        UnsupportedLicenseTypeOnSaasErr: TextConst ENU = 'Only users of type %1 and %2 are supported in the SaaS environment.', ESP = 'Solo se admiten los usuarios del tipo %1 y %2 en el entorno de SaaS.';

    //[External]
    PROCEDURE ValidateUserID(UserName: Code[50]);
    VAR
        User: Record 2000000120;
    BEGIN
        IF UserName <> '' THEN BEGIN
            User.SETCURRENTKEY("User Name");
            User.SETRANGE("User Name", UserName);
            IF NOT User.FINDFIRST THEN BEGIN
                User.RESET;
                IF NOT User.ISEMPTY THEN
                    ERROR(Text000, UserName);
            END;
        END;
    END;

    //[External]
    PROCEDURE LookupUserID(VAR UserName: Code[50]);
    VAR
        SID: GUID;
    BEGIN
        LookupUser(UserName, SID);
    END;

    //[External]
    PROCEDURE LookupUser(VAR UserName: Code[50]; VAR SID: GUID): Boolean;
    VAR
        User: Record 2000000120;
    BEGIN
        User.RESET;
        User.SETCURRENTKEY("User Name");
        User."User Name" := UserName;
        IF User.FIND('=><') THEN;
        IF PAGE.RUNMODAL(PAGE::Users, User) = ACTION::LookupOK THEN BEGIN
            UserName := User."User Name";
            SID := User."User Security ID";
            EXIT(TRUE);
        END;

        EXIT(FALSE);
    END;

    //[External]
    PROCEDURE ValidateUserName(NewUser: Record 2000000120; OldUser: Record 2000000120; WindowsUserName: Text);
    VAR
        User: Record 2000000120;
    BEGIN
        IF NewUser."User Name" <> OldUser."User Name" THEN BEGIN
            User.SETRANGE("User Name", NewUser."User Name");
            User.SETFILTER("User Security ID", '<>%1', OldUser."User Security ID");
            IF User.FINDFIRST THEN
                ERROR(Text002, NewUser."User Name");

            IF NewUser."Windows Security ID" <> '' THEN
                NewUser.TESTFIELD("User Name", WindowsUserName);

            IF OldUser."User Name" <> '' THEN
                IF CONFIRM(Text001, FALSE) THEN
                    RenameUser(OldUser."User Name", NewUser."User Name")
                ELSE
                    ERROR('');
        END;
    END;

    LOCAL PROCEDURE IsPrimaryKeyField(TableID: Integer; FieldID: Integer; VAR NumberOfPrimaryKeyFields: Integer): Boolean;
    VAR
        ConfigValidateMgt: Codeunit 8617;
        RecRef: RecordRef;
        KeyRef: KeyRef;
    BEGIN
        RecRef.OPEN(TableID);
        KeyRef := RecRef.KEYINDEX(1);
        NumberOfPrimaryKeyFields := KeyRef.FIELDCOUNT;
        EXIT(ConfigValidateMgt.IsKeyField(TableID, FieldID));
    END;

    LOCAL PROCEDURE RenameRecord(VAR RecRef: RecordRef; TableNo: Integer; NumberOfPrimaryKeyFields: Integer; UserName: Code[50]; Company: Text[30]);
    VAR
        UserTimeRegister: Record 51;
        PrinterSelection: Record 78;
        SelectedDimension: Record 369;
        OutlookSynchUserSetup: Record 51285;
        FAJournalSetup: Record 5605;
        AnalysisSelectedDimension: Record 7159;
        WarehouseEmployee: Record 7301;
        MyCustomer: Record 9150;
        MyVendor: Record 9151;
        MyItem: Record 9152;
        MyAccount: Record 9153;
        CueSetup: Record 51775;
        ApplicationAreaSetup: Record 9178;
        MyJob: Record 9154;
        MyTimeSheets: Record 9155;
    BEGIN
        IF NumberOfPrimaryKeyFields = 1 THEN
            RecRef.RENAME(UserName)
        ELSE
            CASE TableNo OF
                DATABASE::"User Time Register":
                    BEGIN
                        UserTimeRegister.CHANGECOMPANY(Company);
                        RecRef.SETTABLE(UserTimeRegister);
                        UserTimeRegister.RENAME(UserName, UserTimeRegister.Date);
                    END;
                DATABASE::"Printer Selection":
                    BEGIN
                        RecRef.SETTABLE(PrinterSelection);
                        PrinterSelection.RENAME(UserName, PrinterSelection."Report ID");
                    END;
                DATABASE::"Selected Dimension":
                    BEGIN
                        SelectedDimension.CHANGECOMPANY(Company);
                        RecRef.SETTABLE(SelectedDimension);
                        SelectedDimension.RENAME(UserName, SelectedDimension."Object Type", SelectedDimension."Object ID",
                          SelectedDimension."Analysis View Code", SelectedDimension."Dimension Code");
                    END;
                DATABASE::"Outlook Synch. User Setup 1":
                    BEGIN
                        OutlookSynchUserSetup.CHANGECOMPANY(Company);
                        RecRef.SETTABLE(OutlookSynchUserSetup);
                        OutlookSynchUserSetup.RENAME(UserName, OutlookSynchUserSetup."Synch. Entity Code");
                    END;
                DATABASE::"FA Journal Setup":
                    BEGIN
                        FAJournalSetup.CHANGECOMPANY(Company);
                        RecRef.SETTABLE(FAJournalSetup);
                        FAJournalSetup.RENAME(FAJournalSetup."Depreciation Book Code", UserName);
                    END;
                DATABASE::"Analysis Selected Dimension":
                    BEGIN
                        AnalysisSelectedDimension.CHANGECOMPANY(Company);
                        RecRef.SETTABLE(AnalysisSelectedDimension);
                        AnalysisSelectedDimension.RENAME(UserName, AnalysisSelectedDimension."Object Type", AnalysisSelectedDimension."Object ID",
                          AnalysisSelectedDimension."Analysis Area", AnalysisSelectedDimension."Analysis View Code",
                          AnalysisSelectedDimension."Dimension Code");
                    END;
                DATABASE::"Cue Setup 1":
                    BEGIN
                        CueSetup.CHANGECOMPANY(Company);
                        RecRef.SETTABLE(CueSetup);
                        CueSetup.RENAME(UserName, CueSetup."Table ID", CueSetup."Field No.");
                    END;
                DATABASE::"Warehouse Employee":
                    BEGIN
                        WarehouseEmployee.CHANGECOMPANY(Company);
                        RecRef.SETTABLE(WarehouseEmployee);
                        WarehouseEmployee.RENAME(UserName, WarehouseEmployee."Location Code");
                    END;
                DATABASE::"My Customer":
                    BEGIN
                        MyCustomer.CHANGECOMPANY(Company);
                        RecRef.SETTABLE(MyCustomer);
                        MyCustomer.RENAME(UserName, MyCustomer."Customer No.");
                    END;
                DATABASE::"My Vendor":
                    BEGIN
                        MyVendor.CHANGECOMPANY(Company);
                        RecRef.SETTABLE(MyVendor);
                        MyVendor.RENAME(UserName, MyVendor."Vendor No.");
                    END;
                DATABASE::"My Item":
                    BEGIN
                        MyItem.CHANGECOMPANY(Company);
                        RecRef.SETTABLE(MyItem);
                        MyItem.RENAME(UserName, MyItem."Item No.");
                    END;
                DATABASE::"My Account":
                    BEGIN
                        MyAccount.CHANGECOMPANY(Company);
                        RecRef.SETTABLE(MyAccount);
                        MyAccount.RENAME(UserName, MyAccount."Account No.");
                    END;
                DATABASE::"Application Area Setup":
                    BEGIN
                        ApplicationAreaSetup.CHANGECOMPANY(Company);
                        RecRef.SETTABLE(ApplicationAreaSetup);
                        ApplicationAreaSetup.RENAME('', '', UserName);
                    END;
                DATABASE::"My Job":
                    BEGIN
                        MyJob.CHANGECOMPANY(Company);
                        RecRef.SETTABLE(MyJob);
                        MyJob.RENAME(UserName, MyJob."Job No.");
                    END;
                DATABASE::"My Time Sheets":
                    BEGIN
                        MyTimeSheets.CHANGECOMPANY(Company);
                        RecRef.SETTABLE(MyTimeSheets);
                        MyTimeSheets.RENAME(UserName, MyTimeSheets."Time Sheet No.");
                    END;
            END;
        OnAfterRenameRecord(RecRef, TableNo, NumberOfPrimaryKeyFields, UserName, Company);
    END;

    LOCAL PROCEDURE RenameUser(OldUserName: Code[50]; NewUserName: Code[50]);
    VAR
        User: Record 2000000120;
        Field: Record 2000000041;
        TableInformation: Record 2000000028;
        Company: Record 2000000006;
        RecRef: RecordRef;
        FieldRef: FieldRef;
        FieldRef2: FieldRef;
        NumberOfPrimaryKeyFields: Integer;
    BEGIN
        Field.SETFILTER(ObsoleteState, '<>%1', Field.ObsoleteState::Removed);
        Field.SETRANGE(RelationTableNo, DATABASE::User);
        Field.SETRANGE(RelationFieldNo, User.FIELDNO("User Name"));
        IF Field.FINDSET THEN
            REPEAT
                Company.FINDSET;
                REPEAT
                    RecRef.OPEN(Field.TableNo, FALSE, Company.Name);
                    IF RecRef.READPERMISSION THEN BEGIN
                        FieldRef := RecRef.FIELD(Field."No.");
                        FieldRef.SETRANGE(OldUserName);
                        IF RecRef.FINDSET(TRUE) THEN
                            REPEAT
                                IF IsPrimaryKeyField(Field.TableNo, Field."No.", NumberOfPrimaryKeyFields) THEN
                                    RenameRecord(RecRef, Field.TableNo, NumberOfPrimaryKeyFields, NewUserName, Company.Name)
                                ELSE BEGIN
                                    FieldRef2 := RecRef.FIELD(Field."No.");
                                    FieldRef2.VALUE := NewUserName;
                                    RecRef.MODIFY;
                                END;
                            UNTIL RecRef.NEXT = 0;
                    END ELSE BEGIN
                        TableInformation.SETFILTER("Company Name", '%1|%2', '', Company.Name);
                        TableInformation.SETRANGE("Table No.", Field.TableNo);
                        TableInformation.FINDFIRST;
                        IF TableInformation."No. of Records" > 0 THEN
                            ERROR(Text003);
                    END;
                    RecRef.CLOSE;
                UNTIL Company.NEXT = 0;
            UNTIL Field.NEXT = 0;
    END;

    [EventSubscriber(ObjectType::Table, 2000000120, OnAfterValidateEvent, "Application ID", true, true)]
    LOCAL PROCEDURE SetLicenseTypeOnValidateApplicationID(VAR Rec: Record 2000000120; VAR xRec: Record 2000000120; CurrFieldNo: Integer);
    VAR
        PermissionManager: Codeunit 9002;
        PermissionManager1: Codeunit 51256;
    BEGIN
        IF PermissionManager1.SoftwareAsAService THEN
            IF ISNULLGUID(Rec."Application ID") THEN
                Rec."License Type" := Rec."License Type"::"Full User"
            ELSE
                Rec."License Type" := Rec."License Type"::"External User";
    END;

   

    LOCAL PROCEDURE ValidateLicenseTypeOnSaaS(User: Record 2000000120);
    VAR
        PermissionManager: Codeunit 9002;
        PermissionManager1: Codeunit 51256;
    BEGIN
        IF PermissionManager1.SoftwareAsAService THEN BEGIN
            IF NOT (User."License Type" IN [User."License Type"::"Full User", User."License Type"::"External User"]) THEN
                ERROR(UnsupportedLicenseTypeOnSaasErr, User."License Type"::"Full User", User."License Type"::"External User");
        END;
    END;

    //[IntegrationEvent]
    //[External]
    PROCEDURE OnAfterRenameRecord(VAR RecRef: RecordRef; TableNo: Integer; NumberOfPrimaryKeyFields: Integer; UserName: Code[50]; Company: Text[30]);
    BEGIN
    END;

    /* /*BEGIN
END.*/
}







