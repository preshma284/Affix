Codeunit 7207360 "QB Tables Management"
{
  
  
    trigger OnRun()
BEGIN
          END;
    VAR
      Operation: Option "CRE","UPD","DEL","REN";
      Txt000 : TextConst ESP='Solo altas,Todo';
      Txt001 : TextConst ESP='Proceso finalizado';
      Window : Dialog;
      Txt002 : TextConst ESP='Sincronizar� los datos de TODAS las empresas';
      Txt003 : TextConst ESP='Sincronizar� la empresa %1';

    LOCAL PROCEDURE "------------------------------------------------------- Control de Captions"();
    BEGIN
    END;

    // [EventSubscriber(ObjectType::Codeunit, 42, OnExtensionCaptionArea, '', true, true)]
    LOCAL PROCEDURE OnExtensionCaptionArea(Language : Integer;CaptionArea : Text[80];CaptionRef : Text[1024];VAR CaptionExpr : Text[1024]);
    BEGIN
      //JAV 30/01/20: - Se a�ade OnExtensionCaptionArea para los cambios de captions en NAV 2018 (NAV 11)
      SetCaption(Language, CaptionRef, CaptionExpr);
    END;

    // [EventSubscriber(ObjectType::Codeunit, 42, OnAfterCaptionClassTranslate, '', true, true)]
    LOCAL PROCEDURE OnAfterCaptionClassTranslate(Language : Integer;CaptionExpression : Text[1024];VAR Caption : Text[1024]);
    BEGIN
      //JAV 30/01/20: - Se a�ade OnAfterCaptionClassTranslate para los cambios de captions en Business Central (NAV 13)
      SetCaption(Language, CaptionExpression, Caption);
    END;

    LOCAL PROCEDURE SetCaption(Language : Integer;CaptionRef : Text[1024];VAR CaptionExpr : Text[1024]);
    VAR
      Dimension : Record 348;
      InternalsStatus : Record 7207440;
      recLanguage : Record 8;
      QBTablesSetup : Record 7206903;
      Field : Record 2000000041;
      CaptionManagement : Codeunit 42;
      CaptionManagement1 : Codeunit 50211;
      txtLanguaje : Text;
      txtVertical : Text;
      txtTable : Text;
      txtField : Text;
      idTable : Integer;
      idField : Integer;
      i : Integer;
      j : Integer;
    BEGIN
      //JAV 30/01/20: - Se a�ade OnExtensionCaptionArea para los cambios de captions en QuoBuilding
      // Formato a usar: - 7206910,0,x  -> Una dimensi�n obligatoria, donde X puede ser 1..3 -> ESTO ACTUALMENTE NO SE UTILIZA
      //                 - 7206910,0,y  -> Una fecha de la ficha de estudio o proyecto, con X de 11..15 o 21..25
      //                 - 7206910,t,c  -> Un campo de una tabla, se busca en la tabla de campos con tabla t y campo c

      //Busco el nombre del idioma, ya que me dan el c�digo
      txtLanguaje := '';
      recLanguage.RESET;
      recLanguage.SETRANGE("Windows Language ID", Language);
      IF recLanguage.FINDFIRST THEN
        txtLanguaje := recLanguage.Code;


      FOR i:= 1 TO STRLEN(CaptionExpr) DO BEGIN
        IF (COPYSTR(CaptionExpr,i,1) = ',') THEN
          j += 1
        ELSE IF (COPYSTR(CaptionExpr,i,1) <> ' ') THEN
          CASE j OF
            0 : txtVertical += COPYSTR(CaptionExpr,i,1);
            1 : txtTable    += COPYSTR(CaptionExpr,i,1);
            2 : txtField    += COPYSTR(CaptionExpr,i,1);
          END;
      END;

      //Si el vertical es QuoBuilding
      IF (txtVertical = '7206910') THEN BEGIN
        CASE txtTable OF
          '0': // Esto son campos fijos que no van sobre tabla directamente
            CASE txtField OF
              // QB: 1,2,3 son dimensiones obligatorias,
              //'1': IF Dimension.GET(GeneralLedgerSetup."Mandatory Dimension 1") THEN
              //      CaptionExpr := Dimension.GetMLCodeCaption(txtLanguaje);
              //'2': IF Dimension.GET(GeneralLedgerSetup."Mandatory Dimension 2") THEN
              //      CaptionExpr := Dimension.GetMLCodeCaption(txtLanguaje);
              //'3': IF Dimension.GET(GeneralLedgerSetup."Mandatory Dimension 3") THEN
              //      CaptionExpr := Dimension.GetMLCodeCaption(txtLanguaje);

              //QB 11 a 15 son las fechas en estudios, 21 a 25 son las fecha en proyectos
              //JAV 14/07/21: - QB 1.09.05 Se suprime pues se usa de otra menra mejor
              //'11','12','13','14','15','21','22','23','24','25' : CaptionExpr := InternalsStatus.GetDateName(txtField);
            END;
          ELSE
            BEGIN
              IF NOT EVALUATE(idTable, txtTable) THEN
                EXIT;
              IF NOT EVALUATE(idField, txtField) THEN
                EXIT;

              //JAV 14/09/22: - QB 1.11.02 Verificar que existe el campo antes de procesar su cambio de caption
              IF (NOT Field.GET(idTable,idField)) THEN
                EXIT;

              CaptionExpr := '';
              IF QBTablesSetup.GET(idTable, idField, txtLanguaje) THEN    //Lo busco en el idioma del programa
                CaptionExpr := QBTablesSetup."New Caption"
              ELSE IF QBTablesSetup.GET(idTable, idField, '') THEN        //Si no existe, uso el del texto sin idioma
                CaptionExpr := QBTablesSetup."New Caption";
              IF CaptionExpr = '' THEN BEGIN                              //Si no existe, uso el m�todo est�ndar
                recLanguage.RESET;
                recLanguage.SETRANGE("Windows Language ID",Language);
                // IF recLanguage.FINDFIRST THEN
                //   CaptionExpr := CaptionManagement1.GetTranslatedFieldCaption(recLanguage.Code, idTable, idField)
                // ELSE
                //   CaptionExpr := CaptionManagement1.GetTranslatedFieldCaption(recLanguage.GetUserLanguage, idTable, idField);
              END;
            END;
        END;
      END;
    END;

    LOCAL PROCEDURE "------------------------------------------------------- Control de campos obligatorios"();
    BEGIN
    END;

    LOCAL PROCEDURE CheckTableMandatoryFields(VAR RecRef : RecordRef;Bloqued : Integer;DataMised : Integer;DataMisedTxt : Integer;DataMisedOldBlocked : Integer;Messages : Boolean) : Boolean;
    VAR
      TEXTBlocked : TextConst ENU='%1 %2 will be blocked until mandatory fields are filled.\%3',ESP='%1 %2 %3 permanecera bloqueado hasta que se informen los campos obligatorios que faltan:\%4';
      TEXTUnblocked : TextConst ENU='%1 %2 is now unblocked.',ESP='%1 %2 %3 se ha desbloqueado.';
      TEXTStillBlocked : TextConst ENU='%1 %2 will be still blocked: \%3.',ESP='%1 %2 %3 no faltan datos pero recupera el valor anterio de bloqueado: \%4.';
      fRef0 : FieldRef;
      CTBOOL : TextConst ESP='Boolean';
      fRef1 : FieldRef;
      fRef2 : FieldRef;
      fRef3 : FieldRef;
      fRef4 : FieldRef;
      AllBlocked : Option;
      Mised : Boolean;
      xMised : Boolean;
      txtMised : Text;
      txtAux : Text;
      i : Integer;
    BEGIN
      //JAV 17/09/20: - QB 1.06.14 Verificar los campos obligatorios y
      //                             * Si faltan datos, guardamos el valor actual del bloqueo y bloqueamos el registro
      //                             * Si no faltan, restituimos el valor anterior del bloqueos que nos guardamos antes

      //Creamos las referencias a los campos del registro
      fRef0 := RecRef.FIELDINDEX(1);
      fRef1 := RecRef.FIELD(Bloqued);
      fRef2 := RecRef.FIELD(DataMised);
      fRef3 := RecRef.FIELD(DataMisedTxt);
      fRef4 := RecRef.FIELD(DataMisedOldBlocked);

      //Limpiamos el ultimo error que hubiera y buscamos si falta un campo en la tabla
      CLEARLASTERROR;
      Mised    := CheckMandatoryFields(RecRef);
      xMised   := fRef2.VALUE;
      txtMised := COPYSTR(GETLASTERRORTEXT, 1, fRef3.LENGTH); //Obtenemos el ultimo error si lo hubiera, si no devuelve texto en blanco.

      //Si ahora faltan datos y antes no, guardamos el valor del bloqueo y bloqueamos
      IF (Mised) AND (NOT xMised) THEN BEGIN
        fRef4.VALUE := fRef1.VALUE;
        IF (FORMAT(fRef1.TYPE) = CTBOOL) THEN
          fRef1.VALUE := TRUE
        ELSE BEGIN
          //Busco el m�ximo valor de bloqueo del campo
          AllBlocked := 0;
          txtAux := fRef1.OptionMembers;
          FOR i:=1 TO STRLEN(txtAux) DO
            IF (COPYSTR(txtAux,i,1)=',') THEN
              AllBlocked += 1;

          fRef1.VALUE := AllBlocked
        END;
        IF (Messages) THEN
          MESSAGE(TEXTBlocked, RecRef.CAPTION, RecRef.CURRENTKEY, fRef0.VALUE, GETLASTERRORTEXT);
      END;

      //Si ahora no faltan datos y antes si faltaban, desbloqueamos
      IF (NOT Mised) AND (xMised) THEN BEGIN
        fRef1.VALUE := fRef4.VALUE;
        IF (FORMAT(fRef1.TYPE) <> CTBOOL) THEN
          fRef4.VALUE := 0
        ELSE
          fRef4.VALUE := FALSE;
        IF (Messages) THEN BEGIN
          IF (FORMAT(fRef1.VALUE) = FORMAT(0)) OR (FORMAT(fRef1.VALUE) = FORMAT(FALSE)) THEN                 //Antes estaba desbloqueado
            MESSAGE(TEXTUnblocked, RecRef.CAPTION, RecRef.CURRENTKEY, fRef0.VALUE)
          ELSE                                                                                               //Antes estaba bloqueado
            MESSAGE(TEXTStillBlocked, RecRef.CAPTION, RecRef.CURRENTKEY, fRef0.VALUE, fRef1.VALUE);
        END;
      END;

      //Si cambia el mensaje de bloqueo, hay que guardarse el registro
      IF (FORMAT(fRef3.VALUE) <> txtMised) THEN BEGIN
        fRef2.VALUE := Mised;
        fRef3.VALUE := txtMised;
        RecRef.MODIFY(FALSE);  //Si ha cambiado el dato hay que guardar el registro
      END;

      EXIT(Mised <> xMised); //Si ha cambiado el dato hay que guardar el registro
    END;

    LOCAL PROCEDURE CheckMandatoryFields(RecRef : RecordRef) : Boolean;
    VAR
      QBTablesSetup : Record 7206903;
    BEGIN
      //JAV 02/04/20 - ELECNOR GEN001. Verificar los campos obligatorios de una tabla

      QBTablesSetup.RESET;
      QBTablesSetup.SETRANGE(Table, RecRef.NUMBER);
      QBTablesSetup.SETRANGE("Mandatory Field", TRUE);
      IF QBTablesSetup.FINDSET THEN BEGIN
        REPEAT
          //Comprobar si hay un campo vacio
          IF NOT CheckTableField(RecRef, QBTablesSetup."Field No.") THEN
            EXIT(TRUE);
        UNTIL QBTablesSetup.NEXT = 0;
      END;
      EXIT(FALSE);
    END;

    [TryFunction]
    LOCAL PROCEDURE CheckTableField(RecRef : RecordRef;FieldNo : Integer);
    VAR
      FRef : FieldRef;
      TEXT50000 : TextConst ENU='Field% 1 must have a valid value.',ESP='Campo %1 debe tener un valor v�lido.';
    BEGIN
      //JAV 02/04/20 - ELECNOR GEN001. Retorna si falta un campo en una tabla, al ser TryFunction, el error lo devuelve como TRUE o FALSE

      FRef := RecRef.FIELD(FieldNo);
      IF FORMAT(FRef.VALUE) = '' THEN
        ERROR(TEXT50000,FRef.CAPTION,RecRef.CAPTION); //Indican que debe aparecer el nombre del campo en el cual falta informaci�n (no es obvio cuando son dimensiones)
    END;

    LOCAL PROCEDURE "------------------------------------------------------- Control de dimensiones"();
    BEGIN
    END;

    LOCAL PROCEDURE AddTableDimensions(VAR RecRef : RecordRef);
    VAR
      QBTablesSetup : Record 7206903;
      fRefClave : FieldRef;
      fRefCampo : FieldRef;
      Process : Boolean;
      Description : Text;
      rRef : RecordRef;
      fRef : FieldRef;
      TableCompany : Text;
    BEGIN
      //JAV 07/04/20 - A�ade dimensiones por defecto y crea los valores de dimensi�n a un registro de una tabla
      fRefClave := RecRef.FIELDINDEX(1);               //Campo clave del registro de la tabla, solo puede ser el campo 1 pues la tabla de valores de dimensi�n por defecto solo tiene un campo

      TableCompany := RecRef.CURRENTCOMPANY;

      QBTablesSetup.RESET;
      QBTablesSetup.SETRANGE(Table, RecRef.NUMBER);
      QBTablesSetup.SETFILTER("MDimension Code", '<>%1', '');
      QBTablesSetup.SETFILTER("MDimension Table",'<>%1',0);
      IF QBTablesSetup.FINDSET THEN BEGIN
        REPEAT
          fRefCampo := RecRef.FIELD(QBTablesSetup."Field No.");  //Campo a tratar en el registro

          IF (QBTablesSetup."MDimension Table" = QBTablesSetup.Table) THEN BEGIN    //Si es de la propia tabla, la descripci�n es el campo asociado
            fRef := RecRef.FIELD(QBTablesSetup."MDimension Field");
            Description := FORMAT(fRef.VALUE);
          END ELSE BEGIN                                                            //Si es de otra tabla, hay que leer el registro de esa tabla
            Description := '';
            rRef.OPEN(QBTablesSetup."MDimension Table", FALSE, TableCompany);
            fRef := rRef.FIELDINDEX(1);                                             //Clave del registro, solo trato el campo 1 por no complicarme demasiado
            rRef.RESET;
            fRef.SETRANGE(FORMAT(fRefCampo.VALUE));
            IF rRef.FINDFIRST() THEN BEGIN
              fRef := rRef.FIELD(QBTablesSetup."MDimension Field");
              Description := FORMAT(fRef.VALUE);
            END;
            rRef.CLOSE;
          END;

          IF (FORMAT(fRefCampo.VALUE) <> '') THEN
            SetDefaultDimensionValue(TableCompany, RecRef.NUMBER, FORMAT(fRefClave.VALUE), QBTablesSetup."MDimension Code", QBTablesSetup."MDimension Prefix", FORMAT(fRefCampo.VALUE), Description)
          ELSE
            DeleteDefaultDimensionValue(TableCompany, RecRef.NUMBER, FORMAT(fRefClave.VALUE), QBTablesSetup."MDimension Code");
        UNTIL QBTablesSetup.NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE SetDefaultDimensionValue(pCompany : Text;pTable : Integer;pCode : Code[20];pDimension : Code[20];pPrefix : Text;pValue : Text;pDescription : Text);
    VAR
      TEXT50000 : TextConst ENU='Field% 1 must have a valid value.',ESP='Campo %1 debe tener un valor v�lido.';
      DefaultDimension : Record 352;
      DimensionValue : Record 349;
      rRef : RecordRef;
      fRef : FieldRef;
    BEGIN
      //JAV 07/04/20 - A�ade un valor de dimensi�n al registro de dimensiones por defecto de una tabla
      IF (pValue = '') THEN
        EXIT;

      //Ajusto longitud y quito espacios no necesarios
      pPrefix := DELCHR(pPrefix,'<>',' ');
      pValue := DELCHR(COPYSTR(pPrefix+DELCHR(pValue,'<',' '),1,MAXSTRLEN(DimensionValue.Code)),'>',' ');
      pDescription := DELCHR(COPYSTR(DELCHR(pDescription,'<',' '), 1, MAXSTRLEN(DimensionValue.Name)),'>',' ');

      //Creo o mdifico el valor de dimensi�n
      pDescription := COPYSTR(pDescription, 1, MAXSTRLEN(DimensionValue.Name));
      DimensionValue.CHANGECOMPANY(pCompany);
      IF DimensionValue.GET(pDimension, pValue) THEN BEGIN
        DimensionValue.VALIDATE(Name, pDescription);
        DimensionValue.MODIFY;
      END ELSE BEGIN
        DimensionValue.INIT;
        DimensionValue.VALIDATE("Dimension Code", pDimension);
        DimensionValue.VALIDATE(Code, pValue);
        DimensionValue.VALIDATE(Name, pDescription);
        DimensionValue.INSERT(TRUE);
      END;

      //Asocio la dimensi�n por defecto al registro
      DefaultDimension.CHANGECOMPANY(pCompany);
      IF DefaultDimension.GET(pTable, pCode, pDimension) THEN BEGIN
        DefaultDimension."Dimension Value Code" := pValue;
        DefaultDimension."Value Posting" := DefaultDimension."Value Posting"::"Same Code";
        DefaultDimension.MODIFY;
      END ELSE BEGIN
        DefaultDimension."Table ID" := pTable;
        DefaultDimension."No." := pCode;
        DefaultDimension."Dimension Code" := pDimension;
        DefaultDimension."Dimension Value Code" := pValue;
        DefaultDimension."Value Posting" := DefaultDimension."Value Posting"::"Same Code";
        DefaultDimension.INSERT;
      END;
    END;

    LOCAL PROCEDURE DeleteDefaultDimensionValue(pCompany : Text;pTable : Integer;pCode : Code[20];pDimension : Code[20]);
    VAR
      TEXT50000 : TextConst ENU='Field% 1 must have a valid value.',ESP='Campo %1 debe tener un valor v�lido.';
      DefaultDimension : Record 352;
      DimensionValue : Record 349;
      rRef : RecordRef;
      fRef : FieldRef;
    BEGIN
      //JAV 17/09/20 - Quito la dimensi�n por defecto del registro si la tiene
      DefaultDimension.CHANGECOMPANY(pCompany);
      IF DefaultDimension.GET(pTable, pCode, pDimension) THEN
        DefaultDimension.DELETE;
    END;

    LOCAL PROCEDURE "------------------------------------------------------- Tablas de las que se manejan sus campos: 18 Customer"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 18, OnAfterInsertEvent, '', true, true)]
    LOCAL PROCEDURE T18_OnAfterInsertEvent(VAR Rec : Record 18;RunTrigger : Boolean);
    VAR
      oRef : RecordRef;
    BEGIN
      //JAV 02/04/20 - ELECNOR GEN001. Verificar campos obligatorios en la tabla
      //JAV 10/09/20: - QB 1.06.12 Activar las dimensiones autom�ticas

      IF NOT RunTrigger THEN
        EXIT;

      oRef.GETTABLE(Rec);
      IF CheckTableMandatoryFields(oRef, Rec.FIELDNO(Blocked), Rec.FIELDNO("QB Data Missed"), Rec.FIELDNO("QB Data Missed Message"), Rec.FIELDNO("QB Data Missed Old Blocked"), FALSE) THEN
        Rec.FIND('=');    //Vuelvo a leer el registro si ha cambiado el bloqueo

      AddTableDimensions(oRef);
    END;

    [EventSubscriber(ObjectType::Table, 18, OnAfterModifyEvent, '', true, true)]
    LOCAL PROCEDURE T18_OnAfterModifyEvent(VAR Rec : Record 18;VAR xRec : Record 18;RunTrigger : Boolean);
    VAR
      oRef : RecordRef;
    BEGIN
      //JAV 02/04/20 - ELECNOR GEN001. Verificar campos obligatorios en la tabla
      //JAV 10/09/20: - QB 1.06.12 Activar las dimensiones autom�ticas
      IF NOT RunTrigger THEN
        EXIT;

      oRef.GETTABLE(Rec);
      IF CheckTableMandatoryFields(oRef, Rec.FIELDNO(Blocked), Rec.FIELDNO("QB Data Missed"), Rec.FIELDNO("QB Data Missed Message"), Rec.FIELDNO("QB Data Missed Old Blocked"), FALSE) THEN
        Rec.FIND('=');    //Vuelvo a leer el registro si ha cambiado el bloqueo

      AddTableDimensions(oRef);
    END;

    LOCAL PROCEDURE "------------------------------------------------------- Tablas de las que se manejan sus campos: 23 Vendor"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 23, OnAfterInsertEvent, '', true, true)]
    LOCAL PROCEDURE T23_OnAfterInsertEvent(VAR Rec : Record 23;RunTrigger : Boolean);
    VAR
      oRef : RecordRef;
    BEGIN
      //JAV 02/04/20 - ELECNOR GEN001. Verificar campos obligatorios en la tabla
      IF NOT RunTrigger THEN
        EXIT;

      oRef.GETTABLE(Rec);
      IF CheckTableMandatoryFields(oRef, Rec.FIELDNO(Blocked), Rec.FIELDNO("QB Data Missed"), Rec.FIELDNO("QB Data Missed Message"), Rec.FIELDNO("QB Data Missed Old Blocked"), FALSE) THEN
        Rec.FIND('=');    //Vuelvo a leer el registro si ha cambiado el bloqueo

      AddTableDimensions(oRef);
    END;

    [EventSubscriber(ObjectType::Table, 23, OnAfterModifyEvent, '', true, true)]
    LOCAL PROCEDURE T23_OnAfterModifyEvent(VAR Rec : Record 23;VAR xRec : Record 23;RunTrigger : Boolean);
    VAR
      oRef : RecordRef;
    BEGIN
      //JAV 02/04/20 - ELECNOR GEN001. Verificar campos obligatorios en la tabla
      IF NOT RunTrigger THEN
        EXIT;

      oRef.GETTABLE(Rec);
      IF CheckTableMandatoryFields(oRef, Rec.FIELDNO(Blocked), Rec.FIELDNO("QB Data Missed"), Rec.FIELDNO("QB Data Missed Message"), Rec.FIELDNO("QB Data Missed Old Blocked"), FALSE) THEN
        Rec.FIND('=');    //Vuelvo a leer el registro si ha cambiado el bloqueo

      AddTableDimensions(oRef);
    END;

    LOCAL PROCEDURE "------------------------------------------------------- Tablas de las que se manejan sus campos: 27 Item"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 27, OnAfterInsertEvent, '', true, true)]
    LOCAL PROCEDURE T27_OnAfterInsertEvent(VAR Rec : Record 27;RunTrigger : Boolean);
    VAR
      oRef : RecordRef;
    BEGIN
      //JAV 02/04/20 - ELECNOR GEN001. Verificar campos obligatorios en la tabla
      //JAV 10/09/20: - QB 1.06.12 Activar las dimensiones autom�ticas

      IF NOT RunTrigger THEN
        EXIT;

      oRef.GETTABLE(Rec);
      IF CheckTableMandatoryFields(oRef, Rec.FIELDNO(Blocked), Rec.FIELDNO("QB Data Missed"), Rec.FIELDNO("QB Data Missed Message"), Rec.FIELDNO("QB Data Missed Old Blocked"), FALSE) THEN
        Rec.FIND('=');    //Vuelvo a leer el registro si ha cambiado el bloqueo
      AddTableDimensions(oRef);
    END;

    [EventSubscriber(ObjectType::Table, 27, OnAfterModifyEvent, '', true, true)]
    LOCAL PROCEDURE T27_OnAfterModifyEvent(VAR Rec : Record 27;VAR xRec : Record 27;RunTrigger : Boolean);
    VAR
      oRef : RecordRef;
    BEGIN
      //JAV 02/04/20 - ELECNOR GEN001. Verificar campos obligatorios en la tabla
      //JAV 10/09/20: - QB 1.06.12 Activar las dimensiones autom�ticas

      IF NOT RunTrigger THEN
        EXIT;

      oRef.GETTABLE(Rec);
      IF CheckTableMandatoryFields(oRef, Rec.FIELDNO(Blocked), Rec.FIELDNO("QB Data Missed"), Rec.FIELDNO("QB Data Missed Message"), Rec.FIELDNO("QB Data Missed Old Blocked"), FALSE) THEN
        Rec.FIND('=');    //Vuelvo a leer el registro si ha cambiado el bloqueo
      AddTableDimensions(oRef);
    END;

    LOCAL PROCEDURE "------------------------------------------------------- Tablas de las que se manejan sus campos: 156 Resource"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 156, OnAfterInsertEvent, '', true, true)]
    LOCAL PROCEDURE T156_OnAfterInsertEvent(VAR Rec : Record 156;RunTrigger : Boolean);
    VAR
      oRef : RecordRef;
    BEGIN
      //JAV 02/04/20 - ELECNOR GEN001. Verificar campos obligatorios en la tabla
      //JAV 10/09/20: - QB 1.06.12 Activar las dimensiones autom�ticas

      IF NOT RunTrigger THEN
        EXIT;

      oRef.GETTABLE(Rec);
      IF CheckTableMandatoryFields(oRef, Rec.FIELDNO(Blocked), Rec.FIELDNO("Data Missed"), Rec.FIELDNO("Data Missed Message"), Rec.FIELDNO("Data Missed Old Blocked"), FALSE) THEN
        Rec.FIND('=');    //Vuelvo a leer el registro si ha cambiado el bloqueo
      AddTableDimensions(oRef);
    END;

    [EventSubscriber(ObjectType::Table, 156, OnAfterModifyEvent, '', true, true)]
    LOCAL PROCEDURE T156_OnAfterModifyEvent(VAR Rec : Record 156;VAR xRec : Record 156;RunTrigger : Boolean);
    VAR
      oRef : RecordRef;
    BEGIN
      //JAV 02/04/20 - ELECNOR GEN001. Verificar campos obligatorios en la tabla
      //JAV 10/09/20: - QB 1.06.12 Activar las dimensiones autom�ticas

      IF NOT RunTrigger THEN
        EXIT;

      oRef.GETTABLE(Rec);
      IF CheckTableMandatoryFields(oRef, Rec.FIELDNO(Blocked), Rec.FIELDNO("Data Missed"), Rec.FIELDNO("Data Missed Message"), Rec.FIELDNO("Data Missed Old Blocked"), FALSE) THEN
        Rec.FIND('=');    //Vuelvo a leer el registro si ha cambiado el bloqueo
      AddTableDimensions(oRef);
    END;

    LOCAL PROCEDURE "------------------------------------------------------- Tablas de las que se manejan sus campos: 167 Job"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 167, OnAfterInsertEvent, '', true, true)]
    LOCAL PROCEDURE T167_OnAfterInsertEvent(VAR Rec : Record 167;RunTrigger : Boolean);
    VAR
      oRef : RecordRef;
    BEGIN
      //JAV 02/04/20 - ELECNOR GEN001. Verificar campos obligatorios en la tabla
      IF NOT RunTrigger THEN
        EXIT;

      oRef.GETTABLE(Rec);
      IF CheckTableMandatoryFields(oRef, Rec.FIELDNO(Blocked), Rec.FIELDNO("Data Missed"), Rec.FIELDNO("Data Missed Message"), Rec.FIELDNO("Data Missed Old Blocked"), FALSE) THEN
        Rec.FIND('=');    //Vuelvo a leer el registro si ha cambiado el bloqueo

      AddTableDimensions(oRef);
    END;

    [EventSubscriber(ObjectType::Table, 167, OnAfterModifyEvent, '', true, true)]
    LOCAL PROCEDURE T167_OnAfterModifyEvent(VAR Rec : Record 167;VAR xRec : Record 167;RunTrigger : Boolean);
    VAR
      oRef : RecordRef;
    BEGIN
      //JAV 02/04/20 - ELECNOR GEN001. Verificar campos obligatorios en la tabla
      IF NOT RunTrigger THEN
        EXIT;

      oRef.GETTABLE(Rec);
      IF CheckTableMandatoryFields(oRef, Rec.FIELDNO(Blocked), Rec.FIELDNO("Data Missed"), Rec.FIELDNO("Data Missed Message"), Rec.FIELDNO("Data Missed Old Blocked"), FALSE) THEN
        Rec.FIND('=');    //Vuelvo a leer el registro si ha cambiado el bloqueo

      AddTableDimensions(oRef);
    END;

    /*BEGIN
/*{
      JAV 30/01/20: - Manejo de los captions de las tablas
      JAV 07/04/20: - Manejo de los campos obligatorios y las dimensiones asociadas
      JAV 25/04/22: - QB 1.10.36 Se eliminan las funciones y el c�digo para sincronizar empresas, que se pasan a QM MasterData
      JAV 14/09/22: - QB 1.11.02 Verificar que existe el campo antes de procesar su cambio de caption
    }
END.*/
}







