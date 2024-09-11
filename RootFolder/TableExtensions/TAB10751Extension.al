tableextension 50208 "MyExtension50208" extends "SII Setup"
{


    CaptionML = ENU = 'SII VAT Setup', ESP = 'Configuraci�n de IVA SII';
    LookupPageID = "SII Setup";

    fields
    {
        //To be tested (added certificate_ as blob since certificate has been replaced with certificate code)
        field(7100000; "Certificate_"; Blob)
        {
            CaptionML = ENU = 'Certificate', ESP = 'Certificado';
        }
    }
    keys
    {
        // key(key1;"Primary Key")
        //  {
        /* Clustered=true;
  */
        // }
    }
    fieldgroups
    {
    }

    var
        //       CannotEnableWithoutCertificateErr@1100000 :
        CannotEnableWithoutCertificateErr: TextConst ENU = 'The setup cannot be enabled without a valid certificate.', ESP = 'No se puede activar la configuraci�n sin un certificado v�lido.';
        //       TaxpayerCertificateImportedMsg@1100002 :
        TaxpayerCertificateImportedMsg: TextConst ENU = 'The taxpayer certificate has been successfully imported.', ESP = 'El certificado de contribuyente se ha importado correctamente.';
        //       CertificatePasswordIncorrectErr@1100001 :
        CertificatePasswordIncorrectErr: TextConst ENU = 'The certificate could not get loaded. The password for the certificate may be incorrect.', ESP = 'No se pudo cargar el certificado. Puede que la contrase�a del certificado sea incorrecta.';
        //       CerFileFilterExtensionTxt@1100003 :
        CerFileFilterExtensionTxt: TextConst ENU = 'All Files (*.*)|*.*', ESP = 'Todos los archivos (*.*)|*.*';
        //       CerFileFilterTxt@1100004 :
        CerFileFilterTxt:
// {Locked}
TextConst ENU = 'cer p12 crt pfx', ESP = 'cer p12 crt pfx';
        //       ImportFileTxt@1100005 :
        ImportFileTxt: TextConst ENU = 'Select a file to import', ESP = 'Seleccionar un archivo para importar';
        //       SiiTxt@1100007 :
        SiiTxt:
// {Locked}
TextConst ENU = 'https://www2.agenciatributaria.gob.es/static_files/common/internet/dep/aplicaciones/es/aeat/ssii/fact/ws/SuministroInformacion.xsd', ESP = 'https://www2.agenciatributaria.gob.es/static_files/common/internet/dep/aplicaciones/es/aeat/ssii/fact/ws/SuministroInformacion.xsd';
        //       SiiLRTxt@1100006 :
        SiiLRTxt:
// {Locked}
TextConst ENU = 'https://www2.agenciatributaria.gob.es/static_files/common/internet/dep/aplicaciones/es/aeat/ssii/fact/ws/SuministroLR.xsd', ESP = 'https://www2.agenciatributaria.gob.es/static_files/common/internet/dep/aplicaciones/es/aeat/ssii/fact/ws/SuministroLR.xsd';




    /*
    trigger OnInsert();    begin
                   "Starting Date" := WORKDATE;
                 end;

    */




    /*
    procedure ImportCertificate ()
        var
    //       TempBlob@1100006 :
          TempBlob: Record 99008535;
    //       EmptyTempBlob@1100008 :
          EmptyTempBlob: Record 99008535;
    //       FileManagement@1100007 :
          FileManagement: Codeunit 419;
        begin
          if FileManagement.BLOBImportWithFilter(TempBlob,ImportFileTxt,'',CerFileFilterExtensionTxt,CerFileFilterTxt) = '' then
            exit;

          if Certificate.HASVALUE then begin
            Clear(EmptyTempBlob);
            // Certificate := EmptyTempBlob.Blob;
    //To be tested

    EmptyTempBlob.CreateInStream(InStr, TextEncoding::Windows);
    InStr.Read(Certificate);
            MODIFY(TRUE);
          end;

          // Certificate := TempBlob.Blob;
    //To be tested

    TempBlob.CreateInStream(InStr, TextEncoding::Windows);
    InStr.Read(Certificate);
          CALCFIELDS(Certificate);
          VALIDATE(Enabled,TRUE);
          MODIFY(TRUE);

          MESSAGE(TaxpayerCertificateImportedMsg);
        end;
    */



    /*
    procedure DeleteCertificate ()
        var
    //       EmptyTempBlob@1100008 :
          EmptyTempBlob: Record 99008535;
        begin
          if Certificate.HASVALUE then begin
            Clear(EmptyTempBlob);
            // Certificate := EmptyTempBlob.Blob;
    //To be tested

    EmptyTempBlob.CreateInStream(InStr, TextEncoding::Windows);
    InStr.Read(Certificate);
            MODIFY(TRUE);
          end;
          Password := '';
          VALIDATE(Enabled,FALSE);
          MODIFY(TRUE);
        end;

        [TryFunction]
    */

    //     procedure LoadCertificateFromBlob (var Cert@1220000 :

    [TryFunction]
    procedure LoadCertificateFromBlob(var Cert: DotNet "X509Certificate2");
    var
        //       BlobIn@1100001 :
        BlobIn: InStream;
        //       MemStream@1100000 :
        MemStream: DotNet "MemoryStream";
    begin
        CALCFIELDS(Certificate_);
        if not Certificate_.HASVALUE or ("Certificate Code" = '') then
            ERROR('');

        Certificate_.CREATEINSTREAM(BlobIn);
        MemStream := MemStream.MemoryStream;
        COPYSTREAM(MemStream, BlobIn);
        Cert := Cert.X509Certificate2(MemStream.ToArray, "Certificate Code");
    end;





    procedure ValidateCertificatePassword()
    var
        //       Cert@1100000 :
        Cert: DotNet "X509Certificate2";
    begin
        if not LoadCertificateFromBlob(Cert) then
            ERROR(CertificatePasswordIncorrectErr);
    end;




    /*
    procedure IsEnabled () : Boolean;
        begin
          if not GET then
            exit(FALSE);
          exit(Enabled);
        end;
    */




    /*
    procedure SetDefaults ()
        begin
          if ("SuministroInformacion Schema" <> '') and ("SuministroLR Schema" <> '') then
            exit;

          "SuministroInformacion Schema" := SiiTxt;
          "SuministroLR Schema" := SiiLRTxt;
          MODIFY(TRUE);
        end;

        /*begin
        end.
      */
}




