table 7174654 "QBU Library Types SP"
{


    CaptionML = ENU = 'Tipos de librerias SP', ESP = 'Library Types SP';
    LookupPageID = "Library Types";
    DrillDownPageID = "Library Types";

    fields
    {
        field(1; "Metadata Site Defs"; Code[20])
        {
            CaptionML = ESP = 'No. Definici�n Metadatos';


        }
        field(2; "Entry No."; Integer)
        {
            CaptionML = ENU = 'Entry No.', ESP = 'No. mov.';


        }
        field(3; "Name"; Text[100])
        {


            CaptionML = ESP = 'Nombre';

            trigger OnValidate();
            BEGIN
                FncCheckName("Metadata Site Defs", Name);
            END;


        }
        field(4; "Internal Name"; Text[100])
        {


            CaptionML = ESP = 'Nombre interno';
            Editable = false;

            trigger OnValidate();
            BEGIN
                FncCheckInternalName("Metadata Site Defs", "Internal Name");
            END;


        }
        field(5; "Value"; Text[100])
        {
            CaptionML = ESP = 'Valor';


        }
        field(6; "Description"; Text[50])
        {
            CaptionML = ESP = 'Descripci�n';


        }
        field(15; "Type Field Sharepoint"; Option)
        {
            OptionMembers = "Metadata administrado","Short Date","Number","Currency","Text Line","Boolean";
            CaptionML = ENU = 'Type Field Sharepoint', ESP = 'Tipo de campo Sharepoint';
            OptionCaptionML = ENU = 'Metadata administrado,Short Date,Number,Currency,Text Line,Boolean', ESP = 'Metadato administrado,Fecha formato corto,Numero,Moneda,L�nea de texto,Booleano';

            Description = '16.05.18';


        }
        field(499; "Last Date Modified"; DateTime)
        {
            CaptionML = ENU = 'Last User Modified', ESP = 'Fecha �lt. modificaci�n';
            Editable = false;


        }
    }
    keys
    {
        key(key1; "Metadata Site Defs", "Entry No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       TEXT000@1100286007 :
        TEXT000: TextConst ENU = 'Error, process not supported.', ESP = 'Error, proceso no soportado.';
        //       TEXT001@1100286006 :
        TEXT001: TextConst ENU = 'Error, no blanks or the following special characters are allowed ;/():?�*`�[]{}\�!""�$%&/', ESP = 'Error, no se permiten espacios en blanco ni los siguientes car�cteres especiales  ;/():?�*`�[]{}\�!""�$%&/';
        //       TEXT002@1100286005 :
        TEXT002: TextConst ENU = 'The metadata schema will be opened and then it will need to be checked again. �Do you wish to continue?', ESP = 'Se abrir� el esquema de los metadatos y despues ser� necesario volver a comprobarlo. �Desea continuar?';
        //       TEXT003@1100286004 :
        TEXT003: TextConst ENU = 'Operation canceled by the user.', ESP = 'Operaci�n cancelada por el usuario.';
        //       TEXTWORDRESERVE@1100286003 :
        TEXTWORDRESERVE: TextConst ENU = 'Name,Type,Description', ESP = 'Name,Type,Description';
        //       TEXT004@1100286002 :
        TEXT004: TextConst ENU = 'It is not possible to use the following words reserved %1.', ESP = 'Error, no es posible utilizar las siguientes palabras reservadas %1.';
        //       TEXT005@1100286001 :
        TEXT005: TextConst ENU = 'Error, it is not possible to repeat the name of the column.', ESP = 'Error, no es posible repetir el nombre interno en Sharepoint.';
        //       TEXT006@1100286008 :
        TEXT006: TextConst ENU = 'Error, you must clear the values before renaming.', ESP = 'Error, debe borrar los valores asociados antes de cambiar el nombre.';
        //       TEXTERROR@1100286000 :
        TEXTERROR: TextConst ENU = ' ;/():?�*`�[]{}\�!""�$%&/', ESP = ' ;/():?�*`�[]{}\�!""�$%&/';
        //       NoSerieMgt@1100286009 :
        NoSerieMgt: Codeunit "NoSeriesManagement";
        //       DragDropSPSetup@1100286010 :
        DragDropSPSetup: Record 7174650;



    trigger OnInsert();
    begin
        DragDropSPSetup.GET();
        DragDropSPSetup.TESTFIELD("Serie No. Internal Name");

        "Internal Name" := NoSerieMgt.GetNextNo(DragDropSPSetup."Serie No. Internal Name", TODAY, TRUE);

        "Last Date Modified" := CREATEDATETIME(TODAY, TIME);
    end;

    trigger OnModify();
    begin
        "Last Date Modified" := CREATEDATETIME(TODAY, TIME);
    end;

    trigger OnDelete();
    var
        //                LibraryTypesValuesSP@1100286000 :
        LibraryTypesValuesSP: Record 7174655;
    begin

        LibraryTypesValuesSP.RESET;
        LibraryTypesValuesSP.SETRANGE("Metadata Site Defs", "Metadata Site Defs");
        if LibraryTypesValuesSP.FINDSET then
            LibraryTypesValuesSP.DELETEALL;
    end;



    LOCAL procedure FncChgCheck()
    var
        //       rShrSiteDefs@1100286000 :
        rShrSiteDefs: Record 7174651;
    begin
    end;

    //     LOCAL procedure FncCheckName (pNoDef@1100286001 : Code[20];pName@1000000000 :
    LOCAL procedure FncCheckName(pNoDef: Code[20]; pName: Text)
    var
        //       LibraryTypesSP@1100286000 :
        LibraryTypesSP: Record 7174654;
        //       LibraryTypesValuesSP@1100286002 :
        LibraryTypesValuesSP: Record 7174655;
    begin

        if pName <> xRec.Name then begin
            LibraryTypesValuesSP.RESET;
            LibraryTypesValuesSP.SETRANGE("Metadata Site Defs", pNoDef);
            LibraryTypesValuesSP.SETRANGE(Name, xRec.Name);
            if LibraryTypesValuesSP.FINDFIRST then
                ERROR(TEXT006);
        end;

        ///Comprobar que no se repite el mmismo nombre de columna columna.
        LibraryTypesSP.RESET;
        LibraryTypesSP.SETRANGE("Metadata Site Defs", pNoDef);
        LibraryTypesSP.SETRANGE(Name, pName);
        if LibraryTypesSP.COUNT >= 2 then
            ERROR(TEXT005);
    end;

    //     LOCAL procedure FncCheckInternalName (pNoDef@1100286002 : Code[20];pName@1100286000 :
    LOCAL procedure FncCheckInternalName(pNoDef: Code[20]; pName: Text)
    var
        //       LibraryTypesSP@1100286003 :
        LibraryTypesSP: Record 7174654;
        //       NameNew@1100286004 :
        NameNew: Text;
        //       IntLong@1100286001 :
        IntLong: Integer;
        //       SiteSPMetadataDefs@1100286005 :
        SiteSPMetadataDefs: Record 7174652;
    begin

        if pName = '' then
            exit;

        IntLong := STRLEN(pName);
        NameNew := DELCHR(pName, '=', TEXTERROR);

        if IntLong <> STRLEN(NameNew) then
            ERROR(TEXT001);

        if STRPOS(UPPERCASE(pName), UPPERCASE(TEXTWORDRESERVE)) <> 0 then
            ERROR(TEXT004, TEXTWORDRESERVE);

        ///Comprobar que no se repite el mismo nombre de columna en cualquiera de las definiciones.
        LibraryTypesSP.RESET;
        //LibraryTypesSP.SETRANGE("Metadata Site Defs",pNoDef);
        LibraryTypesSP.SETRANGE("Internal Name", pName);
        if LibraryTypesSP.COUNT >= 1 then
            ERROR(TEXT005);

        SiteSPMetadataDefs.RESET;
        //SiteSPMetadataDefs.SETRANGE("Metadata Site Definition",pNoDef);
        SiteSPMetadataDefs.SETRANGE("Internal Name", pName);
        if SiteSPMetadataDefs.COUNT >= 1 then
            ERROR(TEXT005);
    end;

    /*begin
    //{
//      QUONEXT 20.07.17 DRAG&DROP. Selecci�n del tipo de libreria de sharepoint (se lleva un metadato con el valor asociado al arrastrar)
//    }
    end.
  */
}







