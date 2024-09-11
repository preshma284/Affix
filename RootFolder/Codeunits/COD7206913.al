Codeunit 7206913 "Approval Purchase Invoice"
{


    trigger OnRun()
    BEGIN
    END;

    VAR
        TP: Option "Name","Description","SendCode","SendText","CancelCode","CancelText";

    LOCAL PROCEDURE "---------------------------------------------------------  Eventos que se lanzan"();
    BEGIN
    END;

    [IntegrationEvent(true,false)]
    PROCEDURE OnAfterSendApproval(VAR Rec: Record 38);
    BEGIN
    END;

    [IntegrationEvent(true,false)]
    PROCEDURE OnAfterReleaseDocument(VAR Rec: Record 38);
    BEGIN
    END;

    //[IntegrationEvent]
    PROCEDURE OnAfterReopenDocument(VAR Rec: Record 38);
    BEGIN
    END;

    //[IntegrationEvent]
    PROCEDURE OnAfterPerformManualReopenDoc(VAR Rec: Record 38);
    BEGIN
    END;

    LOCAL PROCEDURE "---------------------------------------------------------  Acciones"();
    BEGIN
    END;

    PROCEDURE Release(VAR Rec: Record 38);
    BEGIN
        //Pasar el estado a lanzado
        IF Rec.Status = Rec.Status::Released THEN
            EXIT;

        CheckAdditionalConditions(Rec);  //Verificar otras condiciones antes de poder lanzar

        Rec.Status := Rec.Status::Released;
        Rec.MODIFY(TRUE);

        //JAV 14/09/20: - QB 1.06.14 Calcular el vencimiento por fecha de aprobaci�n de la factura
        DueDateByApprovalDate(Rec);

        //JAV 23/02/22: - QB 1.20.22 Evento tras lanzar el documento
        OnAfterReleaseDocument(Rec);
    END;

    PROCEDURE Reopen(VAR Rec: Record 38);
    BEGIN
        //Volver al estado a abierto
        IF Rec.Status = Rec.Status::Open THEN
            EXIT;

        Rec.Status := Rec.Status::Open;
        Rec.MODIFY(TRUE);

        //JAV 23/02/22: - QB 1.20.22 Evento tras reabrir el documento
        OnAfterReopenDocument(Rec);
    END;

    PROCEDURE PerformManualRelease(VAR Rec: Record 38);
    VAR
        Text002: TextConst ENU = 'This document can only be released when the approval process is complete.', ESP = 'Este documento s�lo se puede lanzar una vez completado el proceso de aprobaci�n.';
    BEGIN
        //Pasar manualmente al estado lanzado
        IF (IsApprovalsWorkflowEnabled(Rec)) AND
           (Rec.Status = Rec.Status::Open) THEN
            ERROR(Text002);
        Release(Rec);
    END;

    PROCEDURE PerformManualReopen(VAR Rec: Record 38);
    VAR
        Text003: TextConst ENU = 'The approval process must be cancelled or completed to reopen this document.', ESP = 'El proceso de aprobaci�n se debe cancelar o completar para volver a abrir este documento.';
    BEGIN
        //Pasar manualmente al estado abierto
        IF Rec.Status = Rec.Status::"Pending Approval" THEN
            ERROR(Text003);
        Reopen(Rec);

        //JAV 10/08/22: - QB 1.11.01 Se lanza el evento a reabrir el documento
        OnAfterPerformManualReopenDoc(Rec);
    END;

    LOCAL PROCEDURE "---------------------------------------------------------  Manejo de la Page"();
    BEGIN
    END;

    PROCEDURE SetApprovalsControls(Rec: Record 38; VAR ApprovalsActive: Boolean; VAR OpenApprovalEntriesExistForCurrUser: Boolean; VAR CanRequestApproval: Boolean; VAR CanCancelApproval: Boolean; VAR CanRelease: Boolean; VAR CanReopen: Boolean);
    VAR
        ApprovalsMgmt: Codeunit 1535;
        WorkflowWebhookMgt: Codeunit 1543;
        OpenApprovalEntriesExist: Boolean;
        CanCancelApprovalForRecord: Boolean;
        CanRequestApprovalForFlow: Boolean;
        CanCancelApprovalForFlow: Boolean;
    BEGIN
        //Retorna variables para poner los controles de aprobaci�n visibles y/o activos
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RECORDID);
        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RECORDID);
        WorkflowWebhookMgt.GetCanRequestAndCanCancel(Rec.RECORDID, CanRequestApprovalForFlow, CanCancelApprovalForFlow);

        ApprovalsActive := IsApprovalsWorkflowActive();
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RECORDID);
        //DGG 24/05/22: - QRE-17064 Solo estar� activo el bot�n si el estado es abierto
        CanRequestApproval := ((NOT OpenApprovalEntriesExist) AND (CanRequestApprovalForFlow) AND ((Rec.Status = Rec.Status::Open)));
        //+17064
        CanCancelApproval := (CanCancelApprovalForRecord OR CanCancelApprovalForFlow);
        CanRelease := (Rec.Status = Rec.Status::Open);
        CanReopen := (Rec.Status = Rec.Status::Released);
    END;

    PROCEDURE ViewApprovals(Rec: Record 38);
    VAR
        QBApprovalManagement: Codeunit 7207354;
        RecRef: RecordRef;
    BEGIN
        //Desde la p�gina, ver los movimientos de aprobaci�n relacionados con el documento
        RecRef.GETTABLE(Rec);
        QBApprovalManagement.RunWorkflowEntriesPage(Rec.RECORDID, GetTableNumber, GetDocType, GetDocNumber(RecRef));
    END;

    PROCEDURE SendApproval(Rec: Record 38);
    VAR
        WorkflowManagement: Codeunit 1501;
        QBApprovalManagement: Codeunit 7207354;
        RecRef: RecordRef;
    BEGIN
        //Desde la p�gina, enviar solicitud de aprobaci�n

        //JAV 30/06/22: - QB 1.10.47 Si no tiene un circuito, lo buscamos antes de solicitar la aprobaci�n
        IF (Rec."QB Approval Circuit Code" = '') THEN
            SetApprovalCircuit(Rec);

        //JAV 12/03/22: - QB 1.10.24 Evento antes de solicitar aprobaci�n
        OnAfterSendApproval(Rec);

        //JAV 22/02/22: - QB 1.10.22 Verificar que todos los usuarios est�n definidos en el circuito
        RecRef.GETTABLE(Rec);
        QBApprovalManagement.CheckApprovalCircuit(GetJobCode(RecRef), GetCircuitCode(RecRef));

        //Lanzar la solicitud
        IF CheckApprovalPossible(Rec) THEN
            WorkflowManagement.HandleEvent(GetApprovalsText(TP::SendCode), Rec);
    END;

    PROCEDURE CancelApproval(Rec: Record 38);
    VAR
        WorkflowManagement: Codeunit 1501;
        WorkflowWebhookMgt: Codeunit 1543;
    BEGIN
        //Desde la p�gina, cancelar la solicitud de aprobaci�n
        WorkflowManagement.HandleEvent(GetApprovalsText(TP::CancelCode), Rec);
        WorkflowWebhookMgt.FindAndCancel(Rec.RECORDID);
    END;

    PROCEDURE WitHoldingApproval(Rec: Record 38);
    VAR
        QBApprovalManagement: Codeunit 7207354;
        ApprovalEntry: Record 454;
    BEGIN
        //Desde la p�gina, retener la solicitud de aprobaci�n
        IF (QBApprovalManagement.GetApprovalEntry(Rec.RECORDID, ApprovalEntry)) THEN
            QBApprovalManagement.OnWitHoldingRequest(ApprovalEntry);
    END;

    LOCAL PROCEDURE "---------------------------------------------------------  Respuestas a Eventos Est ndar"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Codeunit, 1520, OnAddWorkflowEventsToLibrary, '', true, true)]
    PROCEDURE OnAddWorkflowEventsToLibrary();
    VAR
        WorkflowEventHandling: Codeunit 1520;
    BEGIN
        //A�ade eventos a las cadenas de eventos de aprobaci�n
        WorkflowEventHandling.AddEventToLibrary(GetApprovalsText(TP::SendCode), GetTableNumber, GetApprovalsText(TP::SendText), 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(GetApprovalsText(TP::CancelCode), GetTableNumber, GetApprovalsText(TP::CancelText), 0, FALSE);
    END;

    [EventSubscriber(ObjectType::Codeunit, 1521, OnReleaseDocument, '', true, true)]
    PROCEDURE OnReleaseDocument(RecRef: RecordRef; VAR Handled: Boolean);
    VAR
        Rec: Record 38;
    BEGIN
        //Evento que se lanza para poder lanzar un documento
        IF (RecRef.NUMBER = GetTableNumber) THEN BEGIN
            RecRef.SETTABLE(Rec);
            IF (Rec."Document Type" = Rec."Document Type"::Invoice) THEN BEGIN  //Hay varios tipos de documento en la misma tabla
                PerformManualRelease(Rec);
                Handled := TRUE;
            END;
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 1521, OnOpenDocument, '', true, true)]
    PROCEDURE OnOpenDocument(RecRef: RecordRef; VAR Handled: Boolean);
    VAR
        Rec: Record 38;
    BEGIN
        //Evento que se lanza para poder volver a abrir un documento
        IF (RecRef.NUMBER = GetTableNumber) THEN BEGIN
            RecRef.SETTABLE(Rec);
            IF (Rec."Document Type" = Rec."Document Type"::Invoice) THEN BEGIN  //Hay varios tipos de documento en la misma tabla
                Reopen(Rec);
                Handled := TRUE;
            END;
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 1535, OnPopulateApprovalEntryArgument, '', true, true)]
    LOCAL PROCEDURE OnPopulateApprovalEntryArgument(VAR RecRef: RecordRef; VAR ApprovalEntryArgument: Record 454; WorkflowStepInstance: Record 1504);
    VAR
        ApprovalAmount: Decimal;
        ApprovalAmountLCY: Decimal;
        Rec: Record 38;
    BEGIN
        //Evento que se ejecuta desde el flujo para a�adir datos propios de QB a las aprobaciones
        IF (RecRef.NUMBER = GetTableNumber) THEN BEGIN
            RecRef.SETTABLE(Rec);
            IF (Rec."Document Type" = Rec."Document Type"::Invoice) THEN BEGIN  //Hay varios tipos de documento en la misma tabla
                                                                                //Parte com�n a todas las aprobaciones
                GetAmount(RecRef, ApprovalAmount, ApprovalAmountLCY);
                ApprovalEntryArgument."Document Type" := Enum::"Approval Document Type".FromInteger(30);
                ApprovalEntryArgument."QB Document Type" := GetDocType();
                ApprovalEntryArgument."Document No." := GetDocNumber(RecRef);
                ApprovalEntryArgument."Job No." := GetJobCode(RecRef);
                ApprovalEntryArgument.Amount := ApprovalAmount;
                ApprovalEntryArgument."Amount (LCY)" := ApprovalAmountLCY;
                //Se a�aden campos adicionales al registro para la aprobaci�n del documento
                ApprovalEntryArgument.Type := 'Factura compra';
                ApprovalEntryArgument."Payment Method Code" := Rec."Payment Method Code";
                ApprovalEntryArgument."Payment Terms Code" := Rec."Payment Terms Code";
                ApprovalEntryArgument."QB_Piecework No." := Rec."QB Approval Budget item";  //JAV 03/11/22: - QB 1.12.12 A�ado la partida presupuestaria de aprobaci�n
            END;
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 1535, OnSetStatusToPendingApproval, '', true, true)]
    LOCAL PROCEDURE OnSetStatusToPendingApproval(RecRef: RecordRef; VAR Variant: Variant; VAR IsHandled: Boolean);
    VAR
        Rec: Record 38;
    BEGIN
        //Evento que se ejecuta desde el flujo para marcar el documento como pendiente
        IF (RecRef.NUMBER = GetTableNumber) THEN BEGIN
            RecRef.SETTABLE(Rec);
            IF (Rec."Document Type" = Rec."Document Type"::Invoice) THEN BEGIN  //Hay varios tipos de documento en la misma tabla
                Rec.VALIDATE(Status, Rec.Status::"Pending Approval");
                Rec.MODIFY(TRUE);
                Variant := Rec;
                IsHandled := TRUE;
            END;
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 1535, OnRejectApprovalRequest, '', true, true)]
    LOCAL PROCEDURE OnRejectApprovalRequest(VAR ApprovalEntry: Record 454);
    VAR
        Text01: TextConst ESP = 'No puede rechazar el registro sin a�adir un nuevo comentario';
        RecID: RecordID;
        RecRef: RecordRef;
        fRef1: FieldRef;
        fRef2: FieldRef;
        Rec: Record 38;
        QBApprovalManagement: Codeunit 7207354;
    BEGIN
        RecID := ApprovalEntry."Record ID to Approve";
        IF (RecID.TABLENO = GetTableNumber) THEN BEGIN
            Rec.GET(RecID);
            IF (Rec."Document Type" = Rec."Document Type"::Invoice) THEN BEGIN  //Hay varios tipos de documento en la misma tabla
                ApprovalEntry.CALCFIELDS(Comment);
                IF NOT ApprovalEntry.Comment THEN
                    ERROR(Text01);
            END;
        END;
    END;

    // [EventSubscriber(ObjectType::Report, 1320, QB_OnSetReportFieldPlaceholders, '', true, true)]
    LOCAL PROCEDURE RP1320_QB_OnSetReportFieldPlaceholders(RecRef: RecordRef; VAR Field4Label: Text; VAR Field4Value: Text; VAR Field5Label: Text; VAR Field5Value: Text; VAR Field1Label: Text; VAR Field1Value: Text; VAR Field2Label: Text; VAR Field2Value: Text);
    VAR
        Rec: Record 38;
        Amount: Decimal;
        AmountLCY: Decimal;
        Job: Record 167;
        DataPieceworkForProduction: Record 7207386;
    BEGIN
        //------------------------------------------------------------------------------------------------------------------------
        //JAV 26/04/22: - QB 1.10.36 Retorna los datos para enviar el mail de aprobaci�n
        //------------------------------------------------------------------------------------------------------------------------
        IF (RecRef.NUMBER = GetTableNumber) THEN BEGIN
            RecRef.SETTABLE(Rec);
            IF (Rec."Document Type" = Rec."Document Type"::Invoice) THEN BEGIN  //Hay varios tipos de documento en la misma tabla

                IF (Rec.Status = Rec.Status::Released) THEN BEGIN
                    Field1Label := Rec.FIELDCAPTION("No.");
                    Field1Value := GetDocNumber(RecRef);
                    Field2Label := Rec.FIELDCAPTION("Posting Description");
                    Field2Value := Rec."Posting Description";
                END ELSE BEGIN
                    GetAmount(RecRef, Amount, AmountLCY);
                    Field1Label := Rec.FIELDCAPTION(Amount);
                    Field1Value := FORMAT(Amount);
                    Field2Label := 'Proveedor';
                    Field2Value := '(' + FORMAT(Rec."Buy-from Vendor No.") + ') ' + Rec."Buy-from Vendor Name";
                END;
            END;

            //JAV 01/06/22: - QB 1.10.46 A�adir en el mail el proyecto y la partida
            IF (NOT Job.GET(GetJobCode(RecRef))) THEN
                Job.INIT;
            IF (NOT DataPieceworkForProduction.GET(GetJobCode(RecRef), GetBudgetItemCode(RecRef))) THEN
                DataPieceworkForProduction.INIT;

            IF (GetJobCode(RecRef) <> '') THEN BEGIN
                Field4Label := 'Proyecto';
                Field4Value := GetJobCode(RecRef) + ' ' + Job.Description + ' ' + Job."Description 2";
            END ELSE BEGIN
                Field4Label := '';
                Field4Value := '';
            END;
            IF (GetBudgetItemCode(RecRef) <> '') THEN BEGIN
                Field5Label := 'Partida';
                Field5Value := GetBudgetItemCode(RecRef) + ' ' + DataPieceworkForProduction.Description + ' ' + DataPieceworkForProduction."Description 2";
            END ELSE BEGIN
                Field5Label := '';
                Field5Value := '';
            END;
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 1510, OnGetDocumentTypeAndNumber, '', true, true)]
    LOCAL PROCEDURE C1510_OnGetDocumentTypeAndNumber(VAR RecRef: RecordRef; VAR DocumentType: Text; VAR DocumentNo: Text; VAR IsHandled: Boolean);
    VAR
        Rec: Record 38;
    BEGIN
        //------------------------------------------------------------------------------------------------------------------------
        //JAV 26/04/22: - QB 1.10.36 Retorna los datos del documento para el mail de aprobaci�n
        //------------------------------------------------------------------------------------------------------------------------
        IF (RecRef.NUMBER = GetTableNumber) THEN BEGIN
            RecRef.SETTABLE(Rec);
            IF (Rec."Document Type" = Rec."Document Type"::Invoice) THEN BEGIN  //Hay varios tipos de documento en la misma tabla
                DocumentType := 'Factura de Compra';
                DocumentNo := GetDocNumber(RecRef);
                IsHandled := TRUE;
            END;
        END;
    END;

    LOCAL PROCEDURE "---------------------------------------------------------  Respuestas a Eventos Propios"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Codeunit, 7207354, OnWitHoldingRequest, '', true, true)]
    PROCEDURE OnWitHoldingRequest(VAR ApprovalEntry: Record 454);
    VAR
        ApprovalEntry2: Record 454;
        Rec: Record 38;
        Text01: TextConst ESP = 'No puede retener el registro sin a�adir un nuevo comentario';
        QBApprovalManagement: Codeunit 7207354;
        RecID: RecordID;
    BEGIN
        RecID := ApprovalEntry."Record ID to Approve";
        IF (RecID.TABLENO = GetTableNumber) THEN BEGIN
            Rec.GET(RecID);
            IF (Rec."Document Type" = Rec."Document Type"::Invoice) THEN BEGIN  //Hay varios tipos de documento en la misma tabla
                ApprovalEntry.CALCFIELDS(Comment);
                IF NOT ApprovalEntry.Comment THEN
                    ERROR(Text01);

                //Retiene todos los del mismo nivel
                ApprovalEntry2.RESET;
                ApprovalEntry2.SETCURRENTKEY("Table ID", "Document Type", "Document No.", "Sequence No.");
                ApprovalEntry2.SETRANGE("Table ID", ApprovalEntry."Table ID");
                ApprovalEntry2.SETRANGE("Document Type", ApprovalEntry."Document Type");
                ApprovalEntry2.SETRANGE("QB Document Type", ApprovalEntry."QB Document Type");
                ApprovalEntry2.SETRANGE("Document No.", ApprovalEntry."Document No.");
                ApprovalEntry2.SETRANGE("Sequence No.", ApprovalEntry."Sequence No.");
                ApprovalEntry2.SETFILTER(Status, '=%1', ApprovalEntry2.Status::Open);
                ApprovalEntry2.MODIFYALL(Withholding, TRUE);
            END;
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 7207354, MountFlowCircuit, '', true, true)]
    PROCEDURE MountFlowCircuit();
    VAR
        Text01: TextConst ESP = 'No puede retener el registro sin a�adir un nuevo comentario';
        QBApprovalManagement: Codeunit 7207354;
    BEGIN
        //JAV 21/04/22: - QB 1.10.36 Montar el flujo de trabajo para este tipo de documentos
        QBApprovalManagement.AddUnFlujo(GetDocType, GetTableNumber, GetApprovalsText(0), GetApprovalsText(1), GetApprovalsText(2), GetApprovalsText(4));
    END;

    [EventSubscriber(ObjectType::Codeunit, 7207354, OnGetDocNumber, '', true, true)]
    LOCAL PROCEDURE OnGetDocNumber(RecRef: RecordRef; VAR DocNumber: Code[20]);
    BEGIN
        //------------------------------------------------------------------------------------------------------------------------
        //JAV 26/04/22: - QB 1.10.36 Retorna el n�mero del documento
        //------------------------------------------------------------------------------------------------------------------------
        IF (RecRef.NUMBER = GetTableNumber) THEN
            DocNumber := GetDocNumber(RecRef);
    END;

    LOCAL PROCEDURE "---------------------------------------------------------  Funciones Est ndar"();
    BEGIN
    END;

    PROCEDURE IsApprovalsWorkflowActive(): Boolean;
    VAR
        WorkflowManagement: Codeunit 1501;
    BEGIN
        //Retorna si est� activa la aprobaci�n para este tipo de documentos
        EXIT(WorkflowManagement.EnabledWorkflowExist(GetTableNumber, GetApprovalsText(TP::SendCode)));
    END;

    PROCEDURE IsApprovalsWorkflowEnabled(VAR Rec: Record 38): Boolean;
    VAR
        WorkflowManagement: Codeunit 1501;
    BEGIN
        //Retorna si se puede solictar la aprobaci�n para este tipo de documentos
        EXIT(WorkflowManagement.CanExecuteWorkflow(Rec, GetApprovalsText(TP::SendCode)));
    END;

    PROCEDURE CheckApprovalPossible(VAR Rec: Record 38): Boolean;
    VAR
        NoWorkflowEnabledErr: TextConst ENU = 'No approval workflow for this record type is enabled.', ESP = 'No hay ning�n flujo de trabajo de aprobaci�n habilitado para este tipo de registro.';
        NothingToApproveErr: TextConst ENU = 'There is nothing to approve.', ESP = 'No hay nada que aprobar.';
    BEGIN
        //Retorna si es posible aprobar el documento de este tipo
        IF NOT IsApprovalsWorkflowEnabled(Rec) THEN
            ERROR(NoWorkflowEnabledErr);
        IF Rec.Status = Rec.Status::"Pending Approval" THEN
            ERROR(NothingToApproveErr);

        CheckAdditionalConditions(Rec);  //Verificar otras condiciones antes de poder lanzar

        EXIT(TRUE);
    END;

    PROCEDURE PrePostApprovalCheck(VAR Rec: Record 38): Boolean;
    VAR
        PrePostCheckErr: TextConst ENU = '%1 %2 must be approved and released before you can perform this action.', ESP = 'El documento %1 debe estar aprobado y lanzado antes de poder realizar esta acci�n.';
    BEGIN
        //Retorna si es posible lanzar el documento de este tipo
        IF (Rec.Status = Rec.Status::Open) AND IsApprovalsWorkflowEnabled(Rec) THEN
            ERROR(PrePostCheckErr, Rec."No.");
        EXIT(TRUE);
    END;

    LOCAL PROCEDURE "---------------------------------------------------------  Eventos QB para este tipo de documentos"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Codeunit, 7207354, GetData, '', true, true)]
    PROCEDURE GetData(RecRef: RecordRef; VAR pJob: Code[20]; VAR pBudgetItem: Code[20]; VAR pDepartment: Code[20]; VAR pCircuit: Code[20]; VAR pDocumentType: Option; VAR pAmount: Decimal; VAR pAmountDL: Decimal);
    VAR
        Rec: Record 38;
        AmountLCY: Decimal;
    BEGIN
        //Obtiene los datos del registro necesarios para las aprobaciones: Proyecto, circuito e Importes
        //JAV 25/06/22: - QB 1.10.54 Se a�ade el departamento y su proceso
        IF (RecRef.NUMBER = GetTableNumber) THEN BEGIN
            RecRef.SETTABLE(Rec);
            IF (Rec."Document Type" = Rec."Document Type"::Invoice) THEN BEGIN  //Hay varios tipos de documento en la misma tabla
                pJob := GetJobCode(RecRef);
                pBudgetItem := GetBudgetItemCode(RecRef);
                pDepartment := GetDepartmentCode(RecRef);
                pCircuit := GetCircuitCode(RecRef);
                pDocumentType := GetDocType;
                GetAmount(RecRef, pAmount, pAmountDL);
            END;
        END;
    END;

    LOCAL PROCEDURE "--------------------------------------------------------- Funciones espec¡ficas de este tipo de documento"();
    BEGIN
    END;

    LOCAL PROCEDURE GetDocType(): Integer;
    VAR
        ApprovalEntry: Record 454;
    BEGIN
        //Retorna el tipo de documento de la tabla de manejo de aprobaciones
        EXIT(ApprovalEntry."QB Document Type"::PurchaseInvoice);
    END;

    LOCAL PROCEDURE GetTableNumber(): Integer;
    BEGIN
        //Retorna el n�mero de la tabla que estamos tratando
        EXIT(DATABASE::"Purchase Header");
    END;

    PROCEDURE GetApprovalsText(pType: Integer): Text;
    VAR
        QBApprovalManagement: Codeunit 7207354;
        Txt: Text;
    BEGIN
        //Retorna las cadenas ajustadas al tipo de documento para las aprobaciones
        EXIT(QBApprovalManagement.GetApprovalsFixedText(pType, 'FACTURACOMPRA', 'una factura de compra'))
    END;

    LOCAL PROCEDURE GetDocNumber(RecRef: RecordRef): Code[20];
    VAR
        Rec: Record 38;
    BEGIN
        //Retorna el n�mero del documento
        RecRef.SETTABLE(Rec);
        EXIT(Rec."No.");
    END;

    LOCAL PROCEDURE GetJobCode(RecRef: RecordRef): Code[20];
    VAR
        Rec: Record 38;
    BEGIN
        //Retorna el c�digo del proyecto del documento
        RecRef.SETTABLE(Rec);
        //JAV 20/05/22: - QB 1.10.41 Se cambia la variable para el proyecto y partida de aprobaci�n
        //EXIT(Rec."QB Job No.");
        EXIT(Rec."QB Approval Job No");
    END;

    LOCAL PROCEDURE GetBudgetItemCode(RecRef: RecordRef): Code[20];
    VAR
        Rec: Record 38;
    BEGIN
        //Retorna el c�digo de la partida presupuestaria del documento
        RecRef.SETTABLE(Rec);
        //JAV 20/05/22: - QB 1.10.41 Se cambia la variable para el proyecto y partida de aprobaci�n
        //EXIT(Rec."QB Budget item");
        EXIT(Rec."QB Approval Budget item");
    END;

    LOCAL PROCEDURE GetDepartmentCode(RecRef: RecordRef): Code[20];
    VAR
        Rec: Record 38;
        FunctionQB: Codeunit 7207272;
    BEGIN
        //JAV 25/06/22: - QB 1.10.54 Retorna el c�digo del departamento asociado al documento
        RecRef.SETTABLE(Rec);
        EXIT(FunctionQB.ReturnDepartmentOrganization(Rec."Dimension Set ID"));
    END;

    LOCAL PROCEDURE GetCircuitCode(RecRef: RecordRef): Code[20];
    VAR
        Rec: Record 38;
    BEGIN
        //Retorna el c�digo del circuito de aprobaci�n del documento
        RecRef.SETTABLE(Rec);
        EXIT(Rec."QB Approval Circuit Code");
    END;

    LOCAL PROCEDURE GetAmount(RecRef: RecordRef; VAR Amount: Decimal; VAR AmountLCY: Decimal);
    VAR
        Rec: Record 38;
    BEGIN
        //Retorna los importes del documento
        RecRef.SETTABLE(Rec);
        Rec.CALCFIELDS(Amount);
        Amount := Rec.Amount;
        IF (Rec."Currency Code" = '') THEN
            AmountLCY := Amount
        ELSE
            AmountLCY := ROUND(Amount * Rec."Currency Factor", 0.01);
    END;

    LOCAL PROCEDURE SetApprovalCircuit(VAR Rec: Record 38);
    VAR
        QBApprovalManagement: Codeunit 7207354;
        RecRef: RecordRef;
    BEGIN
        //JAV 22/02/22: - QB 1.10.22 Establecer el circuito de aprobaci�n para el documento
        RecRef.GETTABLE(Rec);
        Rec."QB Approval Circuit Code" := QBApprovalManagement.GetApprovalCircuit(RecRef, Rec."QB Approval Circuit Code");  //JAV 04/04/22: - QB 1.10.31 A�adir par�metro con el valor actual
    END;

    LOCAL PROCEDURE CheckAdditionalConditions(Rec: Record 38);
    BEGIN
        //Verificar condiciones adicionales necesarias para verificar expresamente este tipo de documento
    END;

    LOCAL PROCEDURE "--------------------------------------------------------- Funciones propias de este tipo de documento"();
    BEGIN
    END;

    PROCEDURE DueDateByApprovalDate(VAR PurchaseHeader: Record 38);
    VAR
        QBCodeunitSubscriber: Codeunit 7207353;
        WithholdingTreating: Codeunit 7207306;
    BEGIN
        //Vencimiento por fecha de aprobaci�n
        IF (PurchaseHeader."QB Calc Due Date" = PurchaseHeader."QB Calc Due Date"::Approval) THEN BEGIN
            PurchaseHeader.VALIDATE("QB Due Date Base", WORKDATE);
            PurchaseHeader.MODIFY(TRUE);
        END;
    END;

    LOCAL PROCEDURE "--------------------------------------------------------- Condicionantes para seleccionar el circuito"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 38, OnAfterInitRecord, '', true, true)]
    LOCAL PROCEDURE T38_OnAfterInitRecord(VAR PurchHeader: Record 38);
    BEGIN
        IF (PurchHeader."Document Type" = PurchHeader."Document Type"::Invoice) THEN  //Hay varios tipos de documento en la misma tabla
            SetApprovalCircuit(PurchHeader);
    END;

    [EventSubscriber(ObjectType::Table, 38, OnAfterValidateEvent, "QB Approval Job No", true, true)]
    LOCAL PROCEDURE T38_OnAfterValidateEvent_JobNo(VAR Rec: Record 38; VAR xRec: Record 38; CurrFieldNo: Integer);
    BEGIN
        //JAV 20/05/22: - QB 1.10.41 Se cambia la variable para el proyecto y partida de aprobaci�n
        IF (Rec."Document Type" = Rec."Document Type"::Invoice) THEN  //Hay varios tipos de documento en la misma tabla
            SetApprovalCircuit(Rec);
    END;

    [EventSubscriber(ObjectType::Table, 38, OnAfterValidateEvent, "QB Approval Budget item", true, true)]
    LOCAL PROCEDURE T38_OnAfterValidateEvent_Budgetitem(VAR Rec: Record 38; VAR xRec: Record 38; CurrFieldNo: Integer);
    BEGIN
        //JAV 20/05/22: - QB 1.10.41 Se cambia la variable para el proyecto y partida de aprobaci�n
        IF (Rec."Document Type" = Rec."Document Type"::Invoice) THEN  //Hay varios tipos de documento en la misma tabla
            SetApprovalCircuit(Rec);
    END;


    /*BEGIN
    /*{
          JAV 23/02/22: - QB 1.20.22 Nuevo proceso de aprobaciones.
                                     Se lanzan los eventos OnAfterReleaseDocument y OnAfterReopenDocument tras lanzar o abrir el documento
          JAV 12/03/22: - QB 1.10.24 Evento antes de solicitar aprobaci�n
          JAV 21/04/22: - QB 1.10.36 Se a�ade la funci�n que se lanza con el evento global para montar el flujo de trabajo para este tipo de documentos
          JAV 26/04/22: - QB 1.10.36 Retorna los datos para enviar el mail de aprobado
          JAV 20/05/22: - QB 1.10.41 Se cambia la variable para el proyecto y partida de aprobaci�n
          DGG 24/05/22: - QRE-17064 Solo estar� activo el bot�n si el estado es abierto
          JAV 01/06/22: - QB 1.10.46 A�adir en el mail el proyecto tras el importe
          JAV 25/06/22: - QB 1.10.54 Se a�ade el departamento y su proceso
          JAV 30/06/22: - QB 1.10.47 Si no tiene un circuito, lo buscamos antes de solicitar la aprobaci�n. Se lanza el evento OnAfterSendApproval antes de solicitar aprobaci�n
          JAV 10/08/22: - QB 1.11.01 Se a�ade el evento OnAfterPerformManualReopenDoc y se lanza al reabrir el documento
          JAV 03/11/22: - QB 1.12.12 Para simplificar se elimina la funci�n AddAditionalApprovalEntryArgument y se pasa su c�digo dentro de OnPopulateApprovalEntryArgument
                                     Se a�ade la partida en el documento de aprobaci�n
        }
    END.*/
}









