Codeunit 50192 "ClientTypeManagement 1"
{


    trigger OnRun()
    BEGIN
    END;

    //[External]
    PROCEDURE GetCurrentClientType() CurrClientType: ClientType;
    BEGIN
        CurrClientType := CURRENTCLIENTTYPE;
        OnAfterGetCurrentClientType(CurrClientType);
    END;

    //[External]
    PROCEDURE IsClientType(ExpectedClientType: ClientType): Boolean;
    BEGIN
        EXIT(ExpectedClientType = GetCurrentClientType);
    END;

    //[External]
    PROCEDURE IsCommonWebClientType(): Boolean;
    BEGIN
        EXIT(GetCurrentClientType IN [CLIENTTYPE::Web, CLIENTTYPE::Tablet, CLIENTTYPE::Phone, CLIENTTYPE::Desktop]);
    END;

    //[External]
    PROCEDURE IsWindowsClientType(): Boolean;
    BEGIN
        EXIT(IsClientType(CLIENTTYPE::Windows));
    END;

    //[External]
    PROCEDURE IsDeviceClientType(): Boolean;
    BEGIN
        EXIT(GetCurrentClientType IN [CLIENTTYPE::Tablet, CLIENTTYPE::Phone]);
    END;

    //[External]
    PROCEDURE IsPhoneClientType(): Boolean;
    BEGIN
        EXIT(IsClientType(CLIENTTYPE::Phone));
    END;

    //[External]
    PROCEDURE IsBackground(): Boolean;
    BEGIN
        EXIT(GetCurrentClientType IN [CLIENTTYPE::Background]);
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterGetCurrentClientType(VAR CurrClientType: ClientType);
    BEGIN
    END;

    /* /*BEGIN
END.*/
}











