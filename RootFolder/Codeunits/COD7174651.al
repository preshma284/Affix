Codeunit 7174651 "Send File SP Batch"
{


    TableNo = 472;
    trigger OnRun()
    VAR
        DropAreaMgmt: Codeunit 7174650;
    BEGIN

        ///Se recoge el registro a enviar
        Rec.TESTFIELD(Rec."Record ID to Process");
        RecRef.GET(Rec."Record ID to Process");
        RecRef.SETTABLE(DropAreaFile);
        DropAreaFile.FIND;

        ///Envio

        //17160 CPA. 25-05-22.Begin
        IF DropAreaFile."Update Metadata Only" THEN
            DropAreaMgmt.SendSiteFileMetadatas_Online(DropAreaFile)
        ELSE
            //17160 CPA. 25-05-22.End
              SendFile(DropAreaFile, FALSE);
    END;

    VAR
        RecRef: RecordRef;
        DropAreaFile: Record 7174653;
        DropAreaMgt: Codeunit 7174650;
        TEXTOK: TextConst ENU = 'Subida de Ficheros terminada', ESP = 'Subida de Ficheros terminada';
        vVariant: Variant;
        pRecordID: RecordID;
        IdMetadata: Code[20];
        FilterValuesCurrentLibrary: Text;
        TEXT50000: TextConst ENU = 'Error, only one option can be selected per Sharepoint tag.', ESP = 'Error, solo se puede seleccionar una opci�n por etiqueta de Sharepoint.';
        TEXTOPENLIST: TextConst ENU = '"Preview list files                                   "', ESP = '"Ver lista ficheros                                  "';

    PROCEDURE SendFile(VAR pDropAreaFile: Record 7174653; pBoolTesting: Boolean);
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
        DropAreaMgt: Codeunit 7174650;
        FieldGroup: Text[150];
        vDicResult: BigText;
        vResult: OutStream;
        pTitle: Text;
    BEGIN
        //17160 CPA. 25-05-22.Begin De momento se comenta, no pernece al est�ndar Drag&Drop
        /*{
              //Similar al proceso online pero se utilizan calcfields
              SPSiteDef.SETRANGE(IdTable,38);
              IF NOT SPSiteDef.FINDFIRST THEN EXIT;

              SendValues(Dic,SPSiteDef."No.",pTitle);
              }*/
        //17160 CPA. 25-05-22.End

        pBoolTesting := TRUE;

        SPSetup.GET;
        SPSetup.TESTFIELD("Enable Integration", TRUE);
        pDropAreaFile.CALCFIELDS("File Content");

        pDropAreaFile."File Content".CREATEINSTREAM(IStream);
        ToMemoryStream := ToMemoryStream.MemoryStream;
        COPYSTREAM(ToMemoryStream, IStream);
        Bytes := ToMemoryStream.GetBuffer;
        FileBigText.ADDTEXT(Convert.ToBase64String(Bytes));
        ToMemoryStream.Close();

        pDropAreaFile.CALCFIELDS("Dictionary SP");
        pDropAreaFile."Dictionary SP".CREATEINSTREAM(IStream);
        Dic.READ(IStream);

        SPSiteDef.GET(pDropAreaFile."Sharepoint Site Definition");

        FieldGroup := DropAreaMgt.FncFilterGroup(SPSiteDef."No.");

        ///ENVIO DEL FICHERO.
        //17160 CPA. 25-05-22.BEGIN
        // resultAction.ADDTEXT(
        //        SharepointAddIn.UploadFileToSharepointUnico(SPSetup."Url Sharepoint", SPSetup.User,
        //                                                    SPSetup.Pass, FORMAT(SPSetup."Debug Level"),
        //                                                    pBoolTesting, pBoolTesting, pBoolTesting,
        //                                                    SPSiteDef."Main Url", pDropAreaFile."Library Title", '', FieldGroup,
        //                                                    DELCHR(pDropAreaFile."File Name", '=', '%$&/"���?�')
        //                                                    //Q17567 CPA 17/06/22.Begin
        //                                                    //, FileBigText, Dic,''));
        //                                                    , FileBigText, Dic, SPSiteDef."Sharepoint folder Path"));
        //Q17567 CPA 17/06/22.End
        /*{
              resultAction.ADDTEXT(
                     SharepointAddIn.UploadFileToSharepointUnico(SPSetup."Url Sharepoint",SPSetup.User,
                                                                 SPSetup.Pass, FORMAT(SPSetup."Debug Level"),
                                                                 pBoolTesting,pBoolTesting,pBoolTesting,
                                                                 SPSiteDef."Main Url", pDropAreaFile."Library Title",'',FieldGroup,
                                                                 DELCHR(pDropAreaFile."File Name",'=','%$&/"���?�')
                                                                 , FileBigText, Dic));

              }*/
        //17160 CPA. 25-05-22.END

        //MESSAGE(FORMAT(resultAction));

        vDicResult.ADDTEXT(resultAction);
        pDropAreaFile."Response SP".CREATEOUTSTREAM(vResult);
        vDicResult.WRITE(vResult);

        //Se mapea la respuesta para encontrar que ha sido correcto:
        IF STRPOS(FORMAT(resultAction), TEXTOK) <> 0 THEN BEGIN
            pDropAreaFile.Send := TRUE;
            pDropAreaFile."Send Date" := CREATEDATETIME(TODAY, TIME);
            pDropAreaFile.MODIFY;
        END;

        CLEAR(IStream);

        CLEAR(FileBigText);
    END;

    LOCAL PROCEDURE "//b2B"();
    BEGIN
    END;

    PROCEDURE SendB2BXML(VAR B2BRouterInvHeader: Record 7207314);
    VAR
        B2BRouterInvAttachement: Record 7207318;
        DragDropFile: Record 7174653;
        PurchaseHeader: Record 38;
        vBigTxt: BigText;
        pIdMetadata: Code[20];
        vTitle: Text;
        FileName: Text;
        Data: Text;
    BEGIN
        //17160 CPA. 25-05-22.BEGIN
        /*{
              IF B2BRouterInvHeader."NAV Purch. Inv. No." = '' THEN EXIT;
              PurchaseHeader.GET(PurchaseHeader."Document Type"::Invoice,B2BRouterInvHeader."NAV Purch. Inv. No.");
              B2BRouterInvHeader.CALCFIELDS("Attachment File");
              B2BRouterInvAttachement.INIT;
              B2BRouterInvAttachement."Job No." := B2BRouterInvHeader.Code;
              B2BRouterInvAttachement."Document No." := 99999;
              B2BRouterInvAttachement."Budget Amount" := B2BRouterInvHeader."Attachment File";
              B2BRouterInvAttachement.INSERT;
              SetFilter(PurchaseHeader);
              DropAreaMgt.FileDropBegin(B2BRouterInvHeader."Attachment File Name");
              //DropAreaMgt.FileDrop(CONVERTSTR(B2BRouterInvHeader."Attachment File",Data));

              //Se informa todo lo necesario para SP
              CLEAR(vBigTxt);
              SendValues(vBigTxt,IdMetadata,vTitle);
              //Proceso de envio:
              DropAreaMgt.FileDropEndB2B(vTitle,IdMetadata,vBigTxt,pRecordID,B2BRouterInvAttachement);

              IF B2BRouterInvAttachement.GET(B2BRouterInvHeader.Code,99999) THEN BEGIN
                B2BRouterInvAttachement.DELETE  ;
              END;
              }*/
        //17160 CPA. 25-05-22.END
    END;

    PROCEDURE SendB2B(VAR B2BRouterInvHeader: Record 7207314; VAR B2BRouterInvAttachement: Record 7207318);
    VAR
        DragDropFile: Record 7174653;
        PurchaseHeader: Record 38;
        vBigTxt: BigText;
        pIdMetadata: Code[20];
        vTitle: Text;
        FileName: Text;
        Data: Text[10];
        pB2BRouterInvAttachement: Record 7207318;
    BEGIN
        //17160 CPA. 25-05-22.BEGIN
        /*{
              IF B2BRouterInvHeader."NAV Purch. Inv. No." = '' THEN EXIT;
              PurchaseHeader.GET(PurchaseHeader."Document Type"::Invoice,B2BRouterInvHeader."NAV Purch. Inv. No.");
              B2BRouterInvAttachement.CALCFIELDS("Budget Amount");
              pB2BRouterInvAttachement.INIT;
              pB2BRouterInvAttachement."Job No." := B2BRouterInvHeader.Code;
              pB2BRouterInvAttachement."Document No." := 99999;
              pB2BRouterInvAttachement."Budget Amount" := B2BRouterInvAttachement."Budget Amount";
              pB2BRouterInvAttachement.INSERT;

              SetFilter(PurchaseHeader);
              DropAreaMgt.FileDropBegin(B2BRouterInvAttachement."G/L Account");
              //DropAreaMgt.FileDrop(data);

              //Se informa todo lo necesario para SP
              CLEAR(vBigTxt);
              SendValues(vBigTxt,IdMetadata,vTitle);
              //Proceso de envio:
              DropAreaMgt.FileDropEndB2B(vTitle,IdMetadata,vBigTxt,pRecordID,pB2BRouterInvAttachement);
              IF pB2BRouterInvAttachement.GET(B2BRouterInvHeader.Code,99999) THEN BEGIN
                pB2BRouterInvAttachement.DELETE  ;
              END;

              FncGetData(FALSE,FALSE);
              }*/
        //17160 CPA. 25-05-22.END
    END;

    PROCEDURE SetFilter(vVar: Variant): Boolean;
    BEGIN
        //Se recoge el par�metro rec de la pagina que vamos a integrar.
        vVariant := vVar;
        FilterValuesCurrentLibrary := '';
    END;

    LOCAL PROCEDURE SendValues(VAR vBigText: BigText; VAR pIdMetadata: Code[20]; VAR pTitle: Text);
    VAR
        xRecRef: RecordRef;
        RecRef: RecordRef;
        i: Integer;
        FldRef: FieldRef;
        IsReadable: Boolean;
    BEGIN
        //Proceso que selecciona la definici�n del site SP y rellena una variable con toda la informaci�n del registro en cuesti�n.
        IF vVariant.ISRECORD THEN
            xRecRef.GETTABLE(vVariant)
        ELSE
            xRecRef := vVariant;

        IF xRecRef.ISTEMPORARY THEN
            EXIT;


        RecRef.OPEN(xRecRef.NUMBER);
        IF RecRef.READPERMISSION THEN BEGIN
            IsReadable := TRUE;
            IF NOT RecRef.GET(xRecRef.RECORDID) THEN
                EXIT;
        END;

        pRecordID := RecRef.RECORDID;

        ///Selecci�n estructura site
        SelectIDMetadata(pIdMetadata, RecRef);
        ///T�tulo del site debido a que puede ser un texto fijo o algo variable ("c�digo del cliente, proyecto....")
        pTitle := GetTitleLibrary(pIdMetadata, RecRef);
        ///Se informan los metadatos con el registro seleccionado.
        CreateMetadata(pIdMetadata, vBigText, RecRef, FALSE);
    END;

    LOCAL PROCEDURE SelectIDMetadata(VAR vIdMetadata: Code[20]; VAR xRecRef: RecordRef);
    VAR
        SPSiteDefinition: Record 7174651;
        xFieldRef: FieldRef;
    BEGIN
        ///Con el n�mero de tabla ya tenemos la definici�n a utilizar.
        SPSiteDefinition.RESET;
        SPSiteDefinition.SETRANGE(IdTable, xRecRef.NUMBER);
        SPSiteDefinition.SETRANGE(Status, SPSiteDefinition.Status::Released);
        SPSiteDefinition.FINDFIRST;
        vIdMetadata := SPSiteDefinition."No.";
    END;

    PROCEDURE CreateMetadata(pNoMetadata: Code[20]; VAR pDicc: BigText; VAR xRecRef: RecordRef; pBoolTesting: Boolean);
    VAR
        SPSiteMetadataDefs: Record 7174652;
        LibraryTypesSP: Record 7174654;
        LibraryTypesValuesSP: Record 7174655;
        PagLibraryValues: Page 7174661;
        CurrentLibraryTypeValuesFilter: Text;
        FldRef: FieldRef;
        intField: Integer;
        TxtField: Text[250];
        TxtName: Text[100];
        IntNumberOpt: Integer;
        intno: Boolean;
        dt: Date;
    BEGIN
        //Creaci�n de los metadatos en funci�n del tipo de campo (fijo o variable) indicado en las l�neas.
        SPSiteMetadataDefs.RESET;
        SPSiteMetadataDefs.SETRANGE("Metadata Site Definition", pNoMetadata);
        IF SPSiteMetadataDefs.FINDSET THEN
            REPEAT
                IF SPSiteMetadataDefs."Value Type" = SPSiteMetadataDefs."Value Type"::"Fixed Value" THEN BEGIN
                    IntNumberOpt := SPSiteMetadataDefs."Type Field Sharepoint";
                    TxtField := SPSiteMetadataDefs.Value;

                    IF SPSiteMetadataDefs."Type Field Sharepoint" =
                      SPSiteMetadataDefs."Type Field Sharepoint"::"Short Date" THEN BEGIN
                        IF EVALUATE(dt, FORMAT(FldRef.VALUE)) THEN
                            TxtField := FORMAT(dt, 0, '<Month,2>/<Day,2>/<Year4>')
                        ELSE
                            TxtField := '01/01/2018';
                    END;

                    IF SPSiteMetadataDefs."Type Field Sharepoint" =
                      SPSiteMetadataDefs."Type Field Sharepoint"::Boolean THEN BEGIN
                        IF EVALUATE(intno, SPSiteMetadataDefs.Value) THEN BEGIN
                            IF intno THEN
                                TxtField := '1'
                            ELSE
                                TxtField := '0';
                        END ELSE
                            TxtField := '0';
                    END;

                    pDicc.ADDTEXT('[{' + SPSiteMetadataDefs."Internal Name" + '},{' + SPSiteMetadataDefs.Name + '},{' + TxtField + '},{' + FORMAT(IntNumberOpt) + '}]|');
                END ELSE BEGIN
                    EVALUATE(intField, SPSiteMetadataDefs.Value);
                    FldRef := xRecRef.FIELD(intField);

                    ///Necesario para los campos calculados.
                    IF SPSiteMetadataDefs."Calculate Field" THEN
                        FldRef.CALCFIELD;

                    TxtField := FORMAT(FldRef.VALUE);
                    IF SPSiteMetadataDefs."Type Field Sharepoint" =
                      SPSiteMetadataDefs."Type Field Sharepoint"::"Short Date" THEN BEGIN
                        IF EVALUATE(dt, FORMAT(FldRef.VALUE)) THEN
                            TxtField := FORMAT(dt, 0, '<Month,2>/<Day,2>/<Year4>')
                        ELSE
                            TxtField := '01/01/2018';
                    END;

                    IF SPSiteMetadataDefs."Type Field Sharepoint" =
                      SPSiteMetadataDefs."Type Field Sharepoint"::Boolean THEN BEGIN
                        IF EVALUATE(intno, FORMAT(FldRef.VALUE)) THEN BEGIN
                            IF intno THEN
                                TxtField := '1'
                            ELSE
                                TxtField := '0';
                        END ELSE
                            TxtField := '0';
                    END;

                    IF TxtField <> '' THEN BEGIN
                        IntNumberOpt := SPSiteMetadataDefs."Type Field Sharepoint";
                        pDicc.ADDTEXT('[{' + SPSiteMetadataDefs."Internal Name" + '},{' + SPSiteMetadataDefs.Name + '},{' + TxtField + '},{' + FORMAT(IntNumberOpt) + '}]|')
                    END;
                END;

            UNTIL SPSiteMetadataDefs.NEXT = 0;

        ///Posibilidad de selecci�n de metadatos en funci�n del tipo de documento que se quiere enviar.
        ///Hay metadatos a seleccionar?
        LibraryTypesValuesSP.RESET;
        LibraryTypesValuesSP.SETRANGE("Metadata Site Defs", pNoMetadata);
        LibraryTypesValuesSP.SETFILTER(Value, '<>%1', '');
        IF LibraryTypesValuesSP.FINDFIRST THEN BEGIN

            IF FilterValuesCurrentLibrary = '' THEN BEGIN
                ///Se muestra la pagina, solo aparece una vez cuando se suben varios ficheros en una tanda
                CLEAR(PagLibraryValues);
                PagLibraryValues.LOOKUPMODE := TRUE;
                PagLibraryValues.EDITABLE(FALSE);
                PagLibraryValues.SETTABLEVIEW(LibraryTypesValuesSP);
                IF PagLibraryValues.RUNMODAL = ACTION::LookupOK THEN
                    CurrentLibraryTypeValuesFilter := PagLibraryValues.GetSelectionFilter;

            END ELSE BEGIN
                CurrentLibraryTypeValuesFilter := FilterValuesCurrentLibrary;
            END;

            ///Siempre que se seleccione uno..
            IF CurrentLibraryTypeValuesFilter <> '' THEN BEGIN
                LibraryTypesValuesSP.RESET;
                LibraryTypesValuesSP.SETRANGE("Metadata Site Defs", pNoMetadata);
                LibraryTypesValuesSP.SETFILTER(Value, CurrentLibraryTypeValuesFilter);
                IF LibraryTypesValuesSP.FINDSET THEN
                    REPEAT

                        IF (TxtName <> '') AND (TxtName = LibraryTypesValuesSP.Name) THEN
                            ERROR(TEXT50000);

                        ///Se busca el campo internal_name
                        LibraryTypesSP.RESET;
                        LibraryTypesSP.SETRANGE("Metadata Site Defs", pNoMetadata);
                        LibraryTypesSP.SETRANGE(Name, LibraryTypesValuesSP.Name);
                        LibraryTypesSP.FINDFIRST;

                        pDicc.ADDTEXT('[{' + LibraryTypesSP."Internal Name" + '},{' + LibraryTypesValuesSP.Name + '},{' + LibraryTypesValuesSP.Value + '},{' + '0' + '}]|');

                        TxtName := LibraryTypesValuesSP.Name;

                    UNTIL LibraryTypesValuesSP.NEXT = 0;
                FilterValuesCurrentLibrary := CurrentLibraryTypeValuesFilter;

            END;
        END;

        pDicc.ADDTEXT('|');
    END;

    LOCAL PROCEDURE GetTitleLibrary(pNoMetadata: Code[20]; VAR xRecRef: RecordRef): Text;
    VAR
        SPSiteDefinition: Record 7174651;
        FldRef: FieldRef;
        intField: Integer;
        TxtField: Text[250];
    BEGIN
        ///T�tulo de la libreria.
        SPSiteDefinition.GET(pNoMetadata);
        IF (SPSiteDefinition."Library Title Type" = SPSiteDefinition."Library Title Type"::"Fixed Value") THEN BEGIN
            EXIT(SPSiteDefinition."Library Title");
        END ELSE BEGIN
            IF SPSiteDefinition."Library Title Type" = SPSiteDefinition."Library Title Type"::"Field Value" THEN BEGIN
                EVALUATE(intField, SPSiteDefinition."Library Title");
                FldRef := xRecRef.FIELD(intField);
                TxtField := FORMAT(FldRef.VALUE);
                IF TxtField <> '' THEN
                    EXIT(TxtField)
                ELSE
                    EXIT('TEST');
            END;
        END;
    END;

    LOCAL PROCEDURE FncGetData(pOpenSP: Boolean; pAll: Boolean);
    VAR
        XDropAreaFile: Record 7174657 TEMPORARY;
        SpSiteDef: Record 7174651;
        SPSetup: Record 7174650;
        xRecRef: RecordRef;
        RecRef: RecordRef;
        SiteLibrary: Text;
        TxtLink: Text;
        vNoEntry: Integer;
        cduDropArea: Codeunit 7174650;
        DragDropFileFactbox: Record 7174657;
    BEGIN

        //Se recoge la informaci�n y se muestra el site de sharepoint o rellena el factbox con los ficheros de la libreria SP.
        //Esta funcion se llama desde las opciones.
        SPSetup.GET;
        SPSetup.TESTFIELD("Enable Integration", TRUE);

        IF vVariant.ISRECORD THEN
            xRecRef.GETTABLE(vVariant)
        ELSE
            xRecRef := vVariant;

        IF xRecRef.ISTEMPORARY THEN
            EXIT;

        RecRef.OPEN(xRecRef.NUMBER);
        IF RecRef.READPERMISSION THEN BEGIN
            IF NOT RecRef.GET(xRecRef.RECORDID) THEN
                EXIT;
        END;

        pRecordID := RecRef.RECORDID;


        SpSiteDef.RESET;
        SpSiteDef.SETRANGE(IdTable, xRecRef.NUMBER);
        SpSiteDef.SETRANGE(Status, SpSiteDef.Status::Released);
        SpSiteDef.FINDFIRST;

        SiteLibrary := cduDropArea.GetTitleLibrary(SpSiteDef."No.", RecRef);

        //Se abre el site de SP.
        IF pOpenSP THEN BEGIN

            IF SiteLibrary = '' THEN
                SiteLibrary := SPSetup."Library Name Default";

            TxtLink := SPSetup."Url Sharepoint" + '/' + SpSiteDef."Main Url" + '/' + SiteLibrary + '/Forms/AllItems.aspx';
            HYPERLINK(TxtLink);
            EXIT;
        END;

        IF SPSetup."Batch Synchronization" THEN BEGIN
            cduDropArea.GetFilesBatch(SpSiteDef);
            EXIT;
        END;

        //Recogemos los ficheros y lo indicamos en el factbox.
        CLEAR(XDropAreaFile);
        IF NOT pAll THEN BEGIN
            cduDropArea.FncGetFiles(SpSiteDef."No.", XDropAreaFile, SiteLibrary, pRecordID, FALSE)
        END ELSE BEGIN
            cduDropArea.FncGetFiles(SpSiteDef."No.", XDropAreaFile, SiteLibrary, pRecordID, TRUE);
        END;

        XDropAreaFile.RESET;
        IF XDropAreaFile.FINDSET THEN
            REPEAT
                vNoEntry := 1;
                IF DragDropFileFactbox.FINDLAST THEN
                    vNoEntry := DragDropFileFactbox."Entry No." + 1;

                DragDropFileFactbox.INIT;
                DragDropFileFactbox.TRANSFERFIELDS(XDropAreaFile);
                DragDropFileFactbox.INSERT;
            UNTIL XDropAreaFile.NEXT = 0;
    END;

    /*BEGIN
/*{
      QUONEXT 22.07.17 DRAG&DROP. Subida de ficheros a Sharepoint en batch.

      17160 CPA. 25-05-22
      Q17567 CPA 17/06/22
    }
END.*/
}









