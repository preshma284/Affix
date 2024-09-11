Codeunit 7207271 "Post Worksheet (Yes/No)"
{


    TableNo = 7207290;
    trigger OnRun()
    BEGIN
        recWorksheetHeader.COPY(Rec);
        Code;
        Rec := recWorksheetHeader;
    END;

    VAR
        recWorksheetHeader: Record 7207290;
        Text001: TextConst ENU = 'Do you want to post the %1?', ESP = '�Confirma que desea registrar el documento %1?';
        PostWorksheet: Codeunit 7207270;

    LOCAL PROCEDURE Code();
    BEGIN
        WITH recWorksheetHeader DO BEGIN
            IF NOT CONFIRM(Text001, FALSE, "No.") THEN
                EXIT;
            PostWorksheet.RUN(recWorksheetHeader);
        END;
    END;

    PROCEDURE PostExternalWorksheet_YN(QBExternalWorksheetHeader: Record 7206933);
    BEGIN
        IF CONFIRM(Text001, FALSE, QBExternalWorksheetHeader."No.") THEN
            PostWorksheet.ExternalWorksheet_Post(QBExternalWorksheetHeader);
    END;

    /* /*BEGIN
END.*/
}









