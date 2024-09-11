Codeunit 50000 "QuoSync Send Data"
{


    Permissions = TableData 454 = rim,
                TableData 50002 = r,
                TableData 7000002 = m;
    trigger OnRun()
    BEGIN
    END;

    VAR
        T: Record 50000;

    LOCAL PROCEDURE "------------------------------------- Eventos para crear los registros en el log"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Codeunit, 49, OnAfterOnDatabaseInsert, '', true, true)]
    LOCAL PROCEDURE OnAfterOnDatabaseInsert(RecRef: RecordRef);
    BEGIN
        //Al insertar un registro en cualquier tabla
        InsLog(T.Type::New, RecRef, RecRef.RECORDID, FALSE);
    END;

    [EventSubscriber(ObjectType::Codeunit, 49, OnAfterOnDatabaseModify, '', true, true)]
    LOCAL PROCEDURE OnAfterOnDatabaseModify(RecRef: RecordRef);
    BEGIN
        //Al modificar un registro en cualquier tabla
        InsLog(T.Type::Modification, RecRef, RecRef.RECORDID, FALSE);
    END;

    [EventSubscriber(ObjectType::Codeunit, 49, OnAfterOnDatabaseDelete, '', true, true)]
    LOCAL PROCEDURE OnAfterOnDatabaseDelete(RecRef: RecordRef);
    BEGIN
        //Al eliminar un registro en cualquier tabla
        InsLog(T.Type::Delete, RecRef, RecRef.RECORDID, FALSE);
    END;

    [EventSubscriber(ObjectType::Codeunit, 49, OnAfterOnDatabaseRename, '', true, true)]
    LOCAL PROCEDURE OnAfterOnDatabaseRename(RecRef: RecordRef; xRecRef: RecordRef);
    BEGIN
        //Al renombrar un registro en cualquier tabla
        InsLog(T.Type::Rename, RecRef, xRecRef.RECORDID, FALSE);
    END;

    [EventSubscriber(ObjectType::Table, 50003, OnAfterInsertEvent, '', true, true)]
    LOCAL PROCEDURE OnAfterInsertEvent_QuoSyncTables(VAR Rec: Record 50003; RunTrigger: Boolean);
    VAR
        RecRef: RecordRef;
        RecID: RecordID;
    BEGIN
        //Inserto un registro en la tabla para sincronizar
        IF (RunTrigger) THEN BEGIN
            RecID := Rec.RECORDID;
            RecRef.OPEN(RecID.TABLENO);
            RecRef.GET(Rec.RECORDID);
            InsLog(T.Type::New, RecRef, Rec.RECORDID, TRUE);
            RecRef.CLOSE;
        END;
    END;

    [EventSubscriber(ObjectType::Table, 50003, OnAfterModifyEvent, '', true, true)]
    LOCAL PROCEDURE OnAfterModifyEvent_QuoSyncTables(VAR Rec: Record 50003; VAR xRec: Record 50003; RunTrigger: Boolean);
    VAR
        RecRef: RecordRef;
        RecID: RecordID;
    BEGIN
        //Modifico un registro en la tabla para sincronizar
        IF (RunTrigger) THEN BEGIN
            RecID := Rec.RECORDID;
            RecRef.OPEN(RecID.TABLENO);
            RecRef.GET(Rec.RECORDID);
            InsLog(T.Type::Modification, RecRef, Rec.RECORDID, TRUE);
            RecRef.CLOSE;
        END;
    END;

    [EventSubscriber(ObjectType::Table, 50003, OnAfterDeleteEvent, '', true, true)]
    LOCAL PROCEDURE OnAfterDeleteEvent_QuoSyncTables(VAR Rec: Record 50003; RunTrigger: Boolean);
    VAR
        RecRef: RecordRef;
        RecID: RecordID;
    BEGIN
        //Borro un registro en la tabla para sincronizar
        IF (RunTrigger) THEN BEGIN
            RecID := Rec.RECORDID;
            RecRef.OPEN(RecID.TABLENO);
            InsLog(T.Type::Delete, RecRef, Rec.RECORDID, TRUE);
            RecRef.CLOSE;
        END;
    END;

    [EventSubscriber(ObjectType::Table, 50003, OnAfterRenameEvent, '', true, true)]
    LOCAL PROCEDURE OnAfterRenameEvent_QuoSyncTables(VAR Rec: Record 50003; VAR xRec: Record 50003; RunTrigger: Boolean);
    VAR
        RecRef: RecordRef;
        RecID: RecordID;
    BEGIN
        //Se ha cambiado un registro en la tabla para sincronizar
        IF (RunTrigger) THEN BEGIN
            RecID := Rec.RECORDID;
            RecRef.OPEN(RecID.TABLENO);
            RecRef.GET(Rec.RECORDID);
            InsLog(T.Type::Rename, RecRef, xRec.RECORDID, TRUE);
            RecRef.CLOSE;
        END;
    END;

    [EventSubscriber(ObjectType::Page, 50003, OnBeforeActionEvent, SyncAll, true, true)]
    LOCAL PROCEDURE OnBeforeActionEvent_SyncAll(VAR Rec: Record 50003);
    VAR
        Txt001: TextConst ENU = 'This action will take all the records from the table to the destination company. Do you really want to?', ESP = 'Esta acci�n llevar� todos los registros de la tabla a la empresa de destino �Realmente desea hacerlo?';
        RecRef: RecordRef;
        void: RecordID;
    BEGIN
        //Se fuerza la sincronziaci�n de todos los registros entre las dos empresas
        IF CONFIRM(Txt001, FALSE) THEN BEGIN
            CLEAR(void);
            RecRef.OPEN(Rec.Table);

            //Sincronizar todos los registros de la tabla, primero env�o un registro que indica sincronizar todo
            InsLog(T.Type::SyncIni, RecRef, void, FALSE);

            //Ahora env�o todos los registros de la tabla
            RecRef.RESET;
            IF (RecRef.FINDSET(FALSE)) THEN
                REPEAT
                    InsLog(T.Type::SyncReg, RecRef, RecRef.RECORDID, FALSE);
                UNTIL (RecRef.NEXT = 0);

            //Indico al final que he terminado de enviar registros
            InsLog(T.Type::SyncEnd, RecRef, void, FALSE);

            RecRef.CLOSE;
        END;
    END;

    LOCAL PROCEDURE "------------------------------------- Procesos para crear los registros en el log"();
    BEGIN
    END;

    PROCEDURE InsLog(pType: Integer; pRR: RecordRef; pID: RecordID; pInternal: Boolean);
    VAR
        QuoSyncSetup: Record 50002;
        QuoSyncTables: Record 50003;
        QuoSyncSend1: Record 50000;
        QuoSyncSend2: Record 50000;
    BEGIN
        //Insertar el registro en la tabla de env�os

        //Busco la configuraci�n general
        IF (NOT ReadConf(QuoSyncSetup)) THEN
            EXIT;

        //Miro la tabla a sincronizar en la configuraci�n
        IF (NOT pInternal) THEN BEGIN
            //Miro que la tabla est� incluida
            IF NOT QuoSyncTables.GET(pRR.NUMBER, 0) THEN
                EXIT;

            //Miro que la direcci�n sea correcta
            IF (QuoSyncTables.Direction = QuoSyncTables.Direction::Master) AND (QuoSyncSetup."Company Type" = QuoSyncSetup."Company Type"::Sync) OR
               (QuoSyncTables.Direction = QuoSyncTables.Direction::Sync) AND (QuoSyncSetup."Company Type" = QuoSyncSetup."Company Type"::Master) THEN
                EXIT;
        END;

        //Creo el registro
        QuoSyncSend1.INIT;
        QuoSyncSend1.Origin := COMPANYNAME;
        QuoSyncSend1.Destination := QuoSyncSetup."Destination Company";
        QuoSyncSend1."Date Send" := CURRENTDATETIME;
        QuoSyncSend1.Table := pRR.NUMBER;
        QuoSyncSend1.Type := pType;
        QuoSyncSend1.Key := pID;

        CASE pType OF
            T.Type::New:
                BEGIN
                    //Si es nuevo no pueden existir registro anteriores, solo damos de alta el XML
                    AddXML(QuoSyncSend1, pRR);
                END;
            T.Type::Modification:
                BEGIN
                    //Si modifico, elimino los registros de modificaci�n que existan que no se van a usar ya
                    QuoSyncSend2.RESET;
                    QuoSyncSend2.SETCURRENTKEY(QuoSyncSend2.Received, QuoSyncSend2.Origin, QuoSyncSend2.Destination, QuoSyncSend2.Table, QuoSyncSend2.Type, QuoSyncSend2.Key);
                    QuoSyncSend2.SETRANGE(QuoSyncSend2.Received, FALSE);
                    QuoSyncSend2.SETRANGE(QuoSyncSend2.Origin, COMPANYNAME);
                    QuoSyncSend2.SETRANGE(QuoSyncSend2.Destination, QuoSyncSetup."Destination Company");
                    QuoSyncSend2.SETRANGE(QuoSyncSend2.Table, QuoSyncSend1.Table);
                    QuoSyncSend2.SETRANGE(QuoSyncSend2.Type, T.Type::Modification);
                    QuoSyncSend2.SETRANGE(QuoSyncSend2.Key, QuoSyncSend1.Key);
                    QuoSyncSend2.DELETEALL;

                    AddXML(QuoSyncSend1, pRR);
                END;
            T.Type::Delete:
                BEGIN
                    //Si es una baja, elimino los registros de alta o modificaci�n que existan que no se van a usar ya
                    QuoSyncSend2.RESET;
                    QuoSyncSend2.SETCURRENTKEY(QuoSyncSend2.Received, QuoSyncSend2.Origin, QuoSyncSend2.Destination, QuoSyncSend2.Table, QuoSyncSend2.Type, QuoSyncSend2.Key);
                    QuoSyncSend2.SETRANGE(QuoSyncSend2.Received, FALSE);
                    QuoSyncSend2.SETRANGE(QuoSyncSend2.Origin, COMPANYNAME);
                    QuoSyncSend2.SETRANGE(QuoSyncSend2.Destination, QuoSyncSetup."Destination Company");
                    QuoSyncSend2.SETRANGE(QuoSyncSend2.Table, QuoSyncSend1.Table);
                    QuoSyncSend2.SETRANGE(QuoSyncSend2.Type, T.Type::New, T.Type::Modification);
                    QuoSyncSend2.SETRANGE(QuoSyncSend2.Key, QuoSyncSend1.Key);
                    QuoSyncSend2.DELETEALL;
                END;
            T.Type::Rename:
                BEGIN
                    //Si renombro, elimino los registros de modificaci�n que existan que no se van a usar ya
                    QuoSyncSend2.RESET;
                    QuoSyncSend2.SETRANGE(QuoSyncSend2.Origin, COMPANYNAME);
                    QuoSyncSend2.SETCURRENTKEY(QuoSyncSend2.Received, QuoSyncSend2.Origin, QuoSyncSend2.Destination, QuoSyncSend2.Table, QuoSyncSend2.Type, QuoSyncSend2.Key);
                    QuoSyncSend2.SETRANGE(QuoSyncSend2.Received, FALSE);
                    QuoSyncSend2.SETRANGE(QuoSyncSend2.Destination, QuoSyncSetup."Destination Company");
                    QuoSyncSend2.SETRANGE(QuoSyncSend2.Table, QuoSyncSend1.Table);
                    QuoSyncSend2.SETRANGE(QuoSyncSend2.Type, T.Type::Modification);
                    QuoSyncSend2.SETRANGE(QuoSyncSend2.Key, QuoSyncSend1.Key);
                    QuoSyncSend2.DELETEALL;

                    AddXML(QuoSyncSend1, pRR);
                END;
            T.Type::SyncReg:
                BEGIN
                    //Si sincronizo todo, elimino los registros que existan de cualquier tipo pues no se van a usar ya
                    QuoSyncSend2.RESET;
                    QuoSyncSend2.SETCURRENTKEY(QuoSyncSend2.Received, QuoSyncSend2.Origin, QuoSyncSend2.Destination, QuoSyncSend2.Table, QuoSyncSend2.Type, QuoSyncSend2.Key);
                    QuoSyncSend2.SETRANGE(QuoSyncSend2.Received, FALSE);
                    QuoSyncSend2.SETRANGE(QuoSyncSend2.Origin, COMPANYNAME);
                    QuoSyncSend2.SETRANGE(QuoSyncSend2.Destination, QuoSyncSetup."Destination Company");
                    QuoSyncSend2.SETRANGE(QuoSyncSend2.Table, QuoSyncSend1.Table);
                    QuoSyncSend2.DELETEALL;

                    AddXML(QuoSyncSend1, pRR);
                END;
        END;

        QuoSyncSend1.INSERT(TRUE);
    END;

    LOCAL PROCEDURE AddXML(VAR QuoSyncSend: Record 50000; pRR: RecordRef);
    VAR
        QuoSyncTables: Record 50003;
        XMLBuffer: Record 1235 TEMPORARY;
        TempBlob: codeunit "Temp Blob";
        XMLBufferReader: Codeunit 1239;
        RR: RecordRef;
        FR: FieldRef;
        XMLtext: Text;
        i: Integer;
        nfields: Integer;
        Valor: Text;
        process: Boolean;
        Blob: OutStream;
        InStr: InStream;
    BEGIN
        //Generar un XML a partir del alta de un registro, solo pasamos los campos que tengan un valor
        nfields := pRR.FIELDCOUNT;

        XMLBuffer.AddGroupElement('Export');
        XMLBuffer.AddAttribute('Table', FORMAT(RR.NUMBER));

        i := 0;
        REPEAT
            i += 1;
            FR := pRR.FIELDINDEX(i);
            process := TRUE;

            //No proceso los campos no sincronizables
            IF QuoSyncTables.GET(pRR.NUMBER, FR.NUMBER) THEN
                process := QuoSyncTables."Not Sync" = FALSE;
            //No procesar campos de estos tipos
            IF (UPPERCASE(FORMAT(FR.TYPE)) IN ['BLOB', 'MEDIA']) THEN
                process := FALSE;
            //Me salto los campos calculados o los que sean filtros
            IF (UPPERCASE(FORMAT(FR.CLASS)) <> 'NORMAL') THEN
                process := FALSE;

            IF (process) THEN BEGIN
                Valor := DELCHR(FORMAT(FR.VALUE), '<>', ' ');
                CASE UPPERCASE(FORMAT(FR.TYPE)) OF
                    'INTEGER', 'DECIMAL':
                        IF (Valor = FORMAT(0)) THEN
                            Valor := '';
                    'BOOLEAN':
                        IF (Valor = FORMAT(FALSE)) THEN
                            Valor := '';
                    'OPTION':
                        IF (Valor = COPYSTR(FR.OPTIONCAPTION, 1, STRLEN(Valor))) THEN
                            Valor := '';
                END;

                IF (Valor <> '') THEN BEGIN
                    XMLBuffer.AddGroupElement('Field');
                    XMLBuffer.AddAttribute('No', FORMAT(FR.NUMBER));
                    XMLBuffer.AddAttribute('Value', Valor);
                    XMLBuffer.GetParent;
                END;
            END;
        UNTIL (i = nfields);

        XMLBufferReader.SaveToTempBlob(TempBlob, XMLBuffer);
        //QuoSyncSend.XML := TempBlob.Blob;
        TempBlob.CreateInStream(InStr, TextEncoding::Windows);
        Instr.Read(QuoSyncSend.XML);
        QuoSyncSend."XML Size" := QuoSyncSend.XML.LENGTH;
    END;

    LOCAL PROCEDURE "------------------------------------- Procesos auxiliares"();
    BEGIN
    END;

    LOCAL PROCEDURE ReadConf(VAR QuoSyncSetup: Record 50002): Boolean;
    BEGIN
        //Busco la configuraci�n general
        IF (NOT QuoSyncSetup.GET) THEN
            EXIT(FALSE);
        IF (NOT QuoSyncSetup.Active) THEN
            EXIT(FALSE);

        EXIT(TRUE);
    END;


    /*BEGIN
    /*{
          JAV 27/09/20: - QuoSync 1.00.00 Sincronizar datos entre empresas, generar datos para el env�o
          JAV 03/10/20: - QuoSync 1.00.01 Se a�aden acciones para enviar todos y sincronizar las propias tablas
        }
    END.*/
}









