Codeunit 50370 "Tenant Management 1"
{


    trigger OnRun()
    BEGIN
    END;

    VAR
        NavTenantSettingsHelper: DotNet NavTenantSettingsHelper;
        DISPLAYNAMEKEYTxt: TextConst ENU = 'DISPLAYNAME', ESP = 'DISPLAYNAME';
        AADTENANTIDKEYTxt: TextConst ENU = 'AADTENANTID', ESP = 'AADTENANTID';
        TENANTIDKEYTxt: TextConst ENU = 'TENANTID', ESP = 'TENANTID';
        ENVIRONMENTNAMESANDBOXTxt: TextConst ENU = 'Sandbox', ESP = 'Sandbox';
        ENVIRONMENTNAMEPRODUCTIONTxt: TextConst ENU = 'Production', ESP = 'Production';
        AAD_TENANT_DOMAIN_NAME_FAILUTRE_Err: TextConst ENU = 'Failed to retrieve the Azure Active Directory tenant domain name.', ESP = 'No se pudo recuperar el nombre del dominio del suscriptor de Azure Active Directory.';



    //[External]
    PROCEDURE GetAadTenantId() TenantAadIdValue: Text;
    BEGIN
        // NavTenantSettingsHelper.TryGetStringTenantSetting(AADTENANTIDKEYTxt, TenantAadIdValue);
    END;

    //[External]
    PROCEDURE IsSandbox(): Boolean;
    BEGIN
        EXIT(NavTenantSettingsHelper.IsSandbox())
    END;

    //[External]
    PROCEDURE IsProduction(): Boolean;
    BEGIN
        EXIT(NavTenantSettingsHelper.IsProduction())
    END;

    //[External]
    PROCEDURE GetPlatformVersion(): Text;
    BEGIN
        EXIT(NavTenantSettingsHelper.GetPlatformVersion().ToString())
    END;

    //[External]
    PROCEDURE GetApplicationFamily(): Text;
    BEGIN
        EXIT(NavTenantSettingsHelper.GetApplicationFamily())
    END;

    //[External]
    PROCEDURE GetApplicationVersion(): Text;
    BEGIN
        EXIT(NavTenantSettingsHelper.GetApplicationVersion())
    END;

    //[External]
    PROCEDURE GetEnvironmentName(): Text;
    BEGIN
        IF IsProduction THEN
            EXIT(ENVIRONMENTNAMEPRODUCTIONTxt);
        EXIT(ENVIRONMENTNAMESANDBOXTxt);
    END;

    //[External]
    PROCEDURE GetAadTenantDomainName(): Text;
    VAR
        AzureADUserManagement: Codeunit 9010;
        TenantInfo: DotNet TenantInfo;
    BEGIN
        // IF AzureADUserManagement.GetTenantDetail(TenantInfo) THEN
        //     EXIT(TenantInfo.InitialDomain);
        ERROR(AAD_TENANT_DOMAIN_NAME_FAILUTRE_Err);
    END;

    /* /*BEGIN
END.*/
}







