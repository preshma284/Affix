table 51289 "Outlook Synch. Dependency 1"
{

    DataCaptionFields = "Synch. Entity Code";
    CaptionML = ENU = 'Outlook Synch. Dependency', ESP = 'Dependencia sinc. Outlook';
    PasteIsValid = false;
    LookupPageID = "Outlook Synch. Dependencies";
    DrillDownPageID = "Outlook Synch. Dependencies";

    fields
    {
        field(1; "Synch. Entity Code"; Code[10])
        {
            TableRelation = "Outlook Synch. Entity Element1"."Synch. Entity Code";


            CaptionML = ENU = 'Synch. Entity Code', ESP = 'C�digo entidad sinc.';
            NotBlank = true;

            trigger OnValidate();
            BEGIN
                TESTFIELD("Element No.");
            END;


        }
        field(2; "Element No."; Integer)
        {
            CaptionML = ENU = 'Element No.', ESP = 'N� elemento';


        }
        field(3; "Depend. Synch. Entity Code"; Code[10])
        {
            TableRelation = "Outlook Synch. Entity 1"."Code";


            CaptionML = ENU = 'Depend. Synch. Entity Code', ESP = 'C�digo objeto sinc. depend.';

            trigger OnValidate();
            BEGIN
                IF "Synch. Entity Code" = "Depend. Synch. Entity Code" THEN
                    ERROR(Text001, "Synch. Entity Code");

                LoopCheck("Depend. Synch. Entity Code", "Synch. Entity Code");

                CALCFIELDS(Description);
            END;


        }
        field(4; "Description"; Text[80])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Outlook Synch. Entity"."Description" WHERE("Code" = FIELD("Depend. Synch. Entity Code")));
            CaptionML = ENU = 'Description', ESP = 'Descripci�n';
            Editable = false;


        }
        field(5; "Condition"; Text[250])
        {
            CaptionML = ENU = 'Condition', ESP = 'Condici�n';
            Editable = false;


        }
        field(6; "Table Relation"; Text[250])
        {


            CaptionML = ENU = 'Table Relation', ESP = 'Relaci�n de tabla';
            Editable = false;

            trigger OnValidate();
            BEGIN
                TESTFIELD("Table Relation");
            END;


        }
        field(7; "Record GUID"; GUID)
        {
            DataClassification = SystemMetadata;
            CaptionML = ENU = 'Record GUID', ESP = 'GUID registro';
            Editable = false;


        }
        field(8; "Depend. Synch. Entity Tab. No."; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Outlook Synch. Entity"."Table No." WHERE("Code" = FIELD("Depend. Synch. Entity Code")));
            CaptionML = ENU = 'Depend. Synch. Entity Tab. No.', ESP = 'N� tab. objeto sinc. depend.';
            Editable = false;


        }
    }
    keys
    {
        key(key1; "Synch. Entity Code", "Element No.", "Depend. Synch. Entity Code")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       Text001@1000 :
        Text001: TextConst ENU = 'The selected entity cannot be the same as the %1 entity.', ESP = 'El objeto seleccionado no puede ser el mismo que el objeto %1.';
        //       Text002@1001 :
        Text002: TextConst ENU = 'You cannot add this entity because it is already setup as a dependency for one or more of its own dependencies.', ESP = 'No puede agregar este objeto porque ya est� configurado como una dependencia para una o m�s de sus propias dependencias.';
        //       OSynchFilter@1002 :
        OSynchFilter: Record "Outlook Synch. Filter 1";
        //       Text003@1003 :
        Text003: TextConst ENU = 'You cannot change this dependency for the %1 collection of the %2 entity because it is set up for synchronization.', ESP = 'No puede cambiar esta dependencia para la colecci�n %1 del objeto %2 porque est� configurada para la sincronizaci�n.';




    trigger OnInsert();
    begin
        CheckUserSetup;

        if ISNULLGUID("Record GUID") then
            "Record GUID" := CREATEGUID;

        TESTFIELD("Table Relation");
    end;

    trigger OnDelete();
    begin
        CheckUserSetup;

        OSynchFilter.RESET;
        OSynchFilter.SETRANGE("Record GUID", "Record GUID");
        OSynchFilter.DELETEALL;
    end;

    trigger OnRename();
    begin
        CheckUserSetup;

        OSynchFilter.RESET;
        OSynchFilter.SETRANGE("Record GUID", "Record GUID");
        OSynchFilter.DELETEALL;
        Condition := '';
        "Table Relation" := '';
    end;



    // procedure LoopCheck (DependSynchEntityCode@1003 : Code[10];SynchEntityCode@1000 :
    procedure LoopCheck(DependSynchEntityCode: Code[10]; SynchEntityCode: Code[10])
    var
        //       OSynchDependency@1002 :
        OSynchDependency: Record "Outlook Synch. Dependency 1";
    begin
        OSynchDependency.RESET;
        OSynchDependency.SETRANGE("Synch. Entity Code", DependSynchEntityCode);
        OSynchDependency.SETRANGE("Depend. Synch. Entity Code", SynchEntityCode);
        if OSynchDependency.FIND('-') then
            ERROR(Text002);

        OSynchDependency.SETRANGE("Depend. Synch. Entity Code");
        if OSynchDependency.FIND('-') then
            repeat
                if OSynchDependency."Depend. Synch. Entity Code" = "Synch. Entity Code" then
                    ERROR(Text002);

                LoopCheck(OSynchDependency."Depend. Synch. Entity Code", OSynchDependency."Synch. Entity Code");
            until OSynchDependency.NEXT = 0;
    end;


    procedure CheckUserSetup()
    var
        //       OSynchEntityElement@1002 :
        OSynchEntityElement: Record "Outlook Synch. Entity Element1";
        //       OSynchUserSetup@1000 :
        OSynchUserSetup: Record "Outlook Synch. User Setup 1";
        //       OSynchSetupDetail@1001 :
        OSynchSetupDetail: Record "Outlook Synch. Setup Detail 1";
    begin
        OSynchUserSetup.RESET;
        OSynchUserSetup.SETRANGE("Synch. Entity Code", "Synch. Entity Code");
        if not OSynchUserSetup.FIND('-') then
            exit;

        repeat
            OSynchUserSetup.CALCFIELDS("No. of Elements");
            if OSynchUserSetup."No. of Elements" > 0 then
                if OSynchSetupDetail.GET(OSynchUserSetup."User ID", "Synch. Entity Code", "Element No.") then begin
                    OSynchEntityElement.GET("Synch. Entity Code", "Element No.");
                    ERROR(
                      Text003,
                      OSynchEntityElement."Outlook Collection",
                      OSynchEntityElement."Synch. Entity Code");
                end;
        until OSynchUserSetup.NEXT = 0;
    end;

    /*begin
    end.
  */
}



