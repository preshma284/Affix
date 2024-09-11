Codeunit 51273 "Debugger Management 1"
{
  
  
    SingleInstance=true;
    trigger OnRun()
VAR
            Uri : DotNet Uri;
            UriPartial : DotNet UriPartial;
            UrlString : Text;
          BEGIN
            // Generates a URL like dynamicsnav://host:port/instance//debug<?tenant=tenantId>
            UrlString := GETURL(CLIENTTYPE::Windows);
            Uri := Uri.Uri(UrlString);
            UrlString := Uri.GetLeftPart(UriPartial.Path) + DebuggerUrlTok + Uri.Query;

            HYPERLINK(UrlString);
          END;
    VAR
      ClientAddin : Record 2000000069;
      DebuggedSession : Record 2000000110;
      // DebuggerTaskPage : Page 9500;
      Text000Err : TextConst ENU='Cannot process debugger break. The debugger is not active.',ESP='No se puede procesar el salto de depurador. El depurador no est� activo.';
      LastErrorMesssageIsNew : Boolean;
      LastErrorMessage : Text;
      CodeViewerControlRegistered : Boolean;
      ActionState : Option "None","RunningCodeAction","CodeTrackingAction","BreakAfterRunningCodeAction","BreakAfterCodeTrackingAction";
      DebuggerUrlTok : TextConst ENU='debug',ESP='debug';
      ClientAddinDescriptionTxt : TextConst ENU='%1 Code Viewer control add-in',ESP='Complemento de control del visor de c�digo de %1';

    PROCEDURE OpenDebuggerTaskPage();
    BEGIN
      IF NOT CodeViewerControlRegistered THEN BEGIN
        ClientAddin.INIT;
        ClientAddin."Add-in Name" := 'Microsoft.Dynamics.Nav.Client.CodeViewer';
        ClientAddin."Public Key Token" := '31bf3856ad364e35';
        ClientAddin.Description := STRSUBSTNO(ClientAddinDescriptionTxt,PRODUCTNAME.FULL);
        IF ClientAddin.INSERT THEN;
        CodeViewerControlRegistered := TRUE;
      END;

      // IF NOT DEBUGGER.ISACTIVE THEN
      //   DebuggerTaskPage.RUN
      // ELSE
      //   DebuggerTaskPage.CLOSE;
    END;

    [EventSubscriber(ObjectType::Codeunit, 2000000009, OnDebuggerBreak, '', true, true)]
    LOCAL PROCEDURE ProcessOnDebuggerBreak(ErrorMessage : Text);
    BEGIN
      LastErrorMessage := ErrorMessage;
      LastErrorMesssageIsNew := TRUE;

      IF DEBUGGER.ISACTIVE THEN BEGIN
        IF ActionState = ActionState::CodeTrackingAction THEN
          ActionState := ActionState::BreakAfterCodeTrackingAction
        ELSE
          IF ActionState = ActionState::RunningCodeAction THEN
            ActionState := ActionState::BreakAfterRunningCodeAction;

        RefreshDebuggerTaskPage;
      END ELSE
        ERROR(Text000Err);
    END;

    //[External]
    PROCEDURE GetLastErrorMessage(VAR IsNew : Boolean) Message : Text;
    BEGIN
      Message := LastErrorMessage;
      IsNew := LastErrorMesssageIsNew;
      LastErrorMesssageIsNew := FALSE;
    END;

    //[External]
    PROCEDURE RefreshDebuggerTaskPage();
    BEGIN
      // DebuggerTaskPage.ACTIVATE(TRUE);
    END;

    //[External]
    PROCEDURE AddWatch(Path : Text[1024];Refresh : Boolean);
    VAR
      // DebuggerWatch : Record 2000000104;
    BEGIN
      // IF Path <> '' THEN BEGIN
      //   DebuggerWatch.SETRANGE(Path,Path);
      //   IF DebuggerWatch.ISEMPTY THEN BEGIN
      //     DebuggerWatch.INIT;
      //     DebuggerWatch.Path := Path;
      //     DebuggerWatch.INSERT(TRUE);

      //     IF Refresh THEN
      //       RefreshDebuggerTaskPage;
      //   END;
      // END;
    END;

    LOCAL PROCEDURE LastIndexOf(Path : Text[1024];Character : Char;Index : Integer) : Integer;
    VAR
      CharPos : Integer;
    BEGIN
      IF Path = '' THEN
        EXIT(0);

      IF Index <= 0 THEN
        EXIT(0);

      IF Index > STRLEN(Path) THEN
        Index := STRLEN(Path);

      CharPos := Index;

      IF Path[CharPos] = Character THEN
        EXIT(CharPos);
      IF CharPos = 1 THEN
        EXIT(0);

      REPEAT
        CharPos := CharPos - 1
      UNTIL (CharPos = 1) OR (Path[CharPos] = Character);

      IF Path[CharPos] = Character THEN
        EXIT(CharPos);

      EXIT(0);
    END;

    //[External]
    PROCEDURE RemoveQuotes(Variable : Text[1024]) VarWithoutQuotes : Text[1024];
    BEGIN
      IF Variable = '' THEN
        EXIT(Variable);

      IF (STRLEN(Variable) >= 2) AND (Variable[1] = '"') AND (Variable[STRLEN(Variable)] = '"') THEN
        VarWithoutQuotes := COPYSTR(Variable,2,STRLEN(Variable) - 2)
      ELSE
        VarWithoutQuotes := Variable;
    END;

    LOCAL PROCEDURE IsInRecordContext(Path : Text[1024];Record : Text) : Boolean;
    VAR
      Index : Integer;
      Position : Integer;
      CurrentContext : Text[250];
    BEGIN
      IF Path = '' THEN
        EXIT(FALSE);

      IF Record = '' THEN // Empty record name means all paths match
        EXIT(TRUE);

      Index := STRLEN(Path);

      IF Path[Index] = '"' THEN BEGIN
        Position := LastIndexOf(Path,'"',Index - 1);
        IF Position <= 1 THEN
          EXIT(FALSE);
        IF Path[Position - 1] <> '.' THEN
          EXIT(FALSE);
        Index := Position - 1; // set index on first '.' from the end
      END ELSE BEGIN
        Position := LastIndexOf(Path,'.',Index);
        IF Position <= 1 THEN
          EXIT(FALSE);
        Index := Position; // set index on first '.' from the end
      END;

      Index := Index - 1;
      Position := LastIndexOf(Path,'.',Index);

      IF Position <= 1 THEN  // second '.' not found - context not found
        EXIT(FALSE);

      Index := Position - 1;
      Position := LastIndexOf(Path,'.',Index);

      CurrentContext := COPYSTR(Path,Position + 1,Index - Position);
      EXIT(LOWERCASE(CurrentContext) = LOWERCASE(Record));
    END;

    //[External]
    PROCEDURE ShouldBeInTooltip(Path : Text[1024];LeftContext : Text) : Boolean;
    BEGIN
      EXIT((STRPOS(Path,'."<Globals>"') = 0) AND (STRPOS(Path,'.Keys.') = 0) AND
        ((STRPOS(Path,'."<Global Text Constants>".') = 0) OR (STRPOS(Path,'"<Globals>"."<Global Text Constants>".') > 0)) AND
        IsInRecordContext(Path,LeftContext));
    END;

    //[External]
    PROCEDURE GetDebuggedSession(VAR DebuggedSessionRec : Record 2000000110);
    BEGIN
      DebuggedSessionRec := DebuggedSession;
    END;

    //[External]
    PROCEDURE SetDebuggedSession(DebuggedSessionRec : Record 2000000110);
    BEGIN
      DebuggedSession := DebuggedSessionRec;
    END;

    //[External]
    PROCEDURE SetRunningCodeAction();
    BEGIN
      ActionState := ActionState::RunningCodeAction;
    END;

    //[External]
    PROCEDURE SetCodeTrackingAction();
    BEGIN
      ActionState := ActionState::CodeTrackingAction;
    END;

    //[External]
    PROCEDURE IsBreakAfterRunningCodeAction() : Boolean;
    BEGIN
      EXIT(ActionState = ActionState::BreakAfterRunningCodeAction);
    END;

    //[External]
    PROCEDURE IsBreakAfterCodeTrackingAction() : Boolean;
    BEGIN
      EXIT(ActionState = ActionState::BreakAfterCodeTrackingAction);
    END;

    //[External]
    PROCEDURE ResetActionState();
    BEGIN
      ActionState := ActionState::None;
    END;

    [EventSubscriber(ObjectType::Codeunit, 2000000006, OpenDebugger, '', true, true)]
    LOCAL PROCEDURE OpenDebugger();
    BEGIN
      PAGE.RUN(PAGE::"Session List");
    END;

    /* /*BEGIN
END.*/
}







