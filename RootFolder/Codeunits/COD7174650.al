Codeunit 7174650 "Drop Area Management"
{


    Permissions = TableData 7174653 = ri;
    trigger OnRun()
    BEGIN
    END;

    VAR
        ReadAsDataUrlHeader: TextConst ENU = 'data:';
        ProgressText: TextConst ENU = 'File upload in progress...\#1########################################\@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@';
        CurrentFilename: Text;
        FromMemoryStream: DotNet MemoryStream;
        FileDropInProgress: Boolean;
        TEXTOK: TextConst ENU = 'Subida de Ficheros terminada', ESP = 'Subida de Ficheros terminada';

    PROCEDURE FromBase64Transform(VAR SourceMemoryStream: DotNet MemoryStream; VAR DestinationMemoryStream: DotNet MemoryStream): Integer;
    VAR
        FromBase64Transform: DotNet FromBase64Transform;
        FromBase64TransformMode: DotNet FromBase64TransformMode;
        InputBuffer: DotNet Array;
        OutputBuffer: DotNet Array;
        Byte: DotNet Byte;
        BytesRead: Integer;
        BytesWritten: Integer;
        InputLength: Integer;
        LibraryTypesSP: Record 7174654;
    BEGIN
        //Transforma ficheros a base 64
        FromBase64Transform := FromBase64Transform.FromBase64Transform(FromBase64TransformMode.IgnoreWhiteSpaces);

        OutputBuffer := OutputBuffer.CreateInstance(GETDOTNETTYPE(Byte), FromBase64Transform.OutputBlockSize);
        InputBuffer := SourceMemoryStream.GetBuffer();

        BytesRead := 0;
        InputLength := SourceMemoryStream.Length();

        WHILE ((InputLength - BytesRead) > 4) DO BEGIN
            BytesWritten := FromBase64Transform.TransformBlock(InputBuffer, BytesRead, 4, OutputBuffer, 0);
            BytesRead += 4;
            DestinationMemoryStream.Write(OutputBuffer, 0, BytesWritten);
        END;

        OutputBuffer := FromBase64Transform.TransformFinalBlock(InputBuffer, BytesRead, InputLength - BytesRead);
        DestinationMemoryStream.Write(OutputBuffer, 0, OutputBuffer.Length);

        FromBase64Transform.Clear();
    END;

    PROCEDURE Base64Decode(VAR SourceMemoryStream: DotNet MemoryStream; VAR DestinationMemoryStream: DotNet MemoryStream): Integer;
    VAR
        Buffer: DotNet Array;
        Convert: DotNet Convert;
        Encoding: DotNet Encoding;
        String: DotNet String;
        InputLength: Integer;
    BEGIN
        Encoding := Encoding.Default;
        Buffer := SourceMemoryStream.GetBuffer();

        InputLength := SourceMemoryStream.Length;
        String := Encoding.GetString(Buffer, 0, InputLength);

        Buffer := Convert.FromBase64String(String);

        InputLength := Buffer.Length;
        DestinationMemoryStream.Write(Buffer, 0, InputLength);
    END;

    PROCEDURE FileDropBegin(Filename: Text);
    BEGIN
        FileDropInProgress := TRUE;
        CurrentFilename := Filename;
        FromMemoryStream := FromMemoryStream.MemoryStream();
    END;

    PROCEDURE FileDrop(Data: Text);
    VAR
        Encoding: DotNet Encoding;
    BEGIN

        IF STRPOS(Data, ReadAsDataUrlHeader) <> 0 THEN
            Data := COPYSTR(Data, STRPOS(Data, ',') + 1);

        Encoding := Encoding.Default;
        FromMemoryStream.Write(Encoding.GetBytes(Data), 0, STRLEN(Data));
    END;

    PROCEDURE FileDropEnd(libraryTitle: Text[250]; metadataID: Code[20]; dicc: BigText; pRecordID: RecordID);
    VAR
        ToMemoryStream: DotNet MemoryStream;
        FileStream: DotNet FileStream;
        FileMode: DotNet FileMode;
        FileAccess: DotNet FileAccess;
        DropAreaFile: Record 7174653;
        DragDropSPSetup: Record 7174650;
        SharepointSiteMetadataDefs: Record 7174651;
        SharepointTableDefinition: Record 7174652;
        OStream: OutStream;
        OStreamDic: OutStream;
        dict: DotNet Dictionary_Of_T_U;
        Arr: DotNet Array;
        Type: DotNet Type;
        Activator: DotNet Activator;
        String: DotNet String;
        TableList: DotNet ArrayList;
    BEGIN
        ///Proceso principal donde se rellena la tabla de log con la informacion suministrada.
        DragDropSPSetup.GET;
        DragDropSPSetup.TESTFIELD("Enable Integration", TRUE);

        ToMemoryStream := ToMemoryStream.MemoryStream();
        Base64Decode(FromMemoryStream, ToMemoryStream);

        ///Tabla con la informaci�n suministrada.
        DropAreaFile.INIT;
        DropAreaFile."File Name" := CurrentFilename;
        DropAreaFile."File Content".CREATEOUTSTREAM(OStream);
        ToMemoryStream.WriteTo(OStream);

        DropAreaFile."Dictionary SP".CREATEOUTSTREAM(OStreamDic);
        dicc.WRITE(OStreamDic);
        DropAreaFile."Sharepoint Site Definition" := metadataID;
        DropAreaFile."Creation Date" := CREATEDATETIME(TODAY, TIME);
        DropAreaFile.User := USERID;
        DropAreaFile."Library Title" := libraryTitle;
        DropAreaFile.INSERT(TRUE);


        FromMemoryStream.Close();

        FncCreatedSite(DropAreaFile, pRecordID);

        ///Dependiendo de la configuraci�n se realiza en batch (cola de proyectos) o online.
        IF NOT DragDropSPSetup."Batch Synchronization" THEN
            SendOnline(DropAreaFile, FALSE)
        ELSE
            SendBatch(DropAreaFile);

        FileDropInProgress := FALSE;

        CLEAR(dicc);
        CLEAR(OStream);
    END;

    PROCEDURE FileDropEndB2B(libraryTitle: Text[250]; metadataID: Code[20]; dicc: BigText; pRecordID: RecordID; B2BRouterInvAttachement: Record 7207318);
    VAR
        ToMemoryStream: DotNet MemoryStream;
        FileStream: DotNet FileStream;
        FileMode: DotNet FileMode;
        FileAccess: DotNet FileAccess;
        DropAreaFile: Record 7174653;
        DragDropSPSetup: Record 7174650;
        SharepointSiteMetadataDefs: Record 7174651;
        SharepointTableDefinition: Record 7174652;
        OStream: OutStream;
        OStreamDic: OutStream;
        dict: DotNet Dictionary_Of_T_U;
        Arr: DotNet Array;
        Type: DotNet Type;
        Activator: DotNet Activator;
        String: DotNet String;
        TableList: DotNet ArrayList;
    BEGIN
        ///Proceso principal donde se rellena la tabla de log con la informacion suministrada.
        DragDropSPSetup.GET;
        DragDropSPSetup.TESTFIELD("Enable Integration", TRUE);

        ToMemoryStream := ToMemoryStream.MemoryStream();
        Base64Decode(FromMemoryStream, ToMemoryStream);

        ///Tabla con la informaci�n suministrada.
        DropAreaFile.INIT;
        DropAreaFile."File Name" := CurrentFilename;
        B2BRouterInvAttachement.CALCFIELDS("Budget Amount");
        //DropAreaFile."File Content" := B2BRouterInvAttachement."Budget Amount";
        DropAreaFile."File Content".CREATEOUTSTREAM(OStream);
        ToMemoryStream.WriteTo(OStream);

        DropAreaFile."Dictionary SP".CREATEOUTSTREAM(OStreamDic);
        dicc.WRITE(OStreamDic);
        DropAreaFile."Sharepoint Site Definition" := metadataID;
        DropAreaFile."Creation Date" := CREATEDATETIME(TODAY, TIME);
        DropAreaFile.User := USERID;
        DropAreaFile."Library Title" := libraryTitle;
        DropAreaFile.INSERT(TRUE);


        FromMemoryStream.Close();

        FncCreatedSite(DropAreaFile, pRecordID);

        ///Dependiendo de la configuraci�n se realiza en batch (cola de proyectos) o online.
        IF NOT DragDropSPSetup."Batch Synchronization" THEN
            SendOnline(DropAreaFile, FALSE)
        ELSE
            SendBatch(DropAreaFile);

        FileDropInProgress := FALSE;

        CLEAR(dicc);
        CLEAR(OStream);
    END;

    PROCEDURE IsFileDropInProgress(): Boolean;
    BEGIN
        EXIT(FileDropInProgress);
    END;

    PROCEDURE GetCurrentFilename(): Text;
    BEGIN
        EXIT(CurrentFilename);
    END;

    PROCEDURE Download(DropAreaFile: Record 7174653);
    VAR
        FileMgt: Codeunit 419;
        TempBlob: codeunit "Temp Blob";
        Blob: OutStream;
        InStr: InStream;
    BEGIN
        IF NOT DropAreaFile."File Content".HASVALUE THEN
            EXIT;

        DropAreaFile.CALCFIELDS("File Content");
        //TempBlob.Blob := DropAreaFile."File Content";
        TempBlob.CreateOutStream(Blob, TextEncoding::Windows);
        Blob.Write(DropAreaFile."File Content");
        FileMgt.BLOBExport(TempBlob, DropAreaFile."File Name", TRUE);
    END;

    PROCEDURE fileUploadSP(fileName: Text; data: BigText);
    VAR
        //SharepointAddIn: DotNet SharepointAddIn;
    BEGIN
        MESSAGE('Filename: Option "+fileName +" - Data:' + FORMAT(data));
    END;

    PROCEDURE CreateMetadata(pNoMetadata: Code[20]; VAR pDicc: BigText; pBoolTesting: Boolean);
    VAR
        SPMetadataDefs: Record 7174652;
        LibraryTypesSP: Record 7174654;
        LibraryTypesValuesSP: Record 7174655;
        TxtValue: Text[250];
        IntNumberOpt: Integer;
    BEGIN
        //Se utiliza al configurar el site, envia los datos b�sicos para generar la estructura. Utiliza un diccionario de datos con 3 elementos
        SPMetadataDefs.RESET;
        SPMetadataDefs.SETRANGE("Metadata Site Definition", pNoMetadata);
        IF SPMetadataDefs.FINDSET THEN
            REPEAT
                IntNumberOpt := SPMetadataDefs."Type Field Sharepoint";
                TxtValue := SPMetadataDefs.Value;
                IF SPMetadataDefs."Type Field Sharepoint" =
                  SPMetadataDefs."Type Field Sharepoint"::"Short Date" THEN
                    TxtValue := FORMAT(TODAY, 0, '<Month,2>/<Day,2>/<Year4>');
                pDicc.ADDTEXT('[{' + SPMetadataDefs."Internal Name" + '},{' + SPMetadataDefs.Name + '},{' + TxtValue + '},{' + FORMAT(IntNumberOpt) + '}]|');

            UNTIL SPMetadataDefs.NEXT = 0;

        LibraryTypesSP.RESET;
        LibraryTypesSP.SETRANGE("Metadata Site Defs", pNoMetadata);
        IF LibraryTypesSP.FINDSET THEN
            REPEAT

                TxtValue := '';
                LibraryTypesValuesSP.RESET;
                LibraryTypesValuesSP.SETRANGE("Metadata Site Defs", LibraryTypesSP."Metadata Site Defs");
                LibraryTypesValuesSP.SETRANGE(Name, LibraryTypesSP.Name);
                IF LibraryTypesValuesSP.FINDFIRST THEN
                    TxtValue := LibraryTypesValuesSP.Value;

                IF TxtValue <> '' THEN BEGIN
                    IntNumberOpt := LibraryTypesSP."Type Field Sharepoint";
                    IF LibraryTypesSP."Type Field Sharepoint" =
                      LibraryTypesSP."Type Field Sharepoint"::"Short Date" THEN
                        TxtValue := FORMAT(TODAY, 0, '<Month,2>/<Day,2>/<Year4>');
                    pDicc.ADDTEXT('[{' + LibraryTypesSP."Internal Name" + '},{' + LibraryTypesSP.Name + '},{' + TxtValue + '},{' + FORMAT(IntNumberOpt) + '}]|');

                END;


            UNTIL LibraryTypesSP.NEXT = 0;
        pDicc.ADDTEXT('|');
    END;

    LOCAL PROCEDURE SendBatch(VAR pDropAreaFile: Record 7174653);
    VAR
        JobQueueEntry: Record 472;
    BEGIN

        JobQueueEntry.INIT;
        //JobQueueEntry.ID := CREATEGUID;
        JobQueueEntry."Object Type to Run" := JobQueueEntry."Object Type to Run"::Codeunit;
        JobQueueEntry."Object ID to Run" := CODEUNIT::"Send File SP Batch";
        JobQueueEntry."Record ID to Process" := pDropAreaFile.RECORDID;
        JobQueueEntry."Job Queue Category Code" := 'SP';
        CODEUNIT.RUN(CODEUNIT::"Job Queue - Enqueue", JobQueueEntry);
    END;

    PROCEDURE SendOnline(VAR pDropAreaFile: Record 7174653; pBoolTesting: Boolean);
    VAR
        SPSetup: Record 7174650;
        IStream: InStream;
        ToMemoryStream: DotNet MemoryStream;
        resultAction: BigText;
        Bytes: DotNet Array;
        FileBigText: BigText;
        Convert: DotNet Convert;
        // SharepointAddIn: DotNet SharepointAddIn;
        SPSiteDef: Record 7174651;
        Dic: BigText;
        txtresult: Text;
        FieldGroup: Text[250];
        vResult: OutStream;
        vDicResult: BigText;
        Length: Integer;
    BEGIN

        pBoolTesting := TRUE;

        SPSetup.GET;
        SPSetup.TESTFIELD("Enable Integration", TRUE);

        pDropAreaFile."File Content".CREATEINSTREAM(IStream);
        ToMemoryStream := ToMemoryStream.MemoryStream;
        COPYSTREAM(ToMemoryStream, IStream);
        Bytes := ToMemoryStream.GetBuffer;
        FileBigText.ADDTEXT(Convert.ToBase64String(Bytes));
        ToMemoryStream.Close();

        pDropAreaFile."Dictionary SP".CREATEINSTREAM(IStream);
        Dic.READ(IStream);

        SPSiteDef.GET(pDropAreaFile."Sharepoint Site Definition");

        FieldGroup := FncFilterGroup(SPSiteDef."No.");

        ///ENVIO DEL FICHERO:

        // resultAction.ADDTEXT(
               //17160 CPA. 25-05-22.Begin
            //    SharepointAddIn.UploadFileToSharepointUnico(SPSetup."Url Sharepoint",
            //                                                SPSetup.User,
            //                                                SPSetup.Pass,
            //                                                FORMAT(SPSetup."Debug Level"),
            //                                                pBoolTesting,
            //                                                pBoolTesting,
            //                                                pBoolTesting,
            //                                                SPSiteDef."Main Url",
            //                                                FncGetTitle(pDropAreaFile."Library Title"),
            //                                                SPSiteDef."Name Site Sharepoint",
            //                                                FieldGroup,
            //                                                DELCHR(pDropAreaFile."File Name", '=', '%$&/"���?�'),
            //                                                FileBigText,
            //                                                Dic,
            //                                                //Q17567 CPA 17/06/22.Begin
            //                                                //''));
            //                                                SPSiteDef."Sharepoint folder Path"));
        //Q17567 CPA 17/06/22.End
        /*{
                     SharepointAddIn.UploadFileToSharepointUnico(SPSetup."Url Sharepoint",
                                                                 SPSetup.User,
                                                                 SPSetup.Pass,
                                                                 FORMAT(SPSetup."Debug Level"),
                                                                 pBoolTesting,
                                                                 pBoolTesting,
                                                                 pBoolTesting,
                                                                 SPSiteDef."Main Url",
                                                                 FncGetTitle(pDropAreaFile."Library Title"),
                                                                 '',
                                                                 FieldGroup,
                                                                 DELCHR(pDropAreaFile."File Name",'=','%$&/"���?�'),
                                                                 FileBigText,
                                                                 Dic));
                     }*/
        //17160 CPA. 25-05-22. End
        /*{
              resultAction.ADDTEXT(
                     SharepointAddIn.UploadFileToSharepointUnico(SPSetup."Url Sharepoint",SPSetup.User,
                                                                 SPSetup.Pass, FORMAT(SPSetup."Debug Level"),
                                                                 pBoolTesting,pBoolTesting,pBoolTesting,
                                                                 '/sites/DragandDropTEST/' + SPSiteDef."Main Url", FncGetTitle(pDropAreaFile."Library Title"),'',FieldGroup,
                                                                 DELCHR(pDropAreaFile."File Name",'=','%$&/"���?�'), FileBigText, Dic));
              }*/
        vDicResult.ADDTEXT(resultAction);

        pDropAreaFile."Response SP".CREATEOUTSTREAM(vResult);
        vDicResult.WRITE(vResult);

        MESSAGE(FORMAT(resultAction));

        //Se mapea la respuesta para encontrar que ha sido correcto:
        IF STRPOS(FORMAT(resultAction), TEXTOK) <> 0 THEN BEGIN
            pDropAreaFile.Send := TRUE;
            pDropAreaFile."Send Date" := CREATEDATETIME(TODAY, TIME);
            pDropAreaFile.MODIFY;
        END;

        CLEAR(IStream);
        CLEAR(CurrentFilename);
        CLEAR(FileBigText);
    END;

    LOCAL PROCEDURE "<<>>"();
    BEGIN
    END;

    PROCEDURE FncGetTitle(pNoTitle: Text): Text;
    VAR
        SPSetup: Record 7174650;
    BEGIN
        ///Obtengo el titulo de la libreria de documentos en el caso que se utilice la libreria por defecto.
        SPSetup.GET();
        //////////////////////////AML TEST SPSetup.TESTFIELD("Library Name Default");

        IF pNoTitle = '' THEN
            EXIT(SPSetup."Library Name Default")
        ELSE
            EXIT(pNoTitle);
    END;

    LOCAL PROCEDURE FncCreatedSite(VAR pDragDropFile: Record 7174653; VAR pRecordIDv1: RecordID);
    VAR
        HistorySitesSP: Record 7174656;
        HistorySitesSPv1: Record 7174656;
        SPSiteDef: Record 7174651;
        NoEntry: Integer;
        DragDropSPSetup: Record 7174650;
    BEGIN

        ///Funci�n que guarda un hist�rico de las bibliotecas y site creados.
        SPSiteDef.GET(pDragDropFile."Sharepoint Site Definition");

        NoEntry := 1;
        HistorySitesSP.RESET;
        HistorySitesSP.SETRANGE("Metadata Site Definition", SPSiteDef."No.");
        IF HistorySitesSP.FINDLAST THEN
            NoEntry := HistorySitesSP."Line No." + 1;



        HistorySitesSPv1.RESET;
        HistorySitesSPv1.SETRANGE("Metadata Site Definition", SPSiteDef."No.");
        HistorySitesSPv1.SETRANGE(IdTable, SPSiteDef.IdTable);
        //-Q20314
        //HistorySitesSPv1.SETRANGE("Value PKv1",FORMAT(pRecordIDv1));
        HistorySitesSPv1.SETRANGE("Value PKv1", COPYSTR(FORMAT(pRecordIDv1), 1, 30));
        //+Q20314
        IF NOT HistorySitesSPv1.FINDFIRST THEN BEGIN
            ///Crear
            HistorySitesSP.INIT;
            HistorySitesSP."Metadata Site Definition" := SPSiteDef."No.";
            HistorySitesSP."Line No." := NoEntry;
            HistorySitesSP.IdTable := SPSiteDef.IdTable;
            HistorySitesSP."Value PK" := pRecordIDv1;
            //-Q20314
            //HistorySitesSP."Value PKv1"                := FORMAT(pRecordIDv1);
            HistorySitesSP."Value PKv1" := COPYSTR(FORMAT(pRecordIDv1), 1, 30);
            //+Q20314
            DragDropSPSetup.GET();
            IF pDragDropFile."Library Title" = '' THEN
                HistorySitesSP."Site Name" := DragDropSPSetup."Library Name Default"
            ELSE
                HistorySitesSP."Site Name" := pDragDropFile."Library Title";

            HistorySitesSP.URL := DragDropSPSetup."Url Sharepoint" + '/' + SPSiteDef."Main Url" + '/' + HistorySitesSP."Site Name" + '/Forms/AllItems.aspx';
            HistorySitesSP."Last Date Modified" := CREATEDATETIME(TODAY, TIME);
            HistorySitesSP.INSERT;
        END ELSE BEGIN
            HistorySitesSPv1."Last Date Modified" := CREATEDATETIME(TODAY, TIME);
            HistorySitesSPv1.MODIFY;
        END;
    END;

    PROCEDURE FncGetFiles(NoIdMetadata: Code[20]; VAR rDropArea: Record 7174657 TEMPORARY; pSiteLibrary: Text; pRecorId: RecordID; pAllDoc: Boolean);
    VAR
        SPSetup: Record 7174650;
        SharepointSiteMetadataDefs: Record 7174651;
        dicc: DotNet Dictionary_Of_T_U;
        ElementPair: DotNet KeyValuePair_Of_T_U;
        // GetFilesResponse: DotNet GetFilesListResponse;
        // SharepointAddIn: DotNet SharepointAddIn;
        NoLin: Integer;
        IStream: InStream;
        metadataFiltered: BigText;
        HistorySitesSP: Record 7174656;
        rDropAreav1: Record 7174657;
        returnedValue: Text;
        Enumerator: DotNet IEnumerator;
    BEGIN
        //Funci�n para recoger los ficheros cargados por toda una definici�n
        SPSetup.GET();
        SharepointSiteMetadataDefs.GET(NoIdMetadata);

        NoLin := 1;
        rDropAreav1.RESET;
        IF rDropAreav1.FINDLAST THEN
            NoLin := rDropAreav1."Entry No." + 1;


        HistorySitesSP.RESET;
        HistorySitesSP.SETRANGE("Metadata Site Definition", NoIdMetadata);
        IF (FORMAT(pRecorId) <> '') AND NOT (pAllDoc) THEN
            //-Q20314
            //HistorySitesSP.SETRANGE("Value PKv1",FORMAT(pRecorId));
            HistorySitesSP.SETRANGE("Value PKv1", COPYSTR(FORMAT(pRecorId), 1, 30));
        //+Q20314
        IF HistorySitesSP.FINDSET THEN
            REPEAT
                // Ejemplo filtro
                //metadataFiltered.ADDTEXT('[{B},{PRUEBA1},{BB1}]||');

                FncCreateFilter(HistorySitesSP, NoIdMetadata, metadataFiltered);
                dicc := dicc.Dictionary;
                //returnedValue := '';
                //metadataFiltered.GETSUBTEXT(returnedValue, 1, metadataFiltered.LENGTH);


                //17160 CPA. 25-05-22 Begin
                //Q17567 CPA 17/06/22.Begin
                //GetFilesResponse := SharepointAddIn.GetFilesList(SPSetup."Url Sharepoint", SPSetup.User, SPSetup.Pass,FORMAT(SPSetup."Debug Level"), SharepointSiteMetadataDefs."Main Url", pSiteLibrary, metadataFiltered,'');
                // GetFilesResponse := SharepointAddIn.GetFilesList(SPSetup."Url Sharepoint", SPSetup.User, SPSetup.Pass, FORMAT(SPSetup."Debug Level"),
                                                                //  SharepointSiteMetadataDefs."Main Url", pSiteLibrary, metadataFiltered, SharepointSiteMetadataDefs."Sharepoint folder Path");
                //Q17567 CPA 17/06/22.End
                // dicc := GetFilesResponse.DocumentList;
                //dicc := SharepointAddIn.GetFilesList(SPSetup."Url Sharepoint", SPSetup.User, SPSetup.Pass, SharepointSiteMetadataDefs."Main Url", pSiteLibrary, metadataFiltered);
                //17160 CPA. 25-05-22 End

                rDropAreav1.RESET;
                rDropAreav1.SETRANGE("Sharepoint Site Definition", SharepointSiteMetadataDefs."No.");
                rDropAreav1.SETRANGE(Filter, HistorySitesSP."Value PKv1");
                IF rDropAreav1.FINDSET THEN
                    rDropAreav1.DELETEALL;
                //Se devuelve un diccionario de datos con las urls.
                /*{
                          MESSAGE(FORMAT(dicc.Count));
                          Enumerator := dicc.GetEnumerator();
                          Enumerator.Reset;
                          WHILE (Enumerator.MoveNext) DO BEGIN
                            ElementPair := Enumerator.Current;
                          END;
                          }*/

                FOREACH ElementPair IN dicc DO BEGIN
                    rDropArea.INIT;
                    rDropArea."File Name" := FORMAT(ElementPair.Key);
                    rDropArea.Url := FORMAT(ElementPair.Value);
                    rDropArea."Entry No." := NoLin;
                    rDropArea."PK RecordID" := HistorySitesSP."Value PK"; //PRecorId;
                    rDropArea.Filter := FORMAT(HistorySitesSP."Value PKv1");
                    rDropArea."Creation Date" := CREATEDATETIME(TODAY, TIME);
                    rDropArea."Sharepoint Site Definition" := SharepointSiteMetadataDefs."No.";
                    rDropArea.INSERT;
                    NoLin += 1;
                END;

            UNTIL HistorySitesSP.NEXT = 0;
    END;

    PROCEDURE FncCreateFilter(VAR pHistorySitesSP: Record 7174656; NoIdMetadata: Code[20]; VAR pmetadataFiltered: BigText);
    VAR
        SiteSPDefinition: Record 7174651;
        SiteSPMetadataDefs: Record 7174652;
        xRecRef: RecordRef;
        xFieldRef: FieldRef;
        txtValue: Text;
        INTNUMBER: Integer;
        IntNumberOpt: Integer;
        fieldfilter: Text;
    BEGIN
        ///FIltro para obtener solo los ficheros que tienen un determinado filtro.
        SiteSPDefinition.GET(NoIdMetadata);
        CLEAR(pmetadataFiltered);

        xRecRef.OPEN(SiteSPDefinition.IdTable);

        SiteSPMetadataDefs.RESET;
        SiteSPMetadataDefs.SETRANGE("Metadata Site Definition", NoIdMetadata);
        SiteSPMetadataDefs.SETRANGE("Field Filter", TRUE);
        IF SiteSPMetadataDefs.FINDSET THEN
            REPEAT

                IF xRecRef.GET(pHistorySitesSP."Value PK") THEN BEGIN
                    IntNumberOpt := SiteSPMetadataDefs."Type Field Sharepoint";

                    //17160 CPA. 25-05-22.Begin
                    //EVALUATE(INTNUMBER,SiteSPMetadataDefs.Value);
                    //xFieldRef := xRecRef.FIELD(INTNUMBER);
                    //txtValue := FORMAT(xFieldRef.VALUE);
                    IF SiteSPMetadataDefs."Value Type" = SiteSPMetadataDefs."Value Type"::"Fixed Value" THEN
                        txtValue := SiteSPMetadataDefs.Value
                    ELSE BEGIN
                        EVALUATE(INTNUMBER, SiteSPMetadataDefs.Value);
                        xFieldRef := xRecRef.FIELD(INTNUMBER);

                        IF SiteSPMetadataDefs."Calculate Field" THEN
                            xFieldRef.CALCFIELD();

                        txtValue := FORMAT(xFieldRef.VALUE);
                    END;
                    //17160 CPA. 25-05-22.Begin

                    IF txtValue <> '' THEN BEGIN
                        fieldfilter := '[{' + SiteSPMetadataDefs."Internal Name" + '},{' + SiteSPMetadataDefs.Name + '},{' + txtValue + '},{' + FORMAT(IntNumberOpt) + '}]|';
                        pmetadataFiltered.ADDTEXT(fieldfilter);
                        //   pmetadataFiltered.ADDTEXT('[{' + SiteSPMetadataDefs."Internal Name" +'},{' + SiteSPMetadataDefs.Name + '},{' + txtValue +'}]|');
                    END;
                END;


            UNTIL SiteSPMetadataDefs.NEXT = 0;

        pmetadataFiltered.ADDTEXT('|');
    END;

    PROCEDURE GetFilesBatch(VAR pSiteSPDefinition: Record 7174651);
    VAR
        JobQueueEntry: Record 472;
    BEGIN
        ///Petici�nn batch de los ficheros que componen un site.
        JobQueueEntry.INIT;
        //JobQueueEntry.ID := CREATEGUID;
        JobQueueEntry."Object Type to Run" := JobQueueEntry."Object Type to Run"::Codeunit;
        JobQueueEntry."Object ID to Run" := CODEUNIT::"GetFile SP Batch";
        JobQueueEntry."Record ID to Process" := pSiteSPDefinition.RECORDID;
        JobQueueEntry."Job Queue Category Code" := 'SP';
        CODEUNIT.RUN(CODEUNIT::"Job Queue - Enqueue", JobQueueEntry);
    END;

    PROCEDURE GetTitleLibrary(pNoMetadata: Code[20]; VAR xRecRef: RecordRef): Text;
    VAR
        SPSiteDefinition: Record 7174651;
        FldRef: FieldRef;
        intField: Integer;
        TxtField: Text[250];
    BEGIN
        ///Titulo de la libreria variable (en funci�n de la configuraci�n):

        SPSiteDefinition.GET(pNoMetadata);
        IF (SPSiteDefinition."Library Title Type" = SPSiteDefinition."Library Title Type"::"Fixed Value") THEN BEGIN
            EXIT(SPSiteDefinition."Library Title");
        END ELSE BEGIN
            IF (SPSiteDefinition."Library Title Type" = SPSiteDefinition."Library Title Type"::"Field Value") THEN BEGIN
                EVALUATE(intField, SPSiteDefinition."Library Title");
                FldRef := xRecRef.FIELD(intField);
                TxtField := FORMAT(FldRef.VALUE);
                IF TxtField <> '' THEN
                    EXIT(TxtField)
                ELSE
                    EXIT('TEST');
            END ELSE BEGIN
                EXIT('');
            END;
        END;
    END;

    LOCAL PROCEDURE "<<>>A"();
    BEGIN
    END;

    PROCEDURE GetSelectionFilterForTypeValuesSP(VAR LibTypesValuesSP: Record 7174655): Text;
    VAR
        RecRef: RecordRef;
        CDU46: Codeunit 46;
    BEGIN
        RecRef.GETTABLE(LibTypesValuesSP);
        EXIT(GetSelectionFilter(RecRef, LibTypesValuesSP.FIELDNO(Value)));
    END;

    LOCAL PROCEDURE GetSelectionFilter(VAR TempRecRef: RecordRef; SelectionFieldID: Integer): Text;
    VAR
        RecRef: RecordRef;
        FieldRef: FieldRef;
        FirstRecRef: Text;
        LastRecRef: Text;
        SelectionFilter: Text;
        SavePos: Text;
        TempRecRefCount: Integer;
        More: Boolean;
    BEGIN
        IF TempRecRef.ISTEMPORARY THEN BEGIN
            RecRef := TempRecRef.DUPLICATE;
            RecRef.RESET;
        END ELSE
            RecRef.OPEN(TempRecRef.NUMBER);

        TempRecRefCount := TempRecRef.COUNT;
        IF TempRecRefCount > 0 THEN BEGIN
            TempRecRef.ASCENDING(TRUE);
            TempRecRef.FIND('-');
            WHILE TempRecRefCount > 0 DO BEGIN
                TempRecRefCount := TempRecRefCount - 1;
                RecRef.SETPOSITION(TempRecRef.GETPOSITION);
                RecRef.FIND;
                FieldRef := RecRef.FIELD(SelectionFieldID);
                FirstRecRef := FORMAT(FieldRef.VALUE);
                LastRecRef := FirstRecRef;
                More := TempRecRefCount > 0;
                WHILE More DO
                    IF RecRef.NEXT = 0 THEN
                        More := FALSE
                    ELSE BEGIN
                        SavePos := TempRecRef.GETPOSITION;
                        TempRecRef.SETPOSITION(RecRef.GETPOSITION);
                        IF NOT TempRecRef.FIND THEN BEGIN
                            More := FALSE;
                            TempRecRef.SETPOSITION(SavePos);
                        END ELSE BEGIN
                            FieldRef := RecRef.FIELD(SelectionFieldID);
                            LastRecRef := FORMAT(FieldRef.VALUE);
                            TempRecRefCount := TempRecRefCount - 1;
                            IF TempRecRefCount = 0 THEN
                                More := FALSE;
                        END;
                    END;
                IF SelectionFilter <> '' THEN
                    SelectionFilter := SelectionFilter + '|';
                IF FirstRecRef = LastRecRef THEN
                    SelectionFilter := SelectionFilter + AddQuotes(FirstRecRef)
                ELSE
                    SelectionFilter := SelectionFilter + AddQuotes(FirstRecRef) + '..' + AddQuotes(LastRecRef);
                IF TempRecRefCount > 0 THEN
                    TempRecRef.NEXT;
            END;
            EXIT(SelectionFilter);
        END;
    END;

    PROCEDURE AddQuotes(inString: Text[1024]): Text;
    BEGIN
        IF DELCHR(inString, '=', ' &|()*') = inString THEN
            EXIT(inString);
        EXIT('''' + inString + '''');
    END;

    PROCEDURE FncFilterGroup(pNoMetadata: Code[20]): Text;
    VAR
        SiteSPMetadataDefs: Record 7174652;
    BEGIN
        ///Filtro por campo agrupaci�n.
        SiteSPMetadataDefs.RESET;
        SiteSPMetadataDefs.SETRANGE("Metadata Site Definition", pNoMetadata);
        SiteSPMetadataDefs.SETRANGE("Field Group", TRUE);
        IF SiteSPMetadataDefs.FINDFIRST THEN
            EXIT(SiteSPMetadataDefs.Name);
    END;

    PROCEDURE FileDownload(VAR pDropAreaFile: Record 7174653; pBoolTesting: Boolean);
    VAR
        SPSetup: Record 7174650;
        IStream: InStream;
        ToMemoryStream: DotNet MemoryStream;
        resultAction: BigText;
        Bytes: DotNet Array;
        FileBigText: BigText;
        Convert: DotNet Convert;
        // SharepointAddIn: DotNet SharepointAddIn;
        SPSiteDef: Record 7174651;
        Dic: BigText;
        txtresult: Text;
        FieldGroup: Text[250];
        vResult: OutStream;
        vDicResult: BigText;
        Length: Integer;
    BEGIN
        //Copia de SendOnLine
        pBoolTesting := TRUE;

        SPSetup.GET;
        SPSetup.TESTFIELD("Enable Integration", TRUE);

        pDropAreaFile."File Content".CREATEINSTREAM(IStream);
        ToMemoryStream := ToMemoryStream.MemoryStream;
        COPYSTREAM(ToMemoryStream, IStream);
        Bytes := ToMemoryStream.GetBuffer;
        FileBigText.ADDTEXT(Convert.ToBase64String(Bytes));
        ToMemoryStream.Close();

        pDropAreaFile."Dictionary SP".CREATEINSTREAM(IStream);
        Dic.READ(IStream);

        SPSiteDef.GET(pDropAreaFile."Sharepoint Site Definition");

        FieldGroup := FncFilterGroup(SPSiteDef."No.");

        ///ENVIO DEL FICHERO:

        // resultAction.ADDTEXT(
        //        //17160. CPA 26-05-22.BEGIN
        //        SharepointAddIn.UploadFileToSharepointUnico(SPSetup."Url Sharepoint", SPSetup.User,
        //                                                    SPSetup.Pass, FORMAT(SPSetup."Debug Level"),
        //                                                    pBoolTesting, pBoolTesting, pBoolTesting,
        //                                                    SPSiteDef."Main Url", FncGetTitle(pDropAreaFile."Library Title"), SPSiteDef."Name Site Sharepoint", FieldGroup,
        //                                                    //Q17567 CPA 17/06/22.Begin
        //                                                    //DELCHR(pDropAreaFile."File Name",'=','%$&/"���?�'), FileBigText, Dic,''));
        //                                                    DELCHR(pDropAreaFile."File Name", '=', '%$&/"���?�'), FileBigText, Dic, SPSiteDef."Sharepoint folder Path"));
        //Q17567 CPA 17/06/22.End
        /*{
                     SharepointAddIn.UploadFileToSharepointUnico(SPSetup."Url Sharepoint",SPSetup.User,
                                                                 SPSetup.Pass, FORMAT(SPSetup."Debug Level"),
                                                                 pBoolTesting,pBoolTesting,pBoolTesting,
                                                                 SPSiteDef."Main Url", FncGetTitle(pDropAreaFile."Library Title"),'',FieldGroup,
                                                                 DELCHR(pDropAreaFile."File Name",'=','%$&/"���?�'), FileBigText, Dic));
                     }*/
        //17160. CPA 26-05-22.END
        /*{
              resultAction.ADDTEXT(
                     SharepointAddIn.UploadFileToSharepointUnico(SPSetup."Url Sharepoint",SPSetup.User,
                                                                 SPSetup.Pass, FORMAT(SPSetup."Debug Level"),
                                                                 pBoolTesting,pBoolTesting,pBoolTesting,
                                                                 '/sites/DragandDropTEST/' + SPSiteDef."Main Url", FncGetTitle(pDropAreaFile."Library Title"),'',FieldGroup,
                                                                 DELCHR(pDropAreaFile."File Name",'=','%$&/"���?�'), FileBigText, Dic));
              }*/
        vDicResult.ADDTEXT(resultAction);

        pDropAreaFile."Response SP".CREATEOUTSTREAM(vResult);
        vDicResult.WRITE(vResult);

        MESSAGE(FORMAT(resultAction));

        //Se mapea la respuesta para encontrar que ha sido correcto:
        IF STRPOS(FORMAT(resultAction), TEXTOK) <> 0 THEN BEGIN
            pDropAreaFile.Send := TRUE;
            pDropAreaFile."Send Date" := CREATEDATETIME(TODAY, TIME);
            pDropAreaFile.MODIFY;
        END;

        CLEAR(IStream);
        CLEAR(CurrentFilename);
        CLEAR(FileBigText);
    END;

    LOCAL PROCEDURE "//17160. CPA.  Functions BEGIN"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 18, OnAfterModifyEvent, '', true, true)]
    LOCAL PROCEDURE TbCustomer_OnAfterModifyEvent(VAR Rec: Record 18; VAR xRec: Record 18; RunTrigger: Boolean);
    VAR
        SPSiteDef: Record 7174651;
        RecRef: RecordRef;
        xRecRef: RecordRef;
        DragDropSPSetup: Record 7174650;
    BEGIN
        //17160 CPA. 25-05-22.Begin
        IF Rec.ISTEMPORARY THEN EXIT;

        CheckAndUpdateMetadatasModifications(Rec, xRec);
        //17160 CPA. 25-05-22.End
    END;

    [EventSubscriber(ObjectType::Table, 23, OnAfterModifyEvent, '', true, true)]
    LOCAL PROCEDURE TbVendor_OnAfterModifyEvent(VAR Rec: Record 23; VAR xRec: Record 23; RunTrigger: Boolean);
    VAR
        SPSiteDef: Record 7174651;
        RecRef: RecordRef;
        xRecRef: RecordRef;
        DragDropSPSetup: Record 7174650;
    BEGIN
        //17160 CPA. 25-05-22.Begin
        IF Rec.ISTEMPORARY THEN EXIT;

        CheckAndUpdateMetadatasModifications(Rec, xRec);
        //17160 CPA. 25-05-22.End
    END;

    [EventSubscriber(ObjectType::Table, 38, OnAfterModifyEvent, '', true, true)]
    LOCAL PROCEDURE TbPurchHeader_OnAfterModify(VAR Rec: Record 38; VAR xRec: Record 38; RunTrigger: Boolean);
    VAR
        SPSiteDef: Record 7174651;
        RecRef: RecordRef;
        xRecRef: RecordRef;
        DragDropSPSetup: Record 7174650;
    BEGIN
        //17160 CPA. 25-05-22.Begin
        IF Rec.ISTEMPORARY THEN EXIT;

        CheckAndUpdateMetadatasModifications(Rec, xRec);
        //17160 CPA. 25-05-22.End
    END;

    [EventSubscriber(ObjectType::Table, 36, OnAfterModifyEvent, '', true, true)]
    LOCAL PROCEDURE TbSalesHeader_OnAfterModify(VAR Rec: Record 36; VAR xRec: Record 36; RunTrigger: Boolean);
    VAR
        SPSiteDef: Record 7174651;
        RecRef: RecordRef;
        xRecRef: RecordRef;
        DragDropSPSetup: Record 7174650;
    BEGIN
        //17160 CPA. 25-05-22.Begin
        IF Rec.ISTEMPORARY THEN EXIT;

        CheckAndUpdateMetadatasModifications(Rec, xRec);
        //17160 CPA. 25-05-22.End
    END;

    [EventSubscriber(ObjectType::Codeunit, 90, OnAfterFinalizePosting, '', true, true)]
    LOCAL PROCEDURE cdu80_PurchPostOnAfterFinalizePosting(VAR PurchHeader: Record 38; VAR PurchRcptHeader: Record 120; VAR PurchInvHeader: Record 122; VAR PurchCrMemoHdr: Record 124; VAR ReturnShptHeader: Record 6650; VAR GenJnlPostLine: Codeunit 12; PreviewMode: Boolean; CommitIsSupressed: Boolean);
    VAR
        DragDropSPSetup: Record 7174650;
        SPSiteDef: Record 7174651;
    BEGIN
        //17160 CPA. 25-05-22.Begin
        IF PreviewMode THEN EXIT;

        DragDropSPSetup.GET;
        IF NOT DragDropSPSetup."Enable Integration" THEN EXIT;

        IF PurchInvHeader."No." <> '' THEN BEGIN
            SPSiteDef.RESET;
            SPSiteDef.SETRANGE(IdTable, DATABASE::"Purch. Inv. Header");
            SPSiteDef.SETRANGE(Status, SPSiteDef.Status::Released);
            IF SPSiteDef.FINDSET THEN
                REPEAT
                    UpdateSiteFilesMetadatas(PurchInvHeader.RECORDID, SPSiteDef);
                UNTIL SPSiteDef.NEXT = 0;
        END;


        IF PurchCrMemoHdr."No." <> '' THEN BEGIN
            SPSiteDef.RESET;
            SPSiteDef.SETRANGE(IdTable, DATABASE::"Purch. Cr. Memo Hdr.");
            SPSiteDef.SETRANGE(Status, SPSiteDef.Status::Released);
            IF SPSiteDef.FINDSET THEN
                REPEAT
                    UpdateSiteFilesMetadatas(PurchCrMemoHdr.RECORDID, SPSiteDef);
                UNTIL SPSiteDef.NEXT = 0;
        END;
        //17160 CPA. 25-05-22.End
    END;

    [EventSubscriber(ObjectType::Codeunit, 80, OnAfterFinalizePosting, '', true, true)]
    LOCAL PROCEDURE cdu90_SalesPostOnAfterFinalizePosting(VAR SalesHeader: Record 36; VAR SalesShipmentHeader: Record 110; VAR SalesInvoiceHeader: Record 112; VAR SalesCrMemoHeader: Record 114; VAR ReturnReceiptHeader: Record 6660; VAR GenJnlPostLine: Codeunit 12; CommitIsSuppressed: Boolean; PreviewMode: Boolean);
    VAR
        DragDropSPSetup: Record 7174650;
        SPSiteDef: Record 7174651;
    BEGIN
        //17160 CPA. 25-05-22.Begin
        IF PreviewMode THEN EXIT;

        DragDropSPSetup.GET;
        IF NOT DragDropSPSetup."Enable Integration" THEN EXIT;

        IF SalesInvoiceHeader."No." <> '' THEN BEGIN
            SPSiteDef.RESET;
            SPSiteDef.SETRANGE(IdTable, DATABASE::"Sales Invoice Header");
            SPSiteDef.SETRANGE(Status, SPSiteDef.Status::Released);
            IF SPSiteDef.FINDSET THEN
                REPEAT
                    UpdateSiteFilesMetadatas(SalesInvoiceHeader.RECORDID, SPSiteDef);
                UNTIL SPSiteDef.NEXT = 0;
        END;


        IF SalesCrMemoHeader."No." <> '' THEN BEGIN
            SPSiteDef.RESET;
            SPSiteDef.SETRANGE(IdTable, DATABASE::"Sales Cr.Memo Header");
            SPSiteDef.SETRANGE(Status, SPSiteDef.Status::Released);
            IF SPSiteDef.FINDSET THEN
                REPEAT
                    UpdateSiteFilesMetadatas(SalesCrMemoHeader.RECORDID, SPSiteDef);
                UNTIL SPSiteDef.NEXT = 0;
        END;
        //17160 CPA. 25-05-22.End
    END;

    LOCAL PROCEDURE UpdateSiteFilesMetadatas(RecID: RecordID; SPSiteDef: Record 7174651);
    VAR
        recRef: RecordRef;
        TableNo: Integer;
        tempDropAreaFiles: Record 7174657 TEMPORARY;
        SiteLibrary: Text;
        cduDropArea: Codeunit 7174650;
        txtMetadata: Text;
    BEGIN
        //17160 CPA. 25-05-22.Begin

        recRef.GET(RecID);
        TableNo := recRef.NUMBER;

        SiteLibrary := cduDropArea.GetTitleLibrary(SPSiteDef."No.", recRef);
        FncGetFiles(SPSiteDef."No.", tempDropAreaFiles, SiteLibrary, RecID, FALSE);

        IF tempDropAreaFiles.FINDSET THEN
            REPEAT
                UpdateSiteFileMetadatas(SPSiteDef, recRef, SiteLibrary, tempDropAreaFiles);
            UNTIL tempDropAreaFiles.NEXT = 0;

        //17160 CPA. 25-05-22.End
    END;

    LOCAL PROCEDURE UpdateSiteFileMetadatas(SPSiteDef: Record 7174651; recRef: RecordRef; SiteLibrary: Text; DropAreaFile: Record 7174657 TEMPORARY);
    VAR
        DragDropSPSetup: Record 7174650;
        DragDropFile: Record 7174653;
        OStreamDic: OutStream;
        Dicc: BigText;
        pgDropArea: Page 7174655;
    BEGIN
        //17160 CPA. 25-05-22.Begin
        DragDropSPSetup.GET;

        ///Tabla con la informaci�n suministrada.
        DragDropFile.INIT;
        DragDropFile."File Name" := DropAreaFile."File Name";

        pgDropArea.CreateMetadata(SPSiteDef."No.", Dicc, recRef, FALSE);
        DragDropFile."Dictionary SP".CREATEOUTSTREAM(OStreamDic);
        Dicc.WRITE(OStreamDic);

        DragDropFile."Sharepoint Site Definition" := DropAreaFile."Sharepoint Site Definition";
        DragDropFile."Creation Date" := CURRENTDATETIME;
        DragDropFile.User := USERID;
        DragDropFile.Url := SPSiteDef."Main Url";
        DragDropFile."Library Title" := SiteLibrary;
        DragDropFile."Update Metadata Only" := TRUE;
        DragDropFile.INSERT(TRUE);

        IF NOT DragDropSPSetup."Batch Synchronization" THEN
            SendSiteFileMetadatas_Online(DragDropFile)
        ELSE
            SendSiteFileMetadatas_Batch(DragDropFile);


        //17160 CPA. 25-05-22.End
    END;

    PROCEDURE SendSiteFileMetadatas_Online(VAR DragDropFile: Record 7174653);
    VAR
        // SharepointAddIn: DotNet SharepointAddIn;
        SPSetup: Record 7305;
        DragDropSPSetup: Record 7174650;
        Dicc: BigText;
        InStr: InStream;
        resultAction: BigText;
        OutStream: OutStream;
        vDicResult: BigText;
    BEGIN
        //17160 CPA. 25-05-22.Begin
        DragDropSPSetup.GET;

        //pgDropArea.CreateMetadata(SPSiteDef."No.", Dicc, recRef , FALSE);
        //
        //SharepointAddIn := SharepointAddIn.SharepointAddIn();
        //SharepointAddIn.ActualizarArchivo(DragDropSPSetup."Url Sharepoint",
        //                                  DragDropSPSetup.User,
        //                                  DragDropSPSetup.Pass,
        //                                  FORMAT(DragDropSPSetup."Debug Level"),
        //                                  SPSiteDef."Main Url",
        //                                  SiteLibrary,
        //                                  DropAreaFile."File Name",
        //                                  '',
        //                                  Dicc);

        DragDropFile.CALCFIELDS("Dictionary SP");
        DragDropFile."Dictionary SP".CREATEINSTREAM(InStr);
        Dicc.READ(InStr);

        // SharepointAddIn := SharepointAddIn.SharepointAddIn();
        // resultAction.ADDTEXT(
        // SharepointAddIn.ActualizarArchivo(DragDropSPSetup."Url Sharepoint",
        //                                   DragDropSPSetup.User,
        //                                   DragDropSPSetup.Pass,
        //                                   FORMAT(DragDropSPSetup."Debug Level"),
        //                                   DragDropFile.Url,
        //                                   DragDropFile."Library Title",
        //                                   DragDropFile."File Name",
        //                                   //Q17567 CPA 17/06/22.Begin
        //                                   //'',
        //                                   DragDropFile."Sharepoint Site Definition",
        //                                   //Q17567 CPA 17/06/22.End
        //                                   Dicc));



        vDicResult.ADDTEXT(resultAction);

        DragDropFile."Response SP".CREATEOUTSTREAM(OutStream);
        vDicResult.WRITE(OutStream);

        //Se mapea la respuesta para encontrar que ha sido correcto:
        //IF STRPOS(FORMAT(resultAction),TEXTOK) <> 0 THEN BEGIN
        DragDropFile.Send := TRUE;
        DragDropFile."Send Date" := CURRENTDATETIME;
        DragDropFile.MODIFY;
        //END;

        MESSAGE(FORMAT(resultAction));
        //17160 CPA. 25-05-22.End
    END;

    LOCAL PROCEDURE SendSiteFileMetadatas_Batch(VAR DragDropFile: Record 7174653);
    VAR
        //SharepointAddIn: DotNet SharepointAddIn;
        SPSetup: Record 7305;
        DragDropSPSetup: Record 7174650;
        pgDropArea: Page 7174655;
        Dicc: BigText;
        JobQueueEntry: Record 472;
    BEGIN
        //17160 CPA. 25-05-22.Begin
        JobQueueEntry.INIT;
        //JobQueueEntry.ID := CREATEGUID;
        JobQueueEntry."Object Type to Run" := JobQueueEntry."Object Type to Run"::Codeunit;
        JobQueueEntry."Object ID to Run" := CODEUNIT::"Send File SP Batch";
        JobQueueEntry."Record ID to Process" := DragDropFile.RECORDID;
        JobQueueEntry."Job Queue Category Code" := 'SP';
        CODEUNIT.RUN(CODEUNIT::"Job Queue - Enqueue", JobQueueEntry);
        //17160 CPA. 25-05-22.End
    END;

    LOCAL PROCEDURE CheckAndUpdateMetadatasModifications(RecordVariant: Variant; xRecordVariant: Variant);
    VAR
        DragDropSPSetup: Record 7174650;
        SPSiteDef: Record 7174651;
        RecRef: RecordRef;
        xRecRef: RecordRef;
    BEGIN
        //17160 CPA. 25-05-22.Begin
        DragDropSPSetup.GET;
        IF NOT DragDropSPSetup."Enable Integration" THEN EXIT;

        RecRef.GETTABLE(RecordVariant);
        xRecRef.GETTABLE(xRecordVariant);

        SPSiteDef.RESET;
        SPSiteDef.SETRANGE(IdTable, RecRef.NUMBER);
        SPSiteDef.SETRANGE(Status, SPSiteDef.Status::Released);
        IF SPSiteDef.FINDSET THEN
            REPEAT
                IF SiteDefHasModifiedMetadatas(SPSiteDef."No.", RecRef, xRecRef) THEN
                    UpdateSiteFilesMetadatas(RecRef.RECORDID, SPSiteDef);
            UNTIL SPSiteDef.NEXT = 0;
        //17160 CPA. 25-05-22.End
    END;

    LOCAL PROCEDURE SiteDefHasModifiedMetadatas(SPSiteDefNo: Code[20]; RecRef: RecordRef; xRecRef: RecordRef): Boolean;
    VAR
        SPSiteDefMetadatas: Record 7174652;
        fieldRef: FieldRef;
        xfieldRef: FieldRef;
        fieldNo: Integer;
        xFieldNo: Integer;
    BEGIN
        //17160 CPA. 25-05-22.Begin
        SPSiteDefMetadatas.RESET;
        SPSiteDefMetadatas.SETRANGE("Metadata Site Definition", SPSiteDefNo);
        SPSiteDefMetadatas.SETRANGE("Value Type", SPSiteDefMetadatas."Value Type"::"Field Value");
        SPSiteDefMetadatas.SETRANGE("Calculate Field", FALSE);
        IF SPSiteDefMetadatas.FINDSET THEN
            REPEAT
                EVALUATE(fieldNo, SPSiteDefMetadatas.Value);
                EVALUATE(xFieldNo, SPSiteDefMetadatas.Value);

                fieldRef := RecRef.FIELD(fieldNo);
                xfieldRef := xRecRef.FIELD(xFieldNo);

                IF fieldRef.VALUE <> xfieldRef.VALUE THEN
                    EXIT(TRUE);
            UNTIL (SPSiteDefMetadatas.NEXT = 0);

        EXIT(FALSE);
        //17160 CPA. 25-05-22.End
    END;

    LOCAL PROCEDURE "//17160. CPA Functions END"();
    BEGIN
    END;

    /*BEGIN
/*{
      QUONEXT 20.07.17 DRAG&DROP. Procesos para subida de ficheros a SP.

      17160 CPA. 25-05-22
      Q17567 CPA 17/06/22
      Q20314 AML 17/10/23 Correccion para evitar sobrepasamiento.
    }
END.*/
}









