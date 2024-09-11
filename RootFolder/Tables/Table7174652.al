table 7174652 "Site Sharepoint Metadata Defs"
{


    CaptionML = ENU = 'Site Sharepoint Metadata Defs', ESP = 'Metadatos del sitio Sharepoint';

    fields
    {
        field(1; "Metadata Site Definition"; Code[20])
        {
            TableRelation = "Site Sharepoint Definition"."No.";
            CaptionML = ENU = 'Metadata Site Header ID', ESP = 'No. Def. Metadatos';


        }
        field(2; "Line No."; Integer)
        {
            CaptionML = ENU = 'Id.', ESP = 'No. l�nea';


        }
        field(3; "Name"; Text[100])
        {


            CaptionML = ENU = 'Name', ESP = 'Nombre';

            trigger OnValidate();
            BEGIN

                FncCheckName("Metadata Site Definition", Name);


                TESTFIELD("Field Filter", FALSE);
            END;


        }
        field(4; "Value Type"; Option)
        {
            OptionMembers = " ","Field Value","Fixed Value";

            CaptionML = ENU = 'Value Type', ESP = 'Tipo Valor';
            OptionCaptionML = ENU = '" ,Field Value,Fixed Value"', ESP = '" ,Campo,Valor fijo"';


            trigger OnValidate();
            BEGIN
                IF "Value Type" <> xRec."Value Type" THEN BEGIN
                    Value := '';
                    "Calculate Field" := FALSE;
                END;
            END;


        }
        field(5; "Value"; Text[50])
        {


            CaptionML = ENU = 'Value', ESP = 'Valor';

            trigger OnValidate();
            VAR
                //                                                                 rField@1100286000 :
                rField: Record 2000000041;
                //                                                                 IntCampo@1100286001 :
                IntCampo: Integer;
            BEGIN
                IF "Value Type" <> "Value Type"::"Field Value" THEN
                    EXIT;

                EVALUATE(IntCampo, Value);

                CALCFIELDS(IDTable);
                rField.RESET;
                rField.SETRANGE(TableNo, IDTable);
                rField.SETRANGE("No.", IntCampo);
                rField.FINDFIRST;
                "Name Fields" := rField."Field Caption";
                "Calculate Field" := FALSE;
                IF rField.Class = rField.Class::FlowField THEN
                    "Calculate Field" := TRUE;
            END;

            trigger OnLookup();
            VAR
                //                                                               rField@1100286000 :
                rField: Record 2000000041;
            BEGIN
                IF "Value Type" <> "Value Type"::"Field Value" THEN
                    EXIT;

                CALCFIELDS(IDTable);
                rField.RESET;
                rField.SETRANGE(TableNo, IDTable);
                IF rField.FINDFIRST THEN;
                IF PAGE.RUNMODAL(PAGE::"Fields NAV", rField) = ACTION::LookupOK THEN BEGIN
                    Value := FORMAT(rField."No.");
                    "Name Fields" := rField."Field Caption";
                    "Calculate Field" := FALSE;
                    IF rField.Class = rField.Class::FlowField THEN
                        "Calculate Field" := TRUE;
                END;
            END;


        }
        field(6; "Name Fields"; Text[50])
        {
            CaptionML = ENU = 'Name Fields', ESP = 'Nombre campo';
            Editable = false;


        }
        field(7; "IDTable"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Site Sharepoint Definition"."IdTable" WHERE("No." = FIELD("Metadata Site Definition")));
            CaptionML = ENU = 'TablaId', ESP = 'ID Tabla';
            Editable = false;


        }
        field(10; "Check"; Boolean)
        {
            CaptionML = ESP = 'Revisado';


        }
        field(11; "Calculate Field"; Boolean)
        {
            CaptionML = ENU = 'Calculate Field', ESP = 'Campo Calculado';


        }
        field(12; "Internal Name"; Text[100])
        {


            CaptionML = ENU = 'Internal Name', ESP = 'Nombre interno SP';

            trigger OnValidate();
            BEGIN

                FncCheckInternalName("Metadata Site Definition", "Internal Name");
            END;


        }
        field(13; "Field Filter"; Boolean)
        {


            CaptionML = ENU = 'Field Filter', ESP = 'Campo Filtro';

            trigger OnValidate();
            VAR
                //                                                                 i@1100286000 :
                i: Integer;
                //                                                                 v@1100286001 :
                v: Text;
                //                                                                 vLetters@1100286002 :
                vLetters: Text;
            BEGIN

                TESTFIELD(Name);
                FOR i := 1 TO STRLEN(Name) DO BEGIN
                    v := UPPERCASE(COPYSTR(Name, i, 1));
                    vLetters := '�������������녊���';
                    IF STRPOS(vLetters, v) <> 0 THEN
                        ERROR(TEXT006, vLetters);
                END;
            END;


        }
        field(14; "Field Group"; Boolean)
        {
            CaptionML = ESP = 'Campo agrupaci�n';


        }
        field(15; "Type Field Sharepoint"; Option)
        {
            OptionMembers = "Metadata administrado","Short Date","Number","Currency","Text Line","Boolean";
            CaptionML = ENU = 'Type Field Sharepoint', ESP = 'Tipo de campo Sharepoint';
            OptionCaptionML = ENU = 'Metadata administrado,Short Date,Number,Currency,Text Line,Boolean', ESP = 'Metadato administrado,Fecha formato corto,N�mero,Moneda,L�nea de texto,Booleano';

            Description = '16.05.18';


        }
    }
    keys
    {
        key(key1; "Metadata Site Definition", "Line No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       TEXT000@1100286000 :
        TEXT000: TextConst ENU = 'Error, process not supported.', ESP = 'Error, proceso no soportado.';
        //       TEXT001@1000000001 :
        TEXT001: TextConst ENU = 'Error, no blanks or the following special characters are allowed ;/():?�*`�[]{}\�!""�$%&/', ESP = 'Error, no se permiten espacios en blanco ni los siguientes car�cteres especiales  ;/():?�*`�[]{}\�!""�$%&/';
        //       TEXT002@1000000002 :
        TEXT002: TextConst ENU = 'The metadata schema will be opened and then it will need to be checked again. �Do you wish to continue?', ESP = 'Se abrir� el esquema de los metadatos y despues ser� necesario volver a comprobarlo. �Desea continuar?';
        //       TEXT003@1000000003 :
        TEXT003: TextConst ENU = 'Operation canceled by the user.', ESP = 'Operaci�n cancelada por el usuario.';
        //       TEXTWORDRESERVE@1100286001 :
        TEXTWORDRESERVE: TextConst ENU = 'Name,Type,Description', ESP = 'Name,Type,Description';
        //       TEXT004@1100286002 :
        TEXT004: TextConst ENU = 'It is not possible to use the following words reserved %1.', ESP = 'Error, no es posible utilizar las siguientes palabras reservadas %1.';
        //       TEXT005@1100286003 :
        TEXT005: TextConst ENU = 'Error, it is not possible to repeat the name of the column.', ESP = 'Error, no es posible repetir el nombre interno en Sharepoint.';
        //       TEXT006@1100286005 :
        TEXT006: TextConst ENU = 'Error, filter fields can not have the following characters: %1', ESP = 'Error, los campos filtro no pueden tener los siguientes car�cteres: %1';
        //       TEXTERROR@1000000000 :
        TEXTERROR: TextConst ENU = ' ;/():?�*`�[]{}\�!""�$%&/�������������녊���.,=', ESP = ' ;/():?�*`�[]{}\�!""�$%&/�������������녊���.,=';
        //       NoSerieMgt@1100286004 :
        NoSerieMgt: Codeunit "NoSeriesManagement";
        //       TEXTLETTERS@1100286006 :
        TEXTLETTERS: TextConst ENU = '�������������녊���', ESP = '�������������녊���';



    trigger OnInsert();
    var
        //                DragDropSPSetup@1100286000 :
        DragDropSPSetup: Record 7174650;
    begin

        DragDropSPSetup.GET();
        DragDropSPSetup.TESTFIELD("Serie No. Internal Name");

        //17160.CPA 25-05-22. begin
        if "Internal Name" = '' then
            "Internal Name" := NoSerieMgt.GetNextNo(DragDropSPSetup."Serie No. Internal Name", TODAY, TRUE);
        //17160.CPA 25-05-22. end
        FncChgCheck;
    end;

    trigger OnModify();
    begin

        FncChgCheck;
    end;

    trigger OnDelete();
    begin
        FncChgCheck;
    end;

    trigger OnRename();
    begin

        ERROR(TEXT000);
    end;



    LOCAL procedure FncChgCheck()
    var
        //       rShrSiteDefs@1100286000 :
        rShrSiteDefs: Record 7174651;
    begin

        rShrSiteDefs.RESET;
        rShrSiteDefs.SETRANGE("No.", "Metadata Site Definition");
        if rShrSiteDefs.FINDFIRST then begin
            if rShrSiteDefs.Status = rShrSiteDefs.Status::Released then
                if not CONFIRM(TEXT002, TRUE) then
                    ERROR(TEXT003);
            rShrSiteDefs.VALIDATE(Status, rShrSiteDefs.Status::Open);
            rShrSiteDefs.MODIFY;
        end;
    end;

    //     LOCAL procedure FncCheckName (pNoDef@1100286001 : Code[20];pName@1000000000 :
    LOCAL procedure FncCheckName(pNoDef: Code[20]; pName: Text)
    var
        //       SiteSPMetadataDefs@1100286000 :
        SiteSPMetadataDefs: Record 7174652;
        //       i@1100286002 :
        i: Integer;
        //       v@1100286003 :
        v: Text;
        //       vLetters@1100286004 :
        vLetters: Text;
    begin


        FOR i := 1 TO STRLEN(pName) DO begin
            v := UPPERCASE(COPYSTR(pName, i, 1));
            vLetters := FORMAT(TEXTERROR);
            if STRPOS(vLetters, v) <> 0 then
                ERROR(TEXT006, TEXTERROR);
        end;


        ///Comprobar que no se repite el mmismo nombre de columna columna.
        SiteSPMetadataDefs.RESET;
        SiteSPMetadataDefs.SETRANGE("Metadata Site Definition", pNoDef);
        SiteSPMetadataDefs.SETRANGE(Name, pName);
        if SiteSPMetadataDefs.COUNT >= 2 then
            ERROR(TEXT005);
    end;

    //     LOCAL procedure FncCheckInternalName (pNoDef@1100286002 : Code[20];pName@1100286000 :
    LOCAL procedure FncCheckInternalName(pNoDef: Code[20]; pName: Text)
    var
        //       SiteSPMetadataDefs@1100286001 :
        SiteSPMetadataDefs: Record 7174652;
        //       NameNew@1100286004 :
        NameNew: Text;
        //       IntLong@1100286003 :
        IntLong: Integer;
        //       LibraryTypesSP@1100286005 :
        LibraryTypesSP: Record 7174654;
        //       SiteSPDef@1100286006 :
        SiteSPDef: Record 7174651;
        //       MainURL@1100286007 :
        MainURL: Text[250];
    begin

        if pName = '' then
            exit;

        IntLong := STRLEN(pName);
        NameNew := DELCHR(pName, '=', TEXTERROR);

        if IntLong <> STRLEN(NameNew) then
            ERROR(TEXT001);

        if STRPOS(UPPERCASE(pName), UPPERCASE(TEXTWORDRESERVE)) <> 0 then
            ERROR(TEXT004, TEXTWORDRESERVE);

        ///Comprobar que no se repite el mismo nombre de columna en cualquiera de las definiciones
        SiteSPMetadataDefs.RESET;
        //SiteSPMetadataDefs.SETRANGE("Metadata Site Definition",pNoDef);
        SiteSPMetadataDefs.SETRANGE("Internal Name", pName);

        //17160. CPA 25-05-22.begin Se permite que el nombre sea el mismo cuando los dos Sitedef's apuntan a la misma URL
        //if SiteSPMetadataDefs.COUNT >= 1 then
        //  ERROR(TEXT005);
        if SiteSPMetadataDefs.FINDSET then begin
            SiteSPDef.GET(pNoDef);
            MainURL := SiteSPDef."Main Url";
            repeat
                SiteSPDef.GET(SiteSPMetadataDefs."Metadata Site Definition");
                if SiteSPDef."Main Url" <> MainURL then
                    ERROR(TEXT005);
            until SiteSPMetadataDefs.NEXT = 0;
        end;
        //17160.CPA 25-05-22.end



        LibraryTypesSP.RESET;
        //LibraryTypesSP.SETRANGE("Metadata Site Defs",pNoDef);
        LibraryTypesSP.SETRANGE("Internal Name", pName);
        if LibraryTypesSP.COUNT >= 1 then
            ERROR(TEXT005);
    end;

    /*begin
    //{
//      QUONEXT 20.07.17 DRAG&DROP. Definici�n de los metadatos del site de Sharepoint donde se subiran los ficheros.
//
//      17160 CPA 25-05-22. Factboxes en Facturas de compra y venta
//    }
    end.
  */
}







