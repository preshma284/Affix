Codeunit 50209 "LogInManagement 1"
{


    Permissions = TableData 17 = r,
                TableData 18 = r,
                TableData 23 = r,
                TableData 27 = r,
                TableData 51 = rimd,
                TableData 9150 = rimd,
                TableData 9151 = rimd,
                TableData 9152 = rimd,
                TableData 9153 = rimd;
    SingleInstance = true;
    trigger OnRun()
    BEGIN
    END;

    VAR
        PartnerAgreementNotAcceptedErr: TextConst ENU = 'Partner Agreement has not been accepted.', ESP = 'El acuerdo de socio no se ha aceptado.';
        PasswordChangeNeededErr: TextConst ENU = 'You must change the password before you can continue.', ESP = 'Debe cambiar la contrase�a para continuar.';
        GLSetup: Record 98;
        User: Record 2000000120;// SECURITYFILTERING(Filtered);
        LogInWorkDate: Date;
        LogInDate: Date;
        LogInTime: Time;
        GLSetupRead: Boolean;

    //[Internal]
    PROCEDURE CompanyOpen();
    VAR
        LogonManagement: Codeunit 9802;
        LogonManagement1: Codeunit 51290;
    BEGIN
        LogonManagement1.SetLogonInProgress(TRUE);

        // This needs to be the very first thing to run before company open
        CODEUNIT.RUN(CODEUNIT::"Azure AD User Management");
        CODEUNIT.RUN(CODEUNIT::"SaaS Log In Management");

        OnBeforeCompanyOpen;

        IF GUIALLOWED THEN
            LogInStart;

        OnAfterCompanyOpen;

        LogonManagement1.SetLogonInProgress(FALSE);
    END;

    

    LOCAL PROCEDURE LogInStart();
    VAR
        Language: Record 2000000045;
        LicenseAgreement: Record 140;
        // UserLogin: Record 9008;
        ApplicationAreaMgmtFacade: Codeunit 9179;
        IdentityManagement: Codeunit 9801;
        CompanyInformationMgt: Codeunit 1306;
        LanguageManagement: Codeunit 43;
        LanguageManagement1: Codeunit 50212;
    BEGIN
        IF NOT CompanyInformationMgt.IsDemoCompany THEN
            IF LicenseAgreement.GET THEN
                IF LicenseAgreement.GetActive AND NOT LicenseAgreement.Accepted THEN BEGIN
                    PAGE.RUNMODAL(PAGE::"Additional Customer Terms");
                    LicenseAgreement.GET;
                    IF NOT LicenseAgreement.Accepted THEN
                        ERROR(PartnerAgreementNotAcceptedErr)
                END;

        Language.SETRANGE("Localization Exist", TRUE);
        Language.SETRANGE("Globally Enabled", TRUE);
        Language."Language ID" := GLOBALLANGUAGE;
        IF NOT Language.FIND THEN BEGIN
            Language."Language ID" := WINDOWSLANGUAGE;
            IF NOT Language.FIND THEN
                Language."Language ID" := LanguageManagement1.ApplicationLanguage;
        END;
        GLOBALLANGUAGE := Language."Language ID";

        // Check if the logged in user must change login before allowing access.
        IF NOT User.ISEMPTY THEN BEGIN
            IF IdentityManagement.IsUserNamePasswordAuthentication THEN BEGIN
                User.SETRANGE("User Security ID", USERSECURITYID);
                User.FINDFIRST;
                IF User."Change Password" THEN BEGIN
                    // PAGE.RUNMODAL(PAGE::"Change Password");
                    SELECTLATESTVERSION;
                    User.FINDFIRST;
                    IF User."Change Password" THEN
                        ERROR(PasswordChangeNeededErr);
                END;
            END;

            User.SETRANGE("User Security ID");
        END;

        OnBeforeLogInStart;

        InitializeCompany;
        UpdateUserPersonalization;
        CreateProfiles;

        LogInDate := TODAY;
        LogInTime := TIME;
        LogInWorkDate := 0D;
        // UserLogin.UpdateLastLoginInfo;

        WORKDATE := GetDefaultWorkDate;

        SetupMyRecords;

        ApplicationAreaMgmtFacade.SetupApplicationArea;

        OnAfterLogInStart;
    END;

    LOCAL PROCEDURE LogInEnd();
    VAR
        UserSetup: Record 91;
        UserTimeRegister: Record 51;
        LogOutDate: Date;
        LogOutTime: Time;
        Minutes: Integer;
        UserSetupFound: Boolean;
        RegisterTime: Boolean;
    BEGIN
        IF LogInDate = 0D THEN
            EXIT;

        IF LogInWorkDate <> 0D THEN
            IF LogInWorkDate = LogInDate THEN
                WORKDATE := TODAY
            ELSE
                WORKDATE := LogInWorkDate;

        IF USERID <> '' THEN BEGIN
            IF UserSetup.GET(USERID) THEN BEGIN
                UserSetupFound := TRUE;
                RegisterTime := UserSetup."Register Time";
            END;
            IF NOT UserSetupFound THEN
                IF GetGLSetup THEN
                    RegisterTime := GLSetup."Register Time";
            IF RegisterTime THEN BEGIN
                LogOutDate := TODAY;
                LogOutTime := TIME;
                IF (LogOutDate > LogInDate) OR (LogOutDate = LogInDate) AND (LogOutTime > LogInTime) THEN
                    Minutes := ROUND((1440 * (LogOutDate - LogInDate)) + ((LogOutTime - LogInTime) / 60000), 1);
                IF Minutes = 0 THEN
                    Minutes := 1;
                UserTimeRegister.INIT;
                UserTimeRegister."User ID" := USERID;
                UserTimeRegister.Date := LogInDate;
                IF UserTimeRegister.FIND THEN BEGIN
                    UserTimeRegister.Minutes := UserTimeRegister.Minutes + Minutes;
                    UserTimeRegister.MODIFY;
                END ELSE BEGIN
                    UserTimeRegister.Minutes := Minutes;
                    UserTimeRegister.INSERT;
                END;
            END;
        END;

        OnAfterLogInEnd;
    END;

    //[External]
    PROCEDURE InitializeCompany();
    BEGIN
        IF NOT GLSetup.GET THEN
            CODEUNIT.RUN(CODEUNIT::"Company-Initialize");
    END;

    //[External]
    PROCEDURE CreateProfiles();
    VAR
        // Profile: Record 2000000072;
    BEGIN
        // IF Profile.ISEMPTY THEN BEGIN
        //     CODEUNIT.RUN(CODEUNIT::"Conf./Personalization Mgt.");
        //     COMMIT;
        // END;
    END;

    LOCAL PROCEDURE GetGLSetup(): Boolean;
    BEGIN
        IF NOT GLSetupRead THEN
            GLSetupRead := GLSetup.GET;
        EXIT(GLSetupRead);
    END;

    //[External]
    PROCEDURE GetDefaultWorkDate(): Date;
    VAR
        GLEntry: Record 17;
        CompanyInformationMgt: Codeunit 1306;
    BEGIN
        IF CompanyInformationMgt.IsDemoCompany THEN
            IF GLEntry.READPERMISSION THEN BEGIN
                GLEntry.SETCURRENTKEY("Posting Date");
                IF GLEntry.FINDLAST THEN BEGIN
                    LogInWorkDate := NORMALDATE(GLEntry."Posting Date");
                    EXIT(NORMALDATE(GLEntry."Posting Date"));
                END;
            END;

        EXIT(WORKDATE);
    END;

    LOCAL PROCEDURE SetupMyRecords();
    VAR
        CompanyInformationMgt: Codeunit 1306;
    BEGIN
        IF NOT CompanyInformationMgt.IsDemoCompany THEN
            EXIT;

        IF SetupMyCustomer THEN
            EXIT;

        IF SetupMyItem THEN
            EXIT;

        IF SetupMyVendor THEN
            EXIT;

        SetupMyAccount;
    END;

    LOCAL PROCEDURE SetupMyCustomer(): Boolean;
    VAR
        Customer: Record 18;
        MyCustomer: Record 9150;
        MaxCustomersToAdd: Integer;
        I: Integer;
    BEGIN
        IF NOT Customer.READPERMISSION THEN
            EXIT;

        MyCustomer.SETRANGE("User ID", USERID);
        IF NOT MyCustomer.ISEMPTY THEN
            EXIT(TRUE);

        I := 0;
        MaxCustomersToAdd := 5;
        Customer.SETFILTER(Balance, '<>0');
        IF Customer.FINDSET THEN
            REPEAT
                I += 1;
                MyCustomer."User ID" := USERID;
                MyCustomer.VALIDATE("Customer No.", Customer."No.");
                IF MyCustomer.INSERT THEN;
            UNTIL (Customer.NEXT = 0) OR (I >= MaxCustomersToAdd);
    END;

    LOCAL PROCEDURE SetupMyItem(): Boolean;
    VAR
        Item: Record 27;
        MyItem: Record 9152;
        MaxItemsToAdd: Integer;
        I: Integer;
    BEGIN
        IF NOT Item.READPERMISSION THEN
            EXIT;

        MyItem.SETRANGE("User ID", USERID);
        IF NOT MyItem.ISEMPTY THEN
            EXIT(TRUE);

        I := 0;
        MaxItemsToAdd := 5;

        Item.SETFILTER("Unit Price", '<>0');
        IF Item.FINDSET THEN
            REPEAT
                I += 1;
                MyItem."User ID" := USERID;
                MyItem.VALIDATE("Item No.", Item."No.");
                IF MyItem.INSERT THEN;
            UNTIL (Item.NEXT = 0) OR (I >= MaxItemsToAdd);
    END;

    LOCAL PROCEDURE SetupMyVendor(): Boolean;
    VAR
        Vendor: Record 23;
        MyVendor: Record 9151;
        MaxVendorsToAdd: Integer;
        I: Integer;
    BEGIN
        IF NOT Vendor.READPERMISSION THEN
            EXIT;

        MyVendor.SETRANGE("User ID", USERID);
        IF NOT MyVendor.ISEMPTY THEN
            EXIT(TRUE);

        I := 0;
        MaxVendorsToAdd := 5;
        Vendor.SETFILTER(Balance, '<>0');
        IF Vendor.FINDSET THEN
            REPEAT
                I += 1;
                MyVendor."User ID" := USERID;
                MyVendor.VALIDATE("Vendor No.", Vendor."No.");
                IF MyVendor.INSERT THEN;
            UNTIL (Vendor.NEXT = 0) OR (I >= MaxVendorsToAdd);
    END;

    LOCAL PROCEDURE SetupMyAccount(): Boolean;
    VAR
        GLAccount: Record 15;
        MyAccount: Record 9153;
        MaxAccountsToAdd: Integer;
        I: Integer;
    BEGIN
        IF NOT GLAccount.READPERMISSION THEN
            EXIT;

        MyAccount.SETRANGE("User ID", USERID);
        IF NOT MyAccount.ISEMPTY THEN
            EXIT(TRUE);

        I := 0;
        MaxAccountsToAdd := 5;
        GLAccount.SETRANGE("Reconciliation Account", TRUE);
        IF GLAccount.FINDSET THEN
            REPEAT
                I += 1;
                MyAccount."User ID" := USERID;
                MyAccount.VALIDATE("Account No.", GLAccount."No.");
                IF MyAccount.INSERT THEN;
            UNTIL (GLAccount.NEXT = 0) OR (I >= MaxAccountsToAdd);
    END;

    //[External]
    PROCEDURE AnyUserLoginExistsWithinPeriod(PeriodType: Option "Day","Week","Month","Quarter","Year","Accounting Period"; NoOfPeriods: Integer): Boolean;
    VAR
        // UserLogin: Record 9008;
        PeriodFormManagement: Codeunit 50324;
        FromEventDateTime: DateTime;
    BEGIN
        FromEventDateTime := CREATEDATETIME(PeriodFormManagement.MoveDateByPeriod(TODAY, PeriodType, -NoOfPeriods), TIME);
        // UserLogin.SETFILTER("Last Login Date", '>=%1', FromEventDateTime);
        // EXIT(NOT UserLogin.ISEMPTY);
    END;

    //[External]
    PROCEDURE UserLoggedInAtOrAfterDateTime(FromEventDateTime: DateTime): Boolean;
    VAR
        // UserLogin: Record 9008;
    BEGIN
        // EXIT(UserLogin.UserLoggedInAtOrAfter(FromEventDateTime));
    END;

    [EventSubscriber(ObjectType::Codeunit, 2000000004, GetSystemIndicator, '', true, true)]
    LOCAL PROCEDURE GetSystemIndicator(VAR Text: Text[250]; VAR Style: Option "Standard","Accent1","Accent2","Accent3","Accent4","Accent5","Accent6","Accent7","Accent8","Accent9");
    VAR
        CompanyInformation: Record 79;
    BEGIN
        IF CompanyInformation.GET THEN;
        CompanyInformation.GetSystemIndicator(Text, Style);
    END;

    LOCAL PROCEDURE UpdateUserPersonalization();
    VAR
        UserPersonalization: Record 2000000073;
        Profile: Record 2000000178;
        AllObjWithCaption: Record 2000000058;
        PermissionManager: Codeunit 9002;
        PermissionManager1: Codeunit 51256;
        ProfileScope: Option "System","Tenant";
        AppID: GUID;
    BEGIN
        IF NOT UserPersonalization.GET(USERSECURITYID) THEN
            EXIT;

        IF Profile.GET(UserPersonalization.Scope, UserPersonalization."App ID", UserPersonalization."Profile ID") THEN BEGIN
            AllObjWithCaption.SETRANGE("Object Type", AllObjWithCaption."Object Type"::Page);
            AllObjWithCaption.SETRANGE("Object Subtype", 'RoleCenter');
            AllObjWithCaption.SETRANGE("Object ID", Profile."Role Center ID");
            IF AllObjWithCaption.ISEMPTY THEN BEGIN
                UserPersonalization."Profile ID" := '';
                UserPersonalization.MODIFY;
                COMMIT;
            END;
        END ELSE
            IF PermissionManager1.SoftwareAsAService THEN BEGIN
                Profile.RESET;
                PermissionManager.GetDefaultProfileID(USERSECURITYID, Profile);

                IF NOT Profile.ISEMPTY THEN BEGIN
                    UserPersonalization."Profile ID" := Profile."Profile ID";
                    UserPersonalization.Scope := Profile.Scope;
                    UserPersonalization."App ID" := Profile."App ID";
                    UserPersonalization.MODIFY;
                END ELSE BEGIN
                    UserPersonalization."Profile ID" := '';
                    UserPersonalization.Scope := ProfileScope::System;
                    UserPersonalization."App ID" := AppID;
                    UserPersonalization.MODIFY;
                END;
            END;
    END;

    
    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterLogInStart();
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterLogInEnd();
    BEGIN
    END;

    LOCAL PROCEDURE OnBeforeLogInStart();
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeCompanyOpen();
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterCompanyOpen();
    BEGIN
    END;


    /* /*BEGIN
END.*/
}







