table 51283 "Outlook Synch. Filter 1"
{

    DataCaptionFields = "Filter Type";
    CaptionML = ENU = 'Outlook Synch. Filter', ESP = 'Filtro sinc. Outlook';
    PasteIsValid = false;

    fields
    {
        field(1; "Record GUID"; GUID)
        {
            DataClassification = SystemMetadata;
            CaptionML = ENU = 'Record GUID', ESP = 'GUID registro';
            NotBlank = true;
            Editable = false;


        }
        field(2; "Filter Type"; Option)
        {
            OptionMembers = "Condition","Table Relation";
            CaptionML = ENU = 'Filter Type', ESP = 'Filtro tipo';
            OptionCaptionML = ENU = 'Condition,Table Relation', ESP = 'Condici�n,Relaci�n tablas';



        }
        field(3; "Line No."; Integer)
        {
            CaptionML = ENU = 'Line No.', ESP = 'N� l�nea';


        }
        field(4; "Table No."; Integer)
        {
            TableRelation = AllObjWithCaption."Object ID" WHERE("Object Type" = CONST("Table"));
            CaptionML = ENU = 'Table No.', ESP = 'N� tabla';


        }
        field(5; "Field No."; Integer)
        {
            TableRelation = Field."No." WHERE("TableNo" = FIELD("Table No."));


            CaptionML = ENU = 'Field No.', ESP = 'N� campo';

            trigger OnValidate();
            VAR
                //                                                                 RecRef@1000 :
                RecRef: RecordRef;
            BEGIN
                IF "Field No." = 0 THEN BEGIN
                    CLEAR(RecRef);
                    RecRef.OPEN("Table No.", TRUE);
                    ERROR(Text005, RecRef.CAPTION);
                END;

                IF "Field No." <> xRec."Field No." THEN
                    IF Type <> Type::FIELD THEN
                        Value := '';
            END;

            trigger OnLookup();
            VAR
                //                                                               FieldNo@1000 :
                FieldNo: Integer;
            BEGIN
                IF "Table No." <> 0 THEN
                    FieldNo := OSynchSetupMgt.ShowTableFieldsList("Table No.")
                ELSE
                    FieldNo := OSynchSetupMgt.ShowTableFieldsList("Master Table No.");

                IF FieldNo > 0 THEN
                    VALIDATE("Field No.", FieldNo);
            END;


        }
        field(7; "Type"; Option)
        {
            OptionMembers = "CONST","FILTER","FIELD";

            CaptionML = ENU = 'Type', ESP = 'Tipo';
            OptionCaptionML = ENU = 'CONST,FILTER,FIELD', ESP = 'CONST,FILTRO,CAMPO';


            trigger OnValidate();
            BEGIN
                IF ("Filter Type" = "Filter Type"::Condition) AND (Type = Type::FIELD) THEN
                    ERROR(Text001, FORMAT(Type), FIELDCAPTION("Filter Type"), FORMAT("Filter Type"));

                IF Type <> xRec.Type THEN
                    Value := '';
            END;


        }
        field(8; "Value"; Text[250])
        {


            CaptionML = ENU = 'Value', ESP = 'Valor';

            trigger OnValidate();
            BEGIN
                ValidateFieldValuePair;
            END;

            trigger OnLookup();
            VAR
                //                                                               OSynchTypeConversion@1003 :
                OSynchTypeConversion: Codeunit 5302;
                //                                                               RecRef@1002 :
                RecRef: RecordRef;
                //                                                               FldRef@1001 :
                FldRef: FieldRef;
                //                                                               MasterTableFieldNo@1000 :
                MasterTableFieldNo: Integer;
            BEGIN
                IF Type <> Type::FIELD THEN BEGIN
                    RecRef.GETTABLE(Rec);
                    FldRef := RecRef.FIELD(FIELDNO(Type));
                    ERROR(Text003, FIELDCAPTION(Type), OSynchTypeConversion.GetSubStrByNo(Type::FIELD + 1, FldRef.OPTIONCAPTION));
                END;

                MasterTableFieldNo := OSynchSetupMgt.ShowTableFieldsList("Master Table No.");

                IF MasterTableFieldNo <> 0 THEN
                    VALIDATE("Master Table Field No.", MasterTableFieldNo);
            END;


        }
        field(9; "Master Table No."; Integer)
        {
            TableRelation = AllObjWithCaption."Object ID" WHERE("Object Type" = CONST("Table"));
            CaptionML = ENU = 'Master Table No.', ESP = 'N� tabla principal';


        }
        field(10; "Master Table Field No."; Integer)
        {
            TableRelation = Field."No." WHERE("TableNo" = FIELD("Master Table No."));


            CaptionML = ENU = 'Master Table Field No.', ESP = 'N� campo tabla principal';

            trigger OnValidate();
            BEGIN
                IF TypeHelper.GetField("Master Table No.", "Master Table Field No.", Field) THEN
                    VALIDATE(Value, Field."Field Caption");
            END;


        }
        field(99; "FilterExpression"; Text[250])
        {
            CaptionML = ENU = 'FilterExpression', ESP = 'FilterExpression';
            ;


        }
    }
    keys
    {
        key(key1; "Record GUID", "Filter Type", "Line No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       Field@1004 :
        Field: Record 2000000041;
        //       OSynchSetupMgt@1005 :
        OSynchSetupMgt: Codeunit 50849;
        //       OSynchTypeConversion@1006 :
        OSynchTypeConversion: Codeunit 5302;
        //       Text001@1008 :
        Text001: TextConst ENU = 'You cannot select the %1 option when %2 is %3.', ESP = 'No puede seleccionar la opci�n %1 cuando %2 es %3.';
        //       Text002@1007 :
        Text002: TextConst ENU = 'This value cannot be converted to the selected field datatype.', ESP = 'Este valor no se puede convertir al tipo de datos de campo seleccionado.';
        //       Text003@1003 :
        Text003: TextConst ENU = 'You can only open a lookup table when the %1 field contains the %2 value.', ESP = 'S�lo puede abrir una tabla de b�squeda si el campo %1 contiene el valor %2.';
        //       Text004@1002 :
        Text004: TextConst ENU = 'This is not a valid option for the %1 field. The possible options are: ''%2''.', ESP = 'Esta opci�n no es v�lida para el campo %1. Las posibles opciones son: ''%2''.';
        //       Text005@1001 :
        Text005: TextConst ENU = 'Choose a valid field in the %1 table.', ESP = 'Elija un campo v�lido en la tabla %1.';
        //       Text006@1009 :
        Text006: TextConst ENU = 'The value in this field cannot be longer than %1.', ESP = 'El valor de este campo no puede ser mayor que %1.';
        //       TypeHelper@1000 :
        TypeHelper: Codeunit 10;




    trigger OnInsert();
    begin
        TESTFIELD("Field No.");
        VALIDATE(Value);
        UpdateFilterExpression;
    end;

    trigger OnModify();
    begin
        VALIDATE(Value);
        UpdateFilterExpression;
    end;



    // procedure SetTablesNo (TableLeftNo@1000 : Integer;TableRightNo@1001 :
    procedure SetTablesNo(TableLeftNo: Integer; TableRightNo: Integer)
    begin
        "Table No." := TableLeftNo;
        "Master Table No." := TableRightNo;
    end;


    procedure ValidateFieldValuePair()
    var
        //       RecRef@1000 :
        RecRef: RecordRef;
        //       FldRef@1001 :
        FldRef: FieldRef;
        //       NameString@1004 :
        NameString: Text[250];
        //       TempBool@1003 :
        TempBool: Boolean;
    begin
        TESTFIELD("Table No.");

        CLEAR(RecRef);
        CLEAR(FldRef);
        RecRef.OPEN("Table No.", TRUE);

        if ("Field No." = 0) or not TypeHelper.GetField("Table No.", "Field No.", Field) then
            ERROR(Text005, RecRef.CAPTION);

        FldRef := RecRef.FIELD("Field No.");

        CASE Type OF
            Type::CONST:
                CASE Field.Type OF
                    Field.Type::Option:
                        if not OSynchTypeConversion.EvaluateOptionField(FldRef, Value) then
                            ERROR(Text004, Field."Field Caption", FldRef.OPTIONSTRING);
                    Field.Type::Code, Field.Type::Text:
                        begin
                            if STRLEN(Value) > Field.Len then
                                ERROR(Text006, Field.Len);
                            if not EVALUATE(FldRef, Value) then
                                ERROR(Text002);
                        end;
                    Field.Type::Boolean:
                        begin
                            if not EVALUATE(TempBool, Value) then
                                ERROR(Text002);
                            Value := FORMAT(TempBool);
                        end;
                    else
                        if not EVALUATE(FldRef, Value) then
                            ERROR(Text002);
                end;
            Type::FILTER:
                begin
                    if Field.Type = Field.Type::Option then begin
                        if not OSynchTypeConversion.EvaluateFilterOptionField(FldRef, Value, FALSE) then
                            ERROR(Text004, Field."Field Caption", FldRef.OPTIONSTRING);
                    end;
                    FldRef.SETFILTER(Value);
                end;
            Type::FIELD:
                begin
                    NameString := Value;
                    if not OSynchSetupMgt.ValidateFieldName(NameString, "Master Table No.") then begin
                        RecRef.CLOSE;
                        RecRef.OPEN("Master Table No.", TRUE);
                        ERROR(Text005, RecRef.CAPTION);
                    end;

                    Value := NameString;
                end;
        end;
        RecRef.CLOSE;
    end;


    procedure RecomposeFilterExpression() FilterExpression: Text[250];
    begin
        FilterExpression := OSynchSetupMgt.ComposeFilterExpression("Record GUID", "Filter Type");
    end;


    procedure GetFieldCaption(): Text;
    begin
        if Field.GET("Table No.", "Field No.") then
            exit(Field."Field Caption");
        exit('');
    end;


    procedure GetFilterExpressionValue(): Text[250];
    var
        //       ValueStartIndex@1000 :
        ValueStartIndex: Integer;
    begin
        ValueStartIndex := STRPOS(FilterExpression, '(');
        exit(COPYSTR(FilterExpression, ValueStartIndex + 1, STRLEN(FilterExpression) - ValueStartIndex - 1));
    end;


    procedure UpdateFilterExpression()
    var
        //       TempRecordRef@1000 :
        TempRecordRef: RecordRef;
        //       ViewExpression@1001 :
        ViewExpression: Text;
        //       WhereIndex@1002 :
        WhereIndex: Integer;
        //       TempBoolean@1003 :
        TempBoolean: Boolean;
    begin
        FilterExpression := '';
        if Type <> Type::FIELD then
            if "Table No." <> 0 then begin
                TempRecordRef.OPEN("Table No.");

                ViewExpression := GetFieldCaption + STRSUBSTNO('=FILTER(%1)', Value);

                ViewExpression := STRSUBSTNO('WHERE(%1)', ViewExpression);
                TempRecordRef.SETVIEW(ViewExpression);

                ViewExpression := TempRecordRef.GETVIEW(FALSE);
                WhereIndex := STRPOS(ViewExpression, 'WHERE(') + 6;
                FilterExpression := COPYSTR(ViewExpression, WhereIndex, STRLEN(ViewExpression) - WhereIndex);

                if Field.GET("Table No.", "Field No.") then
                    if Field.Type = Field.Type::Boolean then begin
                        EVALUATE(TempBoolean, Value);
                        if TempBoolean then
                            FilterExpression := COPYSTR(StringReplace(FilterExpression, Value, '1'), 1, 250)
                        else
                            FilterExpression := COPYSTR(StringReplace(FilterExpression, Value, '0'), 1, 250);
                    end;
            end;
    end;

    //     LOCAL procedure StringReplace (Input@1000 : Text;Find@1001 : Text;Replace@1002 :
    LOCAL procedure StringReplace(Input: Text; Find: Text; Replace: Text): Text;
    var
        //       Pos@1003 :
        Pos: Integer;
    begin
        Pos := STRPOS(Input, Find);
        WHILE Pos <> 0 DO begin
            Input := DELSTR(Input, Pos, STRLEN(Find));
            Input := INSSTR(Input, Replace, Pos);
            Pos := STRPOS(Input, Find);
        end;
        exit(Input);
    end;

    /*begin
    end.
  */
}



