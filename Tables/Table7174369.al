table 7174369 "QBU QuoFacturae Entry"
{


    ;
    fields
    {
        field(1; "Entry no."; Integer)
        {
            CaptionML = ENU = 'Entry no.', ESP = 'No. movimiento';


        }
        field(2; "Document type"; Option)
        {
            OptionMembers = "Sales invoice","Purchase invoice";
            CaptionML = ENU = 'Document type', ESP = 'Tipo documento';
            OptionCaptionML = ENU = 'Sales invoice,Purchase invoice', ESP = 'Factura venta,Factura compra';



        }
        field(3; "Document no."; Code[20])
        {
            CaptionML = ENU = 'Document no.', ESP = 'No. documento';


        }
        field(4; "Datetime"; DateTime)
        {
            CaptionML = ENU = 'DateTime', ESP = 'FechaHora';


        }
        field(5; "Status"; Option)
        {
            OptionMembers = "Posted","Posted in RCF","Payment mandatory posted","Paid","Refused","Canceled","Error";
            CaptionML = ENU = 'Status', ESP = 'Estado';
            OptionCaptionML = ENU = ',Posted,Posted in RCF,Payment mandatory posted,Paid,Refused,Canceled,Error', ESP = ',Registrada,Registrada en RCF,Contabilizada la obligaci�n de pago,Pagada,Rechazada,Anulada,Error';



        }
        field(6; "Description"; Text[250])
        {
            CaptionML = ENU = 'Description', ESP = 'Descripción';


        }
        field(7; "Session Id"; Integer)
        {
            TableRelation = "SII Session"."Id";
            CaptionML = ENU = 'Session Id', ESP = 'Session Id';


        }
        field(8; "Codigo Anulacion"; Option)
        {
            OptionMembers = " ","No solicitada anulacion","Solicitada anulacion","Aceptada anulacion","Rechazada anulacion";
            CaptionML = ESP = 'Codigo Anulacion';
            OptionCaptionML = ENU = '" ,No solicitada anulacion,Solicitada anulacion,Aceptada anulacion,Rechazada anulacion"', ESP = '" ,No solicitada anulaci�n,Solicitada anulaci�n,Aceptada anulaci�n,Rechazada anulaci�n"';



        }
        field(9; "Estado Anulacion"; Text[250])
        {
            CaptionML = ESP = 'Estado Anulacion';


        }
        field(10; "Motivo Anulacion"; Text[250])
        {
            CaptionML = ESP = 'Motivo Anulacion';


        }
        field(11; "Codigo Tramitacion"; Option)
        {
            OptionMembers = "Posted","Posted in RCF","Payment mandatory posted","Paid","Refused","Canceled","Error";
            CaptionML = ESP = 'Codigo Tramitacion';
            OptionCaptionML = ENU = ',Posted,Posted in RCF,Payment mandatory posted,Paid,Refused,Canceled,Error', ESP = ',Registrada,Registrada en RCF,Contabilizada la obligaci�n de pago,Pagada,Rechazada,Anulada,Error';



        }
        field(12; "Estado Tramitacion"; Text[250])
        {
            CaptionML = ESP = 'Estado Tramitacion';


        }
        field(13; "Motivo Tramitacion"; Text[250])
        {
            CaptionML = ESP = 'Motivo Tramitacion';


        }
    }
    keys
    {
        key(key1; "Entry no.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }


    // procedure ProcessResponseCommunicationError (ErrorMessage@1100001 :
    procedure ProcessResponseCommunicationError(ErrorMessage: Text[250])
    begin
        Description := ErrorMessage;
        Status := Status::Canceled;
        Description := COPYSTR(ErrorMessage, 1, MAXSTRLEN(Description));

        MODIFY;
    end;

    procedure GetXMLSend()
    var
        //       QuoFacturaeSession@1100286000 :
        QuoFacturaeSession: Record 7174372;
        //       TempBlob@1100286001 :
        TempBlob: Codeunit "Temp Blob";
        Blob: OutStream;
        InStr: InStream;
    begin
        if (QuoFacturaeSession.GET("Session Id")) then begin
            QuoFacturaeSession.CALCFIELDS("Request XML");
            // TempBlob.Blob := QuoFacturaeSession."Request XML";
            /*To be tested*/

            TempBlob.CreateOutStream(Blob, TextEncoding::Windows);
            Blob.Write(QuoFacturaeSession."Request XML");
            SaveXML(TempBlob);
        end;
    end;

    //     LOCAL procedure SaveXML (TempBlob@1100286003 :
    LOCAL procedure SaveXML(TempBlob: Codeunit "Temp Blob")
    var
        //       toFile@1100286004 :
        toFile: Text;
        //       txt@1100286002 :
        txt: Text;
        //       xmlFile@1100286001 :
        xmlFile: File;
        //       txtXML@1100286000 :
        txtXML: Text;
        InStr: InStream;
        Textcontent: Text;
    begin
        //Guardar el fichero generado y descargarlo
        toFile := 'Signed_' + FORMAT(CURRENTDATETIME, 0, '<Year4><Month,2><Day,2><Hours24><Minutes,2><Seconds,2>') + '.xml';
        txt := TEMPORARYPATH + toFile;

        xmlFile.TEXTMODE := TRUE;
        xmlFile.WRITEMODE := TRUE;
        xmlFile.CREATE(txt, TEXTENCODING::UTF8);
        /*To be Tested*/
        //xmlFile.WRITE(TempBlob.ReadAsTextWithCRLFLineSeparator);
        TempBlob.CreateInStream(InStr, TextEncoding::Windows);
        InStr.Read(Textcontent);
        Textcontent := STRSUBSTNO('%1%2', Textcontent, '\r\n'); //Replace LF with CRLF
        xmlFile.WRITE(Textcontent);
        xmlFile.CLOSE;

        DOWNLOAD(txt, 'Download file', 'C:\TMP\FACE', 'XML file(*.xml)|*.xml', toFile);
    end;

    procedure viewXML(): Text;
    var
        //       QuoFacturaeSession@1100286001 :
        QuoFacturaeSession: Record 7174372;
        //       txtXML@1100286000 :
        txtXML: Text;
    begin
        txtXML := '';
        if (QuoFacturaeSession.GET("Session Id")) then begin
            QuoFacturaeSession.CALCFIELDS("Request XML");
            if (QuoFacturaeSession."Request XML".HASVALUE) then
                txtXML := 'XML';
        end;
        exit(txtXML);
    end;

    /*begin
    end.
  */
}







