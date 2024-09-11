Codeunit 51289 "Identity Management 1"
{


    trigger OnRun()
    BEGIN
    END;

    VAR
        TenantManagementHelper: Codeunit 417;
        TenantManagementHelper1: Codeunit 50370;
        UserAccountHelper: DotNet NavUserAccountHelper;
        NavTok: TextConst ENU = 'NAV', ESP = 'NAV';
        InvoiceTok: TextConst ENU = 'INV', ESP = 'INV';
        FinancialsTok: TextConst ENU = 'FIN', ESP = 'FIN';
        C5Tok: TextConst ENU = 'C5', ESP = 'C5';

    
    LOCAL PROCEDURE ValidateKeyStrength("Key": Text[250]): Boolean;
    VAR
        i: Integer;
        KeyLen: Integer;
        HasUpper: Boolean;
        HasLower: Boolean;
        HasNumeric: Boolean;
    BEGIN
        KeyLen := STRLEN(Key);

        IF KeyLen < 8 THEN
            EXIT(FALSE);

        FOR i := 1 TO STRLEN(Key) DO BEGIN
            CASE Key[i] OF
                'A' .. 'Z':
                    HasUpper := TRUE;
                'a' .. 'z':
                    HasLower := TRUE;
                '0' .. '9':
                    HasNumeric := TRUE;
            END;

            IF HasUpper AND HasLower AND HasNumeric THEN
                EXIT(TRUE);
        END;

        EXIT(FALSE);
    END;

    //[External]
    PROCEDURE ValidatePasswordStrength(Password: Text[250]) IsValid: Boolean;
    BEGIN
        IsValid := ValidateKeyStrength(Password);
    END;

    //[External]
    PROCEDURE ValidateAuthKeyStrength(AuthKey: Text[250]) IsValid: Boolean;
    BEGIN
        IsValid := ValidateKeyStrength(AuthKey);
    END;

    //[Internal]
    PROCEDURE GetMaskedNavPassword(UserSecurityID: GUID) MaskedPassword: Text[80];
    BEGIN
        IF UserAccountHelper.IsPasswordSet(UserSecurityID) THEN
            MaskedPassword := '********'
        ELSE
            MaskedPassword := '';
    END;

    

    //[External]
    PROCEDURE GetAadTenantId(): Text;
    BEGIN
        EXIT(TenantManagementHelper1.GetAadTenantId);
    END;

    //[External]
    PROCEDURE IsInvAppId(): Boolean;
    VAR
        AppId: Text;
    BEGIN
        AppId := APPLICATIONIDENTIFIER;
        OnBeforeGetApplicationIdentifier(AppId);
        EXIT(AppId = InvoiceTok);
    END;

    //[External]
    PROCEDURE IsFinAppId(): Boolean;
    VAR
        AppId: Text;
    BEGIN
        AppId := APPLICATIONIDENTIFIER;
        OnBeforeGetApplicationIdentifier(AppId);
        EXIT(AppId = FinancialsTok);
    END;

    //[External]
    PROCEDURE IsNavAppId(): Boolean;
    VAR
        AppId: Text;
    BEGIN
        AppId := APPLICATIONIDENTIFIER;
        OnBeforeGetApplicationIdentifier(AppId);
        EXIT(AppId = NavTok);
    END;

    //[External]
    PROCEDURE IsC5AppId(): Boolean;
    VAR
        AppId: Text;
    BEGIN
        AppId := APPLICATIONIDENTIFIER;
        OnBeforeGetApplicationIdentifier(AppId);
        EXIT(AppId = C5Tok);
    END;

    //[IntegrationEvent]
    //[External]
    PROCEDURE OnBeforeGetApplicationIdentifier(VAR AppId: Text);
    BEGIN
    END;

    /* /*BEGIN
END.*/
}







