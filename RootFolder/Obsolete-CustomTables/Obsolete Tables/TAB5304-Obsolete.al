table 51284 "Outlook Synch. Field 1"
{

    DataCaptionFields = "Synch. Entity Code";
    CaptionML = ENU = 'Outlook Synch. Field', ESP = 'Campo sinc. Outlook';
    PasteIsValid = false;

    fields
    {
        field(1; "Synch. Entity Code"; Code[10])
        {
            TableRelation = "Outlook Synch. Entity 1"."Code";


            CaptionML = ENU = 'Synch. Entity Code', ESP = 'C�digo entidad sinc.';
            NotBlank = true;

            trigger OnValidate();
            BEGIN
                GetMasterInformation;
            END;


        }
        field(2; "Element No."; Integer)
        {
            TableRelation = "Outlook Synch. Entity Element1"."Element No." WHERE("Synch. Entity Code" = FIELD("Synch. Entity Code"));
            CaptionML = ENU = 'Element No.', ESP = 'N� elemento';


        }
        field(3; "Line No."; Integer)
        {
            CaptionML = ENU = 'Line No.', ESP = 'N� l�nea';


        }
        field(4; "Master Table No."; Integer)
        {
            TableRelation = AllObjWithCaption."Object ID" WHERE("Object Type" = CONST("Table"));
            CaptionML = ENU = 'Master Table No.', ESP = 'N� tabla principal';
            Editable = false;


        }
        field(5; "Outlook Object"; Text[80])
        {
            CaptionML = ENU = 'Outlook Object', ESP = 'Objeto Outlook';
            Editable = false;


        }
        field(6; "Outlook Property"; Text[80])
        {


            CaptionML = ENU = 'Outlook Property', ESP = 'Propiedad Outlook';

            trigger OnValidate();
            BEGIN
                CheckReadOnlyStatus;

                IF "Outlook Property" = xRec."Outlook Property" THEN
                    EXIT;

                IF NOT "User-Defined" AND ("Outlook Object" = '') THEN BEGIN
                    IF "Element No." = 0 THEN
                        ERROR(
                          Text009,
                          FIELDCAPTION("Outlook Property"),
                          OSynchEntity.FIELDCAPTION("Outlook Item"));
                    ERROR(
                      Text009,
                      FIELDCAPTION("Outlook Property"),
                      OSynchEntityElement.FIELDCAPTION("Outlook Collection"));
                END;
                IF SetOSynchOptionCorrelFilter(OSynchOptionCorrel) THEN BEGIN
                    IF NOT CONFIRM(STRSUBSTNO(Text008, OSynchOptionCorrel.TABLECAPTION, OSynchFilter.TABLECAPTION)) THEN BEGIN
                        "Outlook Property" := xRec."Outlook Property";
                        "User-Defined" := xRec."User-Defined";
                        EXIT;
                    END;

                    OSynchOptionCorrel.DELETEALL;
                END;

                IF "Outlook Property" <> '' THEN
                    "Field Default Value" := '';
            END;

            trigger OnLookup();
            VAR
                //                                                               PropertyName@1000 :
                PropertyName: Text[80];
            BEGIN
                IF "Outlook Object" = '' THEN BEGIN
                    IF "Element No." = 0 THEN
                        ERROR(
                          Text009,
                          FIELDCAPTION("Outlook Property"),
                          OSynchEntity.FIELDCAPTION("Outlook Item"));
                    ERROR(
                      Text009,
                      FIELDCAPTION("Outlook Property"),
                      OSynchEntityElement.FIELDCAPTION("Outlook Collection"));
                END;

                IF "User-Defined" THEN
                    ERROR(Text001);

                IF "Element No." = 0 THEN
                    PropertyName := OSynchSetupMgt.ShowOItemProperties("Outlook Object")
                ELSE BEGIN
                    OSynchEntity.GET("Synch. Entity Code");
                    PropertyName := OSynchSetupMgt.ShowOCollectionProperties(OSynchEntity."Outlook Item", "Outlook Object");
                END;

                IF PropertyName <> '' THEN
                    VALIDATE("Outlook Property", PropertyName);
            END;


        }
        field(7; "User-Defined"; Boolean)
        {


            CaptionML = ENU = 'User-Defined', ESP = 'Definido por el usuario';

            trigger OnValidate();
            BEGIN
                "Outlook Property" := '';
                IF NOT "User-Defined" THEN
                    EXIT;

                VALIDATE("Outlook Property");
            END;


        }
        field(8; "Search Field"; Boolean)
        {
            CaptionML = ENU = 'Search Field', ESP = 'Campo b�squeda';


        }
        field(9; "Condition"; Text[250])
        {
            CaptionML = ENU = 'Condition', ESP = 'Condici�n';
            Editable = false;


        }
        field(10; "Table No."; Integer)
        {
            TableRelation = AllObjWithCaption."Object ID" WHERE("Object Type" = CONST("Table"));


            CaptionML = ENU = 'Table No.', ESP = 'N� tabla';
            BlankZero = true;

            trigger OnValidate();
            BEGIN
                CALCFIELDS("Table Caption");

                IF "Table No." = xRec."Table No." THEN
                    EXIT;

                IF NOT OSynchSetupMgt.CheckPKFieldsQuantity("Table No.") THEN
                    EXIT;

                IF ("Table Relation" <> '') OR SetOSynchOptionCorrelFilter(OSynchOptionCorrel) THEN BEGIN
                    IF NOT CONFIRM(STRSUBSTNO(Text008, OSynchOptionCorrel.TABLECAPTION, OSynchFilter.TABLECAPTION)) THEN BEGIN
                        "Table No." := xRec."Table No.";
                        EXIT;
                    END;

                    OSynchOptionCorrel.DELETEALL;

                    OSynchFilter.RESET;
                    OSynchFilter.SETRANGE("Record GUID", "Record GUID");
                    OSynchFilter.SETRANGE("Filter Type", OSynchFilter."Filter Type"::"Table Relation");
                    OSynchFilter.DELETEALL;

                    "Table Relation" := '';
                END;

                "Field No." := 0;
                "Field Default Value" := '';
            END;

            trigger OnLookup();
            VAR
                //                                                               TableNo@1000 :
                TableNo: Integer;
            BEGIN
                TableNo := OSynchSetupMgt.ShowTablesList;

                IF TableNo <> 0 THEN
                    VALIDATE("Table No.", TableNo);
            END;


        }
        field(11; "Table Caption"; Text[250])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("AllObjWithCaption"."Object Caption" WHERE("Object Type" = CONST("Table"),
                                                                                                                "Object ID" = FIELD("Table No.")));
            CaptionML = ENU = 'Table Caption', ESP = 'T�tulo tabla';
            Editable = false;


        }
        field(12; "Table Relation"; Text[250])
        {


            CaptionML = ENU = 'Table Relation', ESP = 'Relaci�n de tabla';
            Editable = false;

            trigger OnValidate();
            BEGIN
                TESTFIELD("Table Relation");
                CheckReadOnlyStatus;
            END;


        }
        field(13; "Field No."; Integer)
        {


            CaptionML = ENU = 'Field No.', ESP = 'N� campo';
            BlankZero = true;

            trigger OnValidate();
            BEGIN
                TESTFIELD("Field No.");
                CheckReadOnlyStatus;

                IF "Field No." = xRec."Field No." THEN
                    EXIT;

                IF "Table No." = 0 THEN
                    Field.GET("Master Table No.", "Field No.")
                ELSE
                    Field.GET("Table No.", "Field No.");

                TypeHelper.TestFieldIsNotObsolete(Field);

                IF Field.Class = Field.Class::FlowFilter THEN
                    ERROR(Text002, Field.Class);

                IF NOT Field.Enabled THEN
                    ERROR(Text012, Field.FieldName);

                IF "User-Defined" THEN
                    VALIDATE("Outlook Property", Field."Field Caption");

                IF SetOSynchOptionCorrelFilter(OSynchOptionCorrel) THEN BEGIN
                    IF NOT CONFIRM(STRSUBSTNO(Text008, OSynchOptionCorrel.TABLECAPTION, OSynchFilter.TABLECAPTION)) THEN BEGIN
                        "Field No." := xRec."Field No.";
                        EXIT;
                    END;

                    OSynchOptionCorrel.DELETEALL;
                END;

                "Field Default Value" := '';
            END;

            trigger OnLookup();
            VAR
                //                                                               FieldNo@1000 :
                FieldNo: Integer;
            BEGIN
                IF "Table No." = 0 THEN
                    FieldNo := OSynchSetupMgt.ShowTableFieldsList("Master Table No.")
                ELSE
                    FieldNo := OSynchSetupMgt.ShowTableFieldsList("Table No.");

                IF FieldNo <> 0 THEN
                    VALIDATE("Field No.", FieldNo);
            END;


        }
        field(15; "Read-Only Status"; Option)
        {
            OptionMembers = " ","Read-Only in Microsoft Dynamics NAV","Read-Only in Outlook";

            CaptionML = ENU = 'Read-Only Status', ESP = 'Estado de s�lo lectura';
            OptionCaptionML = ENU = '" ,Read-Only in Microsoft Dynamics NAV,Read-Only in Outlook"', ESP = '" ,S�lo lectura en Microsoft Dynamics NAV,S�lo lectura en Outlook"';

            Editable = false;

            trigger OnValidate();
            BEGIN
                CheckReadOnlyStatus;
            END;


        }
        field(16; "Field Default Value"; Text[250])
        {


            CaptionML = ENU = 'Field Default Value', ESP = 'Valor predeterminado campo';

            trigger OnValidate();
            VAR
                //                                                                 RecRef@1000 :
                RecRef: RecordRef;
                //                                                                 FldRef@1001 :
                FldRef: FieldRef;
                //                                                                 BooleanValue@1002 :
                BooleanValue: Boolean;
            BEGIN
                TESTFIELD("Master Table No.");
                TESTFIELD("Field No.");

                IF "Field Default Value" = xRec."Field Default Value" THEN
                    EXIT;

                IF "Outlook Property" <> '' THEN
                    ERROR(Text005, FIELDCAPTION("Field Default Value"), FIELDCAPTION("Outlook Property"));

                CLEAR(RecRef);
                CLEAR(FldRef);

                IF "Table No." = 0 THEN BEGIN
                    Field.GET("Master Table No.", "Field No.");
                    TypeHelper.TestFieldIsNotObsolete(Field);
                    RecRef.OPEN("Master Table No.", TRUE);
                END ELSE BEGIN
                    Field.GET("Table No.", "Field No.");
                    TypeHelper.TestFieldIsNotObsolete(Field);
                    RecRef.OPEN("Table No.", TRUE);
                END;

                IF Field.Class = Field.Class::FlowField THEN
                    ERROR(Text010, Field.Class);

                FldRef := RecRef.FIELD("Field No.");

                IF Field.Type = Field.Type::Option THEN BEGIN
                    IF NOT OSynchTypeConversion.EvaluateOptionField(FldRef, "Field Default Value") THEN
                        ERROR(Text004, "Field Default Value", FldRef.TYPE, FldRef.OPTIONCAPTION);
                    DefaultValueExpression := FORMAT(OSynchTypeConversion.TextToOptionValue("Field Default Value", FldRef.OPTIONCAPTION))
                END ELSE BEGIN
                    IF NOT EVALUATE(FldRef, "Field Default Value") THEN
                        ERROR(Text003, FIELDCAPTION("Field Default Value"), FldRef.TYPE);

                    IF Field.Type = Field.Type::Boolean THEN BEGIN
                        EVALUATE(BooleanValue, "Field Default Value");
                        IF BooleanValue THEN
                            DefaultValueExpression := '1'
                        ELSE
                            DefaultValueExpression := '0';
                    END;
                END;

                RecRef.CLOSE;
            END;


        }
        field(17; "Record GUID"; GUID)
        {
            DataClassification = SystemMetadata;
            CaptionML = ENU = 'Record GUID', ESP = 'GUID registro';
            Editable = false;


        }
        field(99; "DefaultValueExpression"; Text[250])
        {
            CaptionML = ENU = 'DefaultValueExpression', ESP = 'DefaultValueExpression';
            ;


        }
    }
    keys
    {
        key(key1; "Synch. Entity Code", "Element No.", "Line No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       Field@1001 :
        Field: Record 2000000041;
        //       OSynchEntity@1003 :
        OSynchEntity: Record "Outlook Synch. Entity 1";
        //       OSynchEntityElement@1004 :
        OSynchEntityElement: Record "Outlook Synch. Entity Element1";
        //       OSynchFilter@1019 :
        OSynchFilter: Record "Outlook Synch. Filter 1";
        //       OSynchOptionCorrel@1013 :
        OSynchOptionCorrel: Record "Outlook Synch. Option Correl.1";
        //       OSynchSetupMgt@1000 :
        OSynchSetupMgt: Codeunit "Outlook Synch. Setup Mgt. 1";
        //       OSynchTypeConversion@1008 :
        OSynchTypeConversion: Codeunit 5302;
        //       Text001@1015 :
        Text001: TextConst ENU = 'You cannot choose from a list of Outlook item collections for user-defined fields.', ESP = 'No puede seleccionar de una lista de colecciones de elementos de Outlook para campos definidos por el usuario.';
        //       Text002@1012 :
        Text002: TextConst ENU = 'You cannot use a %1 field for synchronization.', ESP = 'No puede utilizar un campo %1 para la sincronizaci�n.';
        //       Text003@1011 :
        Text003: TextConst ENU = 'The value of the %1 field cannot be converted to the %2 datatype.', ESP = 'El valor del campo %1 no se puede convertir al tipo de datos %2.';
        //       Text004@1010 :
        Text004: TextConst ENU = 'The value of the %1 field cannot be converted to the %2 datatype.\The possible option values are: ''%3''.', ESP = 'El valor del campo %1 no se puede convertir al tipo de datos %2.\Los valores de opci�n posibles son: ''%3''.';
        //       Text005@1009 :
        Text005: TextConst ENU = 'The %1 field should be blank when the %2 field is used.', ESP = 'El campo %1 debe estar vac�o cuando se utilice el campo %2.';
        //       Text006@1006 :
        Text006: TextConst ENU = 'This is not a valid Outlook property name.', ESP = 'No es un nombre de propiedad de Outlook v�lido.';
        //       Text007@1005 :
        Text007: TextConst ENU = 'You cannot synchronize the %1 and the %2 fields because they are both write protected.', ESP = 'No puede sincronizar los campos %1 y %2 porque est�n protegidos contra escritura.';
        //       Text008@1016 :
        Text008: TextConst ENU = 'if you change the value of this field, %1 and %2 records related to this entry will be removed.\Do you want to change this field anyway?', ESP = 'Si cambia el valor de este campo, se eliminar�n los registros %1 y %2 relacionados con este movimiento.\�Desea cambiar este campo de todos modos?';
        //       Text009@1018 :
        Text009: TextConst ENU = 'You cannot change the %1 field if the %2 is not specified for this entity.', ESP = 'No puede cambiar el campo %1 si %2 no se especific� para este objeto.';
        //       Text010@1020 :
        Text010:
// %1: Field.Class::FlowField
TextConst ENU = 'You cannot use this field for %1 fields.', ESP = 'No puede utilizar este campo para los campos %1.';
        //       Text011@1007 :
        Text011: TextConst ENU = 'The %1 table cannot be open, because the %2 or %3 fields are empty.\Fill in these fields with the appropriate values and try again.', ESP = 'La tabla %1 no se puede abrir porque los campos %2 o %3 est�n vac�os.\Cumplimente estos campos con los valores apropiados y vuelva a intentarlo.';
        //       Text012@1021 :
        Text012: TextConst ENU = 'You cannot select the %1 field because it is disabled.', ESP = 'No puede seleccionar el campo %1 porque est� deshabilitado.';
        //       Text013@1002 :
        Text013: TextConst ENU = 'You cannot use this value because an Outlook property with this name exists.', ESP = 'No puede utilizar este valor porque ya existe una propiedad de Outlook con este nombre.';
        //       Text014@1022 :
        Text014: TextConst ENU = 'The entry you are trying to create already exists.', ESP = 'El movimiento que intenta crear ya existe.';
        //       TypeHelper@1014 :
        TypeHelper: Codeunit 10;



    trigger OnInsert();
    begin
        TESTFIELD("Field No.");

        if "Table No." <> 0 then
            TESTFIELD("Table Relation");

        CheckDuplicatedRecords;

        if ISNULLGUID("Record GUID") then
            "Record GUID" := CREATEGUID;
    end;

    trigger OnModify();
    begin
        TESTFIELD("Field No.");
        CheckDuplicatedRecords;

        if "Table No." <> 0 then
            TESTFIELD("Table Relation");
    end;

    trigger OnDelete();
    var
        //                OSynchFilter@1000 :
        OSynchFilter: Record "Outlook Synch. Filter 1";
        //                OSynchOptionCorrel@1001 :
        OSynchOptionCorrel: Record "Outlook Synch. Option Correl.1";
    begin
        OSynchFilter.RESET;
        OSynchFilter.SETRANGE("Record GUID", "Record GUID");
        OSynchFilter.DELETEALL;

        OSynchOptionCorrel.RESET;
        OSynchOptionCorrel.SETRANGE("Synch. Entity Code", "Synch. Entity Code");
        OSynchOptionCorrel.SETRANGE("Element No.", "Element No.");
        OSynchOptionCorrel.SETRANGE("Field Line No.", "Line No.");
        OSynchOptionCorrel.DELETEALL;
    end;



    LOCAL procedure GetMasterInformation()
    begin
        if "Element No." = 0 then begin
            OSynchEntity.GET("Synch. Entity Code");
            "Master Table No." := OSynchEntity."Table No.";
            "Outlook Object" := OSynchEntity."Outlook Item";
        end else begin
            OSynchEntityElement.GET("Synch. Entity Code", "Element No.");
            "Master Table No." := OSynchEntityElement."Table No.";
            "Outlook Object" := OSynchEntityElement."Outlook Collection";
        end;
    end;

    LOCAL procedure CheckReadOnlyStatus()
    var
        //       OSynchProcessLine@1002 :
        // OSynchProcessLine: Codeunit 5305;
        //       IsReadOnlyOutlook@1000 :
        IsReadOnlyOutlook: Boolean;
        //       IsReadOnlyNavision@1001 :
        IsReadOnlyNavision: Boolean;
    begin
        IsReadOnlyOutlook := CheckOtlookPropertyName;

        if ("Outlook Property" <> '') and ("Field No." <> 0) then begin
            if "Table No." = 0 then begin
                Field.GET("Master Table No.", "Field No.");
                TypeHelper.TestFieldIsNotObsolete(Field);
                //     if OSynchProcessLine.CheckKeyField("Master Table No.", "Field No.") or (Field.Class = Field.Class::FlowField) then
                //         IsReadOnlyNavision := TRUE;
                // end else begin
                //     OSynchFilter.RESET;
                //     OSynchFilter.SETRANGE("Record GUID", "Record GUID");
                //     OSynchFilter.SETRANGE("Filter Type", OSynchFilter."Filter Type"::"Table Relation");
                //     OSynchFilter.SETRANGE(Type, OSynchFilter.Type::FIELD);
                //     if OSynchFilter.FIND('-') then
                //         repeat
                //             Field.GET(OSynchFilter."Master Table No.", OSynchFilter."Master Table Field No.");
                //             TypeHelper.TestFieldIsNotObsolete(Field);
                //             if OSynchProcessLine.CheckKeyField("Master Table No.", OSynchFilter."Master Table Field No.") or
                //                (Field.Class = Field.Class::FlowField)
                //             then
                //                 IsReadOnlyNavision := TRUE;
                //         until OSynchFilter.NEXT = 0;
            end;

            if IsReadOnlyOutlook then begin
                if IsReadOnlyNavision then
                    ERROR(Text007, "Outlook Property", GetFieldCaption);
                "Read-Only Status" := "Read-Only Status"::"Read-Only in Outlook";
            end else begin
                if IsReadOnlyNavision then
                    "Read-Only Status" := "Read-Only Status"::"Read-Only in Microsoft Dynamics NAV"
                else
                    "Read-Only Status" := "Read-Only Status"::" ";
            end;
        end else begin
            if "Field No." = 0 then
                "Read-Only Status" := "Read-Only Status"::"Read-Only in Outlook"
            else
                "Read-Only Status" := "Read-Only Status"::"Read-Only in Microsoft Dynamics NAV";
        end;
    end;

    LOCAL procedure CheckOtlookPropertyName(): Boolean;
    var
        //       IsReadOnly@1000 :
        IsReadOnly: Boolean;
    begin
        if "Outlook Property" = '' then
            exit(FALSE);

        if "User-Defined" then
            if "Element No." = 0 then begin
                if OSynchSetupMgt.ValidateOItemPropertyName("Outlook Property", "Outlook Object", IsReadOnly, TRUE) then
                    ERROR(Text013);
            end else begin
                OSynchEntity.GET("Synch. Entity Code");
                if OSynchSetupMgt.ValidateOCollectPropertyName(
                     "Outlook Property",
                     OSynchEntity."Outlook Item",
                     "Outlook Object",
                     IsReadOnly,
                     TRUE)
                then
                    ERROR(Text013);
            end
        else
            if "Element No." = 0 then begin
                if not OSynchSetupMgt.ValidateOItemPropertyName("Outlook Property", "Outlook Object", IsReadOnly, FALSE) then
                    ERROR(Text006);
            end else begin
                OSynchEntity.GET("Synch. Entity Code");
                if not
                   OSynchSetupMgt.ValidateOCollectPropertyName(
                     "Outlook Property",
                     OSynchEntity."Outlook Item",
                     "Outlook Object",
                     IsReadOnly,
                     FALSE)
                then
                    ERROR(Text006);
            end;

        exit(IsReadOnly);
    end;

    LOCAL procedure CheckDuplicatedRecords()
    var
        //       OSynchField@1000 :
        OSynchField: Record "Outlook Synch. Field 1";
    begin
        OSynchField.RESET;
        OSynchField.SETRANGE("Synch. Entity Code", "Synch. Entity Code");
        OSynchField.SETRANGE("Element No.", "Element No.");
        OSynchField.SETFILTER("Line No.", '<>%1', "Line No.");
        OSynchField.SETRANGE("Outlook Property", "Outlook Property");
        OSynchField.SETRANGE("Table No.", "Table No.");
        OSynchField.SETRANGE("Field No.", "Field No.");
        if not OSynchField.ISEMPTY then
            ERROR(Text014);
    end;


    procedure ShowOOptionCorrelForm()
    begin
        if ("Field No." = 0) or ("Outlook Property" = '') then
            ERROR(Text011,
              OSynchOptionCorrel.TABLECAPTION,
              FIELDCAPTION("Field No."),
              FIELDCAPTION("Outlook Property"));
        OSynchSetupMgt.ShowOOptionCorrelForm(Rec);
    end;

    //     LOCAL procedure SetOSynchOptionCorrelFilter (var outlookSynchOptionCorrel@1000 :
    LOCAL procedure SetOSynchOptionCorrelFilter(var outlookSynchOptionCorrel: Record "Outlook Synch. Option Correl.1"): Boolean;
    begin
        outlookSynchOptionCorrel.RESET;
        outlookSynchOptionCorrel.SETRANGE("Synch. Entity Code", "Synch. Entity Code");
        outlookSynchOptionCorrel.SETRANGE("Element No.", "Element No.");
        outlookSynchOptionCorrel.SETRANGE("Field Line No.", "Line No.");
        exit(not outlookSynchOptionCorrel.ISEMPTY);
    end;


    procedure GetFieldCaption(): Text;
    begin
        if "Table No." <> 0 then begin
            if TypeHelper.GetField("Table No.", "Field No.", Field) then
                exit(Field."Field Caption")
        end else
            if TypeHelper.GetField("Master Table No.", "Field No.", Field) then
                exit(Field."Field Caption");

        exit('');
    end;

    /*begin
    end.
  */
}



