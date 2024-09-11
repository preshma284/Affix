//Obsolete page
// page 51269 "SMTP Mail Setup"
// {
// CaptionML=ENU='SMTP Mail Setup',ESP='Configuraci�n correo SMTP';
//     ApplicationArea=Basic,Suite;
//     InsertAllowed=false;
//     DeleteAllowed=false;
//     SourceTable=409;
//     PageType=Card;
//     UsageCategory=Administration;
    
//   layout
// {
// area(content)
// {
// group("Control1")
// {
        
//                 CaptionML=ENU='General',ESP='General';
//     field("SMTP Server";rec."SMTP Server")
//     {
        
//                 ToolTipML=ENU='Specifies the name of the SMTP server.',ESP='Especifica el nombre del servidor SMTP.';
//                 ApplicationArea=Basic,Suite;
                
//                             ;trigger OnValidate()    BEGIN
//                              SetCanSendTestMail;
//                              CurrPage.UPDATE;
//                            END;


//     }
//     field("SMTP Server Port";rec."SMTP Server Port")
//     {
        
//                 ToolTipML=ENU='Specifies the port of the SMTP server. The default setting is 25.',ESP='Especifica el puerto del servidor SMTP. La configuraci�n predeterminada es 25.';
//                 ApplicationArea=Basic,Suite;
//                 // DecimalPlaces=0:0;
//                 NotBlank=true;
//                 // Numeric=true;
//                 MinValue=1;
                
//                             ;trigger OnValidate()    BEGIN
//                              SetCanSendTestMail;
//                            END;


//     }
//     field("Authentication";rec."Authentication")
//     {
        
//                 ToolTipML=ENU='Specifies the type of authentication that the SMTP mail server uses.',ESP='Especifica el tipo de autenticaci�n que utiliza el servidor de correo SMTP.';
//                 ApplicationArea=Basic,Suite;
                
//                             ;trigger OnValidate()    BEGIN
//                              AuthenticationOnAfterValidate;
//                            END;


//     }
//     field("User ID";rec."User ID")
//     {
        
//                 ToolTipML=ENU='Specifies the ID of the user who posted the entry, to be used, for example, in the change log.',ESP='Especifica el identificador del usuario que registr� el movimiento, que se usar�, por ejemplo, en el registro de cambios.';
//                 ApplicationArea=Basic,Suite;
//                 Editable=UserIDEditable ;
//     }
//     field("Password";Password)
//     {
        
//                 ExtendedDatatype=Masked;
//                 CaptionML=ENU='Password',ESP='Contrase�a';
//                 ToolTipML=ENU='Specifies the password of the SMTP server.',ESP='Especifica la contrase�a del servidor SMTP.';
//                 ApplicationArea=Basic,Suite;
//                 Editable=PasswordEditable;
                
//                             ;trigger OnValidate()    BEGIN
//                              rec.SetPassword(Password);
//                              COMMIT;
//                            END;


//     }
//     field("Secure Connection";rec."Secure Connection")
//     {
        
//                 ToolTipML=ENU='Specifies if your SMTP mail server setup requires a secure connection that uses a cryptography or security protocol, such as secure socket layers (SSL). Clear the check box if you do not want to enable this security setting.',ESP='Especifica si la configuraci�n del servidor de correo SMTP necesita una conexi�n segura que use criptograf�a o un protocolo de seguridad, por ejemplo, capa de sockets seguros (SSL). Desactive la casilla si no desea habilitar esta configuraci�n de seguridad.';
//                 ApplicationArea=Basic,Suite;
//     }
//     field("Allow Sender Substitution";rec."Allow Sender Substitution")
//     {
        
//                 CaptionML=ENU='Allow Sender Substitution',ESP='Permitir sustituci�n de remitentes';
//                 ToolTipML=ENU='Specifies that the SMTP server allows you to change sender name and email.',ESP='Especifica que el servidor SMTP le permite cambiar el nombre del remitente y el correo electr�nico.';
//                 ApplicationArea=Basic,Suite;
//     }

// }

// }
// area(FactBoxes)
// {
//     systempart(Links;Links)
//     {
        
//                 Visible=FALSE;
//     }
//     systempart(Notes;Notes)
//     {
        
//                 Visible=FALSE;
//     }

// }
// }actions
// {
// area(Processing)
// {

//     action("ApplyOffice365")
//     {
        
//                       CaptionML=ENU='Apply Office 365 Server Settings',ESP='Aplicar la configuraci�n del servidor de Office 365';
//                       ToolTipML=ENU='Apply the Office 365 server settings to this record.',ESP='Permite aplicar la configuraci�n del servidor de Office 365 a este registro.';
//                       ApplicationArea=Basic,Suite;
//                       Promoted=true;
//                       PromotedIsBig=true;
//                       Image=Setup;
//                       PromotedCategory=Process;
                      
//                                 trigger OnAction()    VAR
//                                  SMTPMail : Codeunit 50355;
//                                BEGIN
//                                  IF CurrPage.EDITABLE THEN BEGIN
//                                    IF NOT (rec."SMTP Server" = '') THEN
//                                      IF NOT DIALOG.CONFIRM(ConfirmApplyO365Qst) THEN
//                                        EXIT;
//                                    SMTPMail.ApplyOffice365Smtp(Rec);
//                                    AuthenticationOnAfterValidate;
//                                    SetCanSendTestMail;
//                                    CurrPage.UPDATE;
//                                  END
//                                END;


//     }
//     action("SendTestMail")
//     {
        
//                       CaptionML=//@@@='"Locked ""&"""',
//                                  ENU='&Test Email Setup',
//                                  ESP='&Configuraci�n de correo elect. de prueba';
//                       ToolTipML=ENU='Sends email to the email address that is specified in the SMTP Settings window.',ESP='Env�a un mensaje de correo a la direcci�n de correo electr�nico especificada en la ventana Configuraci�n de SMTP.';
//                       ApplicationArea=Basic,Suite;
//                       Promoted=true;
//                       Enabled=CanSendTestMail;
//                       PromotedIsBig=true;
//                       Image=SendMail;
//                       PromotedCategory=Process;
                      
                                
//     trigger OnAction()    BEGIN
//                                  CODEUNIT.RUN(CODEUNIT::"SMTP Test Mail 1");
//                                END;


//     }

// }
// }
//   trigger OnInit()    BEGIN
//              PasswordEditable := TRUE;
//              UserIDEditable := TRUE;
//            END;

// trigger OnOpenPage()    BEGIN
//                  Rec.RESET;
//                  IF NOT Rec.GET THEN BEGIN
//                    Rec.INIT;
//                    Rec.INSERT;
//                    rec.SetPassword('');
//                  END ELSE
//                    Password := '***';
//                  UserIDEditable := rec.Authentication = rec.Authentication::Basic;
//                  PasswordEditable := rec.Authentication = rec.Authentication::Basic;
//                  SetCanSendTestMail;
//                END;



//     var
//       Password : Text[250];
//       UserIDEditable : Boolean ;
//       PasswordEditable : Boolean ;
//       CanSendTestMail : Boolean;
//       ConfirmApplyO365Qst : TextConst ENU='Do you want to override the current data?',ESP='�Confirma que desea reemplazar los datos actuales?';

//     LOCAL procedure AuthenticationOnAfterValidate();
//     begin
//       UserIDEditable := rec.Authentication = rec.Authentication::Basic;
//       PasswordEditable := rec.Authentication = rec.Authentication::Basic;
//     end;

//     LOCAL procedure SetCanSendTestMail();
//     begin
//       CanSendTestMail := rec."SMTP Server" <> '';
//     end;

//     // begin//end
// }







