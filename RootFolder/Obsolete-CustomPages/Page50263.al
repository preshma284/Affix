page 50263 "Session List"
{
    CaptionML = ENU = 'Session List', ESP = 'Lista de sesiones';
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    LinksAllowed = false;
    SourceTable = 2000000110;
    PageType = List;
    RefreshOnActivate = true;
    PromotedActionCategoriesML = ENU = 'New,Process,Report,Session,SQL Trace,Events', ESP = 'Nuevo,Procesar,Informe,Sesi�n,Seguimiento SQL,Eventos';

    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("SessionIdText"; "SessionIdText")
                {

                    CaptionML = ENU = 'Session ID', ESP = 'Id. sesi�n';
                    ToolTipML = ENU = 'Specifies the session in the list.', ESP = 'Especifica la sesi�n en la lista.';
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                field("User ID"; rec."User ID")
                {

                    CaptionML = ENU = 'User ID', ESP = 'Id. usuario';
                    ToolTipML = ENU = 'Specifies the user name of the user who is logged on to the active session.', ESP = 'Especifica el nombre del usuario que ha iniciado sesi�n en la sesi�n activa.';
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                field("IsSQLTracing"; "IsSQLTracing")
                {

                    CaptionML = ENU = 'SQL Tracing', ESP = 'Seguimiento SQL';
                    ToolTipML = ENU = 'Specifies if SQL tracing is enabled.', ESP = 'Especifica si el seguimiento SQL est� habilitado.';
                    ApplicationArea = All;
                    Editable = IsRowSessionActive;

                    ; trigger OnValidate()
                    BEGIN
                        IsSQLTracing := DEBUGGER.ENABLESQLTRACE(rec."Session ID", IsSQLTracing);
                    END;


                }
                field("Client Type"; "ClientTypeText")
                {

                    CaptionML = ENU = 'Client Type', ESP = 'Tipo cliente';
                    ToolTipML = ENU = '"Specifies the client type on which the session event occurred, such as Web Service and Client Service . "', ESP = '"Especifica el tipo de cliente en que se ha producido el evento de sesi�n como servicio web y servicio cliente. "';
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                field("Login Datetime"; rec."Login Datetime")
                {

                    CaptionML = ENU = 'Login Date', ESP = 'Fecha conexi�n';
                    ToolTipML = ENU = 'Specifies the date and time that the session started on the Business Central Server instance.', ESP = 'Especifica la fecha y la hora en que se inici� la sesi�n en la instancia de Business Central Server.';
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                field("Server Computer Name"; rec."Server Computer Name")
                {

                    CaptionML = ENU = 'Server Computer Name', ESP = 'Nombre equipo servidor';
                    ToolTipML = ENU = 'Specifies the fully qualified domain name (FQDN) of the computer on which the Business Central Server instance runs.', ESP = 'Especifica el nombre de dominio completo (FQDN) del equipo en el que se ejecuta la instancia de Business Central Server.';
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                field("Server Instance Name"; rec."Server Instance Name")
                {

                    CaptionML = ENU = 'Server Instance Name', ESP = 'Nombre instancia servidor';
                    ToolTipML = ENU = 'Specifies the name of the Business Central Server instance to which the session is connected. The server instance name comes from the Session Event table.', ESP = 'Especifica el nombre de la instancia de Business Central Server a la que est� conectada la sesi�n. El nombre de la instancia del servidor proviene de la tabla Evento de sesi�n.';
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                field("IsDebugging"; "IsDebugging")
                {

                    CaptionML = ENU = 'Debugging', ESP = 'Depuraci�n';
                    ToolTipML = ENU = 'Specifies sessions that are being debugged.', ESP = 'Especifica las sesiones que se est�n depurando.';
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                field("IsDebugged"; "IsDebugged")
                {

                    CaptionML = ENU = 'Debugged', ESP = 'Depurado';
                    ToolTipML = ENU = 'Specifies debugged sessions.', ESP = 'Especifica las sesiones depuradas.';
                    ApplicationArea = All;
                    Editable = FALSE

  ;
                }

            }

        }
    }
    actions
    {
        area(Processing)
        {
            separator("separator1")
            {

            }
            group("Session")
            {

                CaptionML = ENU = 'Session', ESP = 'Sesi�n';
                action("Debug Selected Session")
                {

                    ShortCutKey = 'Shift+Ctrl+S';
                    CaptionML = ENU = 'Debug', ESP = 'Depurar';
                    ToolTipML = ENU = 'Debug the selected session', ESP = 'Depura la sesi�n seleccionada.';
                    ApplicationArea = All;
                    Promoted = true;
                    Enabled = CanDebugSelectedSession;
                    PromotedIsBig = true;
                    Image = Debug;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    BEGIN
                        DebuggerManagement.SetDebuggedSession(Rec);
                        DebuggerManagement.OpenDebuggerTaskPage;
                    END;


                }
                action("Debug Next Session")
                {

                    ShortCutKey = 'Shift+Ctrl+N';
                    CaptionML = ENU = 'Debug Next', ESP = 'Depurar siguiente';
                    ToolTipML = ENU = 'Debug the Rec.NEXT session that breaks code execution.', ESP = 'Depura la siguiente sesi�n que interrumpe la ejecuci�n del c�digo.';
                    ApplicationArea = All;
                    Promoted = true;
                    Enabled = CanDebugNextSession;
                    PromotedIsBig = true;
                    Image = DebugNext;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    VAR
                        DebuggedSessionTemp: Record 2000000110;
                    BEGIN
                        DebuggedSessionTemp."Session ID" := 0;
                        DebuggerManagement.SetDebuggedSession(DebuggedSessionTemp);
                        DebuggerManagement.OpenDebuggerTaskPage;
                    END;


                }

            }
            group("SQL Trace")
            {

                CaptionML = ENU = 'SQL Trace', ESP = 'Seguimiento SQL';
                action("Start Full SQL Tracing")
                {

                    CaptionML = ENU = 'Start Full SQL Tracing', ESP = 'Iniciar seguimiento SQL completo';
                    ToolTipML = ENU = 'Start SQL tracing.', ESP = 'Inicia el seguimiento SQL.';
                    ApplicationArea = All;
                    Promoted = true;
                    Enabled = NOT FullSQLTracingStarted;
                    Image = Continue;
                    PromotedCategory = Category5;

                    trigger OnAction()
                    BEGIN
                        DEBUGGER.ENABLESQLTRACE(0, TRUE);
                        FullSQLTracingStarted := TRUE;
                    END;


                }
                action("Stop Full SQL Tracing")
                {

                    CaptionML = ENU = 'Stop Full SQL Tracing', ESP = 'Detener seguimiento SQL completo';
                    ToolTipML = ENU = 'Stop the current SQL tracing.', ESP = 'Detiene el seguimiento SQL actual.';
                    ApplicationArea = All;
                    Promoted = true;
                    Enabled = FullSQLTracingStarted;
                    Image = Stop;
                    PromotedCategory = Category5;

                    trigger OnAction()
                    BEGIN
                        DEBUGGER.ENABLESQLTRACE(0, FALSE);
                        FullSQLTracingStarted := FALSE;
                    END;


                }

            }
            group("Event")
            {

                CaptionML = ENU = 'Event', ESP = 'Evento';
                action("Subscriptions")
                {

                    CaptionML = ENU = 'Subscriptions', ESP = 'Suscripciones';
                    ToolTipML = ENU = 'Show event subscriptions.', ESP = 'Permite mostrar las suscripciones a eventos.';
                    ApplicationArea = All;
                    RunObject = Page 9510;
                    Promoted = true;
                    Image = Event;
                    PromotedCategory = Category6;
                }

            }
            group("group11")
            {
                CaptionML = ENU = 'Event', ESP = 'Cerrar';
                action("action7")
                {
                    CaptionML = ENU = 'Subscriptions', ESP = 'Cerrar Sesion';
                    ToolTipML = ENU = 'Show event subscriptions.', ESP = 'Permite mostrar las suscripciones a eventos.';
                    ApplicationArea = All;
                    Promoted = true;
                    Image = Close;
                    PromotedCategory = Category7;


                    trigger OnAction()
                    BEGIN
                        IF NOT CONFIRM(txtQB000, TRUE) THEN
                            ERROR(txtQB001);
                        STOPSESSION(rec."Session ID");
                        MESSAGE(txtQB002);
                    END;


                }

            }

        }
    }
    trigger OnOpenPage()
    BEGIN
        Rec.FILTERGROUP(2);
        Rec.SETFILTER("Server Instance ID", '=%1', SERVICEINSTANCEID);
        Rec.SETFILTER("Session ID", '<>%1', SESSIONID);
        Rec.FILTERGROUP(0);

        FullSQLTracingStarted := DEBUGGER.ENABLESQLTRACE(0);
    END;

    trigger OnFindRecord(Which: Text): Boolean
    BEGIN
        CanDebugNextSession := NOT DEBUGGER.ISACTIVE;
        CanDebugSelectedSession := NOT DEBUGGER.ISATTACHED AND NOT Rec.ISEMPTY;

        // If the session list is empty, Rec.INSERT an empty row to carry the button state to the client
        IF NOT Rec.FIND(Which) THEN BEGIN
            Rec.INIT;
            rec."Session ID" := 0;
        END;

        EXIT(TRUE);
    END;

    trigger OnAfterGetRecord()
    BEGIN
        IsDebugging := DEBUGGER.ISACTIVE AND (rec."Session ID" = DEBUGGER.DEBUGGINGSESSIONID);
        IsDebugged := DEBUGGER.ISATTACHED AND (rec."Session ID" = DEBUGGER.DEBUGGEDSESSIONID);
        IsSQLTracing := DEBUGGER.ENABLESQLTRACE(rec."Session ID");
        IsRowSessionActive := ISSESSIONACTIVE(rec."Session ID");

        // If this is the empty row, clear the Session ID and Client Type
        IF rec."Session ID" = 0 THEN BEGIN
            SessionIdText := '';
            ClientTypeText := '';
        END ELSE BEGIN
            SessionIdText := FORMAT(rec."Session ID");
            ClientTypeText := FORMAT(rec."Client Type");
        END;
    END;



    var
        // DebuggerManagement: Codeunit 9500;
        DebuggerManagement: Codeunit "Debugger Management 1";
        CanDebugNextSession: Boolean;
        CanDebugSelectedSession: Boolean;
        FullSQLTracingStarted: Boolean;
        IsDebugging: Boolean;
        IsDebugged: Boolean;
        IsSQLTracing: Boolean;
        IsRowSessionActive: Boolean;
        SessionIdText: Text;
        ClientTypeText: Text;
        txtQB000: TextConst ESP = '�Desea cerrar la sesi�n seleccionada?';
        txtQB001: TextConst ESP = 'Operaci�n cancelada.';
        txtQB002: TextConst ESP = 'Sesi�n cerrada.';

    /*begin
    end.
  
*/
}







