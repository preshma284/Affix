page 53227 "Email Dialog"
{
CaptionML=ENU='Send Email',ESP='Enviar correo electr�nico';
    SourceTable=9500;
    PageType=StandardDialog;
    SourceTableTemporary=true;
    
  layout
{
area(content)
{
    field("FromAddress";ShownFromEmail)
    {
        
                ExtendedDatatype=EMail;
                CaptionML=ENU='From',ESP='Desde';
                ToolTipML=ENU='Specifies the sender of the email.',ESP='Especifica el remitente del mensaje de correo electr�nico.';
                ApplicationArea=Basic,Suite;
                Visible=False;
                Enabled=False ;
    }
    field("SendTo";SendToText)
    {
        
                ExtendedDatatype=EMail;
                CaptionML=ENU='To',ESP='Para';
                ToolTipML=ENU='Specifies the recipient of the email.',ESP='Especifica el destinatario del mensaje de correo electr�nico.';
                ApplicationArea=Basic,Suite;
                
                            ;trigger OnValidate()    BEGIN
                             EmailItem.VALIDATE("Send to",SendToText);
                             SendToText := EmailItem."Send to";
                           END;


    }
    field("CcText";CcText)
    {
        
                CaptionML=ENU='Cc',ESP='Cc';
                ToolTipML=ENU='Specifies one or more additional recipients.',ESP='Especifica uno o varios destinatarios adicionales.';
                ApplicationArea=Basic,Suite;
                
                            ;trigger OnValidate()    BEGIN
                             EmailItem.VALIDATE("Send CC",CcText);
                             CcText := EmailItem."Send CC";
                           END;


    }
    field("BccText";BccText)
    {
        
                CaptionML=ENU='Bcc',ESP='CCo';
                ToolTipML=ENU='Specifies one or more additional recipients.',ESP='Especifica uno o varios destinatarios adicionales.';
                ApplicationArea=Basic,Suite;
                
                            ;trigger OnValidate()    BEGIN
                             EmailItem.VALIDATE("Send BCC",BccText);
                             BccText := EmailItem."Send BCC";
                           END;


    }
    field("Subject";EmailItem.Subject)
    {
        
                CaptionML=ENU='Subject',ESP='Asunto';
                ToolTipML=ENU='Specifies the text that will display as the subject of the email.',ESP='Especifica el texto que se mostrar� como asunto del mensaje de correo electr�nico.';
                ApplicationArea=Basic,Suite;
    }
    field("Attachment Name";EmailItem."Attachment Name")
    {
        
                CaptionML=ENU='Attachment Name',ESP='Nombre de archivo adjunto';
                ToolTipML=ENU='Specifies the name of the attached document.',ESP='Especifica el nombre del documento adjunto.';
                ApplicationArea=All;
                Visible=HasAttachment;
                Enabled=NOT IsOfficeAddin;
                Editable=IsOfficeAddin;
                
                              ;trigger OnAssistEdit()    VAR
                               MailManagement : Codeunit 9520;
                             BEGIN
                               MailManagement.DownloadPdfAttachment(EmailItem);
                             END;


    }
    field("MessageContents";EmailItem."Message Type")
    {
        
                CaptionML=ENU='Message Content',ESP='Contenido del mensaje';
                ApplicationArea=Basic,Suite;
                Visible=NOT PlainTextVisible;
                
                            ;trigger OnValidate()    VAR
                            //  TempBlob : Record 99008535;
                             TempBlob: Codeunit "Temp Blob";
                             Instr: InStream;
                             Blob: OutStream;
                             FileManagement : Codeunit 419;
                           BEGIN
                             UpdatePlainTextVisible;

                             CASE EmailItem."Message Type" OF
                               EmailItem."Message Type"::"From Email Body Template":
                                 BEGIN
                                   FileManagement.BLOBImportFromServerFile(TempBlob,EmailItem."Body File Path");
                                  //  EmailItem.Body := TempBlob.Blob;
                                   TempBlob.CreateInStream(InStr, TextEncoding::Windows);
                                   Instr.Read(EmailItem.Body); 
                                   BodyText := EmailItem.GetBodyText;
                                 END;
                               EmailItem."Message Type"::"Custom Message":
                                 BEGIN
                                   BodyText := PreviousBodyText;
                                   EmailItem.SetBodyText(BodyText);
                                 END;
                             END;
                           END;


    }
group("Control14")
{
        
group("Control12")
{
        
                Visible=NOT PlainTextVisible;
    usercontrol("BodyHTMLMessage";"Microsoft.Dynamics.Nav.Client.WebPageViewer")
    {
        trigger ControlAddInReady(callbackUrl : Text);
    BEGIN
      CurrPage.BodyHTMLMessage.LinksOpenInNewWindow;
      CurrPage.BodyHTMLMessage.SetContent(BodyText);
    END;

    trigger DocumentReady();
    BEGIN
    END;

    trigger Callback(data : Text);
    BEGIN
    END;

    trigger Refresh(CallbackUrl : Text);
    BEGIN
      CurrPage.BodyHTMLMessage.LinksOpenInNewWindow;
      CurrPage.BodyHTMLMessage.SetContent(BodyText);
    END;

        }

}
group("Control13")
{
        
                Visible=PlainTextVisible;
    field("BodyText";BodyText)
    {
        
                CaptionML=ENU='Message',ESP='Mensaje';
                ToolTipML=ENU='Specifies the body of the email.',ESP='Especifica el cuerpo del mensaje de correo electr�nico.';
                ApplicationArea=Basic,Suite;
                MultiLine=true;
                

                ShowCaption=false ;trigger OnValidate()    BEGIN
                             EmailItem.SetBodyText(BodyText);

                             IF rec."Message Type" = rec."Message Type"::"Custom Message" THEN
                               PreviousBodyText := BodyText;
                           END;


    }

}

}
    field("OutlookEdit";LocalEdit)
    {
        
                CaptionML=ENU='Edit in Outlook',ESP='Editar en Outlook';
                ToolTipML=ENU='Specifies that Microsoft Outlook will open so you can complete the email there.',ESP='Especifica que Microsoft Outlook se abrir� para que pueda completar el mensaje de correo electr�nico en esta aplicaci�n.';
                ApplicationArea=All;
                Visible=IsEditEnabled;
                MultiLine=true;
                
                            

  ;trigger OnValidate()    BEGIN
                             IF LocalEdit = TRUE THEN
                               ShownFromEmail := ''
                             ELSE
                               ShownFromEmail := OriginalFromEmail;
                           END;


    }

}
}
  trigger OnInit()    BEGIN
             HasAttachment := FALSE;
           END;

trigger OnOpenPage()    VAR
                //  TempBlob : Record 99008535 TEMPORARY ;
                 TempBlob: Codeunit "Temp Blob";
                 Instr: InStream;
                 Blob: OutStream;
                 FileManagement : Codeunit 419;
                 OfficeMgt : Codeunit 1630;
                 OrigMailBodyText : Text;
               BEGIN
                 OriginalFromEmail := OrigEmailItem."From Address";

                 IF NOT IsEditEnabled THEN
                   LocalEdit := FALSE;
                 IF ForceOutlook THEN
                   LocalEdit := TRUE;
                 IF NOT LocalEdit THEN
                   ShownFromEmail := OriginalFromEmail
                 ELSE
                   ShownFromEmail := '';

                 EmailItem.Subject := OrigEmailItem.Subject;
                 EmailItem."Attachment Name" := OrigEmailItem."Attachment Name";

                 InitBccCcText;
                 SendToText := OrigEmailItem."Send to";
                 IF OrigEmailItem."Send CC" <> '' THEN
                   CcText := OrigEmailItem."Send CC"
                 ELSE
                   EmailItem."Send CC" := CcText;
                 IF OrigEmailItem."Send BCC" <> '' THEN
                   BccText := OrigEmailItem."Send BCC"
                 ELSE
                   EmailItem."Send BCC" := BccText;

                 BodyText := '';

                 IF EmailItem."Plaintext Formatted" THEN
                   EmailItem."Message Type" := EmailItem."Message Type"::"Custom Message"
                 ELSE BEGIN
                   EmailItem."Body File Path" := OrigEmailItem."Body File Path";
                   FileManagement.BLOBImportFromServerFile(TempBlob,EmailItem."Body File Path");
                  //  EmailItem.Body := TempBlob.Blob;
                   TempBlob.CreateInStream(InStr, TextEncoding::Windows);
                   Instr.Read(EmailItem.Body); 
                   EmailItem."Message Type" := EmailItem."Message Type"::"From Email Body Template";
                 END;

                 OrigMailBodyText := EmailItem.GetBodyText;
                 IF OrigMailBodyText <> '' THEN
                   BodyText := OrigMailBodyText
                 ELSE
                   EmailItem.SetBodyText(BodyText);

                 UpdatePlainTextVisible;
                 IsOfficeAddin := OfficeMgt.IsAvailable;
               END;

trigger OnClosePage()    BEGIN
                  Rec := EmailItem;
                END;



    var
      EmailItem : Record 9500;
      OrigEmailItem : Record 9500;
      ClientTypeManagement : Codeunit 50192;
      

LocalEdit : Boolean;
      IsEditEnabled : Boolean;
      HasAttachment : Boolean;
      ForceOutlook : Boolean;
      PlainTextVisible : Boolean;
      IsOfficeAddin : Boolean;
      OriginalFromEmail : Text[250];
      BodyText : Text;
      SendToText : Text[250];
      BccText : Text[250];
      CcText : Text[250];
      ShownFromEmail : Text;
      PreviousBodyText : Text;

    //[External]
    procedure SetValues(ParmEmailItem : Record 9500;ParmOutlookSupported : Boolean;ParmSmtpSupported : Boolean);
    begin
      EmailItem := ParmEmailItem;
      OrigEmailItem.COPY(ParmEmailItem);

      ForceOutlook := ParmOutlookSupported and not ParmSmtpSupported;
      IsEditEnabled := ParmOutlookSupported and (ClientTypeManagement.GetCurrentClientType = CLIENTTYPE::Windows);
      if not IsEditEnabled then
        LocalEdit := FALSE
      ELSE
        LocalEdit := TRUE;

      if EmailItem."Attachment File Path" <> '' then
        HasAttachment := TRUE;
    end;

    //[External]
    procedure GetDoEdit() : Boolean;
    begin
      exit(LocalEdit);
    end;

    LOCAL procedure UpdatePlainTextVisible();
    begin
      PlainTextVisible := EmailItem."Message Type" = EmailItem."Message Type"::"Custom Message";
    end;

    LOCAL procedure InitBccCcText();
    begin
      BccText := '';
      CcText := '';
    end;

    // begin//end
}




