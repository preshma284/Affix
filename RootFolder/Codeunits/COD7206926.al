Codeunit 7206926 "Register Aux. Loc. Ship. (s/n)"
{


    TableNo = 7206951;
    trigger OnRun()
    BEGIN
        QBAuxLocOutShipHeader.COPY(Rec);
        Code;
        Rec := QBAuxLocOutShipHeader;
    END;

    VAR
        QBAuxLocOutShipHeader: Record 7206951;
        Text001: TextConst ENU = 'Do you want to post the %1?', ESP = '�Confirma que desea registrar el documento?';
        QBPostAuxLocationShipm: Codeunit 7206925;

    LOCAL PROCEDURE Code();
    BEGIN
        WITH QBAuxLocOutShipHeader DO BEGIN
            IF NOT CONFIRM(Text001, FALSE) THEN
                EXIT;
            QBPostAuxLocationShipm.RUN(QBAuxLocOutShipHeader);
        END;
    END;

    /* BEGIN
END.*/
}









