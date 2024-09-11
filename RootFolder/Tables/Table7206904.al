table 7206904 "Obralia Log Entry"
{


    CaptionML = ENU = 'Obralia Log Entry', ESP = 'Log Obralia';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Id.';


        }
        field(2; "Datetime Process"; DateTime)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'D�a-hora proceso';


        }
        field(3; "User"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Usuario';


        }
        field(4; "Obralia"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Obralia';


        }
        field(5; "Filter"; Text[70])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Filtro';


        }
        field(6; "Result"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Resultado';


        }
        field(7; "Correct"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Correcto';


        }
        field(8; "Datetime Result Process"; DateTime)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'D�a-hora resultado proceso';


        }
        field(9; "Vendor"; Code[20])
        {
            TableRelation = "Vendor";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Proveedor';
            Editable = false;


        }
        field(10; "Request XML"; BLOB)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Request XML', ESP = 'Solicitud XML';


        }
        field(20; "Response XML"; BLOB)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Response XML', ESP = 'Respuesta XML';


        }
        field(21; "Text Error"; Text[200])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Texto error';


        }
        field(22; "semaforoEmpresa"; Text[1])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Semaforo empresa';


        }
        field(23; "semaforoTotal"; Text[1])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Semaforo total';


        }
        field(24; "urlConsulta"; Text[150])
        {
            ExtendedDatatype = URL;
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'URL consulta';


        }
        field(25; "semaforoPagos"; Text[1])
        {
            DataClassification = ToBeClassified;
            Description = 'Q19458';


        }
    }
    keys
    {
        key(key1; "Entry No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       PurchasesPayablesSetup@1100286000 :
        PurchasesPayablesSetup: Record 312;
        //       ObraliaLogEntry@1100286001 :
        ObraliaLogEntry: Record 7206904;
        //       txtVerde@1100286002 :
        txtVerde: TextConst ESP = 'Verde';
        //       txtRojo@1100286003 :
        txtRojo: TextConst ESP = 'Rojo';

    //     procedure StoreRequestXml (RequestText@1100001 :
    procedure StoreRequestXml(RequestText: Text)
    var
        //       TextMgt@1100002 :
        TextMgt: Codeunit 41;
        TextMgt1: Codeunit 50210;
        //       OutStream@1100000 :
        OutStream: OutStream;
    begin
        "Request XML".CREATEOUTSTREAM(OutStream, TEXTENCODING::UTF8);
        OutStream.WRITETEXT(TextMgt1.XMLTextIndent(RequestText));
        CALCFIELDS("Request XML");
        MODIFY;
        COMMIT;
    end;

    //     procedure StoreResponseXml (ResponseText@1100001 :
    procedure StoreResponseXml(ResponseText: Text)
    var
        //       TextMgt@1100002 :
        TextMgt: Codeunit 41;
        TextMgt1: Codeunit 50210;
        //       OutStream@1100000 :
        OutStream: OutStream;
    begin
        "Response XML".CREATEOUTSTREAM(OutStream, TEXTENCODING::UTF8);
        OutStream.WRITETEXT(TextMgt1.XMLTextIndent(ResponseText));
        CALCFIELDS("Response XML");
        "Datetime Result Process" := CURRENTDATETIME;
        MODIFY;
    end;

    //     procedure StoreResponseXmlinstream (pInStream@1100001 : InStream;pTxtDesc@1000000002 : Text;pResult@1000000003 :
    procedure StoreResponseXmlinstream(pInStream: InStream; pTxtDesc: Text; pResult: Text)
    var
        //       TextMgt@1100002 :
        TextMgt: Codeunit 41;
        //       OutStream@1100000 :
        OutStream: OutStream;
        //       SourceXMLDoc@1000000000 :
        SourceXMLDoc: DotNet XmlDocument;
        //       pOutStream@1000000001 :
        pOutStream: OutStream;
    begin
        if ISNULL(SourceXMLDoc) then
            SourceXMLDoc := SourceXMLDoc.XmlDocument;

        SourceXMLDoc.Load(pInStream);

        "Response XML".CREATEOUTSTREAM(pOutStream);
        SourceXMLDoc.Save(pOutStream);
        "Datetime Result Process" := CURRENTDATETIME;
        Result := pResult;
        if (pTxtDesc = 'OK') or (pTxtDesc = '200') then
            Correct := TRUE;

        "Text Error" := pTxtDesc;
        Result := COPYSTR(pResult, 1, 50);
        MODIFY;
    end;

    procedure StoreErrorResponseXML()
    var
        //       XML@1100286000 :
        XML: Text;
        //       Tag@1100286001 :
        Tag: Text;
        //       Pos@1100286002 :
        Pos: Integer;
        //       URL@1100286003 :
        URL: Text;
    begin
        XML := GetResponseXml;

        Tag := '<faultstring';
        Pos := STRPOS(XML, Tag);
        if Pos <= 0 then
            exit;

        XML := COPYSTR(XML, Pos + STRLEN(Tag));

        Tag := '>';
        Pos := STRPOS(XML, Tag);

        XML := COPYSTR(XML, Pos + STRLEN(Tag));

        Tag := '</faultstring>';
        Pos := STRPOS(XML, Tag);

        "Text Error" := COPYSTR(XML, 1, Pos - 1);

        MODIFY;
    end;

    procedure StoreObraliaXMLData()
    var
        //       XML@1100286000 :
        XML: Text;
        //       Tag@1100286001 :
        Tag: Text;
        //       Pos@1100286002 :
        Pos: Integer;
        //       URL@1100286003 :
        URL: Text;
    begin
        XML := GetResponseXml;

        Tag := '<ns2:semaforoEmpresa>';
        Pos := STRPOS(XML, Tag);
        if Pos > 0 then
            semaforoEmpresa := COPYSTR(XML, Pos + STRLEN(Tag), 1);

        Tag := '<ns2:semaforoTotal>';
        Pos := STRPOS(XML, Tag);
        if Pos > 0 then
            semaforoTotal := COPYSTR(XML, Pos + STRLEN(Tag), 1);

        //-Q19458
        Tag := '<ns2:semaforoPagos>';
        Pos := STRPOS(XML, Tag);
        if Pos > 0 then
            semaforoPagos := COPYSTR(XML, Pos + STRLEN(Tag), 1);
        //+Q19458


        Tag := '<ns2:urlConsulta>';
        Pos := STRPOS(XML, Tag);
        if Pos > 0 then begin
            URL := COPYSTR(XML, Pos + STRLEN(Tag));

            Tag := '</ns2:urlConsulta>';
            Pos := STRPOS(URL, Tag);

            urlConsulta := COPYSTR(URL, 1, Pos - 1);

        end;

        MODIFY;
    end;


    procedure GetRequestXml(): Text;
    var
        //       TempBlob@1000 :
        TempBlob: Codeunit "Temp Blob";
        Blob: OutStream;
        InStr: InStream;
        //       CR@1004 :
        CR: Text[1];
    begin
        CALCFIELDS("Request XML");
        if not "Request XML".HASVALUE then
            exit('');
        CR[1] := 10;
        // TempBlob.Blob := "Request XML";
        /*To be tested*/

        TempBlob.CreateOutStream(Blob, TextEncoding::Windows);
        Blob.Write("Request XML");
        // exit(TempBlob.ReadAsText(CR, TEXTENCODING::Windows)) ;
        /*To be tested*/

        TempBlob.CreateInStream(InStr, TextEncoding::Windows);
        InStr.Read(CR);
        exit(CR);
    end;


    procedure GetResponseXml(): Text;
    var
        //       TempBlob@1000 :
        TempBlob: Codeunit "Temp Blob";
        Blob: OutStream;
        InStr: InStream;
        //       CR@1004 :
        CR: Text[1];
    begin
        CALCFIELDS("Response XML");
        if not "Response XML".HASVALUE then
            exit('');
        CR[1] := 10;
        // TempBlob.Blob := "Response XML";
        /*To be tested*/

        TempBlob.CreateOutStream(Blob, TextEncoding::Windows);
        Blob.Write("Response XML");
        // exit(TempBlob.ReadAsText(CR, TEXTENCODING::Windows)) ;
        /*To be tested*/

        TempBlob.CreateInStream(InStr, TextEncoding::Windows);
        InStr.Read(CR);
        exit(CR);
    end;

    procedure GetSemaphor(): Text;
    begin
        PurchasesPayablesSetup.GET;
        if (STRPOS(PurchasesPayablesSetup."Obralia Green", semaforoTotal) <> 0) then
            exit(txtVerde)
        else if (semaforoTotal <> '') then
            exit(txtRojo);

        exit('');
    end;

    procedure IsSemaphorGreen(): Boolean;
    begin
        //Q19775-
        exit(GetSemaphorPagos = txtVerde);
        //exit(GetSemaphor = txtVerde);
        //Q19775+
    end;

    procedure IsSemaphorRed(): Boolean;
    begin
        //Q19775-
        exit(GetSemaphorPagos = txtRojo);
        //exit(GetSemaphor = txtRojo);
        //Q19775+
    end;

    procedure GetResponse(): Text;
    begin
        //Q19775-
        if (GetSemaphorPagos <> '') then
            exit(GetSemaphorPagos)
        //if (GetSemaphor <> '') then
        //  exit(GetSemaphor)
        //Q19775+
        else
            exit("Text Error");
    end;

    procedure GetResponseStyle(): Text;
    begin
        //q19775-
        CASE GetSemaphorPagos OF
            //CASE GetSemaphor OF
            //Q19775+
            txtVerde:
                exit('Favorable');
            txtRojo:
                exit('Unfavorable');
        end;
        exit('Standard');
    end;

    //     procedure ViewResponse (EntryNo@1100286000 :
    procedure ViewResponse(EntryNo: Integer)
    begin
        if (EntryNo <> 0) then
            if (ObraliaLogEntry.GET(EntryNo)) then begin
                ObraliaLogEntry.RESET;
                ObraliaLogEntry.SETRANGE("Entry No.", EntryNo);
                PAGE.RUN(PAGE::"Obralia Log Entry", ObraliaLogEntry);
            end;
    end;

    procedure GetSemaphorPagos(): Text;
    begin
        PurchasesPayablesSetup.GET;
        if (STRPOS(PurchasesPayablesSetup."Obralia Green", semaforoPagos) <> 0) then
            exit(txtVerde)
        else if (semaforoPagos <> '') then
            exit(txtRojo);

        exit('');
    end;

    procedure GetResponsePagos(): Text;
    begin
        if (GetSemaphorPagos <> '') then
            exit(GetSemaphorPagos)
        else
            exit("Text Error");
    end;

    procedure GetResponseStylePagos(): Text;
    begin
        CASE GetSemaphorPagos OF
            txtVerde:
                exit('Favorable');
            txtRojo:
                exit('Unfavorable');
        end;
        exit('Standard');
    end;

    /*begin
    //{
//      Q19458 AML 22/05/23 Creado campo semaforoPagos Y creada la asignaci�n desde XML
//      Q19458 PSM 22/05/23 Creadas funciones GetSemaphorPagos, GetResponsePagos y GetResponseStylePagos para los documentos en cartera
//      Q19775 PSM 20/07/23 Capturar respuesta SemaforoPagos en todos los casos
//    }
    end.
  */
}







