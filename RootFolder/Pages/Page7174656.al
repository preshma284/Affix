page 7174656 "Files in Sharepoint"
{
    Permissions = TableData 7174653 = r;
    CaptionML = ENU = 'Files in Sharepoint', ESP = 'Archivos en Sharepoint';
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    SourceTable = 7174657;
    PageType = ListPart;
    layout
    {
        area(content)
        {
            repeater("Repeater")
            {

                field("File Name"; rec."File Name")
                {

                    Style = Strong;
                    StyleExpr = TRUE;

                    ; trigger OnLookup(var Text: Text): Boolean
                    BEGIN
                        HYPERLINK(Url);
                    END;

                    trigger OnDrillDown()
                    BEGIN
                        HYPERLINK(Url);
                    END;


                }
                field("Filter"; rec."Filter")
                {

                    Visible = false

  ;
                }

            }

        }
    }
    actions
    {
        area(Processing)
        {

            action("Traer documentos")
            {

                CaptionML = ENU = 'Get Files', ESP = 'Traer documentos';
                Promoted = true;
                PromotedIsBig = true;
                Image = GetEntries;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                VAR
                    Selection: Integer;
                BEGIN

                    Selection := STRMENU(Text000, 1);

                    IF Selection = 1 THEN
                        FncGetData(FALSE, FALSE)
                    ELSE IF Selection = 2 THEN
                        FncGetData(FALSE, TRUE);
                END;


            }
            action("Abrir SP")
            {

                CaptionML = ENU = 'Open Site Sharepoint', ESP = 'Abrir SP';
                Promoted = true;
                PromotedIsBig = true;
                Image = OpenWorksheet;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                BEGIN

                    FncGetData(TRUE, FALSE)
                END;


            }
            action("Descargar documentos")
            {

                CaptionML = ENU = 'Get Files', ESP = 'Traer documentos';
                Promoted = true;
                PromotedIsBig = true;
                Image = GetEntries;
                PromotedCategory = Process;
                PromotedOnly = true;


                trigger OnAction()
                VAR
                    Selection: Integer;
                BEGIN

                    FncDownloadData(TRUE, FALSE)
                END;


            }

        }
    }

    var
        fileName: Text[250];
        url: Text[1024];
        // SharepointAddIn: DotNet "'SharepointAddIn, Version=2.0.0.5, Culture=neutral, PublicKeyToken=null'.SharepointAddIn.SharepointAddIn";
        libraryTitle: Text[250];
        cduDropArea: Codeunit 7174650;
        vVariant: Variant;
        pRecordID: RecordID;
        Text000: TextConst ENU = 'Collect documents associated with the record,Collect all documents', ESP = 'Traer documentos asociados al registro,Traer todos los documentos';
        FileDownloaded: BigText;

    procedure SETFILTER(pVar: Variant);
    var
        xRecRefV1: RecordRef;
        xRecRef: RecordRef;
        RECREF: RecordRef;
    begin
        ///Se debe enviar siempre la variable Rec de la pagina que vamos a configurar.
        vVariant := pVar;

        if pVar.ISRECORD then
            xRecRef.GETTABLE(pVar)
        ELSE
            xRecRef := pVar;

        if xRecRef.ISTEMPORARY then
            exit;

        RECREF.OPEN(xRecRef.NUMBER);
        if RECREF.READPERMISSION then begin
            if not RECREF.GET(xRecRef.RECORDID) then
                exit;
        end;

        Rec.SETRANGE("PK RecordID", RECREF.RECORDID);
        ///Rec.DELETEALL;
        CurrPage.UPDATE(FALSE);
    end;

    LOCAL procedure FncGetData(pOpenSP: Boolean; pAll: Boolean);
    var
        XDropAreaFile: Record 7174657 TEMPORARY;
        SpSiteDef: Record 7174651;
        SPSetup: Record 7174650;
        xRecRef: RecordRef;
        RecRef: RecordRef;
        SiteLibrary: Text;
        TxtLink: Text;
        vNoEntry: Integer;
        Job: Record 167;
    begin

        //Se recoge la informaci�n y se muestra el site de sharepoint o rellena el factbox con los ficheros de la libreria SP.
        //Esta funcion se llama desde las opciones.
        SPSetup.GET;
        SPSetup.TESTFIELD("Enable Integration", TRUE);

        if vVariant.ISRECORD then
            xRecRef.GETTABLE(vVariant)
        ELSE
            xRecRef := vVariant;

        if xRecRef.ISTEMPORARY then
            exit;

        RecRef.OPEN(xRecRef.NUMBER);
        if RecRef.READPERMISSION then begin
            if not RecRef.GET(xRecRef.RECORDID) then
                exit;
        end;

        pRecordID := RecRef.RECORDID;


        SpSiteDef.RESET;
        SpSiteDef.SETRANGE(IdTable, xRecRef.NUMBER);
        SpSiteDef.SETRANGE(Status, SpSiteDef.Status::Released);
        //Q7357 -
        if RecRef.NUMBER = DATABASE::Job then begin
            Job.GET(pRecordID);
            SpSiteDef.SETRANGE("Job Card Type", Job."Card Type");
        end;
        //Q7357 +
        SpSiteDef.FINDFIRST;

        SiteLibrary := cduDropArea.GetTitleLibrary(SpSiteDef."No.", RecRef);

        //Se abre el site de SP.
        if pOpenSP then begin

            if SiteLibrary = '' then
                SiteLibrary := SPSetup."Library Name Default";

            TxtLink := SPSetup."Url Sharepoint" + '/' + SpSiteDef."Main Url" + '/' + SiteLibrary + '/Forms/AllItems.aspx';
            HYPERLINK(TxtLink);
            exit;
        end;

        if SPSetup."Batch Synchronization" then begin
            cduDropArea.GetFilesBatch(SpSiteDef);
            exit;
        end;

        //Recogemos los ficheros y lo indicamos en el factbox.
        CLEAR(XDropAreaFile);
        if not pAll then begin
            cduDropArea.FncGetFiles(SpSiteDef."No.", XDropAreaFile, SiteLibrary, pRecordID, FALSE)
        end ELSE begin
            cduDropArea.FncGetFiles(SpSiteDef."No.", XDropAreaFile, SiteLibrary, pRecordID, TRUE);
        end;

        XDropAreaFile.RESET;
        if XDropAreaFile.FINDSET then
            repeat
                vNoEntry := 1;
                if Rec.FINDLAST then
                    vNoEntry := rec."Entry No." + 1;

                Rec.INIT;
                Rec.TRANSFERFIELDS(XDropAreaFile);
                Rec.INSERT;
            until XDropAreaFile.NEXT = 0;
    end;

    procedure FncGetAllDataOpenPage(pNoTable: Integer);
    var
        SpSiteDef: Record 7174651;
    begin
        SpSiteDef.RESET;
        SpSiteDef.SETRANGE(IdTable, pNoTable);
        SpSiteDef.SETRANGE(Status, SpSiteDef.Status::Released);
        if SpSiteDef.FINDFIRST then
            cduDropArea.GetFilesBatch(SpSiteDef);
    end;

    procedure FncGetAllDataOpenPageCT(pNoTable: Integer);
    var
        SpSiteDef: Record 7174651;
    begin
        SpSiteDef.RESET;
        SpSiteDef.SETRANGE(IdTable, pNoTable);
        SpSiteDef.SETRANGE(Status, SpSiteDef.Status::Released);
        if pNoTable = 167 then
            SpSiteDef.SETRANGE("Job Card Type", SpSiteDef."Job Card Type"::Study);
        if SpSiteDef.FINDFIRST then
            cduDropArea.GetFilesBatch(SpSiteDef);
    end;

    procedure FncGetAllDataOpenPageCTOJ(pNoTable: Integer);
    var
        SpSiteDef: Record 7174651;
    begin
        SpSiteDef.RESET;
        SpSiteDef.SETRANGE(IdTable, pNoTable);
        SpSiteDef.SETRANGE(Status, SpSiteDef.Status::Released);
        if pNoTable = 167 then
            SpSiteDef.SETRANGE("Job Card Type", SpSiteDef."Job Card Type"::"Operative Job");
        if SpSiteDef.FINDFIRST then
            cduDropArea.GetFilesBatch(SpSiteDef);
    end;

    LOCAL procedure FncDownloadData(pOpenSP: Boolean; pAll: Boolean);
    var
        XDropAreaFile: Record 7174657 TEMPORARY;
        SpSiteDef: Record 7174651;
        SPSetup: Record 7174650;
        xRecRef: RecordRef;
        RecRef: RecordRef;
        SiteLibrary: Text;
        TxtLink: Text;
        vNoEntry: Integer;
    begin
        /*{
        //Se recoge la informaci�n y se muestra el site de sharepoint o rellena el factbox con los ficheros de la libreria SP.
        //Esta funcion se llama desde las opciones.
        SPSetup.GET;
        SPSetup.TESTFIELD("Enable Integration",TRUE);

        if vVariant.ISRECORD then
          xRecRef.GETTABLE(vVariant)
        ELSE
          xRecRef := vVariant;

        if xRecRef.ISTEMPORARY then
          exit;

        RecRef.OPEN(xRecRef.NUMBER);
        if RecRef.READPERMISSION then begin
          if not RecRef.GET(rec.xRecRef.RECORDID) then
            exit;
        end;

        pRecordID := RecRef.RECORDID;


        SpSiteDef.RESET;
        SpSiteDef.SETRANGE(IdTable,xRecRef.NUMBER);
        SpSiteDef.SETRANGE(Status,SpSiteDef.Status::Released);
        SpSiteDef.FINDFIRST;

        SiteLibrary := cduDropArea.GetTitleLibrary(SpSiteDef."No.",RecRef);

        //Se abre el site de SP.
        if pOpenSP then begin

          if SiteLibrary = '' then
            SiteLibrary := SPSetup."Library Name Default";

          TxtLink := SPSetup."Url Sharepoint" + '/' + SpSiteDef."Main Url" +'/' + SiteLibrary + '/Forms/AllItems.aspx';

          SharepointAddIn.BajarArchivo(SPSetup."Url Sharepoint",SPSetup.User,SPSetup.Pass,FORMAT(SPSetup."Debug Level"),SpSiteDef."Main Url",SiteLibrary,"File Name",FileDownloaded);

        {
        string siteUrlP, string userP, string passP, string debugLevelP, string relativeUrl, string libraryTitle, string filename, ref string b64Str)
            dicc := SharepointAddIn.GetFilesList(SPSetup."Url Sharepoint", SPSetup.User,
                                      SPSetup.Pass, SiteSpDefinition."Main Url",
                                      vSiteName, metadataFiltered);

            SharepointAddIn.GetFilesList(string siteUrlP, string userP, string passP, string relativeUrl, string libraryTitle, string filtersList)




        }

          exit;
        end;
        }*/
    end;

    // begin
    /*{
      QUONEXT 20.07.17 DRAG&DROP. Factbox para mostrar y acceder a los ficheros subidos a un determinado site
      Q7357 JDC 13/11/19 - Modified function "FncGetData"
            FGZ 28/04/2020 - Se modifica la funci�n FncGetAllDataOpenPage y se divide en las 3 siguientes:
                FncGetAllDataOpenPage(pNoTable : Integer) = para todas las tablas diferentes de la 167
                FncGetAllDataOpenPageCT(pNoTable : Integer) = para la tabla 167 cuando el Card type = Study
                FncGetAllDataOpenPageCTOJ(pNoTable : Integer) = para la tabla 167 cuando el Card type = Operative Job
                (soluciona que se muestre en las pages correspondientes al entrar, antes cog�a el primer sitio configurado)
      17160 CPA 25-05-22. Factboxes de D&D en factura compra y venta
    }*///end
}








