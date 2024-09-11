Codeunit 50849 "Outlook Synch. Setup Mgt. 1"
{


    trigger OnRun()
    BEGIN
    END;

    VAR
        OSynchDependency: Record "Outlook Synch. Dependency 1";
        OSynchEntity: Record "Outlook Synch. Entity 1";
        OSynchEntityElement: Record "Outlook Synch. Entity Element1";
        OSynchFilter: Record "Outlook Synch. Filter 1";
        OSynchUserSetup: Record "Outlook Synch. User Setup 1";
        Field: Record 2000000041;
        OSynchTypeConversion: Codeunit 5302;
        OObjLibrary: DotNet OutlookObjectLibrary;
        Text001: TextConst ENU = 'You should select a table and define a filter.', ESP = 'Seleccione una tabla y defina un filtro.';
        Text002: TextConst ENU = 'You cannot setup a correlation with a property of an Outlook item for this field because it is not of the Option type.', ESP = 'No puede establecer una correlaci�n con una propiedad de un elemento de Outlook para este campo porque no es del tipo Option.';
        Text003: TextConst ENU = 'The filter cannot be processed because its length exceeds %1 symbols. Please redefine your criteria.', ESP = 'El filtro no se puede procesar porque su longitud supera los %1 s�mbolos. Vuelva a definir los criterios.';
        Text004: TextConst ENU = 'The %1 entity cannot be found in the %2 for the selected collection.', ESP = 'El objeto %1 no se encuentra en %2 para la colecci�n seleccionada.';
        Text005: TextConst ENU = 'The %1 entity should not have the ''%2'' %3 in the %4.', ESP = 'El objeto %1 no debe tener ''%2'' %3 en %4.';
        Text006: TextConst ENU = 'The %1 entities cannot be found in the %2 for the selected collection.', ESP = 'Los objetos %1 no se encuentran en %2 para la colecci�n seleccionada.';
        Text007: TextConst ENU = 'You cannot setup a correlation with this field. This property of an Outlook item is not an enumeration value. Use the Assist button to see a list of valid enumeration values.', ESP = 'No puede establecer una correlaci�n con este campo. Esta propiedad de un elemento de Outlook no es un valor de enumeraci�n. Utilice el bot�n Assist para ver una lista de valores de enumeraci�n v�lidos.';
        Text008: TextConst ENU = 'The %1 field cannot be empty.', ESP = 'El campo %1 no puede estar vac�o.';
        Text011: TextConst ENU = 'The %1 table cannot be processed because its primary key contains more than 3 fields.', ESP = 'La tabla %1 no se puede procesar porque la clave principal contiene m�s de 3 campos.';
        Text014: TextConst ENU = 'Installation and configuration of the Microsoft Outlook Integration add-in is not complete. Be sure that Outlook Integration is installed and all required objects are allowed to run.', ESP = 'No ha finalizado la instalaci�n y configuraci�n del complemento de Integraci�n con Microsoft Outlook. Aseg�rese de que la Integraci�n con Outlook est� instalada y de que se permita la ejecuci�n de todos los objetos necesarios.';

    //[External]
    PROCEDURE ShowTablesList() TableID: Integer;
    VAR
        AllObjWithCaption: Record 2000000058;
    BEGIN
        AllObjWithCaption.RESET;

        // IF PAGE.RUNMODAL(PAGE::"Outlook Synch. Table List",AllObjWithCaption) = ACTION::LookupOK THEN
        //   TableID := AllObjWithCaption."Object ID";
    END;

    //[External]
    PROCEDURE ShowTableFieldsList(TableID: Integer) FieldID: Integer;
    BEGIN
        Field.RESET;
        Field.SETRANGE(TableNo, TableID);
        Field.SETFILTER(ObsoleteState, '<>%1', Field.ObsoleteState::Removed);

        // IF PAGE.RUNMODAL(PAGE::"Outlook Synch. Table Fields",Field) = ACTION::LookupOK THEN
        //   FieldID := Field."No.";
    END;

    //[Internal]
    PROCEDURE ShowOItemsList() ItemName: Text[80];
    VAR
        // TempOSynchLookupName : Record 5306 TEMPORARY;
        Counter: Integer;
    BEGIN
        CLEAR(OObjLibrary);
        IF NOT CANLOADTYPE(OObjLibrary) THEN
            ERROR(Text014);
        OObjLibrary := OObjLibrary.OutlookObjectLibrary;

        // FOR Counter := 1 TO OObjLibrary.ItemsCount DO BEGIN
        //   TempOSynchLookupName.INIT;
        //   TempOSynchLookupName.Name := OObjLibrary.GetItemName(Counter);
        //   TempOSynchLookupName."Entry No." := Counter;
        //   TempOSynchLookupName.INSERT;
        // END;

        // ItemName := ShowLookupNames(TempOSynchLookupName);
    END;

    //[Internal]
    PROCEDURE ShowOItemProperties(ItemName: Text) PropertyName: Text[80];
    VAR
        // TempOSynchLookupName : Record 5306 TEMPORARY;
        PropertyList: DotNet OutlookPropertyList;
        Counter: Integer;
    BEGIN
        CLEAR(OObjLibrary);
        IF NOT CANLOADTYPE(OObjLibrary) THEN
            ERROR(Text014);
        OObjLibrary := OObjLibrary.OutlookObjectLibrary;

        PropertyList := OObjLibrary.GetItem(ItemName);

        // FOR Counter := 0 TO PropertyList.Count - 1 DO
        //   IF NOT PropertyList.Item(Counter).ReturnsCollection THEN BEGIN
        //     TempOSynchLookupName.INIT;
        //     TempOSynchLookupName.Name := PropertyList.Item(Counter).Name;
        //     TempOSynchLookupName."Entry No." := Counter + 1;
        //     TempOSynchLookupName.INSERT;
        //   END;

        // PropertyName := ShowLookupNames(TempOSynchLookupName);
    END;

    //[Internal]
    PROCEDURE ShowOCollectionsList(ItemName: Text) CollectionName: Text[80];
    VAR
        // TempOSynchLookupName : Record 5306 TEMPORARY;
        PropertyList: DotNet OutlookPropertyList;
        Counter: Integer;
    BEGIN
        CLEAR(OObjLibrary);
        IF NOT CANLOADTYPE(OObjLibrary) THEN
            ERROR(Text014);
        OObjLibrary := OObjLibrary.OutlookObjectLibrary;

        PropertyList := OObjLibrary.GetItem(ItemName);

        // FOR Counter := 0 TO PropertyList.Count - 1 DO
        //   IF PropertyList.Item(Counter).ReturnsCollection THEN BEGIN
        //     TempOSynchLookupName.INIT;
        //     TempOSynchLookupName.Name := PropertyList.Item(Counter).Name;
        //     TempOSynchLookupName."Entry No." := Counter + 1;
        //     TempOSynchLookupName.INSERT;
        //   END;

        // CollectionName := COPYSTR(ShowLookupNames(TempOSynchLookupName),1,250);
    END;

    //[Internal]
    PROCEDURE ShowOCollectionProperties(ItemName: Text; CollectionName: Text) PropertyName: Text[80];
    VAR
        // TempOSynchLookupName : Record 5306 TEMPORARY;
        PropertyList: DotNet OutlookPropertyList;
        InnerPropertyList: DotNet OutlookPropertyList;
        Counter: Integer;
        Counter1: Integer;
    BEGIN
        CLEAR(OObjLibrary);
        IF NOT CANLOADTYPE(OObjLibrary) THEN
            ERROR(Text014);
        OObjLibrary := OObjLibrary.OutlookObjectLibrary;

        PropertyList := OObjLibrary.GetItem(ItemName);

        FOR Counter := 0 TO PropertyList.Count - 1 DO
            IF PropertyList.Item(Counter).ReturnsCollection THEN
                IF PropertyList.Item(Counter).Name = CollectionName THEN BEGIN
                    InnerPropertyList := PropertyList.Item(Counter).PropertyInfoList;
                    // FOR Counter1 := 0 TO InnerPropertyList.Count - 1 DO BEGIN
                    //   TempOSynchLookupName.INIT;
                    //   TempOSynchLookupName.Name := InnerPropertyList.Item(Counter1).Name;
                    //   TempOSynchLookupName."Entry No." := TempOSynchLookupName."Entry No." + 1;
                    //   TempOSynchLookupName.INSERT;
                    // END;
                END;

        // PropertyName := ShowLookupNames(TempOSynchLookupName);
    END;

    //[External]
    PROCEDURE ShowOEntityCollections(UserID: Code[50]; SynchEntityCode: Code[10]) ElementNo: Integer;
    VAR
        // TempOSynchLookupName : Record 5306 TEMPORARY;
        CollectionName: Text;
    BEGIN
        WITH OSynchEntityElement DO BEGIN
            RESET;
            SETRANGE("Synch. Entity Code", SynchEntityCode);
            SETFILTER("Outlook Collection", '<>%1', '');

            // IF FIND('-') THEN
            //   REPEAT
            //     TempOSynchLookupName.INIT;
            //     TempOSynchLookupName.Name := "Outlook Collection";
            //     TempOSynchLookupName."Entry No." := "Element No.";
            //     TempOSynchLookupName.INSERT;
            //   UNTIL NEXT = 0;

            // CollectionName := ShowLookupNames(TempOSynchLookupName);
            IF CollectionName <> '' THEN BEGIN
                SETRANGE("Outlook Collection", CollectionName);
                IF FINDFIRST THEN
                    IF CheckOCollectionAvailability(OSynchEntityElement, UserID) THEN
                        ElementNo := "Element No.";
            END;
        END;
    END;

    //[External]
    PROCEDURE ShowOptionsLookup(OptionString: Text) OptionID: Integer;
    VAR
        // TempOSynchLookupName : Record 5306 TEMPORARY;
        Separator: Text;
        TempString: Text;
        NamesCount: Integer;
        Counter: Integer;
    BEGIN
        IF OptionString = '' THEN
            EXIT;

        Separator := ',';
        NamesCount := 0;
        TempString := OptionString;

        WHILE STRPOS(TempString, Separator) <> 0 DO BEGIN
            NamesCount := NamesCount + 1;
            TempString := DELSTR(TempString, STRPOS(TempString, Separator), 1);
        END;

        // FOR Counter := 1 TO NamesCount + 1 DO BEGIN
        //   TempOSynchLookupName.INIT;
        //   TempOSynchLookupName.Name := SELECTSTR(Counter,OptionString);
        //   TempOSynchLookupName."Entry No." := TempOSynchLookupName."Entry No." + 1;
        //   TempOSynchLookupName.INSERT;
        // END;

        // TempString := ShowLookupNames(TempOSynchLookupName);
        // TempOSynchLookupName.SETCURRENTKEY(Name);
        // TempOSynchLookupName.SETRANGE(Name,TempString);
        // IF TempOSynchLookupName.FINDFIRST THEN
        //   OptionID := TempOSynchLookupName."Entry No.";
    END;

    //[Internal]
    PROCEDURE ShowEnumerationsLookup(ItemName: Text; CollectionName: Text; PropertyName: Text; VAR EnumerationNo: Integer) SelectedName: Text[80];
    VAR
        // TempOSynchLookupName : Record 5306 TEMPORARY;
        PropertyList: DotNet OutlookPropertyList;
        InnerPropertyList: DotNet OutlookPropertyList;
        PropertyItem: DotNet OutlookPropertyInfo;
        InnerPropertyItem: DotNet OutlookPropertyInfo;
        Counter: Integer;
        Counter1: Integer;
        Counter2: Integer;
    BEGIN
        CLEAR(OObjLibrary);
        IF NOT CANLOADTYPE(OObjLibrary) THEN
            ERROR(Text014);
        OObjLibrary := OObjLibrary.OutlookObjectLibrary;

        PropertyList := OObjLibrary.GetItem(ItemName);

        IF CollectionName = '' THEN BEGIN
            FOR Counter := 0 TO PropertyList.Count - 1 DO BEGIN
                PropertyItem := PropertyList.Item(Counter);
                IF NOT PropertyItem.ReturnsCollection AND (PropertyItem.Name = PropertyName) THEN
                    IF PropertyItem.ReturnsEnumeration THEN BEGIN
                        // FOR Counter1 := 0 TO PropertyItem.EnumerationValues.Count - 1 DO BEGIN
                        //   TempOSynchLookupName.INIT;
                        //   TempOSynchLookupName.Name := PropertyItem.EnumerationValues.Item(Counter1).Key;
                        //   TempOSynchLookupName."Entry No." := PropertyItem.EnumerationValues.Item(Counter1).Value;
                        //   TempOSynchLookupName.INSERT;
                        // END;

                        // SelectedName := ShowLookupNames(TempOSynchLookupName);
                        // EnumerationNo := TempOSynchLookupName."Entry No.";
                        EXIT;
                    END;
            END;
        END ELSE
            FOR Counter := 0 TO PropertyList.Count - 1 DO
                IF PropertyList.Item(Counter).ReturnsCollection AND (PropertyList.Item(Counter).Name = CollectionName) THEN BEGIN
                    InnerPropertyList := PropertyList.Item(Counter).PropertyInfoList;
                    FOR Counter1 := 0 TO InnerPropertyList.Count - 1 DO BEGIN
                        InnerPropertyItem := InnerPropertyList.Item(Counter1);
                        IF InnerPropertyItem.Name = PropertyName THEN
                            IF InnerPropertyItem.ReturnsEnumeration THEN BEGIN
                                //   FOR Counter2 := 0 TO InnerPropertyItem.EnumerationValues.Count - 1 DO BEGIN
                                //     TempOSynchLookupName.INIT;
                                //     TempOSynchLookupName.Name := InnerPropertyItem.EnumerationValues.Item(Counter2).Key;
                                //     TempOSynchLookupName."Entry No." := InnerPropertyItem.EnumerationValues.Item(Counter2).Value;
                                //     TempOSynchLookupName.INSERT;
                                //   END;

                                //   SelectedName := ShowLookupNames(TempOSynchLookupName);
                                //   EnumerationNo := TempOSynchLookupName."Entry No.";
                                //   EXIT;
                            END;
                    END;
                END;
    END;

    // LOCAL PROCEDURE ShowLookupNames(VAR OSynchLookupNameRec : Record 5306) SelectedName : Text[80];
    // BEGIN
    // OSynchLookupNameRec.FINDFIRST;

    // IF PAGE.RUNMODAL(PAGE::"Outlook Synch. Lookup Names",OSynchLookupNameRec) = ACTION::LookupOK THEN
    //   SelectedName := OSynchLookupNameRec.Name;
    // END;

    //[External]
    PROCEDURE ShowOSynchFiltersForm(RecGUID: GUID; TableNo: Integer; MasterTableNo: Integer) ComposedFilter: Text;
    VAR
        TempOSynchFilter: Record "Outlook Synch. Filter 1" TEMPORARY;
        // OSynchFiltersForm : Page 5303;
        LookUpOk: Boolean;
        ShowWarning: Boolean;
    BEGIN
        IF TableNo = 0 THEN
            ERROR(Text001);

        OSynchFilter.RESET;
        OSynchFilter.SETRANGE("Record GUID", RecGUID);
        IF MasterTableNo = 0 THEN
            OSynchFilter.SETRANGE("Filter Type", OSynchFilter."Filter Type"::Condition)
        ELSE
            OSynchFilter.SETRANGE("Filter Type", OSynchFilter."Filter Type"::"Table Relation");

        // CLEAR(OSynchFiltersForm);
        // OSynchFiltersForm.SetTables(TableNo,MasterTableNo);
        // OSynchFiltersForm.SETTABLEVIEW(OSynchFilter);
        // OSynchFiltersForm.SETRECORD(OSynchFilter);

        TempOSynchFilter.RESET;
        TempOSynchFilter.DELETEALL;
        TempOSynchFilter.COPYFILTERS(OSynchFilter);
        IF OSynchFilter.FIND('-') THEN
            REPEAT
                TempOSynchFilter.TRANSFERFIELDS(OSynchFilter);
                TempOSynchFilter.INSERT;
            UNTIL OSynchFilter.NEXT = 0;

        // LookUpOk := OSynchFiltersForm.RUNMODAL = ACTION::OK;
        ShowWarning := LookUpOk AND ((OSynchFilter.COUNT = 0) AND (MasterTableNo <> 0));

        IF ShowWarning OR (NOT LookUpOk) THEN BEGIN
            IF OSynchFilter.COUNT > 0 THEN
                OSynchFilter.DELETEALL;
            IF TempOSynchFilter.FIND('-') THEN
                REPEAT
                    OSynchFilter.TRANSFERFIELDS(TempOSynchFilter);
                    OSynchFilter.INSERT;
                UNTIL TempOSynchFilter.NEXT = 0;
            COMMIT;
        END; //ELSE
             //   OSynchFiltersForm.GETRECORD(OSynchFilter);

        ComposedFilter := ComposeFilterExpression(RecGUID, OSynchFilter."Filter Type");
        CLEAR(OSynchFilter);
        IF ShowWarning THEN
            ERROR(Text008, OSynchEntityElement.FIELDCAPTION("Table Relation"));
    END;

    //[Internal]
    PROCEDURE ShowOOptionCorrelForm(OSynchFieldIn: Record "Outlook Synch. Field 1");
    VAR
        OSynchOptionCorrel: Record "Outlook Synch. Option Correl.1";
    BEGIN
        CLEAR(OObjLibrary);
        IF NOT CANLOADTYPE(OObjLibrary) THEN
            ERROR(Text014);
        OObjLibrary := OObjLibrary.OutlookObjectLibrary;

        IF OSynchFieldIn."Table No." = 0 THEN
            Field.GET(OSynchFieldIn."Master Table No.", OSynchFieldIn."Field No.")
        ELSE
            Field.GET(OSynchFieldIn."Table No.", OSynchFieldIn."Field No.");

        IF Field.Type <> Field.Type::Option THEN
            ERROR(Text002);

        OSynchOptionCorrel.RESET;
        OSynchOptionCorrel.SETRANGE("Synch. Entity Code", OSynchFieldIn."Synch. Entity Code");
        OSynchOptionCorrel.SETRANGE("Element No.", OSynchFieldIn."Element No.");
        OSynchOptionCorrel.SETRANGE("Field Line No.", OSynchFieldIn."Line No.");
        // PAGE.RUNMODAL(PAGE::"Outlook Synch. Option Correl.",OSynchOptionCorrel);
    END;

    //[External]
    PROCEDURE CheckOCollectionAvailability(OSynchEntityElementIn: Record "Outlook Synch. Entity Element1"; UserID: Code[50]): Boolean;
    VAR
        OSynchUserSetup1: Record "Outlook Synch. User Setup 1";
        EntityList: Text;
        CountAvailable: Integer;
    BEGIN
        OSynchDependency.RESET;
        OSynchDependency.SETRANGE("Synch. Entity Code", OSynchEntityElementIn."Synch. Entity Code");
        OSynchDependency.SETRANGE("Element No.", OSynchEntityElementIn."Element No.");
        IF OSynchDependency.FIND('-') THEN BEGIN
            REPEAT
                IF OSynchUserSetup.GET(UserID, OSynchDependency."Depend. Synch. Entity Code") THEN BEGIN
                    OSynchUserSetup1.GET(UserID, OSynchEntityElementIn."Synch. Entity Code");
                    IF (OSynchUserSetup."Synch. Direction" = OSynchUserSetup1."Synch. Direction") OR
                       (OSynchUserSetup."Synch. Direction" = OSynchUserSetup."Synch. Direction"::Bidirectional)
                    THEN
                        CountAvailable := CountAvailable + 1
                    ELSE
                        ERROR(
                          Text005,
                          OSynchUserSetup."Synch. Entity Code",
                          OSynchUserSetup."Synch. Direction",
                          OSynchUserSetup.FIELDCAPTION("Synch. Direction"),
                          OSynchUserSetup.TABLECAPTION);
                END ELSE BEGIN
                    IF EntityList = '' THEN
                        EntityList := OSynchDependency."Depend. Synch. Entity Code"
                    ELSE
                        EntityList := EntityList + ', ' + OSynchDependency."Depend. Synch. Entity Code";
                END;
            UNTIL OSynchDependency.NEXT = 0;

            IF CountAvailable = OSynchDependency.COUNT THEN
                EXIT(TRUE);

            IF STRPOS(EntityList, ',') = 0 THEN
                ERROR(Text004, EntityList, OSynchUserSetup.TABLECAPTION);
            ERROR(Text006, EntityList, OSynchUserSetup.TABLECAPTION);
        END;

        EXIT(TRUE);
    END;

    //[Internal]
    PROCEDURE ValidateEnumerationValue(VAR InputValue: Text; VAR EnumerationNo: Integer; ItemName: Text; CollectionName: Text; PropertyName: Text);
    VAR
        // TempOSynchLookupName : Record 5306 TEMPORARY;
        PropertyList: DotNet OutlookPropertyList;
        InnerPropertyList: DotNet OutlookPropertyList;
        PropertyItem: DotNet OutlookPropertyInfo;
        InnerPropertyItem: DotNet OutlookPropertyInfo;
        Counter: Integer;
        Counter1: Integer;
        Counter2: Integer;
        IntVar: Integer;
    BEGIN
        CLEAR(OObjLibrary);
        IF NOT CANLOADTYPE(OObjLibrary) THEN
            ERROR(Text014);
        OObjLibrary := OObjLibrary.OutlookObjectLibrary;

        // TempOSynchLookupName.RESET;
        // TempOSynchLookupName.DELETEALL;

        PropertyList := OObjLibrary.GetItem(ItemName);

        IF CollectionName = '' THEN BEGIN
            FOR Counter := 0 TO PropertyList.Count - 1 DO BEGIN
                PropertyItem := PropertyList.Item(Counter);

                IF NOT PropertyItem.ReturnsCollection AND (PropertyItem.Name = PropertyName) THEN
                    IF PropertyItem.ReturnsEnumeration THEN BEGIN
                        // FOR Counter1 := 0 TO PropertyItem.EnumerationValues.Count - 1 DO BEGIN
                        //   TempOSynchLookupName.INIT;
                        //   TempOSynchLookupName.Name := PropertyItem.EnumerationValues.Item(Counter1).Key;
                        //   TempOSynchLookupName."Entry No." := PropertyItem.EnumerationValues.Item(Counter1).Value;
                        //   TempOSynchLookupName.INSERT;
                        // END;

                        // IF EVALUATE(IntVar,InputValue) THEN BEGIN
                        //   TempOSynchLookupName.RESET;
                        //   TempOSynchLookupName.SETRANGE("Entry No.",IntVar);
                        //   IF TempOSynchLookupName.FINDFIRST THEN BEGIN
                        //     InputValue := TempOSynchLookupName.Name;
                        //     EnumerationNo := TempOSynchLookupName."Entry No.";
                        //     EXIT;
                        //   END;
                        // END;

                        // TempOSynchLookupName.RESET;
                        // TempOSynchLookupName.SETFILTER(Name,'@' + InputValue + '*');
                        // IF NOT TempOSynchLookupName.FINDFIRST THEN
                        //   ERROR(Text007);

                        // InputValue := TempOSynchLookupName.Name;
                        // EnumerationNo := TempOSynchLookupName."Entry No.";
                        EXIT;
                    END;
            END;
        END ELSE
            FOR Counter := 0 TO PropertyList.Count - 1 DO BEGIN
                PropertyItem := PropertyList.Item(Counter);
                IF PropertyItem.ReturnsCollection AND (PropertyItem.Name = CollectionName) THEN BEGIN
                    InnerPropertyList := PropertyItem.PropertyInfoList;
                    FOR Counter1 := 0 TO InnerPropertyList.Count - 1 DO BEGIN
                        InnerPropertyItem := InnerPropertyList.Item(Counter1);
                        IF InnerPropertyItem.Name = PropertyName THEN
                            IF InnerPropertyItem.ReturnsEnumeration THEN BEGIN
                                FOR Counter2 := 0 TO InnerPropertyItem.EnumerationValues.Count - 1 DO BEGIN
                                    // TempOSynchLookupName.INIT;
                                    // TempOSynchLookupName.Name := InnerPropertyItem.EnumerationValues.Item(Counter2).Key;
                                    // TempOSynchLookupName."Entry No." := InnerPropertyItem.EnumerationValues.Item(Counter2).Value;
                                    // TempOSynchLookupName.INSERT;
                                END;

                                IF EVALUATE(IntVar, InputValue) THEN BEGIN
                                    // TempOSynchLookupName.RESET;
                                    // TempOSynchLookupName.SETRANGE("Entry No.",IntVar);
                                    // IF TempOSynchLookupName.FINDFIRST THEN BEGIN
                                    //   InputValue := TempOSynchLookupName.Name;
                                    //   EnumerationNo := TempOSynchLookupName."Entry No.";
                                    //   EXIT;
                                    // END;
                                END;

                                // TempOSynchLookupName.RESET;
                                // TempOSynchLookupName.SETFILTER(Name,'@' + InputValue + '*');
                                // IF NOT TempOSynchLookupName.FINDFIRST THEN
                                //   ERROR(Text007);

                                // InputValue := TempOSynchLookupName.Name;
                                // EnumerationNo := TempOSynchLookupName."Entry No.";
                                EXIT;
                            END;
                    END;
                END;
            END;
    END;

    //[External]
    PROCEDURE ValidateFieldName(VAR NameString: Text; TableID: Integer): Boolean;
    BEGIN
        Field.RESET;
        Field.SETRANGE(TableNo, TableID);
        Field.SETFILTER("Field Caption", '@' + OSynchTypeConversion.ReplaceFilterChars(NameString) + '*');
        IF Field.FINDFIRST THEN BEGIN
            NameString := Field."Field Caption";
            EXIT(TRUE);
        END;
    END;

    //[Internal]
    PROCEDURE ValidateOutlookItemName(VAR InputString: Text): Boolean;
    VAR
        // TempOSynchLookupName : Record 5306 TEMPORARY;
        Counter: Integer;
    BEGIN
        CLEAR(OObjLibrary);
        IF NOT CANLOADTYPE(OObjLibrary) THEN
            ERROR(Text014);
        OObjLibrary := OObjLibrary.OutlookObjectLibrary;

        // FOR Counter := 1 TO OObjLibrary.ItemsCount DO BEGIN
        //   TempOSynchLookupName.INIT;
        //   TempOSynchLookupName.Name := OObjLibrary.GetItemName(Counter);
        //   TempOSynchLookupName."Entry No." := Counter;
        //   TempOSynchLookupName.INSERT;
        // END;

        // TempOSynchLookupName.SETCURRENTKEY(Name);
        // TempOSynchLookupName.SETFILTER(Name,'@' + OSynchTypeConversion.ReplaceFilterChars(InputString) + '*');

        // IF TempOSynchLookupName.FINDFIRST THEN BEGIN
        //   InputString := TempOSynchLookupName.Name;
        //   EXIT(TRUE);
        // END;
    END;

    //[Internal]
    PROCEDURE ValidateOutlookCollectionName(VAR InputString: Text; ItemName: Text): Boolean;
    VAR
        // TempOSynchLookupName : Record 5306 TEMPORARY;
        PropertyList: DotNet OutlookPropertyList;
        Counter: Integer;
    BEGIN
        CLEAR(OObjLibrary);
        IF NOT CANLOADTYPE(OObjLibrary) THEN
            ERROR(Text014);
        OObjLibrary := OObjLibrary.OutlookObjectLibrary;

        PropertyList := OObjLibrary.GetItem(ItemName);

        // FOR Counter := 0 TO PropertyList.Count - 1 DO
        //   IF PropertyList.Item(Counter).ReturnsCollection THEN BEGIN
        //     TempOSynchLookupName.INIT;
        //     TempOSynchLookupName.Name := PropertyList.Item(Counter).Name;
        //     TempOSynchLookupName."Entry No." := Counter + 1;
        //     TempOSynchLookupName.INSERT;
        //   END;

        // TempOSynchLookupName.SETCURRENTKEY(Name);
        // TempOSynchLookupName.SETFILTER(Name,'@' + OSynchTypeConversion.ReplaceFilterChars(InputString) + '*');

        // IF TempOSynchLookupName.FINDFIRST THEN BEGIN
        //   InputString := TempOSynchLookupName.Name;
        //   EXIT(TRUE);
        // END;
    END;

    //[Internal]
    PROCEDURE ValidateOItemPropertyName(VAR InputString: Text; ItemName: Text; VAR IsReadOnly: Boolean; FullTextSearch: Boolean): Boolean;
    VAR
        // TempOSynchLookupName : Record 5306 TEMPORARY;
        PropertyList: DotNet OutlookPropertyList;
        PropertyItem: DotNet OutlookPropertyInfo;
        Counter: Integer;
    BEGIN
        IF ISNULL(OObjLibrary) THEN
            IF NOT CANLOADTYPE(OObjLibrary) THEN
                ERROR(Text014);
        OObjLibrary := OObjLibrary.OutlookObjectLibrary;

        PropertyList := OObjLibrary.GetItem(ItemName);

        // FOR Counter := 0 TO PropertyList.Count - 1 DO
        //   IF NOT PropertyList.Item(Counter).ReturnsCollection THEN BEGIN
        //     TempOSynchLookupName.INIT;
        //     TempOSynchLookupName.Name := PropertyList.Item(Counter).Name;
        //     TempOSynchLookupName."Entry No." := Counter + 1;
        //     TempOSynchLookupName.INSERT;
        //   END;

        // TempOSynchLookupName.SETCURRENTKEY(Name);

        // IF FullTextSearch THEN
        //   TempOSynchLookupName.SETFILTER(Name,'@' + OSynchTypeConversion.ReplaceFilterChars(InputString))
        // ELSE
        //   TempOSynchLookupName.SETFILTER(Name,'@' + OSynchTypeConversion.ReplaceFilterChars(InputString) + '*');

        // IF TempOSynchLookupName.FINDFIRST THEN BEGIN
        //   InputString := TempOSynchLookupName.Name;
        //   PropertyItem := PropertyList.Item(TempOSynchLookupName."Entry No." - 1);
        //   IsReadOnly := PropertyItem.IsReadOnly;
        //   EXIT(TRUE);
        // END;
    END;

    //[Internal]
    PROCEDURE ValidateOCollectPropertyName(VAR InputString: Text; ItemName: Text; CollectionName: Text; VAR IsReadOnly: Boolean; FullTextSearch: Boolean): Boolean;
    VAR
        // TempOSynchLookupName : Record 5306 TEMPORARY;
        PropertyList: DotNet OutlookPropertyList;
        InnerPropertyList: DotNet OutlookPropertyList;
        Counter: Integer;
        Counter1: Integer;
    BEGIN
        CLEAR(OObjLibrary);
        IF NOT CANLOADTYPE(OObjLibrary) THEN
            ERROR(Text014);
        OObjLibrary := OObjLibrary.OutlookObjectLibrary;

        PropertyList := OObjLibrary.GetItem(ItemName);

        FOR Counter := 0 TO PropertyList.Count - 1 DO
            IF PropertyList.Item(Counter).ReturnsCollection THEN
                IF PropertyList.Item(Counter).Name = CollectionName THEN BEGIN
                    InnerPropertyList := PropertyList.Item(Counter).PropertyInfoList;
                    // FOR Counter1 := 0 TO InnerPropertyList.Count - 1 DO BEGIN
                    //   TempOSynchLookupName.INIT;
                    //   TempOSynchLookupName.Name := InnerPropertyList.Item(Counter1).Name;
                    //   TempOSynchLookupName."Entry No." := TempOSynchLookupName."Entry No." + 1;
                    //   TempOSynchLookupName.INSERT;
                    // END;
                END;

        // TempOSynchLookupName.SETCURRENTKEY(Name);

        // IF FullTextSearch THEN
        //   TempOSynchLookupName.SETFILTER(Name,'@' + OSynchTypeConversion.ReplaceFilterChars(InputString))
        // ELSE
        //   TempOSynchLookupName.SETFILTER(Name,'@' + OSynchTypeConversion.ReplaceFilterChars(InputString) + '*');

        // IF TempOSynchLookupName.FINDFIRST THEN
        //   FOR Counter := 0 TO PropertyList.Count - 1 DO
        //     IF PropertyList.Item(Counter).ReturnsCollection THEN
        //       IF PropertyList.Item(Counter).Name = CollectionName THEN BEGIN
        //         InnerPropertyList := PropertyList.Item(Counter).PropertyInfoList;
        //         FOR Counter1 := 0 TO InnerPropertyList.Count - 1 DO BEGIN
        //           InputString := InnerPropertyList.Item(Counter1).Name;
        //           IF TempOSynchLookupName.Name = InnerPropertyList.Item(Counter1).Name THEN BEGIN
        //             InputString := InnerPropertyList.Item(Counter1).Name;
        //             IsReadOnly := InnerPropertyList.Item(Counter1).IsReadOnly;
        //             EXIT(TRUE);
        //           END;
        //         END;
        //       END;
    END;

    //[External]
    PROCEDURE ComposeFilterExpression(RecGUID: GUID; FilterType: Integer) OutFilterString: Text[250];
    VAR
        Delimiter: Text;
        TempString: Text;
        FilterLength: Integer;
    BEGIN
        OSynchFilter.RESET;
        OSynchFilter.SETRANGE("Record GUID", RecGUID);
        OSynchFilter.SETRANGE("Filter Type", FilterType);

        OutFilterString := '';
        IF OSynchFilter.FIND('-') THEN BEGIN
            Delimiter := '';
            REPEAT
                FilterLength := STRLEN(TempString) +
                  STRLEN(OSynchFilter.GetFieldCaption) + STRLEN(FORMAT(OSynchFilter.Type)) + STRLEN(OSynchFilter.Value);
                IF FilterLength + STRLEN(TempString) > MAXSTRLEN(TempString) - 5 THEN
                    ERROR(Text003, FORMAT(MAXSTRLEN(TempString)));
                TempString :=
                  STRSUBSTNO('%1%2%3=%4(%5)',
                    TempString, Delimiter, OSynchFilter.GetFieldCaption, FORMAT(OSynchFilter.Type), OSynchFilter.Value);
                Delimiter := ',';
            UNTIL OSynchFilter.NEXT = 0;

            TempString := STRSUBSTNO('WHERE(%1)', TempString);
            IF STRLEN(TempString) > 250 THEN
                OutFilterString := STRSUBSTNO('%1...', COPYSTR(TempString, 1, 247))
            ELSE
                OutFilterString := TempString;
        END;
    END;

    //[External]
    PROCEDURE ComposeTableFilter(VAR OSynchFilterIn: Record "Outlook Synch. Filter 1"; SynchRecRef: RecordRef) OutFilterString: Text[250];
    VAR
        MasterFieldRef: FieldRef;
        Delimiter: Text;
        TempStr: Text;
        FilterString: Text;
        FilterLength: Integer;
    BEGIN
        OutFilterString := '';
        FilterString := '';
        IF NOT OSynchFilterIn.FIND('-') THEN
            EXIT;

        Delimiter := '';
        REPEAT
            CASE OSynchFilterIn.Type OF
                OSynchFilterIn.Type::CONST:
                    BEGIN
                        TempStr := OSynchFilterIn.FilterExpression;
                        FilterString := STRSUBSTNO('%1%2%3', FilterString, Delimiter, TempStr)
                    END;
                OSynchFilterIn.Type::FILTER:
                    BEGIN
                        TempStr := OSynchFilterIn.FilterExpression;
                        FilterString := STRSUBSTNO('%1%2%3', FilterString, Delimiter, TempStr)
                    END;
                OSynchFilterIn.Type::FIELD:
                    BEGIN
                        MasterFieldRef := SynchRecRef.FIELD(OSynchFilterIn."Master Table Field No.");
                        TempStr := STRSUBSTNO('FILTER(%1)', OSynchTypeConversion.ReplaceFilterChars(FORMAT(MasterFieldRef.VALUE)));
                        FilterLength := STRLEN(FilterString) + STRLEN(Delimiter) + STRLEN(OSynchFilterIn.GetFieldCaption) + STRLEN(TempStr);
                        IF FilterLength > 1000 THEN
                            ERROR(Text003, FORMAT(1000));
                        FilterString := STRSUBSTNO('%1%2%3=%4', FilterString, Delimiter, OSynchFilterIn.GetFieldCaption, TempStr);
                    END;
            END;
            Delimiter := ',';
        UNTIL OSynchFilterIn.NEXT = 0;

        OutFilterString := COPYSTR(STRSUBSTNO('WHERE(%1)', FilterString), 1, 250);
    END;

    //[External]
    PROCEDURE ComposeTableView(VAR OSynchFilterCondition: Record "Outlook Synch. Filter 1"; VAR OSynchFilterRelation: Record "Outlook Synch. Filter 1"; RelatedRecRef: RecordRef) FilteringExpression: Text;
    VAR
        TempOSynchFilter: Record "Outlook Synch. Filter 1" TEMPORARY;
        NullRecRef: RecordRef;
    BEGIN
        CopyFilterRecords(OSynchFilterCondition, TempOSynchFilter);
        ComposeFilterRecords(OSynchFilterRelation, TempOSynchFilter, RelatedRecRef, TempOSynchFilter.Type::FILTER);

        FilteringExpression := ComposeTableFilter(TempOSynchFilter, NullRecRef);
    END;

    //[External]
    PROCEDURE CopyFilterRecords(VAR FromOSynchFilter: Record "Outlook Synch. Filter 1"; VAR ToOSynchFilter: Record "Outlook Synch. Filter 1");
    BEGIN
        IF FromOSynchFilter.FIND('-') THEN
            REPEAT
                ToOSynchFilter.INIT;
                ToOSynchFilter := FromOSynchFilter;
                IF ToOSynchFilter.INSERT THEN;
            UNTIL FromOSynchFilter.NEXT = 0;
    END;

    //[External]
    PROCEDURE ComposeFilterRecords(VAR FromOSynchFilter: Record "Outlook Synch. Filter 1"; VAR ToOSynchFilter: Record "Outlook Synch. Filter 1"; RecRef: RecordRef; FilteringType: Integer);
    VAR
        FieldRef: FieldRef;
    BEGIN
        IF FromOSynchFilter.FIND('-') THEN
            REPEAT
                FieldRef := RecRef.FIELD(FromOSynchFilter."Field No.");
                CreateFilterCondition(
                  ToOSynchFilter,
                  FromOSynchFilter."Master Table No.",
                  FromOSynchFilter."Master Table Field No.",
                  FilteringType,
                  FORMAT(FieldRef));
            UNTIL FromOSynchFilter.NEXT = 0;
    END;

    //[External]
    PROCEDURE CreateFilterCondition(VAR OSynchFilterIn: Record "Outlook Synch. Filter 1"; TableID: Integer; FieldID: Integer; FilterType: Integer; FilterValue: Text);
    VAR
        FilterValueLen: Integer;
    BEGIN
        IF FilterType = OSynchFilterIn.Type::FIELD THEN
            EXIT;

        Field.GET(TableID, FieldID);
        IF STRLEN(FilterValue) > Field.Len THEN
            FilterValue := PADSTR(FilterValue, Field.Len);

        OSynchFilterIn.INIT;
        OSynchFilterIn."Record GUID" := CREATEGUID;
        OSynchFilterIn."Filter Type" := OSynchFilterIn."Filter Type"::Condition;
        OSynchFilterIn."Line No." := OSynchFilterIn."Line No." + 10000;
        OSynchFilterIn."Table No." := TableID;
        OSynchFilterIn.VALIDATE("Field No.", FieldID);
        OSynchFilterIn.Type := FilterType;

        IF FilterType = OSynchFilterIn.Type::CONST THEN BEGIN
            Field.GET(OSynchFilterIn."Table No.", OSynchFilterIn."Field No.");
            OSynchFilterIn.Value := OSynchTypeConversion.HandleFilterChars(FilterValue, Field.Len);
        END ELSE BEGIN
            FilterValueLen := Field.Len;
            Field.GET(DATABASE::"Outlook Synch. Filter 1", OSynchFilterIn.FIELDNO(Value));
            IF FilterValueLen = Field.Len THEN BEGIN
                FilterValue := PADSTR(FilterValue, Field.Len - 2);
                OSynchFilterIn.Value := '@' + OSynchTypeConversion.ReplaceFilterChars(FilterValue) + '*';
            END ELSE
                OSynchFilterIn.Value := '@' + OSynchTypeConversion.ReplaceFilterChars(FilterValue);
        END;

        IF OSynchFilterIn.INSERT(TRUE) THEN;
    END;

    //[External]
    PROCEDURE CheckPKFieldsQuantity(TableID: Integer): Boolean;
    VAR
        TempRecRef: RecordRef;
        KeyRef: KeyRef;
    BEGIN
        IF TableID = 0 THEN
            EXIT(TRUE);

        TempRecRef.OPEN(TableID, TRUE);
        KeyRef := TempRecRef.KEYINDEX(1);
        IF KeyRef.FIELDCOUNT <= 3 THEN
            EXIT(TRUE);

        ERROR(Text011, TempRecRef.CAPTION);
    END;

    //[Internal]
    PROCEDURE CheckOEnumeration(OSynchFieldIn: Record 51284) IsEnumeration: Boolean;
    VAR
        PropertyList: DotNet OutlookPropertyList;
        InnerPropertyList: DotNet OutlookPropertyList;
        Counter: Integer;
        Counter1: Integer;
    BEGIN
        IF ISNULL(OObjLibrary) THEN
            IF NOT CANLOADTYPE(OObjLibrary) THEN
                ERROR(Text014);
        OObjLibrary := OObjLibrary.OutlookObjectLibrary;

        IF OSynchFieldIn."Element No." = 0 THEN BEGIN
            PropertyList := OObjLibrary.GetItem(OSynchFieldIn."Outlook Object");
            FOR Counter := 0 TO PropertyList.Count - 1 DO BEGIN
                IF NOT PropertyList.Item(Counter).ReturnsCollection AND
                   (PropertyList.Item(Counter).Name = OSynchFieldIn."Outlook Property")
                THEN
                    IF PropertyList.Item(Counter).ReturnsEnumeration THEN
                        IsEnumeration := TRUE;
            END;
        END ELSE BEGIN
            OSynchEntity.GET(OSynchFieldIn."Synch. Entity Code");
            PropertyList := OObjLibrary.GetItem(OSynchEntity."Outlook Item");
            FOR Counter := 0 TO PropertyList.Count - 1 DO
                IF PropertyList.Item(Counter).ReturnsCollection AND
                   (PropertyList.Item(Counter).Name = OSynchFieldIn."Outlook Object")
                THEN BEGIN
                    InnerPropertyList := PropertyList.Item(Counter).PropertyInfoList;
                    FOR Counter1 := 0 TO InnerPropertyList.Count - 1 DO BEGIN
                        IF InnerPropertyList.Item(Counter1).Name = OSynchFieldIn."Outlook Property" THEN
                            IF InnerPropertyList.Item(Counter1).ReturnsEnumeration THEN
                                IsEnumeration := TRUE;
                    END;
                END;
        END;
    END;

    /* /*BEGIN
END.*/
}







