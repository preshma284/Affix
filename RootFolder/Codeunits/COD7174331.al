Codeunit 7174331 "SII Management QS"
{


    trigger OnRun()
    BEGIN
        CreateSIIType;
        UpdateSIIEntity;
    END;

    VAR
        Text0001: TextConst ENU = 'Validaci�n - El valor del campo %1 de la tabla %2 debe estar relleno.';
        Text0002: TextConst ENU = 'Validaci�n - La Razon Social y el CIF no estan censado en la AEAT.';
        Text0003: TextConst ENU = 'Validaci�n - El valor del campo %1 de la tabla %2 no puede estar vac�o o ser superior al %3 en curso';
        Text0004: TextConst ENU = 'Validaci�n - El campo %1 de la tabla %2 no puede ser %3';
        Text0005: TextConst ENU = 'Validaci�n - El campo %1 de la tabla %2 solo puede ser %3';
        Text0006: TextConst ENU = 'Va a enviar una factura al entorno de pruebas de la %1: �Est� seguro?', ESP = 'Va a enviar una factura al entorno de pruebas de la %1: �Est� seguro?';

    //[External]
    PROCEDURE GetCertificateSerialNo(): Text[250];
    VAR
        CompanyInformation: Record 79;
        txt: Text;
        os: OutStream;
        is: InStream;
        bt: BigText;
    BEGIN
        CompanyInformation.GET;
        //EXIT(CompanyInformation."Certificate Serial No.");
    END;

    //[External]
    // PROCEDURE ExportShipment("Ship No.": Code[20]; VAR SIIExport: XMLport 7174331);
    // VAR
    //     SIIDocumentShipment: Record 7174335;
    //     TipoLibro: Code[3];
    //     RecRef: RecordRef;
    //     FRef: FieldRef;
    //     varInteger: Integer;
    // BEGIN
    //     SIIExport.SetShipNo("Ship No.");
    //     SIIDocumentShipment.GET("Ship No.");

    //     RecRef.OPEN(DATABASE::"SII Document Shipment");
    //     FRef := RecRef.FIELD(SIIDocumentShipment.FIELDNO("Document Type"));
    //     EVALUATE(varInteger, FORMAT(SIIDocumentShipment."Document Type", 2, '<Number>'));
    //     TipoLibro := SELECTSTR(varInteger + 1, FRef.OptionMembers);
    //     RecRef.CLOSE;

    //     //QuoSII1.4.04.begin
    //     IF SIIDocumentShipment."Shipment Type" = 'B0' THEN
    //         TipoLibro := 'B' + TipoLibro;
    //     //QuoSII1.4.04.end+

    //     SIIExport.SetTipoLibro(TipoLibro);

    //     SIIExport.EXPORT;
    // END;

    //[External]
    // PROCEDURE ImportAnswer(SIIImportDocError: XMLport 7174332);
    // BEGIN
    //     SIIImportDocError.IMPORT;
    // END;

    // [External]
    PROCEDURE ExportShipmentFile("Ship No.": Code[20]);
    VAR
        // SIIExport: XMLport 7174331;
        ficheroXml: File;
        ostrXML: OutStream;
        fileName: Text[300];
        SIIDocumentShipment: Record 7174335;
        TipoLibro: Code[3];
        RecRef: RecordRef;
        FRef: FieldRef;
        varInteger: Integer;
        CompanyInformation: Record 79;
    BEGIN
        CompanyInformation.GET;
        SIIDocumentShipment.GET("Ship No.");

        //SIIExport.SetShipNo("Ship No.");
        fileName := CompanyInformation."QuoSII Export SII Path" + '\';
        fileName += "Ship No.";
        fileName += '.xml';
        ficheroXml.CREATE(fileName);
        ficheroXml.CREATEOUTSTREAM(ostrXML);
        //SIIExport.SETDESTINATION(ostrXML);

        RecRef.OPEN(DATABASE::"SII Document Shipment");
        FRef := RecRef.FIELD(SIIDocumentShipment.FIELDNO("Document Type"));
        EVALUATE(varInteger, FORMAT(SIIDocumentShipment."Document Type", 2, '<Number>'));
        TipoLibro := SELECTSTR(varInteger + 1, FRef.OptionMembers);
        RecRef.CLOSE;

        //QuoSII1.4.04.begin
        IF SIIDocumentShipment."Shipment Type" = 'B0' THEN
            TipoLibro := 'B' + TipoLibro;
        //QuoSII1.4.04.end

        //SIIExport.SetTipoLibro(TipoLibro);

        //SIIExport.EXPORT;
        ficheroXml.CLOSE;
    END;

    //[External]
    PROCEDURE ProcessShipment("ShipNo.": Code[20]; UseDLL: Option " ","Client","Server"; TipoEntorno: Option "REAL","PRUEBAS");
    VAR

        QuoSIIClient: DotNet QuoSIICom;
        CompanyInformation: Record 79;
        QuoSIIServer: DotNet QuoSIICom;
        SIIDocumentShipment: Record 7174335;
    BEGIN
        CompanyInformation.GET;
        SIIDocumentShipment.GET("ShipNo.");

        //JAV 23/07/20
        OnBeforeProcessShipment;
        //JAV fin

        IF UseDLL = UseDLL::Server THEN BEGIN
            IF (NOT CompanyInformation."QuoSII Certificate".HASVALUE) OR (NOT CompanyInformation."QuoSII Certificate Password".HASVALUE) THEN
                SendMail('QuoSII', CompanyInformation."QuoSII Email From", CompanyInformation."QuoSII Email To", '', 'Error Env�os SII ' + FORMAT(TODAY), 'No se ha configurado un certificado v�lido o una contrase�a.');

            QuoSIIServer := QuoSIIServer.QuoSIICom();

            QuoSIIServer.server := CompanyInformation."QuoSII Server WS";
            QuoSIIServer.port := CompanyInformation."QuoSII Port WS";
            QuoSIIServer.instance := CompanyInformation."QuoSII Instance WS";
            QuoSIIServer.company := COMPANYNAME;
            QuoSIIServer.objectType := 'Codeunit';
            QuoSIIServer.objectName := 'SIIManagement';
            QuoSIIServer.user := CompanyInformation."QuoSII User WS";
            QuoSIIServer.password := CompanyInformation."QuoSII Pass WS";
            QuoSIIServer.domain := CompanyInformation."QuoSII Domain WS";
            QuoSIIServer.strShipment := "ShipNo.";
            QuoSIIServer.sourceDirectory(CompanyInformation."QuoSII Export SII Path");
            QuoSIIServer.version := FORMAT(CompanyInformation."QuoSII Version");//QuoSII1.4
            QuoSIIServer.CIFEmpresa := CompanyInformation."VAT Registration No.";
            QuoSIIServer.TipoApp := 'NAV';
            //QuoSII_1.4.02.042.begin
            QuoSIIServer.TipoAgencia := SIIDocumentShipment."SII Entity";
            //QuoSII_1.4.02.042.end
            //QuoSII.B9.begin
            //QuoSII.1.4.begin
            IF TipoEntorno = TipoEntorno::REAL THEN
                QuoSIIServer.TipoEntorno := 'REAL'
            ELSE
                QuoSIIServer.TipoEntorno := 'PRUEBAS';
            QuoSIIServer.isSslEnabled := CompanyInformation."QuoSII Use SSL"; //2001+
            IF TipoEntorno = TipoEntorno::PRUEBAS THEN BEGIN
                IF GUIALLOWED THEN BEGIN//QuoSII_1.4.0.014
                    IF CONFIRM(STRSUBSTNO(Text0006, SIIDocumentShipment."SII Entity"), TRUE) THEN//QuoSII_1.4.02.042.05
                        QuoSIIServer.EnvioTextXMLServer;//QuoSII_1.4.0.014
                END ELSE//QuoSII_1.4.0.014
                    QuoSIIServer.EnvioTextXMLServer;
            END ELSE
                QuoSIIServer.EnvioTextXMLServer;
            //QuoSII.1.4.end

            // IF NOT QuoSIIServer.EnvioTextXML THEN
            // SendMail('QuoSII', CompanyInformation."Email From", CompanyInformation."Email To", '' , 'Error Env�os SII ' + FORMAT(TODAY), 'error dll');
            //QuoSII.B9.end
        END ELSE BEGIN
            IF UseDLL = UseDLL::Client THEN BEGIN
                IF (NOT CompanyInformation."QuoSII Certificate".HASVALUE) OR (NOT CompanyInformation."QuoSII Certificate Password".HASVALUE) THEN
                    SendMail('QuoSII', CompanyInformation."QuoSII Email From", CompanyInformation."QuoSII Email To", '', 'Error Env�os SII ' + FORMAT(TODAY), 'No se ha configurado un certificado v�lido o una contrase�a.');

                QuoSIIClient := QuoSIIClient.QuoSIICom();

                QuoSIIClient.server := CompanyInformation."QuoSII Server WS";
                QuoSIIClient.port := CompanyInformation."QuoSII Port WS";
                QuoSIIClient.instance := CompanyInformation."QuoSII Instance WS";
                QuoSIIClient.company := COMPANYNAME;
                QuoSIIClient.objectType := 'Codeunit';
                QuoSIIClient.objectName := 'SIIManagement';
                QuoSIIClient.user := CompanyInformation."QuoSII User WS";
                QuoSIIClient.password := CompanyInformation."QuoSII Pass WS";
                QuoSIIClient.domain := CompanyInformation."QuoSII Domain WS";
                QuoSIIClient.strShipment := "ShipNo.";
                QuoSIIClient.sourceDirectory(CompanyInformation."QuoSII Export SII Path");
                QuoSIIClient.version := FORMAT(CompanyInformation."QuoSII Version");//QuoSII1.4
                QuoSIIClient.CIFEmpresa := CompanyInformation."VAT Registration No.";
                QuoSIIClient.TipoApp := 'NAV';
                //QuoSII_1.4.02.042.begin
                QuoSIIClient.TipoAgencia := SIIDocumentShipment."SII Entity";
                //QuoSII_1.4.02.042.end

                //QuoSII.B9.begin
                //QuoSII.1.4.begin
                IF TipoEntorno = TipoEntorno::REAL THEN
                    QuoSIIClient.TipoEntorno := 'REAL'
                ELSE
                    QuoSIIClient.TipoEntorno := 'PRUEBAS';
                QuoSIIClient.isSslEnabled := CompanyInformation."QuoSII Use SSL"; //2001+
                IF TipoEntorno = TipoEntorno::PRUEBAS THEN BEGIN
                    IF GUIALLOWED THEN BEGIN//QuoSII_1.4.0.014
                        IF CONFIRM(STRSUBSTNO(Text0006, SIIDocumentShipment."SII Entity"), TRUE) THEN//QuoSII_1.4.02.042.05
                            QuoSIIClient.EnvioTextXML;//QuoSII_1.4.0.014
                    END ELSE//QuoSII_1.4.0.014
                        QuoSIIClient.EnvioTextXML;
                END ELSE
                    QuoSIIClient.EnvioTextXML;//QuoSII_1.4.0.014
                                              //QuoSII.1.4.end
                                              // IF NOT QuoSIIClient.EnvioTextXML THEN
                                              // SendMail('QuoSII', CompanyInformation."Email From", CompanyInformation."Email To", '' , 'Error Env�os SII ' + FORMAT(TODAY), 'error dll');
                                              //QuoSII.B9.end

            END ELSE BEGIN
                IF CompanyInformation."QuoSII Use Server DLL" THEN BEGIN
                    IF (NOT CompanyInformation."QuoSII Certificate".HASVALUE) OR (NOT CompanyInformation."QuoSII Certificate Password".HASVALUE) THEN
                        SendMail('QuoSII', CompanyInformation."QuoSII Email From", CompanyInformation."QuoSII Email To", '', 'Error Env�os SII ' + FORMAT(TODAY), 'No se ha configurado un certificado v�lido o una contrase�a.');

                    QuoSIIServer := QuoSIIServer.QuoSIICom();

                    QuoSIIServer.server := CompanyInformation."QuoSII Server WS";
                    QuoSIIServer.port := CompanyInformation."QuoSII Port WS";
                    QuoSIIServer.instance := CompanyInformation."QuoSII Instance WS";
                    QuoSIIServer.company := COMPANYNAME;
                    QuoSIIServer.objectType := 'Codeunit';
                    QuoSIIServer.objectName := 'SIIManagement';
                    QuoSIIServer.user := CompanyInformation."QuoSII User WS";
                    QuoSIIServer.password := CompanyInformation."QuoSII Pass WS";
                    QuoSIIServer.domain := CompanyInformation."QuoSII Domain WS";
                    QuoSIIServer.strShipment := "ShipNo.";
                    QuoSIIServer.sourceDirectory(CompanyInformation."QuoSII Export SII Path");
                    QuoSIIServer.version := FORMAT(CompanyInformation."QuoSII Version");//QuoSII1.4
                    QuoSIIServer.CIFEmpresa := CompanyInformation."VAT Registration No.";
                    QuoSIIServer.TipoApp := 'NAV';
                    //QuoSII_1.4.02.042.begin
                    QuoSIIServer.TipoAgencia := SIIDocumentShipment."SII Entity";
                    //QuoSII_1.4.02.042.end

                    //QuoSII.B9.begin
                    //QuoSII.1.4.begin
                    IF TipoEntorno = TipoEntorno::REAL THEN
                        QuoSIIServer.TipoEntorno := 'REAL'
                    ELSE
                        QuoSIIServer.TipoEntorno := 'PRUEBAS';
                    QuoSIIServer.isSslEnabled := CompanyInformation."QuoSII Use SSL"; //2001+
                    IF TipoEntorno = TipoEntorno::PRUEBAS THEN BEGIN
                        IF GUIALLOWED THEN BEGIN//QuoSII_1.4.0.014
                            IF CONFIRM(STRSUBSTNO(Text0006, SIIDocumentShipment."SII Entity"), TRUE) THEN//QuoSII_1.4.02.042.05
                                QuoSIIServer.EnvioTextXMLServer;//QuoSII_1.4.0.014
                        END ELSE//QuoSII_1.4.0.014
                            QuoSIIServer.EnvioTextXMLServer;
                    END ELSE
                        QuoSIIServer.EnvioTextXMLServer;
                    //QuoSII.1.4.end
                    //IF NOT QuoSIIServer.EnvioTextXML THEN
                    //  SendMail('QuoSII', CompanyInformation."Email From", CompanyInformation."Email To", '' , 'Error Env�os SII ' + FORMAT(TODAY), 'error dll');
                    //QuoSII.B9.end
                END ELSE BEGIN
                    QuoSIIClient := QuoSIIClient.QuoSIICom();

                    QuoSIIClient.server := CompanyInformation."QuoSII Server WS";
                    QuoSIIClient.port := CompanyInformation."QuoSII Port WS";
                    QuoSIIClient.instance := CompanyInformation."QuoSII Instance WS";
                    QuoSIIClient.company := COMPANYNAME;
                    QuoSIIClient.objectType := 'Codeunit';
                    QuoSIIClient.objectName := 'SIIManagement';
                    QuoSIIClient.user := CompanyInformation."QuoSII User WS";
                    QuoSIIClient.password := CompanyInformation."QuoSII Pass WS";
                    QuoSIIClient.domain := CompanyInformation."QuoSII Domain WS";
                    QuoSIIClient.strShipment := "ShipNo.";
                    QuoSIIClient.sourceDirectory(CompanyInformation."QuoSII Export SII Path");
                    QuoSIIClient.version := FORMAT(CompanyInformation."QuoSII Version");//QuoSII1.4
                    QuoSIIClient.CIFEmpresa := CompanyInformation."VAT Registration No.";
                    QuoSIIClient.TipoApp := 'NAV';
                    //QuoSII_1.4.02.042.begin
                    QuoSIIClient.TipoAgencia := SIIDocumentShipment."SII Entity";
                    //QuoSII_1.4.02.042.end

                    //QuoSII.B9.begin
                    //QuoSII.1.4.begin
                    IF TipoEntorno = TipoEntorno::REAL THEN
                        QuoSIIClient.TipoEntorno := 'REAL'
                    ELSE
                        QuoSIIClient.TipoEntorno := 'PRUEBAS';
                    QuoSIIClient.isSslEnabled := CompanyInformation."QuoSII Use SSL"; //2001+
                    IF TipoEntorno = TipoEntorno::PRUEBAS THEN BEGIN
                        IF GUIALLOWED THEN BEGIN //QuoSII_1.4.0.014
                            IF CONFIRM(STRSUBSTNO(Text0006, SIIDocumentShipment."SII Entity"), TRUE) THEN//QuoSII_1.4.02.042.05
                                QuoSIIClient.EnvioTextXML;//QuoSII_1.4.0.014
                        END ELSE//QuoSII_1.4.0.014
                            QuoSIIClient.EnvioTextXML;
                    END ELSE
                        QuoSIIClient.EnvioTextXML;//QuoSII_1.4.0.014
                                                  //QuoSII.1.4.end
                                                  //IF NOT QuoSIIClient.EnvioTextXML THEN
                                                  // SendMail('QuoSII', CompanyInformation."Email From", CompanyInformation."Email To", '' , 'Error Env�os SII ' + FORMAT(TODAY), 'error dll');
                                                  //QuoSII.B9.end
                END;
            END;
        END;

        //JAV 23/07/20
        OnAfterProcessShipment;
        //JAV fin
    END;

    //[External]
    // PROCEDURE ExportTextXML(VAR "Ship No.": Code[20]; VAR FXML: BigText);
    // VAR
    //     SIIDocumentShipment: Record 7174335;
    //     TipoLibro: Code[3];
    //     RecRef: RecordRef;
    //     FRef: FieldRef;
    //     varInteger: Integer;
    //     SIIExport: XMLport 7174331;
    //     ins: InStream;
    //     FicheroXML: OutStream;
    //     recTempBlob: Codeunit "Temp Blob";
    //     arch: File;
    // BEGIN
    //     SIIExport.SetShipNo("Ship No.");
    //     SIIDocumentShipment.GET("Ship No.");

    //     RecRef.OPEN(DATABASE::"SII Document Shipment");
    //     FRef := RecRef.FIELD(SIIDocumentShipment.FIELDNO("Document Type"));
    //     EVALUATE(varInteger, FORMAT(SIIDocumentShipment."Document Type", 2, '<Number>'));
    //     TipoLibro := SELECTSTR(varInteger + 1, FRef.OptionMembers);
    //     RecRef.CLOSE;

    //     //QuoSII1.4.04.begin
    //     IF SIIDocumentShipment."Shipment Type" = 'B0' THEN
    //         TipoLibro := 'B' + TipoLibro;
    //     //QuoSII1.4.04.end

    //     SIIExport.SetTipoLibro(TipoLibro);

    //     CLEAR(ins);
    //     CLEAR(FicheroXML);
    //     //CLEAR(recTempBlob);

    //     // recTempBlob."Primary Key" := 1;
    //     // recTempBlob.INSERT;

    //     recTempBlob.CreateOutStream(FicheroXML, TextEncoding::Windows);
    //     SIIExport.SETDESTINATION(FicheroXML);
    //     SIIExport.EXPORT;

    //     //recTempBlob.MODIFY;
    //     recTempBlob.CreateInStream(ins, TextEncoding::Windows);
    //     //FXML.READ(ins);
    //     ins.Read(FXML);
    //     //recTempBlob.DELETEALL;
    // END;

    //[External]
    PROCEDURE FieldsValidations(ShipNo: Code[20]);
    VAR
        SIIDocumentShipment: Record 7174335;
        SIIDocumentShipmentLine: Record 7174336;
        CompanyInformation: Record 79;
        SIIDocument: Record 7174333;
        Customer: Record 18;
        Vendor: Record 23;
        SIIDocumentError: Record 7174332;
        CountryRegion: Record 9;
        ValidacionAEAT: Boolean;
        RespestaAEAT: Text[250];
        Text0001: TextConst ESP = 'Validaci�n - El valor del campo %1 de la tabla %2 debe estar relleno.';
        Text0002: TextConst ESP = 'Validaci�n - La Razon Social y el CIF no estan censado en la AEAT.';
        Text0003: TextConst ESP = 'Validaci�n - El valor del campo %1 de la tabla %2 no puede estar vac�o o ser superior al %3 en curso';
        Text0004: TextConst ESP = 'Validaci�n - El campo %1 de la tabla %2 no puede ser %3';
        Text0005: TextConst ESP = 'Validaci�n - El campo %1 de la tabla %2 solo puede ser %3';
    BEGIN
        // QUOSII_02_06 -->
        CompanyInformation.GET;

        IF CompanyInformation.Name = '' THEN BEGIN
            CLEAR(SIIDocumentError);
            SIIDocumentError.RESET;
            SIIDocumentError.INIT;
            SIIDocumentError."Ship No." := ShipNo;
            SIIDocumentError."Document No." := '';
            SIIDocumentError."Error Desc" :=
              STRSUBSTNO(Text0001, CompanyInformation.FIELDCAPTION(Name), CompanyInformation.TABLECAPTION);
            SIIDocumentError.HoraEnvio := CURRENTDATETIME;
            SIIDocumentError.INSERT;
        END;

        IF CompanyInformation."VAT Registration No." = '' THEN BEGIN
            CLEAR(SIIDocumentError);
            SIIDocumentError.RESET;
            SIIDocumentError.INIT;
            SIIDocumentError."Ship No." := ShipNo;
            SIIDocumentError."Document No." := '';
            SIIDocumentError."Error Desc" :=
              STRSUBSTNO(Text0001, CompanyInformation.FIELDCAPTION("VAT Registration No."), CompanyInformation.TABLECAPTION);
            SIIDocumentError.HoraEnvio := CURRENTDATETIME;
            SIIDocumentError.INSERT;
        END;

        SIIDocumentShipment.RESET;
        SIIDocumentShipment.SETRANGE("Ship No.", ShipNo);
        IF SIIDocumentShipment.FINDSET THEN BEGIN
            IF SIIDocumentShipment."Shipment Type" = '' THEN BEGIN
                CLEAR(SIIDocumentError);
                SIIDocumentError.RESET;
                SIIDocumentError.INIT;
                SIIDocumentError."Ship No." := ShipNo;
                SIIDocumentError."Document No." := '';
                SIIDocumentError."Error Desc" := STRSUBSTNO(Text0001, SIIDocumentShipment.FIELDCAPTION("Shipment Type"), SIIDocumentShipment.TABLECAPTION);
                SIIDocumentError.HoraEnvio := CURRENTDATETIME;
                SIIDocumentError.INSERT;
            END;

            IF SIIDocumentShipment."Document Type" = SIIDocumentShipment."Document Type"::" " THEN BEGIN
                CLEAR(SIIDocumentError);
                SIIDocumentError.RESET;
                SIIDocumentError.INIT;
                SIIDocumentError."Ship No." := ShipNo;
                SIIDocumentError."Document No." := '';
                SIIDocumentError."Error Desc" := STRSUBSTNO(Text0001, SIIDocumentShipment.FIELDCAPTION("Document Type"), SIIDocumentShipment.TABLECAPTION);
                SIIDocumentError.HoraEnvio := CURRENTDATETIME;
                SIIDocumentError.INSERT;
            END;
        END;

        SIIDocumentShipmentLine.RESET;
        SIIDocumentShipmentLine.SETRANGE("Ship No.", ShipNo);
        IF SIIDocumentShipmentLine.FINDSET THEN
            REPEAT

                SIIDocument.RESET;
                SIIDocument.SETRANGE("Document No.", SIIDocumentShipmentLine."Document No.");
                SIIDocument.SETRANGE("Document Type", SIIDocumentShipmentLine."Document Type");
                SIIDocument.SETRANGE("VAT Registration No.", SIIDocumentShipmentLine."VAT Registration No.");
                //-QuoSII1.4.03
                SIIDocument.SETRANGE("Entry No.", SIIDocumentShipmentLine."Entry No.");
                SIIDocument.SETRANGE("Register Type", SIIDocumentShipmentLine."Register Type"); //JAV
                                                                                                //+QuoSII1.4.03
                IF SIIDocument.FINDFIRST THEN BEGIN
                    IF (SIIDocument.Year = 0) OR (SIIDocument.Year > (DATE2DMY(TODAY, 3))) THEN BEGIN
                        CLEAR(SIIDocumentError);
                        SIIDocumentError.RESET;
                        SIIDocumentError.INIT;
                        SIIDocumentError."Ship No." := ShipNo;
                        SIIDocumentError."Document No." := SIIDocumentShipmentLine."Document No.";
                        SIIDocumentError."Error Desc" := STRSUBSTNO(Text0003, SIIDocument.FIELDCAPTION(Year), SIIDocument.TABLECAPTION, 'a�o');
                        SIIDocumentError.HoraEnvio := CURRENTDATETIME;
                        SIIDocumentError.INSERT;
                    END;
                    //IF (SIIDocument.Period = '') OR (SIIDocument.Period > FORMAT((DATE2DMY(TODAY,2)))) THEN BEGIN
                    //QuoSII1.4.03
                    IF (SIIDocument.Period = '') OR ((SIIDocument.Year = (DATE2DMY(TODAY, 3))) AND (SIIDocument.Period > FORMAT((DATE2DMY(TODAY, 2))))) THEN BEGIN
                        CLEAR(SIIDocumentError);
                        SIIDocumentError.RESET;
                        SIIDocumentError.INIT;
                        SIIDocumentError."Ship No." := ShipNo;
                        SIIDocumentError."Document No." := SIIDocumentShipmentLine."Document No.";
                        SIIDocumentError."Error Desc" := STRSUBSTNO(Text0003, SIIDocument.FIELDCAPTION(Period), SIIDocument.TABLECAPTION, 'mes');
                        SIIDocumentError.HoraEnvio := CURRENTDATETIME;
                        SIIDocumentError.INSERT;
                    END;

                    IF SIIDocument."Document Type" IN [SIIDocument."Document Type"::FE, SIIDocument."Document Type"::FR, SIIDocument."Document Type"::OI] THEN BEGIN
                        IF SIIDocument."Invoice Type" = '' THEN BEGIN
                            CLEAR(SIIDocumentError);
                            SIIDocumentError.RESET;
                            SIIDocumentError.INIT;
                            SIIDocumentError."Ship No." := ShipNo;
                            SIIDocumentError."Document No." := SIIDocumentShipmentLine."Document No.";
                            SIIDocumentError."Error Desc" := STRSUBSTNO(Text0001, SIIDocument.FIELDCAPTION("Invoice Type"), SIIDocument.TABLECAPTION);
                            SIIDocumentError.HoraEnvio := CURRENTDATETIME;
                            SIIDocumentError.INSERT;
                        END;

                        IF SIIDocument."Cust/Vendor Name" = '' THEN BEGIN
                            CLEAR(SIIDocumentError);
                            SIIDocumentError.RESET;
                            SIIDocumentError.INIT;
                            SIIDocumentError."Ship No." := ShipNo;
                            SIIDocumentError."Document No." := SIIDocumentShipmentLine."Document No.";
                            SIIDocumentError."Error Desc" := STRSUBSTNO(Text0001, SIIDocument.FIELDCAPTION("Cust/Vendor Name"), SIIDocument.TABLECAPTION);
                            SIIDocumentError.HoraEnvio := CURRENTDATETIME;
                            SIIDocumentError.INSERT;
                        END;

                        IF SIIDocument."Document Type" = SIIDocument."Document Type"::OI THEN BEGIN
                            IF SIIDocument."Declarate Key UE" = '' THEN BEGIN
                                CLEAR(SIIDocumentError);
                                SIIDocumentError.RESET;
                                SIIDocumentError.INIT;
                                SIIDocumentError."Ship No." := ShipNo;
                                SIIDocumentError."Document No." := SIIDocumentShipmentLine."Document No.";
                                SIIDocumentError."Error Desc" := STRSUBSTNO(Text0001, SIIDocument.FIELDCAPTION("Declarate Key UE"), SIIDocument.TABLECAPTION);
                                SIIDocumentError.HoraEnvio := CURRENTDATETIME;
                                SIIDocumentError.INSERT;
                            END;

                            IF SIIDocument."UE Country" = '' THEN BEGIN
                                CLEAR(SIIDocumentError);
                                SIIDocumentError.RESET;
                                SIIDocumentError.INIT;
                                SIIDocumentError."Ship No." := ShipNo;
                                SIIDocumentError."Document No." := SIIDocumentShipmentLine."Document No.";
                                SIIDocumentError."Error Desc" := STRSUBSTNO(Text0001, SIIDocument.FIELDCAPTION("UE Country"), SIIDocument.TABLECAPTION);
                                SIIDocumentError.HoraEnvio := CURRENTDATETIME;
                                SIIDocumentError.INSERT;
                            END;

                            IF SIIDocument."Bienes Description" = '' THEN BEGIN
                                CLEAR(SIIDocumentError);
                                SIIDocumentError.RESET;
                                SIIDocumentError.INIT;
                                SIIDocumentError."Ship No." := ShipNo;
                                SIIDocumentError."Document No." := SIIDocumentShipmentLine."Document No.";
                                SIIDocumentError."Error Desc" := STRSUBSTNO(Text0001, SIIDocument.FIELDCAPTION("Bienes Description"), SIIDocument.TABLECAPTION);
                                SIIDocumentError.HoraEnvio := CURRENTDATETIME;
                                SIIDocumentError.INSERT;
                            END;

                            IF SIIDocument."Operator Address" = '' THEN BEGIN
                                CLEAR(SIIDocumentError);
                                SIIDocumentError.RESET;
                                SIIDocumentError.INIT;
                                SIIDocumentError."Ship No." := ShipNo;
                                SIIDocumentError."Document No." := SIIDocumentShipmentLine."Document No.";
                                SIIDocumentError."Error Desc" := STRSUBSTNO(Text0001, SIIDocument.FIELDCAPTION("Operator Address"), SIIDocument.TABLECAPTION);
                                SIIDocumentError.HoraEnvio := CURRENTDATETIME;
                                SIIDocumentError.INSERT;
                            END;
                        END;

                        IF SIIDocument."Document Type" IN [SIIDocument."Document Type"::FE, SIIDocument."Document Type"::FR] THEN BEGIN
                            IF SIIDocument."Special Regime" = '' THEN BEGIN
                                CLEAR(SIIDocumentError);
                                SIIDocumentError.RESET;
                                SIIDocumentError.INIT;
                                SIIDocumentError."Ship No." := ShipNo;
                                SIIDocumentError."Document No." := SIIDocumentShipmentLine."Document No.";
                                SIIDocumentError."Error Desc" := STRSUBSTNO(Text0001, SIIDocument.FIELDCAPTION("Special Regime"), SIIDocument.TABLECAPTION);
                                SIIDocumentError.HoraEnvio := CURRENTDATETIME;
                                SIIDocumentError.INSERT;
                            END;

                            IF (SIIDocument."Posting Date" > TODAY) OR (DATE2DMY(SIIDocument."Posting Date", 3) < (DATE2DMY(TODAY, 3) - 20)) THEN BEGIN
                                CLEAR(SIIDocumentError);
                                SIIDocumentError.RESET;
                                SIIDocumentError.INIT;
                                SIIDocumentError."Ship No." := ShipNo;
                                SIIDocumentError."Document No." := SIIDocumentShipmentLine."Document No.";
                                SIIDocumentError."Error Desc" := STRSUBSTNO(Text0004, SIIDocument.FIELDCAPTION("Document Date"), SIIDocument.TABLECAPTION,
                                                                            'superior a la fecha actual ni inferior a la fecha actual menos 20 a�os');
                                SIIDocumentError.HoraEnvio := CURRENTDATETIME;
                                SIIDocumentError.INSERT;
                            END;

                            IF SIIDocumentShipmentLine."Document Type" = SIIDocumentShipmentLine."Document Type"::FE THEN BEGIN
                                IF SIIDocument."Document Date" <> 0D THEN
                                    IF DATE2DMY(SIIDocument."Document Date", 3) < (DATE2DMY(TODAY, 3) - 20) THEN BEGIN
                                        CLEAR(SIIDocumentError);
                                        SIIDocumentError.RESET;
                                        SIIDocumentError.INIT;
                                        SIIDocumentError."Ship No." := ShipNo;
                                        SIIDocumentError."Document No." := SIIDocumentShipmentLine."Document No.";
                                        SIIDocumentError."Error Desc" := STRSUBSTNO(Text0004, SIIDocument.FIELDCAPTION("Document Date"),
                                                                                    SIIDocument.TABLECAPTION, 'inferior a la fecha actual menos 20 a�os');
                                        SIIDocumentError.HoraEnvio := CURRENTDATETIME;
                                        SIIDocumentError.INSERT;
                                    END;

                                IF (SIIDocument."Invoice Type" = 'F1') THEN BEGIN //QuoSII1.4.03
                                    Customer.RESET;
                                    Customer.SETRANGE("No.", SIIDocument."Cust/Vendor No.");
                                    IF Customer.FINDFIRST THEN
                                        IF Customer."VAT Registration No." = '' THEN BEGIN
                                            CLEAR(SIIDocumentError);
                                            SIIDocumentError.RESET;
                                            SIIDocumentError.INIT;
                                            SIIDocumentError."Ship No." := ShipNo;
                                            SIIDocumentError."Document No." := SIIDocumentShipmentLine."Document No.";
                                            SIIDocumentError."Error Desc" := STRSUBSTNO(Text0001, Customer.FIELDCAPTION("VAT Registration No."),
                                                                                        Customer.TABLECAPTION);
                                            SIIDocumentError.HoraEnvio := CURRENTDATETIME;
                                            SIIDocumentError.INSERT;
                                        END;

                                    CountryRegion.RESET;
                                    CountryRegion.SETRANGE(Code, Customer."Country/Region Code");
                                    IF CountryRegion.FINDFIRST THEN BEGIN
                                        IF CountryRegion."EU Country/Region Code" = 'ES' THEN BEGIN
                                            IF Customer."QuoSII VAT Reg No. Type" <> '' THEN//QuoSII_1.4.02.042
                                                IF Customer."QuoSII VAT Reg No. Type" <> '07' THEN BEGIN//QuoSII_1.4.02.042
                                                    CLEAR(SIIDocumentError);
                                                    SIIDocumentError.RESET;
                                                    SIIDocumentError.INIT;
                                                    SIIDocumentError."Ship No." := ShipNo;
                                                    SIIDocumentError."Document No." := SIIDocumentShipmentLine."Document No.";
                                                    SIIDocumentError."Error Desc" := STRSUBSTNO(Text0005, Customer.FIELDCAPTION("QuoSII VAT Reg No. Type"),
                                                                                                Customer.TABLECAPTION, 'No Censado');
                                                    SIIDocumentError.HoraEnvio := CURRENTDATETIME;
                                                    SIIDocumentError.INSERT;
                                                END;
                                        END ELSE
                                            IF Customer."QuoSII VAT Reg No. Type" = '' THEN BEGIN//QuoSII_1.4.02.042
                                                CLEAR(SIIDocumentError);
                                                SIIDocumentError.RESET;
                                                SIIDocumentError.INIT;
                                                SIIDocumentError."Ship No." := ShipNo;
                                                SIIDocumentError."Document No." := SIIDocumentShipmentLine."Document No.";
                                                SIIDocumentError."Error Desc" := STRSUBSTNO(Text0001, Customer.FIELDCAPTION("QuoSII VAT Reg No. Type"),
                                                                                            Customer.TABLECAPTION);
                                                SIIDocumentError.HoraEnvio := CURRENTDATETIME;
                                                SIIDocumentError.INSERT;
                                            END ELSE
                                                IF Customer."QuoSII VAT Reg No. Type" = '07' THEN BEGIN //QuoSII_1.4.02.042
                                                    CLEAR(SIIDocumentError);
                                                    SIIDocumentError.RESET;
                                                    SIIDocumentError.INIT;
                                                    SIIDocumentError."Ship No." := ShipNo;
                                                    SIIDocumentError."Document No." := SIIDocumentShipmentLine."Document No.";
                                                    SIIDocumentError."Error Desc" := STRSUBSTNO(Text0004, Customer.FIELDCAPTION("QuoSII VAT Reg No. Type"),
                                                                                                Customer.TABLECAPTION, 'No Censado');
                                                    SIIDocumentError.HoraEnvio := CURRENTDATETIME;
                                                    SIIDocumentError.INSERT;
                                                END;
                                    END;
                                END;
                            END;

                            IF SIIDocumentShipmentLine."Document Type" = SIIDocumentShipmentLine."Document Type"::FR THEN BEGIN
                                IF (SIIDocument."Invoice Type" = 'F1') THEN BEGIN //QuoSII1.4.03
                                    Vendor.RESET;
                                    Vendor.SETRANGE("No.", SIIDocument."Cust/Vendor No.");
                                    IF Vendor.FINDFIRST THEN BEGIN
                                        IF Vendor."VAT Registration No." = '' THEN BEGIN
                                            CLEAR(SIIDocumentError);
                                            SIIDocumentError.RESET;
                                            SIIDocumentError.INIT;
                                            SIIDocumentError."Ship No." := ShipNo;
                                            SIIDocumentError."Document No." := SIIDocumentShipmentLine."Document No.";
                                            SIIDocumentError."Error Desc" := STRSUBSTNO(Text0001, Vendor.FIELDCAPTION("VAT Registration No."),
                                                                                        Vendor.TABLECAPTION);
                                            SIIDocumentError.HoraEnvio := CURRENTDATETIME;
                                            SIIDocumentError.INSERT;
                                        END;
                                        IF Vendor.Name = '' THEN BEGIN
                                            CLEAR(SIIDocumentError);
                                            SIIDocumentError.RESET;
                                            SIIDocumentError.INIT;
                                            SIIDocumentError."Ship No." := ShipNo;
                                            SIIDocumentError."Document No." := SIIDocumentShipmentLine."Document No.";
                                            SIIDocumentError."Error Desc" := STRSUBSTNO(Text0001, Vendor.FIELDCAPTION(Name), Vendor.TABLECAPTION);
                                            SIIDocumentError.HoraEnvio := CURRENTDATETIME;
                                            SIIDocumentError.INSERT;
                                        END;
                                        IF Vendor."QuoSII VAT Reg No. Type" = '07' THEN BEGIN  //QuoSII_1.4.02.042
                                            CLEAR(SIIDocumentError);
                                            SIIDocumentError.RESET;
                                            SIIDocumentError.INIT;
                                            SIIDocumentError."Ship No." := ShipNo;
                                            SIIDocumentError."Document No." := SIIDocumentShipmentLine."Document No.";
                                            SIIDocumentError."Error Desc" := STRSUBSTNO(Text0004, Vendor.FIELDCAPTION("QuoSII VAT Reg No. Type"),
                                                                                        Vendor.TABLECAPTION, 'No Censado');
                                            SIIDocumentError.HoraEnvio := CURRENTDATETIME;
                                            SIIDocumentError.INSERT;
                                        END;
                                        IF SIIDocument."Document Date" <> 0D THEN
                                            IF (SIIDocument."Document Date" > TODAY) OR (DATE2DMY(SIIDocument."Document Date", 3) < (DATE2DMY(TODAY, 3) - 20)) THEN BEGIN
                                                CLEAR(SIIDocumentError);
                                                SIIDocumentError.RESET;
                                                SIIDocumentError.INIT;
                                                SIIDocumentError."Ship No." := ShipNo;
                                                SIIDocumentError."Document No." := SIIDocumentShipmentLine."Document No.";
                                                SIIDocumentError."Error Desc" := STRSUBSTNO(Text0004, SIIDocument.FIELDCAPTION("Document Date"),
                                                                                            SIIDocument.TABLECAPTION,
                                                                                      'superior a la fecha actual ni inferior a la fecha actual menos 20 a�os');
                                                SIIDocumentError.HoraEnvio := CURRENTDATETIME;
                                                SIIDocumentError.INSERT;
                                            END;
                                    END;
                                END;
                            END;
                        END;
                    END;

                    IF SIIDocumentShipmentLine."Document Type" = SIIDocumentShipmentLine."Document Type"::CE THEN BEGIN
                        IF SIIDocument."Document Date" <> 0D THEN
                            IF DATE2DMY(SIIDocument."Document Date", 3) < (DATE2DMY(TODAY, 3) - 20) THEN BEGIN
                                CLEAR(SIIDocumentError);
                                SIIDocumentError.RESET;
                                SIIDocumentError.INIT;
                                SIIDocumentError."Ship No." := ShipNo;
                                SIIDocumentError."Document No." := SIIDocumentShipmentLine."Document No.";
                                SIIDocumentError."Error Desc" := STRSUBSTNO(Text0004, SIIDocument.FIELDCAPTION("Document Date"), SIIDocument.TABLECAPTION,
                                                                            'inferior a la fecha actual menos 20 a�os');
                                SIIDocumentError.HoraEnvio := CURRENTDATETIME;
                                SIIDocumentError.INSERT;
                            END;

                        Customer.RESET;
                        Customer.SETRANGE("No.", SIIDocument."Cust/Vendor No.");
                        IF Customer.FINDFIRST THEN
                            IF (Customer."VAT Registration No." = '') THEN BEGIN
                                CLEAR(SIIDocumentError);
                                SIIDocumentError.RESET;
                                SIIDocumentError.INIT;
                                SIIDocumentError."Ship No." := ShipNo;
                                SIIDocumentError."Document No." := SIIDocumentShipmentLine."Document No.";
                                SIIDocumentError."Error Desc" := STRSUBSTNO(Text0001, Customer.FIELDCAPTION("VAT Registration No."), Customer.TABLECAPTION);
                                SIIDocumentError.HoraEnvio := CURRENTDATETIME;
                                SIIDocumentError.INSERT;
                            END;
                    END;


                    IF SIIDocumentShipmentLine."Document Type" = SIIDocumentShipmentLine."Document Type"::PR THEN BEGIN
                        Vendor.RESET;
                        Vendor.SETRANGE("No.", SIIDocument."Cust/Vendor No.");
                        IF Vendor.FINDFIRST THEN BEGIN
                            IF Vendor."VAT Registration No." = '' THEN BEGIN
                                CLEAR(SIIDocumentError);
                                SIIDocumentError.RESET;
                                SIIDocumentError.INIT;
                                SIIDocumentError."Ship No." := ShipNo;
                                SIIDocumentError."Document No." := SIIDocumentShipmentLine."Document No.";
                                SIIDocumentError."Error Desc" := STRSUBSTNO(Text0001, Vendor.FIELDCAPTION("VAT Registration No."), Vendor.TABLECAPTION);
                                SIIDocumentError.HoraEnvio := CURRENTDATETIME;
                                SIIDocumentError.INSERT;
                            END;
                            IF Vendor.Name = '' THEN BEGIN
                                CLEAR(SIIDocumentError);
                                SIIDocumentError.RESET;
                                SIIDocumentError.INIT;
                                SIIDocumentError."Ship No." := ShipNo;
                                SIIDocumentError."Document No." := SIIDocumentShipmentLine."Document No.";
                                SIIDocumentError."Error Desc" := STRSUBSTNO(Text0001, Vendor.FIELDCAPTION(Name), Vendor.TABLECAPTION);
                                SIIDocumentError.HoraEnvio := CURRENTDATETIME;
                                SIIDocumentError.INSERT;
                            END;
                            IF SIIDocument."Document Date" <> 0D THEN
                                IF (SIIDocument."Document Date" > TODAY) OR (DATE2DMY(SIIDocument."Document Date", 3) < (DATE2DMY(TODAY, 3) - 20)) THEN BEGIN
                                    CLEAR(SIIDocumentError);
                                    SIIDocumentError.RESET;
                                    SIIDocumentError.INIT;
                                    SIIDocumentError."Ship No." := ShipNo;
                                    SIIDocumentError."Document No." := SIIDocumentShipmentLine."Document No.";
                                    SIIDocumentError."Error Desc" := STRSUBSTNO(Text0004, SIIDocument.FIELDCAPTION("Document Date"), SIIDocument.TABLECAPTION,
                                                                                'superior a la fecha actual ni inferior a la fecha actual menos 20 a�os');
                                    SIIDocumentError.HoraEnvio := CURRENTDATETIME;
                                    SIIDocumentError.INSERT;
                                END;
                        END;
                    END;
                END;
            UNTIL SIIDocumentShipmentLine.NEXT = 0;

        //QUOSII_02_06 <--
    END;

    //[External]
    PROCEDURE SendMail(SenderName: Text; SenderEmail: Text; ReceiptEmail: Text; BCCEmail: Text; Subject: Text; Body: Text);
    VAR
        SMTPMail: Codeunit 50355;
    BEGIN
        //QUOSII_02_05 -->
        CLEAR(SMTPMail);
        SMTPMail.CreateMessage(SenderName, SenderEmail, ReceiptEmail, Subject, Body, FALSE);
        //[Syntax for the Createmessage function - Createmessage([sender's name] ,[sender's id],[recipient's id or ids],[subject] ,[body line] ,[html formatted or not]]
        IF BCCEmail <> '' THEN
            SMTPMail.AddBCC(BCCEmail);
        SMTPMail.Send;
        //QUOSII_02_05 <--
    END;

    //[External]
    PROCEDURE CSVExportEntries(TipoExportacion: Option "Customer","Vendor");
    VAR
        CompanyInformation: Record 79;
        opcion: Integer;
        txtOpcionesDescarga: TextConst ESP = 'Descargar semestre completo en un �nico fichero,Descargar semestre completo en ficheros mensuales, Descargar Enero, Descargar Febrero, Descargar Marzo, Descargar Abril, Descargar Mayo, Descargar Junio';
    BEGIN
        //QuoSII.B9.Begin
        //QuoSII_05-BEGIN
        opcion := DIALOG.STRMENU(txtOpcionesDescarga);

        CASE opcion OF
            1:
                CSVExportEntriesFiles(DMY2DATE(1, 1, 2017), DMY2DATE(30, 6, 2017), 'Completo', TipoExportacion);
            2:
                BEGIN
                    CSVExportEntriesFiles(DMY2DATE(1, 1, 2017), DMY2DATE(31, 1, 2017), 'Enero', TipoExportacion);
                    CSVExportEntriesFiles(DMY2DATE(1, 2, 2017), DMY2DATE(28, 2, 2017), 'Febrero', TipoExportacion);
                    CSVExportEntriesFiles(DMY2DATE(1, 3, 2017), DMY2DATE(31, 3, 2017), 'Marzo', TipoExportacion);
                    CSVExportEntriesFiles(DMY2DATE(1, 4, 2017), DMY2DATE(30, 4, 2017), 'Abril', TipoExportacion);
                    CSVExportEntriesFiles(DMY2DATE(1, 5, 2017), DMY2DATE(31, 5, 2017), 'Mayo', TipoExportacion);
                    CSVExportEntriesFiles(DMY2DATE(1, 6, 2017), DMY2DATE(30, 6, 2017), 'Junio', TipoExportacion);
                END;
            3:
                CSVExportEntriesFiles(DMY2DATE(1, 1, 2017), DMY2DATE(31, 1, 2017), 'Enero', TipoExportacion);
            4:
                CSVExportEntriesFiles(DMY2DATE(1, 2, 2017), DMY2DATE(28, 2, 2017), 'Febrero', TipoExportacion);
            5:
                CSVExportEntriesFiles(DMY2DATE(1, 3, 2017), DMY2DATE(31, 3, 2017), 'Marzo', TipoExportacion);
            6:
                CSVExportEntriesFiles(DMY2DATE(1, 4, 2017), DMY2DATE(30, 4, 2017), 'Abril', TipoExportacion);
            7:
                CSVExportEntriesFiles(DMY2DATE(1, 5, 2017), DMY2DATE(31, 5, 2017), 'Mayo', TipoExportacion);
            8:
                CSVExportEntriesFiles(DMY2DATE(1, 6, 2017), DMY2DATE(30, 6, 2017), 'Junio', TipoExportacion);
        END;

        //QuoSII_05-END
        //QuoSII.B9.End
    END;

    //[External]
    PROCEDURE CSVImportEntries(TipoExportacion: Option "Customer","Vendor");
    VAR
        FicheroCustomer: File;
        FicheroVendor: File;
        inSTRVendor: InStream;
        inSTRCustomer: InStream;
        CustLedgerEntry: Record 21;
        VendorLedgerEntry: Record 25;
        Txt: Text[300];
        TempString: Text[300];
        SkipFirst: Boolean;
        CompanyInformation: Record 79;
        FileManagement: Codeunit 419;
        selectedFile: Text[300];
        tofile: Text[300];
    BEGIN
        //QuoSII.B9.Begin
        //QuoSII_05-BEGIN
        CompanyInformation.RESET;
        IF NOT CompanyInformation.GET THEN
            ERROR('No se encontraron los datos de Informaci�n de empresa.');
        IF CompanyInformation."QuoSII Export SII Path" = '' THEN
            ERROR('Ha de configurar la ruta de exportaci�n SII en la Informaci�n de Compa��a');

        IF TipoExportacion = TipoExportacion::Vendor THEN BEGIN
            UPLOADINTOSTREAM('subir fichero', CompanyInformation."QuoSII Export SII Path" + '\Vendor\', 'csv file(*.csv)|*.csv', tofile, inSTRVendor);
            SkipFirst := TRUE;
            WHILE NOT (inSTRVendor.EOS) DO BEGIN
                IF SkipFirst THEN BEGIN
                    SkipFirst := FALSE;
                    inSTRVendor.READTEXT(Txt);
                END ELSE BEGIN
                    CLEAR(VendorLedgerEntry);
                    VendorLedgerEntry.RESET;

                    inSTRVendor.READTEXT(Txt);
                    TempString := CONVERTSTR(Txt, ';', ',');

                    VendorLedgerEntry.SETFILTER("Entry No.", SELECTSTR(1, TempString));
                    VendorLedgerEntry.SETFILTER("Posting Date", SELECTSTR(2, TempString));
                    VendorLedgerEntry.SETFILTER("Document No.", SELECTSTR(3, TempString));
                    IF (LOWERCASE(SELECTSTR(4, TempString)) = 'invoice') OR (LOWERCASE(SELECTSTR(4, TempString)) = 'factura') THEN
                        VendorLedgerEntry.SETRANGE("Document Type", VendorLedgerEntry."Document Type"::Invoice)
                    ELSE BEGIN
                        IF (LOWERCASE(SELECTSTR(4, TempString)) = 'credit memo') OR (LOWERCASE(SELECTSTR(4, TempString)) = 'abono') THEN
                            VendorLedgerEntry.SETRANGE("Document Type", VendorLedgerEntry."Document Type"::"Credit Memo")
                        ELSE
                            VendorLedgerEntry.SETRANGE("Document Type", VendorLedgerEntry."Document Type"::Payment);
                    END;

                    IF VendorLedgerEntry.FINDFIRST THEN BEGIN
                        VendorLedgerEntry."QuoSII Purch. Invoice Type" := DELCHR(SELECTSTR(5, TempString), '<>', ' ');//QuoSII_1.4.02.042
                        VendorLedgerEntry."QuoSII Purch. Corr. Inv. Type" := DELCHR(SELECTSTR(6, TempString), '<>', ' ');//QuoSII_1.4.02.042
                        VendorLedgerEntry."QuoSII Purch. Cr.Memo Type" := DELCHR(SELECTSTR(7, TempString), '<>', ' ');//QuoSII_1.4.02.042
                        VendorLedgerEntry."QuoSII Purch. UE Inv Type" := DELCHR(SELECTSTR(8, TempString), '<>', ' ');//QuoSII_1.4.02.042
                        VendorLedgerEntry."QuoSII UE Country" := SELECTSTR(9, TempString);
                        VendorLedgerEntry."QuoSII Operator Address" := SELECTSTR(10, TempString);
                        VendorLedgerEntry."QuoSII Last Ticket No." := SELECTSTR(11, TempString);
                        IF (SELECTSTR(12, TempString) = '1') THEN
                            VendorLedgerEntry."QuoSII Third Party" := TRUE
                        ELSE
                            VendorLedgerEntry."QuoSII Third Party" := FALSE;
                        VendorLedgerEntry."QuoSII Bienes Description" := SELECTSTR(13, TempString);

                        IF VendorLedgerEntry.MODIFY THEN
                            COMMIT
                        ELSE
                            MESSAGE('Error en ' + FORMAT(VendorLedgerEntry."Entry No."));
                    END;
                END;
            END;
        END ELSE
            IF TipoExportacion = TipoExportacion::Customer THEN BEGIN
                UPLOADINTOSTREAM('subir fichero', CompanyInformation."QuoSII Export SII Path" + '\Customer\', 'csv file(*.csv)|*.csv', tofile, inSTRCustomer);
                SkipFirst := TRUE;
                WHILE NOT (inSTRCustomer.EOS) DO BEGIN
                    IF SkipFirst THEN BEGIN
                        SkipFirst := FALSE;
                        inSTRCustomer.READTEXT(Txt);
                    END ELSE BEGIN
                        CLEAR(CustLedgerEntry);
                        CustLedgerEntry.RESET;

                        inSTRCustomer.READTEXT(Txt);
                        TempString := CONVERTSTR(Txt, ';', ',');

                        CustLedgerEntry.SETFILTER("Entry No.", SELECTSTR(1, TempString));
                        CustLedgerEntry.SETFILTER("Posting Date", SELECTSTR(2, TempString));
                        CustLedgerEntry.SETFILTER("Document No.", SELECTSTR(3, TempString));
                        CustLedgerEntry.SETFILTER("Document Type", SELECTSTR(4, TempString));
                        IF (LOWERCASE(SELECTSTR(4, TempString)) = 'invoice') OR (LOWERCASE(SELECTSTR(4, TempString)) = 'factura') THEN
                            CustLedgerEntry.SETRANGE("Document Type", CustLedgerEntry."Document Type"::Invoice)
                        ELSE BEGIN
                            IF (LOWERCASE(SELECTSTR(4, TempString)) = 'credit memo') OR (LOWERCASE(SELECTSTR(4, TempString)) = 'abono') THEN
                                CustLedgerEntry.SETRANGE("Document Type", CustLedgerEntry."Document Type"::"Credit Memo")
                            ELSE
                                CustLedgerEntry.SETRANGE("Document Type", CustLedgerEntry."Document Type"::Payment);
                        END;

                        IF CustLedgerEntry.FINDFIRST THEN BEGIN
                            CustLedgerEntry."QuoSII Sales Invoice Type" := DELCHR(SELECTSTR(5, TempString), '<>', ' ');//QuoSII_1.4.02.042
                            CustLedgerEntry."QuoSII Sales Corrected In.Type" := DELCHR(SELECTSTR(6, TempString), '<>', ' ');//QuoSII_1.4.02.042
                            CustLedgerEntry."QuoSII Sales UE Inv Type" := DELCHR(SELECTSTR(7, TempString), '<>', ' ');//QuoSII_1.4.02.042
                            CustLedgerEntry."QuoSII Sales Cr.Memo Type" := DELCHR(SELECTSTR(8, TempString), '<>', ' ');//QuoSII_1.4.02.042
                            CustLedgerEntry."QuoSII UE Country" := SELECTSTR(9, TempString);
                            CustLedgerEntry."QuoSII Operator Address" := SELECTSTR(10, TempString);
                            CustLedgerEntry."QuoSII First Ticket No." := SELECTSTR(11, TempString);
                            CustLedgerEntry."QuoSII Last Ticket No." := SELECTSTR(12, TempString);
                            IF (SELECTSTR(13, TempString) = '1') THEN
                                CustLedgerEntry."QuoSII Third Party" := TRUE
                            ELSE
                                CustLedgerEntry."QuoSII Third Party" := FALSE;

                            CustLedgerEntry."QuoSII Situacion Inmueble" := SELECTSTR(14, TempString);
                            CustLedgerEntry."QuoSII Referencia Catastral" := SELECTSTR(15, TempString);
                            CustLedgerEntry."QuoSII Bienes Description" := SELECTSTR(16, TempString);
                            IF CustLedgerEntry.MODIFY THEN
                                COMMIT
                            ELSE
                                MESSAGE('Error en ' + FORMAT(CustLedgerEntry."Entry No."));
                        END;
                    END;
                END;
            END;
        //QuoSII_05-END
        //QuoSII.B9.End
    END;

    //[External]
    PROCEDURE ExportCert(VAR CertBytes: BigText);
    VAR
        ins: InStream;
        CompanyInformation: Record 79;
        MemoryStream: DotNet MemoryStream;
        Bytes: DotNet Array;
        Convert: DotNet Convert;
    BEGIN
        CompanyInformation.GET;
        CompanyInformation.CALCFIELDS("QuoSII Certificate", "QuoSII Certificate Password");

        CLEAR(ins);
        CLEAR(MemoryStream);
        CompanyInformation."QuoSII Certificate".CREATEINSTREAM(ins);
        MemoryStream := MemoryStream.MemoryStream();
        COPYSTREAM(MemoryStream, ins);
        Bytes := MemoryStream.ToArray();

        IF (CompanyInformation."QuoSII Certificate".HASVALUE) AND (CompanyInformation."QuoSII Certificate Password".HASVALUE) THEN BEGIN
            CertBytes.ADDTEXT(Convert.ToBase64String(Bytes));
        END ELSE BEGIN
            CertBytes.ADDTEXT('');
        END;
    END;

    //[External]
    PROCEDURE ExportCertPass(VAR CertPassBytes: BigText);
    VAR
        ins: InStream;
        CompanyInformation: Record 79;
        MemoryStream: DotNet MemoryStream;
        Convert: DotNet Convert;
        BytesPass: DotNet Array;
        txt: Text;
    BEGIN
        CompanyInformation.GET;
        CompanyInformation.CALCFIELDS("QuoSII Certificate", "QuoSII Certificate Password");

        CLEAR(ins);
        CLEAR(MemoryStream);
        CompanyInformation."QuoSII Certificate Password".CREATEINSTREAM(ins);
        MemoryStream := MemoryStream.MemoryStream();
        COPYSTREAM(MemoryStream, ins);
        BytesPass := MemoryStream.ToArray();

        IF (CompanyInformation."QuoSII Certificate".HASVALUE) AND (CompanyInformation."QuoSII Certificate Password".HASVALUE) THEN BEGIN
            CertPassBytes.ADDTEXT(Convert.ToBase64String(BytesPass));
            CertPassBytes.GETSUBTEXT(txt, 1, CertPassBytes.LENGTH);
        END ELSE BEGIN
            CertPassBytes.ADDTEXT('');
        END;
    END;

    //[External]
    PROCEDURE SendShips();
    VAR
    // SIISendShipJobQueue: Report 7174335;
    BEGIN
        // SIISendShipJobQueue.RUN;
    END;

    LOCAL PROCEDURE CSVExportEntriesFiles(FechaIni: Date; FechaFin: Date; Mes: Text[20]; TipoExportacion: Option "Customer","Vendor");
    VAR
        FicheroCustomer: File;
        FicheroVendor: File;
        outSTRVendor: OutStream;
        outSTRCustomer: OutStream;
        CustLedgerEntry: Record 21;
        VendorLedgerEntry: Record 25;
        SkipFirst: Boolean;
        CompanyInformation: Record 79;
        strInvoicesTpes: Text[300];
        fileExt: Text[300];
    //filesystem : Automation "{420B2830-E718-11CF-893D-00A0C9054228} 1.0:{0D43FE01-F093-11CF-8940-00A0C9054228}:Option "Microsoft Scripting Runtime".FileSystemObject";
    BEGIN
        //QuoSII.B9.Begin
        CompanyInformation.RESET;
        IF NOT CompanyInformation.GET THEN
            ERROR('No se encontraron los datos de Informaci�n de empresa.');
        IF CompanyInformation."QuoSII Export SII Path" = '' THEN
            ERROR('Ha de configurar la ruta de exportaci�n SII en la Informaci�n de Compa��a');

        IF TipoExportacion = TipoExportacion::Customer THEN BEGIN
            FicheroCustomer.CREATE(CompanyInformation."QuoSII Export SII Path" + 'Customer\CustLedgerEntries' + Mes + '.csv');
            FicheroCustomer.CREATEOUTSTREAM(outSTRCustomer);

            outSTRCustomer.WRITETEXT(
                'Entry No.' + ';' +
                'Posting Date' + ';' +
                'Document No.' + ';' +
                'Document Type' + ';' +
                'Sales Invoice Type QS' + ';' +
                'Sales Corrected Invoice Type' + ';' +
                'Sales UE Inv Type' + ';' +
                'Sales Cr.Memo Type' + ';' +
                'UE Country' + ';' +
                'Operator Address' + ';' +
                'Primer No. Ticket' + ';' +
                'Ultimo No. Ticket' + ';' +
                'Emitida por tercero' + ';' +
                'Situacion Inmueble' + ';' +
                'Referencia Catastral' + ';' +
                'Descripcion Bienes');
            outSTRCustomer.WRITETEXT;

            CustLedgerEntry.RESET;
            CustLedgerEntry.SETRANGE("Posting Date", FechaIni, FechaFin);
            CustLedgerEntry.SETFILTER("Document Type", '%1|%2|%3', CustLedgerEntry."Document Type"::Invoice, CustLedgerEntry."Document Type"::Payment, CustLedgerEntry."Document Type"::"Credit Memo");
            IF CustLedgerEntry.FINDSET THEN
                REPEAT
                    IF CustLedgerEntry."Document Type" <> CustLedgerEntry."Document Type"::Payment THEN
                        strInvoicesTpes := FORMAT(CustLedgerEntry."QuoSII Sales Invoice Type", 2, '<Number>') + ';' +
                                          FORMAT(CustLedgerEntry."QuoSII Sales Corrected In.Type", 2, '<Number>') + ';' +
                                          FORMAT(CustLedgerEntry."QuoSII Sales UE Inv Type", 2, '<Number>') + ';'
                    ELSE
                        strInvoicesTpes := '0;0;0;';
                    outSTRCustomer.WRITETEXT(
                    FORMAT(CustLedgerEntry."Entry No.") + ';' +
                    FORMAT(CustLedgerEntry."Posting Date") + ';' +
                    CustLedgerEntry."Document No." + ';' +
                    FORMAT(CustLedgerEntry."Document Type") + ';' +
                    strInvoicesTpes +
                    FORMAT(CustLedgerEntry."QuoSII Sales Cr.Memo Type", 2, '<Number>') + ';' +
                    CustLedgerEntry."QuoSII UE Country" + ';' +
                    CustLedgerEntry."QuoSII Operator Address" + ';' +
                    CustLedgerEntry."QuoSII First Ticket No." + ';' +
                    CustLedgerEntry."QuoSII Last Ticket No." + ';' +
                    FORMAT(CustLedgerEntry."QuoSII Third Party") + ';' +
                    CustLedgerEntry."QuoSII Situacion Inmueble" + ';' +
                    CustLedgerEntry."QuoSII Referencia Catastral" + ';' +
                    CustLedgerEntry."QuoSII Bienes Description");

                    outSTRCustomer.WRITETEXT;

                UNTIL CustLedgerEntry.NEXT = 0;
            FicheroCustomer.CLOSE();
            fileExt := 'CustLedgerEntries' + Mes + '.csv';
            DOWNLOAD(CompanyInformation."QuoSII Export SII Path" + '\Customer\CustLedgerEntries' + Mes + '.csv', 'Descarga', CompanyInformation."QuoSII Export SII Path" + '\Customer\', 'CSV Files(*.csv)|*.csv', fileExt);
        END;
        IF TipoExportacion = TipoExportacion::Vendor THEN BEGIN

            FicheroVendor.CREATE(CompanyInformation."QuoSII Export SII Path" + 'Vendor\VendLedgerEntries' + Mes + '.csv');
            FicheroVendor.CREATEOUTSTREAM(outSTRVendor);

            outSTRVendor.WRITETEXT(
                'Entry No.' + ';' +
                'Posting Date' + ';' +
                'Document No.' + ';' +
                'Document Type' + ';' +
                'Purchase Invoice Type' + ';' +
                'Purchase Corrected Invoice Type' + ';' +
                'Purchase  Cr.Memo Type' + ';' +
                'Purchase UE Inv Type' + ';' +
                'UE Country' + ';' +
                'Operator Address' + ';' +
                'Ultimo N� Ticket' + ';' +
                'Emitida por tercero' + ';' +
                'Bienes Description');
            outSTRVendor.WRITETEXT;

            VendorLedgerEntry.RESET;
            VendorLedgerEntry.SETRANGE("Posting Date", FechaIni, FechaFin);
            IF VendorLedgerEntry.FINDSET THEN BEGIN
                REPEAT
                    outSTRVendor.WRITETEXT(
                    FORMAT(VendorLedgerEntry."Entry No.") + ';' +
                    FORMAT(VendorLedgerEntry."Posting Date") + ';' +
                    VendorLedgerEntry."Document No." + ';' +
                    FORMAT(VendorLedgerEntry."Document Type") + ';' +
                    FORMAT(VendorLedgerEntry."QuoSII Purch. Invoice Type", 2, '<Number>') + ';' +
                    FORMAT(VendorLedgerEntry."QuoSII Purch. Corr. Inv. Type", 2, '<Number>') + ';' +
                    FORMAT(VendorLedgerEntry."QuoSII Purch. Cr.Memo Type", 2, '<Number>') + ';' +
                    FORMAT(VendorLedgerEntry."QuoSII Purch. UE Inv Type", 2, '<Number>') + ';' +
                    VendorLedgerEntry."QuoSII UE Country" + ';' +
                    VendorLedgerEntry."QuoSII Operator Address" + ';' +
                    VendorLedgerEntry."QuoSII Last Ticket No." + ';' +
                    FORMAT(VendorLedgerEntry."QuoSII Third Party") + ';' +
                    VendorLedgerEntry."QuoSII Bienes Description");

                    outSTRVendor.WRITETEXT;

                UNTIL VendorLedgerEntry.NEXT = 0;
                FicheroVendor.CLOSE();
                fileExt := 'VendLedgerEntries' + Mes + '.csv';
                DOWNLOAD(CompanyInformation."QuoSII Export SII Path" + '\Vendor\VendLedgerEntries' + Mes + '.csv', 'Descarga', CompanyInformation."QuoSII Export SII Path" + '\Vendor\', 'CSV Files(*.csv)|*.csv', fileExt);
            END;
        END;
        //QuoSII.B9.End
    END;

    //[External]
    PROCEDURE UpdateMovs();
    VAR
        SIIDocuments: Record 7174333;
        CustLedgEntry: Record 21;
        VendLedgEntry: Record 25;
        Window: Dialog;
        SIIDocumentLine: Record 7174334;
        SIIDocumentShipmentLine: Record 7174336;
        Companies: Record 2000000006;
        TMPCompanyInformation: Record 79 TEMPORARY;
        i: Integer;
        strMsg: Text;
        btMsg: BigText;
    BEGIN
        Window.OPEN('Company: #1#########################\' +
                    'Document No.: #2#########################');
        i := 1;
        Companies.RESET;
        Companies.FINDSET;
        REPEAT
            Window.UPDATE(1, Companies.Name);

            CLEAR(SIIDocuments);
            SIIDocuments.CHANGECOMPANY(Companies.Name);

            SIIDocuments.RESET;
            IF SIIDocuments.FINDSET THEN BEGIN
                REPEAT
                    //      SIIDocuments."AEAT Status" := SIIDocuments."AEAT StatusTMP";
                    //      SIIDocuments."AEAT StatusTMP" := '';
                    SIIDocuments.MODIFY;
                UNTIL SIIDocuments.NEXT = 0;
            END;

            SIIDocuments.RESET;
            SIIDocuments.SETRANGE("Entry No.", 0);
            IF SIIDocuments.FINDSET THEN
                REPEAT
                    Window.UPDATE(2, SIIDocuments."Document No.");
                    CASE SIIDocuments."Document Type" OF
                        SIIDocuments."Document Type"::FE:
                            BEGIN
                                CLEAR(CustLedgEntry);
                                CustLedgEntry.CHANGECOMPANY(Companies.Name);
                                CustLedgEntry.RESET;
                                CustLedgEntry.SETCURRENTKEY("Document No.", "Document Type", "Customer No.");
                                CustLedgEntry.SETRANGE("Document No.", SIIDocuments."Document No.");
                                CustLedgEntry.SETRANGE("Posting Date", SIIDocuments."Posting Date");
                                CustLedgEntry.SETRANGE("Customer No.", SIIDocuments."Cust/Vendor No.");
                                CustLedgEntry.SETFILTER("Document Type", '%1|%2', CustLedgEntry."Document Type"::Invoice
                                                                               , CustLedgEntry."Document Type"::"Credit Memo");
                                IF CustLedgEntry.FINDSET THEN BEGIN
                                    IF CustLedgEntry.COUNT = 1 THEN BEGIN
                                        SIIDocuments."Entry No." := CustLedgEntry."Entry No.";
                                        SIIDocuments.MODIFY;
                                    END ELSE BEGIN
                                        CustLedgEntry.SETRANGE(Description, SIIDocuments."Description Operation 1");
                                        IF CustLedgEntry.FINDSET THEN
                                            IF CustLedgEntry.COUNT = 1 THEN BEGIN
                                                SIIDocuments."Entry No." := CustLedgEntry."Entry No.";
                                                SIIDocuments.MODIFY;
                                            END;
                                    END;
                                END;
                            END;
                        SIIDocuments."Document Type"::FR:
                            BEGIN
                                CLEAR(VendLedgEntry);
                                VendLedgEntry.CHANGECOMPANY(Companies.Name);
                                VendLedgEntry.RESET;
                                VendLedgEntry.SETCURRENTKEY("Document No.", "Document Type", "Vendor No.");
                                VendLedgEntry.SETRANGE("External Document No.", SIIDocuments."Document No.");
                                VendLedgEntry.SETRANGE("Posting Date", SIIDocuments."Posting Date");
                                VendLedgEntry.SETRANGE("Vendor No.", SIIDocuments."Cust/Vendor No.");
                                VendLedgEntry.SETFILTER("Document Type", '%1|%2', VendLedgEntry."Document Type"::Invoice
                                                                               , VendLedgEntry."Document Type"::"Credit Memo");
                                IF VendLedgEntry.FINDSET THEN BEGIN
                                    IF VendLedgEntry.COUNT = 1 THEN BEGIN
                                        SIIDocuments."Entry No." := VendLedgEntry."Entry No.";
                                        SIIDocuments.MODIFY;
                                    END ELSE BEGIN
                                        VendLedgEntry.SETRANGE(Description, SIIDocuments."Description Operation 1");
                                        IF VendLedgEntry.FINDSET THEN
                                            IF VendLedgEntry.COUNT = 1 THEN BEGIN
                                                SIIDocuments."Entry No." := VendLedgEntry."Entry No.";
                                                SIIDocuments.MODIFY;
                                            END;
                                    END;
                                END;
                            END;
                        SIIDocuments."Document Type"::CE:
                            BEGIN
                                CLEAR(CustLedgEntry);
                                CustLedgEntry.CHANGECOMPANY(Companies.Name);
                                CustLedgEntry.RESET;
                                CustLedgEntry.SETCURRENTKEY("Document No.", "Document Type", "Customer No.");
                                CustLedgEntry.SETRANGE("Document No.", SIIDocuments."Document No.");
                                CustLedgEntry.SETRANGE("Posting Date", SIIDocuments."Posting Date");
                                CustLedgEntry.SETRANGE("Customer No.", SIIDocuments."Cust/Vendor No.");
                                CustLedgEntry.SETFILTER("Document Type", '%1|%2', CustLedgEntry."Document Type"::Payment
                                                                               , CustLedgEntry."Document Type"::" ");
                                IF CustLedgEntry.FINDSET THEN BEGIN
                                    IF CustLedgEntry.COUNT = 1 THEN BEGIN
                                        SIIDocuments."Entry No." := CustLedgEntry."Entry No.";
                                        SIIDocuments.MODIFY;
                                    END ELSE BEGIN
                                        CustLedgEntry.SETRANGE(Description, SIIDocuments."Description Operation 1");
                                        IF CustLedgEntry.FINDSET THEN
                                            IF CustLedgEntry.COUNT = 1 THEN BEGIN
                                                SIIDocuments."Entry No." := CustLedgEntry."Entry No.";
                                                SIIDocuments.MODIFY;
                                            END;
                                    END;
                                END;
                            END;
                        SIIDocuments."Document Type"::PR:
                            BEGIN
                                CLEAR(VendLedgEntry);
                                VendLedgEntry.CHANGECOMPANY(Companies.Name);
                                VendLedgEntry.RESET;
                                VendLedgEntry.SETCURRENTKEY("Document No.", "Document Type", "Vendor No.");
                                VendLedgEntry.SETRANGE("External Document No.", SIIDocuments."Document No.");
                                VendLedgEntry.SETRANGE("Posting Date", SIIDocuments."Posting Date");
                                VendLedgEntry.SETRANGE("Vendor No.", SIIDocuments."Cust/Vendor No.");
                                VendLedgEntry.SETFILTER("Document Type", '%1|%2', VendLedgEntry."Document Type"::Payment
                                                                               , VendLedgEntry."Document Type"::" ");
                                IF VendLedgEntry.FINDSET THEN BEGIN
                                    IF VendLedgEntry.COUNT = 1 THEN BEGIN
                                        SIIDocuments."Entry No." := VendLedgEntry."Entry No.";
                                        SIIDocuments.MODIFY;
                                    END ELSE BEGIN
                                        VendLedgEntry.SETRANGE(Description, SIIDocuments."Description Operation 1");
                                        IF VendLedgEntry.FINDSET THEN
                                            IF VendLedgEntry.COUNT = 1 THEN BEGIN
                                                SIIDocuments."Entry No." := VendLedgEntry."Entry No.";
                                                SIIDocuments.MODIFY;
                                            END;
                                    END;
                                END;
                            END;
                        SIIDocuments."Document Type"::OI:
                            BEGIN
                                IF SIIDocuments."Declarate Key UE" = 'D' THEN BEGIN//QuoSII_1.4.0.017
                                    CLEAR(VendLedgEntry);
                                    VendLedgEntry.CHANGECOMPANY(Companies.Name);
                                    VendLedgEntry.RESET;
                                    VendLedgEntry.SETCURRENTKEY("Document No.", "Document Type", "Vendor No.");
                                    VendLedgEntry.SETRANGE("External Document No.", SIIDocuments."Document No.");
                                    VendLedgEntry.SETRANGE("Posting Date", SIIDocuments."Posting Date");
                                    VendLedgEntry.SETRANGE("Vendor No.", SIIDocuments."Cust/Vendor No.");
                                    VendLedgEntry.SETFILTER("Document Type", '%1|%2', VendLedgEntry."Document Type"::Invoice
                                                                                   , VendLedgEntry."Document Type"::"Credit Memo");
                                    IF VendLedgEntry.FINDSET THEN BEGIN
                                        IF VendLedgEntry.COUNT = 1 THEN BEGIN
                                            SIIDocuments."Entry No." := VendLedgEntry."Entry No.";
                                            SIIDocuments.MODIFY;
                                        END ELSE BEGIN
                                            VendLedgEntry.SETRANGE(Description, SIIDocuments."Description Operation 1");
                                            IF VendLedgEntry.FINDSET THEN
                                                IF VendLedgEntry.COUNT = 1 THEN BEGIN
                                                    SIIDocuments."Entry No." := VendLedgEntry."Entry No.";
                                                    SIIDocuments.MODIFY;
                                                END;
                                        END;
                                    END;
                                END ELSE BEGIN
                                    CLEAR(CustLedgEntry);
                                    CustLedgEntry.CHANGECOMPANY(Companies.Name);
                                    CustLedgEntry.RESET;
                                    CustLedgEntry.SETCURRENTKEY("Document No.", "Document Type", "Customer No.");
                                    CustLedgEntry.SETRANGE("Document No.", SIIDocuments."Document No.");
                                    CustLedgEntry.SETRANGE("Posting Date", SIIDocuments."Posting Date");
                                    CustLedgEntry.SETRANGE("Customer No.", SIIDocuments."Cust/Vendor No.");
                                    CustLedgEntry.SETFILTER("Document Type", '%1|%2', CustLedgEntry."Document Type"::Invoice
                                                                                   , CustLedgEntry."Document Type"::"Credit Memo");
                                    IF CustLedgEntry.FINDSET THEN BEGIN
                                        IF CustLedgEntry.COUNT = 1 THEN BEGIN
                                            SIIDocuments."Entry No." := CustLedgEntry."Entry No.";
                                            SIIDocuments.MODIFY;
                                        END ELSE BEGIN
                                            CustLedgEntry.SETRANGE(Description, SIIDocuments."Description Operation 1");
                                            IF CustLedgEntry.FINDSET THEN
                                                IF CustLedgEntry.COUNT = 1 THEN BEGIN
                                                    SIIDocuments."Entry No." := CustLedgEntry."Entry No.";
                                                    SIIDocuments.MODIFY;
                                                END;
                                        END;
                                    END;
                                END;
                            END;
                    END;
                    CLEAR(SIIDocumentLine);
                    SIIDocumentLine.CHANGECOMPANY(Companies.Name);
                    SIIDocumentLine.RESET;
                    SIIDocumentLine.SETRANGE("Document Type", SIIDocuments."Document Type");
                    SIIDocumentLine.SETRANGE("Document No.", SIIDocuments."Document No.");
                    IF SIIDocumentLine.FINDSET THEN BEGIN
                        IF SIIDocumentLine.COUNT = 1 THEN BEGIN
                            SIIDocumentLine."Entry No." := SIIDocuments."Entry No.";
                            SIIDocumentLine.MODIFY;
                        END ELSE BEGIN
                            REPEAT
                                IF SIIDocumentLine."VAT Registration No." = SIIDocuments."VAT Registration No." THEN BEGIN
                                    SIIDocumentLine."Entry No." := SIIDocuments."Entry No.";
                                    SIIDocumentLine.MODIFY;
                                END;
                            UNTIL SIIDocumentLine.NEXT = 0;
                        END;
                    END;
                    CLEAR(SIIDocumentShipmentLine);
                    SIIDocumentShipmentLine.CHANGECOMPANY(Companies.Name);
                    SIIDocumentShipmentLine.RESET;
                    SIIDocumentShipmentLine.SETRANGE("Document Type", SIIDocuments."Document Type");
                    SIIDocumentShipmentLine.SETRANGE("Document No.", SIIDocuments."Document No.");
                    IF SIIDocumentShipmentLine.FINDSET THEN BEGIN
                        IF SIIDocumentShipmentLine.COUNT = 1 THEN BEGIN
                            SIIDocumentShipmentLine."Entry No." := SIIDocuments."Entry No.";
                            SIIDocumentShipmentLine.MODIFY;
                        END ELSE BEGIN
                            SIIDocumentShipmentLine.CALCFIELDS("Base Imponible", "Importe IVA");
                            REPEAT
                                IF SIIDocumentShipmentLine."Base Imponible" + SIIDocumentShipmentLine."Importe IVA" = SIIDocuments."Invoice Amount"
                                THEN BEGIN
                                    SIIDocumentShipmentLine."Entry No." := SIIDocuments."Entry No.";
                                    SIIDocumentShipmentLine.MODIFY;
                                END;
                            UNTIL SIIDocumentShipmentLine.NEXT = 0;
                        END;
                    END;
                UNTIL SIIDocuments.NEXT = 0;

            SIIDocuments.RESET;
            SIIDocuments.SETRANGE("Entry No.", 0);
            IF SIIDocuments.FINDSET THEN BEGIN
                TMPCompanyInformation.RESET;
                TMPCompanyInformation.INIT;
                TMPCompanyInformation.Name := Companies.Name;
                TMPCompanyInformation."Primary Key" := FORMAT(i);
                TMPCompanyInformation."QuoSII REAGYP %" := SIIDocuments.COUNT;
                TMPCompanyInformation.INSERT;
                i += 1;
            END;
        UNTIL Companies.NEXT = 0;
        Window.CLOSE;

        strMsg := '';
        IF TMPCompanyInformation.FINDSET THEN
            REPEAT
                btMsg.ADDTEXT(TMPCompanyInformation.Name + ': ' + FORMAT(TMPCompanyInformation."QuoSII REAGYP %") + '\');
            UNTIL TMPCompanyInformation.NEXT = 0;

        IF TMPCompanyInformation.COUNT <> 0 THEN
            MESSAGE('No se han asignado el valor de Entry No. en algunos documentos de las siguientes empresas:\' + FORMAT(btMsg));
    END;

    //[External]
    PROCEDURE DeleteOldsFields();
    VAR
        CompanyInformation: Record 79;
        Companies: Record 2000000006;
        Window: Dialog;
        SIIDocuments: Record 7174333;
    BEGIN
        Window.OPEN('Company: #1#########################');
        Companies.RESET;
        Companies.FINDSET;
        REPEAT
            Window.UPDATE(1, Companies.Name);
            CLEAR(CompanyInformation);
            CompanyInformation.CHANGECOMPANY(Companies.Name);
            CompanyInformation.GET;
            CompanyInformation.MODIFY;

        //  CLEAR(SIIDocuments);
        //  SIIDocuments.RESET;
        //  SIIDocuments.CHANGECOMPANY(Companies.Name);
        //  IF SIIDocuments.FINDSET THEN BEGIN
        //    REPEAT
        //      SIIDocuments.CALCFIELDS(Emited);
        //      SIIDocuments."Is Emited" := SIIDocuments.Emited;
        //      SIIDocuments.MODIFY;
        //    UNTIL SIIDocuments.NEXT = 0;
        //  END;
        UNTIL Companies.NEXT = 0;
        Window.CLOSE;
    END;

    //[External]
    PROCEDURE UseCertDLL(): Boolean;
    VAR
        CompanyInformation: Record 79;
    BEGIN
        CompanyInformation.RESET;
        CompanyInformation.GET;
        EXIT(CompanyInformation."QuoSII Certificate".HASVALUE);
    END;

    LOCAL PROCEDURE EliminaDatos();
    VAR
        GLAccount: Record 15;
        Window: Dialog;
        Customer: Record 18;
        CustLedgerEntry: Record 21;
        VendorLedgerEntry: Record 25;
        Vendor: Record 23;
        SalesHeader: Record 36;
        SalesLine: Record 37;
        PurchaseHeader: Record 38;
        PurchaseLine: Record 39;
        CompanyInformation: Record 79;
        GenJournalLine: Record 81;
        CustomerPostingGroup: Record 92;
        VendorPostingGroup: Record 93;
        SalesInvoiceHeader: Record 112;
        SalesInvoiceLine: Record 113;
        SalesCrMemoHeader: Record 114;
        SalesCrMemoLine: Record 115;
        PurchInvHeader: Record 122;
        PurchCrMemoHdr: Record 124;
        GenProductPostingGroup: Record 251;
        VATEntry: Record 254;
        PaymentMethod: Record 289;
        VATPostingSetup: Record 325;
        DetailedCustLedgEntry: Record 379;
        DetailedVendorLedgEntry: Record 380;
    BEGIN
        Window.OPEN('Tabla : #1#####################################\' +
                    'Record: #2#####################################');

        Window.UPDATE(1, GLAccount.TABLECAPTION);
        GLAccount.RESET;
        GLAccount.SETFILTER("QuoSII Payment Cash", '%1', TRUE);
        IF GLAccount.FINDSET(TRUE) THEN
            REPEAT
                GLAccount."QuoSII Payment Cash" := FALSE;
                GLAccount.MODIFY;
                Window.UPDATE(2, GLAccount."No.");
            UNTIL GLAccount.NEXT = 0;

        Window.UPDATE(1, Customer.TABLECAPTION);
        Customer.RESET;
        IF Customer.FINDSET THEN
            REPEAT
                Customer."QuoSII VAT Reg No. Type" := '';//QuoSII_1.4.02.042
                Customer."QuoSII Sales Special Regimen" := '';//QuoSII_1.4.02.042
                Customer."QuoSII Sales Special Regimen 1" := '';//QuoSII_1.4.02.042
                Customer."QuoSII Sales Special Regimen 2" := '';//QuoSII_1.4.02.042
                Customer.MODIFY;
                Window.UPDATE(2, Customer."No.");
            UNTIL Customer.NEXT = 0;

        Window.UPDATE(1, CustLedgerEntry.TABLECAPTION);
        CustLedgerEntry.RESET;
        IF CustLedgerEntry.FINDSET THEN
            REPEAT
                CustLedgerEntry."QuoSII Sales Special Regimen" := '';//QuoSII_1.4.02.042
                CustLedgerEntry."QuoSII Sales Special Regimen 1" := '';//QuoSII_1.4.02.042
                CustLedgerEntry."QuoSII Sales Special Regimen 2" := '';//QuoSII_1.4.02.042
                CustLedgerEntry."QuoSII Exported" := FALSE;
                CustLedgerEntry."QuoSII Sales Invoice Type" := '';//QuoSII_1.4.02.042
                CustLedgerEntry."QuoSII Sales Corrected In.Type" := '';//QuoSII_1.4.02.042
                CustLedgerEntry."QuoSII Sales Cr.Memo Type" := '';//QuoSII_1.4.02.042
                CustLedgerEntry."QuoSII Sales UE Inv Type" := '';//QuoSII_1.4.02.042
                CustLedgerEntry."QuoSII UE Country" := '';
                CustLedgerEntry."QuoSII Bienes Description" := '';
                CustLedgerEntry."QuoSII Operator Address" := '';
                CustLedgerEntry."QuoSII Medio Cobro" := '';
                CustLedgerEntry."QuoSII CuentaMedioCobro" := '';
                CustLedgerEntry."QuoSII Last Ticket No." := '';
                CustLedgerEntry."QuoSII Third Party" := FALSE;
                CustLedgerEntry."QuoSII Situacion Inmueble" := '';
                CustLedgerEntry."QuoSII Referencia Catastral" := '';
                CustLedgerEntry."QuoSII First Ticket No." := '';
                CustLedgerEntry.MODIFY;
                Window.UPDATE(2, CustLedgerEntry."Entry No.");
            UNTIL CustLedgerEntry.NEXT = 0;

        Window.UPDATE(1, Vendor.TABLECAPTION);
        Vendor.RESET;
        IF Vendor.FINDSET THEN
            REPEAT
                Vendor."QuoSII VAT Reg No. Type" := '';//QuoSII_1.4.02.042
                Vendor."QuoSII Purch Special Regimen" := '';//QuoSII_1.4.02.042
                Vendor."QuoSII Purch Special Regimen 1" := '';//QuoSII_1.4.02.042
                Vendor."QuoSII Purch Special Regimen 2" := '';//QuoSII_1.4.02.042
                Vendor.MODIFY;
                Window.UPDATE(2, Vendor."No.");
            UNTIL Vendor.NEXT = 0;

        Window.UPDATE(1, VendorLedgerEntry.TABLECAPTION);
        VendorLedgerEntry.RESET;
        IF VendorLedgerEntry.FINDSET THEN
            REPEAT
                VendorLedgerEntry."QuoSII Purch. Special Reg." := '';//QuoSII_1.4.02.042
                VendorLedgerEntry."QuoSII Purch. Special Reg. 1" := '';//QuoSII_1.4.02.042
                VendorLedgerEntry."QuoSII Purch. Special Reg. 2" := '';//QuoSII_1.4.02.042
                VendorLedgerEntry."QuoSII Exported" := FALSE;
                VendorLedgerEntry."QuoSII Purch. Invoice Type" := '';//QuoSII_1.4.02.042
                VendorLedgerEntry."QuoSII Purch. Corr. Inv. Type" := '';//QuoSII_1.4.02.042
                VendorLedgerEntry."QuoSII Purch. Cr.Memo Type" := '';//QuoSII_1.4.02.042
                VendorLedgerEntry."QuoSII Purch. UE Inv Type" := '';//QuoSII_1.4.02.042
                VendorLedgerEntry."QuoSII UE Country" := '';
                VendorLedgerEntry."QuoSII Bienes Description" := '';
                VendorLedgerEntry."QuoSII Operator Address" := '';
                VendorLedgerEntry."QuoSII Medio Pago" := '';
                VendorLedgerEntry."QuoSII CuentaMedioPago" := '';
                VendorLedgerEntry."QuoSII Last Ticket No." := '';
                VendorLedgerEntry."QuoSII Third Party" := FALSE;
                VendorLedgerEntry.MODIFY;
                Window.UPDATE(2, VendorLedgerEntry."Entry No.");
            UNTIL VendorLedgerEntry.NEXT = 0;

        Window.UPDATE(1, SalesHeader.TABLECAPTION);
        SalesHeader.RESET;
        IF SalesHeader.FINDSET THEN
            REPEAT
                SalesHeader."QuoSII Sales Special Regimen" := '';//QuoSII_1.4.02.042
                SalesHeader."QuoSII Sales Special Regimen 1" := '';//QuoSII_1.4.02.042
                SalesHeader."QuoSII Sales Special Regimen 2" := '';//QuoSII_1.4.02.042
                SalesHeader."QuoSII Sales Invoice Type" := '';//QuoSII_1.4.02.042
                SalesHeader."QuoSII Sales Cor. Invoice Type" := '';//QuoSII_1.4.02.042
                SalesHeader."QuoSII Sales Cr.Memo Type" := '';//QuoSII_1.4.02.042
                SalesHeader."QuoSII Sales UE Inv Type" := '';//QuoSII_1.4.02.042
                SalesHeader."QuoSII Bienes Description" := '';
                SalesHeader."QuoSII Operator Address" := '';
                SalesHeader."QuoSII Last Ticket No." := '';
                SalesHeader."QuoSII Third Party" := FALSE;
                SalesHeader."QuoSII First Ticket No." := '';
                SalesHeader.MODIFY;
                Window.UPDATE(2, SalesHeader."No.");
            UNTIL SalesHeader.NEXT = 0;

        Window.UPDATE(1, SalesLine.TABLECAPTION);
        SalesLine.RESET;
        IF SalesLine.FINDSET THEN
            REPEAT
                SalesLine."QuoSII Situacion Inmueble" := '';
                SalesLine."QuoSII Referencia Catastral" := '';
                SalesLine.MODIFY;
                Window.UPDATE(2, SalesLine."No.");
            UNTIL SalesLine.NEXT = 0;

        Window.UPDATE(1, PurchaseHeader.TABLECAPTION);
        PurchaseHeader.RESET;
        IF PurchaseHeader.FINDSET THEN
            REPEAT
                PurchaseHeader."QuoSII Purch Special Regimen" := '';//QuoSII_1.4.02.042
                PurchaseHeader."QuoSII Purch Special Regimen 1" := '';//QuoSII_1.4.02.042
                PurchaseHeader."QuoSII Purch Special Regimen 2" := '';//QuoSII_1.4.02.042
                PurchaseHeader."QuoSII Purch. Invoice Type" := '';//QuoSII_1.4.02.042
                PurchaseHeader."QuoSII Purch. Cor. Inv. Type" := '';//QuoSII_1.4.02.042
                PurchaseHeader."QuoSII Purch. Cr.Memo Type" := '';//QuoSII_1.4.02.042
                PurchaseHeader."QuoSII Purch. UE Inv Type" := '';//QuoSII_1.4.02.042
                PurchaseHeader."QuoSII Bienes Description" := '';
                PurchaseHeader."QuoSII Operator Address" := '';
                PurchaseHeader."QuoSII Last Ticket No." := '';
                PurchaseHeader."QuoSII Third Party" := FALSE;
                PurchaseHeader.MODIFY;
                Window.UPDATE(2, PurchaseHeader."No.");
            UNTIL PurchaseHeader.NEXT = 0;

        Window.UPDATE(1, CompanyInformation.TABLECAPTION);
        CompanyInformation.RESET;
        IF CompanyInformation.FINDSET THEN
            REPEAT
                CompanyInformation."QuoSII Nos. Serie SII" := '';
                //CompanyInformation."Certificate Serial No." := '';
                CompanyInformation."QuoSII Export SII Path" := '';
                CompanyInformation."QuoSII VAT Reg. No. Repres." := '';
                CompanyInformation."QuoSII VAT Type" := '';//QuoSII_1.4.02.042
                CompanyInformation."QuoSII Server WS" := '';
                CompanyInformation."QuoSII Port WS" := '';
                CompanyInformation."QuoSII Instance WS" := '';
                //CompanyInformation."QuoExecuter Path" := '';
                CompanyInformation."QuoSII User WS" := '';
                CompanyInformation."QuoSII Pass WS" := '';
                CompanyInformation."QuoSII Domain WS" := '';
                CompanyInformation."QuoSII REAGYP %" := 0;
                //CompanyInformation."SII Version" := ;
                CompanyInformation."QuoSII Email From" := '';
                CompanyInformation."QuoSII Email To" := '';
                CompanyInformation."QuoSII Use Server DLL" := FALSE;
                CLEAR(CompanyInformation."QuoSII Certificate");
                CLEAR(CompanyInformation."QuoSII Certificate Password");
                CompanyInformation."QuoSII Purch. Invoices Period" := FALSE;
                CompanyInformation.MODIFY;
            UNTIL CompanyInformation.NEXT = 0;

        Window.UPDATE(1, GenJournalLine.TABLECAPTION);
        GenJournalLine.RESET;
        IF GenJournalLine.FINDSET THEN
            REPEAT
                GenJournalLine."QuoSII Sales Special Regimen" := '';//QuoSII_1.4.02.042
                GenJournalLine."QuoSII Sales Special Regimen 1" := '';//QuoSII_1.4.02.042
                GenJournalLine."QuoSII Sales Special Regimen 2" := '';//QuoSII_1.4.02.042
                GenJournalLine."QuoSII Purch. Special Regimen" := '';//QuoSII_1.4.02.042
                GenJournalLine."QuoSII Purch. Special Reg. 1" := '';//QuoSII_1.4.02.042
                GenJournalLine."QuoSII Purch. Special Reg. 2" := '';//QuoSII_1.4.02.042
                GenJournalLine."QuoSII Sales Invoice Type QS" := '';//QuoSII_1.4.02.042
                GenJournalLine."QuoSII Sales Cor. Invoice Type" := '';//QuoSII_1.4.02.042
                GenJournalLine."QuoSII Purch. Invoice Type QS" := '';//QuoSII_1.4.02.042
                GenJournalLine."QuoSII Purch. Cor. Inv. Type" := '';//QuoSII_1.4.02.042
                GenJournalLine."QuoSII Sales Cr.Memo Type" := '';//QuoSII_1.4.02.042
                GenJournalLine."QuoSII Sales UE Inv Type" := '';//QuoSII_1.4.02.042
                GenJournalLine."QuoSII Purch. Cr.Memo Type" := '';//QuoSII_1.4.02.042
                GenJournalLine."QuoSII Purch. UE Inv Type" := '';//QuoSII_1.4.02.042
                GenJournalLine."QuoSII UE Country" := '';
                GenJournalLine."QuoSII Bienes Description" := '';
                GenJournalLine."QuoSII Operator Address" := '';
                GenJournalLine."QuoSII Medio Cobro/Pago" := '';
                GenJournalLine."QuoSII Cuenta Medio Cobro/Pago" := '';
                GenJournalLine."QuoSII Last Ticket No." := '';
                GenJournalLine."QuoSII Situacion Inmueble" := '';
                GenJournalLine."QuoSII Referencia Catastral" := '';
                GenJournalLine."QuoSII First Ticket No." := '';
                GenJournalLine."QuoSII Payment Cash SII" := FALSE;
                GenJournalLine.MODIFY;
            UNTIL GenJournalLine.NEXT = 0;

        Window.UPDATE(1, CustomerPostingGroup.TABLECAPTION);
        CustomerPostingGroup.RESET;
        IF CustomerPostingGroup.FINDSET THEN
            REPEAT
                CustomerPostingGroup."QuoSII Type" := 0;
                CustomerPostingGroup.MODIFY;
            UNTIL CustomerPostingGroup.NEXT = 0;

        Window.UPDATE(1, VendorPostingGroup.TABLECAPTION);
        VendorPostingGroup.RESET;
        IF VendorPostingGroup.FINDSET THEN
            REPEAT
                VendorPostingGroup."QuoSII Type" := 0;
                VendorPostingGroup.MODIFY;
            UNTIL VendorPostingGroup.NEXT = 0;

        Window.UPDATE(1, SalesInvoiceHeader.TABLECAPTION);
        SalesInvoiceHeader.RESET;
        IF SalesInvoiceHeader.FINDSET THEN
            REPEAT
                SalesInvoiceHeader."QuoSII Sales Special Regimen" := '';//QuoSII_1.4.02.042
                SalesInvoiceHeader."QuoSII Sales Special Regimen 1" := '';//QuoSII_1.4.02.042
                SalesInvoiceHeader."QuoSII Sales Special Regimen 2" := '';//QuoSII_1.4.02.042
                SalesInvoiceHeader."QuoSII Sales Invoice Type QS" := '';//QuoSII_1.4.02.042
                SalesInvoiceHeader."QuoSII Sales Corr. Inv. Type" := '';//QuoSII_1.4.02.042
                SalesInvoiceHeader."QuoSII Sales Cr.Memo Type" := '';//QuoSII_1.4.02.042
                SalesInvoiceHeader."QuoSII Sales UE Inv Type" := '';//QuoSII_1.4.02.042
                SalesInvoiceHeader."QuoSII Bienes Description" := '';
                SalesInvoiceHeader."QuoSII Operator Address" := '';
                SalesInvoiceHeader."QuoSII Last Ticket No." := '';
                SalesInvoiceHeader."QuoSII Third Party" := FALSE;
                SalesInvoiceHeader."QuoSII First Ticket No." := '';
                SalesInvoiceHeader.MODIFY;
                Window.UPDATE(2, SalesInvoiceHeader."No.");
            UNTIL SalesInvoiceHeader.NEXT = 0;

        Window.UPDATE(1, SalesInvoiceLine.TABLECAPTION);
        SalesInvoiceLine.RESET;
        IF SalesInvoiceLine.FINDSET THEN
            REPEAT
                SalesInvoiceLine."QuoSII Situacion Inmueble" := '';
                SalesInvoiceLine."QuoSII Referencia Catastral" := '';
                SalesInvoiceLine.MODIFY;
                Window.UPDATE(2, SalesInvoiceLine."No.");
            UNTIL SalesInvoiceLine.NEXT = 0;

        Window.UPDATE(1, SalesCrMemoHeader.TABLECAPTION);
        SalesCrMemoHeader.RESET;
        IF SalesCrMemoHeader.FINDSET THEN
            REPEAT
                SalesCrMemoHeader."QuoSII Sales Special Regimen" := '';//QuoSII_1.4.02.042
                SalesCrMemoHeader."QuoSII Sales Special Regimen 1" := '';//QuoSII_1.4.02.042
                SalesCrMemoHeader."QuoSII Sales Special Regimen 2" := '';//QuoSII_1.4.02.042
                SalesCrMemoHeader."QuoSII Sales Invoice Type QS" := '';//QuoSII_1.4.02.042
                SalesCrMemoHeader."QuoSII Sales Cor. Inv. Type" := '';//QuoSII_1.4.02.042
                SalesCrMemoHeader."QuoSII Sales Cr.Memo Type" := '';//QuoSII_1.4.02.042
                SalesCrMemoHeader."QuoSII Sales UE Inv Type" := '';//QuoSII_1.4.02.042
                SalesCrMemoHeader."QuoSII Bienes Description" := '';
                SalesCrMemoHeader."QuoSII Operator Address" := '';
                SalesCrMemoHeader."QuoSII Last Ticket No." := '';
                SalesCrMemoHeader."QuoSII Third Party" := FALSE;
                SalesCrMemoHeader."QuoSII First Ticket No." := '';
                SalesCrMemoHeader.MODIFY;
                Window.UPDATE(2, SalesCrMemoHeader."No.");
            UNTIL SalesCrMemoHeader.NEXT = 0;

        Window.UPDATE(1, SalesCrMemoLine.TABLECAPTION);
        SalesCrMemoLine.RESET;
        IF SalesCrMemoLine.FINDSET THEN
            REPEAT
                SalesCrMemoLine."QuoSII Situacion Inmueble" := '';
                SalesCrMemoLine."QuoSII Referencia Catastral" := '';
                SalesCrMemoLine.MODIFY;
                Window.UPDATE(2, SalesCrMemoLine."No.");
            UNTIL SalesCrMemoLine.NEXT = 0;

        Window.UPDATE(1, PurchInvHeader.TABLECAPTION);
        PurchInvHeader.RESET;
        IF PurchInvHeader.FINDSET THEN
            REPEAT
                PurchInvHeader."QuoSII Purch Special Regimen" := '';//QuoSII_1.4.02.042
                PurchInvHeader."QuoSII Purch Special Regimen 1" := '';//QuoSII_1.4.02.042
                PurchInvHeader."QuoSII Purch Special Regimen 2" := '';//QuoSII_1.4.02.042
                PurchInvHeader."QuoSII Purch. Invoice Type" := '';//QuoSII_1.4.02.042
                PurchInvHeader."QuoSII Purch. Cor. Inv. Type" := '';//QuoSII_1.4.02.042
                PurchInvHeader."QuoSII Purch. Cr.Memo Type" := '';//QuoSII_1.4.02.042
                PurchInvHeader."QuoSII Purch. UE Inv Type" := '';//QuoSII_1.4.02.042
                PurchInvHeader."QuoSII Bienes Description" := '';
                PurchInvHeader."QuoSII Operator Address" := '';
                PurchInvHeader."QuoSII Last Ticket No." := '';
                PurchInvHeader."QuoSII Third Party" := FALSE;
                PurchInvHeader.MODIFY;
                Window.UPDATE(2, PurchInvHeader."No.");
            UNTIL PurchInvHeader.NEXT = 0;

        Window.UPDATE(1, PurchCrMemoHdr.TABLECAPTION);
        PurchCrMemoHdr.RESET;
        IF PurchCrMemoHdr.FINDSET THEN
            REPEAT
                PurchCrMemoHdr."QuoSII Purch Special Regimen 2" := '';//QuoSII_1.4.02.042
                PurchCrMemoHdr."QuoSII Purch. UE Inv Type" := '';//QuoSII_1.4.02.042
                PurchCrMemoHdr."QuoSII Purch Special Regimen 1" := '';//QuoSII_1.4.02.042
                PurchCrMemoHdr."QuoSII Purch. Invoice Type" := '';//QuoSII_1.4.02.042
                PurchCrMemoHdr."QuoSII Purch. Cor. Inv. Type" := '';//QuoSII_1.4.02.042
                PurchCrMemoHdr."QuoSII Purch. Cr.Memo Type" := '';//QuoSII_1.4.02.042
                PurchCrMemoHdr."QuoSII Purch Special Regimen" := '';//QuoSII_1.4.02.042
                PurchCrMemoHdr."QuoSII Bienes Description" := '';
                PurchCrMemoHdr."QuoSII Operator Address" := '';
                PurchCrMemoHdr."QuoSII Last Ticket No." := '';
                PurchCrMemoHdr."QuoSII Third Party" := FALSE;
                PurchCrMemoHdr.MODIFY;
                Window.UPDATE(2, PurchCrMemoHdr."No.");
            UNTIL PurchCrMemoHdr.NEXT = 0;

        Window.UPDATE(1, GenProductPostingGroup.TABLECAPTION);
        GenProductPostingGroup.RESET;
        IF GenProductPostingGroup.FINDSET THEN
            REPEAT
                GenProductPostingGroup."QuoSII Type" := 0;
                GenProductPostingGroup.MODIFY;
                Window.UPDATE(2, GenProductPostingGroup.Code);
            UNTIL GenProductPostingGroup.NEXT = 0;

        // Window.UPDATE(1,VATEntry.TABLECAPTION);
        // VATEntry.RESET;
        // IF VATEntry.FINDSET THEN
        //  REPEAT
        //    VATEntry."QuoSII Exported" := FALSE;
        //    VATEntry.MODIFY;
        //    Window.UPDATE(2,VATEntry."Entry No.");
        //  UNTIL VATEntry.NEXT = 0;

        Window.UPDATE(1, PaymentMethod.TABLECAPTION);
        PaymentMethod.RESET;
        IF PaymentMethod.FINDSET THEN
            REPEAT
                PaymentMethod."QuoSII Cobro Metalico SII" := FALSE;
                PaymentMethod."QuoSII Type SII" := '';//QuoSII_1.4.02.042
                PaymentMethod.MODIFY;
                Window.UPDATE(2, PaymentMethod.Code);
            UNTIL PaymentMethod.NEXT = 0;

        Window.UPDATE(1, VATPostingSetup.TABLECAPTION);
        VATPostingSetup.RESET;
        IF VATPostingSetup.FINDSET THEN
            REPEAT
                VATPostingSetup."QuoSII Exent Type" := '';
                VATPostingSetup."QuoSII No VAT Type" := '';//QuoSII_1.4.02.042
                VATPostingSetup.MODIFY;
                Window.UPDATE(2, VATPostingSetup."VAT Bus. Posting Group");
            UNTIL VATPostingSetup.NEXT = 0;

        Window.UPDATE(1, DetailedCustLedgEntry.TABLECAPTION);
        DetailedCustLedgEntry.RESET;
        IF DetailedCustLedgEntry.FINDSET THEN
            REPEAT
                DetailedCustLedgEntry."QuoSII Exported" := FALSE;
                DetailedCustLedgEntry.MODIFY;
                Window.UPDATE(2, DetailedCustLedgEntry."Entry No.");
            UNTIL DetailedCustLedgEntry.NEXT = 0;

        Window.UPDATE(1, DetailedVendorLedgEntry.TABLECAPTION);
        DetailedVendorLedgEntry.RESET;
        IF DetailedVendorLedgEntry.FINDSET THEN
            REPEAT
                DetailedVendorLedgEntry."QuoSII Exported" := FALSE;
                DetailedVendorLedgEntry.MODIFY;
                Window.UPDATE(2, DetailedVendorLedgEntry."Entry No.");
            UNTIL DetailedVendorLedgEntry.NEXT = 0;

        Window.UPDATE(2, 0);
        /*{
              Window.UPDATE(1,SIIDocumentError.TABLECAPTION);
              SIIDocumentError.RESET;
              SIIDocumentError.DELETEALL;

              Window.UPDATE(1,SIITypeListValue.TABLECAPTION);
              SIITypeListValue.RESET;
              SIITypeListValue.DELETEALL;

              Window.UPDATE(1,SIIDocuments.TABLECAPTION);
              SIIDocuments.RESET;
              SIIDocuments.DELETEALL;

              Window.UPDATE(1,SIIDocumentLine.TABLECAPTION);
              SIIDocumentLine.RESET;
              SIIDocumentLine.DELETEALL;

              Window.UPDATE(1,SIIDocumentShipment.TABLECAPTION);
              SIIDocumentShipment.RESET;
              SIIDocumentShipment.DELETEALL;

              Window.UPDATE(1,SIIDocumentShipmentLine.TABLECAPTION);
              SIIDocumentShipmentLine.RESET;
              SIIDocumentShipmentLine.DELETEALL;

              Window.CLOSE;
              }*/
    END;

    //[External]
    // PROCEDURE ConsultaDocumentos(VAR "Doc No.": Code[60]; VAR DocType: Integer; VAR EntryNo: Integer; VAR LineType: Code[10]; VAR FXML: BigText);
    // VAR
    //     SIIDocumentShipment: Record 7174335;
    //     TipoLibro: Code[3];
    //     RecRef: RecordRef;
    //     FRef: FieldRef;
    //     varInteger: Integer;
    //     SIIExport: XMLport 7174331;
    //     ins: InStream;
    //     FicheroXML: OutStream;
    //     recTempBlob: codeunit "Temp Blob";
    //     arch: File;
    //     "Ship No.": Code[20];
    //     SIIDocuments: Record 7174333;
    // BEGIN
    //     /*{
    //           �La funci�n exportar� en una variable de texto (como en la funci�n ExportTextXML) el contenido del XMLPort SII Export y
    //             ejecutar� la funci�n de la dll llamada ConsultaDocs(string xmlText) sin rellenar el par�metro strShipment
    //             pas�ndole por par�metro la variable de texto en la que se exporta el XMLPort SII Export.
    //               oEn la llamada a la funci�n SetTipoLibro indicar como par�mertro �CF�
    //               oAntes de llamar a EXPORT, llamar a la funci�n SetSIIDocuments del XMLPort pas�ndole por par�metros el par�metro recibido.
    //           }*/

    //     // SIIExport.SetShipNo("Ship No.");
    //     // SIIDocumentShipment.GET("Ship No.");

    //     // RecRef.OPEN(DATABASE::"SII Document Shipment");
    //     // FRef := RecRef.FIELD(SIIDocumentShipment.FIELDNO("Document Type"));
    //     // EVALUATE(varInteger,FORMAT(SIIDocumentShipment."Document Type",2,'<Number>'));
    //     // TipoLibro := SELECTSTR(varInteger+1,FRef.OptionMembers);
    //     // RecRef.CLOSE;

    //     SIIDocuments.RESET;
    //     CASE DocType OF
    //         2:
    //             SIIDocuments.SETRANGE("Document Type", SIIDocuments."Document Type"::FE);
    //         3:
    //             SIIDocuments.SETRANGE("Document Type", SIIDocuments."Document Type"::FR);
    //         4:
    //             SIIDocuments.SETRANGE("Document Type", SIIDocuments."Document Type"::OS);
    //         5:
    //             SIIDocuments.SETRANGE("Document Type", SIIDocuments."Document Type"::CM);
    //         6:
    //             SIIDocuments.SETRANGE("Document Type", SIIDocuments."Document Type"::BI);
    //         7:
    //             SIIDocuments.SETRANGE("Document Type", SIIDocuments."Document Type"::OI);
    //         8:
    //             SIIDocuments.SETRANGE("Document Type", SIIDocuments."Document Type"::CE);
    //         9:
    //             SIIDocuments.SETRANGE("Document Type", SIIDocuments."Document Type"::PR);
    //     END;

    //     SIIDocuments.SETRANGE("Document No.", "Doc No.");
    //     SIIDocuments.SETRANGE("Entry No.", EntryNo);
    //     SIIDocuments.SETRANGE("Register Type", LineType);  //JAV
    //     IF SIIDocuments.FINDFIRST THEN BEGIN
    //         SIIExport.SetSIIDocuments(SIIDocuments);
    //         SIIExport.SetTipoLibro('CF');

    //         CLEAR(ins);
    //         CLEAR(FicheroXML);
    //         //CLEAR(recTempBlob);

    //         //recTempBlob."Primary Key" := 1;
    //         //recTempBlob.INSERT;

    //         recTempBlob.CreateOutStream(FicheroXML, TextEncoding::Windows);
    //         SIIExport.SETDESTINATION(FicheroXML);
    //         SIIExport.EXPORT;

    //         //recTempBlob.MODIFY;
    //         recTempBlob.CreateInStream(ins, TextEncoding::Windows);
    //         //FXML.READ(ins);
    //         ins.Read(FXML);
    //         //recTempBlob.DELETEALL;
    //     END ELSE
    //         ERROR('No se encuentra el documento.');
    // END;

    //[External]
    PROCEDURE ProcessConsulta(VAR "DocNo.": Code[60]; VAR DocType: Option " ","FE","FR","OS","CM","BI","OI","CE","PR"; VAR EntryNo: Integer; VAR LineType: Code[10]; UseDLL: Option " ","Client","Server");
    VAR
        [RUNONCLIENT]
        QuoSIIClient: DotNet QuoSIICom;
        CompanyInformation: Record 79;
        QuoSIIServer: DotNet QuoSIICom;
        ConsultaDialog: Dialog;
        SIIDocuments: Record 7174333;
    BEGIN
        //QuoSII1.4.03
        CompanyInformation.GET;
        //QuoSII_1.4.02.042.12.begin
        //SIIDocuments.GET(DocType,"DocNo.");//QuoSII_1.4.02.042
        SIIDocuments.RESET;
        SIIDocuments.SETRANGE("Document Type", DocType);
        SIIDocuments.SETRANGE("Document No.", "DocNo.");
        SIIDocuments.SETRANGE("Entry No.", EntryNo);
        SIIDocuments.SETRANGE("Register Type", LineType);  //JAV 30/05/21
        SIIDocuments.FINDFIRST;
        //QuoSII_1.4.02.042.12.end

        IF UseDLL = UseDLL::Server THEN BEGIN
            IF (NOT CompanyInformation."QuoSII Certificate".HASVALUE) OR (NOT CompanyInformation."QuoSII Certificate Password".HASVALUE) THEN
                SendMail('QuoSII', CompanyInformation."QuoSII Email From", CompanyInformation."QuoSII Email To", '', 'Error Env�os SII ' + FORMAT(TODAY), 'No se ha configurado un certificado v�lido o una contrase�a.');

            QuoSIIServer := QuoSIIServer.QuoSIICom();

            QuoSIIServer.server := CompanyInformation."QuoSII Server WS";
            QuoSIIServer.port := CompanyInformation."QuoSII Port WS";
            QuoSIIServer.instance := CompanyInformation."QuoSII Instance WS";
            QuoSIIServer.company := COMPANYNAME;
            QuoSIIServer.objectType := 'Codeunit';
            QuoSIIServer.objectName := 'SIIManagement';
            QuoSIIServer.user := CompanyInformation."QuoSII User WS";
            QuoSIIServer.password := CompanyInformation."QuoSII Pass WS";
            QuoSIIServer.domain := CompanyInformation."QuoSII Domain WS";
            QuoSIIServer.DocNo := "DocNo.";
            CASE DocType OF
                DocType::FE:
                    QuoSIIServer.DocType := 2;
                DocType::FR:
                    QuoSIIServer.DocType := 3;
                DocType::OS:
                    QuoSIIServer.DocType := 4;
                DocType::CM:
                    QuoSIIServer.DocType := 5;
                DocType::BI:
                    QuoSIIServer.DocType := 6;
                DocType::OI:
                    QuoSIIServer.DocType := 7;
                DocType::CE:
                    QuoSIIServer.DocType := 8;
                DocType::PR:
                    QuoSIIServer.DocType := 9;
            END;
            QuoSIIServer.EntryNo := EntryNo;
            QuoSIIServer.sourceDirectory(CompanyInformation."QuoSII Export SII Path");
            QuoSIIServer.version := FORMAT(CompanyInformation."QuoSII Version");//QuoSII1.4
            QuoSIIServer.CIFEmpresa := CompanyInformation."VAT Registration No.";
            QuoSIIServer.TipoEntorno := 'REAL';//QuoSII1.4
                                               //QuoSII_1.4.02.042.begin
            QuoSIIServer.TipoAgencia := SIIDocuments."SII Entity";
            //QuoSII_1.4.02.042.end
            QuoSIIServer.isSslEnabled := CompanyInformation."QuoSII Use SSL"; //2001+
            QuoSIIServer.EnvioTextXMLConsultaServer();
        END ELSE BEGIN
            IF UseDLL = UseDLL::Client THEN BEGIN
                IF (NOT CompanyInformation."QuoSII Certificate".HASVALUE) OR (NOT CompanyInformation."QuoSII Certificate Password".HASVALUE) THEN
                    SendMail('QuoSII', CompanyInformation."QuoSII Email From", CompanyInformation."QuoSII Email To", '', 'Error Env�os SII ' + FORMAT(TODAY), 'No se ha configurado un certificado v�lido o una contrase�a.');

                QuoSIIClient := QuoSIIClient.QuoSIICom();

                QuoSIIClient.server := CompanyInformation."QuoSII Server WS";
                QuoSIIClient.port := CompanyInformation."QuoSII Port WS";
                QuoSIIClient.instance := CompanyInformation."QuoSII Instance WS";
                QuoSIIClient.company := COMPANYNAME;
                QuoSIIClient.objectType := 'Codeunit';
                QuoSIIClient.objectName := 'SIIManagement';
                QuoSIIClient.user := CompanyInformation."QuoSII User WS";
                QuoSIIClient.password := CompanyInformation."QuoSII Pass WS";
                QuoSIIClient.domain := CompanyInformation."QuoSII Domain WS";
                QuoSIIClient.DocNo := "DocNo.";
                CASE DocType OF
                    DocType::FE:
                        QuoSIIClient.DocType := 2;
                    DocType::FR:
                        QuoSIIClient.DocType := 3;
                    DocType::OS:
                        QuoSIIClient.DocType := 4;
                    DocType::CM:
                        QuoSIIClient.DocType := 5;
                    DocType::BI:
                        QuoSIIClient.DocType := 6;
                    DocType::OI:
                        QuoSIIClient.DocType := 7;
                    DocType::CE:
                        QuoSIIClient.DocType := 8;
                    DocType::PR:
                        QuoSIIClient.DocType := 9;
                END;
                QuoSIIClient.EntryNo := EntryNo;
                QuoSIIClient.sourceDirectory(CompanyInformation."QuoSII Export SII Path");
                QuoSIIClient.version := FORMAT(CompanyInformation."QuoSII Version");//QuoSII1.4
                QuoSIIClient.CIFEmpresa := CompanyInformation."VAT Registration No.";
                QuoSIIClient.TipoEntorno := 'REAL';//QuoSII1.4
                                                   //QuoSII_1.4.02.042.begin
                QuoSIIClient.TipoAgencia := SIIDocuments."SII Entity";
                //QuoSII_1.4.02.042.end
                QuoSIIClient.isSslEnabled := CompanyInformation."QuoSII Use SSL"; //2001+
                QuoSIIClient.EnvioTextXMLConsulta;
            END ELSE BEGIN
                IF CompanyInformation."QuoSII Use Server DLL" THEN BEGIN
                    IF (NOT CompanyInformation."QuoSII Certificate".HASVALUE) OR (NOT CompanyInformation."QuoSII Certificate Password".HASVALUE) THEN
                        SendMail('QuoSII', CompanyInformation."QuoSII Email From", CompanyInformation."QuoSII Email To", '', 'Error Env�os SII ' + FORMAT(TODAY), 'No se ha configurado un certificado v�lido o una contrase�a.');

                    QuoSIIServer := QuoSIIServer.QuoSIICom();

                    QuoSIIServer.server := CompanyInformation."QuoSII Server WS";
                    QuoSIIServer.port := CompanyInformation."QuoSII Port WS";
                    QuoSIIServer.instance := CompanyInformation."QuoSII Instance WS";
                    QuoSIIServer.company := COMPANYNAME;
                    QuoSIIServer.objectType := 'Codeunit';
                    QuoSIIServer.objectName := 'SIIManagement';
                    QuoSIIServer.user := CompanyInformation."QuoSII User WS";
                    QuoSIIServer.password := CompanyInformation."QuoSII Pass WS";
                    QuoSIIServer.domain := CompanyInformation."QuoSII Domain WS";
                    QuoSIIServer.DocNo := "DocNo.";
                    QuoSIIServer.DocType := DocType;
                    CASE DocType OF
                        DocType::FE:
                            QuoSIIServer.DocType := 2;
                        DocType::FR:
                            QuoSIIServer.DocType := 3;
                        DocType::OS:
                            QuoSIIServer.DocType := 4;
                        DocType::CM:
                            QuoSIIServer.DocType := 5;
                        DocType::BI:
                            QuoSIIServer.DocType := 6;
                        DocType::OI:
                            QuoSIIServer.DocType := 7;
                        DocType::CE:
                            QuoSIIServer.DocType := 8;
                        DocType::PR:
                            QuoSIIServer.DocType := 9;
                    END;
                    QuoSIIServer.EntryNo := EntryNo;
                    QuoSIIServer.sourceDirectory(CompanyInformation."QuoSII Export SII Path");
                    QuoSIIServer.version := FORMAT(CompanyInformation."QuoSII Version");//QuoSII1.4
                    QuoSIIServer.CIFEmpresa := CompanyInformation."VAT Registration No.";

                    QuoSIIServer.TipoEntorno := 'REAL';//QuoSII1.4
                                                       //QuoSII_1.4.02.042.begin
                    QuoSIIServer.TipoAgencia := SIIDocuments."SII Entity";
                    //QuoSII_1.4.02.042.end
                    QuoSIIServer.isSslEnabled := CompanyInformation."QuoSII Use SSL"; //2001+
                    QuoSIIServer.EnvioTextXMLConsultaServer();
                END ELSE BEGIN
                    QuoSIIClient := QuoSIIClient.QuoSIICom();

                    QuoSIIClient.server := CompanyInformation."QuoSII Server WS";
                    QuoSIIClient.port := CompanyInformation."QuoSII Port WS";
                    QuoSIIClient.instance := CompanyInformation."QuoSII Instance WS";
                    QuoSIIClient.company := COMPANYNAME;
                    QuoSIIClient.objectType := 'Codeunit';
                    QuoSIIClient.objectName := 'SIIManagement';
                    QuoSIIClient.user := CompanyInformation."QuoSII User WS";
                    QuoSIIClient.password := CompanyInformation."QuoSII Pass WS";
                    QuoSIIClient.domain := CompanyInformation."QuoSII Domain WS";
                    QuoSIIClient.DocNo := "DocNo.";
                    CASE DocType OF
                        DocType::FE:
                            QuoSIIClient.DocType := 2;
                        DocType::FR:
                            QuoSIIClient.DocType := 3;
                        DocType::OS:
                            QuoSIIClient.DocType := 4;
                        DocType::CM:
                            QuoSIIClient.DocType := 5;
                        DocType::BI:
                            QuoSIIClient.DocType := 6;
                        DocType::OI:
                            QuoSIIClient.DocType := 7;
                        DocType::CE:
                            QuoSIIClient.DocType := 8;
                        DocType::PR:
                            QuoSIIClient.DocType := 9;
                    END;
                    QuoSIIClient.EntryNo := EntryNo;
                    QuoSIIClient.sourceDirectory(CompanyInformation."QuoSII Export SII Path");
                    QuoSIIClient.version := FORMAT(CompanyInformation."QuoSII Version");//QuoSII1.4
                    QuoSIIClient.CIFEmpresa := CompanyInformation."VAT Registration No.";

                    QuoSIIClient.TipoEntorno := 'REAL';//QuoSII1.4
                                                       //QuoSII_1.4.02.042.begin
                    QuoSIIClient.TipoAgencia := SIIDocuments."SII Entity";
                    //QuoSII_1.4.02.042.end
                    QuoSIIClient.isSslEnabled := CompanyInformation."QuoSII Use SSL"; //2001+
                    QuoSIIClient.EnvioTextXMLConsulta;
                END;
            END;
        END;
    END;

    LOCAL PROCEDURE UpdateSIIEntity();
    VAR
        CustLedgerEntry: Record 21;
        VendorLedgerEntry: Record 25;
        SIIDocuments: Record 7174333;
        SIIDocumentShipment: Record 7174335;
        SIIDocumentShipmentLine: Record 7174336;
        Dialog: Dialog;
        Company: Record 2000000006;
    BEGIN
        //QuoSII_1.4.02.042
        /*{
              Company.RESET;
              Company.FINDFIRST;
              Dialog.OPEN('#1###############################\#2#####################');
              REPEAT
                Dialog.UPDATE(1,Company.Name);

                Dialog.UPDATE(2,SIIDocuments.TABLECAPTION);
                SIIDocuments.CHANGECOMPANY(Company.Name);
                SIIDocuments.RESET;
                IF SIIDocuments.FINDFIRST THEN
                  REPEAT
                    SIIDocuments."SII Entity" := 'AEAT';
                    SIIDocuments.MODIFY;
                  UNTIL SIIDocuments.NEXT = 0;

                Dialog.UPDATE(2,SIIDocumentline.TABLECAPTION);
                SIIDocumentline.CHANGECOMPANY(Company.Name);
                SIIDocumentline.RESET;
                IF SIIDocumentline.FINDFIRST THEN
                  REPEAT
                    SIIDocumentline."SII Entity" := 'AEAT';
                    SIIDocumentline.MODIFY;
                  UNTIL SIIDocumentline.NEXT = 0;

                Dialog.UPDATE(2,SIIDocumentShipment.TABLECAPTION);
                SIIDocumentShipment.CHANGECOMPANY(Company.Name);
                SIIDocumentShipment.RESET;
                IF SIIDocumentShipment.FINDFIRST THEN
                  REPEAT
                    SIIDocumentShipment."SII Entity" := 'AEAT';
                    SIIDocumentShipment.MODIFY;
                  UNTIL SIIDocumentShipment.NEXT = 0;

                Dialog.UPDATE(2,SIIDocumentShipmentLine.TABLECAPTION);
                SIIDocumentShipmentLine.CHANGECOMPANY(Company.Name);
                SIIDocumentShipmentLine.RESET;
                IF SIIDocumentShipmentLine.FINDFIRST THEN
                  REPEAT
                    SIIDocumentShipmentLine."SII Entity" := 'AEAT';
                    SIIDocumentShipmentLine.MODIFY;
                  UNTIL SIIDocumentShipmentLine.NEXT = 0;

                Dialog.UPDATE(2,CustLedgerEntry.TABLECAPTION);
                CustLedgerEntry.CHANGECOMPANY(Company.Name);
                CustLedgerEntry.RESET;
                IF CustLedgerEntry.FINDFIRST THEN
                  REPEAT
                    SIIDocuments.RESET;
                    SIIDocuments.SETFILTER("Document Type",'%1|%2',SIIDocuments."Document Type"::FE,SIIDocuments."Document Type"::CE,SIIDocuments."Document Type"::OI);
                    SIIDocuments.SETRANGE("Entry No.",CustLedgerEntry."Entry No.");
                    IF SIIDocuments.FINDFIRST THEN BEGIN
                      CustLedgerEntry."SII Entity" := 'AEAT';
                      CustLedgerEntry.MODIFY;
                    END;
                  UNTIL CustLedgerEntry.NEXT = 0;

                Dialog.UPDATE(2,VendorLedgerEntry.TABLECAPTION);
                VendorLedgerEntry.CHANGECOMPANY(Company.Name);
                VendorLedgerEntry.RESET;
                IF VendorLedgerEntry.FINDFIRST THEN
                  REPEAT
                    SIIDocuments.RESET;
                    SIIDocuments.SETFILTER("Document Type",'%1|%2',SIIDocuments."Document Type"::FR,SIIDocuments."Document Type"::PR,SIIDocuments."Document Type"::OI);
                    SIIDocuments.SETRANGE("Entry No.",VendorLedgerEntry."Entry No.");
                    IF SIIDocuments.FINDFIRST THEN BEGIN
                      VendorLedgerEntry."SII Entity" := 'AEAT';
                      VendorLedgerEntry.MODIFY;
                    END;
                  UNTIL VendorLedgerEntry.NEXT = 0;
              UNTIL Company.NEXT = 0;
              }*/
    END;

    //[External]
    PROCEDURE CreateSIIType();
    VAR
        SIITypeListValue: Record 7174331;
        Dialog: Dialog;
        Company: Record 2000000006;
    BEGIN
        Company.RESET;
        Company.FINDSET;
        Dialog.OPEN('#1###############################\#2#####################');
        REPEAT
            Dialog.UPDATE(1, Company.Name);

            //----------------------------------------------------------------------------------------------------------------------------------------------
            //JAV 08/06/22: - QuoSII 1.06.09 Nuevo sistema de creaci�n, mas legible y f�cil de ampliar. Hay dos funciones auxiliares:
            //                               CreateSIIType_One crea los registros sin poner SIIEntity
            //                               CreateSIIType_Two los crea poniendo la entidad, se le pansan dos descripciones, la primera para AEAT y la segunda para ATCN
            //                                                 si alguna tiene '-'  no se crea registro para esa entidad. Si se le pasa '' usa la misma descripcion en ambos registros

            //JAV 08/06/22: - QuoSII 1.06.09 Se dan de alta registros de la version 1.1

            //JAV 08/06/22: - QuoSII 1.06.09 Se agrupa, unifica y simplifica la creaci�n de datos de la lista ENTIDADES
            CreateSIIType_One(Company.Name, SIITypeListValue.Type::SIIEntity, '0', 'AEAT', 'AEAT');
            CreateSIIType_One(Company.Name, SIITypeListValue.Type::SIIEntity, '1', 'ATCN', 'ATCN');

            //JAV 08/06/22: - QuoSII 1.06.09 Se agrupa, unifica y simplifica la creaci�n de datos de la lista L0-TIPOS DE COMUNICACION
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::CommunicationType, '0', 'A0', 'Alta de facturas/registro', '');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::CommunicationType, '1', 'A1', 'Modificaci�n de facturas/registros (errores registrales)', '');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::CommunicationType, '2', 'A4', 'Modificaci�n Factura R�gimen de Viajeros', '');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::CommunicationType, '3', 'B0', 'Baja de facturas', '');  //?? No est� en la tabla oficial ??
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::CommunicationType, '4', 'A5', 'Alta de las devoluciones del IVA de viajeros', '');            //1.1
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::CommunicationType, '5', 'A6', 'Modificacion de las devoluciones del IVA de viajeros', '');    //1.1

            //JAV 08/06/22: - QuoSII 1.06.09 Se agrupa, unifica y simplifica la creaci�n de datos de la lista L1-PERIODO
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::Period, '0', '01', 'Enero', 'Enero');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::Period, '1', '02', 'Febrero', 'Febrero');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::Period, '2', '03', 'Marzo', 'Marzo');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::Period, '3', '04', 'Abril', 'Abril');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::Period, '4', '05', 'Mayo', 'Mayo');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::Period, '5', '06', 'Junio', 'Junio');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::Period, '6', '07', 'Julio', 'Julio');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::Period, '7', '08', 'Agosto', 'Agosto');
            //Q19001-
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::Period, '8', '09', 'Septiembre', 'Septiembre');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::Period, '9', '10', 'Octubre', 'Octubre');
            //CreateSIIType_Two(Company.Name,SIITypeListValue.Type::Period, '8','09','Enero','');
            //CreateSIIType_Two(Company.Name,SIITypeListValue.Type::Period, '9','10','Septiembre','');
            //Q19001+
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::Period, '10', '11', 'Noviembre', 'Noviembre');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::Period, '11', '12', 'Diciembre', 'Diciembre');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::Period, '12', '0A', 'Anual', 'Anual');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::Period, '13', '1T', '1� Trimestre', '1� Trimestre');    //1.1
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::Period, '14', '2T', '2� Trimestre', '2� Trimestre');    //1.1
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::Period, '15', '3T', '3� Trimestre', '3� Trimestre');    //1.1
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::Period, '16', '4T', '4� Trimestre', '4� Trimestre');    //1.1
                                                                                                                           //Q19001-
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::Period, '0', '1', 'Enero', 'Enero');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::Period, '1', '2', 'Febrero', 'Febrero');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::Period, '2', '3', 'Marzo', 'Marzo');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::Period, '3', '4', 'Abril', 'Abril');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::Period, '4', '5', 'Mayo', 'Mayo');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::Period, '5', '6', 'Junio', 'Junio');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::Period, '6', '7', 'Julio', 'Julio');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::Period, '7', '8', 'Agosto', 'Agosto');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::Period, '8', '9', 'Septiembre', 'Septiembre');
            //Q19001+

            //JAV 08/06/22: - QuoSII 1.06.09 Se agrupa, unifica y simplifica la creaci�n de datos de la lista L2_EMI-TIPO DE FACTURAS EMITIDAS
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::SalesInvType, '0', 'F1', 'Factura (art. 6, 7.2 y 7.3 del RD 1619/201', '');  //1.1 cambio descripci�n
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::SalesInvType, '1', 'F2', 'Factura Simplificada y y Facturas sin identificaci�n del destinatario art. 6.1.d) RD 1619/201', '');  //1.1 cambio descripci�n
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::SalesInvType, '7', 'F3', 'Factura emitida en sustituci�n de facturas simplificadas y declaradas', '');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::SalesInvType, '8', 'F4', 'Asiento resumen de facturas', '');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::SalesInvType, '2', 'R1', 'Factura Rectificativa (Art. 80.1 y 80.2 y error fundado en derecho)', '');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::SalesInvType, '3', 'R2', 'Factura Rectificativa (Art. 80.3)', 'Factura Rectificativa - Concurso');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::SalesInvType, '4', 'R3', 'Factura Rectificativa (Art. 80.4)', 'Factura Rectificativa - Deuda incobrable');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::SalesInvType, '5', 'R4', 'Factura Rectificativa (Resto)', '');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::SalesInvType, '6', 'R5', 'Factura Rectificativa en facturas simplificadas', '');

            //JAV 08/06/22: - QuoSII 1.06.09 Se agrupa, unifica y simplifica la creaci�n de datos de la lista L2_RECI-TIPO DE FACTURAS RECIBIDAS
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::PurchInvType, '0', 'F1', 'Factura (art. 6, 7.2 y 7.3 del RD 1619/201', '');  //1.1 cambio descripci�n
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::PurchInvType, '1', 'F2', 'Factura Simplificada y y Facturas sin identificaci�n del destinatario art. 6.1.d) RD 1619/201', '');  //1.1 cambio descripci�n
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::PurchInvType, '7', 'F3', 'Factura emitida en sustituci�n de facturas simplificadas y declaradas', '');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::PurchInvType, '8', 'F4', 'Asiento resumen de facturas', '');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::PurchInvType, '9', 'F5', 'Importaciones (DUA)', '');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::PurchInvType, '10', 'F6', 'Otros justificantes contables', '');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::PurchInvType, '2', 'R1', 'Factura Rectificativa (Art. 80.1 y 80.2 y error fundado en derecho)', '');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::PurchInvType, '3', 'R2', 'Factura Rectificativa (Art. 80.3)', 'Factura Rectificativa - Concurso');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::PurchInvType, '4', 'R3', 'Factura Rectificativa (Art. 80.4)', 'Factura Rectificativa - Deuda incobrable');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::PurchInvType, '5', 'R4', 'Factura Rectificativa (Resto)', '');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::PurchInvType, '6', 'R5', 'Factura Rectificativa en facturas simplificadas', '');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::PurchInvType, '11', 'LC', 'Aduanas - Liquidaci�n complementaria', 'Liquidaci�n complementaria');   //1.1
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::PurchInvType, '12', '24', '-', 'Cuota deducibles por exclusi�n del RE comerciante minorista');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::PurchInvType, '13', '25', '-', 'Documento de ingreso articulo 25 Ley 19/1994');

            //JAV 08/06/22: - QuoSII 1.06.09 Se agrupa, unifica y simplifica la creaci�n de datos de la lista L3.1-R�GIMEN ESPECIAL FACTURAS EMITIDAS
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::KeySpecialSalesInv, '0', '01', 'Operaci�n de r�gimen com�n', '');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::KeySpecialSalesInv, '1', '02', 'Exportaci�n', '');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::KeySpecialSalesInv, '2', '03', 'Operaciones a las que se aplique el r�gimen especial de bienes usados, objetos de arte, antig�edades y objetos '
                                                                                                + 'de colecci�n (135-139 LIVA,'')', '');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::KeySpecialSalesInv, '3', '04', 'R�gimen especial oro de inversi�n', '');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::KeySpecialSalesInv, '4', '05', 'R�gimen especial agencias de viajes', '');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::KeySpecialSalesInv, '5', '06', 'R�gimen especial grupo de entidades en IVA (Nivel Avanzado)',
                                                                                               'R�gimen especial grupo de entidades en IGIC (Nivel Avanzado)');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::KeySpecialSalesInv, '6', '07', 'R�gimen especial criterio de caja', '');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::KeySpecialSalesInv, '7', '08', 'Operaciones sujetas al IPSI  / IGIC', 'Operaciones sujetas al IPSI  / IVA');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::KeySpecialSalesInv, '8', '09', 'Facturaci�n de las prestaciones de servicios de agencias de viaje que act�an como mediadoras en nombre y por '
                                                                                                + 'cuenta ajena (D.A.4� RD1619/2012)', '');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::KeySpecialSalesInv, '9', '10', 'Cobros por cuenta de terceros de honorarios profesionales o de derechos derivados de la propiedad industrial, '
                                                                                                + 'de autor u otros por cuenta de sus socios, asociados,.. u otras entidades que realicen estas funciones de cobro', '');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::KeySpecialSalesInv, '10', '11', 'Operaciones de arrendamiento de local de negocio sujetas a retenci�n', '');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::KeySpecialSalesInv, '11', '12', 'Operaciones de arrendamiento de local de negocio no  sujetos a retenci�n', '');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::KeySpecialSalesInv, '12', '13', 'Operaciones de arrendamiento de local de negocio sujetas y no sujetas a retenci�n', '');
            //JAV 08/09/22: - QB 1.06.12 Se cambian nombres mal informados en Operaciones del Libro de Facturas Emitidas
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::KeySpecialSalesInv, '13', '14', 'Factura con IVA pendiente de devengo (certificaciones de obra cuyo destinatario sea una Administraci�n P�blica)',
                                                                                               'Factura con IGIC pendiente de devengo (certificaciones de obra cuyo destinatario sea una Administraci�n P�blica)');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::KeySpecialSalesInv, '14', '15', 'Factura con IVA pendiente de devengo en operaciones de tracto sucesivo',
                                                                                               'Factura con IGIC pendiente de devengo en operaciones de tracto sucesivo');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::KeySpecialSalesInv, '15', '16', 'Primer semestre 2017 y otras facturas anteriores a la inclusi�n en el SII', '');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::KeySpecialSalesInv, '16', '17', 'Operaci�n acogida a alguno de los reg�menes previstos en el Cap�tulo XI del T�tulo IX (OSS e IOSS)', '');      //1.1

            //JAV 08/06/22: - QuoSII 1.06.09 Se agrupa, unifica y simplifica la creaci�n de datos de la lista L3.2-R�GIMEN ESPECIAL FACTURAS RECIBIDAS
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::KeySpecialPurchInv, '0', '01', 'Operaci�n de r�gimen com�n', '');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::KeySpecialPurchInv, '1', '02', 'Operaciones por las que los empresarios satisfacen compensaciones REAGYP', '');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::KeySpecialPurchInv, '2', '03', 'Operaciones a las que se aplique el r�gimen especial de bienes usados, objetos de arte, antig�edades y objetos '
                                                                                                + 'de colecci�n (135-139 LIVA)', '');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::KeySpecialPurchInv, '3', '04', 'R�gimen especial oro de inversi�n', '');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::KeySpecialPurchInv, '4', '05', 'R�gimen especial agencias de viajes', '');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::KeySpecialPurchInv, '5', '06', 'R�gimen especial grupo de entidades en IVA (Nivel Avanzado)', 'R�gimen especial grupo de entidades en IGIC '
                                                                                                + '(Nivel Avanzado)');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::KeySpecialPurchInv, '6', '07', 'R�gimen especial criterio de caja', '');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::KeySpecialPurchInv, '7', '08', 'Operaciones sujetas al IPSI / IGIC', 'Operaciones sujetas al IPSI / IVA');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::KeySpecialPurchInv, '8', '09', 'Adquisiciones intracomunitarias de bienes y prestaciones de servicios', '');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::KeySpecialPurchInv, '9', '10', 'Compra de agencias viajes: operaciones de mediaci�n en nombre y por cuenta ajena en los servicios de transporte '
                                                                                                + 'prestados al destinatario de los servicios de acuerdo con el apartado 3 de la D.A.4� RD1619/2012', '');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::KeySpecialPurchInv, '10', '11', 'Facturaci�n de las prestaciones de servicios de agencias de viaje que act�an como mediadoras en nombre y '
                                                                                                + 'por cuenta ajena (D.A.4� RD1619/2012)', '');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::KeySpecialPurchInv, '11', '12', 'Operaciones de arrendamiento de local de negocio', '');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::KeySpecialPurchInv, '12', '13', 'Factura correspondiente a una importaci�n (informada sin asociar a un DUA)', '');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::KeySpecialPurchInv, '13', '14', 'Primer semestre 2017 y otras facturas anteriores a la inclusi�n en el SII', '');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::KeySpecialPurchInv, '14', '15', '-', 'R�gimen especial de comerciante minorista');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::KeySpecialPurchInv, '15', '16', '-', 'R�gimen especial del peque�o empresario o profesional');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::KeySpecialPurchInv, '16', '17', '-', 'Operaciones interiores exentas por aplicaci�n art�culo 25 Ley 19/1994');

            //JAV 08/06/22: - QuoSII 1.06.09 Se agrupa, unifica y simplifica la creaci�n de datos de la lista L4-TIPO IDENTIFICADOR
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::IDType, '0', '02', 'NIF-IVA', '');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::IDType, '1', '03', 'PASAPORTE', '');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::IDType, '2', '04', 'DOCUMENTO OFICIAL DE IDENTIFICACI�N EXPEDIDO POR EL PAIS O TERRITORIO DE RESIDENCIA', '');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::IDType, '3', '05', 'CERTIFICADO DE RESIDENCIA', '');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::IDType, '4', '06', 'OTRO DOCUMENTO PROBATORIO', '');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::IDType, '5', '07', 'NO CENSADO', '');

            //JAV 08/06/22: - QuoSII 1.06.09 Se agrupa, unifica y simplifica la creaci�n de datos de la lista L5-TIPO DE RECTIFICATIVA
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::CorrectedInvType, '1', 'I', 'Por diferencias', '');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::CorrectedInvType, '2', 'S', 'Por sustituci�n', '');

            //JAV 08/06/22: - QuoSII 1.06.09 Se agrupa, unifica y simplifica la creaci�n de datos de la lista L6-SITUACION INMUEBLE
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::PropertyLocation, '0', '1', 'Inmueble con referencia catastral situado en cualquier punto del territorio espa�ol, excepto Pa�s Vasco y Navarra',
                                                                                           'Inmueble con referencia catastral situado en las Islas Canarias');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::PropertyLocation, '1', '2', 'Inmueble situado en la Comunidad Aut�noma del Pa�s Vasco o en la Comunidad Foral de Navarra',
                                                                                           'Inmueble sin referencia catastral situado en las Islas Canarias');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::PropertyLocation, '2', '3', 'Inmueble en cualquiera de las situaciones anteriores pero sin referencia catastral',
                                                                                           'Inmueble con referencia catastral situado en el resto del territorio espa�ol');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::PropertyLocation, '3', '4', 'Inmueble situado en el extranjero',
                                                                                           'Inmueble sin referencia catastral situado en el resto del territorio espa�ol');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::PropertyLocation, '4', '5', '-',
                                                                                           'Inmueble situado en el extranjero');

            //JAV 08/06/22: - QuoSII 1.06.09 Se agrupa, unifica y simplifica la creaci�n de datos de la lista L7-CALIFICACION TIPO OPERACION
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::SujNoSuj, '0', 'S1', 'No exenta- Sin inversion sujeto pasivo', '');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::SujNoSuj, '1', 'S2', 'No exenta- Con inversion sujeto pasivo', '');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::SujNoSuj, '2', 'S3', 'No exenta- Sin inversion sujeto pasivo y con inversion sujeto pasivo', '');

            //JAV 08/06/22: - QuoSII 1.06.09 Se agrupa, unifica y simplifica la creaci�n de datos de la lista L9-CAUSA EXENCI�N
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::ExentType, '0', 'E1', 'Exenta por el art�culo 20', 'Exenta por el Art. 50 Ley 4/2012');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::ExentType, '1', 'E2', 'Exenta por el art�culo 21', 'Exenta por el Art. 11 Ley 20/1991');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::ExentType, '2', 'E3', 'Exenta por el art�culo 22', 'Exenta por el Art. 12 Ley 20/1991');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::ExentType, '3', 'E4', 'Exenta por art�culo 23 y 24', 'Exenta por el Art. 13 Ley 20/1991');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::ExentType, '4', 'E5', 'Exenta por el art�culo 25', 'Exenta por el Art. 25 Ley 19/1994');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::ExentType, '5', 'E6', 'Exenta por Otros', 'Exenta por el Art. 47 Ley 19/1994');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::ExentType, '5', 'E7', '-', 'Exenta por el Art. 110 Ley 4/2012');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::ExentType, '5', 'E8', '-', 'Exenta Otros');

            //JAV 08/06/22: - QuoSII 1.06.09 Se agrupa, unifica y simplifica la creaci�n de datos de la lista L10-EMITIDA POR TERCEROS
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::ThirdParty, '0', 'S', 'S�', '');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::ThirdParty, '1', 'N', 'No', '');

            //JAV 08/06/22: - QuoSII 1.06.09 Se agrupa, unifica y simplifica la creaci�n de datos de la lista L11-MEDIO PAGO/COBRO
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::PaymentMethod, '0', '01', 'Transferencia', '');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::PaymentMethod, '1', '02', 'Cheque', '');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::PaymentMethod, '2', '03', 'No se cobra / paga (fecha l�mite de devengo / devengo forzoso en concurso de acreedores)', '');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::PaymentMethod, '3', '04', 'Otros medios de cobro / pago', '');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::PaymentMethod, '4', '05', 'Domiciliaci�n bancaria', '');   //1.1

            //JAV 08/06/22: - QuoSII 1.06.09 Se agrupa, unifica y simplifica la creaci�n de datos de la lista L12-TIPO OP.INTRACOMUNITARIA
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::IntraType, '0', 'A', 'El env�o o recepci�n de bienes para la realizaci�n de los informes parciales o trabajos mencionados en '
                                                                                     + 'el art�culo 70, apartado uno, n�mero 7�, de la Ley del Impuesto (Ley 37/1992).', '');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::IntraType, '1', 'B', 'Las transferencias de bienes y las adquisiciones intracomunitarias de bienes comprendidas en los art�culos '
                                                                                     + '9, apartado 3�, y 16, apartado 2�, de la Ley del Impuesto (Ley 37/1992)', '');

            //JAV 08/06/22: - QuoSII 1.06.09 Se agrupa, unifica y simplifica la creaci�n de datos de la lista L13-DECLARADO INTRACOUNITARIO
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::IntraKey, '0', 'D', 'Declarante', '-');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::IntraKey, '1', 'R', 'Remitente', '-');

            //JAV 08/06/22: - QuoSII 1.06.09 Se agrupa, unifica y simplifica la creaci�n de datos de la lista L14-ESTADO GLOBAL DEL ENVIO
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::ShipStatus, '0', 'CORRECTO', 'Todas las facturas de la petici�n tienen el estado "CORRECTO"', '');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::ShipStatus, '1', 'PARCIALMENTECORRECTO', 'Algunas facturas de la petici�n tienen estado �INCORRECTO�', '');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::ShipStatus, '2', 'INCORRECTO', 'Todas las facturas de la petici�n tienen el estado "INCORRECTO"', '');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::ShipStatus, '3', 'CORRECTO', 'Todas las facturas de la petici�n tienen el estado "CORRECTO"', '');

            //JAV 08/06/22: - QuoSII 1.06.09 Se agrupa, unifica y simplifica la creaci�n de datos de la lista L15-ESTADO DEL ENVIO DE UNA FACTURA
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::InvStatus, '0', 'CORRECTO', 'La factura es totalmente correcta', '');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::InvStatus, '1', 'ACEPTADOCONERRORES', 'La factura tiene algunos errores que no provocan su rechazo', '');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::InvStatus, '2', 'INCORRECTO', 'La factura tiene errores que provocan su rechazo', '');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::InvStatus, '3', 'ANULADA', 'Anulada', '');

            //JAV 08/06/22: - QuoSII 1.06.09 Se agrupa, unifica y simplifica la creaci�n de datos de la lista L17-PAISES
            CreateSIIType_One(Company.Name, SIITypeListValue.Type::CountryIDType, '0', 'DE', 'ALEMANIA');
            CreateSIIType_One(Company.Name, SIITypeListValue.Type::CountryIDType, '1', 'AT', 'AUSTRIA');
            CreateSIIType_One(Company.Name, SIITypeListValue.Type::CountryIDType, '2', 'BE', 'BELGICA');
            CreateSIIType_One(Company.Name, SIITypeListValue.Type::CountryIDType, '3', 'BG', 'BULGARIA');
            CreateSIIType_One(Company.Name, SIITypeListValue.Type::CountryIDType, '4', 'CZ', 'CHECA, REPUBLICA');
            CreateSIIType_One(Company.Name, SIITypeListValue.Type::CountryIDType, '5', 'CY', 'CHIPRE');
            CreateSIIType_One(Company.Name, SIITypeListValue.Type::CountryIDType, '6', 'HR', 'CROACIA');
            CreateSIIType_One(Company.Name, SIITypeListValue.Type::CountryIDType, '7', 'DK', 'DINAMARCA');
            CreateSIIType_One(Company.Name, SIITypeListValue.Type::CountryIDType, '8', 'SK', 'ESLOVAQUIA');
            CreateSIIType_One(Company.Name, SIITypeListValue.Type::CountryIDType, '9', 'SI', 'ESLOVENIA');
            CreateSIIType_One(Company.Name, SIITypeListValue.Type::CountryIDType, '10', 'EE', 'ESTONIA');
            CreateSIIType_One(Company.Name, SIITypeListValue.Type::CountryIDType, '11', 'FI', 'FINLANDIA');
            CreateSIIType_One(Company.Name, SIITypeListValue.Type::CountryIDType, '12', 'FR', 'FRANCIA');
            //Q19001-
            CreateSIIType_One(Company.Name, SIITypeListValue.Type::CountryIDType, '13', 'EL', 'GRECIA');
            //CreateSIIType_One(Company.Name,SIITypeListValue.Type::CountryIDType,'13','GR','GRECIA');
            //Q19001+
            CreateSIIType_One(Company.Name, SIITypeListValue.Type::CountryIDType, '14', 'HU', 'HUNGRIA');
            CreateSIIType_One(Company.Name, SIITypeListValue.Type::CountryIDType, '15', 'IE', 'IRLANDA');
            CreateSIIType_One(Company.Name, SIITypeListValue.Type::CountryIDType, '16', 'IT', 'ITALIA');
            CreateSIIType_One(Company.Name, SIITypeListValue.Type::CountryIDType, '17', 'LV', 'LETONIA');
            CreateSIIType_One(Company.Name, SIITypeListValue.Type::CountryIDType, '18', 'LT', 'LITUANIA');
            CreateSIIType_One(Company.Name, SIITypeListValue.Type::CountryIDType, '19', 'LU', 'LUXEMBURGO');
            CreateSIIType_One(Company.Name, SIITypeListValue.Type::CountryIDType, '20', 'MT', 'MALTA');
            CreateSIIType_One(Company.Name, SIITypeListValue.Type::CountryIDType, '21', 'NL', 'PAISES BAJOS');
            CreateSIIType_One(Company.Name, SIITypeListValue.Type::CountryIDType, '22', 'PL', 'POLONIA');
            CreateSIIType_One(Company.Name, SIITypeListValue.Type::CountryIDType, '23', 'PT', 'PORTUGAL');
            CreateSIIType_One(Company.Name, SIITypeListValue.Type::CountryIDType, '24', 'GB', 'REINO UNIDO');
            CreateSIIType_One(Company.Name, SIITypeListValue.Type::CountryIDType, '25', 'RO', 'RUMANIA');
            CreateSIIType_One(Company.Name, SIITypeListValue.Type::CountryIDType, '26', 'SE', 'SUECIA');
            CreateSIIType_One(Company.Name, SIITypeListValue.Type::CountryIDType, '27', 'ES', 'ESPA�A');
            CreateSIIType_One(Company.Name, SIITypeListValue.Type::CountryIDType, '28', 'ME', 'MONTENEGRO');
            CreateSIIType_One(Company.Name, SIITypeListValue.Type::CountryIDType, '29', 'XI', 'IRLANDA DEL NORTE');   //1.1

            //JAV 08/06/22: - QuoSII 1.06.09 Se agrupa, unifica y simplifica la creaci�n de datos de la lista L20-VARIOS DESTINATARIOS
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::MultipleDest, '0', 'S', 'S� Multiple', '');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::MultipleDest, '1', 'N', 'No Multiple', '');

            //JAV 08/06/22: - QuoSII 1.06.09 Se agrupa, unifica y simplifica la creaci�n de datos de la lista L21-CLAVE OPERACION
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::MultipleDest, '0', 'A', 'Indemnizaciones o prestaciones satisfechas superiores a 3005,06', '');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::MultipleDest, '1', 'B', 'Primas o contraprestaciones percibidas superiores a 3005,06', '');

            //JAV 08/06/22: - QuoSII 1.06.09 Se agrupa, unifica y simplifica la creaci�n de datos de la lista L22-MINORACION BASE POR CUPON
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::Cupon, '0', 'S', 'S� Cup�n', '');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::Cupon, '1', 'N', 'No Cup�n', '');

            //JAV 08/06/22: - QuoSII 1.06.09 Se agrupa, unifica y simplifica la creaci�n de datos de la lista NO SE CUANDO SE USAN ESTAS
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::InvF4R5, '0', 'N', 'No InvF4R5', '');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::InvF4R5, '1', 'S', 'S� InvF4R5', '');

            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::NoVATType, '1', '7_14_OTROS', '7_14_OTROS', '');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::NoVATType, '1', 'TAI', 'Importe TAI Reglas Localizaci�n', '');
            CreateSIIType_Two(Company.Name, SIITypeListValue.Type::NoVATType, '1', '9_OTROS', '-', '9_OTROS');

        UNTIL Company.NEXT = 0;
    END;

    LOCAL PROCEDURE CreateSIIType_One(pCompany: Text; pType: Option; pNumber: Text; pCode: Text; pName: Text);
    VAR
        SIITypeListValue: Record 7174331;
    BEGIN
        //JAV 08/06/22: - QuoSII 1.06.09 Actualzia un registro en la tabla, sin entidad
        CLEAR(SIITypeListValue);
        SIITypeListValue.CHANGECOMPANY(pCompany);
        SIITypeListValue.INIT;
        SIITypeListValue.VALIDATE(Code, pCode);
        SIITypeListValue.VALIDATE(Description, pName);
        SIITypeListValue.VALIDATE(Type, pType);
        SIITypeListValue.VALIDATE(Value, FORMAT(pNumber));
        SIITypeListValue.VALIDATE("SII Entity", '');
        IF NOT SIITypeListValue.INSERT THEN
            IF SIITypeListValue.MODIFY THEN;
    END;

    LOCAL PROCEDURE CreateSIIType_Two(pCompany: Text; pType: Option; pNumber: Text; pCode: Text; pName1: Text; pName2: Text);
    VAR
        SIITypeListValue: Record 7174331;
    BEGIN
        //JAV 08/06/22: - QuoSII 1.06.09 Actualzia un registro en la tabla, para ambas entidades

        IF (pName1 <> '-') THEN BEGIN
            CLEAR(SIITypeListValue);
            SIITypeListValue.CHANGECOMPANY(pCompany);
            SIITypeListValue.INIT;
            SIITypeListValue.VALIDATE(Code, pCode);
            SIITypeListValue.VALIDATE(Description, pName1);
            SIITypeListValue.VALIDATE(Type, pType);
            SIITypeListValue.VALIDATE(Value, FORMAT(pNumber));
            SIITypeListValue.VALIDATE("SII Entity", 'AEAT');
            IF NOT SIITypeListValue.INSERT THEN
                IF SIITypeListValue.MODIFY THEN;
        END;

        IF (pName2 = '') THEN
            pName2 := pName2;

        IF (pName2 <> '-') THEN BEGIN
            CLEAR(SIITypeListValue);
            SIITypeListValue.CHANGECOMPANY(pCompany);
            SIITypeListValue.INIT;
            SIITypeListValue.VALIDATE(Code, pCode);
            SIITypeListValue.VALIDATE(Description, pName2);
            SIITypeListValue.VALIDATE(Type, pType);
            SIITypeListValue.VALIDATE(Value, FORMAT(pNumber));
            SIITypeListValue.VALIDATE("SII Entity", 'ATCN');
            IF NOT SIITypeListValue.INSERT THEN
                IF SIITypeListValue.MODIFY THEN;
        END;
    END;

    //[External]
    PROCEDURE FiltersFieldSpecialRegimen(SpecialRegimen: Code[20]): Text[150];
    BEGIN
        //QuoSII_1.4.98.999.begin
        IF SpecialRegimen = '07' THEN
            EXIT('01|03|05|09|11|12|13|14|15');

        IF SpecialRegimen = '05' THEN
            EXIT('01|06|08|11|12|13');

        IF SpecialRegimen = '06' THEN
            EXIT('05|11|12|13|14|15');

        IF (SpecialRegimen = '11') OR (SpecialRegimen = '12') OR (SpecialRegimen = '13') THEN
            EXIT('08|15');

        IF SpecialRegimen = '03' THEN
            EXIT('01');

        IF SpecialRegimen = '01' THEN
            EXIT('02|05|08');

        //QuoSII_1.4.98.999.end
    END;

    LOCAL PROCEDURE "------------------------------------ QB"();
    BEGIN
    END;

    [BusinessEvent(true, true)]
    LOCAL PROCEDURE OnBeforeProcessShipment();
    BEGIN
    END;

    [BusinessEvent(true, true)]
    LOCAL PROCEDURE OnAfterProcessShipment();
    BEGIN
    END;

    /*BEGIN
/*{
          11/09/17: - QUOSII_02_06 Validaci�n de datos antes del env�o a la AEAT
      MCM 27/11/17: - QuoSII_1.3.02.007 Correcci�n de la importaci�n de ficheros del primer semestre
      PEL 08/03/18: - QuoSII1.4.03
      MCM 18/04/18: - QuoSII1.4.04
      MCM 29/11/18: - QuoSII_1.4.02.042 Se incluye la opci�n de enviar a la ATCN
      QMD 11/07/19: - QuoSII_1.4.98.999 Filtros para la tabla SII Type List Value
      CHP 09/06/20: - 2001 QuoSII PBI 14603, asignamos en la DLL el valor del campo "Use SSL"
      JAV 08/09/21: - QuoSII 1.5z Se cambia el nombre del campo "Line Type" a "Register Type" que es mas informativo y as� no entra en confusi�n con campos denominados Type
      JAV 29/03/22: - QuoSII 1.06.06 El c�digo debe ser 13 no 14
      JAV 08/06/22: - QuoSII 1.06.09 Nuevo sistema de creaci�n de datos de la tabla auxiliar, mas legible y f�cil de ampliar.
      JAV 08/06/22: - QuoSII 1.06.09 Se dan de alta mas registros en la tabla de tipos (deb�a estar desde el 01/01/22 pero no se hizo en su momento)
      JAV 08/09/22: - QB 1.06.12 Se cambian nombres mal informados en Operaciones del Libro de Facturas Emitidas
      PSM 21/02/23: - Q19001 Modificar creaci�n de Periodos. Cambiar Grecia GR por EL
    }
END.*/
}









