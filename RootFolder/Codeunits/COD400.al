Codeunit 50355 "SMTP Mail"
{


    // Permissions = TableData 409 = r;
    trigger OnRun()
    BEGIN
    END;

    VAR
        // SMTPMailSetup: Record 409;
        Mail: DotNet SmtpMessage;
        Text002: TextConst ENU = 'Attachment %1 does not exist or can not be accessed from the program.', ESP = 'El adjunto %1 no existe o no se puede obtener acceso a ‚ste desde el programa.';
        SendResult: Text;
        Text003: TextConst ENU = 'The mail system returned the following error: "%1".', ESP = 'El sistema de correo devolvi¢ el siguiente error: "%1".';
        SendErr: TextConst ENU = 'The email couldn''t be sent.', ESP = 'No se pudo enviar el correo electr¢nico.';
        RecipientErr: TextConst ENU = 'Could not add recipient %1.', ESP = 'No se pudo agregar el destinatario %1.';
        BodyErr: TextConst ENU = 'Could not add text to email body.', ESP = 'No se pudo agregar texto al cuerpo del correo electr¢nico.';
        AttachErr: TextConst ENU = 'Could not add an attachment to the email.', ESP = 'No se pudo agregar un anexo al correo electr¢nico.';

    //[External]
    PROCEDURE CreateMessage(SenderName: Text; SenderAddress: Text; Recipients: Text; Subject: Text; Body: Text; HtmlFormatted: Boolean);
    BEGIN
        OnBeforeCreateMessage(SenderName, SenderAddress, Recipients, Subject, Body, HtmlFormatted);

        IF Recipients <> '' THEN
            CheckValidEmailAddresses(Recipients);
        CheckValidEmailAddresses(SenderAddress);
        // SMTPMailSetup.GetSetup;
        // SMTPMailSetup.TESTFIELD("SMTP Server");
        IF NOT ISNULL(Mail) THEN BEGIN
            Mail.Dispose;
            CLEAR(Mail);
        END;
        SendResult := '';
        Mail := Mail.SmtpMessage;
        Mail.FromName := SenderName;
        Mail.FromAddress := SenderAddress;
        Mail."To" := Recipients;
        Mail.Subject := Subject;
        Mail.Body := Body;
        Mail.HtmlFormatted := HtmlFormatted;

        IF HtmlFormatted THEN
            Mail.ConvertBase64ImagesToContentId;
    END;

    //[External]
    PROCEDURE TrySend(): Boolean;
    VAR
        Password: Text;
    BEGIN
        OnBeforeTrySend;
        SendResult := '';
        // Password := SMTPMailSetup.GetPassword;
        // WITH SMTPMailSetup DO
        //     SendResult :=
        //       Mail.Send(
        //         "SMTP Server",
        //         "SMTP Server Port",
        //         Authentication <> Authentication::Anonymous,
        //         "User ID",
        //         Password,
        //         "Secure Connection");
        Mail.Dispose;
        CLEAR(Mail);
        OnAfterTrySend(SendResult);
        EXIT(SendResult = '');
    END;

    //[External]
    PROCEDURE Send();
    BEGIN
        IF NOT TrySend THEN
            ShowErrorNotification(SendErr, SendResult);
    END;

    //[External]
    PROCEDURE AddRecipients(Recipients: Text);
    VAR
        Result: Text;
    BEGIN
        OnBeforeAddRecipients(Recipients);

        CheckValidEmailAddresses(Recipients);
        Result := Mail.AddRecipients(Recipients);
        IF Result <> '' THEN
            ShowErrorNotification(STRSUBSTNO(RecipientErr, Recipients), Result);
    END;

    //[External]
    PROCEDURE AddCC(Recipients: Text);
    VAR
        Result: Text;
    BEGIN
        OnBeforeAddCC(Recipients);

        CheckValidEmailAddresses(Recipients);
        Result := Mail.AddCC(Recipients);
        IF Result <> '' THEN
            ShowErrorNotification(STRSUBSTNO(RecipientErr, Recipients), Result);
    END;

    //[External]
    PROCEDURE AddBCC(Recipients: Text);
    VAR
        Result: Text;
    BEGIN
        OnBeforeAddBCC(Recipients);

        CheckValidEmailAddresses(Recipients);
        Result := Mail.AddBCC(Recipients);
        IF Result <> '' THEN
            ShowErrorNotification(STRSUBSTNO(RecipientErr, Recipients), Result);
    END;

    //[External]
    PROCEDURE AppendBody(BodyPart: Text);
    VAR
        Result: Text;
    BEGIN
        Result := Mail.AppendBody(BodyPart);
        IF Result <> '' THEN
            ShowErrorNotification(BodyErr, Result);
    END;

    //[Internal]
    PROCEDURE AddAttachment(Attachment: Text; FileName: Text);
    VAR
        FileManagement: Codeunit 419;
        Result: Text;
    BEGIN
        IF Attachment = '' THEN
            EXIT;
        IF NOT EXISTS(Attachment) THEN
            ERROR(Text002, Attachment);

        FileName := FileManagement.StripNotsupportChrInFileName(FileName);
        FileName := DELCHR(FileName, '=', ';'); // Used for splitting multiple file names in Mail .NET component

        FileManagement.IsAllowedPath(Attachment, FALSE);
        Result := Mail.AddAttachmentWithName(Attachment, FileName);

        IF Result <> '' THEN
            ShowErrorNotification(AttachErr, Result);
    END;

    //[External]
    PROCEDURE AddAttachmentStream(AttachmentStream: InStream; AttachmentName: Text);
    VAR
        FileManagement: Codeunit 419;
    BEGIN
        AttachmentName := FileManagement.StripNotsupportChrInFileName(AttachmentName);

        Mail.AddAttachment(AttachmentStream, AttachmentName);
    END;

    //[External]
    PROCEDURE CheckValidEmailAddresses(Recipients: Text);
    VAR
        MailManagement: Codeunit 9520;
    BEGIN
        MailManagement.CheckValidEmailAddresses(Recipients);
    END;

    //[External]
    PROCEDURE GetLastSendMailErrorText(): Text;
    BEGIN
        EXIT(SendResult);
    END;

    //[External]
    PROCEDURE GetSMTPMessage(VAR SMTPMessage: Dotnet SmtpMessage);
    BEGIN
        SMTPMessage := Mail;
    END;

    //[External]
    PROCEDURE IsEnabled(): Boolean;
    BEGIN
        // SMTPMailSetup.GetSetup;
        // EXIT(NOT (SMTPMailSetup."SMTP Server" = ''));
    END;

    [EventSubscriber(ObjectType::Table, 1400, OnRegisterServiceConnection, '', true, true)]
    //[External]
    PROCEDURE HandleSMTPRegisterServiceConnection(VAR ServiceConnection: Record 1400);
    VAR
        RecRef: RecordRef;
    BEGIN
        // SMTPMailSetup.GetSetup;
        // RecRef.GETTABLE(SMTPMailSetup);

        ServiceConnection.Status := ServiceConnection.Status::Enabled;
        // IF SMTPMailSetup."SMTP Server" = '' THEN
        //     ServiceConnection.Status := ServiceConnection.Status::Disabled;

        // WITH SMTPMailSetup DO
        //     ServiceConnection.InsertServiceConnection(
        //       ServiceConnection, RecRef.RECORDID, TABLECAPTION, '', PAGE::"SMTP Mail Setup");
    END;

    //[External]
    PROCEDURE GetBody(): Text;
    BEGIN
        EXIT(Mail.Body);
    END;

    //[IntegrationEvent]
    PROCEDURE OnBeforeTrySend();
    BEGIN
    END;

    LOCAL PROCEDURE ShowErrorNotification(ErrorMessage: Text; SmtpResult: Text);
    VAR
        NotificationLifecycleMgt: Codeunit 1511;
        Notification: Notification;
    BEGIN
        IF GUIALLOWED THEN BEGIN
            Notification.MESSAGE := ErrorMessage;
            Notification.SCOPE := NOTIFICATIONSCOPE::LocalScope;
            Notification.ADDACTION('Details', CODEUNIT::"SMTP Mail", 'ShowNotificationDetail');
            Notification.SETDATA('Details', STRSUBSTNO(Text003, SmtpResult));
            // NotificationLifecycleMgt.SendNotification(Notification, SMTPMailSetup.RECORDID);
            ERROR('');
        END;
        ERROR(Text003, SmtpResult);
    END;

    //[External]
    PROCEDURE ShowNotificationDetail(Notification: Notification);
    BEGIN
        MESSAGE(Notification.GETDATA('Details'));
    END;

    //[External]
    PROCEDURE GetO365SmtpServer(): Text[250];
    BEGIN
        EXIT('smtp.office365.com')
    END;

    //[External]
    PROCEDURE GetOutlookSmtpServer(): Text[250];
    BEGIN
        EXIT('smtp-mail.outlook.com')
    END;

    //[External]
    PROCEDURE GetGmailSmtpServer(): Text[250];
    BEGIN
        EXIT('smtp.gmail.com')
    END;

    //[External]
    PROCEDURE GetYahooSmtpServer(): Text[250];
    BEGIN
        EXIT('smtp.mail.yahoo.com')
    END;

    //[External]
    PROCEDURE GetDefaultSmtpPort(): Integer;
    BEGIN
        EXIT(587);
    END;

    //[External]
    PROCEDURE GetYahooSmtpPort(): Integer;
    BEGIN
        EXIT(465);
    END;

    //[External]
    PROCEDURE GetDefaultSmtpAuthType(): Integer;
    VAR
    // SMTPMailSetup: Record 409;
    BEGIN
        // EXIT(SMTPMailSetup.Authentication::Basic);
    END;

    // LOCAL PROCEDURE ApplyDefaultSmtpConnectionSettings(VAR SMTPMailSetupConfig: Record 409);
    // BEGIN
    //     SMTPMailSetupConfig.Authentication := GetDefaultSmtpAuthType;
    //     SMTPMailSetupConfig."Secure Connection" := TRUE;
    // END;

    //[External]
    // PROCEDURE ApplyOffice365Smtp(VAR SMTPMailSetupConfig: Record 409);
    // BEGIN
    //     // This might be changed by the Microsoft Office 365 team.
    //     // Current source: http://technet.microsoft.com/library/dn554323.aspx
    //     SMTPMailSetupConfig."SMTP Server" := GetO365SmtpServer;
    //     SMTPMailSetupConfig."SMTP Server Port" := GetDefaultSmtpPort;
    //     ApplyDefaultSmtpConnectionSettings(SMTPMailSetupConfig);
    // END;

    //[External]
    // PROCEDURE ApplyOutlookSmtp(VAR SMTPMailSetupConfig: Record 409);
    // BEGIN
    //     // This might be changed.
    //     SMTPMailSetupConfig."SMTP Server" := GetOutlookSmtpServer;
    //     SMTPMailSetupConfig."SMTP Server Port" := GetDefaultSmtpPort;
    //     ApplyDefaultSmtpConnectionSettings(SMTPMailSetupConfig);
    // END;

    //[External]
    // PROCEDURE ApplyGmailSmtp(VAR SMTPMailSetupConfig: Record 409);
    // BEGIN
    //     // This might be changed.
    //     SMTPMailSetupConfig."SMTP Server" := GetGmailSmtpServer;
    //     SMTPMailSetupConfig."SMTP Server Port" := GetDefaultSmtpPort;
    //     ApplyDefaultSmtpConnectionSettings(SMTPMailSetupConfig);
    // END;

    //[External]
    // PROCEDURE ApplyYahooSmtp(VAR SMTPMailSetupConfig: Record 409);
    // BEGIN
    //     // This might be changed.
    //     SMTPMailSetupConfig."SMTP Server" := GetYahooSmtpServer;
    //     SMTPMailSetupConfig."SMTP Server Port" := GetYahooSmtpPort;
    //     ApplyDefaultSmtpConnectionSettings(SMTPMailSetupConfig);
    // END;

    //[External]
    // PROCEDURE IsOffice365Setup(VAR SMTPMailSetupConfig: Record 409): Boolean;
    // BEGIN
    //     IF SMTPMailSetupConfig."SMTP Server" <> GetO365SmtpServer THEN
    //         EXIT(FALSE);

    //     IF SMTPMailSetupConfig."SMTP Server Port" <> GetDefaultSmtpPort THEN
    //         EXIT(FALSE);

    //     EXIT(IsSmtpConnectionSetup(SMTPMailSetupConfig));
    // END;

    //[External]
    // PROCEDURE IsOutlookSetup(VAR SMTPMailSetupConfig: Record 409): Boolean;
    // BEGIN
    //     IF SMTPMailSetupConfig."SMTP Server" <> GetOutlookSmtpServer THEN
    //         EXIT(FALSE);

    //     IF SMTPMailSetupConfig."SMTP Server Port" <> GetDefaultSmtpPort THEN
    //         EXIT(FALSE);

    //     EXIT(IsSmtpConnectionSetup(SMTPMailSetupConfig));
    // END;

    //[External]
    // PROCEDURE IsGmailSetup(VAR SMTPMailSetupConfig: Record 409): Boolean;
    // BEGIN
    //     IF SMTPMailSetupConfig."SMTP Server" <> GetGmailSmtpServer THEN
    //         EXIT(FALSE);

    //     IF SMTPMailSetupConfig."SMTP Server Port" <> GetDefaultSmtpPort THEN
    //         EXIT(FALSE);

    //     EXIT(IsSmtpConnectionSetup(SMTPMailSetupConfig));
    // END;

    //[External]
    // PROCEDURE IsYahooSetup(VAR SMTPMailSetupConfig: Record 409): Boolean;
    // BEGIN
    //     IF SMTPMailSetupConfig."SMTP Server" <> GetYahooSmtpServer THEN
    //         EXIT(FALSE);

    //     IF SMTPMailSetupConfig."SMTP Server Port" <> GetYahooSmtpPort THEN
    //         EXIT(FALSE);

    //     EXIT(IsSmtpConnectionSetup(SMTPMailSetupConfig));
    // END;

    // LOCAL PROCEDURE IsSmtpConnectionSetup(VAR SMTPMailSetupConfig: Record 409): Boolean;
    // BEGIN
    //     IF SMTPMailSetupConfig.Authentication <> GetDefaultSmtpAuthType THEN
    //         EXIT(FALSE);

    //     IF SMTPMailSetupConfig."Secure Connection" <> TRUE THEN
    //         EXIT(FALSE);

    //     EXIT(TRUE);
    // END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterTrySend(VAR SendResult: Text);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeCreateMessage(VAR SenderName: Text; VAR SenderAddress: Text; VAR Recipients: Text; VAR Subject: Text; VAR Body: Text; HtmlFormatted: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeAddRecipients(VAR Recipients: Text);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeAddCC(VAR Recipients: Text);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeAddBCC(VAR Recipients: Text);
    BEGIN
    END;

    /* /*BEGIN
END.*/
}





