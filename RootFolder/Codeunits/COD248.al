Codeunit 50008 "VAT Lookup Ext. Data Hndl 1"
{


    TableNo = 249;
    Permissions = TableData 249 = rimd;
    trigger OnRun()
    BEGIN
        VATRegistrationLog := Rec;

        LookupVatRegistrationFromWebService(TRUE);

        Rec := VATRegistrationLog;
    END;

    VAR
        NamespaceTxt: TextConst ENU = 'urn:ec.europa.eu:taxud:vies:services:checkVat:types', ESP = 'urn:ec.europa.eu:taxud:vies:services:checkVat:types';
        VATRegistrationLog: Record 249;
        VATRegistrationLogMgt: Codeunit 249;
        VatRegNrValidationWebServiceURLTxt: TextConst ENU = 'http://ec.europa.eu/taxation_customs/vies/services/checkVatService', ESP = 'http://ec.europa.eu/taxation_customs/vies/services/checkVatService';
        VATRegistrationURL: Text;

    LOCAL PROCEDURE LookupVatRegistrationFromWebService(ShowErrors: Boolean);
    VAR
        RequestBodyTempBlob:codeunit "Temp Blob";
    BEGIN
        //RequestBodyTempBlob.INIT;
        Clear(RequestBodyTempBlob);
        SendRequestToVatRegistrationService(RequestBodyTempBlob, ShowErrors);

        InsertLogEntry(RequestBodyTempBlob);

        COMMIT;
    END;

    LOCAL PROCEDURE SendRequestToVatRegistrationService(VAR BodyTempBlob: codeunit "Temp Blob"; ShowErrors: Boolean);
    VAR
        VATRegNoSrvConfig: Record 248;
        SOAPWebServiceRequestMgt: Codeunit 1290;
        ResponseInStream: InStream;
        InStream: InStream;
        ResponseOutStream: OutStream;
    BEGIN
        PrepareSOAPRequestBody(BodyTempBlob);

        BodyTempBlob.CreateInStream(InStream, TextEncoding::Windows);
        VATRegistrationURL := VATRegNoSrvConfig.GetVATRegNoURL;

        //+++HOTFIX
        SOAPWebServiceRequestMgt.SetContentType('text/xml; charset=utf-8');
        //---HOTFIX

        SOAPWebServiceRequestMgt.SetGlobals(InStream, VATRegistrationURL, '', '');
        SOAPWebServiceRequestMgt.DisableHttpsCheck;
        SOAPWebServiceRequestMgt.SetTimeout(60000);

        IF SOAPWebServiceRequestMgt.SendRequestToWebService THEN BEGIN
            SOAPWebServiceRequestMgt.GetResponseContent(ResponseInStream);

            BodyTempBlob.CreateOutStream(ResponseOutStream, TextEncoding::Windows);
            COPYSTREAM(ResponseOutStream, ResponseInStream);
        END ELSE
            IF ShowErrors THEN
                SOAPWebServiceRequestMgt.ProcessFaultResponse('');
    END;

    LOCAL PROCEDURE PrepareSOAPRequestBody(VAR BodyTempBlob: Codeunit "Temp Blob");
    VAR
        XMLDOMMgt: Codeunit 6224;
        BodyContentInputStream: InStream;
        BodyContentOutputStream: OutStream;
        BodyContentXmlDoc: DotNet XmlDocument;
        EnvelopeXmlNode: DotNet XmlNode;
        CreatedXmlNode: DotNet XmlNode;
    BEGIN
        BodyTempBlob.CreateInStream(BodyContentInputStream, TextEncoding::Windows);
        BodyContentXmlDoc := BodyContentXmlDoc.XmlDocument;

        XMLDOMMgt.AddRootElementWithPrefix(BodyContentXmlDoc, 'checkVatApprox', '', NamespaceTxt, EnvelopeXmlNode);
        XMLDOMMgt.AddElement(EnvelopeXmlNode, 'countryCode', VATRegistrationLog.GetCountryCode, NamespaceTxt, CreatedXmlNode);
        XMLDOMMgt.AddElement(EnvelopeXmlNode, 'vatNumber', VATRegistrationLog.GetVATRegNo, NamespaceTxt, CreatedXmlNode);

        //CLEAR(BodyTempBlob.Blob);
        BodyTempBlob.CreateOutStream(BodyContentOutputStream, TextEncoding::Windows);
        BodyContentXmlDoc.Save(BodyContentOutputStream);
    END;

    LOCAL PROCEDURE InsertLogEntry(ResponseBodyTempBlob: codeunit "Temp Blob");
    VAR
        XMLDOMManagement: Codeunit 6224;
        XMLDocOut: DotNet XmlDocument;
        InStream: InStream;
    BEGIN
        ResponseBodyTempBlob.CreateInStream(InStream, TextEncoding::Windows);
        XMLDOMManagement.LoadXMLDocumentFromInStream(InStream, XMLDocOut);

        VATRegistrationLogMgt.LogVerification(VATRegistrationLog, XMLDocOut, NamespaceTxt);
    END;

    //[External]
    // PROCEDURE GetVATRegNrValidationWebServiceURL() : Text[250];
    // BEGIN
    //   EXIT(VatRegNrValidationWebServiceURLTxt);
    // END;

    /*BEGIN
/*{
      JAV 05/09/22: - QB 1.11.02 Se a�ade el HotFix para validar el NIF, marcado como //+++HOTFIX
    }
END.*/
}







