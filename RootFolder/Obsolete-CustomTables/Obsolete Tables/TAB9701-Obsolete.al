table 51775 "Cue Setup 1"
{


    CaptionML = ENU = 'Cue Setup', ESP = 'Configuraci�n de pila';

    fields
    {
        field(1; "User Name"; Code[50])
        {
            TableRelation = User."User Name";


            ValidateTableRelation = false;
            //TestTableRelation=false;
            DataClassification = EndUserIdentifiableInformation;
            CaptionML = ENU = 'User Name', ESP = 'Nombre de usuario';

            trigger OnLookup();
            VAR
                //                                                               UserMgt@1000 :
                UserMgt1: Codeunit "User Management 1";
            BEGIN
                UserMgt1.LookupUserID("User Name");
            END;


        }
        field(2; "Table ID"; Integer)
        {
            TableRelation = AllObjWithCaption."Object ID" WHERE("Object Type" = CONST("Table"),
                                                                                                      "Object Name" = FILTER('*Cue'));


            CaptionML = ENU = 'Table ID', ESP = 'Id. tabla';

            trigger OnValidate();
            BEGIN
                // Force a calculation, even if the FieldNo hasn't yet been filled out (i.e. the record hasn't been inserted yet)
                CALCFIELDS("Table Name")
            END;


        }
        field(3; "Field No."; Integer)
        {
            TableRelation = "Field"."No.";


            CaptionML = ENU = 'Cue ID', ESP = 'Id. de pila';

            trigger OnLookup();
            VAR
                //                                                               Field@1001 :
                Field: Record 2000000041;
                //                                                               FieldsLookup@1000 :
                FieldsLookup: Page 9806;
                //                                                               Filter@1002 :
                Filter: Text[250];
            BEGIN
                // Look up in the Fields virtual table
                // Filter on Table No=Table No and Type=Decimal|Integer. This should give us approximately the
                // fields that are "valid" for a cue control.
                Field.SETRANGE(TableNo, "Table ID");
                Field.SETFILTER(ObsoleteState, '<>%1', Field.ObsoleteState::Removed);
                Filter := FORMAT(Field.Type::Decimal) + '|' + FORMAT(Field.Type::Integer);
                Field.SETFILTER(Type, Filter);
                FieldsLookup.SETTABLEVIEW(Field);
                FieldsLookup.LOOKUPMODE(TRUE);
                IF FieldsLookup.RUNMODAL = ACTION::LookupOK THEN BEGIN
                    FieldsLookup.GETRECORD(Field);
                    "Field No." := Field."No.";
                END;
            END;


        }
        field(4; "Field Name"; Text[80])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Field"."Field Caption" WHERE("TableNo" = FIELD("Table ID"),
                                                                                                   "No." = FIELD("Field No.")));
            CaptionML = ENU = 'Cue Name', ESP = 'Nombre de pila';


        }
        field(5; "Low Range Style"; Option)
        {
            OptionMembers = "None","Favorable","Unfavorable","Ambiguous","Subordinate";
            CaptionML =//@@@='The Style to use if the cue''s value is below Threshold 1',
ENU = 'Low Range Style', ESP = 'Estilo de rango bajo';
            OptionCaptionML = ENU = 'None,,,,,,,Favorable,Unfavorable,Ambiguous,Subordinate', ESP = 'Ninguno,,,,,,,Favorable,Desfavorable,Ambiguo,Subordinado';



        }
        field(6; "Threshold 1"; Decimal)
        {


            CaptionML = ENU = 'Threshold 1', ESP = 'Umbral 1';

            trigger OnValidate();
            BEGIN
                ValidateThresholds;
            END;


        }
        field(7; "Middle Range Style"; Option)
        {
            OptionMembers = "None","Favorable","Unfavorable","Ambiguous","Subordinate";
            CaptionML =//@@@='The Style to use if the cue''s value is between Threshold 1 and Threshold 2',
ENU = 'Middle Range Style', ESP = 'Estilo de rango medio';
            OptionCaptionML = ENU = 'None,,,,,,,Favorable,Unfavorable,Ambiguous,Subordinate', ESP = 'Ninguno,,,,,,,Favorable,Desfavorable,Ambiguo,Subordinado';



        }
        field(8; "Threshold 2"; Decimal)
        {


            CaptionML = ENU = 'Threshold 2', ESP = 'Umbral 2';

            trigger OnValidate();
            BEGIN
                ValidateThresholds;
            END;


        }
        field(9; "High Range Style"; Option)
        {
            OptionMembers = "None","Favorable","Unfavorable","Ambiguous","Subordinate";
            CaptionML =//@@@='The Style to use if the cue''s value is above Threshold 2',
ENU = 'High Range Style', ESP = 'Estilo de rango alto';
            OptionCaptionML = ENU = 'None,,,,,,,Favorable,Unfavorable,Ambiguous,Subordinate', ESP = 'Ninguno,,,,,,,Favorable,Desfavorable,Ambiguo,Subordinado';



        }
        field(10; "Table Name"; Text[249])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("AllObjWithCaption"."Object Caption" WHERE("Object ID" = FIELD("Table ID"),
                                                                                                                "Object Type" = CONST("Table")));
            CaptionML = ENU = 'Table Name', ESP = 'Nombre tabla';


        }
        field(11; "Personalized"; Boolean)
        {
            CaptionML = ENU = 'Personalized', ESP = 'Personalizado';
            ;


        }
    }
    keys
    {
        key(key1; "User Name", "Table ID", "Field No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(Brick; "Table Name", "Field Name", "Threshold 1", "Personalized", "Threshold 2")
        {

        }
    }

    var
        //       TextErr001@1000 :
        TextErr001: TextConst ENU = '%1 must be greater than %2.', ESP = '%1 debe ser mayor que %2.';


    //     procedure ConvertStyleToStyleText (Style@1005 :
    procedure ConvertStyleToStyleText(Style: Option): Text;
    var
        //       RecordRef@1000 :
        RecordRef: RecordRef;
        //       FieldRef@1001 :
        FieldRef: FieldRef;
        //       StyleIndex@1002 :
        StyleIndex: Integer;
    begin
        RecordRef.GETTABLE(Rec);
        FieldRef := RecordRef.FIELD(FIELDNO("Low Range Style"));

        // Default to return the None Style
        StyleIndex := 1;

        // The style must be in the range of existing style options
        if (Style > 0) and (Style <= 10) then
            StyleIndex := Style + 1;

        exit(SELECTSTR(StyleIndex, FieldRef.OPTIONSTRING));
    end;


    //     procedure GetStyleForValue (CueValue@1000 :
    procedure GetStyleForValue(CueValue: Decimal): Integer;
    begin
        if CueValue < "Threshold 1" then
            exit("Low Range Style");
        if CueValue > "Threshold 2" then
            exit("High Range Style");
        exit("Middle Range Style");
    end;

    LOCAL procedure ValidateThresholds()
    begin
        if "Threshold 2" <= "Threshold 1" then
            ERROR(
              TextErr001,
              FIELDCAPTION("Threshold 2"),
              FIELDCAPTION("Threshold 1"));
    end;

    /*begin
    end.
  */
}



