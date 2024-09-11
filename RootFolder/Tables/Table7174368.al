table 7174368 "QuoFacturae Setup"
{


    ;
    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            CaptionML = ENU = 'Primary Key', ESP = 'Clave principal';


        }
        field(2; "Enabled"; Boolean)
        {


            CaptionML = ENU = 'Enabled', ESP = 'Habilitado';

            trigger OnValidate();
            BEGIN
                IF Enabled AND NOT Certificate.HASVALUE THEN
                    ERROR(CannotEnableWithoutCertificateErr);
            END;


        }
        field(3; "Certificate"; BLOB)
        {
            CaptionML = ENU = 'Certificate', ESP = 'Certificado';


        }
        field(4; "Password"; Text[250])
        {


            ExtendedDatatype = Masked;
            CaptionML = ENU = 'Password', ESP = 'Contrase�a';

            trigger OnValidate();
            BEGIN
                ValidateCertificatePassword;
            END;


        }
        field(5; "InvoicesIssuedEndpointUrl"; Text[250])
        {
            InitValue = 'https://www1.agenciatributaria.gob.es/wlpl/SSII-FACT/ws/fe/SiiFactFEV1SOAP';
            CaptionML = ENU = 'InvoicesIssuedEndpointUrl', ESP = 'InvoicesIssuedEndpointUrl';
            NotBlank = true;


        }
        field(6; "InvoicesReceivedEndpointUrl"; Text[250])
        {
            InitValue = 'https://www1.agenciatributaria.gob.es/wlpl/SSII-FACT/ws/fr/SiiFactFRV1SOAP';
            CaptionML = ENU = 'InvoicesReceivedEndpointUrl', ESP = 'InvoicesReceivedEndpointUrl';
            NotBlank = true;


        }
        field(7; "PaymentsIssuedEndpointUrl"; Text[250])
        {
            InitValue = 'https://www1.agenciatributaria.gob.es/wlpl/SSII-FACT/ws/fr/SiiFactPAGV1SOAP';
            CaptionML = ENU = 'PaymentsIssuedEndpointUrl', ESP = 'PaymentsIssuedEndpointUrl';
            NotBlank = true;


        }
        field(8; "PaymentsReceivedEndpointUrl"; Text[250])
        {
            InitValue = 'https://www1.agenciatributaria.gob.es/wlpl/SSII-FACT/ws/fe/SiiFactCOBV1SOAP';
            CaptionML = ENU = 'PaymentsReceivedEndpointUrl', ESP = 'PaymentsReceivedEndpointUrl';
            NotBlank = true;


        }
        field(9; "IntracommunityEndpointUrl"; Text[250])
        {
            InitValue = 'https://www1.agenciatributaria.gob.es/wlpl/SSII-FACT/ws/oi/SiiFactOIV1SOAP';
            CaptionML = ENU = 'IntracommunityEndpointUrl', ESP = 'IntracommunityEndpointUrl';
            NotBlank = true;


        }
        field(10; "Enable Batch Submissions"; Boolean)
        {
            CaptionML = ENU = 'Enable Batch Submissions', ESP = 'Enable Batch Submissions';


        }
        field(11; "Job Batch Submission Threshold"; Integer)
        {
            CaptionML = ENU = 'Job Batch Submission Threshold', ESP = 'Job Batch Submission Threshold';
            MinValue = 0;


        }
        field(12; "eMail"; Text[250])
        {
            DataClassification = ToBeClassified;


        }
        field(50; "Generate Grouped"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Generate Grouped', ESP = 'Generar L�neas Agrupadas';
            Description = 'JAV 20/03/21: - Si los documentos se generan agrupados, si no ser�n detallados';


        }
        field(51; "WorkDescription in Lines"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'WorkDescription in Lines', ESP = 'Descripción trabajo en l�neas';
            Description = 'JAV 08/04/21: - Si se incluye la Descripción del trabajo en la primera l�nea del documento';


        }
        field(52; "Send alwais period dates"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Send alwais period dates', ESP = 'Enviar siempre fechas del periodo';
            Description = 'JAV 08/04/21: - Si se narca se env�an siempre las fechas, si no tiene ser�n las del documento';


        }
    }
    keys
    {
        key(key1; "Primary Key")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       CannotEnableWithoutCertificateErr@1000000005 :
        CannotEnableWithoutCertificateErr: TextConst ENU = 'The setup cannot be enabled without a valid certificate.', ESP = 'No se puede activar la configuraci�n sin un certificado v�lido.';
        //       TaxpayerCertificateImportedMsg@1000000004 :
        TaxpayerCertificateImportedMsg: TextConst ENU = 'The taxpayer certificate has been successfully imported.', ESP = 'El certificado de contribuyente se ha importado correctamente.';
        //       CertificatePasswordIncorrectErr@1000000003 :
        CertificatePasswordIncorrectErr: TextConst ENU = 'The certificate could not get loaded. The password for the certificate may be incorrect.', ESP = 'No se pudo cargar el certificado. Puede que la contrase�a del certificado sea incorrecta.';
        //       CerFileFilterExtensionTxt@1000000002 :
        CerFileFilterExtensionTxt: TextConst ENU = 'All Files (*.*)|*.*', ESP = 'Todos los archivos (*.*)|*.*';
        //       CerFileFilterTxt@1000000001 :
        CerFileFilterTxt:
// {Locked}
TextConst ENU = 'cer p12 crt pfx', ESP = 'cer p12 crt pfx';
        //       ImportFileTxt@1000000000 :
        ImportFileTxt: TextConst ENU = 'Select a file to import', ESP = 'Seleccionar un archivo para importar';

    procedure ImportCertificate()
    var
        //       TempBlob@1100006 :
        TempBlob: Codeunit "Temp Blob";
        Blob: OutStream;
        InStr: InStream;
        //       EmptyTempBlob@1100008 :
        EmptyTempBlob: Codeunit "Temp Blob";
        //       FileManagement@1100007 :
        FileManagement: Codeunit "File Management";
    begin
        if FileManagement.BLOBImportWithFilter(TempBlob, ImportFileTxt, '', CerFileFilterExtensionTxt, CerFileFilterTxt) = '' then
            exit;

        if Certificate.HASVALUE then begin
            Clear(EmptyTempBlob);
            // Certificate := EmptyTempBlob.Blob;
            /*To be tested*/

            EmptyTempBlob.CreateInStream(InStr, TextEncoding::Windows);
            InStr.Read(Certificate);
            MODIFY(TRUE);
        end;

        // Certificate := TempBlob.Blob;
        /*To be tested*/

        TempBlob.CreateInStream(InStr, TextEncoding::Windows);
        InStr.Read(Certificate);
        CALCFIELDS(Certificate);
        VALIDATE(Enabled, TRUE);
        MODIFY(TRUE);

        MESSAGE(TaxpayerCertificateImportedMsg);
    end;

    procedure DeleteCertificate()
    var
        //       EmptyTempBlob@1100008 :
        EmptyTempBlob: Codeunit "Temp Blob";
        Blob: OutStream;
        InStr: InStream;
    begin
        if Certificate.HASVALUE then begin
            Clear(EmptyTempBlob);
            // Certificate := EmptyTempBlob.Blob;
            /*To be tested*/

            EmptyTempBlob.CreateInStream(InStr, TextEncoding::Windows);
            InStr.Read(Certificate);
            MODIFY(TRUE);
        end;
        Password := '';
        VALIDATE(Enabled, FALSE);
        MODIFY(TRUE);
    end;

    [TryFunction]
    //     procedure LoadCertificateFromBlob (var Cert@1220000 :
    procedure LoadCertificateFromBlob(var Cert: DotNet X509Certificate2)
    var
        //       BlobIn@1100001 :
        BlobIn: InStream;
        //       MemStream@1100000 :
        MemStream: DotNet MemoryStream;
        //       X509KeyStorageFlags@1000000000 :
        X509KeyStorageFlags: DotNet X509KeyStorageFlags;
    begin
        CALCFIELDS(Certificate);
        if not Certificate.HASVALUE or (Password = '') then
            ERROR('');

        Certificate.CREATEINSTREAM(BlobIn);
        MemStream := MemStream.MemoryStream;
        COPYSTREAM(MemStream, BlobIn);
        //PEL: A�adido X509KeyStorageFlags.Exportable al constructor
        //Cert := Cert.X509Certificate2(MemStream.ToArray,Password);
        Cert := Cert.X509Certificate2(MemStream.ToArray, Password, X509KeyStorageFlags.Exportable);
    end;

    procedure ValidateCertificatePassword()
    var
        //       Cert@1100000 :
        Cert: DotNet X509Certificate2;
    begin
        if not LoadCertificateFromBlob(Cert) then
            ERROR(CertificatePasswordIncorrectErr);
    end;

    procedure IsEnabled(): Boolean;
    begin
        if not GET then
            exit(FALSE);
        exit(Enabled);
    end;

    /*begin
    end.
  */
}







