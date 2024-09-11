Codeunit 50455 "Social Listening Management 1"
{


    trigger OnRun()
    BEGIN
    END;

    VAR
        MslProductNameTxt: TextConst ENU = 'Microsoft Social Engagement', ESP = 'Microsoft Social Engagement';
        FailedToConnectTxt: TextConst ENU = 'Failed to connect to %1.<br><br>Verify the configuration of %1 in %3.<br><br>Afterwards %2 to try connecting to %1 again.', ESP = 'No se pudo conectar con %1.<br><br>Compruebe la configuraci�n de %1 en %3.<br><br>Despu�s, %2 para volver a intentar conectarse a %1.';
        HasNotBeenAuthenticatedTxt: TextConst ENU = '%1 has not been authenticated.<br><br>Go to %2 to open the authentication window.<br><br>Afterwards %3 to show data.', ESP = '%1 no se ha autenticado.<br><br>Vaya a %2 para abrir la ventana de autenticaci�n.<br><br>Despu�s, %3 para mostrar los datos.';
        ExpectedValueErr: TextConst ENU = 'Expected value should be an integer or url path containing %2 in %1.', ESP = 'El valor esperado deber�a ser un entero o una ruta url que contenga %2 en %1.';
        RefreshTxt: TextConst ENU = 'refresh', ESP = 'actualizar';

    //[External]
    PROCEDURE GetSignupURL(): Text[250];
    BEGIN
        EXIT('http://go.microsoft.com/fwlink/p/?LinkId=401462');
    END;

    //[External]
    PROCEDURE GetTermsOfUseURL(): Text[250];
    BEGIN
        EXIT('http://go.microsoft.com/fwlink/?LinkID=389042');
    END;

    //[External]
    PROCEDURE GetMSL_URL(): Text[250];
    VAR
        // SocialListeningSetup: Record 870;
    BEGIN
        // WITH SocialListeningSetup DO BEGIN
        //     IF GET AND ("Social Listening URL" <> '') THEN
        //         EXIT(COPYSTR("Social Listening URL", 1, STRPOS("Social Listening URL", '/app/') - 1));
        //     TESTFIELD("Social Listening URL");
        // END;
    END;

    //[External]
    PROCEDURE GetMSLAppURL(): Text[250];
    BEGIN
        EXIT(STRSUBSTNO('%1/app/%2/', GetMSL_URL, GetMSLSubscriptionID));
    END;

    //[External]
    PROCEDURE MSLUsersURL(): Text;
    BEGIN
        EXIT(STRSUBSTNO('%1/settings/%2/?locale=%3#page:users', GetMSL_URL, GetMSLSubscriptionID, GetLanguage));
    END;

    //[External]
    PROCEDURE MSLSearchItemsURL(): Text;
    BEGIN
        EXIT(STRSUBSTNO('%1/app/%2/?locale=%3#search:topics', GetMSL_URL, GetMSLSubscriptionID, GetLanguage));
    END;

    LOCAL PROCEDURE MSLAuthenticationURL(): Text;
    BEGIN
        EXIT(STRSUBSTNO('%1/widgetapi/%2/authenticate.htm?lang=%3', GetMSL_URL, GetMSLSubscriptionID, GetLanguage));
    END;

    //[External]
    PROCEDURE MSLAuthenticationStatusURL(): Text;
    BEGIN
        EXIT(STRSUBSTNO('%1/widgetapi/%2/auth_status.htm?lang=%3', GetMSL_URL, GetMSLSubscriptionID, GetLanguage));
    END;

    //[External]
    PROCEDURE GetAuthenticationWidget(SearchTopic: Text): Text;
    BEGIN
        EXIT(
          STRSUBSTNO(
            '%1/widgetapi/%2/?locale=%3#analytics:overview?date=today&nodeId=%4',
            GetMSL_URL, GetMSLSubscriptionID, GetLanguage, SearchTopic));
    END;

    LOCAL PROCEDURE GetAuthenticationLink(): Text;
    BEGIN
        EXIT(
          STRSUBSTNO(
            '<a style="text-decoration: none" href="javascript:;" onclick="openAuthenticationWindow(''%1'');">%2</a>',
            MSLAuthenticationURL, MslProductNameTxt));
    END;

    LOCAL PROCEDURE GetRefreshLink(): Text;
    BEGIN
        EXIT(STRSUBSTNO('<a style="text-decoration: none" href="javascript:;" onclick="raiseMessageLinkClick(1);">%1</a>', RefreshTxt));
    END;

    LOCAL PROCEDURE GetMSLSubscriptionID(): Text[250];
    VAR
        // SocialListeningSetup: Record 870;
    BEGIN
        // SocialListeningSetup.GET;
        // SocialListeningSetup.TESTFIELD("Solution ID");
        // EXIT(SocialListeningSetup."Solution ID");
    END;

    LOCAL PROCEDURE GetLanguage(): Text;
    VAR
        CultureInfo: DotNet CultureInfo;
    BEGIN
        CultureInfo := CultureInfo.CultureInfo(GLOBALLANGUAGE);
        EXIT(CultureInfo.TwoLetterISOLanguageName);
    END;

    //[External]
    PROCEDURE GetAuthenticationConectionErrorMsg(): Text;
    BEGIN
        EXIT(STRSUBSTNO(FailedToConnectTxt, MslProductNameTxt, GetRefreshLink, PRODUCTNAME.FULL));
    END;

    //[External]
    PROCEDURE GetAuthenticationUserErrorMsg(): Text;
    BEGIN
        EXIT(STRSUBSTNO(HasNotBeenAuthenticatedTxt, MslProductNameTxt, GetAuthenticationLink, GetRefreshLink));
    END;

    //[External]
    PROCEDURE GetCustFactboxVisibility(Cust: Record 18; VAR MSLSetupVisibility: Boolean; VAR MSLVisibility: Boolean);
    VAR
        // SocialListeningSetup: Record 870;
        // SocialListeningSearchTopic: Record 871;
    BEGIN
        // WITH SocialListeningSetup DO
        //     MSLSetupVisibility := GET AND "Show on Customers" AND "Accept License Agreement" AND ("Solution ID" <> '');

        // IF MSLSetupVisibility THEN
        //     WITH SocialListeningSearchTopic DO
        //         MSLVisibility := FindSearchTopic("Source Type"::Customer, Cust."No.") AND ("Search Topic" <> '')
    END;

    //[External]
    PROCEDURE GetVendFactboxVisibility(Vend: Record 23; VAR MSLSetupVisibility: Boolean; VAR MSLVisibility: Boolean);
    VAR
        // SocialListeningSetup: Record 870;
        // SocialListeningSearchTopic: Record 871;
    BEGIN
        // WITH SocialListeningSetup DO
        //     MSLSetupVisibility := GET AND "Show on Vendors" AND "Accept License Agreement" AND ("Solution ID" <> '');

        // IF MSLSetupVisibility THEN
        //     WITH SocialListeningSearchTopic DO
        //         MSLVisibility := FindSearchTopic("Source Type"::Vendor, Vend."No.") AND ("Search Topic" <> '');
    END;

    //[External]
    PROCEDURE GetItemFactboxVisibility(Item: Record 27; VAR MSLSetupVisibility: Boolean; VAR MSLVisibility: Boolean);
    VAR
        // SocialListeningSetup: Record 870;
        // SocialListeningSearchTopic: Record 871;
    BEGIN
        // WITH SocialListeningSetup DO
        //     MSLSetupVisibility := GET AND "Show on Items" AND "Accept License Agreement" AND ("Solution ID" <> '');

        // IF MSLSetupVisibility THEN
        //     WITH SocialListeningSearchTopic DO
        //         MSLVisibility := SocialListeningSetup.FindSearchTopic("Source Type"::Item, Item."No.") AND ("Search Topic" <> '');
    END;

    //[External]
    PROCEDURE ConvertURLToID(URL: Text; where: Text): Text[250];
    VAR
        i: Integer;
        j: Integer;
        PositionOfID: Integer;
        ID: Text;
        IntegerValue: Integer;
    BEGIN
        IF URL = '' THEN
            EXIT(URL);
        IF EVALUATE(IntegerValue, URL) THEN
            EXIT(URL);

        PositionOfID := STRPOS(LOWERCASE(URL), LOWERCASE(where));
        IF PositionOfID = 0 THEN
            ERROR(ExpectedValueErr, where, URL);

        j := 1;
        FOR i := PositionOfID + STRLEN(where) TO STRLEN(URL) DO BEGIN
            IF NOT (URL[i] IN ['0' .. '9']) THEN
                BREAK;

            ID[j] := URL[i];
            j += 1;
        END;

        IF ID = '' THEN
            ERROR(ExpectedValueErr, where, LOWERCASE(GetMSL_URL));
        EXIT(ID);
    END;

    [EventSubscriber(ObjectType::Table, 1400, OnRegisterServiceConnection, '', true, true)]
    //[External]
    PROCEDURE HandleMSERegisterServiceConnection(VAR ServiceConnection: Record 1400);
    VAR
        // SocialListeningSetup: Record 870;
        PermissionManager: Codeunit 9002;
        PermissionManager1: Codeunit 51256;
        RecRef: RecordRef;
    BEGIN
        IF PermissionManager1.SoftwareAsAService THEN
            EXIT;

        // SocialListeningSetup.GET;
        // RecRef.GETTABLE(SocialListeningSetup);

        // WITH SocialListeningSetup DO BEGIN
        //     ServiceConnection.Status := ServiceConnection.Status::Enabled;
        //     IF NOT "Show on Items" AND NOT "Show on Customers" AND NOT "Show on Vendors" THEN
        //         ServiceConnection.Status := ServiceConnection.Status::Disabled;
        //     ServiceConnection.InsertServiceConnection(
        //       ServiceConnection, RecRef.RECORDID, TABLECAPTION, "Social Listening URL", PAGE::"Social Listening Setup");
        // END;
    END;

    //[External]
    PROCEDURE CheckURLPath(URL: Text; where: Text);
    VAR
        IntegerValue: Integer;
    BEGIN
        IF URL = '' THEN
            EXIT;
        IF EVALUATE(IntegerValue, URL) THEN
            EXIT;

        IF STRPOS(LOWERCASE(URL), LOWERCASE(GetMSL_URL)) = 0 THEN
            ERROR(ExpectedValueErr, where, LOWERCASE(GetMSL_URL));
    END;

    /* /*BEGIN
END.*/
}







