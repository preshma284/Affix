table 51287 "Outlook Synch. Option Correl.1"
{


    CaptionML = ENU = 'Outlook Synch. Option Correl.', ESP = 'Correl. opciones sinc. Outlook';

    fields
    {
        field(1; "Synch. Entity Code"; Code[10])
        {
            TableRelation = "Outlook Synch. Entity 1"."Code";


            CaptionML = ENU = 'Synch. Entity Code', ESP = 'C�digo entidad sinc.';
            NotBlank = true;

            trigger OnValidate();
            BEGIN
                SetDefaults;
            END;


        }
        field(2; "Element No."; Integer)
        {
            CaptionML = ENU = 'Element No.', ESP = 'N� elemento';


        }
        field(3; "Field Line No."; Integer)
        {
            CaptionML = ENU = 'Field Line No.', ESP = 'N� l�nea campo';


        }
        field(4; "Line No."; Integer)
        {
            CaptionML = ENU = 'Line No.', ESP = 'N� l�nea';


        }
        field(5; "Outlook Object"; Text[80])
        {
            CaptionML = ENU = 'Outlook Object', ESP = 'Objeto Outlook';


        }
        field(6; "Outlook Property"; Text[80])
        {
            CaptionML = ENU = 'Outlook Property', ESP = 'Propiedad Outlook';


        }
        field(7; "Outlook Value"; Text[80])
        {


            CaptionML = ENU = 'Outlook Value', ESP = 'Valor Outlook';

            trigger OnValidate();
            VAR
                //                                                                 IntVar@1000 :
                IntVar: Integer;
            BEGIN
                OSynchField.RESET;
                OSynchField.GET("Synch. Entity Code", "Element No.", "Field Line No.");

                // IF OSynchSetupMgt.CheckOEnumeration(OSynchField) THEN BEGIN
                //     IF "Element No." = 0 THEN
                //         OSynchSetupMgt.ValidateEnumerationValue(
                //           "Outlook Value",
                //           "Enumeration No.",
                //           OSynchField."Outlook Object",
                //           '',
                //           OSynchField."Outlook Property")
                //     ELSE BEGIN
                //         OSynchEntity.GET("Synch. Entity Code");
                //         OSynchSetupMgt.ValidateEnumerationValue(
                //           "Outlook Value",
                //           "Enumeration No.",
                //           OSynchEntity."Outlook Item",
                //           OSynchField."Outlook Object",
                //           OSynchField."Outlook Property");
                //     END;
                // END ELSE BEGIN
                //     IF NOT EVALUATE(IntVar, "Outlook Value") THEN
                //         ERROR(Text002);

                //     "Enumeration No." := IntVar;
                // END;
            END;

            trigger OnLookup();
            VAR
                //                                                               OutlookValue@1000 :
                OutlookValue: Text[80];
                //                                                               EnumerationNo@1001 :
                EnumerationNo: Integer;
            BEGIN
                OSynchField.RESET;
                OSynchField.GET("Synch. Entity Code", "Element No.", "Field Line No.");
                // IF NOT OSynchSetupMgt.CheckOEnumeration(OSynchField) THEN
                //     ERROR(Text003);

                // IF "Element No." = 0 THEN
                //     OutlookValue := OSynchSetupMgt.ShowEnumerationsLookup("Outlook Object", '', "Outlook Property", EnumerationNo)
                // ELSE BEGIN
                //     OSynchEntity.GET("Synch. Entity Code");
                //     OutlookValue :=
                //       OSynchSetupMgt.ShowEnumerationsLookup(
                //         OSynchEntity."Outlook Item",
                //         "Outlook Object",
                //         "Outlook Property",
                //         EnumerationNo);
                // END;

                IF OutlookValue = '' THEN
                    EXIT;

                "Outlook Value" := OutlookValue;
                "Enumeration No." := EnumerationNo;
            END;


        }
        field(8; "Table No."; Integer)
        {
            TableRelation = AllObjWithCaption."Object ID" WHERE("Object Type" = CONST("Table"));
            CaptionML = ENU = 'Table No.', ESP = 'N� tabla';


        }
        field(9; "Field No."; Integer)
        {
            TableRelation = Field."No." WHERE("TableNo" = FIELD("Table No."));
            CaptionML = ENU = 'Field No.', ESP = 'N� campo';


        }
        field(11; "Option No."; Integer)
        {
            CaptionML = ENU = 'Option No.', ESP = 'N� opci�n';
            Editable = false;


        }
        field(12; "Enumeration No."; Integer)
        {
            CaptionML = ENU = 'Enumeration No.', ESP = 'N� enumeraci�n';
            Editable = false;


        }
    }
    keys
    {
        key(key1; "Synch. Entity Code", "Element No.", "Field Line No.", "Line No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       OSynchEntity@1000 :
        OSynchEntity: Record "Outlook Synch. Entity 1";
        //       OSynchEntityElement@1001 :
        OSynchEntityElement: Record "Outlook Synch. Entity Element1";
        //       OSynchField@1002 :
        OSynchField: Record "Outlook Synch. Field 1";
        //       OSynchSetupMgt@1003 :
        //OSynchSetupMgt: Codeunit 5300;
        //       Text001@1006 :
        Text001: TextConst ENU = 'The line you are trying to create already exists.', ESP = 'La l�nea que intenta crear ya existe.';
        //       Text002@1007 :
        Text002: TextConst ENU = 'This value is not valid. It must be either an integer or an enumeration element.', ESP = 'Este valor no es v�lido. Debe ser un entero o un elemento de enumeraci�n.';
        //       Text003@1008 :
        Text003: TextConst ENU = 'The look up window table cannot be opened because this Outlook property is not of the enumeration type.', ESP = 'La tabla de ventana de b�squeda no se puede abrir porque esta propiedad de Outlook no es del tipo de enumeraci�n.';




    trigger OnInsert();
    begin
        TESTFIELD("Outlook Value");

        CheckDuplicatedRecords;
    end;

    trigger OnModify();
    begin
        CheckDuplicatedRecords;
    end;



    procedure SetDefaults()
    begin
        if "Element No." = 0 then begin
            OSynchEntity.GET("Synch. Entity Code");
            "Outlook Object" := OSynchEntity."Outlook Item";
        end else begin
            OSynchEntityElement.GET("Synch. Entity Code", "Element No.");
            "Outlook Object" := OSynchEntityElement."Outlook Collection";
        end;

        OSynchField.GET("Synch. Entity Code", "Element No.", "Field Line No.");
        "Outlook Property" := OSynchField."Outlook Property";
        "Field No." := OSynchField."Field No.";

        if OSynchField."Table No." = 0 then
            "Table No." := OSynchField."Master Table No."
        else
            "Table No." := OSynchField."Table No.";
    end;

    LOCAL procedure CheckDuplicatedRecords()
    var
        //       OSynchOptionCorrel@1000 :
        OSynchOptionCorrel: Record "Outlook Synch. Option Correl.1";
    begin
        OSynchOptionCorrel.RESET;
        OSynchOptionCorrel.SETRANGE("Synch. Entity Code", "Synch. Entity Code");
        OSynchOptionCorrel.SETRANGE("Element No.", "Element No.");
        OSynchOptionCorrel.SETRANGE("Field Line No.", "Field Line No.");
        OSynchOptionCorrel.SETFILTER("Line No.", '<>%1', "Line No.");
        OSynchOptionCorrel.SETRANGE("Option No.", "Option No.");
        OSynchOptionCorrel.SETRANGE("Enumeration No.", "Enumeration No.");
        if not OSynchOptionCorrel.ISEMPTY then
            ERROR(Text001);
    end;


    procedure GetFieldValue() FieldValue: Text;
    var
        //       OutlookSynchTypeConv@1002 :
        OutlookSynchTypeConv: Codeunit 5302;
        //       LookupRecRef@1000 :
        LookupRecRef: RecordRef;
        //       LookupFieldRef@1001 :
        LookupFieldRef: FieldRef;
    begin
        LookupRecRef.OPEN("Table No.");
        LookupFieldRef := LookupRecRef.FIELD("Field No.");
        FieldValue := OutlookSynchTypeConv.OptionValueToText("Option No.", LookupFieldRef.OPTIONCAPTION);
        LookupRecRef.CLOSE;
    end;

    /*begin
    end.
  */
}



