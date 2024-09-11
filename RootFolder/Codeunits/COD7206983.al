Codeunit 7206983 "QB Mail Management"
{


    trigger OnRun()
    BEGIN
    END;

    PROCEDURE SendInternalSalesDocument(SalesDocument: Variant; WithConfirmation: Boolean);
    VAR
        // SMTPMailSetup: Record 409;
        TempEmailItem: Record 9500 TEMPORARY;
        QuoBuildingSetup: Record 7207278;
        ReportSelections: Record 77;
        ReportLayoutSelection: Record 9651;
        UserSetup: Record 91;
        SalesInvoiceHeader: Record 112;
        SalesCrMemoHeader: Record 114;
        FileMgt: Codeunit 419;
        SMTPMail: Codeunit 50355;
        DocumentMailing: Codeunit 260;
        // EmailDialog: Page 9700;
        chr13: Char;
        chr10: Char;
        ReportID: Integer;
        EmailFrom: Text[250];
        EmailTo: Text[250];
        ServerEmailBodyFilePath: Text[250];
        ServerAttachmentFilePath: Text[250];
        AttachmentFileName: Text[250];
        Text001: TextConst ENU = 'Mail sent', ESP = 'Correo interno de confirmaci�n enviado';
        Err000: TextConst ESP = 'No hay informado un usuario en la configuraci�n del SMTP';
        Err001: TextConst ENU = 'No mail configured', ESP = 'No hay direcci�n de mail de destino en la configuraci�n de QuoBuilding';
        BodyText: Text;
        SubjectText: Text;
        DocNo: Text;
        CustomerNo: Text;
        CustomerName: Text;
        DocType: Option "Factura","Abono";
        rr: RecordRef;
        fr: FieldRef;
    BEGIN
        //Q16494
        chr13 := 13;
        chr10 := 10;

        //Buscar el tipo y n�mero del documento
        rr.GETTABLE(SalesDocument);
        fr := rr.FIELD(3);
        DocNo := fr.VALUE;
        fr := rr.FIELD(4);
        CustomerNo := fr.VALUE;
        fr := rr.FIELD(5);
        CustomerName := fr.VALUE;

        CASE rr.NUMBER OF
            DATABASE::"Sales Invoice Header":
                DocType := DocType::Factura;
            DATABASE::"Sales Cr.Memo Header":
                DocType := DocType::Abono;
            ELSE
                ERROR('Documento no soportado para el env�o interno');
        END;


        //Mirar el report a usar para la impresi�n
        ReportSelections.RESET;
        CASE DocType OF
            DocType::Factura:
                ReportSelections.SETRANGE(Usage, ReportSelections.Usage::"S.Invoice");
            DocType::Abono:
                ReportSelections.SETRANGE(Usage, ReportSelections.Usage::"S.Cr.Memo");
        END;

        IF ReportSelections.FINDFIRST THEN
            ReportID := ReportSelections."Report ID"
        ELSE
            ERROR('No ha definido el formato de impresi�n del documento en el selector de informes para ventas');

        //Origen del correo
        // SMTPMailSetup.GET();
        // EmailFrom := SMTPMailSetup."User ID";
        IF EmailFrom = '' THEN
            ERROR(Err000);

        //Destinatarios del correo
        QuoBuildingSetup.GET();
        EmailTo := QuoBuildingSetup."Internal Shippind to Mail";
        IF EmailTo = '' THEN
            ERROR(Err001);

        //Montar el adjunto en PDF y el cuerpo en HTML
        ServerAttachmentFilePath := COPYSTR(FileMgt.ServerTempFileName('pdf'), 1, 250);
        ServerEmailBodyFilePath := '';

        CASE DocType OF
            DocType::Factura:
                BEGIN
                    SalesInvoiceHeader.RESET;  //Si no ponemos un filtro en la tabla dar� un error el proceso de creaci�n del PDF/HTML
                    SalesInvoiceHeader.SETRANGE("No.", DocNo);

                    //Guardar el adjunto como un PDF
                    REPORT.SAVEASPDF(ReportID, ServerAttachmentFilePath, SalesInvoiceHeader);

                    //Guardar el cuerpo como HTML
                    IF (QuoBuildingSetup."Internal Shippind Inv. Layout" <> '') THEN BEGIN
                        ServerEmailBodyFilePath := COPYSTR(FileMgt.ServerTempFileName('html'), 1, 250);
                        ReportLayoutSelection.SetTempLayoutSelected(QuoBuildingSetup."Internal Shippind Inv. Layout");
                        REPORT.SAVEASHTML(ReportID, ServerEmailBodyFilePath, SalesInvoiceHeader);
                        ReportLayoutSelection.SetTempLayoutSelected('');
                    END;
                END;
            DocType::Abono:
                BEGIN
                    SalesCrMemoHeader.RESET;  //Si no ponemos un filtro en la tabla dar� un error el proceso de creaci�n del PDF/HTML
                    SalesCrMemoHeader.SETRANGE("No.", DocNo);

                    //Guardar el adjunto como un PDF
                    REPORT.SAVEASPDF(ReportID, ServerAttachmentFilePath, SalesCrMemoHeader);

                    //Guardar el cuerpo como HTML
                    IF (QuoBuildingSetup."Internal Shippind Cr.M. Layout" <> '') THEN BEGIN
                        ServerEmailBodyFilePath := COPYSTR(FileMgt.ServerTempFileName('html'), 1, 250);
                        ReportLayoutSelection.SetTempLayoutSelected(QuoBuildingSetup."Internal Shippind Cr.M. Layout");
                        REPORT.SAVEASHTML(ReportID, ServerEmailBodyFilePath, SalesCrMemoHeader);
                        ReportLayoutSelection.SetTempLayoutSelected('');
                    END;
                END;
        END;

        CASE DocType OF
            DocType::Factura:
                BEGIN
                    SubjectText := 'Registrada Factura de venta ';
                    AttachmentFileName := 'Factura Venta ';
                END;
            DocType::Abono:
                BEGIN
                    SubjectText := 'Registrado Abono de venta ';
                    AttachmentFileName := 'Abono Venta ';
                END;
        END;
        SubjectText += DocNo + ' en la empresa ' + COMPANYNAME;
        AttachmentFileName += DocNo + '.pdf';


        BodyText := STRSUBSTNO(QuoBuildingSetup."Internal Shipping Text 1", FORMAT(DocType), DocNo, CustomerNo, CustomerName, USERID, COMPANYNAME) + FORMAT(chr13) + FORMAT(chr10);
        BodyText += STRSUBSTNO(QuoBuildingSetup."Internal Shipping Text 2", FORMAT(DocType), DocNo, CustomerNo, CustomerName, USERID, COMPANYNAME) + FORMAT(chr13) + FORMAT(chr10);
        BodyText += STRSUBSTNO(QuoBuildingSetup."Internal Shipping Text 3", FORMAT(DocType), DocNo, CustomerNo, CustomerName, USERID, COMPANYNAME) + FORMAT(chr13) + FORMAT(chr10);

        //Crear el registro del mail
        TempEmailItem.Init;
        TempEmailItem."From Address" := EmailFrom;
        TempEmailItem."Send to" := EmailTo;
        TempEmailItem.Subject := SubjectText;
        TempEmailItem."Attachment File Path" := ServerAttachmentFilePath;
        TempEmailItem."Attachment Name" := AttachmentFileName;
        TempEmailItem.SetBodyText(BodyText);
        IF ServerEmailBodyFilePath <> '' THEN BEGIN
            TempEmailItem.VALIDATE("Plaintext Formatted", FALSE);
            TempEmailItem.VALIDATE("Body File Path", ServerEmailBodyFilePath);
        END;
        TempEmailItem.INSERT;


        //Mostrar el mensaje en la pantalla
        IF (NOT QuoBuildingSetup."Internal Shippind Don't Show") THEN BEGIN
            // EmailDialog.SetValues(TempEmailItem, FALSE, TRUE);
            COMMIT;

            // IF NOT (EmailDialog.RUNMODAL = ACTION::OK) THEN
            //     EXIT;

            // EmailDialog.GETRECORD(TempEmailItem);
        END;

        //Enviarlo
        IF TempEmailItem.Send(TRUE) THEN
            IF (WithConfirmation) THEN
                MESSAGE(Text001);
    END;

    [EventSubscriber(ObjectType::Codeunit, 80, OnAfterPostSalesDoc, '', true, true)]
    PROCEDURE SalesPost_OnAfterPostSalesDoc(VAR SalesHeader: Record 36; VAR GenJnlPostLine: Codeunit 12; SalesShptHdrNo: Code[20]; RetRcpHdrNo: Code[20]; SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20]; CommitIsSuppressed: Boolean);
    VAR
        SalesInvHeader: Record 112;
        SalesCrMemoHeader: Record 114;
        QuoBuildingSetup: Record 7207278;
    BEGIN
        //Q16494
        QuoBuildingSetup.GET();
        IF (QuoBuildingSetup."Internal Shippind Sales Inv." <> QuoBuildingSetup."Internal Shippind Sales Inv."::Automatic) THEN
            EXIT;

        IF (SalesInvHeader.GET(SalesInvHdrNo)) THEN
            SendInternalSalesDocument(SalesInvHeader, NOT QuoBuildingSetup."Internal Shippind Don't Conf.");

        IF (SalesCrMemoHeader.GET(SalesCrMemoHdrNo)) THEN
            SendInternalSalesDocument(SalesCrMemoHeader, NOT QuoBuildingSetup."Internal Shippind Don't Conf.");
    END;

    /* /*BEGIN
END.*/
}









