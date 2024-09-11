table 51281 "Outlook Synch. Entity Element1"
{


    CaptionML = ENU = 'Outlook Synch. Entity Element', ESP = 'Elemento objeto sinc. Outlook';
    PasteIsValid = false;

    fields
    {
        field(1; "Synch. Entity Code"; Code[10])
        {
            TableRelation = "Outlook Synch. Entity 1"."Code";
            CaptionML = ENU = 'Synch. Entity Code', ESP = 'C�digo entidad sinc.';
            NotBlank = true;


        }
        field(2; "Element No."; Integer)
        {
            CaptionML = ENU = 'Element No.', ESP = 'N� elemento';


        }
        field(3; "Table No."; Integer)
        {
            TableRelation = AllObjWithCaption."Object ID" WHERE("Object Type" = CONST("Table"));


            CaptionML = ENU = 'Table No.', ESP = 'N� tabla';
            BlankZero = true;

            trigger OnValidate();
            BEGIN
                IF "Table No." <> xRec."Table No." THEN BEGIN
                    CheckUserSetup;
                    CheckMasterTableNo;
                    TESTFIELD("Table No.");

                    IF NOT OSynchSetupMgt.CheckPKFieldsQuantity("Table No.") THEN
                        EXIT;

                    IF "Element No." <> 0 THEN BEGIN
                        IF NOT
                           CONFIRM(
                             STRSUBSTNO(
                               Text003,
                               OSynchField.TABLECAPTION,
                               OSynchFilter.TABLECAPTION,
                               OSynchDependency.TABLECAPTION))
                        THEN BEGIN
                            "Table No." := xRec."Table No.";
                            EXIT;
                        END;

                        OSynchField.SETRANGE("Synch. Entity Code", "Synch. Entity Code");
                        OSynchField.SETRANGE("Element No.", "Element No.");
                        OSynchField.DELETEALL(TRUE);

                        OSynchFilter.RESET;
                        OSynchFilter.SETRANGE("Record GUID", "Record GUID");
                        OSynchFilter.DELETEALL;

                        OSynchDependency.RESET;
                        OSynchDependency.SETRANGE("Synch. Entity Code", "Synch. Entity Code");
                        OSynchDependency.SETRANGE("Element No.", "Element No.");
                        OSynchDependency.DELETEALL(TRUE);

                        "Table Relation" := '';
                    END;
                END;

                CALCFIELDS("Table Caption", "No. of Dependencies");
            END;

            trigger OnLookup();
            VAR
                //                                                               TableNo@1000 :
                TableNo: Integer;
            BEGIN
                CheckMasterTableNo;
                TableNo := OSynchSetupMgt.ShowTablesList;

                IF TableNo <> 0 THEN
                    VALIDATE("Table No.", TableNo);
            END;


        }
        field(4; "Table Caption"; Text[250])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("AllObjWithCaption"."Object Caption" WHERE("Object Type" = CONST("Table"),
                                                                                                                "Object ID" = FIELD("Table No.")));
            CaptionML = ENU = 'Table Caption', ESP = 'T�tulo tabla';
            Editable = false;


        }
        field(5; "Table Relation"; Text[250])
        {


            CaptionML = ENU = 'Table Relation', ESP = 'Relaci�n de tabla';
            Editable = false;

            trigger OnValidate();
            BEGIN
                TESTFIELD("Table Relation");
            END;


        }
        field(6; "Outlook Collection"; Text[80])
        {


            CaptionML = ENU = 'Outlook Collection', ESP = 'Colecci�n Outlook';

            trigger OnValidate();
            BEGIN
                IF "Outlook Collection" <> '' THEN BEGIN
                    OSynchEntity.GET("Synch. Entity Code");
                    IF NOT OSynchSetupMgt.ValidateOutlookCollectionName("Outlook Collection", OSynchEntity."Outlook Item") THEN
                        ERROR(Text002);
                    CheckCollectionName;
                END;

                IF "Outlook Collection" = xRec."Outlook Collection" THEN
                    EXIT;

                CheckUserSetup;
                CheckMasterTableNo;

                IF "Element No." = 0 THEN
                    EXIT;

                IF xRec."Outlook Collection" <> '' THEN
                    IF NOT
                       CONFIRM(
                         STRSUBSTNO(
                           Text003,
                           OSynchField.TABLECAPTION,
                           OSynchFilter.TABLECAPTION,
                           OSynchDependency.TABLECAPTION))
                    THEN BEGIN
                        "Outlook Collection" := xRec."Outlook Collection";
                        EXIT;
                    END;

                OSynchField.RESET;
                OSynchField.SETRANGE("Synch. Entity Code", "Synch. Entity Code");
                OSynchField.SETRANGE("Element No.", "Element No.");
                OSynchField.DELETEALL(TRUE);

                OSynchDependency.RESET;
                OSynchDependency.SETRANGE("Synch. Entity Code", "Synch. Entity Code");
                OSynchDependency.SETRANGE("Element No.", "Element No.");
                OSynchDependency.DELETEALL(TRUE);
            END;

            trigger OnLookup();
            VAR
                //                                                               CollectionName@1000 :
                CollectionName: Text[80];
            BEGIN
                CheckMasterTableNo;
                OSynchEntity.GET("Synch. Entity Code");

                OSynchEntity.TESTFIELD("Outlook Item");

                CollectionName := OSynchSetupMgt.ShowOCollectionsList(OSynchEntity."Outlook Item");

                IF CollectionName <> '' THEN
                    VALIDATE("Outlook Collection", CollectionName);
            END;


        }
        field(7; "Master Table No."; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Outlook Synch. Entity 1"."Table No." WHERE("Code" = FIELD("Synch. Entity Code")));
            CaptionML = ENU = 'Master Table No.', ESP = 'N� tabla principal';
            Editable = false;


        }
        field(8; "Record GUID"; GUID)
        {
            DataClassification = SystemMetadata;
            CaptionML = ENU = 'Record GUID', ESP = 'GUID registro';
            Editable = false;


        }
        field(9; "No. of Dependencies"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Outlook Synch. Dependency 1" WHERE("Synch. Entity Code" = FIELD("Synch. Entity Code"),
                                                                                                        "Element No." = FIELD("Element No.")));
            CaptionML = ENU = 'No. of Dependencies', ESP = 'N� dependencias';
            Editable = false;


        }
    }
    keys
    {
        key(key1; "Synch. Entity Code", "Element No.")
        {
            Clustered = true;
        }
        key(key2; "Table No.")
        {
            ;
        }
    }
    fieldgroups
    {
    }

    var
        //       OSynchEntity@1003 :
        OSynchEntity: Record "Outlook Synch. Entity 1";
        //       OSynchFilter@1002 :
        OSynchFilter: Record "Outlook Synch. Filter 1";
        //       OSynchField@1001 :
        OSynchField: Record "Outlook Synch. Field 1";
        //       OSynchDependency@1012 :
        OSynchDependency: Record "Outlook Synch. Dependency 1";
        //       OSynchSetupDetail@1011 :
        OSynchSetupDetail: Record "Outlook Synch. Setup Detail 1";
        //       OSynchSetupMgt@1000 :
        OSynchSetupMgt: Codeunit 50849;
        //       Text001@1005 :
        Text001: TextConst ENU = 'You cannot delete this collection because it is used with synchronization.', ESP = 'No puede eliminar esta colecci�n porque se utiliza con la sincronizaci�n.';
        //       Text002@1007 :
        Text002: TextConst ENU = 'The Outlook item collection with this name does not exist.\Click the AssistButton to see a list of valid collections for this Outlook item.', ESP = 'La colecci�n de Outlook con este nombre no existe.\Haga clic en el bot�n AssistButton para ver una lista de las colecciones v�lidas para este elemento de Outlook.';
        //       Text003@1004 :
        Text003: TextConst ENU = 'if you change the value in this field, the %1, %2, and %3 records related to this collection will be deleted.\Do you want to change it anyway?', ESP = 'Si cambia el valor de este campo, los registros %1, %2 y %3 relacionados con esta colecci�n se eliminar�n.\�Desea cambiarlo de todas maneras?';
        //       Text004@1006 :
        Text004: TextConst ENU = 'You cannot change this collection because it is used with synchronization for user %1.', ESP = 'No puede cambiar esta colecci�n porque se est� utilizando con la sincronizaci�n para el usuario %1.';
        //       Text005@1008 :
        Text005: TextConst ENU = 'An Outlook item collection with this name already exists.\Identification fields and values:\%1=''''%2'''',%3=''''%4''''.', ESP = 'Ya existe una colecci�n de elementos de Outlook con este nombre.\Campos y valores de identificaci�n:\%1=''''%2'''',%3=''''%4''''.';




    trigger OnInsert();
    begin
        TESTFIELD("Table No.");

        if ISNULLGUID("Record GUID") then
            "Record GUID" := CREATEGUID;
    end;

    trigger OnDelete();
    begin
        OSynchSetupDetail.RESET;
        OSynchSetupDetail.SETRANGE("Synch. Entity Code", "Synch. Entity Code");
        OSynchSetupDetail.SETRANGE("Element No.", "Element No.");
        if not OSynchSetupDetail.ISEMPTY then
            ERROR(Text001);

        OSynchSetupDetail.DELETEALL(TRUE);

        OSynchFilter.RESET;
        OSynchFilter.SETRANGE("Record GUID", "Record GUID");
        OSynchFilter.DELETEALL;

        OSynchField.RESET;
        OSynchField.SETRANGE("Synch. Entity Code", "Synch. Entity Code");
        OSynchField.SETRANGE("Element No.", "Element No.");
        OSynchField.DELETEALL(TRUE);

        OSynchDependency.RESET;
        OSynchDependency.SETRANGE("Synch. Entity Code", "Synch. Entity Code");
        OSynchDependency.SETRANGE("Element No.", "Element No.");
        OSynchDependency.DELETEALL(TRUE);
    end;



    procedure ShowElementFields()
    begin
        TESTFIELD("Synch. Entity Code");
        TESTFIELD("Element No.");
        TESTFIELD("Table No.");
        TESTFIELD("Table Relation");
        TESTFIELD("Outlook Collection");

        OSynchField.RESET;
        OSynchField.SETRANGE("Synch. Entity Code", "Synch. Entity Code");
        OSynchField.SETRANGE("Element No.", "Element No.");

        PAGE.RUNMODAL(PAGE::"Outlook Synch. Fields", OSynchField);
    end;


    procedure ShowDependencies()
    begin
        TESTFIELD("Synch. Entity Code");
        TESTFIELD("Element No.");
        TESTFIELD("Table No.");
        TESTFIELD("Table Relation");
        TESTFIELD("Outlook Collection");

        OSynchDependency.RESET;
        OSynchDependency.SETRANGE("Synch. Entity Code", "Synch. Entity Code");
        OSynchDependency.SETRANGE("Element No.", "Element No.");

        PAGE.RUNMODAL(PAGE::"Outlook Synch. Dependencies", OSynchDependency);
        CALCFIELDS("No. of Dependencies");
    end;


    procedure CheckMasterTableNo()
    begin
        CALCFIELDS("Master Table No.");
        if "Master Table No." = 0 then begin
            OSynchEntity.GET("Synch. Entity Code");
            OSynchEntity.TESTFIELD("Table No.");
        end;
    end;


    procedure CheckUserSetup()
    var
        //       OSynchUserSetup@1000 :
        OSynchUserSetup: Record "Outlook Synch. User Setup 1";
    begin
        OSynchUserSetup.RESET;
        OSynchUserSetup.SETRANGE("Synch. Entity Code", "Synch. Entity Code");
        if not OSynchUserSetup.FINDSET then
            exit;

        repeat
            OSynchUserSetup.CALCFIELDS("No. of Elements");
            if OSynchUserSetup."No. of Elements" > 0 then
                if OSynchSetupDetail.GET(OSynchUserSetup."User ID", "Synch. Entity Code", "Element No.") then
                    ERROR(Text004, OSynchUserSetup."User ID");
        until OSynchUserSetup.NEXT = 0;
    end;


    procedure CheckCollectionName()
    var
        //       OSynchEntityElement@1000 :
        OSynchEntityElement: Record "Outlook Synch. Entity Element1";
    begin
        OSynchEntityElement.RESET;
        OSynchEntityElement.SETRANGE("Synch. Entity Code", "Synch. Entity Code");
        OSynchEntityElement.SETRANGE("Outlook Collection", "Outlook Collection");
        if OSynchEntityElement.FINDFIRST then
            ERROR(
              Text005,
              OSynchEntityElement.FIELDCAPTION("Synch. Entity Code"),
              OSynchEntityElement."Synch. Entity Code",
              OSynchEntityElement.FIELDCAPTION("Element No."),
              OSynchEntityElement."Element No.");
    end;

    /*begin
    end.
  */
}



