Codeunit 7174652 "GetFile SP Batch"
{


    TableNo = 472;
    trigger OnRun()
    VAR
        cduDropArea: Codeunit 7174650;
        SPSetup: Record 7174650;
        dicc: DotNet Dictionary_Of_T_U;
        ElementPair: DotNet KeyValuePair_Of_T_U;
        // SharepointAddIn: DotNet SharepointAddIn;
        NoLin: Integer;
        metadataFiltered: BigText;
        HistorySitesSP: Record 7174656;
        rDropAreav1: Record 7174657;
        rDropArea: Record 7174657;
        SiteSpDefinition: Record 7174651;
        DropAreaFile: Record 7174653;
        vSiteName: Text[250];
        // GetFilesResponse: DotNet GetFilesListResponse;
    BEGIN


        Rec.TESTFIELD(Rec."Record ID to Process");
        RecRef.GET(Rec."Record ID to Process");
        RecRef.SETTABLE(SiteSpDefinition);
        SiteSpDefinition.FIND;


        NoLin := 1;
        rDropAreav1.RESET;
        IF rDropAreav1.FINDLAST THEN
            NoLin := rDropAreav1."Entry No." + 1;


        SPSetup.GET();
        SPSetup.TESTFIELD("Enable Integration", TRUE);

        ///Para no buscar entre los n registros de una tabla solo se busca entre lo que ha sido enviado anteriormente.
        HistorySitesSP.RESET;
        HistorySitesSP.SETRANGE("Metadata Site Definition", SiteSpDefinition."No.");
        HistorySitesSP.SETFILTER("Site Name", '<>%1', '');
        HistorySitesSP.SETFILTER("Value PKv1", '<>%1', '');
        IF HistorySitesSP.FINDSET THEN
            REPEAT
                // Ejemplo filtro
                //metadataFiltered.ADDTEXT('[{B},{PRUEBA1},{BB1}]||');
                cduDropArea.FncCreateFilter(HistorySitesSP, SiteSpDefinition."No.", metadataFiltered);

                vSiteName := HistorySitesSP."Site Name";
                IF vSiteName = SPSetup."Library Name Default" THEN
                    vSiteName := '';

                dicc := dicc.Dictionary;
                //17160 CPA. 25-05-22. BEGIN
                /*{
                                dicc := SharepointAddIn.GetFilesList(SPSetup."Url Sharepoint", SPSetup.User,
                                                          SPSetup.Pass, SiteSpDefinition."Main Url",
                                                          vSiteName, metadataFiltered);
                                }*/
                // GetFilesResponse := SharepointAddIn.GetFilesList(SPSetup."Url Sharepoint", SPSetup.User,
                //                           SPSetup.Pass, FORMAT(SPSetup."Debug Level"), SiteSpDefinition."Main Url",
                //                           //Q17567 CPA 17/06/22.Begin
                //                           //vSiteName, metadataFiltered,'');
                //                           vSiteName, metadataFiltered, SiteSpDefinition."Sharepoint folder Path");
                //Q17567 CPA 17/06/22.End

                // dicc := GetFilesResponse.DocumentList;
                //17160 CPA. 25-05-22. END


                rDropAreav1.RESET;
                rDropAreav1.SETRANGE("Sharepoint Site Definition", SiteSpDefinition."No.");
                rDropAreav1.SETRANGE(Filter, HistorySitesSP."Value PKv1");
                IF rDropAreav1.FINDSET THEN
                    rDropAreav1.DELETEALL;
                //Se obtiene un diccionario con las urls
                FOREACH ElementPair IN dicc DO BEGIN
                    rDropArea.INIT;
                    rDropArea."File Name" := FORMAT(ElementPair.Key);
                    rDropArea.Url := FORMAT(ElementPair.Value);
                    rDropArea."Entry No." := NoLin;
                    rDropArea."PK RecordID" := HistorySitesSP."Value PK"; //PRecorId;
                    rDropArea.Filter := FORMAT(HistorySitesSP."Value PKv1");
                    rDropArea."Creation Date" := CREATEDATETIME(TODAY, TIME);
                    rDropArea."Sharepoint Site Definition" := SiteSpDefinition."No.";
                    rDropArea.INSERT;
                    NoLin += 1;
                END;

            UNTIL HistorySitesSP.NEXT = 0;
    END;

    VAR
        TEXTOK: TextConst ENU = 'Subida de Ficheros terminada', ESP = 'Subida de Ficheros terminada';
        RecRef: RecordRef;

    /*BEGIN
/*{
      QUONEXT 22.07.17 DRAG&DROP. Funcionalidad para obtener los ficheros en batch que forman parte de un site-biblioteca de documentos.

      17160 CPA. 25-05-22
      Q17567 CPA 17/06/22
    }
END.*/
}









