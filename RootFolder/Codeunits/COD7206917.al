Codeunit 7206917 "Approval Cartera Doc"
{


    trigger OnRun()
    BEGIN
    END;

    VAR
        TP: Option "Name","Description","SendCode","SendText","CancelCode","CancelText";

    LOCAL PROCEDURE "---------------------------------------------------------  Eventos que se lanzan"();
    BEGIN
    END;

    //[IntegrationEvent]
    PROCEDURE OnAfterSendApproval(VAR Rec: Record 7000002);
    BEGIN
    END;

    //[IntegrationEvent]
    PROCEDURE OnAfterReleaseDocument(VAR Rec: Record 7000002);
    BEGIN
    END;

    //[IntegrationEvent]
    PROCEDURE OnAfterReopenDocument(VAR Rec: Record 7000002);
    BEGIN
    END;

    //[IntegrationEvent]
    PROCEDURE OnAfterPerformManualReopenDoc(VAR Rec: Record 7000002);
    BEGIN
    END;

    LOCAL PROCEDURE "---------------------------------------------------------  Acciones"();
    BEGIN
    END;

    PROCEDURE Release(VAR Rec: Record 7000002);
    BEGIN
        //Pasar el estado a lanzado
        IF Rec."Approval Status" = Rec."Approval Status"::Released THEN
            EXIT;

        CheckAdditionalConditionsPost(Rec);  //Verificar otras condiciones antes de poder lanzar

        CASE Rec."Approval Status" OF
            Rec."Approval Status"::Open, Rec."Approval Status"::"Pending Approval":
                Rec."Approval Status" := Rec."Approval Status"::Released;
            Rec."Approval Status"::"Due Open", Rec."Approval Status"::"Due Pending Approval":
                Rec."Approval Status" := Rec."Approval Status"::"Due Released";
        END;
        Rec.MODIFY(TRUE);

        //JAV 23/02/22: - QB 1.20.22 Evento tras lanzar el documento
        OnAfterReleaseDocument(Rec);
    END;

    PROCEDURE Reopen(VAR Rec: Record 7000002);
    BEGIN
        //Volver al estado a abierto
        IF Rec."Approval Status" = Rec."Approval Status"::Open THEN
            EXIT;

        CASE Rec."Approval Status" OF
            Rec."Approval Status"::Released, Rec."Approval Status"::"Pending Approval":
                Rec."Approval Status" := Rec."Approval Status"::Open;
            Rec."Approval Status"::"Due Released", Rec."Approval Status"::"Due Pending Approval":
                Rec."Approval Status" := Rec."Approval Status"::Released;
        END;
        Rec.MODIFY(TRUE);

        //JAV 23/02/22: - QB 1.20.22 Evento tras reabrir el documento
        OnAfterReopenDocument(Rec);
    END;

    PROCEDURE PerformManualRelease(VAR Rec: Record 7000002);
    VAR
        Text002: TextConst ENU = 'This document can only be released when the approval process is complete.', ESP = 'Este documento s�lo se puede lanzar una vez completado el proceso de aprobaci�n.';
    BEGIN
        //Pasar manualmente al estado lanzado
        IF (IsApprovalsWorkflowEnabled(Rec)) AND
           (Rec."Approval Status" IN [Rec."Approval Status"::Open, Rec."Approval Status"::"Due Open"]) AND
           (Rec."Job No." <> '') THEN
            ERROR(Text002);
        Release(Rec);
    END;

    PROCEDURE PerformManualReopen(VAR Rec: Record 7000002);
    VAR
        Text003: TextConst ENU = 'The approval process must be cancelled or completed to reopen this document.', ESP = 'El proceso de aprobaci�n se debe cancelar o completar para volver a abrir este documento.';
    BEGIN
        //Pasar manualmente al estado abierto
        IF (Rec."Approval Status" IN [Rec."Approval Status"::"Pending Approval", Rec."Approval Status"::"Due Pending Approval"]) THEN
            ERROR(Text003);
        Reopen(Rec);

        //JAV 10/08/22: - QB 1.11.01 Se lanza el evento a reabrir el documento
        OnAfterPerformManualReopenDoc(Rec);
    END;

    LOCAL PROCEDURE "---------------------------------------------------------  Manejo de la Page"();
    BEGIN
    END;

    PROCEDURE SetApprovalsControls(Rec: Record 7000002; VAR ApprovalsActive: Boolean; VAR OpenApprovalEntriesExistForCurrUser: Boolean; VAR CanRequestApproval: Boolean; VAR CanCancelApproval: Boolean; VAR CanRelease: Boolean; VAR CanReopen: Boolean; VAR CanRequestDueApproval: Boolean);
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
        CanRequestApproval := ((NOT OpenApprovalEntriesExist) AND (CanRequestApprovalForFlow) AND ((Rec."Approval Status" = Rec."Approval Status"::Open)));
        //+17064
        CanCancelApproval := (CanCancelApprovalForRecord OR CanCancelApprovalForFlow);
        CanRelease := (Rec."Approval Status" IN [Rec."Approval Status"::Open, Rec."Approval Status"::"Due Open"]);
        CanReopen := (Rec."Approval Status" IN [Rec."Approval Status"::Released, Rec."Approval Status"::"Due Released"]);

        CanRequestDueApproval := CheckDueApprovalPossible(Rec);
    END;

    PROCEDURE ViewApprovals(Rec: Record 7000002);
    VAR
        QBApprovalManagement: Codeunit 7207354;
        RecRef: RecordRef;
    BEGIN
        //Desde la p�gina, ver los movimientos de aprobaci�n relacionados con el documento
        RecRef.GETTABLE(Rec);
        QBApprovalManagement.RunWorkflowEntriesPage(Rec.RECORDID, GetTableNumber, GetDocType, GetDocNumber(RecRef));
    END;

    PROCEDURE SendApproval(Rec: Record 7000002);
    VAR
        WorkflowManagement: Codeunit 1501;
        QBApprovalManagement: Codeunit 7207354;
        RecRef: RecordRef;
    BEGIN
        //Desde la p�gina, enviar solicitud de aprobaci�n

        //JAV 30/06/22: - QB 1.10.47 Si no tiene un circuito, lo buscamos antes de solicitar la aprobaci�n
        IF (Rec."QB Approval Circuit Code" = '') THEN
            SetApprovalCircuit(Rec);

        //JAV 30/06/22: - QB 1.10.47 Evento antes de solicitar aprobaci�n
        OnAfterSendApproval(Rec);

        //JAV 26/05/22: - QB 1.10.44 Le establecemos el circuito de aprobaci�n al documento si no lo tiene informado
        IF (Rec."QB Approval Circuit Code" = '') THEN
            SetApprovalCircuit(Rec);

        //JAV 22/02/22: - QB 1.10.22 Verificar que todos los usuarios est�n definidos en el circuito
        RecRef.GETTABLE(Rec);
        QBApprovalManagement.CheckApprovalCircuit(GetJobCode(RecRef), GetCircuitCode(RecRef));

        //Lanzar la solicitud
        IF CheckApprovalPossible(Rec) THEN
            WorkflowManagement.HandleEvent(GetApprovalsText(TP::SendCode), Rec);
    END;

    PROCEDURE SendDueApproval(Rec: Record 7000002);
    VAR
        WorkflowManagement: Codeunit 1501;
    BEGIN
        //Desde la p�gina, enviar solicitud de aprobaci�n de certificado vencido
        IF (CheckDueApprovalPossible(Rec)) THEN BEGIN
            Rec."Approval Status" := Rec."Approval Status"::"Due Open";
            Rec.MODIFY;

            WorkflowManagement.HandleEvent(GetApprovalsText(TP::SendCode), Rec);
        END;
    END;

    PROCEDURE CancelApproval(Rec: Record 7000002);
    VAR
        WorkflowManagement: Codeunit 1501;
        WorkflowWebhookMgt: Codeunit 1543;
    BEGIN
        //Desde la p�gina, cancelar la solicitud de aprobaci�n
        WorkflowManagement.HandleEvent(GetApprovalsText(TP::CancelCode), Rec);
        WorkflowWebhookMgt.FindAndCancel(Rec.RECORDID);
    END;

    PROCEDURE WitHoldingApproval(Rec: Record 7000002);
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
        Rec: Record 7000002;
    BEGIN
        //Evento que se lanza para poder lanzar un documento
        IF (RecRef.NUMBER = GetTableNumber) THEN BEGIN
            RecRef.SETTABLE(Rec);
            IF (TRUE) THEN BEGIN  //No hay varios tipos de documento en la misma tabla
                PerformManualRelease(Rec);
                Handled := TRUE;
            END;
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 1521, OnOpenDocument, '', true, true)]
    PROCEDURE OnOpenDocument(RecRef: RecordRef; VAR Handled: Boolean);
    VAR
        Rec: Record 7000002;
    BEGIN
        //Evento que se lanza para poder volver a abrir un documento
        IF (RecRef.NUMBER = GetTableNumber) THEN BEGIN
            RecRef.SETTABLE(Rec);
            IF (TRUE) THEN BEGIN  //No hay varios tipos de documento en la misma tabla
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
        Rec: Record 7000002;
        QualityManagement: Codeunit 7207293;
        TxtCert: Text;
    BEGIN
        //Evento que se ejecuta desde el flujo para a�adir datos propios de QB a las aprobaciones
        IF (RecRef.NUMBER = GetTableNumber) THEN BEGIN
            RecRef.SETTABLE(Rec);
            IF (TRUE) THEN BEGIN  //No hay varios tipos de documento en la misma tabla
                                  //Parte com�n a todas las aprobaciones
                GetAmount(RecRef, ApprovalAmount, ApprovalAmountLCY);
               ApprovalEntryArgument."Document Type" := Enum::"Approval Document Type".FromInteger(30);
                ApprovalEntryArgument."QB Document Type" := GetDocType();
                ApprovalEntryArgument."Document No." := GetDocNumber(RecRef);
                ApprovalEntryArgument."Job No." := GetJobCode(RecRef);
                ApprovalEntryArgument.Amount := ApprovalAmount;
                ApprovalEntryArgument."Amount (LCY)" := ApprovalAmountLCY;
                //Se a�aden campos adicionales al registro para la aprobaci�n del documento
                IF (Rec."Approval Status" >= Rec."Approval Status"::"Due Open") THEN BEGIN
                    QualityManagement.VendorCertificatesDued(Rec."Account No.", TODAY, TxtCert);
                    ApprovalEntryArgument.Type := COPYSTR('Pago con Cert. Vencidos ' + TxtCert, 1, MAXSTRLEN(ApprovalEntryArgument.Type));
                END ELSE BEGIN
                    ApprovalEntryArgument.Type := 'Pago de factura';
                END;
                ApprovalEntryArgument."Payment Method Code" := '';
                ApprovalEntryArgument."Payment Terms Code" := '';
                ApprovalEntryArgument."QB_Piecework No." := Rec."QB Budget item";  //JAV 03/11/22: - QB 1.12.12 A�ado la partida presupuestaria de aprobaci�n
            END;
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 1535, OnSetStatusToPendingApproval, '', true, true)]
    LOCAL PROCEDURE OnSetStatusToPendingApproval(RecRef: RecordRef; VAR Variant: Variant; VAR IsHandled: Boolean);
    VAR
        Rec: Record 7000002;
    BEGIN
        //Evento que se ejecuta desde el flujo para marcar el documento como pendiente
        IF (RecRef.NUMBER = GetTableNumber) THEN BEGIN
            RecRef.SETTABLE(Rec);
            IF (TRUE) THEN BEGIN  //No hay varios tipos de documento en la misma tabla
                CASE Rec."Approval Status" OF
                    Rec."Approval Status"::Open, Rec."Approval Status"::Released:
                        Rec."Approval Status" := Rec."Approval Status"::"Pending Approval";
                    Rec."Approval Status"::"Due Open", Rec."Approval Status"::"Due Released":
                        Rec."Approval Status" := Rec."Approval Status"::"Due Pending Approval";
                END;
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
        Rec: Record 7000002;
        QBApprovalManagement: Codeunit 7207354;
    BEGIN
        RecID := ApprovalEntry."Record ID to Approve";
        IF (RecID.TABLENO = GetTableNumber) THEN BEGIN
            Rec.GET(RecID);
            IF (TRUE) THEN BEGIN  //No hay varios tipos de documento en la misma tabla
                ApprovalEntry.CALCFIELDS(Comment);
                IF NOT ApprovalEntry.Comment THEN
                    ERROR(Text01);
            END;
        END;
    END;

    // [EventSubscriber(ObjectType::Report, 1320, QB_OnSetReportFieldPlaceholders, '', true, true)]
    LOCAL PROCEDURE RP1320_QB_OnSetReportFieldPlaceholders(RecRef: RecordRef; VAR Field4Label: Text; VAR Field4Value: Text; VAR Field5Label: Text; VAR Field5Value: Text; VAR Field1Label: Text; VAR Field1Value: Text; VAR Field2Label: Text; VAR Field2Value: Text);
    VAR
        Rec: Record 7000002;
        Amount: Decimal;
        AmountLCY: Decimal;
        Vendor: Record 23;
        Job: Record 167;
        DataPieceworkForProduction: Record 7207386;
    BEGIN
        //------------------------------------------------------------------------------------------------------------------------
        //JAV 26/04/22: - QB 1.10.36 Retorna los datos para enviar el mail de aprobaci�n
        //------------------------------------------------------------------------------------------------------------------------
        IF (RecRef.NUMBER = GetTableNumber) THEN BEGIN
            RecRef.SETTABLE(Rec);
            IF (TRUE) THEN BEGIN  //No hay varios tipos de documento en la misma tabla

                IF (Rec."Approval Status" = Rec."Approval Status"::Released) THEN BEGIN
                    Field1Label := Rec.FIELDCAPTION("No.");
                    Field1Value := GetDocNumber(RecRef);
                    Field2Label := Rec.FIELDCAPTION(Description);
                    Field2Value := Rec.Description;
                END ELSE BEGIN
                    GetAmount(RecRef, Amount, AmountLCY);
                    IF NOT Vendor.GET(Rec."Account No.") THEN
                        Vendor.INIT;
                    Field1Label := 'Importe';
                    Field1Value := FORMAT(Amount);
                    Field2Label := 'Proveedor';
                    Field2Value := '(' + FORMAT(Rec."Account No.") + ') ' + Vendor.Name;
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
    BEGIN
        //------------------------------------------------------------------------------------------------------------------------
        //JAV 26/04/22: - QB 1.10.36 Retorna los datos del documento para el mail de aprobaci�n
        //------------------------------------------------------------------------------------------------------------------------
        IF (RecRef.NUMBER = GetTableNumber) THEN BEGIN
            DocumentType := 'Pago';
            DocumentNo := GetDocNumber(RecRef);
            IsHandled := TRUE;
        END;
    END;

    LOCAL PROCEDURE "---------------------------------------------------------  Respuestas a Eventos Propios"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Codeunit, 7207354, OnWitHoldingRequest, '', true, true)]
    PROCEDURE OnWitHoldingRequest(VAR ApprovalEntry: Record 454);
    VAR
        ApprovalEntry2: Record 454;
        Rec: Record 7000002;
        Text01: TextConst ESP = 'No puede retener el registro sin a�adir un nuevo comentario';
        QBApprovalManagement: Codeunit 7207354;
        RecID: RecordID;
    BEGIN
        RecID := ApprovalEntry."Record ID to Approve";
        IF (RecID.TABLENO = GetTableNumber) THEN BEGIN
            Rec.GET(RecID);
            IF (TRUE) THEN BEGIN  //No hay varios tipos de documento en la misma tabla
                ApprovalEntry.CALCFIELDS(Comment);
                IF NOT ApprovalEntry.Comment THEN
                    ERROR(Text01);
                CheckAdditionalConditionsPost(Rec);  //Verificar otras condiciones antes de poder lanzar

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

    [EventSubscriber(ObjectType::Codeunit, 7207354, OnAfterApproveRequest, '', true, true)]
    PROCEDURE OnAfterApproveRequest(VAR ApprovalEntry: Record 454);
    VAR
        ApprovalEntry2: Record 454;
        Rec: Record 7000002;
        Text01: TextConst ESP = 'No puede retener el registro sin a�adir un nuevo comentario';
        QBApprovalManagement: Codeunit 7207354;
        RecID: RecordID;
    BEGIN
        RecID := ApprovalEntry."Record ID to Approve";
        IF (RecID.TABLENO = GetTableNumber) THEN BEGIN
            Rec.GET(RecID);
            CheckAdditionalConditionsPost(Rec);  //Verificar otras condiciones antes de poder lanzar
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

    PROCEDURE IsApprovalsWorkflowEnabled(VAR Rec: Record 7000002): Boolean;
    VAR
        WorkflowManagement: Codeunit 1501;
    BEGIN
        //Retorna si se puede solictar la aprobaci�n para este tipo de documentos
        EXIT(WorkflowManagement.CanExecuteWorkflow(Rec, GetApprovalsText(TP::SendCode)));
    END;

    PROCEDURE CheckApprovalPossible(VAR Rec: Record 7000002): Boolean;
    VAR
        NoWorkflowEnabledErr: TextConst ENU = 'No approval workflow for this record type is enabled.', ESP = 'No hay ning�n flujo de trabajo de aprobaci�n habilitado para este tipo de registro.';
        NothingToApproveErr: TextConst ENU = 'There is nothing to approve.', ESP = 'No hay nada que aprobar.';
    BEGIN
        //Retorna si es posible aprobar el documento de este tipo
        IF NOT IsApprovalsWorkflowEnabled(Rec) THEN
            ERROR(NoWorkflowEnabledErr);
        IF (Rec."Approval Status" IN [Rec."Approval Status"::"Pending Approval", Rec."Approval Status"::"Due Pending Approval"]) THEN
            ERROR(NothingToApproveErr);

        CheckAdditionalConditionsPre(Rec);  //Verificar otras condiciones antes de poder lanzar

        EXIT(TRUE);
    END;

    PROCEDURE CheckDueApprovalPossible(VAR Rec: Record 7000002): Boolean;
    VAR
        NoWorkflowEnabledErr: TextConst ENU = 'No approval workflow for this record type is enabled.', ESP = 'No hay ning�n flujo de trabajo de aprobaci�n habilitado para este tipo de registro.';
        NothingToApproveErr: TextConst ENU = 'There is nothing to approve.', ESP = 'No hay nada que aprobar.';
    BEGIN
        //Retorna si es posible aprobar el documento con certificados vencidos
        EXIT((Rec."Approval Status" = Rec."Approval Status"::Released) AND (HaveDueCertificates(Rec)));

        CheckAdditionalConditionsPre(Rec);  //Verificar otras condiciones antes de poder lanzar

        EXIT(TRUE);
    END;

    PROCEDURE PrePostApprovalCheck(VAR Rec: Record 7000002): Boolean;
    VAR
        PrePostCheckErr: TextConst ENU = '%1 %2 must be approved and released before you can perform this action.', ESP = 'El documento %1 debe estar aprobado y lanzado antes de poder realizar esta acci�n.';
    BEGIN
        //Retorna si es posible lanzar el documento de este tipo
        IF (Rec."Approval Status" IN [Rec."Approval Status"::Open, Rec."Approval Status"::"Due Open"]) AND
           (IsApprovalsWorkflowEnabled(Rec)) THEN
            ERROR(PrePostCheckErr, Rec."No.");
        EXIT(TRUE);
    END;

    LOCAL PROCEDURE "---------------------------------------------------------  Eventos QB para este tipo de documentos"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Codeunit, 7207354, GetData, '', true, true)]
    PROCEDURE GetData(RecRef: RecordRef; VAR pJob: Code[20]; VAR pBudgetItem: Code[20]; VAR pDepartment: Code[20]; VAR pCircuit: Code[20]; VAR pDocumentType: Option; VAR pAmount: Decimal; VAR pAmountDL: Decimal);
    VAR
        Rec: Record 7000002;
        AmountLCY: Decimal;
    BEGIN
        //Obtiene los datos del registro necesarios para las aprobaciones: Proyecto, circuito e Importes
        //JAV 25/06/22: - QB 1.10.54 Se a�ade el departamento y su proceso
        IF (RecRef.NUMBER = GetTableNumber) THEN BEGIN
            RecRef.SETTABLE(Rec);
            IF (TRUE) THEN BEGIN  //No hay varios tipos de documento
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
        EXIT(ApprovalEntry."QB Document Type"::Payment);
    END;

    LOCAL PROCEDURE GetTableNumber(): Integer;
    BEGIN
        //Retorna el n�mero de la tabla que estamos tratando
        EXIT(DATABASE::"Cartera Doc.");
    END;

    PROCEDURE GetApprovalsText(pType: Integer): Text;
    VAR
        QBApprovalManagement: Codeunit 7207354;
        Txt: Text;
    BEGIN
        //Retorna las cadenas ajustadas al tipo de documento para las aprobaciones
        EXIT(QBApprovalManagement.GetApprovalsFixedText(pType, 'PAGOS', 'del pago de una factura'));
    END;

    LOCAL PROCEDURE GetDocNumber(RecRef: RecordRef): Code[20];
    VAR
        Rec: Record 7000002;
    BEGIN
        //Retorna el n�mero del documento
        RecRef.SETTABLE(Rec);
        EXIT(FORMAT(Rec."Entry No."));
    END;

    LOCAL PROCEDURE GetJobCode(RecRef: RecordRef): Code[20];
    VAR
        Rec: Record 7000002;
    BEGIN
        //Retorna el c�digo del proyecto del documento
        RecRef.SETTABLE(Rec);
        EXIT(Rec."Job No.");
    END;

    LOCAL PROCEDURE GetBudgetItemCode(RecRef: RecordRef): Code[20];
    VAR
        Rec: Record 7000002;
    BEGIN
        //Retorna el c�digo de la partida presupuestaria del documento
        RecRef.SETTABLE(Rec);
        EXIT('');
    END;

    LOCAL PROCEDURE GetDepartmentCode(RecRef: RecordRef): Code[20];
    VAR
        Rec: Record 7000002;
        FunctionQB: Codeunit 7207272;
    BEGIN
        //JAV 25/06/22: - QB 1.10.54 Retorna el c�digo del departamento asociado al documento
        RecRef.SETTABLE(Rec);
        EXIT(FunctionQB.ReturnDepartmentOrganization(Rec."Dimension Set ID"));
    END;

    LOCAL PROCEDURE GetCircuitCode(RecRef: RecordRef): Code[20];
    VAR
        Rec: Record 7000002;
    BEGIN
        //Retorna el c�digo del circuito de aprobaci�n del documento
        RecRef.SETTABLE(Rec);
        EXIT(Rec."QB Approval Circuit Code");
    END;

    LOCAL PROCEDURE GetAmount(RecRef: RecordRef; VAR Amount: Decimal; VAR AmountLCY: Decimal);
    VAR
        Rec: Record 7000002;
    BEGIN
        //Retorna los importes del documento
        RecRef.SETTABLE(Rec);
        Amount := Rec."Remaining Amount";
        AmountLCY := Rec."Remaining Amt. (LCY)";
    END;

    LOCAL PROCEDURE SetApprovalCircuit(VAR Rec: Record 7000002);
    VAR
        QBApprovalManagement: Codeunit 7207354;
        RecRef: RecordRef;
    BEGIN
        //JAV 22/02/22: - QB 1.10.22 Establecer el circuito de aprobaci�n para el documento
        RecRef.GETTABLE(Rec);
        Rec."QB Approval Circuit Code" := QBApprovalManagement.GetApprovalCircuit(RecRef, Rec."QB Approval Circuit Code");  //JAV 04/04/22: - QB 1.10.31 A�adir par�metro con el valor actual
    END;

    LOCAL PROCEDURE CheckAdditionalConditionsPre(Rec: Record 7000002);
    VAR
        Text001: TextConst ESP = 'El documento no tiene indicado proyecto, no se puede aprobar';
    BEGIN
        //Verificar condiciones adicionales necesarias antes de empezar el flujo para este tipo de documento
        IF (Rec."Job No." = '') THEN
            ERROR(Text001);
    END;

    LOCAL PROCEDURE CheckAdditionalConditionsPost(Rec: Record 7000002);
    VAR
        QBApprovalsSetup: Record 7206994;
        Text001: TextConst ESP = 'No tiene marcado el check obligatorio %1';
    BEGIN
        //Verificar condiciones adicionales necesarias para cerrar el flujo para este tipo de documento
        //JAV 04/04/22: - QB 1.10.31 Se cambian campos de aprobacines a la nueva tabla de configuraci�n de aprobaciones
        QBApprovalsSetup.GET;
        IF QBApprovalsSetup."Approvals Payments Checks" >= 1 THEN
            IF NOT Rec."Approval Check 1" THEN
                ERROR(Text001, Rec.FIELDCAPTION("Approval Check 1"));
        IF QBApprovalsSetup."Approvals Payments Checks" >= 2 THEN
            IF NOT Rec."Approval Check 2" THEN
                ERROR(Text001, Rec.FIELDCAPTION("Approval Check 2"));
        IF QBApprovalsSetup."Approvals Payments Checks" >= 3 THEN
            IF NOT Rec."Approval Check 3" THEN
                ERROR(Text001, Rec.FIELDCAPTION("Approval Check 3"));
        IF QBApprovalsSetup."Approvals Payments Checks" >= 4 THEN
            IF NOT Rec."Approval Check 4" THEN
                ERROR(Text001, Rec.FIELDCAPTION("Approval Check 4"));
        IF QBApprovalsSetup."Approvals Payments Checks" >= 5 THEN
            IF NOT Rec."Approval Check 5" THEN
                ERROR(Text001, Rec.FIELDCAPTION("Approval Check 5"));
    END;

    LOCAL PROCEDURE "--------------------------------------------------------- Funciones propias de este tipo de documento"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Codeunit, 7000006, OnAfterCreatePayableDoc, '', true, true)]
    PROCEDURE OnAfterCreatePayableDoc_CUDocumentPost(VAR CarteraDoc: Record 7000002; GenJournalLine: Record 81);
    VAR
        QBApprovalsSetup: Record 7206994;
        QualityManagement: Codeunit 7207293;
        ReleaseDocCartera: Codeunit 7207358;
        TxtError: Text;
        Text00: TextConst ENU = 'The Treasury Payment Certificate expired', ESP = 'El proveedor %1 tiene certificados caducados: \  -%2\�Desea solicitar aprobaci�n?';
        Text01: TextConst ESP = 'No se puede incluir en la relaci�n';
        Text02: TextConst ESP = 'El documento %1 del proveedor %2 debe estar aprobado para poder incluirlo en una relaci�n de pagos';
        GenJnlPostPreview: Codeunit 19;
    BEGIN
        //JAV 08/05/20: - Si est� activa la aprobaci�n de pagos, marcar el documento como pendiente de aprobar

        //JAV 25/05/22: - QB 1.10.44 Si estamos en modo de vista previa no hacemos el proceso
        IF (GenJnlPostPreview.IsActive) THEN
            EXIT;

        IF (IsApprovalsWorkflowActive) AND (CarteraDoc."Job No." <> '') THEN BEGIN       //Si se puede aprobar y tiene proyecto, necesita aprobaci�n
                                                                                         //JAV 04/04/22: - QB 1.10.31 Se cambian campos de aprobaciones a la nueva tabla de configuraci�n de aprobaciones

            //JAV 24/06/22: - QB 1.10.54 Le establecemos el circuito de aprobaci�n al documento cuando se crea, estaba mal ubicado
            IF (CarteraDoc."QB Approval Circuit Code" = '') THEN
                SetApprovalCircuit(CarteraDoc);

            CarteraDoc."Approval Status" := CarteraDoc."Approval Status"::Open;
            CarteraDoc.MODIFY;

            //JAV 24/06/22: - QB 1.10.54 Si la aprobaci�n es manual al menos debe haber buscado el circuito, se cambia el c�digo
            QBApprovalsSetup.GET;
            IF (NOT QBApprovalsSetup."Manual. App. Payments Request") THEN  //Si la aprobaci�n es manual no hacemos nada, si no se solicita la probaci�n autom�ticamente
                SendApproval(CarteraDoc);
        END ELSE BEGIN                                                                   //Por defecto entra como aprobado directamente
            CarteraDoc."Approval Status" := CarteraDoc."Approval Status"::Released;
            CarteraDoc.MODIFY;
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 7000000, OnInsertPayableDocsOnAfterSetFilters, '', true, true)]
    PROCEDURE OnInsertPayableDocsOnAfterSetFilters_cuCarteraManagement(VAR CarteraDoc: Record 7000002);
    VAR
        carteradoc2: Record 7000002;
    BEGIN
        //Al abrir la p�gina de documentos a insertar en una orden de pago, se filtran que los documentos est�n aprobados
        IF NOT IsApprovalsWorkflowActive THEN
            EXIT;

        AutomaticApprove;
        COMMIT; // Luego hace un Runmodal

        //Filtramos los aprobados
        CarteraDoc.FILTERGROUP(2);
        CarteraDoc.SETFILTER("Approval Status", '%1|%2', CarteraDoc."Approval Status"::Released, CarteraDoc."Approval Status"::"Due Released");
        CarteraDoc.FILTERGROUP(0);
    END;

    [EventSubscriber(ObjectType::Codeunit, 7000000, OnAfterInsertPayableDocs, '', true, true)]
    PROCEDURE OnAfterInsertPayableDocs_cuCarteraManagement(VAR CarteraDoc: Record 7000002; VAR PaymentOrder: Record 7000020);
    VAR
        FunctionQB: Codeunit 7207272;
        Vendor: Record 23;
        Job: Record 167;
        Obralia: Codeunit 7206901;
        ObraliaLogEntry: Record 7206904;
        QualityManagement: Codeunit 7207293;
        ReleaseDocCartera: Codeunit 7207358;
        TxtError: Text;
        Text00: TextConst ENU = 'The Treasury Payment Certificate expired', ESP = 'El proveedor %1 tiene certificados caducados: \  -%2\�Desea solicitar aprobaci�n?';
        Text01: TextConst ESP = 'No se puede incluir en la relaci�n';
        Text02: TextConst ESP = 'El documento %1 del proveedor %2 debe estar aprobado para poder incluirlo en una relaci�n de pagos';
        Text03: TextConst ESP = 'El documento %1 del proveedor %2 no se puede verificar con obralia para poder incluirlo en una relaci�n de pagos';
        Text04: TextConst ESP = 'El documento %1 del proveedor %2 debe estar aceptado por obralia para poder incluirlo en una relaci�n de pagos';
        Text05: TextConst ENU = '<El documento %1 del proveedor %2 no ha sido verificado con obralia para poder incluirlo en una relaci�n de pagos>', ESP = 'El documento %1 del proveedor %2 no ha sido verificado con obralia para poder incluirlo en una relaci�n de pagos';
    BEGIN
        //JAV 05/03/20: - Funci�n para controlar que se pueda incluir un documento en una orden de pago

        //Verificar primero obralia si el m�dulo est� activado
        IF (FunctionQB.AccessToObralia) THEN BEGIN
            IF (Job.GET(CarteraDoc."Job No.")) THEN BEGIN
                IF (Job."Obralia Code" <> '') THEN BEGIN
                    Vendor.GET(CarteraDoc."Account No.");
                    //Q19458-
                    IF Vendor."QB Obralia" <> Vendor."QB Obralia"::Never THEN BEGIN
                        IF (CarteraDoc."Obralia Entry" = 0) OR (NOT ObraliaLogEntry.GET(CarteraDoc."Obralia Entry")) THEN BEGIN
                            DocumentOut(CarteraDoc);
                            MESSAGE(Text05, CarteraDoc."Document No.", CarteraDoc."Account No.");
                            EXIT;
                        END;
                        IF ObraliaLogEntry.GET(CarteraDoc."Obralia Entry") THEN BEGIN
                            IF ((ObraliaLogEntry.semaforoEmpresa = '') AND
                                (ObraliaLogEntry.semaforoPagos = '') AND
                                (ObraliaLogEntry.semaforoTotal = '')) THEN BEGIN
                                IF (Vendor."QB Obralia" = Vendor."QB Obralia"::Mandatory) THEN BEGIN
                                    DocumentOut(CarteraDoc);
                                    MESSAGE(Text03, CarteraDoc."Document No.", CarteraDoc."Account No.");
                                    EXIT;
                                END;
                            END ELSE BEGIN
                                IF ObraliaLogEntry.IsSemaphorRed THEN BEGIN
                                    DocumentOut(CarteraDoc);
                                    MESSAGE(Text04, CarteraDoc."Document No.", CarteraDoc."Account No.");
                                    EXIT;
                                END;
                            END;
                        END;
                    END;
                    //  CarteraDoc.VALIDATE("Obralia Entry", Obralia.SemaforoRequest_CarteraDoc(CarteraDoc,FALSE));
                    //  CarteraDoc.GET(CarteraDoc.Type, CarteraDoc."Entry No."); //Lo vuelvo a leer por que hace un modify
                    //  IF (NOT ObraliaLogEntry.GET(CarteraDoc."Obralia Entry")) THEN BEGIN
                    //    IF (Vendor."QB Obralia" = Vendor."QB Obralia"::Mandatory) THEN
                    //      MESSAGE(Text03, CarteraDoc."Document No.", CarteraDoc."Account No.");
                    //  END ELSE BEGIN
                    //    IF (Vendor."QB Obralia" <> Vendor."QB Obralia"::Never) AND (ObraliaLogEntry.IsSemaphorRed) THEN BEGIN
                    //        DocumentOut(CarteraDoc);
                    //        MESSAGE(Text04, CarteraDoc."Document No.", CarteraDoc."Account No.");
                    //        EXIT;
                    //      END;
                    //    END;
                    //Q19458+
                END;
            END;
        END;
        //Q19458+

        IF NOT IsApprovalsWorkflowActive THEN
            EXIT;

        //Verificar el estado de aprobaci�n general del pago
        IF NOT (CarteraDoc."Approval Status" IN [CarteraDoc."Approval Status"::Released, CarteraDoc."Approval Status"::"Due Released"]) THEN BEGIN
            DocumentOut(CarteraDoc);
            MESSAGE(Text02, CarteraDoc."Document No.", CarteraDoc."Account No.");
            EXIT;
        END;

        //Verificar si tiene certificados vencidos y no est� aprobado su pago
        IF (CarteraDoc."Approval Status" <> CarteraDoc."Approval Status"::"Due Released") THEN BEGIN
            IF QualityManagement.VendorCertificatesDued(CarteraDoc."Account No.", PaymentOrder."Posting Date", TxtError) THEN BEGIN
                DocumentOut(CarteraDoc);
                IF (CONFIRM(STRSUBSTNO(Text00, CarteraDoc."Account No.", TxtError), FALSE)) THEN BEGIN
                    SendDueApproval(CarteraDoc);
                END;
            END;
        END;
    END;

    LOCAL PROCEDURE DocumentOut(VAR Rec: Record 7000002);
    VAR
        CarteraDoc2: Record 7000002;
        CarteraManagement: Codeunit 7000000;
    BEGIN
        //Lo tengo que sacar de la relaci�n, pero como la funci�n RemovePayableDocs hace un FINDFIRTS en su interior lo tengo que posicionar primero
        CarteraDoc2.RESET;
        CarteraDoc2.SETRANGE(Type, Rec.Type);
        CarteraDoc2.SETRANGE("Entry No.", Rec."Entry No.");
        CarteraManagement.RemovePayableDocs(CarteraDoc2);

        //Vuelvo a leer el registro por los cambios
        Rec.GET(Rec.Type, Rec."Entry No.");
    END;

    LOCAL PROCEDURE HaveDueCertificates(Rec: Record 7000002): Boolean;
    VAR
        PaymentOrder: Record 7000020;
        QualityManagement: Codeunit 7207293;
        Fecha: Date;
        TxtError: Text;
    BEGIN
        IF (PaymentOrder.GET(Rec."Bill Gr./Pmt. Order No.")) THEN
            Fecha := PaymentOrder."Posting Date"
        ELSE
            Fecha := TODAY;

        EXIT(QualityManagement.VendorCertificatesDued(Rec."Account No.", Fecha, TxtError));
    END;

    PROCEDURE SetCheckVisible(VAR v1: Boolean; VAR v2: Boolean; VAR v3: Boolean; VAR v4: Boolean; VAR v5: Boolean);
    VAR
        QBApprovalsSetup: Record 7206994;
        Nro: Integer;
    BEGIN
        //JAV 04/04/22: - QB 1.10.31 Se cambian campos de aprobaciones a la nueva tabla de configuraci�n de aprobaciones
        QBApprovalsSetup.GET();
        Nro := 0;
        IF (QBApprovalsSetup."Approvals Payments Caption 1" <> '') THEN BEGIN
            v1 := TRUE;
            Nro += 1;
        END;
        IF (QBApprovalsSetup."Approvals Payments Caption 2" <> '') THEN BEGIN
            v2 := TRUE;
            Nro += 1;
        END;
        IF (QBApprovalsSetup."Approvals Payments Caption 3" <> '') THEN BEGIN
            v3 := TRUE;
            Nro += 1;
        END;
        IF (QBApprovalsSetup."Approvals Payments Caption 4" <> '') THEN BEGIN
            v4 := TRUE;
            Nro += 1;
        END;
        IF (QBApprovalsSetup."Approvals Payments Caption 5" <> '') THEN BEGIN
            v5 := TRUE;
            Nro += 1;
        END;
        IF (Nro <> QBApprovalsSetup."Approvals Payments Checks") THEN BEGIN
            QBApprovalsSetup."Approvals Payments Checks" := Nro;
            QBApprovalsSetup.MODIFY;
        END;
    END;

    PROCEDURE CheckEditables(Rec: Record 7000002): Boolean;
    BEGIN
        //JAV 28/06/22: - QB 1.10.54 Solo son editables los checks si no est� lanzado el documento, esta funci�n retorna si se pueden o no editar
        //TO-DO que solo sean editables por los aprobadores una vez lanzado el proceso de aprobaci�n
        EXIT(Rec."Approval Status" IN [Rec."Approval Status"::Open, Rec."Approval Status"::"Pending Approval"]);
    END;

    PROCEDURE AutomaticApprove();
    VAR
        QuoBuildingSetup: Record 7207278;
        carteradoc1: Record 7000002;
        carteradoc2: Record 7000002;
        n: Integer;
    BEGIN
        //Marca todos los documentos pendientes sin proyecto como aprobados, por si se ha activado el proceso posteriormente que no afecte
        IF NOT IsApprovalsWorkflowActive THEN
            EXIT;

        carteradoc1.RESET;
        carteradoc1.SETRANGE(Type, carteradoc1.Type::Payable);
        carteradoc1.SETRANGE("Approval Status", carteradoc1."Approval Status"::"Pending Approval");
        carteradoc1.SETFILTER("Job No.", '=%1', '');
        IF carteradoc1.FINDSET(TRUE) THEN
            REPEAT
                carteradoc2.GET(carteradoc1.Type, carteradoc1."Entry No.");
                carteradoc2."Approval Status" := carteradoc1."Approval Status"::Released;
                carteradoc2.MODIFY;
            UNTIL (carteradoc1.NEXT = 0);
    END;

    LOCAL PROCEDURE "--------------------------------------------------------- Condicionantes para seleccionar el circuito"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 7000002, OnAfterValidateEvent, "Job No.", true, true)]
    LOCAL PROCEDURE T7000002_OnAfterValidateEvent_JobNo(VAR Rec: Record 7000002; VAR xRec: Record 7000002; CurrFieldNo: Integer);
    BEGIN
        IF (TRUE) THEN  //No hay varios tipos de documento en la misma tabla
            SetApprovalCircuit(Rec);
    END;


    /*BEGIN
    /*{
          JAV 23/02/22: - QB 1.20.22 Nuevo proceso de aprobaciones.
                                     Se lanzan los eventos OnAfterReleaseDocument y OnAfterReopenDocument tras lanzar o abrir el documento
          JAV 04/04/22: - QB 1.10.31 Se cambian campos de aprobacines a la nueva tabla de configuraci�n de aprobaciones
          JAV 21/04/22: - QB 1.10.36 Se a�ade la funci�n que se lanza con el evento global para montar el flujo de trabajo para este tipo de documentos
          JAV 26/04/22: - QB 1.10.36 Retorna los datos para enviar el mail de aprobado
          DGG 24/05/22: - QRE-17064 Solo estar� activo el bot�n si el estado es abierto
          JAV 25/05/22: - QB 1.10.44 Si estamos en modo de vista previa no hacemos el proceso
          JAV 26/05/22: - QB 1.10.44 Le establecemos el circuito de aprobaci�n al documento si no lo tiene informado
          JAV 01/06/22: - QB 1.10.46 A�adir en el mail el proyecto tras el importe
          JAV 24/06/22: - QB 1.10.54 Le establecemos el circuito de aprobaci�n al documento cuando se crea, estaba mal ubicado el c�digo
                                     Si la aprobaci�n es manual al menos debe haber buscado el circuito, se cambia el c�digo
          JAV 28/06/22: - QB 1.10.54 Solo son editables los checks si no est� lanzado el documento, esta funci�n retorna si se pueden o no editar
          JAV 25/06/22: - QB 1.10.54 Se a�ade el departamento y su proceso
          JAV 30/06/22: - QB 1.10.47 Si no tiene un circuito, lo buscamos antes de solicitar la aprobaci�n. Se lanza el evento OnAfterSendApproval antes de solicitar aprobaci�n
          JAV 10/08/22: - QB 1.11.01 Se a�ade el evento OnAfterPerformManualReopenDoc y se lanza al reabrir el documento
          JAV 03/11/22: - QB 1.12.12 Para simplificar se elimina la funci�n AddAditionalApprovalEntryArgument y se pasa su c�digo dentro de OnPopulateApprovalEntryArgument
                                     Se a�ade la partida en el documento de aprobaci�n
          PSM 19/10/23: - Q19458 Quitar validaci�n de ObraliaLogEntry para no mandar un nuevo request a Obralia
        }
    END.*/
}









