Codeunit 7206901 "Obralia"
{


    trigger OnRun()
    VAR
        PurchasesPayablesSetup: Record 312;
        LogWS: Record 7206904;
        PurchInvHeader: Record 122;
        Envelope: Text;
    BEGIN
    END;

    VAR
        ContentTypeTxt: TextConst ENU = '"text/xml; charset=utf-8"', ESP = '"text/xml; charset=utf-8"';
        NoRequestBodyErr: TextConst ENU = 'The request body is not set.', ESP = 'El cuerpo de la solicitud no est� establecido.';
        NoServiceAddressErr: TextConst ENU = 'The web service URI is not set.', ESP = 'El URI de servicio web no est� establecido.';
        ExpectedResponseNotReceivedErr: TextConst ENU = 'The expected data was not received from the web service.', ESP = 'No se recibieron los datos esperados del servicio web.';
        ResponseBodyTempBlob: Codeunit "Temp Blob";
        Blob: OutStream;
        InStr: InStream;
        ResponseInStreamTempBlob: Codeunit "Temp Blob";
        HttpWebResponse: DotNet HttpWebResponse;
        GlobalPassword: Text;
        GlobalURL: Text;
        GlobalUsername: Text;
        GlobalDomain: Text;
        GlobalTimeout: Integer;
        GlobalProcess: Text;
        GlobalFilter: Text;
        GlobalProgressDialogEnabled: Boolean;
        vBigText: BigText;
        GlobalHttpWebResponseError: DotNet HttpWebResponse;
        GlobalReturnValue: Text[50];
        GlobalAlbDevValue: Code[20];
        GlobalAlbDevLinValue: Integer;
        RespondeTxt: TextConst ENU = 'Response: %1.', ESP = 'Respuesta: %1';
        RCarteraDoc: Record 7000002;
        vResponse: Integer;

    PROCEDURE SemaforoRequest_PurchHeader(PurchaseHeader: Record 38; Messages: Boolean): Integer;
    VAR
        LogWS: Record 7206904;
        Response: Text;
    BEGIN
        //Petici�n semaforo Obralia Factura sin registrar
        //Q19775-
        IF PurchaseHeader."Works Date" = 0D THEN
            EXIT(SemaforoRequest(PurchaseHeader.TABLECAPTION + ' ' + PurchaseHeader."No.",
                                 PurchaseHeader."Buy-from Vendor No.", PurchaseHeader."QB Job No.", TODAY(),
                                 Messages, PurchaseHeader."Document Date"))
        ELSE
            //Q19775+
            EXIT(SemaforoRequest(PurchaseHeader.TABLECAPTION + ' ' + PurchaseHeader."No.",
                             //Q19775-
                             PurchaseHeader."Buy-from Vendor No.", PurchaseHeader."QB Job No.", TODAY(),
                             Messages, PurchaseHeader."Works Date"));
        //PurchaseHeader."Buy-from Vendor No.",PurchaseHeader."QB Job No.",PurchaseHeader."Posting Date",
        //Messages));
        //Q19775+
    END;

    PROCEDURE SemaforoRequest_PostPurchHeader(PurchInvHeader: Record 122; Messages: Boolean): Integer;
    VAR
        LogWS: Record 7206904;
        Response: Text;
    BEGIN
        //Petici�n semaforo Obralia Factura registrada
        //Q19775-
        IF PurchInvHeader."Works Date" = 0D THEN
            EXIT(SemaforoRequest(PurchInvHeader.TABLECAPTION + ' ' + PurchInvHeader."No.",
                                 PurchInvHeader."Buy-from Vendor No.", PurchInvHeader."Job No.", TODAY(),
                                 Messages, PurchInvHeader."Document Date"))
        //Q19775+
        ELSE
            //Q19775+
            EXIT(SemaforoRequest(PurchInvHeader.TABLECAPTION + ' ' + PurchInvHeader."No.",
                             //Q19775-
                             PurchInvHeader."Buy-from Vendor No.", PurchInvHeader."Job No.", TODAY(),
                             Messages, PurchInvHeader."Works Date"));
        //PurchInvHeader."Buy-from Vendor No.",PurchInvHeader."Job No.",PurchInvHeader."Posting Date",
        //Messages));
        //Q19775+
    END;

    PROCEDURE SemaforoRequest_CarteraDoc(CarteraDoc: Record 7000002; Messages: Boolean): Integer;
    VAR
        PurchInvHeader: Record 122;
        LogWS: Record 7206904;
        Response: Text;
    BEGIN
        //Petici�n semaforo Obralia para una factura en cartera
        //Q19775-
        IF PurchInvHeader.GET(CarteraDoc."Document No.") THEN BEGIN
            IF PurchInvHeader."Works Date" = 0D THEN
                EXIT(SemaforoRequestPagos(CarteraDoc.TABLECAPTION + ' ' + CarteraDoc."No.",
                                          CarteraDoc."Account No.", CarteraDoc."Job No.", TODAY(),
                                          Messages, PurchInvHeader."Document Date"))
            ELSE
                //Q19775+
                EXIT(SemaforoRequestPagos(CarteraDoc.TABLECAPTION + ' ' + CarteraDoc."No.",
                                    //Q19775-
                                    CarteraDoc."Account No.", CarteraDoc."Job No.", TODAY(),
                                    Messages, PurchInvHeader."Works Date"));
            //CarteraDoc."Account No.",CarteraDoc."Job No.",CarteraDoc."Posting Date",
            //Messages));
            //Q19775+
            //Q19775-
        END ELSE
            EXIT(SemaforoRequestPagos(CarteraDoc.TABLECAPTION + ' ' + CarteraDoc."No.",
                                      CarteraDoc."Account No.", CarteraDoc."Job No.", TODAY(),
                                      Messages, CarteraDoc."Document Date"));
        //Q19775+
    END;

    PROCEDURE SemaforoRequest_Comparative(ComparativeQuoteHeader: Record 7207412; Messages: Boolean): Integer;
    BEGIN
        //Petici�n semaforo Obralia para un comparativo
        EXIT(SemaforoRequest(ComparativeQuoteHeader.TABLECAPTION + ' ' + ComparativeQuoteHeader."No.",
                             ComparativeQuoteHeader."Selected Vendor", ComparativeQuoteHeader."Job No.", ComparativeQuoteHeader."Comparative Date",
                             //Q19775-
                             Messages, ComparativeQuoteHeader."Comparative Date"));
        //Messages));
        //Q19775+
    END;

    LOCAL PROCEDURE SemaforoRequest(pFilter: Text; pVendor: Code[20]; pJob: Code[20]; pDate: Date; Messages: Boolean; wDate: Date): Integer;
    VAR
        Response: Text;
        LogWS: Record 7206904;
    BEGIN
        //Q19775- A�adir par�metro wDate
        //Petici�n semaforo Obralia

        GetObraliaConf(GlobalURL, GlobalUsername, GlobalPassword);
        GlobalDomain := '';
        GlobalProcess := 'CalcularSemaforoEmpresaTotalYPagosRequest';
        GlobalFilter := pFilter;
        GlobalProgressDialogEnabled := Messages;

        CLEAR(vBigText);
        NewRequest(LogWS, pVendor);

        FncCreateHDSOAPEnvelope(vBigText, GlobalProcess); //Cabecera
        FncCreateHDAuth(vBigText); //Autorizaci�n
                                   //Q19775-
        FncCreateBody(vBigText, pDate, pVendor, pJob, wDate); //Cuerpo
                                                              //FncCreateBody(vBigText,pDate,pVendor,pJob); //Cuerpo
                                                              //Q19775+
        FncCreateSLSOAPEnvelope(vBigText, GlobalProcess); //Pie

        SendRequestToWebService(LogWS, vBigText);

        LogWS.StoreObraliaXMLData;

        //Q19775-
        IF LogWS.semaforoPagos <> '' THEN
            Response := ' semaforo ' + LogWS.semaforoPagos
        //IF LogWS.semaforoTotal <> '' THEN
        //  Response := ' semaforo ' + LogWS.semaforoTotal
        //Q19775+
        ELSE
            Response := ' error ' + LogWS."Text Error";

        IF (Messages) THEN
            MESSAGE(RespondeTxt, Response);

        EXIT(LogWS."Entry No.");
    END;

    LOCAL PROCEDURE SemaforoRequestPagos(pFilter: Text; pVendor: Code[20]; pJob: Code[20]; pDate: Date; Messages: Boolean; wDate: Date): Integer;
    VAR
        Response: Text;
        LogWS: Record 7206904;
    BEGIN
        //Q19775- A�adir par�metro wDate
        //Petici�n semaforo pagos Obralia

        GetObraliaConf(GlobalURL, GlobalUsername, GlobalPassword);
        GlobalDomain := '';
        GlobalProcess := 'CalcularSemaforoEmpresaTotalYPagosRequest';
        GlobalFilter := pFilter;
        GlobalProgressDialogEnabled := Messages;

        CLEAR(vBigText);
        NewRequest(LogWS, pVendor);

        FncCreateHDSOAPEnvelope(vBigText, GlobalProcess); //Cabecera
        FncCreateHDAuth(vBigText); //Autorizaci�n
                                   //Q19775-
        FncCreateBody(vBigText, pDate, pVendor, pJob, wDate); //Cuerpo
                                                              //FncCreateBody(vBigText,pDate,pVendor,pJob); //Cuerpo
                                                              //Q19775+
        FncCreateSLSOAPEnvelope(vBigText, GlobalProcess); //Pie

        SendRequestToWebService(LogWS, vBigText);

        LogWS.StoreObraliaXMLData;

        IF LogWS.semaforoPagos <> '' THEN
            Response := ' semaforo ' + LogWS.semaforoPagos
        ELSE
            Response := ' error ' + LogWS."Text Error";

        IF (Messages) THEN
            MESSAGE(RespondeTxt, Response);

        EXIT(LogWS."Entry No.");
    END;

    LOCAL PROCEDURE NewRequest(VAR pLogWS: Record 7206904; pVendor: Code[20]);
    VAR
        LogWS: Record 7206904;
        nolin: Integer;
    BEGIN
        nolin := 1;
        LogWS.RESET;
        IF LogWS.FINDLAST THEN
            nolin := LogWS."Entry No." + 1;

        pLogWS.INIT;
        pLogWS."Entry No." := nolin;
        pLogWS."Datetime Process" := CURRENTDATETIME;
        pLogWS.User := USERID;
        pLogWS.Obralia := GlobalProcess;
        pLogWS.Filter := COPYSTR(GlobalFilter, 1, 70);
        pLogWS.Vendor := pVendor;
        pLogWS.INSERT(TRUE);
    END;

    [TryFunction]
    PROCEDURE SendRequestToWebService(VAR pLogWS: Record 7206904; VAR pBigText: BigText);
    VAR
        WebRequestHelper: Codeunit 1299;
        HttpWebRequest: DotNet HttpWebRequest;
        HttpStatusCode: DotNet HttpStatusCode;
        ResponseHeaders: DotNet NameValueCollection;
        ResponseInStream: InStream;
        WebException: DotNet WebException;
        XMLRequestDoc: DotNet XmlDocument;
        ResponseText: Text;
        StatusCode: DotNet HttpStatusCode;
        StatusDescription: Text;
    BEGIN
        CheckGlobals;
        BuildWebRequest(GlobalURL, HttpWebRequest);
        //ResponseInStreamTempBlob.INIT;
        Clear(ResponseInStreamTempBlob);
        ResponseInStreamTempBlob.CreateInStream(ResponseInStream, TextEncoding::Windows);
        CreateSoapRequest(HttpWebRequest.GetRequestStream, pBigText, pLogWS);
        IF NOT WebRequestHelper.GetWebResponse(HttpWebRequest, HttpWebResponse, ResponseInStream,
          HttpStatusCode, ResponseHeaders, GlobalProgressDialogEnabled) THEN BEGIN
            GetWebResponseError(WebException, GlobalURL, pLogWS);
            pLogWS.StoreErrorResponseXML();
            EXIT;
        END;

        StatusCode := HttpWebResponse.StatusCode;
        StatusDescription := HttpWebResponse.StatusDescription;

        ExtractContentFromResponse(ResponseInStream, ResponseBodyTempBlob, pLogWS, StatusDescription);
        EXIT;
    END;

    LOCAL PROCEDURE BuildWebRequest(ServiceUrl: Text; VAR HttpWebRequest: DotNet HttpWebRequest);
    VAR
        DecompressionMethods: DotNet DecompressionMethods;
        credentials: DotNet NetworkCredential;
        ContentTypeTxt: DotNet String;
    BEGIN
        HttpWebRequest := HttpWebRequest.Create(ServiceUrl);
        HttpWebRequest.Method := 'POST';
        HttpWebRequest.KeepAlive := TRUE;
        HttpWebRequest.AllowAutoRedirect := TRUE;

        HttpWebRequest.Credentials := credentials.NetworkCredential(GlobalUsername, GlobalPassword, GlobalDomain);
        /////////////////////HttpWebRequest.Headers.Add('SOAPAction','urn:microsoft-dynamics-schemas/codeunit/FuncionesWeb');
        HttpWebRequest.ContentType := ContentTypeTxt;
        IF GlobalTimeout <= 0 THEN
            GlobalTimeout := 300000;
        HttpWebRequest.Timeout := GlobalTimeout;
        HttpWebRequest.AutomaticDecompression := DecompressionMethods.GZip;
    END;

    LOCAL PROCEDURE CheckGlobals();
    VAR
        WebRequestHelper: Codeunit 1299;
    BEGIN
        IF GlobalURL = '' THEN
            ERROR(NoServiceAddressErr);
    END;

    LOCAL PROCEDURE CreateSoapRequest(RequestOutStream: OutStream; VAR pBigText: BigText; VAR pLogWS: Record 7206904);
    VAR
        XmlDoc: DotNet XmlDocument;
        BodyXmlNode: DotNet XmlNode;
    BEGIN

        XmlDoc := XmlDoc.XmlDocument;
        XmlDoc.LoadXml(pBigText);
        XmlDoc.Save(RequestOutStream);

        pLogWS.StoreRequestXml(FORMAT(vBigText));
    END;

    LOCAL PROCEDURE ExtractContentFromResponse(VAR ResponseInStream: InStream; VAR BodyTempBlob: Codeunit "Temp Blob"; VAR pLogWS: Record 7206904; VAR pTxtDescription: Text);
    VAR
        ResponseBodyXMLDoc: DotNet XmlDocument;
        ResponseBodyXmlNode: DotNet XmlNode;
        BodyOutStream: OutStream;
        XML: DotNet XmlDocument;
        XmlNode: DotNet XmlNode;
        XmlNodeList: DotNet XmlNodeList;
        i: Integer;
        TxtResult: Text;
    BEGIN
        XML := XML.XmlDocument;
        XML.Load(ResponseInStream);
        XmlNodeList := XML.SelectNodes('//*');

        FOR i := 0 TO XmlNodeList.Count - 1 DO BEGIN
            XmlNode := XmlNodeList.Item(i);
            IF XmlNode.Name = 'return_value' THEN BEGIN
                TxtResult := XmlNode.InnerXml;
                GlobalReturnValue := TxtResult;
            END;
        END;

        pLogWS.StoreResponseXmlinstream(ResponseInStream, pTxtDescription, COPYSTR(TxtResult, 1, 50));
        COMMIT;
    END;

    PROCEDURE GetResponseContent(VAR ResponseBodyInStream: InStream);
    BEGIN
        ResponseBodyTempBlob.CreateInStream(ResponseBodyInStream, TextEncoding::Windows);
    END;

    //[Internal]
    PROCEDURE GetWebResponseError(VAR WebException: DotNet WebException; pServiceURL: Text; VAR pLogWS: Record 7206904): Text;
    VAR
        DotNetExceptionHandler: Codeunit 1291;
        WebExceptionStatus: DotNet WebExceptionStatus;
        HttpStatusCode: DotNet HttpStatusCode;
        ErrorText: Text;
        MemoryStream: DotNet MemoryStream;
        pOutStream: OutStream;
        XMLRequestDoc: DotNet XmlDocument;
        ConnectionErr: TextConst ENU = 'Connection to the remote service could not be established.\\', ESP = 'No se pudo establecer la conexi�n con el servicio remoto.\\';
        ServiceURLTxt: TextConst ENU = '\\Service URL: %1.', ESP = '\\URL de servicio: %1.';
    BEGIN
        DotNetExceptionHandler.Collect;

        IF NOT DotNetExceptionHandler.CastToType(WebException, GETDOTNETTYPE(WebException)) THEN
            DotNetExceptionHandler.Rethrow;

        IF NOT ISNULL(WebException.Response) THEN
            IF NOT ISNULL(WebException.Response.ResponseUri) THEN
                pServiceURL := STRSUBSTNO(ServiceURLTxt, WebException.Response.ResponseUri.AbsoluteUri);

        ErrorText := ConnectionErr + WebException.Message + pServiceURL;
        IF NOT WebException.Status.Equals(WebExceptionStatus.ProtocolError) THEN
            EXIT(ErrorText);

        IF ISNULL(XMLRequestDoc) THEN
            XMLRequestDoc := XMLRequestDoc.XmlDocument;
        MemoryStream := WebException.Response.GetResponseStream;
        IF MemoryStream.Length <> 0 THEN
            XMLRequestDoc.Load(MemoryStream);
        pLogWS."Response XML".CREATEOUTSTREAM(pOutStream);
        pLogWS."Text Error" := COPYSTR(GETLASTERRORTEXT, 1, 200);
        pLogWS.Result := COPYSTR(ErrorText, 1, 50);
        XMLRequestDoc.Save(pOutStream);
        pLogWS.MODIFY;
        MemoryStream.Flush;
        MemoryStream.Close;
        COMMIT;

        IF ISNULL(WebException.Response) THEN
            DotNetExceptionHandler.Rethrow;

        GlobalHttpWebResponseError := WebException.Response;
        IF NOT (GlobalHttpWebResponseError.StatusCode.Equals(HttpStatusCode.Found) OR
                GlobalHttpWebResponseError.StatusCode.Equals(HttpStatusCode.InternalServerError))
        THEN
            EXIT(ErrorText);

        EXIT('');
    END;

    LOCAL PROCEDURE FncCreateHDSOAPEnvelope(VAR pTxtSOAP: BigText; pParName: Text);
    BEGIN

        CLEAR(pTxtSOAP);
        pTxtSOAP.ADDTEXT('<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:sch="http://www.obralia.com/integration/schemas">');
        pTxtSOAP.ADDTEXT('<soapenv:Header/><soapenv:Body>');
        pTxtSOAP.ADDTEXT('<sch: Option "+pParName+">');
    END;

    LOCAL PROCEDURE FncCreateSLSOAPEnvelope(VAR pTxtSOAP: BigText; pParName: Text);
    BEGIN

        pTxtSOAP.ADDTEXT('</sch: Option "+pParName+"></soapenv:Body></soapenv:Envelope>');
    END;

    LOCAL PROCEDURE FncCreateHDAuth(VAR pTxtSOAP: BigText);
    BEGIN

        pTxtSOAP.ADDTEXT('<sch:authObralia>');
        pTxtSOAP.ADDTEXT('<sch:username>' + GlobalUsername + '</sch:username>');
        pTxtSOAP.ADDTEXT('<sch:password>' + GlobalPassword + '</sch:password>');
        pTxtSOAP.ADDTEXT('</sch:authObralia>');
    END;

    LOCAL PROCEDURE FncCreateBody(VAR pTxtSOAP: BigText; pDate: Date; pVendor: Code[20]; pJob: Code[20]; wDate: Date);
    VAR
        CompanyInformation: Record 79;
        Job: Record 167;
        Vendor: Record 23;
    BEGIN
        //Q19775 A�adir par�metro wDate
        //Crear el cuerpo de la llamada
        CompanyInformation.GET;

        Vendor.GET(pVendor);
        Vendor.TESTFIELD("VAT Registration No.");

        Job.GET(pJob);
        Job.TESTFIELD("Obralia Code");

        pTxtSOAP.ADDTEXT('<sch:cifEmpresa>' + FORMAT(CompanyInformation."VAT Registration No.") + '</sch:cifEmpresa>');
        pTxtSOAP.ADDTEXT('<sch:cifProveedor>' + Vendor."VAT Registration No." + '</sch:cifProveedor>');
        pTxtSOAP.ADDTEXT('<sch:cifPropietario>' + FORMAT(CompanyInformation."VAT Registration No.") + '</sch:cifPropietario>');
        pTxtSOAP.ADDTEXT('<sch:codigoObra>' + Job."Obralia Code" + '</sch:codigoObra>');
        //Q19775-
        pTxtSOAP.ADDTEXT('<sch:fechaTrabajos>' + FORMAT(wDate, 10, '<Year4>-<Month,2>-<Day,2>') + '</sch:fechaTrabajos>');
        //pTxtSOAP.ADDTEXT('<sch:fechaTrabajos>' + FORMAT(pDate,10,'<Year4>-<Month,2>-<Day,2>') + '</sch:fechaTrabajos>');
        //Q19775+
        pTxtSOAP.ADDTEXT('<sch:fechaFactura>' + FORMAT(pDate, 10, '<Year4>-<Month,2>-<Day,2>') + '</sch:fechaFactura>');
    END;

    LOCAL PROCEDURE GetObraliaConf(VAR pURL: Text; VAR pUsr: Text; VAR pPss: Text);
    VAR
        PurchasesPayablesSetup: Record 312;
    BEGIN
        PurchasesPayablesSetup.GET();
        IF (PurchasesPayablesSetup."Obralia WS" = '') THEN
            pURL := 'https://www.obralia.com/ws/integration/services/calculosSemaforos.wsdl'
        ELSE
            pURL := PurchasesPayablesSetup."Obralia WS";

        pUsr := PurchasesPayablesSetup."Obralia User";
        pPss := PurchasesPayablesSetup."Obralia Password";
    END;


    /*BEGIN
    /*{

          ///QUONEXT PER 28.05.19 Revisi�n de procedimiento de Obralia, llamada proceso automatico.Revisi�n.
          ---------------------------------------------------------------------------------------------------------
          C�digo anterior onrun:

          CompanyInformation.GET;

          GlobalURL := 'https://www.obralia.com/ws/integration/services/calculosSemaforos.wsdl';
          GlobalUsername := 'NAVISI�N';
          GlobalPassword := 'Navision_01';
          GlobalDomain := '';

          CLEAR(vBigText);
          NewRequest(LogWS);

          FncCreateHDSOAPEnvelope('CalcularSemaforoEmpresaTotalYPagosRequest',vBigText);
          FncCreateHDAuth(vBigText);
          FncCreateBodyHD(vBigText);
          FncCreateSLSOAPEnvelope('CalcularSemaforoEmpresaTotalYPagosRequest',vBigText);

          SendRequestToWebService(LogWS,vBigText);

          MESSAGE('Finalizado.');
          ---------------------------------------------------------------------------------------------------------
          Q19458 AML 22/05/23 Cambiada llamada a funcion CalcularSemaforoEmpresaYTotalRequest por CalcularSemaforoEmpresaTotalYPagosRequest
          Q19458 PSM 22/05/23 Capturar respuesta de SemaforoPagos para los documentos en cartera
          Q19775 PSM 20/07/23 Modificar los Request, para enviar dos fechas distintas: para fechaTrabajo Work Date o Document Date, y para fechaFactura usar TODAY
                              Capturar respuesta SemaforoPagos en todos los casos
        }
    END.*/
}









