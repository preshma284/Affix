table 7206909 "QBU Job Attribute Value Selection"
{


    CaptionML = ENU = 'Job Attribute Value Selection', ESP = 'Selecci�n del valor de atributo de proyecto/estudio';

    fields
    {
        field(1; "Attribute Name"; Text[250])
        {


            CaptionML = ENU = 'Attribute Name', ESP = 'Nombre de atributo';
            NotBlank = true;

            trigger OnValidate();
            VAR
                //                                                                 JobAttribute@1000 :
                JobAttribute: Record 7206905;
            BEGIN
                FindJobAttributeCaseInsensitive(JobAttribute);
                CheckForDuplicate;
                CheckIfBlocked(JobAttribute);
                AdjustAttributeName(JobAttribute);
                ValidateChangedAttribute(JobAttribute);
            END;


        }
        field(2; "Value"; Text[250])
        {


            CaptionML = ENU = 'Value', ESP = 'Valor';

            trigger OnValidate();
            VAR
                //                                                                 JobAttributeValue@1000 :
                JobAttributeValue: Record 7206906;
                //                                                                 JobAttribute@1001 :
                JobAttribute: Record 7206905;
                //                                                                 DecimalValue@1002 :
                DecimalValue: Decimal;
                //                                                                 IntegerValue@1005 :
                IntegerValue: Integer;
                //                                                                 DateValue@1003 :
                DateValue: Date;
            BEGIN
                IF Value = '' THEN
                    EXIT;

                JobAttribute.GET("Attribute ID");
                IF FindJobAttributeValueCaseSensitive(JobAttributeValue) THEN
                    CheckIfValueBlocked(JobAttributeValue);

                CASE "Attribute Type" OF
                    "Attribute Type"::Option:
                        BEGIN
                            IF JobAttributeValue.Value = '' THEN BEGIN
                                IF NOT FindJobAttributeValueCaseInsensitive(JobAttributeValue) THEN
                                    ERROR(AttributeValueDoesntExistErr, Value);
                                CheckIfValueBlocked(JobAttributeValue);
                            END;
                            AdjustAttributeValue(JobAttributeValue);
                        END;
                    "Attribute Type"::Decimal:
                        ValidateType(DecimalValue, Value, JobAttribute);
                    "Attribute Type"::Integer:
                        ValidateType(IntegerValue, Value, JobAttribute);
                    "Attribute Type"::Date:
                        ValidateType(DateValue, Value, JobAttribute);
                END;
            END;


        }
        field(3; "Attribute ID"; Integer)
        {
            CaptionML = ENU = 'Attribute ID', ESP = 'Id. de atributo';


        }
        field(4; "Unit of Measure"; Text[30])
        {
            CaptionML = ENU = 'Unit of Measure', ESP = 'Unidad medida';
            Editable = false;


        }
        field(6; "Blocked"; Boolean)
        {
            CaptionML = ENU = 'Blocked', ESP = 'Bloqueado';


        }
        field(7; "Attribute Type"; Option)
        {
            OptionMembers = "Option","Text","Integer","Decimal","Date";
            CaptionML = ENU = 'Attribute Type', ESP = 'Tipo de atributo';
            OptionCaptionML = ENU = 'Option,Text,Integer,Decimal,Date', ESP = 'Opci�n,Texto,Entero,Decimal,Fecha';



        }
        field(8; "Inherited-From Table ID"; Integer)
        {
            CaptionML = ENU = 'Inherited-From Table ID', ESP = 'Id. de la tabla Origen de herencia';


        }
        field(9; "Inherited-From Key Value"; Code[20])
        {
            CaptionML = ENU = 'Inherited-From Key Value', ESP = 'Valor de clave de Origen de herencia';


        }
        field(10; "Inheritance Level"; Integer)
        {
            CaptionML = ENU = 'Inheritance Level', ESP = 'Nivel de herencia';
            ;


        }
    }
    keys
    {
        key(key1; "Attribute Name")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Attribute ID")
        {

        }
        fieldgroup(Brick; "Attribute Name", "Value", "Unit of Measure")
        {

        }
    }

    var
        //       AttributeDoesntExistErr@1005 :
        AttributeDoesntExistErr:
// %1 - arbitrary name
TextConst ENU = 'The Job attribute ''%1'' doesn''t exist.', ESP = 'El atributo de proyecto/estudio ''%1'' no existe.';
        //       AttributeBlockedErr@1001 :
        AttributeBlockedErr:
// %1 - arbitrary name
TextConst ENU = 'The Job attribute ''%1'' is blocked.', ESP = 'El atributo de proyecto/estudio ''%1'' est� bloqueado.';
        //       AttributeValueBlockedErr@1002 :
        AttributeValueBlockedErr:
// %1 - arbitrary name
TextConst ENU = 'The Job attribute value ''%1'' is blocked.', ESP = 'El valor del atributo de proyecto/estudio ''%1'' est� bloqueado.';
        //       AttributeValueDoesntExistErr@1003 :
        AttributeValueDoesntExistErr:
// %1 - arbitrary name
TextConst ENU = 'The Job attribute value ''%1'' doesn''t exist.', ESP = 'El valor del atributo de proyecto/estudio ''%1'' no existe.';
        //       AttributeValueAlreadySpecifiedErr@1004 :
        AttributeValueAlreadySpecifiedErr:
// %1 - attribute name
TextConst ENU = 'You have already specified a value for Job attribute ''%1''.', ESP = 'Ya especific� un valor para el atributo de proyecto/estudio ''%1''.';
        //       AttributeValueTypeMismatchErr@1000 :
        AttributeValueTypeMismatchErr:
// " %1 is arbitrary string, %2 is type name"
TextConst ENU = 'The value ''%1'' does not match the Job attribute of type %2.', ESP = 'El valor ''%1'' no coincide con el atributo de proyecto/estudio de tipo %2.';


    //     procedure PopulateJobAttributeValueSelection (var TempJobAttributeValue@1001 :
    procedure PopulateJobAttributeValueSelection(var TempJobAttributeValue: Record 7206906 TEMPORARY)
    begin
        if TempJobAttributeValue.FINDSET then
            repeat
                InsertRecord(TempJobAttributeValue, 0, '');
            until TempJobAttributeValue.NEXT = 0;
    end;


    //     procedure PopulateJobAttributeValue (var TempNewJobAttributeValue@1001 :
    procedure PopulateJobAttributeValue(var TempNewJobAttributeValue: Record 7206906 TEMPORARY)
    var
        //       JobAttributeValue@1003 :
        JobAttributeValue: Record 7206906;
        //       ValDecimal@1002 :
        ValDecimal: Decimal;
    begin
        if FINDSET then
            repeat
                CLEAR(TempNewJobAttributeValue);
                TempNewJobAttributeValue.INIT;
                TempNewJobAttributeValue."Attribute ID" := "Attribute ID";
                TempNewJobAttributeValue.Blocked := Blocked;
                JobAttributeValue.RESET;
                JobAttributeValue.SETRANGE("Attribute ID", "Attribute ID");
                CASE "Attribute Type" OF
                    "Attribute Type"::Option,
                    "Attribute Type"::Text,
                    "Attribute Type"::Integer:
                        begin
                            TempNewJobAttributeValue.Value := Value;
                            JobAttributeValue.SETRANGE(Value, Value);
                        end;
                    "Attribute Type"::Decimal:
                        begin
                            if Value <> '' then begin
                                EVALUATE(ValDecimal, Value);
                                JobAttributeValue.SETRANGE(Value, FORMAT(ValDecimal, 0, 9));
                                if JobAttributeValue.ISEMPTY then begin
                                    JobAttributeValue.SETRANGE(Value, FORMAT(ValDecimal));
                                    if JobAttributeValue.ISEMPTY then
                                        JobAttributeValue.SETRANGE(Value, Value);
                                end;
                            end;
                            TempNewJobAttributeValue.Value := FORMAT(ValDecimal);
                        end;
                end;
                if not JobAttributeValue.FINDFIRST then
                    InsertJobAttributeValue(JobAttributeValue, Rec);
                TempNewJobAttributeValue.ID := JobAttributeValue.ID;
                TempNewJobAttributeValue.INSERT;
            until NEXT = 0;
    end;


    //     procedure InsertJobAttributeValue (var JobAttributeValue@1000 : Record 7206906;TempJobAttributeValueSelection@1001 :
    procedure InsertJobAttributeValue(var JobAttributeValue: Record 7206906; TempJobAttributeValueSelection: Record 7206909 TEMPORARY)
    var
        //       ValDecimal@1003 :
        ValDecimal: Decimal;
        //       ValDate@1002 :
        ValDate: Date;
    begin
        CLEAR(JobAttributeValue);
        JobAttributeValue."Attribute ID" := TempJobAttributeValueSelection."Attribute ID";
        JobAttributeValue.Blocked := TempJobAttributeValueSelection.Blocked;
        CASE TempJobAttributeValueSelection."Attribute Type" OF
            TempJobAttributeValueSelection."Attribute Type"::Option,
          TempJobAttributeValueSelection."Attribute Type"::Text:
                JobAttributeValue.Value := TempJobAttributeValueSelection.Value;
            TempJobAttributeValueSelection."Attribute Type"::Integer:
                JobAttributeValue.VALIDATE(Value, TempJobAttributeValueSelection.Value);
            TempJobAttributeValueSelection."Attribute Type"::Decimal:
                if TempJobAttributeValueSelection.Value <> '' then begin
                    EVALUATE(ValDecimal, TempJobAttributeValueSelection.Value);
                    JobAttributeValue.VALIDATE(Value, FORMAT(ValDecimal));
                end;
            TempJobAttributeValueSelection."Attribute Type"::Date:
                if TempJobAttributeValueSelection.Value <> '' then begin
                    EVALUATE(ValDate, TempJobAttributeValueSelection.Value);
                    JobAttributeValue.VALIDATE("Date Value", ValDate);
                end;
        end;
        JobAttributeValue.INSERT;
    end;


    //     procedure InsertRecord (var TempJobAttributeValue@1000 : TEMPORARY Record 7206906;DefinedOnTableID@1003 : Integer;DefinedOnKeyValue@1004 :
    procedure InsertRecord(var TempJobAttributeValue: Record 7206906 TEMPORARY; DefinedOnTableID: Integer; DefinedOnKeyValue: Code[20])
    var
        //       JobAttribute@1002 :
        JobAttribute: Record 7206905;
    begin
        "Attribute ID" := TempJobAttributeValue."Attribute ID";
        JobAttribute.GET(TempJobAttributeValue."Attribute ID");
        "Attribute Name" := JobAttribute.Name;
        "Attribute Type" := JobAttribute.Type;
        Value := TempJobAttributeValue.GetValueInCurrentLanguageWithoutUnitOfMeasure;
        Blocked := TempJobAttributeValue.Blocked;
        "Unit of Measure" := JobAttribute."Unit of Measure";
        "Inherited-From Table ID" := DefinedOnTableID;
        "Inherited-From Key Value" := DefinedOnKeyValue;
        INSERT;
    end;

    //     LOCAL procedure ValidateType (Variant@1000 : Variant;ValueToValidate@1001 : Text;JobAttribute@1002 :
    LOCAL procedure ValidateType(Variant: Variant; ValueToValidate: Text; JobAttribute: Record 7206905)
    var
        //       TypeHelper@1003 :
        TypeHelper: Codeunit "Type Helper";
        //       CultureInfo@1004 :
        CultureInfo: DotNet CultureInfo;
    begin
        if (ValueToValidate <> '') and not TypeHelper.Evaluate(Variant, ValueToValidate, '', CultureInfo.CurrentCulture.Name) then
            ERROR(AttributeValueTypeMismatchErr, ValueToValidate, JobAttribute.Type);
    end;

    //     LOCAL procedure FindJobAttributeCaseInsensitive (var JobAttribute@1000 :
    LOCAL procedure FindJobAttributeCaseInsensitive(var JobAttribute: Record 7206905)
    var
        //       AttributeName@1001 :
        AttributeName: Text[250];
    begin
        OnBeforeFindJobAttributeCaseInsensitive(JobAttribute, Rec);

        JobAttribute.SETRANGE(Name, "Attribute Name");
        if JobAttribute.FINDFIRST then
            exit;

        AttributeName := LOWERCASE("Attribute Name");
        JobAttribute.SETRANGE(Name);
        if JobAttribute.FINDSET then
            repeat
                if LOWERCASE(JobAttribute.Name) = AttributeName then
                    exit;
            until JobAttribute.NEXT = 0;

        ERROR(AttributeDoesntExistErr, "Attribute Name");
    end;

    //     LOCAL procedure FindJobAttributeValueCaseSensitive (var JobAttributeValue@1000 :
    LOCAL procedure FindJobAttributeValueCaseSensitive(var JobAttributeValue: Record 7206906): Boolean;
    begin
        JobAttributeValue.SETRANGE("Attribute ID", "Attribute ID");
        JobAttributeValue.SETRANGE(Value, Value);
        exit(JobAttributeValue.FINDFIRST);
    end;

    //     LOCAL procedure FindJobAttributeValueCaseInsensitive (var JobAttributeValue@1000 :
    LOCAL procedure FindJobAttributeValueCaseInsensitive(var JobAttributeValue: Record 7206906): Boolean;
    var
        //       AttributeValue@1002 :
        AttributeValue: Text[250];
    begin
        JobAttributeValue.SETRANGE("Attribute ID", "Attribute ID");
        JobAttributeValue.SETRANGE(Value);
        if JobAttributeValue.FINDSET then begin
            AttributeValue := LOWERCASE(Value);
            repeat
                if LOWERCASE(JobAttributeValue.Value) = AttributeValue then
                    exit(TRUE);
            until JobAttributeValue.NEXT = 0;
        end;
        exit(FALSE);
    end;

    LOCAL procedure CheckForDuplicate()
    var
        //       TempJobAttributeValueSelection@1001 :
        TempJobAttributeValueSelection: Record 7206909 TEMPORARY;
        //       AttributeName@1003 :
        AttributeName: Text[250];
    begin
        if ISEMPTY then
            exit;
        AttributeName := LOWERCASE("Attribute Name");
        TempJobAttributeValueSelection.COPY(Rec, TRUE);
        if TempJobAttributeValueSelection.FINDSET then
            repeat
                if TempJobAttributeValueSelection."Attribute ID" <> "Attribute ID" then
                    if LOWERCASE(TempJobAttributeValueSelection."Attribute Name") = AttributeName then
                        ERROR(AttributeValueAlreadySpecifiedErr, "Attribute Name");
            until TempJobAttributeValueSelection.NEXT = 0;
    end;

    //     LOCAL procedure CheckIfBlocked (var JobAttribute@1000 :
    LOCAL procedure CheckIfBlocked(var JobAttribute: Record 7206905)
    begin
        if JobAttribute.Blocked then
            ERROR(AttributeBlockedErr, JobAttribute.Name);
    end;

    //     LOCAL procedure CheckIfValueBlocked (JobAttributeValue@1000 :
    LOCAL procedure CheckIfValueBlocked(JobAttributeValue: Record 7206906)
    begin
        if JobAttributeValue.Blocked then
            ERROR(AttributeValueBlockedErr, JobAttributeValue.Value);
    end;

    //     LOCAL procedure AdjustAttributeName (var JobAttribute@1000 :
    LOCAL procedure AdjustAttributeName(var JobAttribute: Record 7206905)
    begin
        if "Attribute Name" <> JobAttribute.Name then
            "Attribute Name" := JobAttribute.Name;
    end;

    //     LOCAL procedure AdjustAttributeValue (var JobAttributeValue@1000 :
    LOCAL procedure AdjustAttributeValue(var JobAttributeValue: Record 7206906)
    begin
        if Value <> JobAttributeValue.Value then
            Value := JobAttributeValue.Value;
    end;

    //     LOCAL procedure ValidateChangedAttribute (var JobAttribute@1002 :
    LOCAL procedure ValidateChangedAttribute(var JobAttribute: Record 7206905)
    begin
        if "Attribute ID" <> JobAttribute.ID then begin
            VALIDATE("Attribute ID", JobAttribute.ID);
            VALIDATE("Attribute Type", JobAttribute.Type);
            VALIDATE("Unit of Measure", JobAttribute."Unit of Measure");
            VALIDATE(Value, '');
        end;
    end;


    //     procedure FindAttributeValue (var JobAttributeValue@1000 :
    procedure FindAttributeValue(var JobAttributeValue: Record 7206906): Boolean;
    begin
        exit(FindAttributeValueFromRecord(JobAttributeValue, Rec));
    end;


    //     procedure FindAttributeValueFromRecord (var JobAttributeValue@1000 : Record 7206906;JobAttributeValueSelection@1002 :
    procedure FindAttributeValueFromRecord(var JobAttributeValue: Record 7206906; JobAttributeValueSelection: Record 7206909): Boolean;
    var
        //       ValDecimal@1001 :
        ValDecimal: Decimal;
    begin
        JobAttributeValue.RESET;
        JobAttributeValue.SETRANGE("Attribute ID", JobAttributeValueSelection."Attribute ID");
        if IsNotBlankDecimal(JobAttributeValueSelection.Value) then begin
            EVALUATE(ValDecimal, JobAttributeValueSelection.Value);
            JobAttributeValue.SETRANGE("Numeric Value", ValDecimal);
        end else
            JobAttributeValue.SETRANGE(Value, JobAttributeValueSelection.Value);
        exit(JobAttributeValue.FINDFIRST);
    end;


    //     procedure GetAttributeValueID (var TempJobAttributeValueToInsert@1000 :
    procedure GetAttributeValueID(var TempJobAttributeValueToInsert: Record 7206906 TEMPORARY): Integer;
    var
        //       JobAttributeValue@1001 :
        JobAttributeValue: Record 7206906;
        //       ValDecimal@1003 :
        ValDecimal: Decimal;
    begin
        if not FindAttributeValue(JobAttributeValue) then begin
            JobAttributeValue."Attribute ID" := "Attribute ID";
            if IsNotBlankDecimal(Value) then begin
                EVALUATE(ValDecimal, Value);
                JobAttributeValue.VALIDATE(Value, FORMAT(ValDecimal));
            end else
                JobAttributeValue.Value := Value;
            JobAttributeValue.INSERT;
        end;
        TempJobAttributeValueToInsert.TRANSFERFIELDS(JobAttributeValue);
        TempJobAttributeValueToInsert.INSERT;
        exit(JobAttributeValue.ID);
    end;


    //     procedure IsNotBlankDecimal (TextValue@1001 :
    procedure IsNotBlankDecimal(TextValue: Text[250]): Boolean;
    var
        //       JobAttribute@1000 :
        JobAttribute: Record 7206905;
    begin
        if TextValue = '' then
            exit(FALSE);
        JobAttribute.GET("Attribute ID");
        exit(JobAttribute.Type = JobAttribute.Type::Decimal);
    end;


    //     LOCAL procedure OnBeforeFindJobAttributeCaseInsensitive (var JobAttribute@1000 : Record 7206905;var JobAttributeValueSelection@1001 :
    LOCAL procedure OnBeforeFindJobAttributeCaseInsensitive(var JobAttribute: Record 7206905; var JobAttributeValueSelection: Record 7206909)
    begin
    end;

    /*begin
    //{
//      JAV 13/02/20: - Gesti�n de atributos para proyectos
//    }
    end.
  */
}







