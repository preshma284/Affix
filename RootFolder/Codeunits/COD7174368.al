Codeunit 7174368 "QM MasterData Management"
{


    trigger OnRun()
    BEGIN
    END;

    VAR
        T: Option "New","Modification","Delete","Rename","SyncIni","SyncReg","SyncEnd";
        Operation: Option "CRE","UPD","DEL","REN";
        SyncType: Option "No","Master","Bi";
        Window: Dialog;
        Txt001: TextConst ESP = 'No puede sincronizar o actualizar el %1 mientras falten datos obligatorios';
        Txt020: TextConst ESP = 'No se puede crear un %1 desde esta empresa, solo desde la Master';
        Txt021: TextConst ESP = 'Solo puede cambiar el campo %1 de la tabla %2 en la empresa master';
        Txt022: TextConst ESP = 'No se puede borrar un %1 desde esta empresa, solo desde la Master';
        Txt023: TextConst ESP = 'No se puede renombrar un %1 desde esta empresa, solo desde la Master';
        Txt010: TextConst ESP = 'Solo altas,Todo';
        Txt011: TextConst ESP = 'Proceso finalizado';
        Txt012: TextConst ESP = 'Sincronizar� los datos de TODAS las empresas';
        Txt013: TextConst ESP = 'Sincronizar� la empresa %1';

    LOCAL PROCEDURE "------------------------------------------------------- Funciones Auxiliares"();
    BEGIN
    END;

    PROCEDURE SetMasterDataVisible(pTable: Integer): Boolean;
    VAR
        QMMasterDataTable: Record 7174392;
    BEGIN
        //Retorna si la sincronizaci�n MANUAL est� activada para esa tabla

        EXIT(FALSE); //De momento no se va a activar la sincronizaci�n manual

        IF (IsSyncActive) THEN BEGIN
            EXIT(QMMasterDataTable.GET(pTable));
        END;

        EXIT(FALSE);
    END;

    LOCAL PROCEDURE IsSyncActive(): Boolean;
    VAR
        QMMasterDataConfiguration: Record 7174390;
    BEGIN
        IF (QMMasterDataConfiguration.GET) THEN
            EXIT(QMMasterDataConfiguration."Synchronize between companies" AND (QMMasterDataConfiguration."Master Data Company" <> ''))
        ELSE
            EXIT(FALSE);
    END;

    PROCEDURE IsSyncActiveFromTable(pCompany: Text; pTable: Integer): Boolean;
    VAR
        QMMasterDataCompanieTable: Record 7174394;
        z: Boolean;
    BEGIN
        //JAV 22/04/22: - QM 1.00.00 Ver si est� activa la sincronizaci�n autom�tica para una tabla en la empresa actual
        IF (IsSyncActive) THEN
            IF QMMasterDataCompanieTable.GET(pCompany, pTable) THEN
                EXIT(QMMasterDataCompanieTable.Sync = QMMasterDataCompanieTable.Sync::Automatic);

        EXIT(FALSE);
    END;

    PROCEDURE IsPrimaryKeyField(rRef: RecordRef; FieldID: Integer): Boolean;
    VAR
        i: Integer;
    BEGIN
        //JAV 22/04/22: - MD 1.00.02 Retorna si un campo es parte de la clave primaria del registro
        FOR i := 1 TO rRef.KEYINDEX(1).FIELDCOUNT DO BEGIN
            IF rRef.KEYINDEX(1).FIELDINDEX(i).NUMBER = FieldID THEN
                EXIT(TRUE);
        END;

        EXIT(FALSE);
    END;

    LOCAL PROCEDURE "------------------------------------------------------- Funciones Auxiliares Locales"();
    BEGIN
    END;

    PROCEDURE GetMaster(): Text;
    VAR
        QMMasterDataConfiguration: Record 7174390;
    BEGIN
        IF (QMMasterDataConfiguration.GET) THEN
            EXIT(QMMasterDataConfiguration."Master Data Company")
        ELSE
            EXIT('');
    END;

    PROCEDURE IsMasterCompany(): Boolean;
    BEGIN
        //Retorna si estamos en la empresa Master
        EXIT((IsSyncActive) AND (CompanyIsMaster(COMPANYNAME)));
    END;

    PROCEDURE CompanyIsMaster(pCompany: Text): Boolean;
    BEGIN
        //Retorna si la empresa indicada es la Master
        EXIT(UPPERCASE(GetMaster) = UPPERCASE(pCompany));
    END;

    LOCAL PROCEDURE GetFieldNo(pTable: Integer; pName: Text; VAR pNro: Integer): Boolean;
    VAR
        rFields: Record 2000000041;
    BEGIN
        //A partir del nombre de un campo retorna su n�mero si lo encuentra
        rFields.RESET;
        rFields.SETRANGE(TableNo, pTable);
        IF (pName = '') THEN BEGIN              //Si no me dan nombre, retorna el primer campo de la tabla que siempre es la clave para estas tablas
            rFields.FINDFIRST;
            pNro := rFields."No.";
            EXIT(TRUE);
        END ELSE BEGIN                          //Retorna el campo con ese name en la tabla
            rFields.SETRANGE(FieldName, pName);
            IF (rFields.FINDFIRST) THEN BEGIN
                pNro := rFields."No.";
                EXIT(TRUE);
            END;
        END;
        EXIT(FALSE);
    END;

    LOCAL PROCEDURE "------------------------------------------------------ Eventos para la sincronizaci¢n Autom tica"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Codeunit, 49, OnAfterGetDatabaseTableTriggerSetup, '', true, true)]
    LOCAL PROCEDURE CU49_OnAfterGetDatabaseTableTriggerSetup(TableId: Integer; VAR OnDatabaseInsert: Boolean; VAR OnDatabaseModify: Boolean; VAR OnDatabaseDelete: Boolean; VAR OnDatabaseRename: Boolean);
    VAR
        QMMasterDataTable: Record 7174392;
    BEGIN
        //------------------------------------------------------------------------------------------------------------------------
        //JAV 22/04/22: - QM 1.00.01 subscribir las tablas que hay que sincronizar
        //------------------------------------------------------------------------------------------------------------------------

        IF (QMMasterDataTable.GET(TableId)) THEN BEGIN
            OnDatabaseInsert := TRUE;
            OnDatabaseModify := TRUE;
            OnDatabaseDelete := TRUE;
            OnDatabaseRename := TRUE;
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 49, OnAfterOnDatabaseInsert, '', true, true)]
    LOCAL PROCEDURE CU49_OnAfterOnDatabaseInsert(RecRef: RecordRef);
    BEGIN
        //JAV 22/04/22: - QM 1.00.00 Al insertar un registro en cualquier tabla
        IF (NOT IsSyncActive) OR (RecRef.CURRENTCOMPANY <> COMPANYNAME) THEN     //Solo proceso registros si est� activo y son de la empresa activa, as� las altas autom�ticas no afectan
            EXIT;

        IF (IsMasterCompany) THEN
            CreateFromCompany(GetMaster, RecRef)
        ELSE
            CreateFromWork(RecRef);
    END;

    [EventSubscriber(ObjectType::Codeunit, 49, OnAfterOnDatabaseModify, '', true, true)]
    LOCAL PROCEDURE CU49_OnAfterOnDatabaseModify(RecRef: RecordRef);
    VAR
        masterRecRef: RecordRef;
    BEGIN
        //JAV 22/04/22: - QM 1.00.00 Al modificar un registro en cualquier tabla
        IF (NOT IsSyncActive) OR (RecRef.CURRENTCOMPANY <> COMPANYNAME) THEN     //Solo proceso registros si est� activo y son de la empresa activa, as� las modificaciones autom�ticas no afectan
            EXIT;

        IF (IsMasterCompany) THEN
            UpdateFromCompany(GetMaster, RecRef, TRUE, TRUE)
        ELSE
            UpdateFromWork(RecRef, TRUE, TRUE);
    END;

    [EventSubscriber(ObjectType::Codeunit, 49, OnAfterOnDatabaseDelete, '', true, true)]
    LOCAL PROCEDURE CU49_OnAfterOnDatabaseDelete(RecRef: RecordRef);
    BEGIN
        //JAV 22/04/22: - QM 1.00.00 Al eliminar un registro en cualquier tabla
        IF (NOT IsSyncActive) OR (RecRef.CURRENTCOMPANY <> COMPANYNAME) THEN     //Solo proceso registros si est� activo y son de la empresa activa, as� las bajas autom�ticas no afectan
            EXIT;

        IF (IsMasterCompany) THEN
            DeleteFromMaster(RecRef)
        ELSE
            DeleteFromWork(RecRef);
    END;

    [EventSubscriber(ObjectType::Codeunit, 49, OnAfterOnDatabaseRename, '', true, true)]
    LOCAL PROCEDURE CU49_OnAfterOnDatabaseRename(RecRef: RecordRef; xRecRef: RecordRef);
    BEGIN
        //JAV 22/04/22: - QM 1.00.00 Al renombrar un registro en cualquier tabla
        IF (NOT IsSyncActive) OR (RecRef.CURRENTCOMPANY <> COMPANYNAME) THEN     //Solo proceso registros si est� activo y son de la empresa activa, as� el renombrar autom�tico no afecta
            EXIT;

        IF (IsMasterCompany) THEN
            RenameFromMaster(RecRef, xRecRef)
        ELSE
            RenameFromWork(RecRef);
    END;

    LOCAL PROCEDURE "------------------------------------------------------- Funciones para sincronizar datos de Configuraci¢n"();
    BEGIN
    END;

    PROCEDURE Configuration_UpdateAll();
    VAR
        Select: Integer;
        Company: Record 2000000006;
    BEGIN
        //---------------------------------------------------------------------------------------------------------------------------------------
        //JAV 25/04/22: - QM 1.00.02 Actualizar la configuraci�n de todas las empresas desde la master, salvo la propia master
        //---------------------------------------------------------------------------------------------------------------------------------------
        Select := 0;
        Company.RESET;
        IF (Company.FINDSET) THEN
            REPEAT
                IF (NOT CompanyIsMaster(Company.Name)) THEN BEGIN
                    Select := Configuration_UpdateCompany(Company.Name, Select, FALSE, Txt012);  //JAV 25/04/22: - QM 1.00.02 Solicitar el tipo de sincronizaci�n, completa o solo altas
                    IF (Select = 0) THEN
                        EXIT;
                END;
            UNTIL (Company.NEXT = 0);

        MESSAGE(Txt011);
    END;

    PROCEDURE Configuration_UpdateCompany(pCompany: Text; pSelect: Integer; pMsg: Boolean; pTxt: Text): Integer;
    VAR
        QMMasterDataConfTables: Record 7174389;
        QMMasterDataCompanies: Record 7174391;
        FunctionQB: Codeunit 7207272;
    BEGIN
        //---------------------------------------------------------------------------------------------------------------------------------------
        //JAV 25/04/22: - QM 1.00.02 Actualizar la configuraci�n de una sola empresas desde la master
        //---------------------------------------------------------------------------------------------------------------------------------------

        //JAV 25/04/22: - QM 1.00.02 Solicitar el tipo de sincronizaci�n, completa o solo altas
        IF (pSelect = 0) THEN BEGIN
            IF (pTxt = '') THEN
                pTxt := STRSUBSTNO(Txt013, pCompany);
            pSelect := STRMENU(Txt010, 0, pTxt);
            IF (pSelect = 0) THEN
                EXIT(0);
        END;

        Window.OPEN('Empresa:  #1###############################################################\' +
                    'Tabla:    #2###############################################################\' +
                    'Registro: #3###############################################################');

        Window.UPDATE(1, pCompany);

        //Sincronizar las tablas
        QMMasterDataConfTables.RESET;
        QMMasterDataConfTables.SETFILTER(Configuration, '<>%1', QMMasterDataConfTables.Configuration::No);
        IF (QMMasterDataConfTables.FINDSET) THEN
            REPEAT
                IF (QMMasterDataConfTables.Configuration = QMMasterDataConfTables.Configuration::Yes) OR
                   (FunctionQB.IsQuoBuildingCompany(pCompany) AND (QMMasterDataConfTables.Configuration = QMMasterDataConfTables.Configuration::OnlyQB)) THEN BEGIN
                    Window.UPDATE(2, FORMAT(QMMasterDataConfTables."Table No.") + ' ' + QMMasterDataConfTables."Table Name");
                    Configuration_UpdateReg(pCompany, QMMasterDataConfTables."Table No.", (pSelect = 2));
                END;
            UNTIL (QMMasterDataConfTables.NEXT = 0);

        IF (NOT QMMasterDataCompanies.GET(pCompany)) THEN BEGIN
            QMMasterDataCompanies.INIT;
            QMMasterDataCompanies.Company := pCompany;
            QMMasterDataCompanies.INSERT;
        END;

        QMMasterDataCompanies."Last Date Conf. Sync." := CURRENTDATETIME;
        QMMasterDataCompanies.MODIFY;

        Window.CLOSE;
        IF (pMsg) THEN
            MESSAGE(Txt011);

        EXIT(pSelect);
    END;

    LOCAL PROCEDURE Configuration_UpdateReg(pCompany: Text; pTable: Integer; pMod: Boolean);
    VAR
        rRef_Ori: RecordRef;
        rRef_Des: RecordRef;
        rID: RecordID;
    BEGIN
        //---------------------------------------------------------------------------------------------------------------------------------------
        //JAV 25/04/22: - QM 1.00.02 Actualizar una tabla de configuraci�n
        //---------------------------------------------------------------------------------------------------------------------------------------

        //Abro los RecordRef
        rRef_Ori.OPEN(pTable, FALSE, GetMaster);
        rRef_Des.OPEN(pTable, FALSE, pCompany);

        //Recorro la tabla y doy altas o modificaciones
        IF rRef_Ori.FINDFIRST THEN
            REPEAT
                rID := rRef_Ori.RECORDID;
                Window.UPDATE(3, FORMAT(rID));

                IF (NOT rRef_Des.GET(rID)) THEN BEGIN
                    //CPA 10/02/23: Q18908. Los campos no asignados no se inicializaban.BEGIN
                    rRef_Des.INIT;
                    //CPA 10/02/23: Q18908. Los campos no asignados no se inicializaban.END
                    Configuration_UpdateFields(rRef_Ori, rRef_Des, FALSE);
                    rRef_Des.INSERT(FALSE);
                END ELSE IF (pMod) THEN BEGIN
                    Configuration_UpdateFields(rRef_Ori, rRef_Des, TRUE);
                    rRef_Des.MODIFY(FALSE);
                END;
            UNTIL rRef_Ori.NEXT = 0;

        //Cierro los RecordRef
        rRef_Des.CLOSE;
        rRef_Ori.CLOSE;
    END;

    LOCAL PROCEDURE Configuration_UpdateFields(rOri: RecordRef; VAR rDes: RecordRef; pMod: Boolean);
    VAR
        QMMasterDataTableField: Record 7174393;
        FunctionQB: Codeunit 7207272;
        fRef_Ori: FieldRef;
        fRef_Des: FieldRef;
        CopyField: Boolean;
        i: Integer;
    BEGIN
        //---------------------------------------------------------------------------------------------------------------------------------------
        //JAV 25/04/22: - QM 1.00.02 Actualizar los campos un registro, siempre si es parte de la clave o estamos insertando, para modificaciones solo los campos seleccionados
        //---------------------------------------------------------------------------------------------------------------------------------------

        FOR i := 1 TO rOri.FIELDCOUNT DO BEGIN
            fRef_Ori := rOri.FIELDINDEX(i);
            fRef_Des := rDes.FIELDINDEX(i);

            CopyField := (NOT pMod);  //Por defecto copia en altas y no en modificaciones
            IF (pMod) THEN BEGIN
                IF QMMasterDataTableField.GET(rOri.NUMBER, fRef_Ori.NUMBER) THEN
                    CopyField := (QMMasterDataTableField.Syncronization = QMMasterDataTableField.Syncronization::Yes) OR
                                 ((FunctionQB.IsQuoBuildingCompany(rDes.CURRENTCOMPANY) AND (QMMasterDataTableField.Syncronization = QMMasterDataTableField.Syncronization::OnlyQB)));
            END;

            //JAV 19/05/22: - QM 1.00.05 Verificar que se pueda tratar el campo
            CopyField := CopyField AND CheckField(rOri.NUMBER, fRef_Ori.NUMBER);

            IF (IsPrimaryKeyField(rOri, i) OR CopyField) THEN
                fRef_Des.VALUE := fRef_Ori.VALUE;
        END;
    END;

    LOCAL PROCEDURE "Funciones para sincronizar registros autom ticamente desde master"();
    BEGIN
    END;

    LOCAL PROCEDURE CreateFromCompany(oCompany: Text; oRef: RecordRef);
    VAR
        QMMasterDataCompanieTable: Record 7174394;
        ok: Boolean;
    BEGIN
        //JAV 22/04/22: - QM 1.00.00 Crear nuevos registros desde la empresa Master y pasarlos a las de trabajo que lo tengan en autom�tico
        //JAV 22/07/22: - QM 1.00.05 Poder crear desde empresas que no sean la master

        //JAV 10/05/22: - QM 1.00.04 Si es la tabla de dimensiones y no sincronizamos la maestra no hay que controlar esto
        IF (SkipDimension(oRef)) THEN
            EXIT;

        QMMasterDataCompanieTable.RESET;
        //JAV 22/07/22: - QM 1.00.05 Poder crear desde empresas que no sean la master
        //QMMasterDataCompanieTable.SETFILTER(Company, '<>%1', GetMaster);
        QMMasterDataCompanieTable.SETFILTER(Company, '<>%1', oCompany);

        QMMasterDataCompanieTable.SETRANGE("Table No.", oRef.NUMBER);
        QMMasterDataCompanieTable.SETRANGE(Sync, QMMasterDataCompanieTable.Sync::Automatic);
        IF (QMMasterDataCompanieTable.FINDSET) THEN
            REPEAT
                IF (NOT ExistCompany(QMMasterDataCompanieTable.Company)) THEN  //Por si se ha eliminado la empresa pero sigue en la tabla de sincronizaci�n
                    QMMasterDataCompanieTable.DELETE
                ELSE
                    CopyRecord(QMMasterDataCompanieTable.Company, oRef, TRUE);
            UNTIL (QMMasterDataCompanieTable.NEXT = 0);
    END;

    LOCAL PROCEDURE UpdateFromCompany(oCompany: Text; oRef: RecordRef; pModify: Boolean; pMessages: Boolean);
    VAR
        QMMasterDataCompanieTable: Record 7174394;
    BEGIN
        //Sincronizar cambios de registros desde la empresa Master
        //      Si en destino se ha tocado pasar solo los campos a sincronizar a la empresa destino
        //      Si en destino no se ha tocado, sincronizar todos los campos con destino
        //JAV 22/07/22: - QM 1.00.05 Poder crear desde empresas que no sean la master

        //JAV 10/05/22: - QM 1.00.04 Si es la tabla de dimensiones y no sincronizamos la maestra no hay que controlar esto
        IF (SkipDimension(oRef)) THEN
            EXIT;

        QMMasterDataCompanieTable.RESET;
        //JAV 22/07/22: - QM 1.00.05 Poder crear desde empresas que no sean la master
        //QMMasterDataCompanieTable.SETFILTER(Company, '<>%1', GetMaster);
        QMMasterDataCompanieTable.SETFILTER(Company, '<>%1', oCompany);

        QMMasterDataCompanieTable.SETRANGE("Table No.", oRef.NUMBER);
        QMMasterDataCompanieTable.SETRANGE(Sync, QMMasterDataCompanieTable.Sync::Automatic);
        IF (QMMasterDataCompanieTable.FINDSET) THEN
            REPEAT
                IF (NOT ExistCompany(QMMasterDataCompanieTable.Company)) THEN  //Por si se ha eliminado la empresa pero sigue en la tabla de sincronizaci�n
                    QMMasterDataCompanieTable.DELETE
                ELSE
                    UpdateRecord(QMMasterDataCompanieTable.Company, oRef, TRUE, TRUE);
            UNTIL (QMMasterDataCompanieTable.NEXT = 0);
    END;

    LOCAL PROCEDURE DeleteFromMaster(oRef: RecordRef);
    VAR
        QMMasterDataCompanieTable: Record 7174394;
        QMSessionTableData: Record 7174388;
    BEGIN
        //JAV 22/04/22: - QM 1.00.00 Eliminar un registro desde el master, lo hace en todas las empresas asociadas

        //JAV 10/05/22: - QM 1.00.04 Si es la tabla de dimensiones y no sincronizamos la maestra no hay que controlar esto
        IF (SkipDimension(oRef)) THEN
            EXIT;

        //JAV 10/05/22: - QM 1.00.04 Procesar usando una nueva sesi�n en la empresa de destino, ahora hay dos pasos

        //Eliminar los registros creados que no han sido eliminados por procesos anteriores al dar el error y cancelar
        QMSessionTableData.RESET;
        QMSessionTableData.SETRANGE(OriginSesion, SESSIONID);
        QMSessionTableData.DELETEALL;

        //Primera pasada, miramos si se puede eliminar el registro en todas las empresas
        QMMasterDataCompanieTable.RESET;
        QMMasterDataCompanieTable.SETFILTER(Company, '<>%1', GetMaster);
        QMMasterDataCompanieTable.SETRANGE("Table No.", oRef.NUMBER);
        QMMasterDataCompanieTable.SETRANGE(Sync, QMMasterDataCompanieTable.Sync::Automatic);
        IF (QMMasterDataCompanieTable.FINDSET) THEN
            REPEAT
                IF (NOT ExistCompany(QMMasterDataCompanieTable.Company)) THEN  //Por si se ha eliminado la empresa pero sigue en la tabla de sincronizaci�n
                    QMMasterDataCompanieTable.DELETE
                ELSE
                    DeleteRecord(QMMasterDataCompanieTable.Company, oRef, TRUE);
            UNTIL (QMMasterDataCompanieTable.NEXT = 0);

        //Segunda pasada, los eliminamos
        QMMasterDataCompanieTable.RESET;
        QMMasterDataCompanieTable.SETFILTER(Company, '<>%1', GetMaster);
        QMMasterDataCompanieTable.SETRANGE("Table No.", oRef.NUMBER);
        QMMasterDataCompanieTable.SETRANGE(Sync, QMMasterDataCompanieTable.Sync::Automatic);
        IF (QMMasterDataCompanieTable.FINDSET) THEN
            REPEAT
                DeleteRecord(QMMasterDataCompanieTable.Company, oRef, FALSE);
            UNTIL (QMMasterDataCompanieTable.NEXT = 0);
    END;

    LOCAL PROCEDURE RenameFromMaster(oRef: RecordRef; xRef: RecordRef);
    VAR
        QMMasterDataCompanieTable: Record 7174394;
    BEGIN
        //JAV 22/04/22: - QM 1.00.00Al renombrar un registro del master, renombrarlo en todas las empresas

        //JAV 10/05/22: - QM 1.00.04 Si es la tabla de dimensiones y no sincronizamos la maestra no hay que controlar esto
        IF (SkipDimension(oRef)) THEN
            EXIT;

        QMMasterDataCompanieTable.RESET;
        QMMasterDataCompanieTable.SETFILTER(Company, '<>%1', GetMaster);
        QMMasterDataCompanieTable.SETRANGE("Table No.", oRef.NUMBER);
        QMMasterDataCompanieTable.SETRANGE(Sync, QMMasterDataCompanieTable.Sync::Automatic);
        IF (QMMasterDataCompanieTable.FINDSET) THEN
            REPEAT
                IF (NOT ExistCompany(QMMasterDataCompanieTable.Company)) THEN  //Por si se ha eliminado la empresa pero sigue en la tabla de sincronizaci�n
                    QMMasterDataCompanieTable.DELETE
                ELSE
                    RenameRecord(QMMasterDataCompanieTable.Company, oRef, xRef);
            UNTIL (QMMasterDataCompanieTable.NEXT = 0);
    END;

    LOCAL PROCEDURE "------------------------------------------------------ Funciones para revisar cambios en las empresas de trabajo"();
    BEGIN
    END;

    LOCAL PROCEDURE IsSyncActiveForRecord(RecRef: RecordRef): Integer;
    VAR
        QMMasterDataCompanieTable: Record 7174394;
        QMMasterDataTable: Record 7174392;
        QMSessionTableData: Record 7174388;
    BEGIN
        //JAV 22/04/22: - QM 1.00.00 Ver si est� activa la sincronizaci�n manual o autom�tica para un registro dato
        //JAV 22/07/22: - DP 1.00.05 Se cambia el retorno de boolean a indicar Si no se sincroniza, si es solo desde master o si es bidireccional

        //JAV 10/05/22: - QM 1.00.04 Si estamos ejecutando desde la sesi�n auxiliar, no dar el error
        IF (QMSessionTableData.GET(SESSIONID)) THEN    //JAV 12/02/22: - QB 1.00.06 Se a�ade la empresa a la clave de la tabla auxiliar de sesiones
            EXIT(SyncType::No);

        //JAV 28/04/22: - QM 1.00.04 Si es la tabla de dimensiones y no sincronizamos la maestra no hay que controlar esto
        IF (SkipDimension(RecRef)) THEN
            EXIT(SyncType::No);

        //Si est� activa la sincronizaci�n y no estamos en la empresa master
        IF (IsSyncActive) AND (RecRef.CURRENTCOMPANY <> GetMaster) THEN BEGIN
            //Si la tabla no se sincroniza no hacemos mas
            IF (QMMasterDataTable.GET(RecRef.NUMBER)) THEN BEGIN
                IF (QMMasterDataTable.Sync) THEN BEGIN
                    //Mirar si se sincroniza de manera manual o autom�tica
                    IF QMMasterDataCompanieTable.GET(COMPANYNAME, RecRef.NUMBER) THEN BEGIN
                        IF (QMMasterDataCompanieTable.Sync <> QMMasterDataCompanieTable.Sync::" ") THEN BEGIN
                            //JAV 22/07/22: - DP 1.00.05 Se sincroniza, ahora miramos si es solo desde master o si es bidireccional
                            IF (QMMasterDataTable."Modification in Destination") THEN
                                EXIT(SyncType::Bi)
                            ELSE
                                EXIT(SyncType::Master);
                        END;
                    END;
                END;
            END;
        END;

        EXIT(SyncType::No);
    END;

    LOCAL PROCEDURE CreateFromWork(RecRef: RecordRef);
    VAR
        QMMasterDataCompanieTable: Record 7174394;
    BEGIN
        //JAV 22/04/22: - QM 1.00.00 Crear nuevos registros desde una empresa de trabajo, verificar que se pueda hacer
        IF (IsSyncActiveForRecord(RecRef) = SyncType::Master) THEN
            ERROR(Txt020, RecRef.CAPTION);

        //JAV 22/07/22: - MD 1.00.05 Si la sincronizaci�n es bidireccional, dar de Alta desde una destino hacia la master y de esta al resto de empresas **
        IF (IsSyncActiveForRecord(RecRef) = SyncType::Bi) THEN BEGIN
            CreateFromCompany(COMPANYNAME, RecRef);  // Copiar a destinos
            CopyRecord(GetMaster, RecRef, TRUE);     // Copiar a la master
        END;
    END;

    LOCAL PROCEDURE UpdateFromWork(RecRef: RecordRef; pModify: Boolean; pMessages: Boolean);
    VAR
        QMMasterDataCompanieTable: Record 7174394;
        QMMasterDataDataRegister: Record 7174395;
        QMMasterDataTableField: Record 7174393;
        Field: Record 2000000041;
        mRecRef: RecordRef;
        dfRef: FieldRef;
        mfRef: FieldRef;
    BEGIN
        //Modificar un registro desde la empresa de trabajo, solo de los campos permitidos, y se marca que se ha modificado para mejorar la sincronizaci�n.
        IF (IsSyncActiveForRecord(RecRef) = SyncType::Master) THEN BEGIN
            //JAV 20/05/22: QM 1.00.05 Si no existe no proceso nada, dar un mensaje en lugar de un error al intentar abrir el registro
            IF (NOT OpenRecord(mRecRef, RecRef.RECORDID, GetMaster, FALSE)) THEN BEGIN    //Abro el registro en la empresa master
                QMMasterDataDataRegister.Table := RecRef.NUMBER;
                QMMasterDataDataRegister.RecordID := RecRef.RECORDID;
                QMMasterDataDataRegister."From Company" := '';
                QMMasterDataDataRegister."With Company" := COMPANYNAME;
                QMMasterDataDataRegister."Modified in Destination" := TRUE;
                QMMasterDataDataRegister."Not in Master" := TRUE;
                IF QMMasterDataDataRegister.INSERT(TRUE) THEN
                    MESSAGE('El registro que est� procesando no existe en la empresa Master')
                ELSE
                    QMMasterDataDataRegister.MODIFY(FALSE);
            END ELSE BEGIN
                //Miro campos no editables en destino
                QMMasterDataTableField.RESET;
                QMMasterDataTableField.SETRANGE("Table No.", RecRef.NUMBER);
                QMMasterDataTableField.SETRANGE("Not editable in destination", TRUE);
                IF QMMasterDataTableField.FINDSET THEN BEGIN
                    REPEAT
                        //JAV 19/05/22: - QM 1.00.05 Verificar que se pueda tratar el campo
                        IF CheckField(QMMasterDataTableField."Table No.", QMMasterDataTableField."Field No.") THEN BEGIN
                            dfRef := RecRef.FIELD(QMMasterDataTableField."Field No.");
                            mfRef := mRecRef.FIELD(QMMasterDataTableField."Field No.");
                            IF (FORMAT(dfRef.VALUE) <> FORMAT(mfRef.VALUE)) THEN
                                ERROR(Txt021, dfRef.CAPTION, RecRef.CAPTION);
                        END;
                    UNTIL QMMasterDataTableField.NEXT = 0;
                END;

                //Si no hay campos no editables implicados, marco que se ha modificado el registro en destino
                IF QMMasterDataDataRegister.GET(RecRef.NUMBER, RecRef.RECORDID, COMPANYNAME) THEN BEGIN
                    QMMasterDataDataRegister."Modified in Destination" := TRUE;
                    QMMasterDataDataRegister.MODIFY(FALSE);
                END ELSE BEGIN
                    QMMasterDataDataRegister.Table := RecRef.NUMBER;
                    QMMasterDataDataRegister.RecordID := RecRef.RECORDID;
                    QMMasterDataDataRegister."From Company" := GetMaster;
                    QMMasterDataDataRegister."With Company" := COMPANYNAME;
                    QMMasterDataDataRegister."Modified in Destination" := TRUE;
                    QMMasterDataDataRegister.INSERT(TRUE);
                END;
            END;
        END;


        //JAV 22/07/22: - MD 1.00.05 Si la sincronizaci�n es bidireccional, Modificar desde una destino hacia la master y de esta al resto de empresas **
        IF (IsSyncActiveForRecord(RecRef) = SyncType::Bi) THEN BEGIN
            UpdateFromCompany(COMPANYNAME, RecRef, TRUE, TRUE);
            UpdateRecord(GetMaster, RecRef, TRUE, TRUE);
        END;
    END;

    LOCAL PROCEDURE DeleteFromWork(RecRef: RecordRef);
    VAR
        QMMasterDataCompanieTable: Record 7174394;
    BEGIN
        //JAV 22/04/22: - QM 1.00.00 Eliminar un registro desde una empresa de trabajo, verificar que se pueda hacer

        IF (IsSyncActiveForRecord(RecRef) = SyncType::Master) THEN
            ERROR(Txt022, RecRef.CAPTION);

        //JAV 22/07/22: - MD 1.00.05 Si la sincronizaci�n es bidireccional
        IF (IsSyncActiveForRecord(RecRef) = SyncType::Bi) THEN
            ERROR(Txt022, RecRef.CAPTION);
    END;

    LOCAL PROCEDURE RenameFromWork(RecRef: RecordRef);
    VAR
        QMMasterDataCompanieTable: Record 7174394;
    BEGIN
        //JAV 22/04/22: - QM 1.00.00 Renombra un registro desde una empresa de trabajo, verificar que se pueda hacer

        IF (IsSyncActiveForRecord(RecRef) = SyncType::Master) THEN
            ERROR(Txt023, RecRef.CAPTION);

        //JAV 22/07/22: - MD 1.00.05 Si la sincronizaci�n es bidireccional
        IF (IsSyncActiveForRecord(RecRef) = SyncType::Bi) THEN
            ERROR(Txt022, RecRef.CAPTION);
    END;

    LOCAL PROCEDURE "------------------------------------------------------- Sincronizaci¢n Manual desde la empresa Master"();
    BEGIN
    END;

    LOCAL PROCEDURE UpdateOne(oRef: RecordRef; dRef: RecordRef);
    VAR
        QMMasterDataTableField: Record 7174393;
        tbFields: Record 2000000041;
        oField: FieldRef;
        dField: FieldRef;
        procesar: Boolean;
    BEGIN
        //Actualiza un registro desde la master a destino
        tbFields.RESET;
        tbFields.SETRANGE(TableNo, oRef.NUMBER);
        tbFields.SETRANGE(Class, tbFields.Class::Normal);
        IF (tbFields.FINDSET(FALSE)) THEN
            REPEAT
                procesar := TRUE;  //Si no ha sido restringido expresamente lo procesamos
                IF (QMMasterDataTableField.GET(oRef.NUMBER, tbFields."No.")) THEN
                    procesar := (QMMasterDataTableField."Not editable in destination");

                //JAV 19/05/22: - QM 1.00.05 Verificar que se pueda tratar el campo
                procesar := procesar AND CheckField(QMMasterDataTableField."Table No.", QMMasterDataTableField."Field No.");

                IF (procesar) THEN BEGIN
                    oField := oRef.FIELD(tbFields."No.");
                    dField := dRef.FIELD(tbFields."No.");
                    dField.VALUE(oField.VALUE);
                END;
            UNTIL (tbFields.NEXT = 0);

        IF NOT dRef.MODIFY(FALSE) THEN
            dRef.INSERT(FALSE);
    END;

    PROCEDURE UpdateAllTablesByCompany(pCompany: Text);
    VAR
        QMMasterDataCompanieTable: Record 7174394;
        QMMasterDataCompanies: Record 7174391;
        QMMasterDataTable: Record 7174392;
        n: Integer;
    BEGIN
        //Actualizo todas las tablas autom�ticas de una empresa
        n := 0;
        QMMasterDataCompanieTable.RESET;
        QMMasterDataCompanieTable.SETRANGE(Company, pCompany);
        QMMasterDataCompanieTable.SETRANGE(Sync, QMMasterDataCompanieTable.Sync::Automatic);
        IF (QMMasterDataCompanieTable.FINDSET) THEN
            REPEAT
                IF (NOT ExistCompany(QMMasterDataCompanieTable.Company)) OR                  //Por si se ha eliminado la empresa pero sigue en la tabla de sincronizaci�n
                   (NOT QMMasterDataCompanies.GET(QMMasterDataCompanieTable.Company)) OR     //o Si se ha eliminado de la lista de empresas
                   (NOT QMMasterDataTable.GET(QMMasterDataCompanieTable."Table No.")) THEN   //o Si se ha eliminado de la lista de tablas
                    QMMasterDataCompanieTable.DELETE
                ELSE BEGIN
                    n += 1;
                    UpdateOneTableInACompany(QMMasterDataCompanieTable.Company, QMMasterDataCompanieTable."Table No.");
                END;
            UNTIL (QMMasterDataCompanieTable.NEXT = 0);
        MESSAGE('Proceso finalizado, se han actualziado %1 tablas', n);
    END;

    PROCEDURE UpdateTableInAllCompany(pTable: Integer);
    VAR
        QMMasterDataCompanieTable: Record 7174394;
        QMMasterDataCompanies: Record 7174391;
        QMMasterDataTable: Record 7174392;
        n: Integer;
    BEGIN
        //Actualizo una tabla autom�tica en todas las empresas
        n := 0;
        QMMasterDataCompanieTable.RESET;
        QMMasterDataCompanieTable.SETRANGE("Table No.", pTable);
        QMMasterDataCompanieTable.SETRANGE(Sync, QMMasterDataCompanieTable.Sync::Automatic);
        IF (QMMasterDataCompanieTable.FINDSET) THEN
            REPEAT
                IF (NOT ExistCompany(QMMasterDataCompanieTable.Company)) OR                  //Por si se ha eliminado la empresa pero sigue en la tabla de sincronizaci�n
                   (NOT QMMasterDataCompanies.GET(QMMasterDataCompanieTable.Company)) OR     //o Si se ha eliminado de la lista de empresas
                   (NOT QMMasterDataTable.GET(QMMasterDataCompanieTable."Table No.")) THEN   //o Si se ha eliminado de la lista de tablas
                    QMMasterDataCompanieTable.DELETE
                ELSE BEGIN
                    n += 1;
                    UpdateOneTableInACompany(QMMasterDataCompanieTable.Company, QMMasterDataCompanieTable."Table No.");
                END;
            UNTIL (QMMasterDataCompanieTable.NEXT = 0);
        MESSAGE('Proceso finalizado, se han actualizado en %1 empresas', n);
    END;

    PROCEDURE UpdateOneTableInACompany(pCompany: Text; pTable: Integer);
    VAR
        oRef: RecordRef;
        Window: Dialog;
        n1: Integer;
        n2: Integer;
    BEGIN
        //---------------------------------------------------------------------------------------------
        //Sincronizar todos los registros de una tabla desde la empresa Master a otra empresa
        //---------------------------------------------------------------------------------------------

        //JAV 22/04/22: - QM 1.00.02 Solo se pueden sincronizar tablas lanzandolo desde la empresa master
        IF (NOT CompanyIsMaster(COMPANYNAME)) THEN
            ERROR('Este proceso solo se puede lanzar desde la empresa Master');


        Window.OPEN('Sincronizando: #1#################################' +
                           '\Tabla: #2#################################' +
                        '\Registro: @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
        Window.UPDATE(1, pCompany);
        Window.UPDATE(2, FORMAT(pTable));

        oRef.OPEN(pTable, FALSE, GetMaster);
        Window.UPDATE(2, oRef.CAPTION);
        n1 := oRef.COUNT;
        n2 := 0;
        oRef.RESET;
        IF (oRef.FINDSET(FALSE)) THEN
            REPEAT
                n2 += 1;
                Window.UPDATE(3, ROUND(n2 * 10000 / n1, 1));
                CopyRecord(pCompany, oRef, FALSE);
            UNTIL (oRef.NEXT = 0);
        oRef.CLOSE;
        Window.CLOSE;
    END;

    LOCAL PROCEDURE "------------------------------------------------------- Funciones para procesar los registros a sincronizar"();
    BEGIN
    END;

    PROCEDURE ExistCompany(pCompany: Text): Boolean;
    VAR
        Company: Record 2000000006;
    BEGIN
        //Retorna si existe la empresa de destino
        EXIT(Company.GET(pCompany));
    END;

    PROCEDURE ExistCodeInCompany(pRecordID: RecordID; pCompany: Text): Boolean;
    VAR
        rRef: RecordRef;
        Exist: Boolean;
    BEGIN
        //Retorna si existe el registro en la empresa de destino

        //JAV 20/05/22: - QM 1.00.05 Si no existe la empresa no puede existir el registro
        IF NOT ExistCompany(pCompany) THEN
            EXIT(FALSE);

        rRef.OPEN(pRecordID.TABLENO, FALSE, pCompany);
        Exist := rRef.GET(pRecordID);
        rRef.CLOSE;
        EXIT(Exist);
    END;

    PROCEDURE SyncUp(pRecordID: RecordID; pModify: Boolean);
    VAR
        DataSyncronization: Record 7174395;
        oRR: RecordRef;
    BEGIN
        //Sincroniza un registro de la master entre las empresas relacionadas

        //Abro el registro en la empresa master, si no puedo salgo
        IF (NOT OpenRecord(oRR, pRecordID, GetMaster(), TRUE)) THEN
            EXIT;

        //Recorro la tabla de sincronizaci�n y doy altas de registros si no existen en la empresa de destino
        DataSyncronization.RESET;
        DataSyncronization.CHANGECOMPANY(GetMaster); //Aunque solo se puede lanzar desde la master
        DataSyncronization.SETRANGE(Table, pRecordID.TABLENO);
        DataSyncronization.SETRANGE(RecordID, pRecordID);
        IF (DataSyncronization.FINDSET(TRUE)) THEN
            REPEAT
                IF (NOT ExistCompany(DataSyncronization."With Company")) THEN  //Por si se ha eliminado la empresa pero sigue en la tabla de sincronizaci�n
                    DataSyncronization.DELETE
                ELSE IF (NOT ExistCodeInCompany(pRecordID, DataSyncronization."With Company")) THEN
                    CopyRecord(DataSyncronization."With Company", oRR, FALSE);
            UNTIL (DataSyncronization.NEXT = 0);

        CloseRecord(oRR, '');
    END;

    PROCEDURE UpdateFields(pRecordID: RecordID; pModify: Boolean);
    VAR
        DataSyncronization: Record 7174395;
        oRR: RecordRef;
    BEGIN
        //Actualizar los campos de la master en todas las empresas

        IF (NOT OpenRecord(oRR, pRecordID, GetMaster(), TRUE)) THEN
            EXIT;

        //Recorro la tabla de sincronizaci�n y modifico o doy altas de registros en la empresa de destino
        DataSyncronization.RESET;
        DataSyncronization.CHANGECOMPANY(GetMaster);
        DataSyncronization.SETRANGE(Table, pRecordID.TABLENO);
        DataSyncronization.SETRANGE(RecordID, pRecordID);
        IF (DataSyncronization.FINDSET(TRUE)) THEN
            REPEAT
                IF (NOT ExistCompany(DataSyncronization."With Company")) THEN  //Por si se ha eliminado la empresa pero sigue en la tabla de sincronizaci�n
                    DataSyncronization.DELETE
                ELSE IF (NOT ExistCodeInCompany(pRecordID, DataSyncronization."With Company")) THEN  //Si no existe lo creo
                    CopyRecord(DataSyncronization."With Company", oRR, FALSE)
                ELSE
                    UpdateRecord(DataSyncronization."With Company", oRR, pModify, FALSE);
            UNTIL (DataSyncronization.NEXT = 0);

        CloseRecord(oRR, '');
    END;

    PROCEDURE OpenRecord(VAR pRR: RecordRef; pRecordID: RecordID; pCompany: Text; pError: Boolean): Boolean;
    VAR
        Field: Record 2000000041;
        fRef: FieldRef;
        Existe: Boolean;
        NF: Integer;
        Encontrado: Boolean;
    BEGIN
        //Abre un registro de una tabla en una empresa y prepara el recordRef, retorna si existe o no el registro
        pRR.OPEN(pRecordID.TABLENO, FALSE, pCompany);

        Encontrado := pRR.GET(pRecordID);
        IF (NOT Encontrado) THEN BEGIN
            IF (pError) THEN
                CloseRecord(pRR, STRSUBSTNO('No existe el registro %1 en la tabla %2', pRecordID, pRR.NAME))
            ELSE
                CloseRecord(pRR, '');
            EXIT(FALSE);
        END;

        //Miro si faltan datos en el registro, no puedo sincronizar si faltan
        IF (pError) THEN BEGIN
            IF (GetFieldNo(pRecordID.TABLENO, 'Data Missed', NF)) THEN BEGIN
                fRef := pRR.FIELD(NF);
                IF (FORMAT(fRef.VALUE) = FORMAT(TRUE)) THEN BEGIN
                    CloseRecord(pRR, STRSUBSTNO(Txt001, pRR.NAME));
                    EXIT(FALSE);
                END;
            END;
        END;

        EXIT(TRUE);
    END;

    PROCEDURE CopyRecord(ToCompany: Text; oRR: RecordRef; pValidate: Boolean);
    VAR
        QMMasterDataDataRegister: Record 7174395;
        Field: Record 2000000041;
        dRR: RecordRef;
        dFR: FieldRef;
        Nombre: Text;
        NF: Integer;
    BEGIN
        //Copia un registro a otra empresa

        IF (NOT ExistCompany(ToCompany)) THEN  //Por si se ha eliminado la empresa pero sigue en la tabla de sincronizaci�n
            EXIT;

        //JAV 28/04/22: - QM 1.00.04 Si es la tabla de dimensiones y no sincronizamos la maestra salir
        IF (SkipDimension(oRR)) THEN
            EXIT;

        //Busco el registro del log de cambios y lo creo si no existe
        IF (NOT QMMasterDataDataRegister.GET(oRR.NUMBER, oRR.RECORDID, ToCompany)) THEN BEGIN
            QMMasterDataDataRegister.Table := oRR.NUMBER;
            QMMasterDataDataRegister.RecordID := oRR.RECORDID;
            QMMasterDataDataRegister."With Company" := ToCompany;
            QMMasterDataDataRegister."From Company" := GetMaster;
            QMMasterDataDataRegister.INSERT(TRUE);
        END;

        IF (ExistCodeInCompany(QMMasterDataDataRegister.RecordID, QMMasterDataDataRegister."With Company")) THEN  //Si ya existe no hago nada
            EXIT;

        dRR.OPEN(oRR.NUMBER);                                                     //Abro el registro de destino
        dRR := oRR.DUPLICATE;                                                     //Copio origen a destino completamente
        dRR.CHANGECOMPANY(QMMasterDataDataRegister."With Company");               //Cambio la empresa en el destino
        IF (GetFieldNo(dRR.NUMBER, 'Created from Master Data', NF)) THEN BEGIN    //Guardo cuando se cre� el registro desde la empresa master si existe el campo en la tabla
            dFR := dRR.FIELD(NF);
            dFR.VALUE := CURRENTDATETIME;
        END;

        IF dRR.INSERT(FALSE) THEN BEGIN                                                  //Creo el registro sin validar
                                                                                         //JAV 19/04/22: - QM 1.00.02 No se puede usar el MODIFY(TRUE) por problemas con recursividad
                                                                                         //IF (pValidate) THEN
                                                                                         //  dRR.MODIFY(pValidate);                                                //Valido para las dimensiones obligatorias

            QMMasterDataDataRegister."Creation Date" := CURRENTDATETIME;
            IF NOT QMMasterDataDataRegister.MODIFY THEN;
        END;
        dRR.CLOSE;
    END;

    PROCEDURE UpdateRecord(ToCompany: Text; oRR: RecordRef; pValidate: Boolean; pMessages: Boolean);
    VAR
        QMMasterDataDataRegister: Record 7174395;
        QMMasterDataTableField: Record 7174393;
        Field: Record 2000000041;
        dRR: RecordRef;
        oFR: FieldRef;
        dFR: FieldRef;
        Changed: Boolean;
        NF: Integer;
        AutoInc: Boolean;
    BEGIN
        //Actualiza un registro en otra empresa

        IF (NOT ExistCompany(ToCompany)) THEN  //Por si se ha eliminado la empresa pero sigue en la tabla de sincronizaci�n
            EXIT;

        //JAV 28/04/22: - QM 1.00.04 Si es la tabla de dimensiones y no sincronizamos la maestra salir
        IF (SkipDimension(oRR)) THEN
            EXIT;

        //Busco el registro del log de cambios y lo creo si no existe
        IF (NOT QMMasterDataDataRegister.GET(oRR.NUMBER, oRR.RECORDID, ToCompany)) THEN BEGIN
            QMMasterDataDataRegister.Table := oRR.NUMBER;
            QMMasterDataDataRegister.RecordID := oRR.RECORDID;
            QMMasterDataDataRegister."With Company" := ToCompany;
            QMMasterDataDataRegister."From Company" := GetMaster;
            QMMasterDataDataRegister.INSERT(TRUE);
        END;

        IF (NOT ExistCodeInCompany(QMMasterDataDataRegister.RecordID, QMMasterDataDataRegister."With Company")) THEN   //Si no existe lo creo
            CopyRecord(QMMasterDataDataRegister."With Company", oRR, pValidate)
        ELSE BEGIN
            Changed := FALSE;

            OpenRecord(dRR, QMMasterDataDataRegister.RecordID, QMMasterDataDataRegister."With Company", FALSE);  //Como lo hemos encontrado no puede dar un error
            QMMasterDataTableField.RESET;
            QMMasterDataTableField.SETRANGE("Table No.", QMMasterDataDataRegister.Table);
            IF (QMMasterDataDataRegister."Modified in Destination") THEN                                         //Si est� modificado en destino solo cambio campos sincronizables, si no todos
                QMMasterDataTableField.SETRANGE("Not editable in destination", TRUE);
            IF (QMMasterDataTableField.FINDSET(FALSE)) THEN
                REPEAT
                    //JAV 19/05/22: - QM 1.00.05 Verificar que se pueda tratar el campo
                    IF CheckField(dRR.NUMBER, QMMasterDataTableField."Field No.") THEN BEGIN
                        oFR := oRR.FIELD(QMMasterDataTableField."Field No.");
                        dFR := dRR.FIELD(QMMasterDataTableField."Field No.");

                        IF (oFR.VALUE <> dFR.VALUE) THEN BEGIN
                            dFR.VALUE := oFR.VALUE;
                            Changed := TRUE;
                        END;
                    END;
                UNTIL (QMMasterDataTableField.NEXT = 0);

            //Si ha cambiado
            IF (Changed) THEN BEGIN
                IF (GetFieldNo(QMMasterDataDataRegister.Table, 'Updated from Master Data', NF)) THEN BEGIN
                    dFR := dRR.FIELD(NF);
                    dFR.VALUE := CURRENTDATETIME;
                END;
                //JAV 19/04/22: - QM 1.00.02 No se puede usar el MODIFY(TRUE) por problemas con recursividad
                //dRR.MODIFY(pValidate);
                dRR.MODIFY(FALSE);

                //Marco como sincronizado el registro
                QMMasterDataDataRegister."Update Date" := CURRENTDATETIME;
                IF NOT QMMasterDataDataRegister.MODIFY THEN;
            END;

            CloseRecord(dRR, '');
        END;
    END;

    LOCAL PROCEDURE DeleteRecord(ToCompany: Text; oRef: RecordRef; Test: Boolean);
    VAR
        QMMasterDataDataRegister: Record 7174395;
        dRef: RecordRef;
    BEGIN
        //JAV 22/04/22: - QM 1.00.00 Eliminar un registro desde el master, lo hace en todas las empresas asociadas

        IF (NOT ExistCompany(ToCompany)) THEN  //Por si se ha eliminado la empresa pero sigue en la tabla de sincronizaci�n
            EXIT;

        //JAV 28/04/22: - QM 1.00.04 Si es la tabla de dimensiones y no sincronizamos la maestra salir
        IF (SkipDimension(oRef)) THEN
            EXIT;

        //Busco el registro del log de cambios y lo elimino si existe
        IF (QMMasterDataDataRegister.GET(oRef.NUMBER, oRef.RECORDID, ToCompany)) THEN BEGIN
            QMMasterDataDataRegister.DELETE;
        END;

        IF (NOT ExistCodeInCompany(oRef.RECORDID, ToCompany)) THEN  //Si no existe no hago nada
            EXIT;

        dRef.OPEN(oRef.NUMBER, FALSE, ToCompany);
        IF dRef.GET(oRef.RECORDID) THEN
            //JAV 10/05/22: - QM 1.00.04 Procesar usando una nueva sesi�n en la empresa de destino
            ProcessInSession(COMPANYNAME, ToCompany, Operation::DEL, dRef, NOT Test);   //JAV 12/02/22: - QB 1.00.06 Modificaciones para la tabla auxiliar de sesiones
        dRef.CLOSE;
    END;

    LOCAL PROCEDURE RenameRecord(ToCompany: Text; oRef: RecordRef; xRef: RecordRef);
    VAR
        QMMasterDataDataRegister: Record 7174395;
        QMMasterDataTableField: Record 7174393;
        dRef: RecordRef;
        fRef: ARRAY[10] OF FieldRef;
        nKeys: Integer;
    BEGIN
        //JAV 22/04/22: - QM 1.00.00Al renombrar un registro del master, renombrarlo en todas las empresas

        IF (NOT ExistCompany(ToCompany)) THEN  //Por si se ha eliminado la empresa pero sigue en la tabla de sincronizaci�n
            EXIT;

        //JAV 28/04/22: - QM 1.00.04 Si es la tabla de dimensiones y no sincronizamos la maestra salir
        IF (SkipDimension(oRef)) THEN
            EXIT;

        //Busco el registro del log de cambios, lo elimino si existe y creo el nuevo registro
        IF (QMMasterDataDataRegister.GET(oRef.NUMBER, xRef.RECORDID, ToCompany)) THEN BEGIN
            QMMasterDataDataRegister.DELETE;
        END;
        QMMasterDataDataRegister.Table := oRef.NUMBER;
        QMMasterDataDataRegister.RecordID := oRef.RECORDID;
        QMMasterDataDataRegister."With Company" := ToCompany;
        QMMasterDataDataRegister."From Company" := GetMaster;
        QMMasterDataDataRegister."Update Date" := CURRENTDATETIME;
        QMMasterDataDataRegister.INSERT(TRUE);

        IF (NOT ExistCodeInCompany(xRef.RECORDID, QMMasterDataDataRegister."With Company")) THEN                          //Si no existe lo creo
            CopyRecord(QMMasterDataDataRegister."With Company", oRef, TRUE)
        ELSE BEGIN
            dRef.OPEN(oRef.NUMBER, FALSE, ToCompany);
            IF dRef.GET(xRef.RECORDID) THEN BEGIN
                nKeys := 0;
                QMMasterDataTableField.RESET;
                QMMasterDataTableField.SETRANGE("Table No.", oRef.NUMBER);
                QMMasterDataTableField.SETRANGE(PK, TRUE);
                IF (QMMasterDataTableField.FINDSET) THEN
                    REPEAT
                        nKeys += 1;
                        fRef[nKeys] := oRef.FIELD(QMMasterDataTableField."Field No.");
                    UNTIL (QMMasterDataTableField.NEXT = 0);

                CASE nKeys OF
                    1:
                        dRef.RENAME(fRef[1].VALUE);
                    2:
                        dRef.RENAME(fRef[1].VALUE, fRef[2].VALUE);
                    3:
                        dRef.RENAME(fRef[1].VALUE, fRef[2].VALUE, fRef[3].VALUE);
                    4:
                        dRef.RENAME(fRef[1].VALUE, fRef[2].VALUE, fRef[3].VALUE, fRef[4].VALUE);
                    5:
                        dRef.RENAME(fRef[1].VALUE, fRef[2].VALUE, fRef[3].VALUE, fRef[4].VALUE, fRef[5].VALUE);
                    ELSE
                        ERROR('Mas de 5 campos clave');
                END;
            END;
            dRef.CLOSE;
        END;
    END;

    PROCEDURE CloseRecord(VAR pRR: RecordRef; pError: Text);
    BEGIN
        //Cierra un recordref, retorna un error si lo hay
        pRR.CLOSE;
        IF (pError <> '') THEN
            ERROR(pError);
    END;

    LOCAL PROCEDURE SkipDimension(rRef: RecordRef): Boolean;
    VAR
        QMMasterDataCompanieTable: Record 7174394;
        QMMasterDataTable: Record 7174392;
        DefaultDimension: Record 352;
    BEGIN
        //---------------------------------------------------------------------------------------------------------------------------------------
        //JAV 28/04/22: - QM 1.00.04 Retorna si hay que tratar el registro cuando se trata de la tabla de Dimensiones
        //---------------------------------------------------------------------------------------------------------------------------------------

        //Busco la tabla que estoy sincronizando, si no est� en la lista no debe ser la de dimensi�nes
        IF NOT QMMasterDataTable.GET(rRef.NUMBER) THEN
            EXIT(FALSE);

        //Si no es la tabla de dimensiones la que estamos procesando no hay que hacer nada
        IF (NOT QMMasterDataTable."Is Default Dimension Table") THEN
            EXIT(FALSE);

        //A partir de este punto ya se que es la tabla de dimensiones predeterminadas, por tanto hay que ver si la trato o me salto los procesos de sincronizaci�n

        //Busco la tabla de origen y miro si se trata, si no saltamos la verificaci�n de la dimensi�n
        rRef.SETTABLE(DefaultDimension);
        IF NOT QMMasterDataTable.GET(DefaultDimension."Table ID") THEN
            EXIT(TRUE);

        //Si no se sincroniza la tabla de origen de la dimensi�n en la empresa no hay que hacer nada, saltamos la verificaci�n de la dimensi�n
        IF (NOT QMMasterDataCompanieTable.GET(rRef.CURRENTCOMPANY, DefaultDimension."Table ID")) THEN
            EXIT(TRUE);

        //Si no se maneja la tabla no se sinconizar�, saltamos la verificaci�n de la dimensi�n
        IF (NOT QMMasterDataTable.Sync) THEN
            EXIT(TRUE);

        //Finalmente ya depende de si se manejan sus dimensiones
        EXIT(QMMasterDataTable.Dimensions);
    END;

    LOCAL PROCEDURE ProcessInSession(pFromCompany: Text; pToCompany: Text; pOperation: Option; pRecRef: RecordRef; pProcess: Boolean);
    VAR
        QMMasterDataSetup: Record 7174390;
        QMSessionTableData: Record 7174388;
        SessionEvent: Record 2000000111;
        ActiveSession: Record 2000000110;
        IdSession: Integer;
        Txt: Text;
        tm1: Time;
        tm2: Time;
        maxTO: Integer;
    BEGIN
        //---------------------------------------------------------------------------------------------------------------------------------------
        //JAV 10/05/22: - QM 1.00.04 Procesar un registro en una sesion de otra empresa
        //---------------------------------------------------------------------------------------------------------------------------------------

        //Tiempo m�ximo de espera, si no se ha establecido o es muy peque�o por defecto ser�n 3 segundos, si es muy grande se ajusta a 1 minuto
        QMMasterDataSetup.GET();
        maxTO := QMMasterDataSetup.TimeOut * 1000;
        IF (maxTO < 3000) THEN
            maxTO := 3000;
        IF (maxTO > 60000) THEN
            maxTO := 60000;

        IF (QMSessionTableData.GET(SESSIONID)) THEN
            QMSessionTableData.DELETE;

        QMSessionTableData.INIT;
        QMSessionTableData.IDSesion := SESSIONID;
        QMSessionTableData.OriginSesion := SESSIONID;
        QMSessionTableData.OriginCompany := pFromCompany;   //JAV 12/02/22: - QB 1.00.06 Se a�ade la empresa a la tabla auxiliar de sesiones
        QMSessionTableData.Table := pRecRef.NUMBER;
        QMSessionTableData.RecID := pRecRef.RECORDID;
        QMSessionTableData.Operation := pOperation;
        QMSessionTableData.Process := pProcess;
        QMSessionTableData.INSERT(TRUE);

        //Inicio la sesi�n en la otra empresa
        IF NOT STARTSESSION(IdSession, CODEUNIT::"QM Session Table Maintenance", pToCompany, QMSessionTableData) THEN
            ERROR('No se pudo crear una nueva sesi�n.');

        //Esperamos a que se cierre la otra sesi�n, o como m�ximo lo configurado
        tm1 := TIME;
        tm2 := tm1;
        WHILE (ActiveSession.GET(SERVICEINSTANCEID, IdSession)) AND (tm2 - tm1 < maxTO) DO BEGIN
            SLEEP(1000);
            tm2 := TIME;
        END;

        //Si la sesi�n sigue activa es que hay un TimeOut
        IF ActiveSession.GET(SERVICEINSTANCEID, IdSession) THEN BEGIN
            STOPSESSION(IdSession, 'Sesion cancelada por TimeOut');
            ERROR('Error en la empresa ' + pToCompany + ': TimeOut');
        END;

        //Miramos si hay un error
        IF (QMSessionTableData.GET(IdSession)) THEN       //JAV 20/09/22: - QB 1.00.06 Si existe el registro de la sesi�n es que termin� correctamente
            IF (QMSessionTableData.ResultOk) THEN BEGIN     //JAV 20/09/22: - QB 1.00.06 Por si acaso, indico que la sesi�n termin� correctamente
                QMSessionTableData.DELETE;
                EXIT;
            END;

        SessionEvent.RESET;
        SessionEvent.SETASCENDING("Event Datetime", TRUE);
        SessionEvent.SETRANGE("User ID", USERID);
        SessionEvent.SETRANGE("Server Instance ID", SERVICEINSTANCEID);
        SessionEvent.SETRANGE("Session ID", IdSession);
        SessionEvent.SETRANGE("Event Type", SessionEvent."Event Type"::Logoff);
        IF SessionEvent.FINDLAST THEN
            Txt := SessionEvent.Comment;

        IF (Txt <> '') AND (Txt <> QMSessionTableData.TxtNoError) THEN
            ERROR('No puedo eliminar el registro en la Empresa ' + pToCompany + ' (' + Txt + ')');
    END;

    LOCAL PROCEDURE CheckField(pTable: Integer; pField: Integer): Boolean;
    VAR
        Field: Record 2000000041;
    BEGIN
        //---------------------------------------------------------------------------------------------------------------------------------------
        //JAV 19/05/22: - QM 1.00.05 Verificar que se pueda tratar el campo, que est� activo, no obsoleto y no autoincremental
        //                           Retona SI o NO lo podemos procesar
        //---------------------------------------------------------------------------------------------------------------------------------------
        IF NOT Field.GET(pTable, pField) THEN
            EXIT(FALSE);

        //JAV 09/05/22: - QM 1.00.04 No incluir campos auto-incrementales en las modificaciones
        IF (AutoIncremental(pTable, pField)) THEN
            EXIT(FALSE);

        EXIT((Field.Enabled) AND (Field.ObsoleteState IN [Field.ObsoleteState::No, Field.ObsoleteState::Pending]));
    END;

    LOCAL PROCEDURE AutoIncremental(pTable: Integer; pField: Integer): Boolean;
    BEGIN
        //---------------------------------------------------------------------------------------------------------------------------------------
        //JAV 09/05/22: - QM 1.00.04 No incluir campos auto-incrementales, no se puede saber desde la tabla de campos
        //---------------------------------------------------------------------------------------------------------------------------------------
        CASE TRUE OF
            (pTable = 349) AND (pField = 12):
                EXIT(TRUE);
        END;

        EXIT(FALSE);
    END;

    /*BEGIN
/*{
      JAV 22/04/22: - QM 1.00.00 Esta CU realiza la sincronizaci�n de datos desde la Master Data al resto de empresas. Basado en el anterior QB 1.06.12
      JAV 19/04/22: - QM 1.00.02 No se puede usar el MODIFY(TRUE) por problemas con recursividad
      JAV 22/04/22: - QM 1.00.02 Solo se pueden sincronizar tablas lanzandolo desde la empresa master
      JAV 28/04/22: - QM 1.00.03 Sincronizar valores de dimensi�n por defecto
      JAV 10/05/22: - QM 1.00.04 No incluir campos auto-incrementales en las modificaciones
                                 Mejora en el tratamiento de las dimensiones, se procesaban siempre en los traspasos autom�ticos
                                 Se procesan cambios abriendo nuevas sesiones en las empresas de destino
      JAV 19/05/22: - QM 1.00.05 Verificar que se pueda tratar el campo, que est� activo, no obsoleto y no autoincremental
      JAV 20/05/22: - QM 1.00.05 Al buscar un registro en la master desde una empresa de trabajo, si no existe no hay que procesar nada
                                 Al mirar si existe el registro, si no existe la empresa no puede existir el registro
      JAV 12/02/22: - QB 1.00.06 Se a�ade la empresa a la clave de la tabla auxiliar de sesiones
      CPA 10/02/23: - Q18908. Los campos no asignados no se inicializaban
    }
END.*/
}









