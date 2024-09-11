Codeunit 50001 "QuoSync Receive Data"
{


    Permissions = TableData 454 = rim,
                TableData 7000002 = m,
                TableData 50002 = r;
    trigger OnRun()
    BEGIN
    END;

    VAR
        T: Record 50000;
        CONECTIONID: TextConst ESP = 'QuoSync';
        AZURE: TextConst ESP = '.database.windows.net';
        Txt00: TextConst ENU = 'No configuration for QuoSync', ESP = 'No hay configuraci�n para QuoSync';
        Txt01: TextConst ENU = 'No configuration for QuoSync', ESP = 'QuoSync no activo';
        Txt02: TextConst ENU = 'Connection is not possible for internal type', ESP = 'Conexi�n no es posible para el tipo interno';
        Txt03: TextConst ENU = 'Connecting with the external system......', ESP = 'Conectando con el sistema externo......';
        Txt04: TextConst ENU = 'Conected OK', ESP = 'Conectado';
        Txt05: TextConst ENU = 'Unable to establish connection, error reported:\%1', ESP = 'No se puede establecer la conexi�n, error reportado:\%1';

    LOCAL PROCEDURE "------------------------------------- Para procesar registros desde el log"();
    BEGIN
    END;

    PROCEDURE ProcessLog();
    VAR
        QuoSyncReceived: Record 50001;
        RR: RecordRef;
        tmpRR: RecordRef;
        result: Boolean;
    BEGIN
        //Procesar los registros recibidos del log
        QuoSyncReceived.RESET;
        QuoSyncReceived.SETRANGE(Destination, COMPANYNAME);
        QuoSyncReceived.SETRANGE(Procesed, FALSE);
        IF (QuoSyncReceived.FINDSET(TRUE)) THEN
            REPEAT
                RR.OPEN(QuoSyncReceived.Table);
                QuoSyncReceived.Procesed := TRUE;
                QuoSyncReceived."Date Procesed" := CURRENTDATETIME;
                result := ProcessReg(QuoSyncReceived, RR, tmpRR);
                IF (result) THEN BEGIN
                    //Si se proces�o correctamente el registro, lanzo el evento despu�s de guardar el registro
                    OnAfterImportData(QuoSyncReceived.Type, RR);
                END ELSE BEGIN
                    QuoSyncReceived."Whit Error" := TRUE;
                    QuoSyncReceived."Text Error" := GETLASTERRORTEXT;
                    CLEARLASTERROR;
                END;
                QuoSyncReceived.MODIFY;
                RR.CLOSE;
            UNTIL (QuoSyncReceived.NEXT = 0);
    END;

    LOCAL PROCEDURE ProcessReg(VAR QuoSyncReceived: Record 50001; VAR RR: RecordRef; VAR tmpRR: RecordRef): Boolean;
    VAR
        QuoSyncSendData: Codeunit 50000;
        xRR: RecordRef;
        deleted: Boolean;
    BEGIN
        //Procesar un registro recibido, retorna TRUE si hay error, FALSE si no lo hay
        CASE QuoSyncReceived.Type OF

            // Procesos para las acciones generales de alta, modificaci�n, baja y renombrar

            T.Type::New:
                BEGIN
                    RR.INIT;
                    IF (NOT ProcessXML(QuoSyncReceived, RR)) THEN
                        EXIT(FALSE);
                    EXIT(RR.INSERT(FALSE));
                END;
            T.Type::Modification:
                BEGIN
                    RR.GET(QuoSyncReceived.Key);
                    IF (NOT ProcessXML(QuoSyncReceived, RR)) THEN
                        EXIT(FALSE);
                    EXIT(RR.MODIFY(FALSE));
                END;
            T.Type::Delete:
                BEGIN
                    RR.GET(QuoSyncReceived.Key);
                    EXIT(RR.DELETE(FALSE));
                END;
            T.Type::Rename:
                BEGIN
                    //Borro el registro existente
                    deleted := FALSE;
                    xRR.OPEN(QuoSyncReceived.Table);
                    IF (xRR.GET(QuoSyncReceived.Key)) THEN
                        deleted := xRR.DELETE(TRUE);
                    xRR.CLOSE;
                    IF NOT deleted THEN
                        EXIT(FALSE);

                    //Doy de alta uno nuevo
                    RR.INIT;
                    IF (NOT ProcessXML(QuoSyncReceived, RR)) THEN
                        EXIT(FALSE);
                    EXIT(RR.INSERT(TRUE));
                END;

            // Procesos para las acciones de sincronizar todos los registros de una tabla

            T.Type::SyncIni:
                BEGIN
                    tmpRR.OPEN(QuoSyncReceived.Table, TRUE);
                END;
            T.Type::SyncReg:
                BEGIN
                    //Si existe el registro lo modifico, si no lo tengo que crear
                    IF (RR.GET(QuoSyncReceived.Key)) THEN BEGIN
                        IF (NOT ProcessXML(QuoSyncReceived, RR)) THEN
                            EXIT(FALSE);
                        RR.MODIFY(FALSE);
                    END ELSE BEGIN
                        RR.INIT;
                        IF (NOT ProcessXML(QuoSyncReceived, RR)) THEN
                            EXIT(FALSE);
                        RR.INSERT(FALSE);
                    END;
                    //Inserto el registro en la tabla temporal
                    tmpRR := RR;
                    tmpRR.INSERT;
                END;
            T.Type::SyncEnd:
                BEGIN
                    //Tengo que recorrer la tabla de nuevo para enviar al origen los registros que no han llegado desde el origen
                    RR.OPEN(tmpRR.NUMBER);
                    IF (RR.FINDSET(FALSE)) THEN
                        REPEAT
                            IF (NOT tmpRR.GET(RR.RECORDID)) THEN BEGIN
                                QuoSyncSendData.InsLog(T.Type::New, RR, RR.RECORDID, FALSE);
                            END;
                        UNTIL (RR.NEXT = 0);
                    RR.CLOSE;
                    tmpRR.CLOSE;
                END;
        END;
    END;

    [TryFunction]
    LOCAL PROCEDURE ProcessXML(VAR QuoSyncReceived: Record 50001; VAR RR: RecordRef);
    VAR
        XMLBuffer: Record 1235 TEMPORARY;
        TempBlob: codeunit "Temp Blob";
        Blob: OutStream;
        InStr: InStream;
        XMLBufferReader: Codeunit 1239;
        FR: FieldRef;
        XMLtext: Text;
        i: Integer;
        nfields: Integer;
        Valor: Text;
        process: Boolean;
        txtXML: Text;
        Value: Text;
        tField: Text;
        nField: Integer;
        cancel: Boolean;
        txtMessage: Text;
    BEGIN
        //Rellenar un registro desde el XML recibido
        QuoSyncReceived.CALCFIELDS(XML);
        //TempBlob.Blob := QuoSyncReceived.XML;
        TempBlob.CreateOutStream(Blob, TextEncoding::Windows);
        Blob.Write(QuoSyncReceived.XML);
        //txtXML := TempBlob.GetXMLAsText;
        TempBlob.CreateInStream(InStr, TextEncoding::Windows);
        Instr.Read(txtXML);
        XMLBuffer.LoadFromText(txtXML);

        XMLBuffer.RESET;
        XMLBuffer.SETRANGE(Name, 'Field');
        IF (XMLBuffer.FINDSET) THEN
            REPEAT
                IF (XMLBuffer.Type = XMLBuffer.Type::Element) THEN BEGIN
                    tField := XMLBuffer.GetAttributeValue('No');
                    Value := XMLBuffer.GetAttributeValue('Value');
                    EVALUATE(nField, tField);
                    FR := RR.FIELD(nField);
                    WriteField(FR, Value);
                END;
            UNTIL (XMLBuffer.NEXT = 0);

        //Una vez procesado el registro, lanzo el evento antes de guardarselo
        OnBeforeImportData(RR, cancel, txtMessage);
        IF (cancel) AND (txtMessage <> '') THEN
            ERROR(txtMessage);
    END;

    [TryFunction]
    LOCAL PROCEDURE WriteField(VAR FR: FieldRef; Value: Text);
    VAR
        OutlookSynchTypeConv: Codeunit 5302;
        NumericValue: Decimal;
        DateValue: Date;
        DateTimeValue: DateTime;
        BoolValue: Boolean;
        OptValue: Option;
        GUIDValue: GUID;
        DateFormulaValue: DateFormula;
    BEGIN
        //Cambia el valor de un campo a partir del recibido en el XML
        CASE UPPERCASE(FORMAT(FR.TYPE)) OF
            'INTEGER', 'DECIMAL':
                BEGIN
                    EVALUATE(NumericValue, Value);
                    IF (FORMAT(NumericValue) <> FORMAT(FR.VALUE)) THEN
                        FR.VALIDATE(NumericValue);
                END;
            'DATE':
                BEGIN
                    EVALUATE(DateValue, Value);
                    IF (FORMAT(DateValue) <> FORMAT(FR.VALUE)) THEN
                        FR.VALIDATE(DateValue);
                END;
            'DATETIME':
                BEGIN
                    EVALUATE(DateTimeValue, Value);
                    IF (FORMAT(DateTimeValue) <> FORMAT(FR.VALUE)) THEN
                        FR.VALIDATE(DateTimeValue);
                END;
            'DATEFORMULA':
                BEGIN
                    EVALUATE(DateFormulaValue, Value);
                    IF (FORMAT(DateFormulaValue) <> FORMAT(FR.VALUE)) THEN
                        FR.VALIDATE(DateFormulaValue);
                END;
            'BOOLEAN':
                BEGIN
                    EVALUATE(BoolValue, Value);
                    IF (FORMAT(BoolValue) <> FORMAT(FR.VALUE)) THEN
                        FR.VALIDATE(BoolValue);
                END;
            'TEXT', 'CODE':
                BEGIN
                    IF (Value <> FORMAT(FR.VALUE)) THEN
                        FR.VALIDATE(COPYSTR(Value, 1, FR.LENGTH));
                END;
            'OPTION':
                BEGIN
                    OptValue := OutlookSynchTypeConv.TextToOptionValue(Value, FR.OPTIONCAPTION);
                    IF (FORMAT(OptValue) <> FORMAT(FR.VALUE)) THEN
                        FR.VALIDATE(OptValue);
                END;
            'GUID':
                BEGIN
                    EVALUATE(GUIDValue, Value);
                    IF (FORMAT(GUIDValue) <> FORMAT(FR.VALUE)) THEN
                        FR.VALIDATE(GUIDValue);
                END;
            'BLOB', 'MEDIA':
                BEGIN
                    //Estos tipos de campos no los puedo procesar, me los salto
                END;
            ELSE        //Otros campos, lo intento como texto directamente
              BEGIN
                IF (FORMAT(Value) <> FORMAT(FR.VALUE)) THEN
                    FR.VALIDATE(COPYSTR(Value, 1, FR.LENGTH));
            END;
        END;
    END;

    LOCAL PROCEDURE "------------------------------------- Recibir de un sistema Externo"();
    BEGIN
    END;

    PROCEDURE ReceiveDataFromCompany(pFrom: Integer);
    VAR
        QuoSyncSetup: Record 50002;
        QuoSyncSendExternal: Record 50004;
        QuoSyncSend: Record 50000;
        QuoSyncReceived: Record 50001;
        txtError: Text;
    BEGIN
        //Recibir los datos desde otra empresa, interna o externa
        IF (NOT ReadConf(QuoSyncSetup, txtError)) THEN
            ERROR(txtError);

        IF (QuoSyncSetup."Connection Type" = QuoSyncSetup."Connection Type"::Internal) THEN BEGIN
            //Recibir de una empresa dentro de la misma BBDD
            QuoSyncSend.RESET;
            QuoSyncSend.SETCURRENTKEY(QuoSyncSend.Received, QuoSyncSend.Origin, QuoSyncSend.Destination, QuoSyncSend.Table, QuoSyncSend.Type, QuoSyncSend.Key);
            QuoSyncSend.SETRANGE(QuoSyncSend.Destination, COMPANYNAME);
            IF (pFrom = 0) THEN
                QuoSyncSend.SETRANGE(QuoSyncSend.Received, FALSE)
            ELSE
                QuoSyncSend.SETFILTER(QuoSyncSend."Entry No", '>=%1', pFrom);
            IF (QuoSyncSend.FINDSET(TRUE)) THEN
                REPEAT
                    QuoSyncSend.CALCFIELDS(QuoSyncSend.XML);
                    QuoSyncSend.Received := TRUE;
                    QuoSyncSend."Date Received" := CURRENTDATETIME;

                    QuoSyncReceived.TRANSFERFIELDS(QuoSyncSend);
                    QuoSyncReceived."Origin Entry No" := QuoSyncSend."Entry No";
                    QuoSyncReceived.INSERT(TRUE);

                    QuoSyncSend."Destination Entry No" := QuoSyncReceived."Entry No";
                    QuoSyncSend.MODIFY;
                UNTIL (QuoSyncSend.NEXT = 0);
        END ELSE BEGIN
            //Recibir de una empresa de otra BBDD
            IF (TryConnect) THEN BEGIN
                QuoSyncSendExternal.RESET;
                QuoSyncSendExternal.SETCURRENTKEY("Date Send", Origin, Destination, Table, Type, Key);
                QuoSyncSendExternal.SETRANGE(Destination, COMPANYNAME);
                IF (pFrom = 0) THEN
                    QuoSyncSendExternal.SETRANGE(Received, FALSE)
                ELSE
                    QuoSyncSendExternal.SETFILTER("Entry No", '>=%1', pFrom);
                IF (QuoSyncSendExternal.FINDSET(TRUE)) THEN
                    REPEAT
                        QuoSyncSendExternal.CALCFIELDS(XML);
                        QuoSyncSendExternal.Received := TRUE;
                        QuoSyncSendExternal."Date Received" := CURRENTDATETIME;

                        QuoSyncReceived.TRANSFERFIELDS(QuoSyncSendExternal);
                        QuoSyncReceived."Origin Entry No" := QuoSyncSendExternal."Entry No";
                        QuoSyncReceived.INSERT(TRUE);

                        QuoSyncSendExternal."Destination Entry No" := QuoSyncReceived."Entry No";
                        QuoSyncSendExternal.MODIFY;
                    UNTIL (QuoSyncSendExternal.NEXT = 0);
            END;
        END;
    END;

    PROCEDURE DeleteObsoleteRecords(pErrors: Boolean);
    VAR
        QuoSyncSetup: Record 50002;
        QuoSyncSendExternal: Record 50004;
        QuoSyncSend: Record 50000;
        QuoSyncReceived: Record 50001;
        PriorTo: DateTime;
        txtError: Text;
    BEGIN
        //Eliminar los datos obsoletos en los registros de intermcabio
        IF (NOT ReadConf(QuoSyncSetup, txtError)) THEN
            EXIT;

        IF (QuoSyncSetup."Delete after days" = 0) THEN
            EXIT;

        PriorTo := CREATEDATETIME(CALCDATE(STRSUBSTNO('-%1D', QuoSyncSetup."Delete after days"), TODAY), TIME);

        //Elimino de las tablas de env�o
        IF (QuoSyncSetup."Connection Type" = QuoSyncSetup."Connection Type"::Internal) THEN BEGIN
            //Eliminar de una empresa dentro de la misma BBDD
            QuoSyncSend.RESET;
            QuoSyncSend.SETCURRENTKEY(QuoSyncSend.Received, QuoSyncSend.Origin, QuoSyncSend.Destination, QuoSyncSend.Table, QuoSyncSend.Type, QuoSyncSend.Key);
            QuoSyncSend.SETRANGE(QuoSyncSend.Received, TRUE);
            QuoSyncSend.SETRANGE(QuoSyncSend.Destination, COMPANYNAME);
            QuoSyncSend.SETFILTER(QuoSyncSend."Date Received", '<%1', PriorTo);
            QuoSyncSend.DELETEALL;
        END ELSE BEGIN
            //Eliminar de una empresa de otra BBDD
            IF (TryConnect) THEN BEGIN
                QuoSyncSendExternal.RESET;
                QuoSyncSendExternal.SETCURRENTKEY("Date Send", Origin, Destination, Table, Type, Key);
                QuoSyncSendExternal.SETRANGE(Received, TRUE);
                QuoSyncSendExternal.SETRANGE(Destination, COMPANYNAME);
                QuoSyncSendExternal.SETFILTER("Date Received", '<%1', PriorTo);
                QuoSyncSendExternal.DELETEALL;
            END;
        END;

        //Elimino de las tablas de recepci�n
        QuoSyncReceived.RESET;
        QuoSyncReceived.SETCURRENTKEY(Procesed, Origin, Destination, Table, Type, Key);
        QuoSyncReceived.SETRANGE(Procesed, TRUE);
        QuoSyncReceived.SETRANGE(Destination, COMPANYNAME);
        QuoSyncReceived.SETFILTER("Date Received", '<%1', PriorTo);
        IF (NOT pErrors) THEN
            QuoSyncReceived.SETRANGE("Whit Error", FALSE);
        QuoSyncReceived.DELETEALL;
    END;

    PROCEDURE Connect(pMsg: Boolean; pError: Boolean): Boolean;
    VAR
        Window: Dialog;
        Result: Boolean;
    BEGIN
        //Establece la conexi�n con el sistema externo y retorna el resultado
        Window.OPEN(Txt03);
        Result := TryConnect;
        Window.CLOSE;

        IF (Result) AND (pMsg) THEN
            MESSAGE(Txt04);
        IF (NOT Result) AND (pError) THEN BEGIN
            ERROR(Txt05, GETLASTERRORTEXT);
            CLEARLASTERROR;
        END;

        EXIT(Result);
    END;

    [TryFunction]
    PROCEDURE TryConnect();
    VAR
        QuoSyncSetup: Record 50002;
        QuoSyncSendExternal: Record 50004;
        DatabaseConnectionString: Text;
        txtError: Text;
    BEGIN
        //Establece la conexi�n con el sistema externo
        IF (NOT ReadConf(QuoSyncSetup, txtError)) THEN
            ERROR(txtError);

        CASE QuoSyncSetup."Connection Type" OF
            QuoSyncSetup."Connection Type"::Internal:
                ERROR(Txt02);
            QuoSyncSetup."Connection Type"::Azure:
                BEGIN
                    DatabaseConnectionString := 'Server=%1%5;Initial Catalog=%2;User ID=%3;Password=%4;';
                    QuoSyncSetup.Server := DELCHR(QuoSyncSetup.Server, '>', AZURE); //Por si ya est� puesto en la conexi�n
                END;
            QuoSyncSetup."Connection Type"::SQL:
                IF (QuoSyncSetup.Security = QuoSyncSetup.Security::Integrated) THEN
                    DatabaseConnectionString := 'Data Source=%1;Initial Catalog=%2;Integrated Security=SSPI;';    //Trusted_Connection=yes;
            ELSE
                DatabaseConnectionString := 'Data Source=%1;Initial Catalog=%2;User ID=%3;Password=%4;';
        END;

        DatabaseConnectionString := STRSUBSTNO(DatabaseConnectionString, QuoSyncSetup.Server, QuoSyncSetup.Database, QuoSyncSetup.User, QuoSyncSetup.Password, AZURE);

        IF HASTABLECONNECTION(TABLECONNECTIONTYPE::ExternalSQL, CONECTIONID) THEN
            UNREGISTERTABLECONNECTION(TABLECONNECTIONTYPE::ExternalSQL, CONECTIONID);

        REGISTERTABLECONNECTION(TABLECONNECTIONTYPE::ExternalSQL, CONECTIONID, DatabaseConnectionString);
        SETDEFAULTTABLECONNECTION(TABLECONNECTIONTYPE::ExternalSQL, CONECTIONID);

        QuoSyncSendExternal.RESET;
        IF (QuoSyncSendExternal.FINDFIRST) THEN;
    END;

    LOCAL PROCEDURE "------------------------------------- Procesos auxiliares"();
    BEGIN
    END;

    LOCAL PROCEDURE ReadConf(VAR QuoSyncSetup: Record 50002; VAR pTxt: Text): Boolean;
    BEGIN
        //Busco la configuraci�n general
        IF (NOT QuoSyncSetup.GET) THEN BEGIN
            pTxt := Txt00;
            EXIT(FALSE);
        END;

        IF (NOT QuoSyncSetup.Active) THEN BEGIN
            pTxt := Txt01;
            EXIT(FALSE);
        END;

        EXIT(TRUE);
    END;

    LOCAL PROCEDURE "------------------------------------- Eventos que se lanzan"();
    BEGIN
    END;

    //[Business]
    PROCEDURE OnBeforeImportData(VAR RecRef: RecordRef; VAR Cancel: Boolean; VAR txtMessage: Text);
    BEGIN
    END;

    //[Business]
    PROCEDURE OnAfterImportData(Type: Option "New","Modify","Delete","Rename"; RecRef: RecordRef);
    BEGIN
    END;


    /*BEGIN
    /*{
          JAV 27/09/20: - QuoSync 1.00.00 Sincronizar datos entre empresas, generar datos para el env�o
        }
    END.*/
}









