Codeunit 7207354 "QB - Approval - Management"
{


    Permissions = TableData 454 = rimd;
    trigger OnRun()
    BEGIN
    END;

    VAR
        "------------------------- Proyectos": Integer;
        ApJobs: Codeunit 7206915;
        ApComparativeQuote: Codeunit 7206916;
        ApPurchaseOrder: Codeunit 7206912;
        ApPurchaseInvoice: Codeunit 7206913;
        ApMeasurements: Codeunit 7206914;
        ApExpenseNotes: Codeunit 7206919;
        ApWorksheet: Codeunit 7206920;
        ApTransBetweenJobs: Codeunit 7206921;
        ApPaymentOrders: Codeunit 7206927;
        ApPurchaseCrMemo: Codeunit 7206928;
        ApBudget: Codeunit 7206929;
        ApPrepayment: Codeunit 7206931;
        "--------------------------- Departamentos": Integer;
        ApCarteraDoc: Codeunit 7206917;
        "--------------------------- Presupuestos": Integer;
        AplBudgets: Codeunit 7206929;

    LOCAL PROCEDURE "-----------------------------------------  Eventos para el mail de aprobaci¢n"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Codeunit, 1521, OnReleaseDocument, '', true, true)]
    LOCAL PROCEDURE CU1521_OnReleaseDocument(RecRef: RecordRef; VAR Handled: Boolean);
    BEGIN
        //------------------------------------------------------------------------------------------------------------------------
        //JAV 26/04/22: - QB 1.10.37 Enviar un mail de documento aprobado al que origina la aprobaci�n
        //------------------------------------------------------------------------------------------------------------------------
        SendMailForApproved(RecRef);
    END;

    [EventSubscriber(ObjectType::Codeunit, 415, OnAfterReleasePurchaseDoc, '', true, true)]
    LOCAL PROCEDURE CU415_OnAfterReleasePurchaseDoc(VAR PurchaseHeader: Record 38; PreviewMode: Boolean; VAR LinesWereModified: Boolean);
    VAR
        RecRef: RecordRef;
    BEGIN
        //------------------------------------------------------------------------------------------------------------------------
        //JAV 26/04/22: - QB 1.10.37 Enviar un mail de documento aprobado de compra al que origina la aprobaci�n
        //------------------------------------------------------------------------------------------------------------------------
        RecRef.GET(PurchaseHeader.RECORDID);
        SendMailForApproved(RecRef);
    END;

    [EventSubscriber(ObjectType::Codeunit, 414, OnAfterReleaseSalesDoc, '', true, true)]
    LOCAL PROCEDURE CU414_OnAfterReleaseSalesDoc(VAR SalesHeader: Record 36; PreviewMode: Boolean; VAR LinesWereModified: Boolean);
    VAR
        RecRef: RecordRef;
    BEGIN
        //------------------------------------------------------------------------------------------------------------------------
        //JAV 26/04/22: - QB 1.10.37 Enviar un mail de documento aprobado de venta al que origina la aprobaci�n
        //------------------------------------------------------------------------------------------------------------------------
        RecRef.GET(SalesHeader.RECORDID);
        SendMailForApproved(RecRef);
    END;

    LOCAL PROCEDURE SendMailForApproved(RecRef: RecordRef);
    VAR
        NotificationEntry: Record 1511;
        ApprovalEntry: Record 454;
        QBApprovalsSetup: Record 7206994;
        DocNumber: Code[20];
    BEGIN
        //------------------------------------------------------------------------------------------------------------------------
        //JAV 26/04/22: - QB 1.10.37 Enviar un mail de documento aprobado al que origina la aprobaci�n
        //------------------------------------------------------------------------------------------------------------------------
        IF NOT QBApprovalsSetup.GET THEN
            EXIT;

        IF (NOT QBApprovalsSetup."Send Mail For Approved") THEN
            EXIT;

        OnGetDocNumber(RecRef, DocNumber);

        ApprovalEntry.RESET;
        ApprovalEntry.SETRANGE("Table ID", RecRef.NUMBER);
        ApprovalEntry.SETRANGE("Document No.", DocNumber);
        IF (NOT ApprovalEntry.FINDLAST) THEN
            ApprovalEntry.INIT;

        NotificationEntry.INIT;
        NotificationEntry.Type := NotificationEntry.Type::Approval;
        NotificationEntry."Recipient User ID" := ApprovalEntry."Sender ID";
        NotificationEntry."Triggered By Record" := ApprovalEntry.RECORDID;
        NotificationEntry.INSERT(TRUE);
    END;

    [IntegrationEvent(true, false)]
    PROCEDURE OnGetDocNumber(RecRef: RecordRef; VAR DocNumber: Code[20]);
    BEGIN
        //------------------------------------------------------------------------------------------------------------------------
        //JAV 26/04/22: - QB 1.10.37 Lanza un evento que retorna el nro de un documento a partir de su RecordRef
        //------------------------------------------------------------------------------------------------------------------------
    END;

    LOCAL PROCEDURE "----------------------------------------- Eventos Espec¡ficos que se lanzan"();
    BEGIN
    END;

    [IntegrationEvent(true, false)]
    PROCEDURE OnWitHoldingRequest(VAR ApprovalEntry: Record 454);
    BEGIN
    END;

    [IntegrationEvent(true, false)]
    PROCEDURE OnAfterApproveRequest(VAR ApprovalEntry: Record 454);
    BEGIN
    END;

    [IntegrationEvent(true, false)]
    PROCEDURE GetData(recRef: RecordRef; VAR pJob: Code[20]; VAR pBudgetItem: Code[20]; VAR pDepartment: Code[20]; VAR pCircuit: Code[20]; VAR pDocumentType: Option; VAR pAmount: Decimal; VAR pAmountDL: Decimal);
    BEGIN
        //JAV 25/06/22: - QB 1.10.54 A�adirmos el departamento al obtener datos para poder usar aprobaci�n por departamentos
    END;

    [IntegrationEvent(true, false)]
    PROCEDURE MountFlowCircuit();
    BEGIN
        //------------------------------------------------------------------------------------------------------------------------
        //JAV 21/04/22: - QB 1.10.36 Cambio en la forma de montar los flujos, dejar que cada CU monte el suyo propio usando un evento general
        //------------------------------------------------------------------------------------------------------------------------
    END;

    LOCAL PROCEDURE "----------------------------------------- Eventos que se capturan"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 458, OnBeforeInsertEvent, '', true, true)]
    LOCAL PROCEDURE T458_OnBeforeInsertEvent(VAR Rec: Record 458; RunTrigger: Boolean);
    VAR
        OverdueApprovalEntry: Record 458;
    BEGIN
        //------------------------------------------------------------------------------------------------------------------------
        //JAV 10/04/22: - QB 1.10.34 Evitar error de registro duplicado al existir varia entradas con el mismo n�mero en "Secuence No."
        //------------------------------------------------------------------------------------------------------------------------

        REPEAT
            OverdueApprovalEntry.RESET;
            OverdueApprovalEntry.SETRANGE("Table ID", Rec."Table ID");
            OverdueApprovalEntry.SETRANGE("Document Type", Rec."Document Type");
            OverdueApprovalEntry.SETRANGE("Document No.", Rec."Document No.");
            OverdueApprovalEntry.SETRANGE("Sequence No.", Rec."Sequence No.");
            OverdueApprovalEntry.SETRANGE("Sent Date", Rec."Sent Date");
            OverdueApprovalEntry.SETRANGE("Sent Time", Rec."Sent Time");
            OverdueApprovalEntry.SETRANGE("Record ID to Approve", Rec."Record ID to Approve");
            IF (NOT OverdueApprovalEntry.ISEMPTY) THEN
                Rec."Sent Time" += OverdueApprovalEntry.COUNT;  //Cambiamos la hora, al ser d�cimas de seguindos no influye
        UNTIL (OverdueApprovalEntry.ISEMPTY);
    END;

    [EventSubscriber(ObjectType::Codeunit, 1520, OnAddWorkflowEventsToLibrary, '', true, true)]
    PROCEDURE CU1520_OnAddWorkflowEventsToLibrary();
    VAR
        WorkflowEventHandling: Codeunit 1520;
        Text001: TextConst ENU = 'It was requested to approve a doc. cartera', ESP = 'Se solicit� la aprobaci�n de un doc. cartera';
        WorkflowResponseHandling: Codeunit 1521;
    BEGIN
        //------------------------------------------------------------------------------------------------------------------------
        //A�ade eventos a las cadenas de respuestas a los pasos
        //------------------------------------------------------------------------------------------------------------------------
        WorkflowResponseHandling.AddResponseToLibrary(GetWorkflowResponseName, 0, 'QB - Solicitar aprobaci�n seg�n responsables del proyecto', 'GROUP 5');
    END;

    [EventSubscriber(ObjectType::Codeunit, 1521, OnExecuteWorkflowResponse, '', true, true)]
    PROCEDURE CU1521_OnExecuteWorkflowResponse(VAR ResponseExecuted: Boolean; Variant: Variant; xVariant: Variant; ResponseWorkflowStepInstance: Record 1504);
    VAR
        QBApprovalsSetup: Record 7206994;
        UserSetup: Record 91;
        QBJobResponsible: Record 7206992;
        ApprovalEntry: Record 454;
        ApprovalEntryArgument: Record 454;
        WorkflowStepArgument: Record 1523;
        ApprovalsMgmt: Codeunit 1535;
        ApprovalsMgmt2: Codeunit 50015;
        RecRef: RecordRef;
        FRef: FieldRef;
        Level: Integer;
        LastLevel: Integer;
        NewLevel: Integer;
        Suficiente: Boolean;
        Insertar: Boolean;
        Salir: Boolean;
        AuxCode: Code[10];
        ApproverID: Code[50];
        JobNo: Code[20];
        BudgetItem: Code[20];
        Department: Code[20];
        DocumentType: Option;
        Circuit: Code[20];
        Amount: Decimal;
        AmountDL: Decimal;
        QBApprovalCircuitHeader: Record 7206986;
        QBApprovalCircuitLines: Record 7206987;
        tmpQBApprovalCircuitLines1: Record 7206987 TEMPORARY;
        tmpQBApprovalCircuitLines2: Record 7206987 TEMPORARY;
        tmpLevel: Integer;
        txtAux: Text;
    BEGIN
        //------------------------------------------------------------------------------------------------------------------------
        //Monto la tabla de usuarios del flujo
        //------------------------------------------------------------------------------------------------------------------------
        IF (ResponseWorkflowStepInstance."Function Name" <> GetWorkflowResponseName) THEN
            EXIT;

        //Buscamos los datos necesarios para los c�lculos
        RecRef.GETTABLE(Variant);
        GetData(RecRef, JobNo, BudgetItem, Department, Circuit, DocumentType, Amount, AmountDL);

        //JAV 21/03/22: - QB 1.10.27 Leer la cabecera de la tabla de circuitos de aprobaci�n, debe existir
        QBApprovalCircuitHeader.GET(Circuit);

        //Monto una tabla temporal con el circuito de aprobaci�n
        tmpQBApprovalCircuitLines1.RESET;
        tmpQBApprovalCircuitLines1.DELETEALL;

        //JAV 04/04/22: - QB 1.10.31 Se monta la tabla inicial seg�n el tipo de aprobaci�n definido
        tmpLevel := -1; //Aqu� ir� el nivel del usuario que ha solicitado la aprobaci�n si est� en la cadena de aprobaci�n
        AuxCode := 'A000';
        CASE QBApprovalCircuitHeader."Approval By" OF
            //Aprobaci�n por proyecto. Inserto todos los usuarios necesarios del circuito de aprobaci�n, busco en el proyecto todos los que tengan el mismo cargo y los voy insertando
            //JAV 25/06/22: - QB 1.10.54 Se incluye la aprobaci�n por departamentos en la de proyectos pues son compatibles
            QBApprovalCircuitHeader."Approval By"::Job, QBApprovalCircuitHeader."Approval By"::Department:
                BEGIN
                    QBApprovalCircuitLines.RESET;
                    QBApprovalCircuitLines.SETCURRENTKEY("Circuit Code", "Approval Level"); //Ordenado por nivel de aprobaci�n
                    QBApprovalCircuitLines.SETRANGE("Circuit Code", Circuit);
                    QBApprovalCircuitLines.SETFILTER(Position, '<>%1', '');
                    IF (QBApprovalCircuitLines.FINDSET) THEN
                        REPEAT
                            //Busco en el proyecto/departamento todos los que tengan el mismo cargo, los inserto todos con firma indiferente
                            QBJobResponsible.RESET;
                            QBJobResponsible.SETRANGE(Type, QBApprovalCircuitHeader."Approval By");  //JAV 21/03/22: - QB 1.10.27 No filtraba por el tipo proyecto/departamento
                            QBJobResponsible.SETRANGE("Table Code", JobNo);
                            QBJobResponsible.SETRANGE(Position, QBApprovalCircuitLines.Position);
                            QBJobResponsible.SETRANGE("No in Approvals", FALSE);  //JAV 22/04/22: - QB 1.10.36 Se filtran los que no intervienen en aprobaciones
                            IF NOT QBJobResponsible.FINDSET(FALSE) THEN BEGIN
                                IF (NOT QBApprovalCircuitLines.Optional) THEN
                                    ERROR('No ha definido el cargo obligatorio %1 en el proyecto %2', tmpQBApprovalCircuitLines1.Position, JobNo);
                            END ELSE BEGIN
                                REPEAT
                                    tmpQBApprovalCircuitLines1 := QBApprovalCircuitLines;
                                    tmpQBApprovalCircuitLines1."tmp User" := QBJobResponsible."User ID";
                                    IF (NOT QBApprovalCircuitLines.Optional) AND (tmpQBApprovalCircuitLines1."tmp User" = '') THEN
                                        ERROR('No ha definido usario para el cargo %1 en el proyecto %2', tmpQBApprovalCircuitLines1.Position, JobNo);

                                    IF (tmpQBApprovalCircuitLines1."tmp User" <> '') THEN BEGIN
                                        AuxCode := INCSTR(AuxCode);
                                        tmpQBApprovalCircuitLines1."Line Code" := AuxCode;
                                        tmpQBApprovalCircuitLines1.INSERT;
                                    END;
                                UNTIL QBJobResponsible.NEXT = 0;

                                //Me guardo el nivel del usuario que lanza la solicitud si est� en la cadena, todos los anteriores no deben entrar en la aprobaci�n por ser de menor nivel.
                                //Como puede estar varias veces guardo el m�ximo nivel en que me lo he encontrado
                                IF (tmpQBApprovalCircuitLines1."tmp User" = USERID) AND (tmpLevel < tmpQBApprovalCircuitLines1."Approval Level") THEN
                                    tmpLevel := tmpQBApprovalCircuitLines1."Approval Level";
                            END;
                        UNTIL (QBApprovalCircuitLines.NEXT = 0);
                END;

            //JAV 04/04/22: - QB 1.10.31 Aprobaci�n por usuarios. Inserto todas las l�neas con usuario
            QBApprovalCircuitHeader."Approval By"::User:
                BEGIN
                    //Inserto todos los usarios del circuito de aprobaci�n, que est�n definidos en las l�neas
                    QBApprovalCircuitLines.RESET;
                    QBApprovalCircuitLines.SETCURRENTKEY("Circuit Code", "Approval Level"); //Ordenado por nivel de aprobaci�n
                    QBApprovalCircuitLines.SETRANGE("Circuit Code", Circuit);
                    IF (QBApprovalCircuitLines.FINDSET) THEN
                        REPEAT
                            IF (QBApprovalCircuitLines.User = '') AND (NOT QBApprovalCircuitLines.Optional) THEN
                                ERROR('No ha definido el usuario obligatorio %1 en el circuito %2', QBApprovalCircuitLines."Line Code", Circuit)
                            ELSE BEGIN
                                tmpQBApprovalCircuitLines1 := QBApprovalCircuitLines;
                                tmpQBApprovalCircuitLines1."tmp User" := QBApprovalCircuitLines.User;

                                AuxCode := INCSTR(AuxCode);
                                tmpQBApprovalCircuitLines1."Line Code" := AuxCode;
                                tmpQBApprovalCircuitLines1.INSERT;

                                //Me guardo el nivel del usuario que lanza la solicitud si est� en la cadena, todos los anteriores no deben entrar en la aprobaci�n por ser de menor nivel.
                                //Como puede estar varias veces guardo el m�ximo nivel en que me lo he encontrado
                                IF (tmpQBApprovalCircuitLines1."tmp User" = USERID) AND (tmpLevel < tmpQBApprovalCircuitLines1."Approval Level") THEN
                                    tmpLevel := tmpQBApprovalCircuitLines1."Approval Level";
                            END;
                        UNTIL (QBApprovalCircuitLines.NEXT = 0);
                END;

        END;

        //Elimino los usuarios de nivel inferior al solicitante, salvo el propio solicitante si est� en la cadena para poder disponer del importe de aprobaci�n
        IF (tmpLevel <> -1) THEN BEGIN
            tmpQBApprovalCircuitLines1.RESET;
            tmpQBApprovalCircuitLines1.SETRANGE("Approval Level", 0, tmpLevel);
            tmpQBApprovalCircuitLines1.SETFILTER("tmp User", '<>%1', USERID);
            tmpQBApprovalCircuitLines1.DELETEALL;
        END;

        //Monto una segunda tabla temporal con el circuito de aprobaci�n definitivo para poder buscar en ella
        tmpQBApprovalCircuitLines2.RESET;
        tmpQBApprovalCircuitLines2.DELETEALL;

        tmpQBApprovalCircuitLines1.RESET;
        IF (tmpQBApprovalCircuitLines1.FINDSET) THEN
            REPEAT
                tmpQBApprovalCircuitLines2 := tmpQBApprovalCircuitLines1;
                tmpQBApprovalCircuitLines2.INSERT;
            UNTIL (tmpQBApprovalCircuitLines1.NEXT = 0);

        //Si la aprobaci�n va por usuarios en lugar de por cargos, elimino los usuarios duplicados dej�ndo solo el de m�ximo nivel
        //JAV 04/04/22: - QB 1.10.31 Se cambian campos de aprobaciones a la nueva tabla de configuraci�n de aprobaciones
        IF NOT QBApprovalsSetup.GET THEN
            QBApprovalsSetup.INIT;

        IF (QBApprovalsSetup."User Approve" = QBApprovalsSetup."User Approve"::All) THEN BEGIN

            tmpQBApprovalCircuitLines1.RESET;
            tmpQBApprovalCircuitLines1.SETCURRENTKEY("Circuit Code", "Approval Level");
            IF (tmpQBApprovalCircuitLines1.FINDSET) THEN
                REPEAT
                    tmpQBApprovalCircuitLines2.RESET;
                    tmpQBApprovalCircuitLines2.SETRANGE("tmp User", tmpQBApprovalCircuitLines1."tmp User");
                    IF (tmpQBApprovalCircuitLines2.COUNT > 1) THEN BEGIN
                        tmpQBApprovalCircuitLines1.DELETE;
                        tmpQBApprovalCircuitLines2.GET(tmpQBApprovalCircuitLines1."Circuit Code", tmpQBApprovalCircuitLines1."Line Code");
                        tmpQBApprovalCircuitLines2.DELETE;
                    END;
                UNTIL (tmpQBApprovalCircuitLines1.NEXT = 0);
        END;

        //A�ado primero siempre al usuario que lo ha solicitado como el usuario que lanza la aprobaci�n
        ApprovalsMgmt2.CreateApprovalEntry(RecRef, ResponseWorkflowStepInstance, 0, USERID, '', ApprovalEntryArgument,
                                          GetChargeInCircuit(tmpQBApprovalCircuitLines2, USERID));  //El que lo lanza siempre a nivel cero
        Suficiente := GetSufficientApprover(tmpQBApprovalCircuitLines2, USERID, AmountDL); //Busco si el usuario tiene suficiente importe para aprobar esto

        //Si no hay suficiente nivel de aprobaci�n, monto un bucle con los usuarios de la cadena de aprobaci�n
        IF (NOT Suficiente) THEN BEGIN
            NewLevel := 0;  //Aqu� ir� el contador del nuevo nivel correlativo
            LastLevel := -1; //Aqu� el nivel del �ltimo registro procesado, como el primero puede estar a nivel 0 lo marco negativo
            Salir := FALSE;
            tmpQBApprovalCircuitLines1.RESET;
            tmpQBApprovalCircuitLines1.SETCURRENTKEY("Circuit Code", "Approval Level");
            tmpQBApprovalCircuitLines1.SETFILTER("tmp User", '<>%1', USERID);  //El propio usuario ya se ha incluido como primer aprobador
            IF (tmpQBApprovalCircuitLines1.FINDSET(FALSE)) THEN
                REPEAT
                    IF (LastLevel <> tmpQBApprovalCircuitLines1."Approval Level") THEN  //Si cambia el nivel del usuario aumento el contador correlativo de niveles
                        NewLevel += 1;

                    Level := GetLevelInCircuit(tmpQBApprovalCircuitLines2, tmpQBApprovalCircuitLines1."tmp User", tmpQBApprovalCircuitLines1.Position);
                    Salir := ((Suficiente) AND (LastLevel < Level)); //Salgo si tiene suficiente nivel de aprobaci�n y hemos cambiado de nivel, as� pongo todos los del mismo nivel siempre

                    IF NOT Salir THEN BEGIN
                        Suficiente := (tmpQBApprovalCircuitLines1."Approval Limit" >= AmountDL) OR (tmpQBApprovalCircuitLines1."Approval Unlim.");
                        LastLevel := Level;

                        //JAV 24/12/20 - QB 1.07.17 Miro si hay que substituir autom�ticamente, si no el aprobador es el propio usuario
                        // ApproverID := UserSetup.GetSubstitute(tmpQBApprovalCircuitLines1."tmp User");

                        //Creo el registro del aprobador con su posible substituto
                        ApprovalsMgmt2.CreateApprovalEntry(RecRef, ResponseWorkflowStepInstance, NewLevel, ApproverID, tmpQBApprovalCircuitLines1."tmp User",
                                                          ApprovalEntryArgument, tmpQBApprovalCircuitLines1.Position);
                    END;
                UNTIL (Salir) OR (tmpQBApprovalCircuitLines1.NEXT = 0);
        END;

        //JAV 03/11/22: - QB 1.12.12 Eliminamos el c�digo que a�ade datos al registro de la aprobaci�n, ya que no sirve realmente para nada, el proceso que crea los registros ya lo a�ade
        // //Se informan los campos propios de QB en el registro de aprobaci�n, al no existir un evento tengo que hacer en todos los registros, por eso filtro que no lo tengan informado
        // ApprovalEntry.RESET;
        // ApprovalEntry.SETRANGE("Document Type", ApprovalEntryArgument."Document Type");
        // ApprovalEntry.SETRANGE("QB Document Type", ApprovalEntryArgument."QB Document Type");
        // ApprovalEntry.SETRANGE("Document No.",  ApprovalEntryArgument."Document No.");
        // IF ApprovalEntry.FINDSET THEN
        //  REPEAT
        //    IF (ApprovalEntry."Job No." = '') THEN BEGIN
        //      ApprovalEntry."QB Document Type" := ApprovalEntryArgument."QB Document Type";
        //      ApprovalEntry."Job No." := ApprovalEntryArgument."Job No.";
        //      ApprovalEntry."Payment Method Code" := ApprovalEntryArgument."Payment Method Code";
        //      ApprovalEntry."Payment Terms Code" := ApprovalEntryArgument."Payment Terms Code";
        //      ApprovalEntry.Type := ApprovalEntryArgument.Type;
        //      ApprovalEntry.MODIFY;
        //    END;
        //  UNTIL ApprovalEntry.NEXT = 0;

        //Mensaje al usuario si est� as� configurado
        WorkflowStepArgument.GET(ResponseWorkflowStepInstance.Argument);
        IF WorkflowStepArgument."Show Confirmation Message" THEN
            ApprovalsMgmt.InformUserOnStatusChange(RecRef, ResponseWorkflowStepInstance.ID);

        //Finalizamos el proceso correctamente
        ResponseExecuted := TRUE;
    END;

    [EventSubscriber(ObjectType::Codeunit, 1535, OnApproveApprovalRequest, '', true, true)]
    LOCAL PROCEDURE CU1535_OnApproveApprovalRequest(VAR ApprovalEntry: Record 454);
    VAR
        QBApprovalsSetup: Record 7206994;
        ApprovalEntry2: Record 454;
        ApprovalsMgmt: Codeunit 1535;
        UserSetup: Record 91;
        isApprover: Boolean;
    BEGIN
        //------------------------------------------------------------------------------------------------------------------------
        //JAV Procesos de aprobaciones no est�ndar
        //------------------------------------------------------------------------------------------------------------------------

        //Tengo que ser conf aprobaciones para que no de error el proceso
        UserSetup.GET(USERID);
        isApprover := UserSetup."Approval Administrator";
        IF NOT UserSetup."Approval Administrator" THEN BEGIN
            UserSetup."Approval Administrator" := TRUE;
            UserSetup.MODIFY;
        END;

        //JAV 09/09/19: Si se aprueba por un usuario en un nivel, se aprueban todos los movimientos de dicho nivel de cualquier usuario, ESTO VA CONTRA EL ESTANDAR
        ApprovalEntry2.RESET;
        ApprovalEntry2.SETCURRENTKEY("Table ID", "Document Type", "Document No.", "Sequence No.");
        ApprovalEntry2.SETRANGE("Table ID", ApprovalEntry."Table ID");
        ApprovalEntry2.SETRANGE("Document Type", ApprovalEntry."Document Type");
        ApprovalEntry2.SETRANGE("Document No.", ApprovalEntry."Document No.");
        ApprovalEntry2.SETRANGE("QB Document Type", ApprovalEntry."QB Document Type");
        ApprovalEntry2.SETRANGE("Sequence No.", ApprovalEntry."Sequence No.");
        ApprovalEntry2.SETRANGE(Status, ApprovalEntry2.Status::Open);
        ApprovalsMgmt.ApproveApprovalRequests(ApprovalEntry2);

        //JAV 24/12/20: Si se aprueba por un usuario, se aprueban todos los movimientos del usuario en cualquier nivel (puede estar varias veces por las substituciones)
        //JAV 02/03/22: - QB 1.10.22 Esto ahora es opcional
        //JAV 04/04/22: - QB 1.10.31 Se cambian campos de aprobaciones a la nueva tabla de configuraci�n de aprobaciones
        IF NOT QBApprovalsSetup.GET THEN
            QBApprovalsSetup.INIT;

        IF (QBApprovalsSetup."User Approve" = QBApprovalsSetup."User Approve"::All) THEN BEGIN
            ApprovalEntry2.RESET;
            ApprovalEntry2.SETCURRENTKEY("Table ID", "Document Type", "Document No.", "Sequence No.");
            ApprovalEntry2.SETRANGE("Table ID", ApprovalEntry."Table ID");
            ApprovalEntry2.SETRANGE("Document Type", ApprovalEntry."Document Type");
            ApprovalEntry2.SETRANGE("Document No.", ApprovalEntry."Document No.");
            ApprovalEntry2.SETRANGE("QB Document Type", ApprovalEntry."QB Document Type");
            ApprovalEntry2.SETRANGE("Approver ID", ApprovalEntry."Approver ID");

            ApprovalEntry2.SETRANGE(Status, ApprovalEntry2.Status::Created);    //Las creadas las apruebo directamente
            ApprovalEntry2.MODIFYALL(Status, ApprovalEntry2.Status::Approved);
            ApprovalEntry2.SETRANGE(Status, ApprovalEntry2.Status::Open);       //Las abiertas hay que pasar por el proceso
            ApprovalsMgmt.ApproveApprovalRequests(ApprovalEntry2);
        END;

        //Repongo el estado del usuario
        IF (NOT isApprover) THEN BEGIN
            UserSetup.GET(USERID);
            UserSetup."Approval Administrator" := FALSE;
            UserSetup.MODIFY;
        END;

        //Para poder guardar el comentario de aprobaci�n si es necesario
        OnAfterApproveRequest(ApprovalEntry);
    END;

    [EventSubscriber(ObjectType::Codeunit, 1535, OnPopulateApprovalEntryArgument, '', true, true)]
    LOCAL PROCEDURE CU1535_OnPopulateApprovalEntryArgument(VAR RecRef: RecordRef; VAR ApprovalEntryArgument: Record 454; WorkflowStepInstance: Record 1504);
    VAR
        GenJournalLine: Record 81;
        PurchaseHeader: Record 38;
        SalesHeader: Record 36;
    BEGIN
        //------------------------------------------------------------------------------------------------------------------------
        //JAV 09/09/19: - Se a�ade en los registros de aprobaci�n que se crean desde la funci�n PopulateApprovalEntryArgument el campo Job.
        //------------------------------------------------------------------------------------------------------------------------

        CASE RecRef.NUMBER OF
            DATABASE::"Purchase Header":
                BEGIN
                    RecRef.SETTABLE(PurchaseHeader);
                    ApprovalEntryArgument."Job No." := PurchaseHeader."QB Job No.";
                    ApprovalEntryArgument."QB_Piecework No." := PurchaseHeader."QB Budget item";//18218
                    ApprovalEntryArgument."Payment Method Code" := PurchaseHeader."Payment Method Code";
                    ApprovalEntryArgument."Payment Terms Code" := PurchaseHeader."Payment Terms Code";
                END;
            DATABASE::"Sales Header":
                BEGIN
                    RecRef.SETTABLE(SalesHeader);
                    ApprovalEntryArgument."Job No." := SalesHeader."QB Job No.";
                    ApprovalEntryArgument."QB_Piecework No." := SalesHeader."QB Budget item";//18218
                    ApprovalEntryArgument."Payment Method Code" := SalesHeader."Payment Method Code";
                    ApprovalEntryArgument."Payment Terms Code" := SalesHeader."Payment Terms Code";
                END;
            DATABASE::"Gen. Journal Line":
                BEGIN
                    RecRef.SETTABLE(GenJournalLine);
                    ApprovalEntryArgument."Job No." := GenJournalLine."Job No.";
                    ApprovalEntryArgument."QB_Piecework No." := GenJournalLine."Piecework Code";//18218
                    ApprovalEntryArgument."Payment Method Code" := GenJournalLine."Payment Method Code";
                    ApprovalEntryArgument."Payment Terms Code" := GenJournalLine."Payment Terms Code";
                END;
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 1535, OnDelegateApprovalRequest, '', true, true)]
    LOCAL PROCEDURE CU1535_OnDelegateApprovalRequest(VAR ApprovalEntry: Record 454);
    VAR
        UserSetup: Record 91;
    BEGIN
        //------------------------------------------------------------------------------------------------------------------------
        //Mira si se ha delegado una aprobaci�n a un adminitrador de aprobaciones, si es as� intentar cambiarlo por el usuario actual
        //------------------------------------------------------------------------------------------------------------------------

        //Si el delegado es el usuario en curso no hacemos nada
        IF (ApprovalEntry."Approver ID" = USERID) THEN
            EXIT;

        //Si el usuario tiene un delegado no hacemos nada
        UserSetup.GET(USERID);
        IF (UserSetup.Substitute <> '') THEN
            EXIT;

        //Si el usuario delegado no es adminitrador de aprobaciones no hacer nada
        UserSetup.GET(ApprovalEntry."Approver ID");
        IF (NOT UserSetup."Approval Administrator") THEN
            EXIT;

        //Si el usuario actual es administrador de aprobaciones, se delega a si mismo no al primer administrador de aprobaciones
        UserSetup.GET(USERID);
        IF (UserSetup."Approval Administrator") THEN BEGIN
            ApprovalEntry."Approver ID" := UserSetup."User ID";
            ApprovalEntry.MODIFY(TRUE);
        END;
    END;

    [EventSubscriber(ObjectType::Page, 654, OnOpenPageEvent, '', true, true)]
    LOCAL PROCEDURE PG654_OnOpenPageEvent(VAR Rec: Record 454);
    VAR
        ApprovalEntry: Record 454;
        RecRef: RecordRef;
    BEGIN
        //------------------------------------------------------------------------------------------------------------------------
        //CPA 31/03/22: - Eliminar registros no existentes al abrir la p�gina
        //------------------------------------------------------------------------------------------------------------------------
        ApprovalEntry.COPYFILTERS(Rec);
        IF ApprovalEntry.FINDSET THEN
            REPEAT
                IF NOT RecRef.GET(ApprovalEntry."Record ID to Approve") THEN
                    ApprovalEntry.DELETE;
            UNTIL ApprovalEntry.NEXT = 0;
    END;

    LOCAL PROCEDURE "----------------------------------------- Funciones"();
    BEGIN
    END;

    LOCAL PROCEDURE GetWorkflowResponseName(): Text;
    BEGIN
        //------------------------------------------------------------------------------------------------------------------------
        //A�ade eventos a las cadenas de respuestas a los pasos
        //------------------------------------------------------------------------------------------------------------------------
        EXIT(UPPERCASE('QB-Aprobacion'));
    END;

    PROCEDURE GetApprovalsFixedText(pType: Option "Name","Description","SendCode","SendText","CancelCode","CancelText"; pName: Text; pDescription: Text): Text;
    VAR
        Txt: Text;
    BEGIN
        //------------------------------------------------------------------------------------------------------------------------
        //Retorna las cadenas fijas para las aprobaciones de QB
        //------------------------------------------------------------------------------------------------------------------------
        CASE pType OF
            pType::Name:
                EXIT(STRSUBSTNO('QB-%1', pName));
            pType::Description:
                EXIT(STRSUBSTNO('Flujo de aprobaci�n %1', pDescription));
            pType::SendCode:
                EXIT(UPPERCASE(STRSUBSTNO('QB-%1_RunApprovals', pName)));
            pType::SendText:
                EXIT(STRSUBSTNO('QB - Se solicit� la aprobaci�n de %1', pDescription));
            pType::CancelCode:
                EXIT(UPPERCASE(STRSUBSTNO('QB-%1_CancelApprovals', pName)));
            pType::CancelText:
                EXIT(STRSUBSTNO('QB - Se cancel� una solicitud de aprobaci�n de %1', pDescription));
        END;
    END;

    PROCEDURE GetStdApprovalsFixedText(pType: Option "Overdue"): Text;
    BEGIN
        //------------------------------------------------------------------------------------------------------------------------
        //Retorna las cadenas fijas para las aprobaciones del Est�ndar
        //------------------------------------------------------------------------------------------------------------------------

        CASE pType OF
            pType::Overdue:
                EXIT('MS-OVERDUE-01');
        END;
    END;

    PROCEDURE GetCommentText(ApprovalEntry: Record 454): Text;
    VAR
        ApprovalCommentLine: Record 455;
    BEGIN
        ApprovalCommentLine.RESET;
        ApprovalCommentLine.SETRANGE("Table ID", ApprovalEntry."Table ID");
        ApprovalCommentLine.SETRANGE("Record ID to Approve", ApprovalEntry."Record ID to Approve");
        ApprovalCommentLine.SETRANGE("Workflow Step Instance ID", ApprovalEntry."Workflow Step Instance ID");
        IF ApprovalCommentLine.FINDFIRST THEN
            EXIT(ApprovalCommentLine.Comment)
        ELSE
            EXIT('');
    END;

    PROCEDURE GetLastCommentText(TableID: Integer; recID: RecordID): Text;
    VAR
        ApprovalCommentLine: Record 455;
    BEGIN
        ApprovalCommentLine.RESET;
        ApprovalCommentLine.SETRANGE("Table ID", TableID);
        ApprovalCommentLine.SETRANGE("Record ID to Approve", recID);
        IF ApprovalCommentLine.FINDLAST THEN
            EXIT(ApprovalCommentLine.Comment)
        ELSE
            EXIT('');
    END;

    PROCEDURE GetApprovalEntry(recID: RecordID; VAR ApprovalEntry: Record 454): Boolean;
    BEGIN
        ApprovalEntry.SETRANGE("Record ID to Approve", recID);
        ApprovalEntry.SETRANGE(Status, ApprovalEntry.Status::Open);
        ApprovalEntry.SETRANGE(ApprovalEntry."Approver ID", USERID);
        EXIT(ApprovalEntry.FINDFIRST);
    END;

    PROCEDURE WitHoldingRequest(VAR ApprovalEntry: Record 454);
    BEGIN
        IF ApprovalEntry.FINDSET(TRUE) THEN
            REPEAT
                OnWitHoldingRequest(ApprovalEntry);
            UNTIL ApprovalEntry.NEXT = 0;
    END;

    //[External]
    PROCEDURE RunWorkflowEntriesPage(RecordIDInput: RecordID; TableId: Integer; DocumentType: Option; DocumentNo: Code[20]);
    VAR
        WorkflowsEntriesBuffer: Record 832;
        ApprovalEntries: Page 658;
    BEGIN
        //------------------------------------------------------------------------------------------------------------------------
        //A�adimos el filtro de documento de QuoBuilding antes de mostrar la pantalla
        //------------------------------------------------------------------------------------------------------------------------
        ApprovalEntries.QB_SetDocument(DocumentType);
        // WorkflowsEntriesBuffer.RunWorkflowEntriesPage(RecordIDInput, TableId, 30, DocumentNo);
    END;

    LOCAL PROCEDURE "-------------------------------------- Crear configuraci¢n aprobaciones y utilidades"();
    BEGIN
    END;

    PROCEDURE CreateSetup();
    VAR
        WorkflowEventHandling: Codeunit 1520;
        WorkflowCategory: Record 1508;
        WorkflowUserGroup: Record 1540;
        QBJobResponsiblesGroupTem: Record 7206990;
        QuoBuildingSetup: Record 7207278;
    BEGIN
        //------------------------------------------------------------------------------------------------------------------------
        //JAV 13/02/21: - QB 1.08.10 Crear o revisar los datos necesarios para que funcionen las aprobaciones de QuoBuilding
        //------------------------------------------------------------------------------------------------------------------------

        // Crear los eventos del sistema necesarios
        WorkflowEventHandling.CreateEventsLibrary();

        //Crear el registro en la tabla de categor�as y en la grupos de usuarios
        WorkflowCategory.INIT;
        WorkflowCategory.Code := 'QB';
        WorkflowCategory.Description := 'QuoBuilding';
        IF NOT WorkflowCategory.INSERT THEN;
        WorkflowUserGroup.INIT;
        WorkflowUserGroup.Code := 'QB';
        WorkflowUserGroup.Description := 'QuoBuilding';
        IF NOT WorkflowUserGroup.INSERT THEN;

        //Crear las relaciones entre tablas
        AddRelations;

        //JAV 10/04/22: - QB 1.10.34 A�adir los flujos copiando de las plantillas est�ndar
        AddStdFlow;

        //A�adir los flujos de probaci�n propios de QB
        //JAV 21/04/22: - QB 1.10.36 Cambio en la forma de montar los flujos, dejar que cada CU monte el suyo propio usando un evento general
        MountFlowCircuit;

        //Crear el grupo por defecto para plantillas de aprobaci�n
        QBJobResponsiblesGroupTem.INIT;
        QBJobResponsiblesGroupTem.Code := 'GENERAL';
        IF NOT QBJobResponsiblesGroupTem.INSERT(TRUE) THEN;
    END;

    LOCAL PROCEDURE AddRelations();
    BEGIN
        AddRelation(38, 0, 454, 22);              //Compras
        AddRelation(38, 1, 39, 1);
        AddRelation(38, 3, 39, 3);
        AddRelation(167, 0, 454, 3);              //Jobs
        AddRelation(7000002, 0, 454, 22);         //Cartera
        AddRelation(7207412, 0, 454, 22);         //Comparativos
        AddRelation(7207412, 2, 7207413, 2);
        AddRelation(7207320, 0, 454, 22);         //Notas de gasto
        AddRelation(7207320, 1, 7207321, 1);
        AddRelation(7207290, 0, 454, 22);         //Hojas de horas
        AddRelation(7207290, 2, 7207291, 1);
        AddRelation(7207286, 0, 454, 22);         //Traspasos entre proyectos
        AddRelation(7207286, 1, 7207287, 1);
        AddRelation(7207336, 0, 454, 22);         //Mediciones
        AddRelation(7207336, 1, 7207337, 1);
        AddRelation(7000020, 0, 454, 22);         //Ordenes de pago
        AddRelation(7000020, 2, 7000002, 16);
        AddRelation(7207407, 0, 454, 22);         //JAV 18/11/21: - QB 1.09.28 Se a�aden los Presupuestos
        AddRelation(7206928, 0, 454, 22);         //JAV 31/03/22: - QB 1.10.29 Se a�aden los anticipos
        AddRelation(7207329, 0, 454, 22);         //JAV 13/12/22: - QB 1.12.26 Se a�aden las retenciones
    END;

    LOCAL PROCEDURE AddRelation(idTabla: Integer; idCampo: Integer; idTablaRelacionada: Integer; idCampoRelacionado: Integer);
    VAR
        WorkflowTableRelation: Record 1505;
    BEGIN
        WorkflowTableRelation.INIT;
        WorkflowTableRelation."Table ID" := idTabla;
        WorkflowTableRelation."Field ID" := idCampo;
        WorkflowTableRelation."Related Table ID" := idTablaRelacionada;
        WorkflowTableRelation."Related Field ID" := idCampoRelacionado;
        IF NOT WorkflowTableRelation.INSERT THEN;
    END;

    LOCAL PROCEDURE AddStdFlow();
    VAR
        WorkflowBuffer: Record 1500;
        Workflow: Record 1501;
    BEGIN
        //------------------------------------------------------------------------------------------------------------------------
        //JAV 10/04/22: - QB 1.10.34 A�adir todos los flujos necesarios que se crean copiando de las plantillas est�ndar
        //------------------------------------------------------------------------------------------------------------------------
        AddStdFlowOne(GetStdApprovalsFixedText(0));
    END;

    LOCAL PROCEDURE AddStdFlowOne(pToName: Code[20]);
    VAR
        WorkflowBuffer: Record 1500;
        FromWorkflow: Record 1501;
        ToWorkflow: Record 1501;
        CopyWorkflow: Report 1510;
        FromName: Code[20];
    BEGIN
        //------------------------------------------------------------------------------------------------------------------------
        //JAV 10/04/22: - QB 1.10.34 A�adir un flujo copiando de una plantilla est�ndar
        //------------------------------------------------------------------------------------------------------------------------
        IF (ToWorkflow.GET(pToName)) THEN
            EXIT;

        FromName := COPYSTR(pToName, 1, STRLEN(pToName) - 3);

        IF (NOT FromWorkflow.GET(FromName)) THEN
            EXIT;

        ToWorkflow.INIT;
        ToWorkflow.Code := pToName;
        ToWorkflow.INSERT;
        CopyWorkflow.InitCopyWorkflow(FromWorkflow, ToWorkflow);
        CopyWorkflow.USEREQUESTPAGE(FALSE);
        CopyWorkflow.RUN;
    END;

    PROCEDURE AddUnFlujo(pTipo: Integer; pTabla: Integer; pCodigoFlujo: Text; pDescripcion: Text; pCodigoEnvio: Text; pCodigoCancelacion: Text);
    VAR
        Workflow: Record 1501;
        WorkflowStep: Record 1502;
        TempBlob: Codeunit "Temp Blob";
        Instr: InStream;
        Blob: OutStream;
        QBApprovalsSetup: Record 7206994;
        WfActive: Boolean;
        txtXML: Text;
        i: Integer;
    BEGIN
        //------------------------------------------------------------------------------------------------------------------------
        //JAV Funci�n que monta un flujo de trabajo de QB con los par�metros adecuados
        //------------------------------------------------------------------------------------------------------------------------
        //JAV 21/04/22: - QB 1.10.36 A�ado un par�metro con la tabla a tratar y cambio nombres del resto para que est�n mas claros. A�ado los nuevos datos de configuraci�n de aprobaciones

        //Elimino el flujo existente para poder introducir los cambios que se desee, pero me guardo si est� activo para restaurarlo al final
        WfActive := FALSE;
        IF (Workflow.GET(pCodigoFlujo)) THEN BEGIN
            WfActive := Workflow.Enabled;
            Workflow.DELETE;
            WorkflowStep.RESET;
            WorkflowStep.SETRANGE("Workflow Code", pCodigoFlujo);
            WorkflowStep.DELETEALL;
        END;

        //Crear el fichero auxiliar con la configuraci�n y guardarlo
        txtXML := '<?xml version="1.0" encoding="UTF-16" standalone="no"?>';
        txtXML += '<Root>';
        txtXML += '<Workflow Code="' + pCodigoFlujo + '" Description="' + pDescripcion + '" Category="QB">';
        txtXML += '<WorkflowStep StepID="89" EntryPoint="1" PreviousStepID="0" Type="0" FunctionName="' + pCodigoEnvio + '" SequenceNo="1">';
        txtXML += '<WorkflowStepArgument EventConditions="';
        AddConditions(pTipo, txtXML);
        txtXML += '" /></WorkflowStep>';
        txtXML += '<WorkflowStep StepID="90" PreviousStepID="89" Type="1" FunctionName="RESTRICTRECORDUSAGE" SequenceNo="1">';
        txtXML += '<WorkflowStepArgument ResponseFunctionName="RESTRICTRECORDUSAGE" /></WorkflowStep>';
        txtXML += '<WorkflowStep StepID="91" PreviousStepID="90" Type="1" FunctionName="SETSTATUSTOPENDINGAPPROVAL" SequenceNo="1">';
        txtXML += '<WorkflowStepArgument ResponseFunctionName="SETSTATUSTOPENDINGAPPROVAL" /></WorkflowStep>';
        txtXML += '<WorkflowStep StepID="92" PreviousStepID="91" Type="1" FunctionName="QB-APROBACION" SequenceNo="1">';

        //JAV 21/04/22: - QB 1.10.36 A�ado la tabla a tratar que no lo hac�a correctamente y los nuevos par�metros de configuraci�n
        QBApprovalsSetup.GET();
        txtXML += '<WorkflowStepArgument ResponseFunctionName="QB-APROBACION" ApproverType="2" WorkflowUserGroupCode="QB" TableNumber="' + FORMAT(pTabla) + '" ';
        IF (FORMAT(QBApprovalsSetup."Due Date for Approvals") <> '') THEN
            txtXML += 'DueDateFormula="' + FORMAT(QBApprovalsSetup."Due Date for Approvals") + '" ';
        txtXML += 'ShowConfirmationMessage="' + FORMAT(QBApprovalsSetup."Show Confirmation Message") + '" ';
        IF (QBApprovalsSetup."Delegate After" <> QBApprovalsSetup."Delegate After"::Never) THEN BEGIN
            i := QBApprovalsSetup."Delegate After";
            txtXML += 'DelegateAfter="' + FORMAT(i) + '" ';
        END;
        txtXML += ' />';

        txtXML += '</WorkflowStep>';
        txtXML += '<WorkflowStep StepID="93" PreviousStepID="92" Type="1" FunctionName="SENDAPPROVALREQUESTFORAPPROVAL" SequenceNo="1">';
        txtXML += '<WorkflowStepArgument ResponseFunctionName="SENDAPPROVALREQUESTFORAPPROVAL" /></WorkflowStep>';
        txtXML += '<WorkflowStep StepID="94" PreviousStepID="93" Type="0" FunctionName="RUNWORKFLOWONAPPROVEAPPROVALREQUEST" SequenceNo="1">';
        txtXML += '<WorkflowStepArgument EventConditions="';
        txtXML += 'PAA/AHgAbQBsACAAdgBlAHIAcwBpAG8AbgA9ACIAMQAuADAAIgAgAGUAbgBjAG8AZABpAG4AZwA9ACIAdQB0AGYALQA4ACIAIAB';
        txtXML += 'zAHQAYQBuAGQAYQBsAG8AbgBlAD0AIgB5AGUAcwAiAD8APgA8AFIAZQBwAG8AcgB0AFAAYQByAGEAbQBlAHQAZQByAHMAPgA8AE';
        txtXML += 'QAYQB0AGEASQB0AGUAbQBzAD4APABEAGEAdABhAEkAdABlAG0AIABuAGEAbQBlAD0AIgBBAHAAcAByAG8AdgBhAGwAIABFAG4Ad';
        txtXML += 'AByAHkAIgA+AFYARQBSAFMASQBPAE4AKAAxACkAIABTAE8AUgBUAEkATgBHACgARgBpAGUAbABkADIAOQApACAAVwBIAEUAUgBF';
        txtXML += 'ACgARgBpAGUAbABkADIAMQA9ADEAKAAwACkAKQA8AC8ARABhAHQAYQBJAHQAZQBtAD4APAAvAEQAYQB0AGEASQB0AGUAbQBzAD4';
        txtXML += 'APAAvAFIAZQBwAG8AcgB0AFAAYQByAGEAbQBlAHQAZQByAHMAPgA=';
        txtXML += '" />';
        txtXML += '</WorkflowStep>';
        txtXML += '<WorkflowStep StepID="95" PreviousStepID="94" Type="1" FunctionName="ALLOWRECORDUSAGE" SequenceNo="1">';
        txtXML += '<WorkflowStepArgument ResponseFunctionName="ALLOWRECORDUSAGE" />';
        txtXML += '</WorkflowStep>';
        txtXML += '<WorkflowStep StepID="96" PreviousStepID="95" Type="1" FunctionName="RELEASEDOCUMENT" SequenceNo="1">';
        txtXML += '<WorkflowStepArgument ResponseFunctionName="RELEASEDOCUMENT" />';
        txtXML += '</WorkflowStep>';
        txtXML += '<WorkflowStep StepID="97" PreviousStepID="93" Type="0" FunctionName="RUNWORKFLOWONAPPROVEAPPROVALREQUEST" SequenceNo="1">';
        txtXML += '<WorkflowStepArgument EventConditions="';
        txtXML += 'PAA/AHgAbQBsACAAdgBlAHIAcwBpAG8AbgA9ACIAMQAuADAAIgAgAGUAbgBjAG8AZABpAG4AZwA9ACIAdQB0AGYALQA4ACIAIAB';
        txtXML += 'zAHQAYQBuAGQAYQBsAG8AbgBlAD0AIgB5AGUAcwAiAD8APgA8AFIAZQBwAG8AcgB0AFAAYQByAGEAbQBlAHQAZQByAHMAPgA8AE';
        txtXML += 'QAYQB0AGEASQB0AGUAbQBzAD4APABEAGEAdABhAEkAdABlAG0AIABuAGEAbQBlAD0AIgBBAHAAcAByAG8AdgBhAGwAIABFAG4Ad';
        txtXML += 'AByAHkAIgA+AFYARQBSAFMASQBPAE4AKAAxACkAIABTAE8AUgBUAEkATgBHACgARgBpAGUAbABkADIAOQApACAAVwBIAEUAUgBF';
        txtXML += 'ACgARgBpAGUAbABkADIAMQA9ADEAKAAmAGcAdAA7ADAAKQApADwALwBEAGEAdABhAEkAdABlAG0APgA8AC8ARABhAHQAYQBJAHQ';
        txtXML += 'AZQBtAHMAPgA8AC8AUgBlAHAAbwByAHQAUABhAHIAYQBtAGUAdABlAHIAcwA+AA==';
        txtXML += '" />';
        txtXML += '</WorkflowStep>';
        txtXML += '<WorkflowStep StepID="98" PreviousStepID="97" NextStepID="93" Type="1" FunctionName="SENDAPPROVALREQUESTFORAPPROVAL" SequenceNo="1">';
        txtXML += '<WorkflowStepArgument ResponseFunctionName="SENDAPPROVALREQUESTFORAPPROVAL" />';
        txtXML += '</WorkflowStep>';
        txtXML += '<WorkflowStep StepID="99" PreviousStepID="93" Type="0" FunctionName="RUNWORKFLOWONREJECTAPPROVALREQUEST" SequenceNo="2" />';
        txtXML += '<WorkflowStep StepID="100" PreviousStepID="99" Type="1" FunctionName="REJECTALLAPPROVALREQUESTS" SequenceNo="1">';
        txtXML += '<WorkflowStepArgument ResponseFunctionName="REJECTALLAPPROVALREQUESTS" />';
        txtXML += '</WorkflowStep>';
        txtXML += '<WorkflowStep StepID="101" PreviousStepID="100" Type="1" FunctionName="OPENDOCUMENT" SequenceNo="1">';
        txtXML += '<WorkflowStepArgument ResponseFunctionName="OPENDOCUMENT" />';
        txtXML += '</WorkflowStep>';
        txtXML += '<WorkflowStep StepID="102" PreviousStepID="93" Type="0" FunctionName="' + pCodigoCancelacion + '" SequenceNo="3" />';
        txtXML += '<WorkflowStep StepID="103" PreviousStepID="102" Type="1" FunctionName="CANCELALLAPPROVALREQUESTS" SequenceNo="1">';
        txtXML += '<WorkflowStepArgument ResponseFunctionName="CANCELALLAPPROVALREQUESTS" />';
        txtXML += '</WorkflowStep>';
        txtXML += '<WorkflowStep StepID="104" PreviousStepID="103" Type="1" FunctionName="ALLOWRECORDUSAGE" SequenceNo="1">';
        txtXML += '<WorkflowStepArgument ResponseFunctionName="ALLOWRECORDUSAGE" />';
        txtXML += '</WorkflowStep>';
        txtXML += '<WorkflowStep StepID="105" PreviousStepID="104" Type="1" FunctionName="OPENDOCUMENT" SequenceNo="1">';
        txtXML += '<WorkflowStepArgument ResponseFunctionName="OPENDOCUMENT" />';
        txtXML += '</WorkflowStep>';
        txtXML += '<WorkflowStep StepID="106" PreviousStepID="105" Type="1" FunctionName="SHOWMESSAGE" SequenceNo="1">';
        txtXML += '<WorkflowStepArgument ResponseFunctionName="SHOWMESSAGE" Message="Se ha cancelado la solicitud de aprobaci�n del registro." />';
        txtXML += '</WorkflowStep>';
        txtXML += '<WorkflowStep StepID="107" PreviousStepID="93" Type="0" FunctionName="RUNWORKFLOWONDELEGATEAPPROVALREQUEST" SequenceNo="4" />';
        txtXML += '<WorkflowStep StepID="108" PreviousStepID="107" NextStepID="93" Type="1" FunctionName="SENDAPPROVALREQUESTFORAPPROVAL" SequenceNo="1">';
        txtXML += '<WorkflowStepArgument ResponseFunctionName="SENDAPPROVALREQUESTFORAPPROVAL" />';
        txtXML += '</WorkflowStep>';
        txtXML += '<WorkflowCategory CategoryCode="QB" CategoryDescription="QuoBuilding" />';
        txtXML += '</Workflow>';
        txtXML += '</Root>';
        //TempBlob.WriteAsText(txtXML, TEXTENCODING::UTF16);
        TempBlob.CreateOutStream(Blob, TextEncoding::Windows);
        Blob.Write(txtXML);
        //Crear el flujo usando el auxiliare recien montado
        Workflow.INIT;
        Workflow.Code := pCodigoFlujo;
        Workflow.Description := pDescripcion;
        Workflow.Category := 'QB';
        Workflow.ImportFromBlob(TempBlob);

        //Volver a marcar si est� activo
        IF (Workflow.GET(pCodigoFlujo)) THEN BEGIN
            Workflow.Enabled := WfActive;
            Workflow.MODIFY;
        END;
    END;

    LOCAL PROCEDURE AddConditions(pType: Integer; VAR txtXML: Text);
    VAR
        ApprovalEntry: Record 454;
    BEGIN
        // Versiones de estudios
        IF pType = ApprovalEntry."QB Document Type"::Job THEN BEGIN
            txtXML += 'PAA/AHgAbQBsACAAdgBlAHIAcwBpAG8AbgA9ACIAMQAuADAAIgAgAGUAbgBjAG8AZABpAG4AZwA9ACIAdQB0AGYALQA4ACIAIABz';
            txtXML += 'AHQAYQBuAGQAYQBsAG8AbgBlAD0AIgB5AGUAcwAiAD8APgA8AFIAZQBwAG8AcgB0AFAAYQByAGEAbQBlAHQAZQByAHMAPgA8AEQA';
            txtXML += 'YQB0AGEASQB0AGUAbQBzAD4APABEAGEAdABhAEkAdABlAG0AIABuAGEAbQBlAD0AIgBUAGEAYgBsAGUAMQA2ADcAIgA+AFYARQBS';
            txtXML += 'AFMASQBPAE4AKAAxACkAIABTAE8AUgBUAEkATgBHACgARgBpAGUAbABkADEAKQAgAFcASABFAFIARQAoAEYAaQBlAGwAZAA3ADIA';
            txtXML += 'MAA3ADUAMwAxAD0AMQAoADAAKQApADwALwBEAGEAdABhAEkAdABlAG0APgA8AC8ARABhAHQAYQBJAHQAZQBtAHMAPgA8AC8AUgBl';
            txtXML += 'AHAAbwByAHQAUABhAHIAYQBtAGUAdABlAHIAcwA+AA==';
            // Comparativos
        END ELSE IF pType = ApprovalEntry."QB Document Type"::Comparative THEN BEGIN
            txtXML += 'PAA/AHgAbQBsACAAdgBlAHIAcwBpAG8AbgA9ACIAMQAuADAAIgAgAGUAbgBjAG8AZABpAG4AZwA9ACIAdQB0AGYALQA4ACIAIABz';
            txtXML += 'AHQAYQBuAGQAYQBsAG8AbgBlAD0AIgB5AGUAcwAiAD8APgA8AFIAZQBwAG8AcgB0AFAAYQByAGEAbQBlAHQAZQByAHMAPgA8AEQA';
            txtXML += 'YQB0AGEASQB0AGUAbQBzAD4APABEAGEAdABhAEkAdABlAG0AIABuAGEAbQBlAD0AIgBUAGEAYgBsAGUANwAyADAANwA0ADEAMgAi';
            txtXML += 'AD4AVgBFAFIAUwBJAE8ATgAoADEAKQAgAFMATwBSAFQASQBOAEcAKABGAGkAZQBsAGQAMgApACAAVwBIAEUAUgBFACgARgBpAGUA';
            txtXML += 'bABkADEAMgAwAD0AMQAoADAAKQApADwALwBEAGEAdABhAEkAdABlAG0APgA8AC8ARABhAHQAYQBJAHQAZQBtAHMAPgA8AC8AUgBl';
            txtXML += 'AHAAbwByAHQAUABhAHIAYQBtAGUAdABlAHIAcwA+AA==';
            // Pedidos de Compra
        END ELSE IF pType = ApprovalEntry."QB Document Type"::Purchase THEN BEGIN
            txtXML += 'PAA/AHgAbQBsACAAdgBlAHIAcwBpAG8AbgA9ACIAMQAuADAAIgAgAGUAbgBjAG8AZABpAG4AZwA9ACIAdQB0AGYALQA4ACIAIABz';
            txtXML += 'AHQAYQBuAGQAYQBsAG8AbgBlAD0AIgB5AGUAcwAiAD8APgA8AFIAZQBwAG8AcgB0AFAAYQByAGEAbQBlAHQAZQByAHMAPgA8AEQA';
            txtXML += 'YQB0AGEASQB0AGUAbQBzAD4APABEAGEAdABhAEkAdABlAG0AIABuAGEAbQBlAD0AIgBUAGEAYgBsAGUAMwA4ACIAPgBWAEUAUgBT';
            txtXML += 'AEkATwBOACgAMQApACAAUwBPAFIAVABJAE4ARwAoAEYAaQBlAGwAZAAxACwARgBpAGUAbABkADMAKQAgAFcASABFAFIARQAoAEYA';
            txtXML += 'aQBlAGwAZAAxAD0AMQAoADEAKQAsAEYAaQBlAGwAZAAxADIAMAA9ADEAKAAwACkAKQA8AC8ARABhAHQAYQBJAHQAZQBtAD4APABE';
            txtXML += 'AGEAdABhAEkAdABlAG0AIABuAGEAbQBlAD0AIgBUAGEAYgBsAGUAMwA5ACIAPgBWAEUAUgBTAEkATwBOACgAMQApACAAUwBPAFIA';
            txtXML += 'VABJAE4ARwAoAEYAaQBlAGwAZAAxACwARgBpAGUAbABkADMALABGAGkAZQBsAGQANAApADwALwBEAGEAdABhAEkAdABlAG0APgA8';
            txtXML += 'AC8ARABhAHQAYQBJAHQAZQBtAHMAPgA8AC8AUgBlAHAAbwByAHQAUABhAHIAYQBtAGUAdABlAHIAcwA+AA==';
            // Facturas de compra
        END ELSE IF pType = ApprovalEntry."QB Document Type"::PurchaseInvoice THEN BEGIN
            txtXML += 'PAA/AHgAbQBsACAAdgBlAHIAcwBpAG8AbgA9ACIAMQAuADAAIgAgAGUAbgBjAG8AZABpAG4AZwA9ACIAdQB0AGYALQA4ACIAIABz';
            txtXML += 'AHQAYQBuAGQAYQBsAG8AbgBlAD0AIgB5AGUAcwAiAD8APgA8AFIAZQBwAG8AcgB0AFAAYQByAGEAbQBlAHQAZQByAHMAPgA8AEQA';
            txtXML += 'YQB0AGEASQB0AGUAbQBzAD4APABEAGEAdABhAEkAdABlAG0AIABuAGEAbQBlAD0AIgBUAGEAYgBsAGUAMwA4ACIAPgBWAEUAUgBT';
            txtXML += 'AEkATwBOACgAMQApACAAUwBPAFIAVABJAE4ARwAoAEYAaQBlAGwAZAAxACwARgBpAGUAbABkADMAKQAgAFcASABFAFIARQAoAEYA';
            txtXML += 'aQBlAGwAZAAxAD0AMQAoADIAKQAsAEYAaQBlAGwAZAAxADIAMAA9ADEAKAAwACkAKQA8AC8ARABhAHQAYQBJAHQAZQBtAD4APABE';
            txtXML += 'AGEAdABhAEkAdABlAG0AIABuAGEAbQBlAD0AIgBUAGEAYgBsAGUAMwA5ACIAPgBWAEUAUgBTAEkATwBOACgAMQApACAAUwBPAFIA';
            txtXML += 'VABJAE4ARwAoAEYAaQBlAGwAZAAxACwARgBpAGUAbABkADMALABGAGkAZQBsAGQANAApADwALwBEAGEAdABhAEkAdABlAG0APgA8';
            txtXML += 'AC8ARABhAHQAYQBJAHQAZQBtAHMAPgA8AC8AUgBlAHAAbwByAHQAUABhAHIAYQBtAGUAdABlAHIAcwA+AA==';

            // Mediciones
        END ELSE IF pType = ApprovalEntry."QB Document Type"::Measeurement THEN BEGIN
            txtXML += 'PAA/AHgAbQBsACAAdgBlAHIAcwBpAG8AbgA9ACIAMQAuADAAIgAgAGUAbgBjAG8AZABpAG4AZwA9ACIAdQB0AGYALQA4ACIAIABz';
            txtXML += 'AHQAYQBuAGQAYQBsAG8AbgBlAD0AIgB5AGUAcwAiAD8APgA8AFIAZQBwAG8AcgB0AFAAYQByAGEAbQBlAHQAZQByAHMAPgA8AEQA';
            txtXML += 'YQB0AGEASQB0AGUAbQBzAD4APABEAGEAdABhAEkAdABlAG0AIABuAGEAbQBlAD0AIgBUAGEAYgBsAGUANwAyADAANwAzADMANgAi';
            txtXML += 'AD4AVgBFAFIAUwBJAE8ATgAoADEAKQAgAFMATwBSAFQASQBOAEcAKABGAGkAZQBsAGQANAAzACwARgBpAGUAbABkADEAKQAgAFcA';
            txtXML += 'SABFAFIARQAoAEYAaQBlAGwAZAAxADIAMAA9ADEAKAAwACkAKQA8AC8ARABhAHQAYQBJAHQAZQBtAD4APAAvAEQAYQB0AGEASQB0';
            txtXML += 'AGUAbQBzAD4APAAvAFIAZQBwAG8AcgB0AFAAYQByAGEAbQBlAHQAZQByAHMAPgA=';
            // cartera
        END ELSE IF pType = ApprovalEntry."QB Document Type"::Payment THEN BEGIN
            txtXML += 'PAA/AHgAbQBsACAAdgBlAHIAcwBpAG8AbgA9ACIAMQAuADAAIgAgAGUAbgBjAG8AZABpAG4AZwA9ACIAdQB0AGYALQA4ACIAIABz';
            txtXML += 'AHQAYQBuAGQAYQBsAG8AbgBlAD0AIgB5AGUAcwAiAD8APgA8AFIAZQBwAG8AcgB0AFAAYQByAGEAbQBlAHQAZQByAHMAPgA8AEQA';
            txtXML += 'YQB0AGEASQB0AGUAbQBzAD4APABEAGEAdABhAEkAdABlAG0AIABuAGEAbQBlAD0AIgBUAGEAYgBsAGUANwAwADAAMAAwADAAMgAi';
            txtXML += 'AD4AVgBFAFIAUwBJAE8ATgAoADEAKQAgAFMATwBSAFQASQBOAEcAKABGAGkAZQBsAGQAMQAsAEYAaQBlAGwAZAAyACkAIABXAEgA';
            txtXML += 'RQBSAEUAKABGAGkAZQBsAGQANwAyADAANwAyADkAOAA9ADEAKAAwAHwAMwApACkAPAAvAEQAYQB0AGEASQB0AGUAbQA+ADwALwBE';
            txtXML += 'AGEAdABhAEkAdABlAG0AcwA+ADwALwBSAGUAcABvAHIAdABQAGEAcgBhAG0AZQB0AGUAcgBzAD4A';
            // Hojas de gasto
        END ELSE IF pType = ApprovalEntry."QB Document Type"::Expense THEN BEGIN
            txtXML += 'PAA/AHgAbQBsACAAdgBlAHIAcwBpAG8AbgA9ACIAMQAuADAAIgAgAGUAbgBjAG8AZABpAG4AZwA9ACIAdQB0AGYALQA4ACIAIABz';
            txtXML += 'AHQAYQBuAGQAYQBsAG8AbgBlAD0AIgB5AGUAcwAiAD8APgA8AFIAZQBwAG8AcgB0AFAAYQByAGEAbQBlAHQAZQByAHMAPgA8AEQA';
            txtXML += 'YQB0AGEASQB0AGUAbQBzAD4APABEAGEAdABhAEkAdABlAG0AIABuAGEAbQBlAD0AIgBUAGEAYgBsAGUANwAyADAANwAzADIAMAAi';
            txtXML += 'AD4AVgBFAFIAUwBJAE8ATgAoADEAKQAgAFMATwBSAFQASQBOAEcAKABGAGkAZQBsAGQAMQApACAAVwBIAEUAUgBFACgARgBpAGUA';
            txtXML += 'bABkADEAMgAwAD0AMQAoADAAKQApADwALwBEAGEAdABhAEkAdABlAG0APgA8AC8ARABhAHQAYQBJAHQAZQBtAHMAPgA8AC8AUgBl';
            txtXML += 'AHAAbwByAHQAUABhAHIAYQBtAGUAdABlAHIAcwA+AA==';
            // horas de horas
        END ELSE IF pType = ApprovalEntry."QB Document Type"::Worksheet THEN BEGIN
            txtXML += 'PAA/AHgAbQBsACAAdgBlAHIAcwBpAG8AbgA9ACIAMQAuADAAIgAgAGUAbgBjAG8AZABpAG4AZwA9ACIAdQB0AGYALQA4ACIAIABz';
            txtXML += 'AHQAYQBuAGQAYQBsAG8AbgBlAD0AIgB5AGUAcwAiAD8APgA8AFIAZQBwAG8AcgB0AFAAYQByAGEAbQBlAHQAZQByAHMAPgA8AEQA';
            txtXML += 'YQB0AGEASQB0AGUAbQBzAD4APABEAGEAdABhAEkAdABlAG0AIABuAGEAbQBlAD0AIgBUAGEAYgBsAGUANwAyADAANwAyADkAMAAi';
            txtXML += 'AD4AVgBFAFIAUwBJAE8ATgAoADEAKQAgAFMATwBSAFQASQBOAEcAKABGAGkAZQBsAGQAMgApACAAVwBIAEUAUgBFACgARgBpAGUA';
            txtXML += 'bABkADEAMgAwAD0AMQAoADAAKQApADwALwBEAGEAdABhAEkAdABlAG0APgA8AC8ARABhAHQAYQBJAHQAZQBtAHMAPgA8AC8AUgBl';
            txtXML += 'AHAAbwByAHQAUABhAHIAYQBtAGUAdABlAHIAcwA+AA==';
            // traspasos entre proyectos
        END ELSE IF pType = ApprovalEntry."QB Document Type"::Transfer THEN BEGIN
            txtXML += 'PAA/AHgAbQBsACAAdgBlAHIAcwBpAG8AbgA9ACIAMQAuADAAIgAgAGUAbgBjAG8AZABpAG4AZwA9ACIAdQB0AGYALQA4ACIAIABz';
            txtXML += 'AHQAYQBuAGQAYQBsAG8AbgBlAD0AIgB5AGUAcwAiAD8APgA8AFIAZQBwAG8AcgB0AFAAYQByAGEAbQBlAHQAZQByAHMAPgA8AEQA';
            txtXML += 'YQB0AGEASQB0AGUAbQBzAD4APABEAGEAdABhAEkAdABlAG0AIABuAGEAbQBlAD0AIgBUAGEAYgBsAGUANwAyADAANwAyADgANgAi';
            txtXML += 'AD4AVgBFAFIAUwBJAE8ATgAoADEAKQAgAFMATwBSAFQASQBOAEcAKABGAGkAZQBsAGQAMQApACAAVwBIAEUAUgBFACgARgBpAGUA';
            txtXML += 'bABkADEAMgAwAD0AMQAoADAAKQApADwALwBEAGEAdABhAEkAdABlAG0APgA8AC8ARABhAHQAYQBJAHQAZQBtAHMAPgA8AC8AUgBl';
            txtXML += 'AHAAbwByAHQAUABhAHIAYQBtAGUAdABlAHIAcwA+AA==';
            // �rdenes de pago
        END ELSE IF pType = ApprovalEntry."QB Document Type"::"Payment Order" THEN BEGIN
            txtXML += 'PAA/AHgAbQBsACAAdgBlAHIAcwBpAG8AbgA9ACIAMQAuADAAIgAgAGUAbgBjAG8AZABpAG4AZwA9ACIAdQB0AGYALQA4ACIAIABz';
            txtXML += 'AHQAYQBuAGQAYQBsAG8AbgBlAD0AIgB5AGUAcwAiAD8APgA8AFIAZQBwAG8AcgB0AFAAYQByAGEAbQBlAHQAZQByAHMAPgA8AEQA';
            txtXML += 'YQB0AGEASQB0AGUAbQBzAD4APABEAGEAdABhAEkAdABlAG0AIABuAGEAbQBlAD0AIgBUAGEAYgBsAGUANwAwADAAMAAwADIAMAAi';
            txtXML += 'AD4AVgBFAFIAUwBJAE8ATgAoADEAKQAgAFMATwBSAFQASQBOAEcAKABGAGkAZQBsAGQAMgApACAAVwBIAEUAUgBFACgARgBpAGUA';
            txtXML += 'bABkADcAMgAwADcAMgA3ADAAPQAxACgAJgBsAHQAOwAmAGcAdAA7ACcAJwApACwARgBpAGUAbABkADcAMgAwADcAMgA3ADEAPQAx';
            txtXML += 'ACgAMAApACkAPAAvAEQAYQB0AGEASQB0AGUAbQA+ADwALwBEAGEAdABhAEkAdABlAG0AcwA+ADwALwBSAGUAcABvAHIAdABQAGEA';
            txtXML += 'cgBhAG0AZQB0AGUAcgBzAD4A';
            //JAV 13/04/21: - QB 1.08.38 se a�aden los abonos de compra
        END ELSE IF pType = ApprovalEntry."QB Document Type"::PurchaseCredirMemo THEN BEGIN
            txtXML += 'PAA/AHgAbQBsACAAdgBlAHIAcwBpAG8AbgA9ACIAMQAuADAAIgAgAGUAbgBjAG8AZABpAG4AZwA9ACIAdQB0AGYALQA4ACIAIABz';
            txtXML += 'AHQAYQBuAGQAYQBsAG8AbgBlAD0AIgB5AGUAcwAiAD8APgA8AFIAZQBwAG8AcgB0AFAAYQByAGEAbQBlAHQAZQByAHMAPgA8AEQA';
            txtXML += 'YQB0AGEASQB0AGUAbQBzAD4APABEAGEAdABhAEkAdABlAG0AIABuAGEAbQBlAD0AIgBQAHUAcgBjAGgAYQBzAGUAIABIAGUAYQBk';
            txtXML += 'AGUAcgAiAD4AVgBFAFIAUwBJAE8ATgAoADEAKQAgAFMATwBSAFQASQBOAEcAKABGAGkAZQBsAGQAMQAsAEYAaQBlAGwAZAAzACkA';
            txtXML += 'IABXAEgARQBSAEUAKABGAGkAZQBsAGQAMQA9ADEAKAAzACkALABGAGkAZQBsAGQAMQAyADAAPQAxACgAMAApACkAPAAvAEQAYQB0';
            txtXML += 'AGEASQB0AGUAbQA+ADwARABhAHQAYQBJAHQAZQBtACAAbgBhAG0AZQA9ACIAUAB1AHIAYwBoAGEAcwBlACAATABpAG4AZQAiAD4A';
            txtXML += 'VgBFAFIAUwBJAE8ATgAoADEAKQAgAFMATwBSAFQASQBOAEcAKABGAGkAZQBsAGQAMQAsAEYAaQBlAGwAZAAzACwARgBpAGUAbABk';
            txtXML += 'ADQAKQA8AC8ARABhAHQAYQBJAHQAZQBtAD4APAAvAEQAYQB0AGEASQB0AGUAbQBzAD4APAAvAFIAZQBwAG8AcgB0AFAAYQByAGEA';
            txtXML += 'bQBlAHQAZQByAHMAPgA=';
            //JAV 18/11/21: - QB 1.09.28 Se a�aden los Presupuestos
        END ELSE IF pType = ApprovalEntry."QB Document Type"::Budget THEN BEGIN
            txtXML += 'PAA/AHgAbQBsACAAdgBlAHIAcwBpAG8AbgA9ACIAMQAuADAAIgAgAGUAbgBjAG8AZABpAG4AZwA9ACIAdQB0AGYALQA4ACIAIABz';
            txtXML += 'AHQAYQBuAGQAYQBsAG8AbgBlAD0AIgB5AGUAcwAiAD8APgA8AFIAZQBwAG8AcgB0AFAAYQByAGEAbQBlAHQAZQByAHMAPgA8AEQA';
            txtXML += 'YQB0AGEASQB0AGUAbQBzAD4APABEAGEAdABhAEkAdABlAG0AIABuAGEAbQBlAD0AIgBUAGEAYgBsAGUANwAyADAANwA0ADAANwAi';
            txtXML += 'AD4AVgBFAFIAUwBJAE8ATgAoADEAKQAgAFMATwBSAFQASQBOAEcAKABGAGkAZQBsAGQAMQAsAEYAaQBlAGwAZAAyACkAIABXAEgA';
            txtXML += 'RQBSAEUAKABGAGkAZQBsAGQAMQAyADAAPQAxACgAMAApACkAPAAvAEQAYQB0AGEASQB0AGUAbQA+ADwALwBEAGEAdABhAEkAdABl';
            txtXML += 'AG0AcwA+ADwALwBSAGUAcABvAHIAdABQAGEAcgBhAG0AZQB0AGUAcgBzAD4A';

            //JAV 31/03/22: - QB 1.10.29 Se a�aden los Anticipos
        END ELSE IF pType = ApprovalEntry."QB Document Type"::Prepayment THEN BEGIN
            txtXML += 'PAA/AHgAbQBsACAAdgBlAHIAcwBpAG8AbgA9ACIAMQAuADAAIgAgAGUAbgBjAG8AZABpAG4AZwA9ACIAdQB0AGYALQA4ACIAIABz';
            txtXML += 'AHQAYQBuAGQAYQBsAG8AbgBlAD0AIgB5AGUAcwAiAD8APgA8AFIAZQBwAG8AcgB0AFAAYQByAGEAbQBlAHQAZQByAHMAPgA8AEQA';
            txtXML += 'YQB0AGEASQB0AGUAbQBzAD4APABEAGEAdABhAEkAdABlAG0AIABuAGEAbQBlAD0AIgBUAGEAYgBsAGUANwAyADAANgA5ADIAOAAi';
            txtXML += 'AD4AVgBFAFIAUwBJAE8ATgAoADEAKQAgAFMATwBSAFQASQBOAEcAKABGAGkAZQBsAGQAMQApACAAVwBIAEUAUgBFACgARgBpAGUA';
            txtXML += 'bABkADUAMAA9ADEAKAAwACkAKQA8AC8ARABhAHQAYQBJAHQAZQBtAD4APAAvAEQAYQB0AGEASQB0AGUAbQBzAD4APAAvAFIAZQBw';
            txtXML += 'AG8AcgB0AFAAYQByAGEAbQBlAHQAZQByAHMAPgA=';

            //JAV 13/12/22: - QB 1.12.26 Se a�aden las Retenciones
        END ELSE IF pType = ApprovalEntry."QB Document Type"::Withholding THEN BEGIN
            txtXML += 'PAA/AHgAbQBsACAAdgBlAHIAcwBpAG8AbgA9ACIAMQAuADAAIgAgAGUAbgBjAG8AZABpAG4AZwA9ACIAdQB0AGYALQA4ACIAIABz';
            txtXML += 'AHQAYQBuAGQAYQBsAG8AbgBlAD0AIgB5AGUAcwAiAD8APgA8AFIAZQBwAG8AcgB0AFAAYQByAGEAbQBlAHQAZQByAHMAPgA8AEQA';
            txtXML += 'YQB0AGEASQB0AGUAbQBzAD4APABEAGEAdABhAEkAdABlAG0AIABuAGEAbQBlAD0AIgBUAGEAYgBsAGUANwAyADAANwAzADIAOQAi';
            txtXML += 'AD4AVgBFAFIAUwBJAE8ATgAoADEAKQAgAFMATwBSAFQASQBOAEcAKABGAGkAZQBsAGQAMQApACAAVwBIAEUAUgBFACgARgBpAGUA';
            txtXML += 'bABkADUAMAA9ADEAKAAwACkAKQA8AC8ARABhAHQAYQBJAHQAZQBtAD4APAAvAEQAYQB0AGEASQB0AGUAbQBzAD4APAAvAFIAZQBw';
            txtXML += 'AG8AcgB0AFAAYQByAGEAbQBlAHQAZQByAHMAPgA='
        END;
    END;

    PROCEDURE EditFlow(pCode: Code[20]);
    VAR
        QBApprovalCircuitHeader: Record 7206986;
        Workflow: Record 1501;
        pgWorkflow: Page 1501;
    BEGIN
        //------------------------------------------------------------------------------------------------------------------------
        //JAV 21/04/22: - QB 1.10.36 Editar un flujo de trabajo a partir de su c�digo
        //------------------------------------------------------------------------------------------------------------------------
        Workflow.RESET;
        Workflow.SETRANGE(Code, pCode);

        COMMIT; //Por el Run Modal
        CLEAR(pgWorkflow);
        pgWorkflow.SETTABLEVIEW(Workflow);
        pgWorkflow.RUNMODAL;
    END;

    LOCAL PROCEDURE "-------------------------------------- Nuevos circuitos de aprobaci¢n"();
    BEGIN
    END;

    PROCEDURE GetLastComment(rID: RecordID): Text;
    VAR
        ApprovalCommentLine: Record 455;
    BEGIN
        //------------------------------------------------------------------------------------------------------------------------
        //JAV 21/02/22: - QB 1.10.22 Retorna el �ltimo comentario sobre una aprobaci�n
        //------------------------------------------------------------------------------------------------------------------------
        ApprovalCommentLine.RESET;
        ApprovalCommentLine.SETRANGE("Record ID to Approve", rID);
        IF ApprovalCommentLine.FINDLAST THEN
            EXIT(ApprovalCommentLine.Comment)
        ELSE
            EXIT('');
    END;

    PROCEDURE GetLastDateTime(rID: RecordID): DateTime;
    VAR
        ApprovalEntry: Record 454;
    BEGIN
        //------------------------------------------------------------------------------------------------------------------------
        //JAV 21/02/22: - QB 1.10.22 Retorna la �ltima fecha en que se ha efectuado una acci�n sobre una aprobaci�n
        //------------------------------------------------------------------------------------------------------------------------
        ApprovalEntry.RESET;
        ApprovalEntry.SETRANGE("Record ID to Approve", rID);
        ApprovalEntry.SETFILTER(Status, '%1|%2|%3', ApprovalEntry.Status::Approved, ApprovalEntry.Status::Canceled, ApprovalEntry.Status::Rejected);
        IF ApprovalEntry.FINDLAST THEN
            EXIT(ApprovalEntry."Last Date-Time Modified")
        ELSE
            EXIT(CREATEDATETIME(0D, 0T));
    END;

    PROCEDURE GetLastStatus(rID: RecordID; Status: Option): Text;
    VAR
        ApprovalEntry: Record 454;
    BEGIN
        //------------------------------------------------------------------------------------------------------------------------
        //JAV 21/02/22: - QB 1.10.22 Retorna la �ltima fecha en que se ha efectuado una acci�n sobre una aprobaci�n y el usuario
        //------------------------------------------------------------------------------------------------------------------------
        ApprovalEntry.RESET;
        ApprovalEntry.SETRANGE("Record ID to Approve", rID);
        ApprovalEntry.SETRANGE(Withholding, TRUE);
        IF ApprovalEntry.FINDLAST THEN
            IF (ApprovalEntry.Status = ApprovalEntry.Status::Open) THEN
                EXIT('Retenida por ' + ApprovalEntry."Approver ID");

        ApprovalEntry.RESET;
        ApprovalEntry.SETRANGE("Record ID to Approve", rID);
        ApprovalEntry.SETRANGE(Status, ApprovalEntry.Status::Open);
        IF ApprovalEntry.FINDLAST THEN
            EXIT('Pendiente por ' + ApprovalEntry."Approver ID");

        ApprovalEntry.RESET;
        ApprovalEntry.SETRANGE("Record ID to Approve", rID);
        IF ApprovalEntry.FINDLAST THEN BEGIN
            IF (ApprovalEntry.Status = ApprovalEntry.Status::Canceled) THEN
                EXIT('Aprobaci�n Cancelada');

            IF (ApprovalEntry.Status = ApprovalEntry.Status::Rejected) THEN
                EXIT('Rechazado por ' + ApprovalEntry."Last Modified By User ID"); //PSM 04/05/22: - QB 1.10.40 Se cambia el usuario a presentar del "Approved ID" al "Last Modified By User ID"

            IF (Status = 0) THEN  //Si ha sido cancelado o rechazado mantengo el estado aunque ahora eswt� abierto de nuevo, pero no lo puedo poner nunca como aprobado
                EXIT('');

            IF (ApprovalEntry.Status = ApprovalEntry.Status::Approved) THEN
                EXIT('Aprobado');
        END;

        EXIT('');
    END;

    PROCEDURE CheckApprovalCircuit(pJobOrDep: Code[20]; pCircuit: Code[20]): Boolean;
    VAR
        QBApprovalCircuitHeader: Record 7206986;
        QBApprovalCircuitLines: Record 7206987;
    BEGIN
        //------------------------------------------------------------------------------------------------------------------------
        //JAV 22/02/22: - QB 1.10.22 Verifica el circuito de aprobaci�n antes de lanzarlo
        //------------------------------------------------------------------------------------------------------------------------
        IF (pCircuit = '') THEN
            ERROR('No ha definido un circuito de aprobaci�n para este documento');

        IF NOT QBApprovalCircuitHeader.GET(pCircuit) THEN
            ERROR('No existe el circuito de aprobaci�n %1', pCircuit);


        //JAV 22/02/22: - QB 1.10.22 Verifica que todos los cargos obligatorios de un circuito est�n definidos en el proyecto
        CASE QBApprovalCircuitHeader."Approval By" OF
            //JAV 04/04/22: - QB 1.10.31 Para aprobaci�n por proyectos deben estar todos los cargos definidos en el proyecto
            QBApprovalCircuitHeader."Approval By"::Job:
                BEGIN
                    QBApprovalCircuitLines.RESET;
                    QBApprovalCircuitLines.SETRANGE("Circuit Code", pCircuit);
                    QBApprovalCircuitLines.SETRANGE(Optional, FALSE);
                    IF (QBApprovalCircuitLines.FINDSET) THEN
                        REPEAT
                            ExistChargeInJob(pJobOrDep, QBApprovalCircuitLines.Position); //JAV 22/04/22: - QB 1.10.36 Se cambia la funci�n GetChargeInJob por ExistChargeInJob que es mas adecuado
                        UNTIL (QBApprovalCircuitLines.NEXT = 0);
                END;

            //JAV 04/04/22: - QB 1.10.31 Para aprobaci�n por departamentos.   JAV 24/06/22: - QB 1.10.54 Se completa este tipo de aprobaciones
            QBApprovalCircuitHeader."Approval By"::Department:
                BEGIN
                    QBApprovalCircuitLines.RESET;
                    QBApprovalCircuitLines.SETRANGE("Circuit Code", pCircuit);
                    QBApprovalCircuitLines.SETRANGE(Optional, FALSE);
                    IF (QBApprovalCircuitLines.FINDSET) THEN
                        REPEAT
                            ExistChargeInDep(pJobOrDep, QBApprovalCircuitLines.Position);
                        UNTIL (QBApprovalCircuitLines.NEXT = 0);
                END;

            //JAV 04/04/22: - QB 1.10.31 Para aprobaci�n por usuarios deben estar todos definidos en las l�neas
            QBApprovalCircuitHeader."Approval By"::User:
                BEGIN
                    QBApprovalCircuitLines.RESET;
                    QBApprovalCircuitLines.SETRANGE("Circuit Code", pCircuit);
                    QBApprovalCircuitLines.SETRANGE(Optional, FALSE);
                    IF (QBApprovalCircuitLines.FINDSET) THEN
                        REPEAT
                            IF (QBApprovalCircuitLines.User = '') THEN
                                ERROR('No ha definido el usuario obligatorio %1 en el circuito %2', QBApprovalCircuitLines."Line Code", pCircuit)
                        UNTIL (QBApprovalCircuitLines.NEXT = 0);
                END;

        END;
    END;

    LOCAL PROCEDURE ExistChargeInJob(pJob: Code[20]; pPosition: Code[20]);
    VAR
        QBApprovalCircuitLines: Record 7206987;
        QBJobResponsible: Record 7206992;
    BEGIN
        //------------------------------------------------------------------------------------------------------------------------
        //JAV 22/02/22: - QB 1.10.22 Verifica que exista al menos un usuario asociado a un cargo de un proyecto
        //------------------------------------------------------------------------------------------------------------------------
        //JAV 22/04/22: - QB 1.10.36 Se filtran los que no intervienen en aprobaciones. Se cambia la funci�n GetChargeinJob por ExistChargeInJob que es mas adecuado
        QBJobResponsible.RESET;
        QBJobResponsible.SETRANGE(Type, QBJobResponsible.Type::Job);   //JAV 16/05/22: - QRE 1.00.15 Se filtra que sean solo responsables de tipo JOB
        QBJobResponsible.SETRANGE("Table Code", pJob);
        QBJobResponsible.SETRANGE(Position, pPosition);
        QBJobResponsible.SETRANGE("No in Approvals", FALSE); //JAV 22/04/22: - QB 1.10.36 Se filtran los que no intervienen en aprobaciones.
        IF NOT QBJobResponsible.FINDFIRST THEN
            ERROR('No ha definido en el proyecto %1 el cargo %2', pJob, pPosition);
        IF QBJobResponsible."User ID" = '' THEN
            ERROR('No ha definido en el proyecto %1 la persona para el cargo %2', pJob, pPosition);
    END;

    LOCAL PROCEDURE ExistChargeInDep(pDep: Code[20]; pPosition: Code[20]);
    VAR
        QBApprovalCircuitLines: Record 7206987;
        QBJobResponsible: Record 7206992;
    BEGIN
        //------------------------------------------------------------------------------------------------------------------------
        //JAV 24/06/22: - QB 1.10.54 Verifica que exista al menos un usuario asociado a un cargo en un departamento
        //------------------------------------------------------------------------------------------------------------------------
        QBJobResponsible.RESET;
        QBJobResponsible.SETRANGE(Type, QBJobResponsible.Type::Department);   //Solo los de tipo departamento
        QBJobResponsible.SETRANGE("Table Code", pDep);
        QBJobResponsible.SETRANGE(Position, pPosition);
        QBJobResponsible.SETRANGE("No in Approvals", FALSE);                  //Se filtran los que no intervienen en aprobaciones.
        IF NOT QBJobResponsible.FINDFIRST THEN
            ERROR('No ha definido en el departamento %1 el cargo %2', pDep, pPosition);
        IF QBJobResponsible."User ID" = '' THEN
            ERROR('No ha definido en el departamento %1 la persona para el cargo %2', pDep, pPosition);
    END;

    PROCEDURE ExistUserInJob(pUser: Text; pJob: Code[20]; pCircuit: Code[20]): Boolean;
    VAR
        QBApprovalCircuitLines: Record 7206987;
        QBJobResponsible: Record 7206992;
        Exist: Boolean;
    BEGIN
        //------------------------------------------------------------------------------------------------------------------------
        //JAV 12/08/22: - QB 1.11.02 Se a�ade la funci�n ExistUserInJob que retorna si un usuario tiene alg�n rol en un proyecto para un circuito
        //------------------------------------------------------------------------------------------------------------------------

        Exist := FALSE;
        QBJobResponsible.RESET;
        QBJobResponsible.SETRANGE(Type, QBJobResponsible.Type::Job);   //Solo para registros de tipo JOB
        QBJobResponsible.SETRANGE("User ID", pUser);
        QBJobResponsible.SETRANGE("Table Code", pJob);
        IF (QBJobResponsible.FINDSET(FALSE)) THEN
            REPEAT
                QBApprovalCircuitLines.RESET;
                QBApprovalCircuitLines.SETRANGE("Circuit Code", pCircuit);
                QBApprovalCircuitLines.SETRANGE(Position, QBJobResponsible.Position);
                Exist := (NOT QBApprovalCircuitLines.ISEMPTY);
            UNTIL (QBJobResponsible.NEXT = 0) OR (Exist);

        EXIT(Exist);
    END;

    LOCAL PROCEDURE GetChargeInCircuit(VAR tmpQBApprovalCircuitLines: Record 7206987; pUser: Text): Code[10];
    BEGIN
        //------------------------------------------------------------------------------------------------------------------------
        //JAV 22/02/22: - QB 1.10.22 Retorna el primer cargo del usuario en un circuito de aprobaci�n
        //------------------------------------------------------------------------------------------------------------------------
        tmpQBApprovalCircuitLines.RESET;
        tmpQBApprovalCircuitLines.SETCURRENTKEY("Circuit Code", "Approval Level");
        tmpQBApprovalCircuitLines.SETRANGE("tmp User", pUser);
        IF tmpQBApprovalCircuitLines.FINDFIRST THEN
            EXIT(tmpQBApprovalCircuitLines.Position)
        ELSE
            EXIT('');
    END;

    LOCAL PROCEDURE GetLevelInCircuit(VAR tmpQBApprovalCircuitLines: Record 7206987; pUser: Text; pPosition: Code[10]): Integer;
    BEGIN
        //------------------------------------------------------------------------------------------------------------------------
        //JAV 22/02/22: - QB 1.10.22 Retorna el nivel m�ximo del usuario asociado a un cargo de un proyecto
        //------------------------------------------------------------------------------------------------------------------------
        tmpQBApprovalCircuitLines.RESET;
        tmpQBApprovalCircuitLines.SETCURRENTKEY("Circuit Code", "Approval Level");
        tmpQBApprovalCircuitLines.SETRANGE("tmp User", pUser);
        tmpQBApprovalCircuitLines.SETRANGE(Position, pPosition);
        IF tmpQBApprovalCircuitLines.FINDFIRST THEN
            EXIT(tmpQBApprovalCircuitLines."Approval Level")
        ELSE
            EXIT(0);
    END;

    LOCAL PROCEDURE GetSufficientApprover(VAR tmpQBApprovalCircuitLines: Record 7206987; pUser: Text; pAmount: Decimal): Boolean;
    BEGIN
        //------------------------------------------------------------------------------------------------------------------------
        //JAV 22/02/22: - QB 1.10.22 Retorna si el usuario puede aprobar ese importe o necesita mas aprobadores
        //------------------------------------------------------------------------------------------------------------------------
        tmpQBApprovalCircuitLines.RESET;
        tmpQBApprovalCircuitLines.SETCURRENTKEY("Circuit Code", "Approval Level");
        tmpQBApprovalCircuitLines.SETRANGE("tmp User", pUser);
        IF tmpQBApprovalCircuitLines.FINDFIRST THEN
            EXIT((tmpQBApprovalCircuitLines."Approval Limit" >= pAmount) OR (tmpQBApprovalCircuitLines."Approval Unlim."))
        ELSE
            EXIT(FALSE);
    END;

    PROCEDURE GetApprovalCircuit(VAR recRef: RecordRef; ActualCircuit: Code[20]): Code[20];
    VAR
        QBApprovalCircuitHeader: Record 7206986;
        QBApprovalsSetup: Record 7206994;
        ApprovalEntry: Record 454;
        Circuit: Code[20];
        DocumentType: Option;
        JobNo: Code[20];
        BudgetItem: Code[20];
        Department: Code[20];
        Amount: Decimal;
        AmountDL: Decimal;
        ApprovalDocumentType: Integer;
        ByJob: Boolean;
        ByDepartment: Boolean;
        ByUser: Boolean;
        AppBy: Option;
        i: Integer;
        evJob: Boolean;
        evCA: Boolean;
        evDep: Boolean;
        Buscar: Boolean;
        QuoBuildingSetup: Record 7207278;
        JobPiecework: Record 7207386;
    BEGIN
        //------------------------------------------------------------------------------------------------------------------------
        //JAV 22/02/22: - QB 1.10.22 Establecer el circuito de aprobaci�n para el documento
        //------------------------------------------------------------------------------------------------------------------------

        GetData(recRef, JobNo, BudgetItem, Department, Circuit, DocumentType, Amount, AmountDL);

        //Obtengo el tipo de aprobaci�n del documento, no est� alineado con la tabla de aprobaciones por desgracia
        CASE DocumentType OF
            // ApprovalEntry."QB Document Type"::" ":
            //     ApprovalDocumentType := QBApprovalCircuitHeader."Document Type"::" ";        //No se considera
            ApprovalEntry."QB Document Type"::Job:
                ApprovalDocumentType := QBApprovalCircuitHeader."Document Type"::JobBudget;
            ApprovalEntry."QB Document Type"::Comparative:
                ApprovalDocumentType := QBApprovalCircuitHeader."Document Type"::Comparative;
            ApprovalEntry."QB Document Type"::Payment:
                ApprovalDocumentType := QBApprovalCircuitHeader."Document Type"::Payments;
            // ApprovalEntry."QB Document Type"::PaymentDueCert:
            //     ApprovalDocumentType := QBApprovalCircuitHeader."Document Type"::"30";       //No se considera
            ApprovalEntry."QB Document Type"::Worksheet:
                ApprovalDocumentType := QBApprovalCircuitHeader."Document Type"::WorkSheet;
            ApprovalEntry."QB Document Type"::Expense:
                ApprovalDocumentType := QBApprovalCircuitHeader."Document Type"::ExpenseNote;
            ApprovalEntry."QB Document Type"::Measeurement:
                ApprovalDocumentType := QBApprovalCircuitHeader."Document Type"::Certification;
            ApprovalEntry."QB Document Type"::Transfer:
                ApprovalDocumentType := QBApprovalCircuitHeader."Document Type"::Transfers;
            ApprovalEntry."QB Document Type"::Purchase:
                ApprovalDocumentType := QBApprovalCircuitHeader."Document Type"::PurchaseOrder;
            ApprovalEntry."QB Document Type"::PurchaseInvoice:
                ApprovalDocumentType := QBApprovalCircuitHeader."Document Type"::PurchaseInvoice;
            ApprovalEntry."QB Document Type"::"Payment Order":
                ApprovalDocumentType := QBApprovalCircuitHeader."Document Type"::PaymentOrder;
            ApprovalEntry."QB Document Type"::PurchaseCredirMemo:
                ApprovalDocumentType := QBApprovalCircuitHeader."Document Type"::PurchaseCrMemo;
            ApprovalEntry."QB Document Type"::Budget:
                ApprovalDocumentType := QBApprovalCircuitHeader."Document Type"::Budget;
            ApprovalEntry."QB Document Type"::Prepayment:
                ApprovalDocumentType := QBApprovalCircuitHeader."Document Type"::Prepayment;    //JAV 31/03/22: - QB 1.10.29 Nuevo tipo para anticipos
            ApprovalEntry."QB Document Type"::Withholding:
                ApprovalDocumentType := QBApprovalCircuitHeader."Document Type"::Withholding;   //JAV 13/12/22: - QB 1.12.26 Nuevo tipo para retenciones
        END;

        //JAV 04/04/22: - QB 1.10.31 Se cambian campos de aprobaciones a la nueva tabla de configuraci�n de aprobaciones
        QBApprovalsSetup.GET;


        //JAV 04/04/22: - QB 1.10.31 Obtengo la forma de aprobar a partir de la configuraci�n y del tipo de documento
        CASE ApprovalDocumentType OF
            QBApprovalCircuitHeader."Document Type"::JobBudget:
                AppBy := QBApprovalsSetup."Approvals 01 Type";
            QBApprovalCircuitHeader."Document Type"::Comparative:
                AppBy := QBApprovalsSetup."Approvals 02 Type";
            QBApprovalCircuitHeader."Document Type"::PurchaseOrder:
                AppBy := QBApprovalsSetup."Approvals 03 Type";
            QBApprovalCircuitHeader."Document Type"::PurchaseInvoice:
                AppBy := QBApprovalsSetup."Approvals 04 Type";
            QBApprovalCircuitHeader."Document Type"::Certification:
                AppBy := QBApprovalsSetup."Approvals 05 Type";
            QBApprovalCircuitHeader."Document Type"::Payments:
                AppBy := QBApprovalsSetup."Approvals 06 Type";
            QBApprovalCircuitHeader."Document Type"::ExpenseNote:
                AppBy := QBApprovalsSetup."Approvals 07 Type";
            QBApprovalCircuitHeader."Document Type"::WorkSheet:
                AppBy := QBApprovalsSetup."Approvals 08 Type";
            QBApprovalCircuitHeader."Document Type"::Transfers:
                AppBy := QBApprovalsSetup."Approvals 09 Type";
            QBApprovalCircuitHeader."Document Type"::PurchaseCrMemo:
                AppBy := QBApprovalsSetup."Approvals 10 Type";
            QBApprovalCircuitHeader."Document Type"::Budget:
                AppBy := QBApprovalsSetup."Approvals 11 Type";
            QBApprovalCircuitHeader."Document Type"::Prepayment:
                AppBy := QBApprovalsSetup."Approvals 12 Type";
            QBApprovalCircuitHeader."Document Type"::Withholding:
                AppBy := QBApprovalsSetup."Approvals 14 Type";   //JAV 13/12/22: - QB 1.12.26 Nuevo tipo para retenciones
            QBApprovalCircuitHeader."Document Type"::PaymentOrder:
                AppBy := QBApprovalsSetup."Approvals 20 Type";
        END;

        //JAV 24/06/22: - QB 1.10.54 La aprobaci�n por usuarios usa los mismos condicionantes del proyecto
        ByJob := (AppBy = QBApprovalsSetup."Approvals 01 Type"::Job) OR (AppBy = QBApprovalsSetup."Approvals 01 Type"::User);
        ByDepartment := (AppBy = QBApprovalsSetup."Approvals 01 Type"::Department);
        //ByUser       := (AppBy = QBApprovalsSetup."Approvals 01 Type"::User);
        //IF (ByUser) THEN  //La aprobaci�n por usuarios no puede establecerse desde aqu�
        //  EXIT(ActualCircuit);

        //JAV 07/04/22: - QB 1.10.33 Cambio de la forma de procesar los circuitos para obtener el mas adecuado

        //PSM 23/01/23 Q18811-
        QuoBuildingSetup.GET();
        IF NOT QuoBuildingSetup."QB_QPR Create Dim.Value" THEN BEGIN
            IF (JobNo <> '') AND (BudgetItem <> '') THEN BEGIN
                JobPiecework.RESET;
                IF JobPiecework.GET(JobNo, BudgetItem) THEN
                    IF JobPiecework."QPR AC" <> BudgetItem THEN
                        BudgetItem := JobPiecework."QPR AC";
            END;
        END;
        //PSM 23/01/23 Q18811+

        //Evaluamos seg�n los criterios deseados
        i := 0;
        REPEAT
            i += 1;

            CASE i OF
                1: //Primero el mas restrictivo con todos los criterios posibles
                    BEGIN
                        Buscar := TRUE;
                        evJob := ByJob;
                        evCA := ByJob;
                        evDep := ByDepartment;
                    END;
                2: //Segundo por el primer criterio seleccionado (solo se aplica si es por proyectos, no por departamentos)
                    BEGIN
                        Buscar := ByJob;
                        IF (QBApprovalsSetup."Evaluation Order" = QBApprovalsSetup."Evaluation Order"::"Job/CA") THEN BEGIN
                            evJob := ByJob;
                            evCA := FALSE;
                        END ELSE BEGIN
                            evJob := FALSE;
                            evCA := ByJob;
                        END;
                    END;
                3: //Tercero por el criterio contrario (solo se aplica si es por proyectos, no por departamentos)
                    BEGIN
                        Buscar := ByJob;
                        IF (QBApprovalsSetup."Evaluation Order" = QBApprovalsSetup."Evaluation Order"::"CA/Job") THEN BEGIN
                            evJob := ByJob;
                            evCA := FALSE;
                        END ELSE BEGIN
                            evJob := FALSE;
                            evCA := ByJob;
                        END;
                    END;
                4: //Por �ltimo sin criterios
                    BEGIN
                        Buscar := TRUE;
                        evJob := FALSE;
                        evCA := FALSE;
                        evDep := FALSE;
                    END;
                ELSE  //Ya no hay mas criterios, salimos sin mas
                    i := 0;
            END;

            //Buscar en la tabla
            IF (Buscar) THEN BEGIN
                QBApprovalCircuitHeader.RESET;
                QBApprovalCircuitHeader.SETRANGE("Document Type", ApprovalDocumentType);

                IF (evJob) THEN
                    QBApprovalCircuitHeader.SETRANGE("Job No.", JobNo)          //Si aprobamos por proyecto aqu� va el proyecto
                ELSE
                    QBApprovalCircuitHeader.SETFILTER("Job No.", '=%1', '');

                IF (evCA) THEN
                    QBApprovalCircuitHeader.SETRANGE(CA, BudgetItem)            //Si aprobamos por proyecto aqu� va el CA=Partida presupuestaria
                ELSE
                    QBApprovalCircuitHeader.SETFILTER(CA, '=%1', '');

                IF (evDep) THEN
                    QBApprovalCircuitHeader.SETRANGE(Department, Department)    //En aprobaciones por departamento aqu� est� este
                ELSE
                    QBApprovalCircuitHeader.SETFILTER(Department, '=%1', '');

                IF (QBApprovalCircuitHeader.FINDFIRST) THEN BEGIN
                    EXIT(QBApprovalCircuitHeader."Circuit Code")
                END;
            END;
        UNTIL (i = 0);
        /*{---
              //Primero el mas restrictivo con mas criterios
              QBApprovalCircuitHeader.RESET;
              QBApprovalCircuitHeader.SETRANGE("Document Type", ApprovalDocumentType);
              IF (ByDepartment) THEN
                QBApprovalCircuitHeader.SETRANGE(Department, JobNo)
              ELSE
                QBApprovalCircuitHeader.SETRANGE("Job No.", JobNo);
              QBApprovalCircuitHeader.SETRANGE(CA, BudgetItem);
              IF (QBApprovalCircuitHeader.FINDFIRST) THEN BEGIN
                EXIT(QBApprovalCircuitHeader."Circuit Code")
              END;

              //Ahora seg�n el primer criterio
              QBApprovalCircuitHeader.RESET;
              QBApprovalCircuitHeader.SETRANGE("Document Type", ApprovalDocumentType);
              IF (QBApprovalsSetup."Evaluation Order" = QBApprovalsSetup."Evaluation Order"::"CA/Job") THEN BEGIN
                QBApprovalCircuitHeader.SETRANGE(CA, BudgetItem);
                QBApprovalCircuitHeader.SETFILTER("Job No.", '=%1', '');
                QBApprovalCircuitHeader.SETFILTER(Department, '=%1', '');
              END ELSE BEGIN
                QBApprovalCircuitHeader.SETFILTER(CA, '=%1', '');
                IF (ByDepartment) THEN
                  QBApprovalCircuitHeader.SETRANGE(Department, JobNo)
                ELSE
                  QBApprovalCircuitHeader.SETRANGE("Job No.", JobNo);
              END;
              IF (QBApprovalCircuitHeader.FINDFIRST) THEN BEGIN
                EXIT(QBApprovalCircuitHeader."Circuit Code")
              END;

              //Ahora seg�n el segundo criterio
              QBApprovalCircuitHeader.RESET;
              QBApprovalCircuitHeader.SETRANGE("Document Type", ApprovalDocumentType);
              IF (QBApprovalsSetup."Evaluation Order" = QBApprovalsSetup."Evaluation Order"::"Job/CA") THEN BEGIN
                QBApprovalCircuitHeader.SETFILTER(CA, '=%1', '');
                IF (ByDepartment) THEN
                  QBApprovalCircuitHeader.SETRANGE(Department, JobNo)
                ELSE
                  QBApprovalCircuitHeader.SETRANGE("Job No.", JobNo);
              END ELSE BEGIN
                QBApprovalCircuitHeader.SETRANGE(CA, BudgetItem);
                QBApprovalCircuitHeader.SETFILTER("Job No.", '=%1', '');
                QBApprovalCircuitHeader.SETFILTER(Department, '=%1', '');
              END;
              IF (QBApprovalCircuitHeader.FINDFIRST) THEN BEGIN
                EXIT(QBApprovalCircuitHeader."Circuit Code")
              END;

              //Por �ltimo sin criterios
              QBApprovalCircuitHeader.RESET;
              QBApprovalCircuitHeader.SETRANGE("Document Type", ApprovalDocumentType);
              QBApprovalCircuitHeader.SETFILTER(CA, '=%1', '');
              QBApprovalCircuitHeader.SETFILTER("Job No.", '=%1', '');
              QBApprovalCircuitHeader.SETFILTER(Department, '=%1', '');
              IF (QBApprovalCircuitHeader.FINDFIRST) THEN BEGIN
                EXIT(QBApprovalCircuitHeader."Circuit Code")
              END;
              ---}*/

        //JAV 04/04/22: - Si no encuentro ninguno, mantengo el actual
        EXIT(ActualCircuit);
    END;

    LOCAL PROCEDURE "-------------------------------------- Cargar la lista de responsables de un proyecto desde las plantillas"();
    BEGIN
    END;

    PROCEDURE CreateResponsiblesFromTemplate(Type: Option "Jobs","Departments"; RecordID: Code[20]; pEliminar: Boolean);
    VAR
        Job: Record 167;
        QBJobResponsiblesTemplate: Record 7206991;
        QBJobResponsiblesGroupTem: Record 7206990;
        QBJobResponsiblesTempSelec: Page 7207046;
        ResponsiblesTemplatesDefine: Page 7206908;
    BEGIN
        //------------------------------------------------------------------------------------------------------------------------
        //JAV 28/01/20: - Nueva funci¢n "CreateResponsiblesFromTemplate" para crear los responsables a partir de las plantillas
        //------------------------------------------------------------------------------------------------------------------------
        //JAV 24/02/22: - QB 1.10.22 Se ajusta al nuevo sistema de aprobaciones

        IF (RecordID = '') OR (NOT GUIALLOWED) THEN    //Si no tiene todav¡a c¢digo o no estamos presentando la pantalla, salimos directamente
            EXIT;

        COMMIT; //Antes del RunModal para evitar errores

        //JAV 10/02/22: - QB 1.10.19 Si hay mas de una plantilla, primero deben seleccionarla
        //JAV 31/08/21: - QB 1.09.99 Filtrar por los tipos
        QBJobResponsiblesGroupTem.RESET;
        CASE Type OF
            Type::Jobs:
                BEGIN
                    Job.GET(RecordID);
                    CASE Job."Card Type" OF
                        Job."Card Type"::Estudio:
                            QBJobResponsiblesGroupTem.SETFILTER("Use in", '%1|%2|%3', QBJobResponsiblesGroupTem."Use in"::All, QBJobResponsiblesGroupTem."Use in"::Quotes, QBJobResponsiblesGroupTem."Use in"::"Quotes&Jobs");
                        Job."Card Type"::"Proyecto operativo":
                            QBJobResponsiblesGroupTem.SETFILTER("Use in", '%1|%2|%3', QBJobResponsiblesGroupTem."Use in"::All, QBJobResponsiblesGroupTem."Use in"::"Operative Jobs", QBJobResponsiblesGroupTem."Use in"::"Quotes&Jobs");
                        Job."Card Type"::Presupuesto:
                            QBJobResponsiblesGroupTem.SETFILTER("Use in", '%1|%2', QBJobResponsiblesGroupTem."Use in"::All, QBJobResponsiblesGroupTem."Use in"::Budgets);
                        Job."Card Type"::Promocion:
                            QBJobResponsiblesGroupTem.SETFILTER("Use in", '%1|%2', QBJobResponsiblesGroupTem."Use in"::All, QBJobResponsiblesGroupTem."Use in"::RealEstate);
                    END;
                END;
            Type::Departments:
                BEGIN
                    // QBJobResponsiblesGroupTem.SETFILTER("Use in", '%1|%2', QBJobResponsiblesGroupTem."Use in"::All, QBJobResponsiblesGroupTem."Use in"::"4");
                END;
        END;

        CASE QBJobResponsiblesGroupTem.COUNT OF
            0:
                ERROR('No ha definido ninguna plantilla de responsables para este tipo de proyecto');
            1:
                QBJobResponsiblesGroupTem.FINDFIRST;
            ELSE BEGIN
                CLEAR(QBJobResponsiblesTempSelec);
                QBJobResponsiblesTempSelec.LOOKUPMODE(TRUE);
                QBJobResponsiblesTempSelec.SETTABLEVIEW(QBJobResponsiblesGroupTem);
                IF (QBJobResponsiblesTempSelec.RUNMODAL <> ACTION::LookupOK) THEN
                    EXIT;

                QBJobResponsiblesTempSelec.GETRECORD(QBJobResponsiblesGroupTem);
            END;
        END;

        //Ahora cargamos los responsables de esa plantilla
        CLEAR(ResponsiblesTemplatesDefine);
        ResponsiblesTemplatesDefine.OnOpen(Type, RecordID, QBJobResponsiblesGroupTem.Code, pEliminar);  //JAV 10/02/22: - QB 1.10.19 A�adimos la plantilla
        ResponsiblesTemplatesDefine.LOOKUPMODE(TRUE);
        ResponsiblesTemplatesDefine.RUNMODAL;
    END;

    LOCAL PROCEDURE "-------------------------------------- Copiar la cadena de aprobaci¢n de un documento a otro"();
    BEGIN
    END;

    PROCEDURE CopyApprovalChain(pSource: RecordID; pDestination: RecordID; pNewType: Option; pNewCode: Code[20]);
    VAR
        oApprovalEntry: Record 454;
        dApprovalEntry: Record 454;
        EntryNo: Integer;
        ApprovalPurchaseOrder: Codeunit 7206912;
        ApprovalPurchaseInvoice: Codeunit 7206913;
        ApprovalPurchaseCrMemo: Codeunit 7206928;
    BEGIN
        //------------------------------------------------------------------------------------------------------------------------
        //JAV 27/02/22: - QB 1.10.22 Copiar las aprobaciones de un documento a otro
        //------------------------------------------------------------------------------------------------------------------------

        //Busco el �ltimo n�mero de registro
        oApprovalEntry.RESET;
        IF (oApprovalEntry.FINDLAST) THEN
            EntryNo := oApprovalEntry."Entry No."
        ELSE
            EntryNo := 0;

        //Copio origen a destino cambiado los datos necesarios
        oApprovalEntry.RESET;
        oApprovalEntry.RESET;
        oApprovalEntry.SETRANGE("Record ID to Approve", pSource);
        IF (oApprovalEntry.FINDSET(FALSE)) THEN
            REPEAT
                EntryNo += 1;
                dApprovalEntry := oApprovalEntry;
                dApprovalEntry."Entry No." := EntryNo;
                dApprovalEntry."Record ID to Approve" := pDestination;
                dApprovalEntry."QB Document Type" := pNewType;
                //-17368 DGG
                dApprovalEntry."Table ID" := pDestination.TABLENO;
                dApprovalEntry."Document No." := pNewCode;
                CASE pNewType OF
                    dApprovalEntry."QB Document Type"::Purchase:
                        dApprovalEntry."Approval Code" := ApprovalPurchaseOrder.GetApprovalsText(0);
                    dApprovalEntry."QB Document Type"::PurchaseInvoice:
                        dApprovalEntry."Approval Code" := ApprovalPurchaseInvoice.GetApprovalsText(0);
                    dApprovalEntry."QB Document Type"::PurchaseCredirMemo:
                        dApprovalEntry."Approval Code" := ApprovalPurchaseCrMemo.GetApprovalsText(0);
                END;
                //17368
                dApprovalEntry.INSERT;
            UNTIL (oApprovalEntry.NEXT = 0);
    END;

    LOCAL PROCEDURE "-------------------------------------- Calcular el C¢digo y Nombre de Cliente/Proveedor de un movimiento de aprobaci¢n"();
    BEGIN
    END;

    PROCEDURE GetCustVendFromRecRef(rId: RecordID; VAR No: Text; VAR Name: Text);
    VAR
        recRef: RecordRef;
        CarteraDoc: Record 7000002;
        PostedCarteraDoc: Record 7000003;
        SalesHeader: Record 36;
        PurchaseHeader: Record 38;
        QBPrepayment: Record 7206928;
        Customer: Record 18;
        Vendor: Record 23;
    BEGIN
        //------------------------------------------------------------------------------------------------------------------------
        //CPA 16/03/22: - QB 1.10.27 (Q16730 Roig CyS) Retorna el c�digo del cliente o proveedor desde un registro a partir de su ID
        //------------------------------------------------------------------------------------------------------------------------

        No := '';
        Name := '';

        IF (NOT recRef.GET(rId)) THEN
            EXIT;

        CASE recRef.NUMBER OF
            DATABASE::"Purchase Header":
                BEGIN
                    recRef.SETTABLE(PurchaseHeader);
                    No := PurchaseHeader."Buy-from Vendor No.";
                    Name := PurchaseHeader."Pay-to Name";
                END;
            DATABASE::"Sales Header":
                BEGIN
                    recRef.SETTABLE(SalesHeader);
                    No := SalesHeader."Sell-to Customer No.";
                    Name := SalesHeader."Bill-to Name";
                END;
            DATABASE::Vendor:
                BEGIN
                    recRef.SETTABLE(Vendor);
                    No := Vendor."No.";
                    Name := Vendor.Name;
                END;
            DATABASE::Customer:
                BEGIN
                    recRef.SETTABLE(Customer);
                    No := Customer."No.";
                    Name := Customer.Name;
                END;
            DATABASE::"Cartera Doc.":
                BEGIN
                    recRef.SETTABLE(CarteraDoc);
                    CarteraDoc.CALCFIELDS("Vendor Name", "Customer Name");  //JAV 1.10.36: - QB 1.10.36 No se calculaban y no sal�an los nombres
                    No := CarteraDoc."Account No.";
                    CASE CarteraDoc.Type OF
                        CarteraDoc.Type::Payable:
                            Name := CarteraDoc."Vendor Name";
                        CarteraDoc.Type::Receivable:
                            Name := CarteraDoc."Customer Name";
                    END;
                END;
            DATABASE::"Posted Cartera Doc.":
                BEGIN
                    recRef.SETTABLE(PostedCarteraDoc);
                    CarteraDoc.CALCFIELDS("Vendor Name", "Customer Name");  //JAV 1.10.36: - QB 1.10.36 No se calculaban y no sal�an los nombres
                    No := PostedCarteraDoc."Account No.";
                    CASE CarteraDoc.Type OF
                        PostedCarteraDoc.Type::Payable:
                            Name := PostedCarteraDoc."Vendor Name";
                        PostedCarteraDoc.Type::Receivable:
                            Name := PostedCarteraDoc."Customer Name";
                    END;
                END;
            //JAV 04/04/22: - QB 1.10.31 Se a�aden los anticipos
            DATABASE::"QB Prepayment":
                BEGIN
                    recRef.SETTABLE(QBPrepayment);
                    No := QBPrepayment."Account No.";
                    Name := QBPrepayment."Account Description";
                END;

        //TO-DO A�adir el resto de tablas que se pueden aprobar con QB
        END;
    END;

    LOCAL PROCEDURE "---------------------------------------- Verificar que se puede registrar el documento por estar aprobado"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Codeunit, 90, OnBeforePostPurchaseDoc, '', true, true)]
    LOCAL PROCEDURE C90_OnBeforePostPurchaseDoc(VAR Sender: Codeunit 90; VAR PurchaseHeader: Record 38; PreviewMode: Boolean; CommitIsSupressed: Boolean);
    VAR
        ApprovalPurchaseOrder: Codeunit 7206912;
        ApprovalPurchaseInvoice: Codeunit 7206913;
        ApprovalPurchaseCrMemo: Codeunit 7206928;
        IsActive: Boolean;
    BEGIN
        //JAV 24/05/22: - QB 1.10.43 Controlar que est� aprobado el documento de compra antes de registrarlo
        CASE PurchaseHeader."Document Type" OF
            PurchaseHeader."Document Type"::Order:
                IsActive := (ApprovalPurchaseOrder.IsApprovalsWorkflowActive);
            PurchaseHeader."Document Type"::Invoice:
                IsActive := (ApprovalPurchaseInvoice.IsApprovalsWorkflowActive);
            PurchaseHeader."Document Type"::"Credit Memo":
                IsActive := (ApprovalPurchaseCrMemo.IsApprovalsWorkflowActive);
        END;

        IF (IsActive) AND (PurchaseHeader.Status <> PurchaseHeader.Status::Released) THEN BEGIN
            IF (PreviewMode) THEN
                MESSAGE('Recuerde que el documento no se podr� registra hasta que est� aprobado')
            ELSE
                ERROR('No puede registrar este documento antes de su aprobaci�n');
        END;
    END;

    LOCAL PROCEDURE "-------------------------------------- Gesti¢n de la Pila de solicitudes de aprobaci¢n"();
    BEGIN
    END;

    PROCEDURE CalcMyPendingApprovalsCompanies(pMsg: Boolean): Integer;
    VAR
        Company: Record 2000000006;
        ApprovalEntry: Record 454;
        vCount: Integer;
        Txt001: TextConst ESP = 'Consulte %1 solicitudes en la sociedad %2 %3';
        rAccessControl: Record 2000000053;
        rUser: Record 2000000120;
        vFiltroTxt: Text;
        tmpBuffer: Record 823 TEMPORARY;
        IdBuffer: Integer;
        FunctionQB: Codeunit 7207272;
    BEGIN
        // EPV 19/05/22 Se a�ade c�lculo multiempresa de las solicitudes de aprobaci�n
        vCount := 0;
        CLEAR(Company);
        Company.SETRANGE("Evaluation Company", FALSE);

        // EPV 30/09/22: - QB 1.11.03 Se a�ade filtro seg�n los permisos de acceso del usuario a las empresas.
        rAccessControl.RESET;
        rAccessControl.SETRANGE("Company Name", '');
        rAccessControl.SETRANGE("User Security ID", USERSECURITYID);
        // Si tiene alg�n permiso en la empresa "vac�a" es que puede entrar en cualquier empresa.
        IF (NOT rAccessControl.ISEMPTY) THEN BEGIN
            vFiltroTxt := '';
            CLEAR(tmpBuffer);
            rAccessControl.RESET;
            rAccessControl.SETRANGE("User Security ID", USERSECURITYID);
            // S�lo se analizan empresas de 4 caracteres (no las copias) para Culmia
            IF (FunctionQB.IsClient('CUL')) THEN
                rAccessControl.SETFILTER("Company Name", '????');
            IF rAccessControl.FINDSET THEN
                REPEAT
                    tmpBuffer.RESET;
                    tmpBuffer.SETRANGE(tmpBuffer.Name, rAccessControl."Company Name");
                    IF NOT tmpBuffer.FINDFIRST THEN BEGIN
                        tmpBuffer.RESET;
                        IF tmpBuffer.FINDLAST THEN
                            IdBuffer := tmpBuffer.ID + 1;
                        tmpBuffer.INIT;
                        tmpBuffer.ID := IdBuffer;
                        tmpBuffer.Name := rAccessControl."Company Name";
                        tmpBuffer.INSERT(TRUE);
                    END;
                UNTIL rAccessControl.NEXT = 0;

            tmpBuffer.RESET;
            IF tmpBuffer.FINDFIRST THEN
                REPEAT
                    IF vFiltroTxt = '' THEN
                        vFiltroTxt := tmpBuffer.Name
                    ELSE
                        vFiltroTxt := vFiltroTxt + '|' + tmpBuffer.Name;
                UNTIL tmpBuffer.NEXT = 0;

            // Asociamos el filtro calculado por empresas.
            Company.SETFILTER(Name, vFiltroTxt);
        END;

        IF Company.FINDSET THEN
            REPEAT
                CLEAR(ApprovalEntry);
                ApprovalEntry.CHANGECOMPANY(Company.Name);
                ApprovalEntry.SETCURRENTKEY("Approver ID", Status, "Due Date", "Date-Time Sent for Approval");
                ApprovalEntry.SETRANGE(Status, ApprovalEntry.Status::Open);
                ApprovalEntry.SETRANGE("Approver ID", USERID);
                vCount += ApprovalEntry.COUNT;

                // Mensaje que informa de las sociedades donde se encuentran las aprobaciones pendientes.
                IF pMsg THEN
                    IF ApprovalEntry.COUNT > 0 THEN
                        MESSAGE(Txt001, ApprovalEntry.COUNT, Company.Name, Company."Display Name");

            UNTIL Company.NEXT = 0;

        EXIT(vCount);
    END;

    /*BEGIN
/*{
      JAV 09/09/19: - Si se aprueba por un usuario en un nivel, se aprueban todos los movimientos de dicho nivel, ESTO VA CONTRA EL ESTANDAR, se deber�a mejorar
      JAV 05/02/20: - Se a�aden los eventos para aprobaciones en QuoBuilding, parte general
      JAV 24/12/20: - Substituci�n autom�tica de aprobadores
      JAV 28/04/20: - Mejora en los substitutos que son jefes de aprobaci�n
      JAV 27/02/22: - QB 1.10.22 Cambio en el sistema de aprobaciones, se cambia la tabla por completo
      JAV 21/03/22: - QB 1.10.26 Se a�ade el campo 12 "Approval By" para el tipo de condicionantes de la aprobaci�n proyecto o departamento
      CPA 16/03/22: - QB 1.10.27 (Q16730 Roig) Agregar una columna con el n�mero y nombre del proveedor en las pantallas de aprobaciones.
      JAV 24/03/22: - QB 1.10.27 Se a�aden permisos para la tabla para evitar errores con licencia del cliente
      JAV 31/03/22: - QB 1.10.29 Se a�aden anticipos. Se a�ade par�metro para pasar "Send App. Prepayment to Doc." a la configuraci�n
      JAV 04/04/22: - QB 1.10.31 Se cambian campos de aprobacines a la nueva tabla de configuraci�n de aprobaciones
      JAV 10/04/22: - QB 1.10.34 A�adir los flujos copiando de las plantillas est�ndar
                                 Evitar error de registro duplicado de aprobaciones vencidas al existir varia entradas con el mismo n�mero en "Secuence No."
      JAV 21/04/22: - QB 1.10.36 Se trae la funci�n PageApprovalRequestsOnOpenPage de la CU 7207349 para unificar. Se da permisos a la tabla "Mov. Aprobaci�n"
                                 Cambio en la forma de montar los flujos, dejar que cada CU monte el suyo propio usando un evento general
                                 Al crear los flujos a�ado un par�metro con la tabla a tratar y cambio nombres del resto para que est�n mas claros. A�ado los nuevos datos de configuraci�n de aprobaciones
                                 Editar un flujo de trabajo a partir de su c�digo
      JAV 22/04/22: - QB 1.10.36 Se filtran los que no intervienen en aprobaciones. Se cambia la funci�n GetChargeinJob por ExistChargeInJob que es mas adecuado
      PSM 04/05/22: - QB 1.10.36 En la funci�n GetLastStatus, poner el usuario que rechaz� realmente, no el �ltimo aprobador
      EPV 19/05/22: - Se a�ade un c�lculo multiempresa para conocer el n�mero de solicitudes de aprobaci�n pendientes
      JAV 24/05/22: - QB 1.10.43 Controlar que est� aprobado el documento de compra antes de registrarlo
      DGG 26/05/22: - QB 1.10.45 Se a�ade un par�metro mas a la funci�n "CopyApprovalChain" par�meto (pCode), para indicar el n�mero de documento.
                                 Se a�ade c�digo para que se informen todos los campos necesarios de forma adecuada.
      JAV 24/06/22: - QB 1.10.54 La aprobaci�n por usuarios usa los mismos condicionantes del proyecto
                                 Se eliminan las funciones que ya no se usan GetDepartmentsApprovalsData, SetDepartmentsApprovalsData, GetBudgetsApprovalsData, SetBudgetsApprovalsData
                                 Se completa la aprobaci�n por departamentos, se usa lo mismo que para proyectos en general, a�adiendo una funci�n ExistChargeInDep
      JAV 12/08/22: - QB 1.11.02 Se a�ade la funci�n ExistUserInJob que retorna si un usuario tiene alg�n rol en un proyecto para un circuito
      EPV 30/09/22: - QB 1.11.03 Se a�ade modificaci�n al c�lculo para ver las aprobaciones en todas las empresas
      JAV 03/11/22: - QB 1.12.12 Eliminamos el c�digo que a�ade datos al registro de la aprobaci�n, ya que no sirve realmente para nada, el proceso que crea los registros ya lo a�ade
      JAV 13/12/22: - QB 1.12.26 Se a�ade el manejo de las retenciones
      PSM 23/01/23: - Q18811 Se modifica el filtro de partida en aprobaciones, para empresas que no creen un valor CA igual a la partida
    }
END.*/
}







