page 7174496 "QuoFacturae Setup"
{
  ApplicationArea=All;

    CaptionML = ENU = 'Quofacturae setup', ESP = 'Configuraci�n de Quofacturae';
    InsertAllowed = false;
    DeleteAllowed = false;
    LinksAllowed = false;
    SourceTable = 7174368;
    PageType = Card;
    InstructionalTextML = ESP = 'hola';
    ShowFilter = false;

    layout
    {
        area(content)
        {
            group("General")
            {

                field("Enabled"; rec."Enabled")
                {

                }
                field("eMail"; rec."eMail")
                {

                }
                group("group11")
                {

                    CaptionML = ENU = 'Options', ESP = 'Opciones';
                    field("Generate Grouped"; rec."Generate Grouped")
                    {

                    }
                    field("WorkDescription in Lines"; rec."WorkDescription in Lines")
                    {

                    }
                    field("Send alwais period dates"; rec."Send alwais period dates")
                    {

                    }

                }

            }
            group("Certificate")
            {

                field("Certificate Installed"; "CertificateHasValue")
                {

                    CaptionML = ENU = 'Certificate Installed', ESP = 'Certificado Instalado';
                    ApplicationArea = All;
                    Editable = False;
                }
                field("Password"; rec."Password")
                {

                }

            }

        }
    }
    actions
    {
        area(Processing)
        {

            action("ImportCert")
            {

                CaptionML = ENU = 'Import certificate', ESP = 'Importar certificado';
                ToolTipML = ENU = 'Choose your digital certificate file, and import it. You will need it to send the SII document.', ESP = 'Elija el archivo de certificado digital e imp�rtelo. Tendr� que enviar el documento SII.';
                ApplicationArea = All;
                Image = UserCertificate;

                trigger OnAction()
                BEGIN
                    rec.ImportCertificate;
                END;


            }
            action("DeleteCert")
            {

                CaptionML = ENU = 'Delete certificate', ESP = 'Eliminar certificado';
                ToolTipML = ENU = 'Delete your digital certificate file. SII will be disabled.', ESP = 'Borre su archivo de certificado digital. Se deshabilitar� SII.';
                ApplicationArea = All;
                Image = Delete;

                trigger OnAction()
                BEGIN
                    rec.DeleteCertificate;
                END;


            }

        }
        area(Navigation)
        {

            action("ShowRequestHistory")
            {

                CaptionML = ENU = 'Show Factura-e History', ESP = 'Mostrar historial Factura-e';
                ToolTipML = ENU = 'Show history of all Facturae communication.', ESP = 'Muestra el historial de todas las comunicaciones Facturae.';
                ApplicationArea = All;
                RunObject = Page 7174497;
                Image = History;
            }
            action("action4")
            {
                CaptionML = ENU = 'Endpoints', ESP = 'Puntos de entrada';
                RunObject = Page 7174500;
                Image = SetupLines;
            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(ImportCert_Promoted; ImportCert)
                {
                }
                actionref(DeleteCert_Promoted; DeleteCert)
                {
                }
                actionref(action4_Promoted; action4)
                {
                }
            }
        }
    }

    trigger OnOpenPage()
    BEGIN
        Rec.RESET;
        IF NOT Rec.GET THEN BEGIN
            Rec.INIT;
            Rec.INSERT;
        END;
    END;

    trigger OnAfterGetRecord()
    BEGIN
        CertificateHasValue := rec.Certificate.HASVALUE;
    END;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    BEGIN
        IF rec.IsEnabled AND (CloseAction = ACTION::OK) THEN
            rec.ValidateCertificatePassword;
    END;



    var
        CertificateHasValue: Boolean;

    /*begin
    end.
  
*/
}









