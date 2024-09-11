Codeunit 50024 "SII Doc. Upload Management 1"
{


    trigger OnRun()
    BEGIN
    END;

    VAR
        SIISetup: Record 10751;
        SIIXMLCreator: Codeunit 50023;
        X509Certificate2: DotNet X509Certificate2;
        RequestType: Option "InvoiceIssuedRegistration","InvoiceReceivedRegistration","PaymentSentRegistration","PaymentReceivedRegistration","CollectionInCashRegistration";
        NoCertificateErr: TextConst ENU = 'Could not get certificate.', ESP = 'No se pudo obtener el certificado.';
        NoConnectionErr: TextConst ENU = 'Could not establish connection.', ESP = 'No se pudo establecer la conexi�n.';
        NoResponseErr: TextConst ENU = 'Could not get response.', ESP = 'No se pudo obtener respuesta.';
        NoCustLedgerEntryErr: TextConst ENU = 'Customer Ledger Entry could not be found.', ESP = 'No se encontr� el movimiento de cliente.';
        NoDetailedCustLedgerEntryErr: TextConst ENU = 'Detailed Customer Ledger Entry could not be found.', ESP = 'No se encontr� el movimiento de cliente detallado.';
        NoVendLedgerEntryErr: TextConst ENU = 'Vendor Ledger Entry could not be found.', ESP = 'No se encontr� el movimiento de proveedor.';
        NoDetailedVendLedgerEntryErr: TextConst ENU = 'Detailed Vendor Ledger Entry could not be found.', ESP = 'No se encontr� el movimiento de proveedor detallado.';
        CommunicationErr: TextConst ENU = 'Communication error: %1.', ESP = 'Error de comunicaci�n: %1.';
        ParseMatchDocumentErr: TextConst ENU = 'Parse error: couldn''t match the documents.', ESP = 'Error de an�lisis: no se pudieron asignar los documentos.';

    LOCAL PROCEDURE InvokeBatchSoapRequest(SIISession: Record 10753; VAR TempSIIHistoryBuffer: Record 10750 TEMPORARY; RequestText: Text; RequestType: Option "InvoiceIssuedRegistration","InvoiceReceivedRegistration","PaymentSentRegistration","PaymentReceivedRegistration","CollectionInCashRegistration"; VAR ResponseText: Text): Boolean;
    VAR
        WebRequest: DotNet WebRequest;
        HttpWebRequest: DotNet HttpWebRequest;
        RequestStream: DotNet Stream;
        Encoding: DotNet Encoding;
        ByteArray: DotNet Array;
        Uri: DotNet Uri;
        HttpWebResponse: DotNet HttpWebResponse;
        StatusCode: DotNet HttpStatusCode;
        WebServiceUrl: Text;
        StatusDescription: Text[250];
    BEGIN
        // IF NOT GetCertificate THEN BEGIN
        //     ProcessBatchResponseCommunicationError(TempSIIHistoryBuffer, NoCertificateErr);
        //     EXIT(FALSE);
        // END;

        CASE RequestType OF
            RequestType::InvoiceIssuedRegistration:
                WebServiceUrl := SIISetup.InvoicesIssuedEndpointUrl;
            RequestType::InvoiceReceivedRegistration:
                WebServiceUrl := SIISetup.InvoicesReceivedEndpointUrl;
            RequestType::PaymentReceivedRegistration:
                WebServiceUrl := SIISetup.PaymentsReceivedEndpointUrl;
            RequestType::PaymentSentRegistration:
                WebServiceUrl := SIISetup.PaymentsIssuedEndpointUrl;
            RequestType::CollectionInCashRegistration:
                WebServiceUrl := SIISetup.CollectionInCashEndpointUrl;
        END;

        SIISession.StoreRequestXml(RequestText);

        HttpWebRequest := WebRequest.Create(Uri.Uri(WebServiceUrl));
        HttpWebRequest.ClientCertificates.Add(X509Certificate2);
        HttpWebRequest.Method := 'POST';
        HttpWebRequest.ContentType := 'application/xml';

        ByteArray := Encoding.UTF8.GetBytes(RequestText);
        HttpWebRequest.ContentLength := ByteArray.Length;
        IF NOT TryCreateRequestStream(HttpWebRequest, RequestStream) THEN BEGIN
            ProcessBatchResponseCommunicationError(TempSIIHistoryBuffer, NoConnectionErr);
            EXIT(FALSE);
        END;

        RequestStream.Write(ByteArray, 0, ByteArray.Length);

        IF NOT TryGetWebResponse(HttpWebRequest, HttpWebResponse) THEN BEGIN
            ProcessBatchResponseCommunicationError(TempSIIHistoryBuffer, NoResponseErr);
            EXIT(FALSE);
        END;

        StatusCode := HttpWebResponse.StatusCode;
        StatusDescription := HttpWebResponse.StatusDescription;
        ResponseText := ReadHttpResponseAsText(HttpWebResponse);
        SIISession.StoreResponseXml(ResponseText);
        IF NOT StatusCode.Equals(StatusCode.Accepted) AND NOT StatusCode.Equals(StatusCode.OK) THEN BEGIN
            ProcessBatchResponseCommunicationError(
              TempSIIHistoryBuffer, STRSUBSTNO(CommunicationErr, StatusDescription));
            EXIT(FALSE);
        END;

        EXIT(TRUE);
    END;

    [TryFunction]
    LOCAL PROCEDURE TryCreateRequestStream(HttpWebRequest: DotNet HttpWebRequest; VAR RequestStream: DotNet Stream);
    BEGIN
        RequestStream := HttpWebRequest.GetRequestStream;
    END;

    [TryFunction]
    LOCAL PROCEDURE TryGetWebResponse(HttpWebRequest: DotNet HttpWebRequest; VAR HttpWebResponse: DotNet HttpWebResponse);
    VAR
        Task: DotNet Task_Of_T;
    BEGIN
        Task := HttpWebRequest.GetResponseAsync;
        HttpWebResponse := Task.Result;
    END;

    // LOCAL PROCEDURE GetCertificate(): Boolean;
    // BEGIN
    //     EXIT(SIISetup.LoadCertificateFromBlob(X509Certificate2));
    // END;

    LOCAL PROCEDURE ReadHttpResponseAsText(HttpWebResponse: DotNet HttpWebResponse) ResponseText: Text;
    VAR
        StreamReader: DotNet StreamReader;
    BEGIN
        StreamReader := StreamReader.StreamReader(HttpWebResponse.GetResponseStream);
        ResponseText := StreamReader.ReadToEnd;
    END;

    LOCAL PROCEDURE ExecutePendingRequests(VAR SIIDocUploadState: Record 10752; VAR TempSIIHistoryBuffer: Record 10750 TEMPORARY; BatchSubmissions: Boolean);
    VAR
        SIISession: Record 10753;
        XMLDoc: DotNet XmlDocument;
        IsInvokeSoapRequest: Boolean;
    BEGIN
        SIIDocUploadState.FINDSET(TRUE);
        PreExecutePendingRequests(SIISession, IsInvokeSoapRequest, NOT BatchSubmissions);
        REPEAT
            PreExecutePendingRequests(SIISession, IsInvokeSoapRequest, BatchSubmissions);
            ExecutePendingRequestsPerDocument(SIIDocUploadState, TempSIIHistoryBuffer, XMLDoc, IsInvokeSoapRequest, SIISession.Id);
            PostExecutePendingRequests(SIIDocUploadState, TempSIIHistoryBuffer, SIISession, XMLDoc, IsInvokeSoapRequest, BatchSubmissions);
        UNTIL SIIDocUploadState.NEXT = 0;
        PostExecutePendingRequests(SIIDocUploadState, TempSIIHistoryBuffer, SIISession, XMLDoc, IsInvokeSoapRequest, NOT BatchSubmissions);
    END;

    LOCAL PROCEDURE ExecutePendingRequestsPerDocument(VAR SIIDocUploadState: Record 10752; VAR TempSIIHistoryBuffer: Record 10750 TEMPORARY; VAR XMLDoc: DotNet XmlDocument; VAR IsInvokeSoapRequest: Boolean; SIISessionId: Integer);
    VAR
        DotNetExceptionHandler: Codeunit 1291;
        IsSupported: Boolean;
        Message: Text;
    BEGIN
        TempSIIHistoryBuffer.SETRANGE("Document State Id", SIIDocUploadState.Id);
        IF TempSIIHistoryBuffer.FINDSET THEN
            REPEAT
                TempSIIHistoryBuffer."Session Id" := SIISessionId;
                IF NOT TryGenerateXml(SIIDocUploadState, TempSIIHistoryBuffer, XMLDoc, IsSupported, Message) THEN BEGIN
                    DotNetExceptionHandler.Collect;
                    TempSIIHistoryBuffer.Status := TempSIIHistoryBuffer.Status::Failed;
                    TempSIIHistoryBuffer."Error Message" :=
                      COPYSTR(DotNetExceptionHandler.GetMessage, 1, MAXSTRLEN(TempSIIHistoryBuffer."Error Message"));
                    SIIDocUploadState.Status := SIIDocUploadState.Status::Failed;
                    SIIDocUploadState.MODIFY;
                END ELSE
                    IF NOT IsSupported THEN BEGIN
                        TempSIIHistoryBuffer.Status := TempSIIHistoryBuffer.Status::"Not Supported";
                        SIIDocUploadState.Status := SIIDocUploadState.Status::"Not Supported";
                        TempSIIHistoryBuffer."Error Message" := COPYSTR(Message, 1, MAXSTRLEN(TempSIIHistoryBuffer."Error Message"));
                        SIIDocUploadState.MODIFY;
                    END ELSE
                        IsInvokeSoapRequest := TRUE OR IsInvokeSoapRequest;
                TempSIIHistoryBuffer.MODIFY;
            UNTIL TempSIIHistoryBuffer.NEXT = 0;
    END;

    LOCAL PROCEDURE PreExecutePendingRequests(VAR SIISession: Record 10753; VAR IsInvokeSoapRequest: Boolean; SkipPrePost: Boolean);
    BEGIN
        IF SkipPrePost THEN
            EXIT;

        SIIXMLCreator.Reset;
        CreateNewSessionRecord(SIISession);
        IsInvokeSoapRequest := FALSE;
    END;

    LOCAL PROCEDURE PostExecutePendingRequests(VAR SIIDocUploadState: Record 10752; VAR TempSIIHistoryBuffer: Record 10750 TEMPORARY; SIISession: Record 10753; XMLDoc: DotNet XmlDocument; IsInvokeSoapRequest: Boolean; SkipPrePost: Boolean);
    VAR
        ResponseText: Text;
    BEGIN
        IF SkipPrePost THEN
            EXIT;

        TempSIIHistoryBuffer.SETRANGE("Document State Id");
        TempSIIHistoryBuffer.SETRANGE("Session Id", SIISession.Id);
        TempSIIHistoryBuffer.SETRANGE(Status, TempSIIHistoryBuffer.Status::Pending);
        IF IsInvokeSoapRequest THEN
            IF InvokeBatchSoapRequest(SIISession, TempSIIHistoryBuffer, XMLDoc.OuterXml, RequestType, ResponseText) THEN
                ParseBatchResponse(SIIDocUploadState, TempSIIHistoryBuffer, ResponseText);

        TempSIIHistoryBuffer.SETRANGE("Session Id");
        TempSIIHistoryBuffer.SETRANGE(Status);
    END;

    // PROCEDURE UploadPendingDocuments();
    // VAR
    //     SIIDocUploadState: Record 10752;
    // BEGIN
    //     IF NOT GetAndCheckSetup THEN
    //         EXIT;

    //     IF SIISetup."Enable Batch Submissions" AND (SIISetup."Job Batch Submission Threshold" > 0) THEN BEGIN
    //         SetDocStateFilters(SIIDocUploadState, FALSE);
    //         IF SIIDocUploadState.COUNT < SIISetup."Job Batch Submission Threshold" THEN
    //             EXIT;
    //     END;

    //     // Process only automatically-created documents
    //     UploadDocuments(FALSE);
    // END;

    // PROCEDURE UploadManualDocument();
    // BEGIN
    //     IF NOT GetAndCheckSetup THEN
    //         EXIT;

    //     // Process only manually-created documents
    //     UploadDocuments(TRUE);
    // END;

    // LOCAL PROCEDURE UploadDocuments(IsManual: Boolean);
    // VAR
    //     SIIDocUploadState: Record 10752;
    //     TempSIIHistoryBuffer: Record 10750 TEMPORARY;
    // BEGIN
    //     WITH SIIDocUploadState DO BEGIN
    //         SetDocStateFilters(SIIDocUploadState, IsManual);
    //         IF NOT ISEMPTY THEN BEGIN
    //             CreateHistoryPendingBuffer(TempSIIHistoryBuffer, IsManual);

    //             // Customer Invoice
    //             UploadDocumentsPerTransactionFilter(
    //               SIIDocUploadState, TempSIIHistoryBuffer, "Document Source"::"Customer Ledger", "Document Type"::Invoice, '');
    //             // Customer Credit Memo
    //             UploadDocumentsPerTransactionFilter(
    //               SIIDocUploadState, TempSIIHistoryBuffer, "Document Source"::"Customer Ledger", "Document Type"::"Credit Memo", '0');
    //             // Customer Credit Memo Removal
    //             UploadDocumentsPerTransactionFilter(
    //               SIIDocUploadState, TempSIIHistoryBuffer, "Document Source"::"Customer Ledger", "Document Type"::"Credit Memo", '1');
    //             // Customer Payment
    //             UploadDocumentsPerTransactionFilter(
    //               SIIDocUploadState, TempSIIHistoryBuffer, "Document Source"::"Detailed Customer Ledger", "Document Type"::Payment, '');
    //             // Vendor Invoice
    //             UploadDocumentsPerTransactionFilter(
    //               SIIDocUploadState, TempSIIHistoryBuffer, "Document Source"::"Vendor Ledger", "Document Type"::Invoice, '');
    //             // Vendor Credit Memo
    //             UploadDocumentsPerTransactionFilter(
    //               SIIDocUploadState, TempSIIHistoryBuffer, "Document Source"::"Vendor Ledger", "Document Type"::"Credit Memo", '0');
    //             // Vendor Credit Memo Removal
    //             UploadDocumentsPerTransactionFilter(
    //               SIIDocUploadState, TempSIIHistoryBuffer, "Document Source"::"Vendor Ledger", "Document Type"::"Credit Memo", '1');
    //             // Vendor Payment
    //             UploadDocumentsPerTransactionFilter(
    //               SIIDocUploadState, TempSIIHistoryBuffer, "Document Source"::"Detailed Vendor Ledger", "Document Type"::Payment, '');

    //             RESET;
    //             SetDocStateFilters(SIIDocUploadState, IsManual);
    //             // Collection in cash
    //             UploadDocumentsPerFilter(SIIDocUploadState, TempSIIHistoryBuffer, "Transaction Type"::"Collection In Cash", FALSE);
    //             UploadDocumentsPerFilter(SIIDocUploadState, TempSIIHistoryBuffer, "Transaction Type"::"Collection In Cash", TRUE);

    //             SaveHistoryPendingBuffer(TempSIIHistoryBuffer, IsManual);
    //         END;
    //     END;
    // END;

    LOCAL PROCEDURE UploadDocumentsPerTransactionFilter(VAR SIIDocUploadState: Record 10752; VAR TempSIIHistoryBuffer: Record 10750 TEMPORARY; DocumentSource: Option; DocumentType: Option; IsCreditMemoRemovalFilter: Text);
    BEGIN
        WITH SIIDocUploadState DO BEGIN
            SETRANGE("Document Source", DocumentSource);
            SETRANGE("Document Type", DocumentType);
            SETFILTER("Is Credit Memo Removal", IsCreditMemoRemovalFilter);
            UploadDocumentsPerFilter(SIIDocUploadState, TempSIIHistoryBuffer, "Transaction Type"::Regular, FALSE);
            UploadDocumentsPerFilter(SIIDocUploadState, TempSIIHistoryBuffer, "Transaction Type"::Regular, TRUE);
            UploadDocumentsPerFilter(SIIDocUploadState, TempSIIHistoryBuffer, "Transaction Type"::RetryAccepted, FALSE);
            UploadDocumentsPerFilter(SIIDocUploadState, TempSIIHistoryBuffer, "Transaction Type"::RetryAccepted, TRUE);
        END;
    END;

    LOCAL PROCEDURE UploadDocumentsPerFilter(VAR SIIDocUploadState: Record 10752; VAR TempSIIHistoryBuffer: Record 10750 TEMPORARY; TransactionType: Option; RetryAccepted: Boolean);
    BEGIN
        WITH SIIDocUploadState DO BEGIN
            SETRANGE("Transaction Type", TransactionType);
            SETRANGE("Retry Accepted", RetryAccepted);
            IF NOT ISEMPTY THEN
                ExecutePendingRequests(
                  SIIDocUploadState, TempSIIHistoryBuffer, SIISetup."Enable Batch Submissions");
        END;
    END;

    [TryFunction]
    LOCAL PROCEDURE TryGenerateXml(SIIDocUploadState: Record 10752; SIIHistory: Record 10750; VAR XMLDoc: DotNet XmlDocument; VAR IsSupported: Boolean; VAR Message: Text);
    VAR
        CustLedgerEntry: Record 21;
        VendorLedgerEntry: Record 25;
        DetailedCustLedgEntry: Record 379;
        DetailedVendorLedgEntry: Record 380;
    BEGIN
        SIIXMLCreator.SetSIIVersionNo(SIIDocUploadState."Version No.");
        SIIXMLCreator.SetIsRetryAccepted(SIIDocUploadState."Retry Accepted");
        CASE SIIDocUploadState."Document Source" OF
            SIIDocUploadState."Document Source"::"Customer Ledger":
                BEGIN
                    IF SIIDocUploadState."Transaction Type" = SIIDocUploadState."Transaction Type"::"Collection In Cash" THEN BEGIN
                        CustLedgerEntry.INIT;
                        CustLedgerEntry."Customer No." := SIIDocUploadState."CV No.";
                        CustLedgerEntry."Posting Date" := SIIDocUploadState."Posting Date";
                        CustLedgerEntry."Sales (LCY)" := SIIDocUploadState."Total Amount In Cash";
                        RequestType := RequestType::CollectionInCashRegistration;
                    END ELSE BEGIN
                        CustLedgerEntry.SETRANGE("Entry No.", SIIDocUploadState."Entry No");
                        IF NOT CustLedgerEntry.FINDFIRST THEN
                            ERROR(NoCustLedgerEntryErr);
                        RequestType := RequestType::InvoiceIssuedRegistration;
                    END;
                    IsSupported :=
                      SIIXMLCreator.GenerateXml(
                        CustLedgerEntry, XMLDoc, SIIHistory."Upload Type", SIIDocUploadState."Is Credit Memo Removal");
                END;
            SIIDocUploadState."Document Source"::"Vendor Ledger":
                BEGIN
                    VendorLedgerEntry.SETRANGE("Entry No.", SIIDocUploadState."Entry No");
                    IF VendorLedgerEntry.FINDFIRST THEN BEGIN
                        RequestType := RequestType::InvoiceReceivedRegistration;
                        IsSupported :=
                          SIIXMLCreator.GenerateXml(
                            VendorLedgerEntry, XMLDoc, SIIHistory."Upload Type", SIIDocUploadState."Is Credit Memo Removal");
                    END ELSE
                        ERROR(NoVendLedgerEntryErr);
                END;
            SIIDocUploadState."Document Source"::"Detailed Customer Ledger":
                BEGIN
                    DetailedCustLedgEntry.SETRANGE("Entry No.", SIIDocUploadState."Entry No");
                    IF DetailedCustLedgEntry.FINDFIRST THEN BEGIN
                        RequestType := RequestType::PaymentReceivedRegistration;
                        IsSupported :=
                          SIIXMLCreator.GenerateXml(
                            DetailedCustLedgEntry, XMLDoc, SIIHistory."Upload Type", SIIDocUploadState."Is Credit Memo Removal");
                    END ELSE
                        ERROR(NoDetailedCustLedgerEntryErr);
                END;
            SIIDocUploadState."Document Source"::"Detailed Vendor Ledger":
                BEGIN
                    DetailedVendorLedgEntry.SETRANGE("Entry No.", SIIDocUploadState."Entry No");
                    IF DetailedVendorLedgEntry.FINDFIRST THEN BEGIN
                        RequestType := RequestType::PaymentSentRegistration;
                        IsSupported :=
                          SIIXMLCreator.GenerateXml(
                            DetailedVendorLedgEntry, XMLDoc, SIIHistory."Upload Type", SIIDocUploadState."Is Credit Memo Removal");
                    END ELSE
                        ERROR(NoDetailedVendLedgerEntryErr);
                END;
        END;

        IF NOT IsSupported THEN
            Message := SIIXMLCreator.GetLastErrorMsg;
    END;

    LOCAL PROCEDURE CreateHistoryPendingBuffer(VAR TempSIIHistoryBuffer: Record 10750 TEMPORARY; IsManual: Boolean);
    VAR
        SIIHistory: Record 10750;
    BEGIN
        WITH SIIHistory DO BEGIN
            SETCURRENTKEY(Status, "Is Manual");
            SetHistoryFilters(SIIHistory, IsManual);
            IF FINDSET THEN
                REPEAT
                    TempSIIHistoryBuffer := SIIHistory;
                    TempSIIHistoryBuffer.INSERT;
                UNTIL NEXT = 0;
        END;
    END;

    LOCAL PROCEDURE SaveHistoryPendingBuffer(VAR TempSIIHistoryBuffer: Record 10750 TEMPORARY; IsManual: Boolean);
    VAR
        SIIHistory: Record 10750;
    BEGIN
        TempSIIHistoryBuffer.RESET;
        IF TempSIIHistoryBuffer.FINDSET THEN BEGIN
            SetHistoryFilters(SIIHistory, IsManual);
            IF SIIHistory.FINDSET(TRUE) THEN
                REPEAT
                    SIIHistory := TempSIIHistoryBuffer;
                    SIIHistory.MODIFY;
                UNTIL (SIIHistory.NEXT = 0) OR (TempSIIHistoryBuffer.NEXT = 0);
        END;
    END;

    LOCAL PROCEDURE SetHistoryFilters(VAR SIIHistory: Record 10750; IsManual: Boolean);
    BEGIN
        SIIHistory.SETRANGE(Status, SIIHistory.Status::Pending);
        SIIHistory.SETRANGE("Is Manual", IsManual);
    END;

    LOCAL PROCEDURE SetDocStateFilters(VAR SIIDocUploadState: Record 10752; IsManual: Boolean);
    BEGIN
        SIIDocUploadState.SETCURRENTKEY(Status, "Is Manual");
        SIIDocUploadState.SETRANGE(Status, SIIDocUploadState.Status::Pending);
        SIIDocUploadState.SETRANGE("Is Manual", IsManual);

        OnAfterSetDocStateFilters(SIIDocUploadState);
    END;

    LOCAL PROCEDURE CreateNewSessionRecord(VAR SIISession: Record 10753);
    BEGIN
        CLEAR(SIISession);
        SIISession.INSERT;
    END;

    LOCAL PROCEDURE ProcessBatchResponseCommunicationError(VAR TempSIIHistoryBuffer: Record 10750 TEMPORARY; ErrorMessage: Text[250]);
    BEGIN
        IF TempSIIHistoryBuffer.FINDSET THEN
            REPEAT
                TempSIIHistoryBuffer.ProcessResponseCommunicationError(ErrorMessage);
            UNTIL TempSIIHistoryBuffer.NEXT = 0;
    END;

    LOCAL PROCEDURE ProcessBatchResponse(VAR TempSIIHistoryBuffer: Record 10750 TEMPORARY);
    BEGIN
        IF TempSIIHistoryBuffer.FINDSET THEN
            REPEAT
                TempSIIHistoryBuffer.ProcessResponse;
            UNTIL TempSIIHistoryBuffer.NEXT = 0;
    END;

    LOCAL PROCEDURE ParseBatchResponse(VAR SIIDocUploadState: Record 10752; VAR TempSIIHistoryBuffer: Record 10750 TEMPORARY; ResponseText: Text);
    VAR
        TempXMLBuffer: ARRAY[2] OF Record 1235 TEMPORARY;
        TempSIIHistory: Record 10750 TEMPORARY;
    BEGIN
        TempXMLBuffer[1].LoadFromText(ResponseText);
        TempXMLBuffer[1].SETFILTER(Name, 'RespuestaLinea');
        IF TempXMLBuffer[1].FINDSET THEN
            REPEAT
                IF SIIDocUploadState."Transaction Type" = SIIDocUploadState."Transaction Type"::"Collection In Cash" THEN
                    ProcessResponseCollectionInCash(SIIDocUploadState, TempSIIHistoryBuffer, TempXMLBuffer[2], TempXMLBuffer[1]."Entry No.")
                ELSE
                    ProcessResponseDocNo(SIIDocUploadState, TempSIIHistoryBuffer, TempXMLBuffer[2], TempXMLBuffer[1]."Entry No.");
            UNTIL TempXMLBuffer[1].NEXT = 0
        ELSE BEGIN
            XMLParseErrorCode(TempXMLBuffer[2], TempSIIHistory);
            TempSIIHistoryBuffer.MODIFYALL("Error Message", TempSIIHistory."Error Message");
            TempSIIHistoryBuffer.MODIFYALL(Status, TempSIIHistory.Status);
            TempSIIHistoryBuffer.SETRANGE(Status, TempSIIHistory.Status);
            ProcessBatchResponse(TempSIIHistoryBuffer);
        END;
        TempSIIHistoryBuffer.SETRANGE("Document State Id");

        // update remaining Pending (not matched within XML)
        TempSIIHistoryBuffer.SETRANGE(Status, TempSIIHistory.Status::Pending);
        IF NOT TempSIIHistoryBuffer.ISEMPTY THEN BEGIN
            TempSIIHistoryBuffer.MODIFYALL("Error Message", ParseMatchDocumentErr);
            TempSIIHistoryBuffer.MODIFYALL(Status, TempSIIHistory.Status::Failed);
            ProcessBatchResponse(TempSIIHistoryBuffer);
        END;
    END;

    LOCAL PROCEDURE ProcessResponseDocNo(VAR SIIDocUploadState: Record 10752; VAR TempSIIHistoryBuffer: Record 10750 TEMPORARY; VAR TempXMLBuffer: Record 1235 TEMPORARY; ParentEntryNo: Integer);
    VAR
        DocumentNo: Code[35];
        Found: Boolean;
    BEGIN
        // Use TempXMLBuffer[2] to point the same temporary buffer and not to break TempXMLBuffer[1] cursor position
        DocumentNo := XMLParseDocumentNo(TempXMLBuffer, ParentEntryNo);
        IF DocumentNo <> '' THEN BEGIN
            IF SIIDocUploadState."Document Source" = SIIDocUploadState."Document Source"::"Vendor Ledger" THEN
                SIIDocUploadState.SETRANGE("External Document No.", DocumentNo)
            ELSE
                SIIDocUploadState.SETRANGE("Document No.", DocumentNo);
            Found := SIIDocUploadState.FINDFIRST;
            IF (NOT Found) AND
               (SIIDocUploadState."Document Source" IN [SIIDocUploadState."Document Source"::"Customer Ledger",
                                                        SIIDocUploadState."Document Source"::"Vendor Ledger"])
            THEN BEGIN
                SIIDocUploadState.SETRANGE("External Document No.");
                SIIDocUploadState.SETRANGE("Document No.");
                SIIDocUploadState.SETRANGE("Corrected Doc. No.", DocumentNo);
                Found := SIIDocUploadState.FINDFIRST;
            END;
            IF Found THEN BEGIN
                TempSIIHistoryBuffer.SETRANGE("Document State Id", SIIDocUploadState.Id);
                IF TempSIIHistoryBuffer.FINDFIRST THEN BEGIN
                    XMLParseDocumentResponse(TempXMLBuffer, TempSIIHistoryBuffer, ParentEntryNo);
                    TempSIIHistoryBuffer.ProcessResponse;
                END;
            END;
            SIIDocUploadState.SETRANGE("External Document No.");
            SIIDocUploadState.SETRANGE("Document No.");
        END;
    END;

    LOCAL PROCEDURE ProcessResponseCollectionInCash(VAR SIIDocUploadState: Record 10752; VAR TempSIIHistoryBuffer: Record 10750 TEMPORARY; VAR TempXMLBuffer: Record 1235 TEMPORARY; ParentEntryNo: Integer);
    BEGIN
        IF XMLParseCustData(TempXMLBuffer, SIIDocUploadState, ParentEntryNo) THEN BEGIN
            TempSIIHistoryBuffer.SETRANGE("Document State Id", SIIDocUploadState.Id);
            IF TempSIIHistoryBuffer.FINDFIRST THEN BEGIN
                XMLParseDocumentResponse(TempXMLBuffer, TempSIIHistoryBuffer, ParentEntryNo);
                TempSIIHistoryBuffer.ProcessResponse;
            END;
            SIIDocUploadState.SETRANGE("Posting Date");
            SIIDocUploadState.SETRANGE("VAT Registration No.");
            SIIDocUploadState.SETRANGE("CV Name");
        END;
    END;

    LOCAL PROCEDURE XMLParseDocumentNo(VAR XMLBuffer: Record 1235; ParentEntryNo: Integer): Code[35];
    BEGIN
        WITH XMLBuffer DO BEGIN
            SETRANGE("Parent Entry No.", ParentEntryNo);
            SETRANGE(Name, 'IDFactura');
            IF FINDFIRST THEN BEGIN
                SETRANGE("Parent Entry No.", "Entry No.");
                SETRANGE(Name, 'NumSerieFacturaEmisor');
                IF FINDFIRST THEN
                    EXIT(COPYSTR(Value, 1, 35));
            END;
        END;
    END;

    LOCAL PROCEDURE XMLParseDocumentResponse(VAR XMLBuffer: Record 1235; VAR SIIHistory: Record 10750; ParentEntryNo: Integer);
    BEGIN
        XMLBuffer.SETRANGE("Parent Entry No.", ParentEntryNo);
        XMLBuffer.SETFILTER(Name, 'EstadoRegistro');
        IF XMLBuffer.FINDFIRST THEN
            CASE XMLBuffer.Value OF
                'Incorrecto':
                    BEGIN
                        SIIHistory.Status := SIIHistory.Status::Incorrect;
                        XMLBuffer.SETFILTER(Name, 'DescripcionErrorRegistro');
                        IF XMLBuffer.FINDFIRST THEN
                            SIIHistory."Error Message" := COPYSTR(XMLBuffer.Value, 1, MAXSTRLEN(SIIHistory."Error Message"));
                    END;
                'Correcto':
                    SIIHistory.Status := SIIHistory.Status::Accepted;
                'AceptadoConErrores':
                    BEGIN
                        SIIHistory.Status := SIIHistory.Status::"Accepted With Errors";
                        XMLBuffer.SETFILTER(Name, 'DescripcionErrorRegistro');
                        IF XMLBuffer.FINDFIRST THEN
                            SIIHistory."Error Message" := COPYSTR(XMLBuffer.Value, 1, MAXSTRLEN(SIIHistory."Error Message"));
                    END;
                ELSE
                    // something is wrong with the response
                    SIIHistory.Status := SIIHistory.Status::Failed;
            END
        ELSE
            XMLParseErrorCode(XMLBuffer, SIIHistory);
    END;

    LOCAL PROCEDURE XMLParseCustData(VAR XMLBuffer: Record 1235; VAR SIIDocUploadState: Record 10752; ParentEntryNo: Integer): Boolean;
    VAR
        Year: Integer;
        VATRegistrationNo: Text;
        CountryRegionCode: Text;
    BEGIN
        WITH XMLBuffer DO BEGIN
            IF FindXMLBufferByParentEntryAndName(XMLBuffer, ParentEntryNo, 'PeriodoLiquidacion') THEN BEGIN
                IF NOT FindXMLBufferByParentEntryAndName(XMLBuffer, "Entry No.", 'Ejercicio') THEN
                    EXIT(FALSE);
                EVALUATE(Year, COPYSTR(Value, 1, 20));
                SIIDocUploadState.SETRANGE("Posting Date", DMY2DATE(1, 1, Year));
            END;
            IF FindXMLBufferByParentEntryAndName(XMLBuffer, ParentEntryNo, 'Contraparte') THEN BEGIN
                ParentEntryNo := "Entry No.";
                IF FindXMLBufferByParentEntryAndName(XMLBuffer, ParentEntryNo, 'NIF') THEN BEGIN
                    VATRegistrationNo := Value;
                    IF NOT FindXMLBufferByParentEntryAndName(XMLBuffer, ParentEntryNo, 'NombreRazon') THEN
                        EXIT(FALSE);
                    SIIDocUploadState.SETRANGE("VAT Registration No.", VATRegistrationNo);
                    SIIDocUploadState.SETRANGE("CV Name", Value);
                    EXIT(SIIDocUploadState.FINDFIRST);
                END;
                IF NOT FindXMLBufferByParentEntryAndName(XMLBuffer, "Entry No.", 'IDOtro') THEN
                    EXIT(FALSE);
                ParentEntryNo := "Entry No.";
                IF NOT FindXMLBufferByParentEntryAndName(XMLBuffer, ParentEntryNo, 'CodigoPais') THEN
                    EXIT(FALSE);
                CountryRegionCode := Value;
                IF NOT FindXMLBufferByParentEntryAndName(XMLBuffer, ParentEntryNo, 'ID') THEN
                    EXIT(FALSE);
                SIIDocUploadState.SETRANGE("VAT Registration No.", Value);
                SIIDocUploadState.SETRANGE("Country/Region Code", CountryRegionCode);
                EXIT(SIIDocUploadState.FINDFIRST);
            END;
        END;
    END;

    LOCAL PROCEDURE XMLParseErrorCode(VAR XMLBuffer: Record 1235; VAR SIIHistory: Record 10750);
    BEGIN
        XMLBuffer.SETFILTER(Name, 'faultcode');
        IF XMLBuffer.FINDFIRST THEN
            IF STRPOS(XMLBuffer.Value, 'Server') > 0 THEN
                // error is probably on the SII website side
                SIIHistory.Status := SIIHistory.Status::Failed
            ELSE
                // error is probably on our side (XML schema incorrect...)
                SIIHistory.Status := SIIHistory.Status::Incorrect
        ELSE
            // couldn't find the faultcode in the response, assume error on our side
            SIIHistory.Status := SIIHistory.Status::Failed;

        XMLBuffer.SETFILTER(Name, 'faultstring');
        IF XMLBuffer.FINDFIRST THEN
            SIIHistory."Error Message" := COPYSTR(XMLBuffer.Value, 1, MAXSTRLEN(SIIHistory."Error Message"))
    END;

    LOCAL PROCEDURE FindXMLBufferByParentEntryAndName(VAR XMLBuffer: Record 1235; ParentEntryNo: Integer; NodeName: Text): Boolean;
    BEGIN
        WITH XMLBuffer DO BEGIN
            SETRANGE("Parent Entry No.", ParentEntryNo);
            SETRANGE(Name, NodeName);
            EXIT(FINDFIRST);
        END;
    END;

    LOCAL PROCEDURE GetAndCheckSetup(): Boolean;
    BEGIN
        SIISetup.GET;
        EXIT(SIISetup.Enabled);
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterSetDocStateFilters(VAR SIIDocUploadState: Record 10752);
    BEGIN
    END;

    /* /*BEGIN
END.*/
}









