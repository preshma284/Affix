Codeunit 50212 "LanguageManagement 1"
{


    trigger OnRun()
    BEGIN
    END;

    VAR
        SavedGlobalLanguageID: Integer;

    //[External]
    PROCEDURE SetGlobalLanguage();
    VAR
        TempLanguage: Record 2000000045 TEMPORARY;
    BEGIN
        GetApplicationLanguages(TempLanguage);

        WITH TempLanguage DO BEGIN
            SETCURRENTKEY(Name);
            IF GET(GLOBALLANGUAGE) THEN;
            // PAGE.RUN(PAGE::"Application Languages", TempLanguage);
        END;
    END;

    [TryFunction]
    //[External]
    PROCEDURE TrySetGlobalLanguage(LanguageID: Integer);
    BEGIN
        GLOBALLANGUAGE(LanguageID);
    END;

    //[External]
    PROCEDURE GetApplicationLanguages(VAR TempLanguage: Record 2000000045 TEMPORARY);
    VAR
        Language: Record 2000000045;
    BEGIN
        WITH Language DO BEGIN
            GetLanguageFilters(Language);
            IF FINDSET THEN
                REPEAT
                    TempLanguage := Language;
                    TempLanguage.INSERT;
                UNTIL NEXT = 0;
        END;
    END;

    //[External]
    PROCEDURE ApplicationLanguage(): Integer;
    BEGIN
        EXIT(1033);
    END;

    //[External]
    PROCEDURE ValidateApplicationLanguage(LanguageID: Integer);
    VAR
        TempLanguage: Record 2000000045 TEMPORARY;
    BEGIN
        GetApplicationLanguages(TempLanguage);

        WITH TempLanguage DO BEGIN
            SETRANGE("Language ID", LanguageID);
            FINDFIRST;
        END;
    END;

    //[External]
    PROCEDURE ValidateWindowsLocale(LocaleID: Integer);
    VAR
        WindowsLanguage: Record 2000000045;
    BEGIN
        WindowsLanguage.SETRANGE("Language ID", LocaleID);
        WindowsLanguage.FINDFIRST;
    END;

    //[External]
    PROCEDURE LookupApplicationLanguage(VAR LanguageID: Integer);
    VAR
        TempLanguage: Record 2000000045 TEMPORARY;
    BEGIN
        GetApplicationLanguages(TempLanguage);

        WITH TempLanguage DO BEGIN
            IF GET(LanguageID) THEN;
            IF PAGE.RUNMODAL(PAGE::"Windows Languages", TempLanguage) = ACTION::LookupOK THEN
                LanguageID := "Language ID";
        END;
    END;

    //[External]
    PROCEDURE LookupWindowsLocale(VAR LocaleID: Integer);
    VAR
        WindowsLanguage: Record 2000000045;
    BEGIN
        WITH WindowsLanguage DO BEGIN
            SETCURRENTKEY(Name);
            IF PAGE.RUNMODAL(PAGE::"Windows Languages", WindowsLanguage) = ACTION::LookupOK THEN
                LocaleID := "Language ID";
        END;
    END;

    //[External]
    PROCEDURE SetGlobalLanguageByCode(LanguageCode: Code[10]);
    VAR
        Language: Record 8;
    BEGIN
        IF LanguageCode = '' THEN
            EXIT;
        SavedGlobalLanguageID := GLOBALLANGUAGE;
        // GLOBALLANGUAGE(Language.GetLanguageID(LanguageCode));
    END;

    //[External]
    PROCEDURE RestoreGlobalLanguage();
    BEGIN
        IF SavedGlobalLanguageID <> 0 THEN BEGIN
            GLOBALLANGUAGE(SavedGlobalLanguageID);
            SavedGlobalLanguageID := 0;
        END;
    END;

    LOCAL PROCEDURE GetLanguageFilters(VAR WindowsLanguage: Record 2000000045);
    BEGIN
        WindowsLanguage.SETRANGE("Localization Exist", TRUE);
        WindowsLanguage.SETRANGE("Globally Enabled", TRUE);
    END;

    //[External]
    PROCEDURE GetWindowsLanguageNameFromLanguageCode(LanguageCode: Code[10]): Text;
    VAR
        Language: Record 8;
    BEGIN
        IF LanguageCode = '' THEN
            EXIT('');

        Language.SETAUTOCALCFIELDS("Windows Language Name");
        IF Language.GET(LanguageCode) THEN
            EXIT(Language."Windows Language Name");

        EXIT('');
    END;

    //[External]
    PROCEDURE GetWindowsLanguageIDFromLanguageName(LanguageName: Text): Integer;
    VAR
        WindowsLanguage: Record 2000000045;
    BEGIN
        IF LanguageName = '' THEN
            EXIT(0);
        WindowsLanguage.SETRANGE("Localization Exist", TRUE);
        WindowsLanguage.SETFILTER(Name, '@*' + COPYSTR(LanguageName, 1, MAXSTRLEN(WindowsLanguage.Name)) + '*');
        IF NOT WindowsLanguage.FINDFIRST THEN
            EXIT(0);

        EXIT(WindowsLanguage."Language ID");
    END;

    //[External]
    PROCEDURE GetLanguageCodeFromLanguageID(LanguageID: Integer): Code[10];
    VAR
        Language: Record 8;
    BEGIN
        IF LanguageID = 0 THEN
            EXIT('');
        Language.SETRANGE("Windows Language ID", LanguageID);
        IF Language.FINDFIRST THEN
            EXIT(Language.Code);
        EXIT('');
    END;

    //[External]
    PROCEDURE GetWindowsLanguageNameFromLanguageID(LanguageID: Integer): Text;
    VAR
        Language: Record 8;
    BEGIN
        IF LanguageID = 0 THEN
            EXIT('');

        Language.SETRANGE("Windows Language ID", LanguageID);
        IF Language.FINDFIRST THEN BEGIN
            Language.CALCFIELDS("Windows Language Name");
            EXIT(Language.Name);
        END;

        EXIT('');
    END;

    [EventSubscriber(ObjectType::Codeunit, 2000000004, GetApplicationLanguage, '', true, true)]
    LOCAL PROCEDURE GetApplicationLanguage(VAR language: Integer);
    BEGIN
        language := ApplicationLanguage;
    END;

    [TryFunction]
    //[External]
    PROCEDURE TryGetCultureName(Culture: Integer; VAR CultureName: Text);
    VAR
       CultureInfo: DotNet CultureInfo;
    BEGIN
        CultureInfo := CultureInfo.CultureInfo(Culture);
        CultureName := CultureInfo.Name;
    END;

    /* /*BEGIN
END.*/
}







