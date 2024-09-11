Codeunit 7174369 "QM Session Table Maintenance"
{


    TableNo = 7174388;
    trigger OnRun()
    VAR
        QMSessionTableData: Record 7174388;
        SessionEvent: Record 2000000111;
        recRef: RecordRef;
        fRef: FieldRef;
        Ok: Boolean;
    BEGIN
        //Este proceso se ejecuta en la empresa de destino, en una nueva sesi�n

        //JAV 12/09/22: - QM 1.00.06 Para evitar errores si ya existe el registro, solo puede ser porque no se elimin� en su momento
        IF (QMSessionTableData.GET(SESSIONID)) THEN    //JAV 12/02/22: - QB 1.00.06 Se a�ade la empresa a la clave de la tabla auxiliar de sesiones
            QMSessionTableData.DELETE;

        QMSessionTableData.INIT;
        QMSessionTableData.IDSesion := SESSIONID;
        QMSessionTableData.DestinationCompany := COMPANYNAME;
        QMSessionTableData.OriginCompany := Rec.OriginCompany;
        QMSessionTableData.OriginSesion := Rec.OriginSesion;
        QMSessionTableData.ResultOk := FALSE;                         //JAV 20/09/22: - QB 1.00.06 Por defecto la sesi�n terminar� con error, a no ser que pueda cambiar este check
        QMSessionTableData.INSERT;

        //Elimino comentarios de la tabla de sesiones para evitar problemas
        SessionEvent.RESET;
        SessionEvent.SETASCENDING("Event Datetime", TRUE);
        SessionEvent.SETRANGE("User ID", USERID);
        SessionEvent.SETRANGE("Server Instance ID", SERVICEINSTANCEID);
        SessionEvent.SETRANGE("Session ID", SESSIONID);
        IF SessionEvent.FINDLAST THEN BEGIN
            IF (SessionEvent.Comment <> '') THEN BEGIN
                SessionEvent.Comment := '';
                SessionEvent.MODIFY;
            END;
        END;

        //Ejecuto el proceso
        CLEARLASTERROR;
        recRef.OPEN(Rec.Table);
        recRef.GET(Rec.RecID);

        fRef := recRef.FIELD(1);
        IF (FORMAT(fRef.VALUE) = 'P00050') THEN ERROR('Pruebas de errores');

        CASE Rec.Operation OF
            Rec.Operation::Del:
                recRef.DELETE(TRUE);   //Si no puede ejecutar esto, cierra la sesi�n directamente
        END;
        recRef.CLOSE;



        //Si ha llego hasta aqu� es porque no hay errores en el proceso
        QMSessionTableData.GET(SESSIONID);
        QMSessionTableData.ResultOk := TRUE;                         //JAV 20/09/22: - QB 1.00.06 La sesi�n termin� correctamente, pero cuidado que puedo dar el error luego por no procesar
        QMSessionTableData.MODIFY(FALSE);

        IF (NOT Rec.Process) THEN
            //Si no estamos procesando doy un error para evitar que se guarden los datos
            ERROR(QMSessionTableData.TxtNoError)
        ELSE BEGIN
            //Estamos procesando, guardo que no hay errores
            SessionEvent.RESET;
            SessionEvent.SETASCENDING("Event Datetime", TRUE);
            SessionEvent.SETRANGE("User ID", USERID);
            SessionEvent.SETRANGE("Server Instance ID", SERVICEINSTANCEID);
            SessionEvent.SETRANGE("Session ID", SESSIONID);
            IF SessionEvent.FINDLAST THEN BEGIN
                SessionEvent.Comment := QMSessionTableData.TxtNoError;
                SessionEvent.MODIFY;
            END;
        END;



    END;


    /*BEGIN
    /*{
          JAV 12/02/22: - QB 1.00.06 Mejoras en todo el proceso de gesti�n, para intentar evitar problemas con timeouts
        }
    END.*/
}









