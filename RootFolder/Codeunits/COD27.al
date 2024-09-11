Codeunit 50206 "Confirm Management 1"
{


    trigger OnRun()
    BEGIN
    END;

    PROCEDURE ConfirmProcess(ConfirmQuestion: Text; DefaultButton: Boolean): Boolean;
    BEGIN
        IF NOT GUIALLOWED THEN
            EXIT(DefaultButton);
        EXIT(CONFIRM(ConfirmQuestion, DefaultButton));
    END;

    PROCEDURE ConfirmProcessUI(ConfirmQuestion: Text; DefaultButton: Boolean): Boolean;
    BEGIN
        IF NOT GUIALLOWED THEN
            EXIT(FALSE);
        EXIT(CONFIRM(ConfirmQuestion, DefaultButton));
    END;

    /* /*BEGIN
END.*/
}





