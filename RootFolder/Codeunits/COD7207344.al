Codeunit 7207344 "QB Update Version"
{


    //Permissions = codeunit 7207344=x;
    trigger OnRun()
    BEGIN
    END;

    // [EventSubscriber(ObjectType::Codeunit, 40, OnAfterCompanyOpen, '', true, true)]
    LOCAL PROCEDURE C40_OnAfterCompanyOpen();
    VAR
        QBGlobalConf: Record 7206985;
        Object: Record 2000000001;
        QBVersionChanges: Record 7206921;
        FunctionQB: Codeunit 7207272;
        // QBDataVersionChange: Report 7207530;
        Version: Code[10];
    BEGIN
        /*{---
              //JAV 10/02/22: - QB 1.10.19 Si cambia la versi�n de QB, este proceso lanza la actualizaci�n y bloquea al resto de usuarios mientras

              //JAV 23/05/22: - QB 1.10.43 Solo lanzamos el proceso si estamos ejecutando con cliente Roles o Cliente Web
              IF (CURRENTCLIENTTYPE  = CLIENTTYPE::Windows) OR (CURRENTCLIENTTYPE  = CLIENTTYPE::Web) THEN BEGIN
                //Buscar la versi�n del programa en la tabla de cambios
                Object.RESET;
                Object.SETRANGE(Type, Object.Type::Table);
                Object.SETRANGE(ID, 7206921);
                Object.FINDFIRST;
                Version := COPYSTR(Object."Version List",1,6);

                //Leer el fichero de configuraci�n global, si no existe lo crear�
                QBGlobalConf.GetGlobalConf('');
                IF NOT FunctionQB.IsClient('CEI') THEN BEGIN              //Si no est� con la licencia de CEI, ponemos la del cliente
                  QBGlobalConf."License No." := SERIALNUMBER;
                  QBGlobalConf.MODIFY;
                END;

                //Si ha cambiado la version hacemos los cambios necesarios
                IF (Version <> QBGlobalConf."Global Version") OR (Version <> QBGlobalConf."Data Version") THEN BEGIN
                  IF (Version <> QBGlobalConf."Global Version") THEN BEGIN
                    QBGlobalConf.LOCKTABLE(TRUE); //Bloqueamos la tabla para que otros no puedan entrar a hacer el cambio a la vez
                    QBGlobalConf.GetGlobalConf('');
                    QBGlobalConf."Global Version" := Version;
                    QBGlobalConf.MODIFY;
                    COMMIT; //Liberar el registro para que entren otros usuarios
                  END;

                  //Procesos de cambios de datos
                  CLEAR(QBDataVersionChange);
                  QBDataVersionChange.USEREQUESTPAGE(FALSE);
                  QBDataVersionChange.SetOption(FALSE);
                  QBDataVersionChange.RUNMODAL;

                  //Actualizo la tabla con los cambios de las versiones
                  QBVersionChanges.AddAll;

                END;
              END;
              ---}*/
    END;

    /*BEGIN
/*{
      JAV 10/02/22: - QB 1.10.19 Procesos globales para la actualizaci�n de datos
      JAV 23/05/22: - QB 1.10.43 Solo lanzamos el proceso si estamos ejecutando con cliente Roles o Cliente Web
      JAV 26/05/22: - QB 1.10.44 Se elimina el cambio autom�tico que produce errores y bloqueos, se deber� lanzar manualmente.
    }
END.*/
}







