table 7174651 "Site Sharepoint Definition"
{


    CaptionML = ENU = 'Site Sharepoint Definition', ESP = 'Defs. sitio Sharepoint';

    fields
    {
        field(1; "No."; Code[20])
        {


            CaptionML = ENU = 'No.', ESP = 'No.';

            trigger OnValidate();
            BEGIN
                IF "No." <> xRec."No." THEN BEGIN
                    ShptSetup.GET;
                    NoSeriesMgt.TestManual(ShptSetup."Def. Sharepoint Nos.");
                    "No. Series" := '';
                END;
            END;


        }
        field(2; "IdTable"; Integer)
        {
            TableRelation = AllObjWithCaption."Object ID" WHERE("Object Type" = FILTER("Table"));
            CaptionML = ENU = 'Id. Table', ESP = 'Id. tabla';


        }
        field(3; "Library Title"; Text[50])
        {


            CaptionML = ENU = 'Name', ESP = 'T�tulo librer�a';

            trigger OnValidate();
            VAR
                //                                                                 IntNoField@1000000000 :
                IntNoField: Integer;
            BEGIN

                IF "Library Title Type" = "Library Title Type"::"Without Library SP" THEN
                    TESTFIELD("Library Title", '');

                IF "Library Title Type" <> "Library Title Type"::"Field Value" THEN
                    EXIT;

                ///En el caso que se configure un campo de una tabla se indica su nombre.
                EVALUATE(IntNoField, "Library Title");

                rField.RESET;
                rField.SETRANGE(TableNo, IdTable);
                rField.SETRANGE("No.", IntNoField);
                rField.FINDFIRST;
                "Field Name Title" := rField."Field Caption";
            END;

            trigger OnLookup();
            BEGIN

                IF "Library Title Type" <> "Library Title Type"::"Field Value" THEN
                    EXIT;

                ///En el caso que se configure un campo de una tabla se indica su nombre.
                rField.RESET;
                rField.SETRANGE(TableNo, IdTable);
                IF rField.FINDFIRST THEN;
                IF PAGE.RUNMODAL(PAGE::"Fields NAV", rField) = ACTION::LookupOK THEN BEGIN
                    "Library Title" := FORMAT(rField."No.");
                    "Field Name Title" := rField."Field Caption";
                END;
            END;


        }
        field(4; "Name Site Sharepoint"; Text[50])
        {
            CaptionML = ENU = 'Value', ESP = 'Nombre sitio Sharepoint';


        }
        field(7; "Main Url"; Text[250])
        {
            CaptionML = ENU = 'Relative Url', ESP = 'Url principal';


        }
        field(8; "Check Site"; Boolean)
        {
            CaptionML = ENU = 'Check Site', ESP = 'Comprobar Sitio';


        }
        field(9; "Check Library"; Boolean)
        {
            CaptionML = ENU = 'Check Library', ESP = 'Comprobar Librer�a';


        }
        field(10; "Check Metadata"; Boolean)
        {
            CaptionML = ENU = 'Check Metadata', ESP = 'Comprobar Metadatos';


        }
        field(11; "Description"; Text[50])
        {


            CaptionML = ESP = 'Descripci�n';

            trigger OnValidate();
            BEGIN
                ///Descripci�n informativa no se utiliza en la integraci�.
            END;


        }
        field(12; "Last Date Modified"; DateTime)
        {
            CaptionML = ESP = 'Fecha �lt. Modificaci�n';


        }
        field(13; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'No. Series', ESP = 'Nos. serie';
            Description = 'JAV 08/09/21: - QB 1.09.17 Se aumenta a 20 las longitudes de los contadores';


        }
        field(14; "Name Table"; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup(AllObjWithCaption."Object Name" WHERE("Object Type" = FILTER("Table"),
                                                                                         "Object ID" = FIELD("IdTable")));
            CaptionML = ENU = 'Name Table', ESP = 'Nombre tabla';
            Editable = false;


        }
        field(15; "Status"; Option)
        {
            OptionMembers = "Open","Released";
            CaptionML = ENU = 'Status', ESP = 'Estado';
            OptionCaptionML = ENU = 'Open,Released', ESP = 'Abierto,Lanzado';



        }
        field(16; "Library Title Type"; Option)
        {
            OptionMembers = "Field Value","Fixed Value","Without Library SP";

            CaptionML = ENU = 'Name', ESP = 'Tipo T�tulo librer�a';
            OptionCaptionML = ENU = 'Field Value,Fixed Value,Without Library SP', ESP = 'Campo,Valor fijo,Sin librer�a asociada';


            trigger OnValidate();
            BEGIN

                IF "Library Title Type" <> xRec."Library Title Type" THEN BEGIN
                    "Field Name Title" := '';
                    "Library Title" := '';
                END;
            END;


        }
        field(17; "Field Name Title"; Text[50])
        {
            CaptionML = ENU = 'Field Name Title', ESP = 'Nombre campo T�tulo';
            Editable = false;


        }
        field(18; "Sharepoint folder Path"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'CPA 17/06/22 - Q17567';


        }
        field(50000; "Job Card Type"; Option)
        {
            OptionMembers = " ","Study","Operative Job";

            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Job Card Type', ESP = 'Tipo ficha proyecto';
            OptionCaptionML = ENU = '" ,Study,Operative Job"', ESP = '" ,Estudio,Proyecto operativo"';

            Description = 'Q7357';

            trigger OnValidate();
            BEGIN
                IF "Job Card Type" <> "Job Card Type"::" " THEN
                    TESTFIELD(IdTable, DATABASE::Job);
            END;


        }
    }
    keys
    {
        key(key1; "No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "No.", "Name Site Sharepoint")
        {

        }
    }

    var
        //       NoSeriesMgt@1100286000 :
        NoSeriesMgt: Codeunit "NoSeriesManagement";
        //       ShptSetup@1100286001 :
        ShptSetup: Record 7174650;
        //       TEXT000@1000000003 :
        TEXT000: TextConst ENU = 'Operation not allowed.', ESP = 'Operaci�n no permitida.';
        //       TEXT001@1000000000 :
        TEXT001: TextConst ENU = 'The existence of the Sharepoint site and associated metadata has been verified', ESP = 'Comprobada la existencia del sitio de Sharepoint y los metadatos asociados.';
        //       TEXT002@1000000001 :
        TEXT002: TextConst ENU = 'Error, missing data.', ESP = 'Error, faltan datos.';
        //       rField@1000000002 :
        rField: Record 2000000041;
        //       TEXT003@1100286002 :
        TEXT003: TextConst ENU = 'Error, you must enter a field as a filter.', ESP = 'Error, debe indicar un campo como filtro.';



    trigger OnInsert();
    begin
        InitInsert;

        "Last Date Modified" := CREATEDATETIME(TODAY, TIME);
    end;

    trigger OnModify();
    begin

        TESTFIELD(Status, Status::Open);

        "Last Date Modified" := CREATEDATETIME(TODAY, TIME);
    end;

    trigger OnDelete();
    var
        //                SiteSPMetadataDefs@1100286000 :
        SiteSPMetadataDefs: Record 7174652;
        //                LibraryTypesSP@1100286001 :
        LibraryTypesSP: Record 7174654;
        //                HistorySitesSP@1100286002 :
        HistorySitesSP: Record 7174656;
        //                DragDropFile@1100286003 :
        DragDropFile: Record 7174653;
    begin

        TESTFIELD(Status, Status::Open);

        SiteSPMetadataDefs.RESET;
        SiteSPMetadataDefs.SETRANGE("Metadata Site Definition", "No.");
        if SiteSPMetadataDefs.FINDSET then
            SiteSPMetadataDefs.DELETEALL(TRUE);

        LibraryTypesSP.RESET;
        LibraryTypesSP.SETRANGE("Metadata Site Defs", "No.");
        if LibraryTypesSP.FINDSET then
            LibraryTypesSP.DELETEALL(TRUE);

        HistorySitesSP.RESET;
        HistorySitesSP.SETRANGE("Metadata Site Definition", "No.");
        if HistorySitesSP.FINDSET then
            HistorySitesSP.DELETEALL(TRUE);

        DragDropFile.RESET;
        DragDropFile.SETRANGE("Sharepoint Site Definition", "No.");
        if DragDropFile.FINDSET then
            DragDropFile.DELETEALL(TRUE);
    end;

    trigger OnRename();
    begin
        ERROR(TEXT000);
    end;



    procedure InitInsert()
    begin

        if "No." = '' then begin
            ShptSetup.GET;
            ShptSetup.TESTFIELD("Def. Sharepoint Nos.");
            NoSeriesMgt.InitSeries(ShptSetup."Def. Sharepoint Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        end;
    end;

    //     procedure AssistEdit (OldShptSiteDef@1000 :
    procedure AssistEdit(OldShptSiteDef: Record 7174651): Boolean;
    begin
        /*To be Tested*/
        //WITH OldShptSiteDef DO begin
        OldShptSiteDef := Rec;
        ShptSetup.GET;
        ShptSetup.TESTFIELD("Def. Sharepoint Nos.");
        if NoSeriesMgt.SelectSeries(ShptSetup."Def. Sharepoint Nos.", OldShptSiteDef."No. Series", "No. Series") then begin
            NoSeriesMgt.SetSeries("No.");
            Rec := OldShptSiteDef;
            exit(TRUE);
        end;
        //end;
    end;

    //     procedure FncCheckMetadataSP (pNoMetadata@1000000001 :
    procedure FncCheckMetadataSP(pNoMetadata: Code[20])
    var
        //       SiteSPDf@1100286000 :
        SiteSPDf: Record 7174651;
        //       ShrpMetadataDefs@1000000000 :
        ShrpMetadataDefs: Record 7174652;
        //       DropAreaMgt@1000000002 :
        DropAreaMgt: Codeunit 7174650;
        //       vBigText@1000000003 :
        vBigText: BigText;
        //       pRecordId@1100286001 :
        pRecordId: RecordID;
        //       BoolExistFilter@1100286002 :
        BoolExistFilter: Boolean;
        //       I@1100286003 :
        I: Integer;
    begin
        ///Proceso que se llama desde la cabecera del documento del site.

        SiteSPDf.GET(pNoMetadata);

        if SiteSPDf."Library Title Type" <> SiteSPDf."Library Title Type"::"Without Library SP" then
            SiteSPDf.TESTFIELD("Library Title");
        SiteSPDf.TESTFIELD(IdTable);
        SiteSPDf.TESTFIELD("Name Site Sharepoint");
        SiteSPDf.TESTFIELD("Main Url");

        ///Revisi�n de los datos.
        BoolExistFilter := FALSE;

        ShrpMetadataDefs.RESET;
        ShrpMetadataDefs.SETRANGE("Metadata Site Definition", pNoMetadata);
        if ShrpMetadataDefs.FINDSET then
            repeat
                if (ShrpMetadataDefs.Name = '') or
                   (ShrpMetadataDefs.Value = '') or
                   (ShrpMetadataDefs."Internal Name" = '') then
                    ERROR(TEXT002);
                if (ShrpMetadataDefs."Field Filter") then
                    BoolExistFilter := TRUE;

                ShrpMetadataDefs.Check := TRUE;
                ShrpMetadataDefs.MODIFY(FALSE);
            until ShrpMetadataDefs.NEXT = 0;

        if not BoolExistFilter then
            ERROR(TEXT003);

        ///Creaci�n del site y de los metadatos asociados, si no se configura un campo en la cabecera se crea un site con el valor
        ///del campo c�digo
        FOR I := 1 TO 2 DO begin
            CLEAR(DropAreaMgt);
            CLEAR(vBigText);
            DropAreaMgt.FileDropBegin('Test.txt');
            DropAreaMgt.FileDrop('cHJ1ZWJh');
            DropAreaMgt.CreateMetadata(pNoMetadata, vBigText, TRUE);
            DropAreaMgt.FileDropEnd(DropAreaMgt.FncGetTitle(SiteSPDf."Library Title"), pNoMetadata, vBigText, pRecordId);
        end;

        Status := Status::Released;
        MODIFY(FALSE);
    end;

    /*begin
    //{
//      QUONEXT 20.07.17 DRAG&DROP. Definici�n de los datos b�sicos del site de Sharepoint donde se subiran los ficheros.
//      JAV 15/09/21: - Se amplia el contador de 10 a 20 caracteres
//      CPA 17/06/22 - Q17567 A�adir configuraci�n en la definici�n de los sitios para permitir carpetas
//    }
    end.
  */
}







