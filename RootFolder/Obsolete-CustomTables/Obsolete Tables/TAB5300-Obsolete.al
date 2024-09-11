table 51280 "Outlook Synch. Entity 1"
{

    DataCaptionFields = "Code", "Description";
    CaptionML = ENU = 'Outlook Synch. Entity', ESP = 'Entidad sinc. Outlook';
    PasteIsValid = false;
    LookupPageID = "Outlook Synch. Entity List";
    DrillDownPageID = "Outlook Synch. Entity List";

    fields
    {
        field(1; "Code"; Code[10])
        {
            CaptionML = ENU = 'Code', ESP = 'C�digo';
            NotBlank = true;


        }
        field(2; "Description"; Text[80])
        {


            CaptionML = ENU = 'Description', ESP = 'Descripci�n';

            trigger OnValidate();
            VAR
                //                                                                 OutlookSynchUserSetup@1000 :
                OutlookSynchUserSetup: Record "Outlook Synch. User Setup 1";
            BEGIN
                IF Description <> '' THEN
                    EXIT;

                OutlookSynchUserSetup.SETRANGE("Synch. Entity Code", Code);
                IF NOT OutlookSynchUserSetup.ISEMPTY THEN
                    ERROR(Text005, FIELDCAPTION(Description), Code);
            END;


        }
        field(3; "Table No."; Integer)
        {
            TableRelation = AllObjWithCaption."Object ID" WHERE("Object Type" = CONST("Table"));


            CaptionML = ENU = 'Table No.', ESP = 'N� tabla';
            BlankZero = true;

            trigger OnValidate();
            BEGIN
                IF "Table No." = xRec."Table No." THEN
                    EXIT;

                CheckUserSetup;
                TESTFIELD("Table No.");

                IF NOT OSynchSetupMgt.CheckPKFieldsQuantity("Table No.") THEN
                    EXIT;

                IF xRec."Table No." <> 0 THEN BEGIN
                    IF NOT
                       CONFIRM(
                         STRSUBSTNO(
                           Text001,
                           OSynchEntityElement.TABLECAPTION,
                           OSynchField.TABLECAPTION,
                           OSynchFilter.TABLECAPTION,
                           OSynchDependency.TABLECAPTION))
                    THEN BEGIN
                        "Table No." := xRec."Table No.";
                        EXIT;
                    END;

                    Condition := '';
                    "Outlook Item" := '';

                    OSynchDependency.RESET;
                    OSynchDependency.SETRANGE("Depend. Synch. Entity Code", Code);
                    OSynchDependency.DELETEALL(TRUE);

                    OSynchEntityElement.RESET;
                    OSynchEntityElement.SETRANGE("Synch. Entity Code", Code);
                    OSynchEntityElement.DELETEALL(TRUE);

                    OSynchField.RESET;
                    OSynchField.SETRANGE("Synch. Entity Code", Code);
                    OSynchField.DELETEALL(TRUE);

                    OSynchFilter.RESET;
                    OSynchFilter.SETRANGE("Record GUID", "Record GUID");
                    OSynchFilter.DELETEALL;
                END;

                CALCFIELDS("Table Caption");
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
        field(4; "Table Caption"; Text[250])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("AllObjWithCaption"."Object Caption" WHERE("Object Type" = CONST("Table"),
                                                                                                                "Object ID" = FIELD("Table No.")));
            CaptionML = ENU = 'Table Caption', ESP = 'T�tulo tabla';
            Editable = false;


        }
        field(5; "Condition"; Text[250])
        {


            CaptionML = ENU = 'Condition', ESP = 'Condici�n';
            Editable = false;

            trigger OnValidate();
            VAR
                //                                                                 RecordRef@1000 :
                RecordRef: RecordRef;
            BEGIN
                RecordRef.OPEN("Table No.");
                RecordRef.SETVIEW(Condition);
                Condition := RecordRef.GETVIEW(FALSE);
            END;


        }
        field(6; "Outlook Item"; Text[80])
        {


            CaptionML = ENU = 'Outlook Item', ESP = 'Elemento Outlook';

            trigger OnValidate();
            BEGIN
                TESTFIELD("Outlook Item");
                IF NOT OSynchSetupMgt.ValidateOutlookItemName("Outlook Item") THEN
                    ERROR(Text002);

                IF "Outlook Item" = xRec."Outlook Item" THEN
                    EXIT;

                CheckUserSetup;

                IF xRec."Outlook Item" = '' THEN
                    EXIT;

                IF NOT
                   CONFIRM(
                     STRSUBSTNO(
                       Text001,
                       OSynchEntityElement.TABLECAPTION,
                       OSynchField.TABLECAPTION,
                       OSynchFilter.TABLECAPTION,
                       OSynchDependency.TABLECAPTION))
                THEN BEGIN
                    "Outlook Item" := xRec."Outlook Item";
                    EXIT;
                END;

                OSynchDependency.RESET;
                OSynchDependency.SETRANGE("Depend. Synch. Entity Code", Code);
                OSynchDependency.DELETEALL(TRUE);

                OSynchEntityElement.RESET;
                OSynchEntityElement.SETRANGE("Synch. Entity Code", Code);
                OSynchEntityElement.DELETEALL(TRUE);

                OSynchField.RESET;
                OSynchField.SETRANGE("Synch. Entity Code", Code);
                OSynchField.DELETEALL(TRUE);
            END;

            trigger OnLookup();
            VAR
                //                                                               ItemName@1000 :
                ItemName: Text[50];
            BEGIN
                ItemName := OSynchSetupMgt.ShowOItemsList;

                IF ItemName <> '' THEN
                    VALIDATE("Outlook Item", ItemName);
            END;


        }
        field(7; "Record GUID"; GUID)
        {
            DataClassification = SystemMetadata;
            CaptionML = ENU = 'Record GUID', ESP = 'GUID registro';
            Editable = false;


        }
    }
    keys
    {
        key(key1; "Code")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       OSynchEntityElement@1003 :
        OSynchEntityElement: Record "Outlook Synch. Entity Element1";
        //       OSynchFilter@1002 :
        OSynchFilter: Record "Outlook Synch. Filter 1";
        //       OSynchField@1001 :
        OSynchField: Record "Outlook Synch. Field 1";
        //       OSynchDependency@1010 :
        OSynchDependency: Record "Outlook Synch. Dependency 1";
        //       OSynchSetupMgt@1000 :
        OSynchSetupMgt: Codeunit 50849;
        //       Text001@1005 :
        Text001: TextConst ENU = 'if you change the value in this field, the %1, %2, %3 and %4 records related to this entity will be deleted.\Do you want to change it anyway?', ESP = 'Si cambia el valor de este campo, los registros %1, %2, %3 y %4 relacionados con este objeto se eliminar�n.\�Desea cambiarlo de todas maneras?';
        //       Text002@1004 :
        Text002: TextConst ENU = 'The Outlook item with this name does not exist.\Click the AssistButton to see a list of valid Outlook items', ESP = 'El elemento de Outlook con este nombre no existe.\Haga clic en el bot�n AssistButton para ver una lista de elementos de Outlook v�lidos.';
        //       Text003@1009 :
        Text003: TextConst ENU = 'You cannot delete this entity because it is set up for synchronization. Please verify %1.', ESP = 'No puede eliminar este objeto porque est� configurado para la sincronizaci�n. Compruebe %1.';
        //       Text004@1006 :
        Text004: TextConst ENU = 'There are entities which depend on this entity. if you delete it, the relation to its dependencies will be removed.\Do you want to delete it anyway?', ESP = 'Hay objetos que dependen de este objeto. Si la elimina, la relaci�n con sus dependencias desaparecer�.\�Desea eliminarla de todas formas?';
        //       Text005@1011 :
        Text005: TextConst ENU = 'The %1 field cannot be blank because the %2 entity is used with synchronization.', ESP = 'El campo %1 no puede estar vac�o porque el objeto %2 se utiliza con sincronizaci�n.';
        //       Text006@1012 :
        Text006: TextConst ENU = 'You cannot change this entity because it is used with synchronization for the user %1.', ESP = 'No puede cambiar este objeto porque se est� utilizando con la sincronizaci�n para el usuario %1.';




    trigger OnInsert();
    begin
        if ISNULLGUID("Record GUID") then
            "Record GUID" := CREATEGUID;
    end;

    trigger OnDelete();
    var
        //                OutlookSynchUserSetup@1000 :
        OutlookSynchUserSetup: Record "Outlook Synch. User Setup 1";
    begin
        OSynchDependency.RESET;
        OSynchDependency.SETRANGE("Depend. Synch. Entity Code", Code);
        if not OSynchDependency.ISEMPTY then
            if not CONFIRM(Text004) then
                ERROR('');

        OutlookSynchUserSetup.SETRANGE("Synch. Entity Code", Code);
        if not OutlookSynchUserSetup.ISEMPTY then
            ERROR(Text003, OutlookSynchUserSetup.TABLECAPTION);

        OSynchDependency.DELETEALL;
        OutlookSynchUserSetup.DELETEALL(TRUE);

        OSynchEntityElement.RESET;
        OSynchEntityElement.SETRANGE("Synch. Entity Code", Code);
        OSynchEntityElement.DELETEALL(TRUE);

        OSynchField.RESET;
        OSynchField.SETRANGE("Synch. Entity Code", Code);
        OSynchField.DELETEALL(TRUE);

        OSynchFilter.RESET;
        OSynchFilter.SETRANGE("Record GUID", "Record GUID");
        OSynchFilter.DELETEALL;
    end;



    procedure ShowEntityFields()
    begin
        TESTFIELD("Outlook Item");
        if "Table No." = 0 then
            FIELDERROR("Table No.");

        OSynchField.RESET;
        OSynchField.SETRANGE("Synch. Entity Code", Code);
        OSynchField.SETRANGE("Element No.", 0);

        PAGE.RUNMODAL(PAGE::"Outlook Synch. Fields", OSynchField);
    end;

    LOCAL procedure CheckUserSetup()
    var
        //       OSynchUserSetup@1000 :
        OSynchUserSetup: Record "Outlook Synch. User Setup 1";
    begin
        OSynchUserSetup.RESET;
        OSynchUserSetup.SETRANGE("Synch. Entity Code", Code);
        if OSynchUserSetup.FINDFIRST then
            ERROR(Text006, OSynchUserSetup."User ID");
    end;

    /*begin
    end.
  */
}



