Codeunit 7174341 "QuoFacturae Upload Management"
{
  
  
    Permissions=TableData 21=rimd;
    trigger OnRun()
BEGIN
          END;
    VAR
      NoCertificateErr : TextConst ENU='Could not get certificate.',ESP='No se pudo obtener el certificado.';
      NoConnectionErr : TextConst ENU='Could not establish connection.',ESP='No se pudo establecer la conexi�n.';
      NoResponseErr : TextConst ENU='Could not get response.',ESP='No se pudo obtener respuesta.';
      CommunicationErr : TextConst ENU='Communication error: %1.',ESP='Error de comunicaci�n: %1.';
      NoCustLedgerEntryErr : TextConst ENU='Customer Ledger Entry could not be found.',ESP='No se encontr� el movimiento de cliente.';

    PROCEDURE SendManualInvoiceToFace(EntryNo : Integer);
    VAR
      ClientNotFoundErr : TextConst ENU='Client No. %1 Not Found in QuoFacturae Admin. Center',ESP='Cliente %1 no encontrado en el Administrador de QuoFacurae';
      CustLedgerEntry : Record 21;
      XMLDoc : DotNet XmlDocument;
      QuoFacturaeSetup : Record 7174368;
      CompanyInformation : Record 79;
      ins : InStream;
      MemoryStream : DotNet MemoryStream;
      Bytes : DotNet Array;
      Convert : DotNet Convert;
      QuoFacturae : DotNet QuoFacturae;
      QuoFacturaeEntry : Record 7174369;
      LastEntryNo : Integer;
      QuoFacturaeSession : Record 7174372;
      QuoFacturaeXMLCreator : Codeunit 7174342;
      txtXML : Text;
    BEGIN
      QuoFacturaeSetup.GET;
      CompanyInformation.GET;

      CustLedgerEntry.GET(EntryNo);
      QuoFacturaeXMLCreator.GenerateXML(CustLedgerEntry,XMLDoc);

      QuoFacturaeSetup.CALCFIELDS(Certificate);

      CLEAR(ins);
      CLEAR(MemoryStream);
      QuoFacturaeSetup.Certificate.CREATEINSTREAM(ins);
      MemoryStream := MemoryStream.MemoryStream();
      COPYSTREAM(MemoryStream,ins);
      Bytes := MemoryStream.ToArray();

      QuoFacturae := QuoFacturae.QuoFacturae();

      IF (QuoFacturaeSetup.Certificate.HASVALUE) THEN
        QuoFacturae.Cert := Convert.ToBase64String(Bytes);

      QuoFacturae.CertPass := QuoFacturaeSetup.Password;
      QuoFacturae.email := QuoFacturaeSetup.eMail;

      // +QFA 0.3
      //QuoFacturae.url := QuoFacturaeSetup.InvoicesIssuedEndpointUrl;
      QuoFacturae.url := GetEndPoint(CustLedgerEntry."Customer No.");
      // -QFA 0.3
      QuoFacturae.factura := XMLDoc.OuterXml;
      QuoFacturae.EnviarFactura(CustLedgerEntry."Document No.");

      CLEAR(QuoFacturaeSession);
      QuoFacturaeSession.INSERT;

      //JAV 15/04/21: - QFA 1.5l Guardar el XML de la factura generada firmada en la tabla de sesi�n
      QuoFacturae.FirmarFactura();
      QuoFacturaeSession.StoreRequestXml(QuoFacturae.outfactura);

      QuoFacturaeSession.StoreResponseXml(QuoFacturae.codigo + ' - ' + QuoFacturae.descripcion);

      QuoFacturaeEntry.RESET;
      IF QuoFacturaeEntry.FINDLAST THEN
       LastEntryNo := QuoFacturaeEntry."Entry no.";

      CLEAR(QuoFacturaeEntry);
      QuoFacturaeEntry.RESET;
      QuoFacturaeEntry.INIT;
      QuoFacturaeEntry.Datetime := CREATEDATETIME(TODAY,TIME);
      QuoFacturaeEntry."Document type" := QuoFacturaeEntry."Document type"::"Sales invoice";
      QuoFacturaeEntry."Document no." := CustLedgerEntry."Document No.";
      QuoFacturaeEntry."Entry no." := LastEntryNo + 1;
      IF QuoFacturae.codigo = '0' THEN BEGIN
        QuoFacturaeEntry.Status := QuoFacturaeEntry.Status::Posted;
        QuoFacturaeEntry.Description := QuoFacturae.numeroRegistro;
      END ELSE BEGIN
        QuoFacturaeEntry.Status := QuoFacturaeEntry.Status::Error;
        QuoFacturaeEntry.Description := COPYSTR(QuoFacturae.codigo + ' - ' + QuoFacturae.descripcion, 1, MAXSTRLEN(QuoFacturaeEntry.Description));
      END;
      QuoFacturaeEntry."Session Id" := QuoFacturaeSession.Id;
      QuoFacturaeEntry.INSERT;

      CustLedgerEntry."QFA QuoFacturae Status" := QuoFacturaeEntry.Status;
      CustLedgerEntry.MODIFY;
    END;

    PROCEDURE SendManualRequestInvoiceToFace(EntryNo : Integer);
    VAR
      ClientNotFoundErr : TextConst ENU='Client No. %1 Not Found in QuoFacturae Admin. Center',ESP='Cliente %1 no encontrado en el Administrador de QuoFacurae';
      CustLedgerEntry : Record 21;
      QuoFacturaeSetup : Record 7174368;
      CompanyInformation : Record 79;
      ins : InStream;
      MemoryStream : DotNet MemoryStream;
      Bytes : DotNet Array;
      Convert : DotNet Convert;
      QuoFacturae : DotNet QuoFacturae;
      QuoFacturaeEntry : Record 7174369;
      LastEntryNo : Integer;
      QuoFacturaeSession : Record 7174372;
    BEGIN
      QuoFacturaeSetup.GET;
      CompanyInformation.GET;

      CustLedgerEntry.GET(EntryNo);

      QuoFacturaeSetup.CALCFIELDS(Certificate);

      CLEAR(ins);
      CLEAR(MemoryStream);
      QuoFacturaeSetup.Certificate.CREATEINSTREAM(ins);
      MemoryStream := MemoryStream.MemoryStream();
      COPYSTREAM(MemoryStream,ins);
      Bytes := MemoryStream.ToArray();

      QuoFacturae := QuoFacturae.QuoFacturae();

      IF (QuoFacturaeSetup.Certificate.HASVALUE) THEN
        QuoFacturae.Cert := Convert.ToBase64String(Bytes);

      QuoFacturae.CertPass := QuoFacturaeSetup.Password;
      QuoFacturae.email :=  QuoFacturaeSetup.eMail;

      // +QFA 0.3
      //QuoFacturae.url := QuoFacturaeSetup.InvoicesIssuedEndpointUrl;
      QuoFacturae.url := GetEndPoint(CustLedgerEntry."Customer No.");
      // -QFA 0.3

      CustLedgerEntry.CALCFIELDS("QFA Posting No. Facturae");
      QuoFacturae.ConsultaFactura(CustLedgerEntry."QFA Posting No. Facturae");

      CLEAR(QuoFacturaeSession);
      QuoFacturaeSession.INSERT;

      QuoFacturaeSession.StoreResponseXml(QuoFacturae.codigo + ' - ' + QuoFacturae.descripcion);

      QuoFacturaeEntry.RESET;
      IF QuoFacturaeEntry.FINDLAST THEN
       LastEntryNo := QuoFacturaeEntry."Entry no.";

      CLEAR(QuoFacturaeEntry);
      QuoFacturaeEntry.RESET;
      QuoFacturaeEntry.INIT;
      QuoFacturaeEntry.Datetime := CREATEDATETIME(TODAY,TIME);
      QuoFacturaeEntry."Document type" := QuoFacturaeEntry."Document type"::"Sales invoice";
      QuoFacturaeEntry."Document no." := CustLedgerEntry."Document No.";
      QuoFacturaeEntry."Entry no." := LastEntryNo + 1;
      IF QuoFacturae.codigo = '0' THEN BEGIN
        QuoFacturaeEntry.Status := CodigoTramitacion(QuoFacturae.codigoTramitacion);
        QuoFacturaeEntry."Codigo Anulacion" := CodigoAnulacion(QuoFacturae.codigoAnulacion);
        QuoFacturaeEntry."Estado Anulacion" := QuoFacturae.codigoAnulacion + ' - ' + QuoFacturae.estadoAnulacion;
        QuoFacturaeEntry."Motivo Anulacion" := QuoFacturae.motivoAnulacion;
        QuoFacturaeEntry."Codigo Tramitacion" := CodigoTramitacion(QuoFacturae.codigoTramitacion);
        QuoFacturaeEntry."Estado Tramitacion" := QuoFacturae.codigoTramitacion + ' - ' + QuoFacturae.estadoTramitacion;
        QuoFacturaeEntry."Motivo Tramitacion" := COPYSTR(QuoFacturae.motivoTramitacion, 1, MAXSTRLEN(QuoFacturaeEntry."Motivo Tramitacion"));
        CustLedgerEntry."QFA QuoFacturae Status" := QuoFacturaeEntry.Status;
        CustLedgerEntry.MODIFY;
      END ELSE BEGIN
        QuoFacturaeEntry.Status := QuoFacturaeEntry.Status::Error;
        QuoFacturaeEntry.Description := COPYSTR(QuoFacturae.codigo + ' - ' + QuoFacturae.descripcion, 1, MAXSTRLEN(QuoFacturaeEntry.Description));
      END;
      QuoFacturaeEntry."Session Id" := QuoFacturaeSession.Id;
      QuoFacturaeEntry.INSERT;

      CustLedgerEntry."QFA QuoFacturae Status" := QuoFacturaeEntry.Status;
      CustLedgerEntry.MODIFY;
    END;

    PROCEDURE SendManualVoidInvoiceToFace(EntryNo : Integer;motivo : Text[1024]);
    VAR
      CustLedgerEntry : Record 21;
      QuoFacturaeSetup : Record 7174368;
      CompanyInformation : Record 79;
      ins : InStream;
      MemoryStream : DotNet MemoryStream;
      Bytes : DotNet Array;
      Convert : DotNet Convert;
      QuoFacturae : DotNet QuoFacturae;
      QuoFacturaeEntry : Record 7174369;
      LastEntryNo : Integer;
      QuoFacturaeSession : Record 7174372;
    BEGIN
      QuoFacturaeSetup.GET;
      CompanyInformation.GET;

      CustLedgerEntry.GET(EntryNo);

      QuoFacturaeSetup.CALCFIELDS(Certificate);

      CLEAR(ins);
      CLEAR(MemoryStream);
      QuoFacturaeSetup.Certificate.CREATEINSTREAM(ins);
      MemoryStream := MemoryStream.MemoryStream();
      COPYSTREAM(MemoryStream,ins);
      Bytes := MemoryStream.ToArray();

      QuoFacturae := QuoFacturae.QuoFacturae();

      IF (QuoFacturaeSetup.Certificate.HASVALUE) THEN
        QuoFacturae.Cert := Convert.ToBase64String(Bytes);

      QuoFacturae.CertPass := QuoFacturaeSetup.Password;
      QuoFacturae.email :=  QuoFacturaeSetup.eMail;

      // +QFA 0.3
      //QuoFacturae.url := QuoFacturaeSetup.InvoicesIssuedEndpointUrl;
      QuoFacturae.url := GetEndPoint(CustLedgerEntry."Customer No.");
      // -QFA 0.3

      QuoFacturae.motivo := motivo;

      CustLedgerEntry.CALCFIELDS("QFA Posting No. Facturae");
      QuoFacturae.AnularFactura(CustLedgerEntry."QFA Posting No. Facturae");

      CLEAR(QuoFacturaeSession);
      QuoFacturaeSession.INSERT;

      QuoFacturaeSession.StoreResponseXml(QuoFacturae.codigo + ' - ' + QuoFacturae.descripcion);

      QuoFacturaeEntry.RESET;
      IF QuoFacturaeEntry.FINDLAST THEN
       LastEntryNo := QuoFacturaeEntry."Entry no.";

      CLEAR(QuoFacturaeEntry);
      QuoFacturaeEntry.RESET;
      QuoFacturaeEntry.INIT;
      QuoFacturaeEntry.Datetime := CREATEDATETIME(TODAY,TIME);
      QuoFacturaeEntry."Document type" := QuoFacturaeEntry."Document type"::"Sales invoice";
      QuoFacturaeEntry."Document no." := CustLedgerEntry."Document No.";
      QuoFacturaeEntry."Entry no." := LastEntryNo + 1;
      IF QuoFacturae.codigo = '0' THEN BEGIN
        QuoFacturaeEntry.Status := QuoFacturaeEntry.Status::Canceled;
        QuoFacturaeEntry.Description := COPYSTR(QuoFacturae.descripcion, 1, MAXSTRLEN(QuoFacturaeEntry.Description));
      END ELSE BEGIN
        QuoFacturaeEntry.Status := QuoFacturaeEntry.Status::Error;
        QuoFacturaeEntry.Description := COPYSTR(QuoFacturae.codigo + ' - ' + QuoFacturae.descripcion, 1, MAXSTRLEN(QuoFacturaeEntry.Description));
      END;
      QuoFacturaeEntry."Session Id" := QuoFacturaeSession.Id;
      QuoFacturaeEntry.INSERT;

      CustLedgerEntry."QFA QuoFacturae Status" := QuoFacturaeEntry.Status;
      CustLedgerEntry.MODIFY;
    END;

    PROCEDURE CreateXMLFile(EntryNo : Integer);
    VAR
      os : OutStream;
      tempBLOB : Codeunit "Temp Blob";
      txt : Text;
      btxt : BigText;
      is : InStream;
      i : Integer;
      j : Integer;
      xmlFile : File;
      ToFile : Text;
      XMLDOMManagement : Codeunit 6224;
      CustLedgerEntry : Record 21;
      QuoFacturaeXMLCreator : Codeunit 7174342;
      XMLDoc : DotNet XmlDocument;
    BEGIN
/*{CustLedgerEntry.GET(EntryNo);
      QuoFacturaeXMLCreator.GenerateXML(CustLedgerEntry,XMLDoc);

      tempBLOB.Blob.CREATEOUTSTREAM(os);
      XMLDOMManagement.SaveXMLDocumentToOutStream(os,XMLDoc.FirstChild());

      ToFile := FORMAT(CURRENTDATETIME,0,'<Year4><Month,2><Day,2><Hours24><Minutes,2><Seconds,2>')+'.xml';
      txt := TEMPORARYPATH + '\' + ToFile;

      IF NOT EXISTS(txt) THEN
        tempBLOB.Blob.EXPORT(txt)
      ELSE BEGIN
        ERASE(txt);
        tempBLOB.Blob.EXPORT(txt);
      END;

      DOWNLOAD(txt,'Download file','C:\TMP\FACE','XML file(*.xml)|*.xml',ToFile);

      MESSAGE('Fichero exportado.');}*/

      CreateSignedXMLFile(EntryNo);
    END;

    PROCEDURE CreateSignedXMLFile(EntryNo : Integer);
    VAR
      os : OutStream;
      tempBLOB : Codeunit "Temp Blob";
      txt : Text;
      btxt : BigText;
      is : InStream;
      i : Integer;
      j : Integer;
      xmlFile : File;
      ToFile : Text;
      XMLDOMManagement : Codeunit 6224;
      CustLedgerEntry : Record 21;
      QuoFacturaeXMLCreator : Codeunit 7174342;
      XMLDoc : DotNet XmlDocument;
      QuoFacturaeSetup : Record 7174368;
      CompanyInformation : Record 79;
      ins : InStream;
      MemoryStream : DotNet MemoryStream;
      Bytes : DotNet Array;
      Convert : DotNet Convert;
      Filexml : File;
      QuoFacturae : DotNet QuoFacturae;
      QuoF : DotNet QuoFacturae;
    BEGIN
      IF (USERID = 'QUONEXT\JAVAQUE') THEN BEGIN     // Para poder hacer pruebas no puedo firmar, seg�n el usuario genero solo el XML
        CustLedgerEntry.GET(EntryNo);
        QuoFacturaeXMLCreator.GenerateXML(CustLedgerEntry,XMLDoc);

        //Guardar el fichero generado y descargarlo
        ToFile := 'Signed_'+FORMAT(CURRENTDATETIME,0,'<Year4><Month,2><Day,2><Hours24><Minutes,2><Seconds,2>')+'.xml';
        txt := TEMPORARYPATH + ToFile;
        xmlFile.TEXTMODE := TRUE;
        xmlFile.WRITEMODE := TRUE;
        xmlFile.CREATE(txt, TEXTENCODING::UTF8);
        // xmlFile.WRITE(XMLDoc.OuterXml);
        xmlFile.CLOSE;
        DOWNLOAD(txt,'Download file','C:\TMP\FACE','XML file(*.xml)|*.xml',ToFile);
        EXIT;
      END;


      QuoFacturaeSetup.GET;
      CompanyInformation.GET;

      CustLedgerEntry.GET(EntryNo);
      QuoFacturaeXMLCreator.GenerateXML(CustLedgerEntry,XMLDoc);

      QuoFacturaeSetup.CALCFIELDS(Certificate);

      CLEAR(ins);
      CLEAR(MemoryStream);
      QuoFacturaeSetup.Certificate.CREATEINSTREAM(ins);
      MemoryStream := MemoryStream.MemoryStream();
      COPYSTREAM(MemoryStream,ins);
      Bytes := MemoryStream.ToArray();

      QuoFacturae := QuoFacturae.QuoFacturae();

      IF (QuoFacturaeSetup.Certificate.HASVALUE) THEN
        QuoFacturae.Cert := Convert.ToBase64String(Bytes);

      QuoFacturae.CertPass := QuoFacturaeSetup.Password;
      QuoFacturae.factura := XMLDoc.OuterXml;
      QuoFacturae.FirmarFactura();

      //Guardar el fichero generado y descargarlo
      ToFile := 'Signed_'+FORMAT(CURRENTDATETIME,0,'<Year4><Month,2><Day,2><Hours24><Minutes,2><Seconds,2>')+'.xml';
      txt := TEMPORARYPATH + ToFile;

      xmlFile.TEXTMODE := TRUE;
      xmlFile.WRITEMODE := TRUE;
      xmlFile.CREATE(txt, TEXTENCODING::UTF8);
      // xmlFile.WRITE(QuoFacturae.outfactura);
      xmlFile.CLOSE;

      DOWNLOAD(txt,'Download file','C:\TMP\FACE','XML file(*.xml)|*.xml',ToFile);
    END;

    LOCAL PROCEDURE CodigoAnulacion(_codigo : Text) : Integer;
    BEGIN
      IF _codigo = '4100' THEN
        EXIT(1);
      IF _codigo = '4200' THEN
        EXIT(2);
      IF _codigo = '4300' THEN
        EXIT(3);
      IF _codigo = '4400' THEN
        EXIT(4);
    END;

    LOCAL PROCEDURE CodigoTramitacion(_codigo : Text) : Integer;
    BEGIN
      IF _codigo = '1200' THEN
        EXIT(1);
      IF _codigo = '1300' THEN
        EXIT(2);
      IF _codigo = '2400' THEN
        EXIT(3);
      IF _codigo = '2500' THEN
        EXIT(4);
      IF _codigo = '2600' THEN
        EXIT(5);
      IF _codigo = '3100' THEN
        EXIT(6);
    END;

    LOCAL PROCEDURE GetEndPoint(CustomerNo : Code[20]) : Text;
    VAR
      Customer : Record 18;
      QuoFacturaeendpoint : Record 7174373;
      Text80200 : TextConst ENU='There''s not Quofacturae entity defined in the customer %1.',ESP='No hay entidad Quofacturae definida para el cliente %1.';
    BEGIN
      Customer.GET(CustomerNo);
      IF Customer."QFA Quofacturae endpoint"<>'' THEN BEGIN
        QuoFacturaeendpoint.GET(Customer."QFA Quofacturae endpoint");
        EXIT(QuoFacturaeendpoint.URL);
      END ELSE
        ERROR(Text80200,Customer."No.");
    END;

    /*BEGIN
/*{
      QFA 0.3 09/11/18 JALA - Modificaciones para poder enviar a la entidad definida en el cliente de la factura.
    }
END.*/
}









