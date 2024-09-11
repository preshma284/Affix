Codeunit 50015 "Approvals Mgmt. 1"
{


    Permissions = TableData 454 = imd,
                TableData 455 = imd,
                TableData 456 = imd,
                TableData 457 = imd,
                TableData 458 = imd,
                TableData 1511 = imd;
    trigger OnRun()
    BEGIN
    END;

    VAR
        UserIdNotInSetupErr: TextConst ENU = 'User ID %1 does not exist in the Approval User Setup window.', ESP = 'El id. usuario %1 no existe en la tabla Config. usuario aprobaci�n.';
        ApproverUserIdNotInSetupErr: TextConst ENU = 'You must set up an approver for user ID %1 in the Approval User Setup window.', ESP = 'Debe configurar un aprobador para el id. de usuario %1 en la ventana Config. usuario aprobaci�n.';
        WFUserGroupNotInSetupErr: TextConst ENU = 'The workflow user group member with user ID %1 does not exist in the Approval User Setup window.', ESP = 'El miembro del grupo de usuarios del flujo de trabajo con el id. de usuario %1 no existe en la ventana Config. usuario aprobaci�n.';
        SubstituteNotFoundErr: TextConst ENU = 'There is no substitute, direct approver, or approval administrator for user ID %1 in the Approval User Setup window.', ESP = 'No hay ning�n sustituto, aprobador directo o administrador de aprobaciones para el id. de usuario %1 en la ventana Config. usuario aprobaci�n.';
        NoSuitableApproverFoundErr: TextConst ENU = 'No qualified approver was found.', ESP = 'No se encontr� ning�n aprobador cualificado.';
        DelegateOnlyOpenRequestsErr: TextConst ENU = 'You can only delegate open approval requests.', ESP = 'Solo puede delegar las solicitudes de aprobaci�n abiertas.';
        ApproveOnlyOpenRequestsErr: TextConst ENU = 'You can only approve open approval requests.', ESP = 'Solo puede aprobar las solicitudes de aprobaci�n abiertas.';
        RejectOnlyOpenRequestsErr: TextConst ENU = 'You can only reject open approval entries.', ESP = 'Solo puede rechazar los movs. aprobaci�n abiertos.';
        ApprovalsDelegatedMsg: TextConst ENU = 'The selected approval requests have been delegated.', ESP = 'Se han delegado las solicitudes de aprobaci�n seleccionadas.';
        NoReqToApproveErr: TextConst ENU = 'There is no approval request to approve.', ESP = 'No hay ninguna solicitud de aprobaci�n para aprobar.';
        NoReqToRejectErr: TextConst ENU = 'There is no approval request to reject.', ESP = 'No hay ninguna solicitud de aprobaci�n para rechazar.';
        NoReqToDelegateErr: TextConst ENU = 'There is no approval request to delegate.', ESP = 'No hay ninguna solicitud de aprobaci�n para delegar.';
        PendingApprovalMsg: TextConst ENU = 'An approval request has been sent.', ESP = 'Se ha enviado una solicitud de aprobaci�n.';
        NoApprovalsSentMsg: TextConst ENU = 'No approval requests have been sent, either because they are already sent or because related workflows do not support the journal line.', ESP = 'No se ha enviado ninguna solicitud de aprobaci�n, porque ya se han enviado o porque los flujos de trabajo relacionados no admiten la l�nea del diario.';
        PendingApprovalForSelectedLinesMsg: TextConst ENU = 'Approval requests have been sent.', ESP = 'Se han enviado las solicitudes de aprobaci�n.';
        PendingApprovalForSomeSelectedLinesMsg: TextConst ENU = 'Approval requests have been sent.\\Requests for some journal lines were not sent, either because they are already sent or because related workflows do not support the journal line.', ESP = 'Se han enviado solicitudes de aprobaci�n.\\No se han enviado las solicitudes de algunas l�neas de diario, porque ya se han enviado o porque los flujos de trabajo relacionados no admiten la l�nea del diario.';
        PurchaserUserNotFoundErr: TextConst ENU = 'The salesperson/purchaser user ID %1 does not exist in the Approval User Setup window for %2 %3.', ESP = 'EL id. de usuario de vendedor o comprador %1 no existe en la ventana Config. usuario aprobaci�n de %2 %3.';
        NoApprovalRequestsFoundErr: TextConst ENU = 'No approval requests exist.', ESP = 'No existe ninguna solicitud de aprobaci�n.';
        NoWFUserGroupMembersErr: TextConst ENU = 'A workflow user group with at least one member must be set up.', ESP = 'Debe configurarse un grupo de usuarios de flujo de trabajo con al menos un miembro.';
        DocStatusChangedMsg: TextConst ENU = '%1 %2 has been automatically approved. The status has been changed to %3.', ESP = 'El documento de %1 %2 se ha aprobado autom�ticamente. El estado se ha cambiado a %3.';
        UnsupportedRecordTypeErr: TextConst ENU = 'Record type %1 is not supported by this workflow response.', ESP = 'La respuesta de este flujo de trabajo no admite el tipo de registro %1.';
        SalesPrePostCheckErr: TextConst ENU = 'Sales %1 %2 must be approved and released before you can perform this action.', ESP = 'Las ventas %1 %2 deben aprobarse y lanzarse para poder realizar esta acci�n.';
        WorkflowEventHandling: Codeunit 1520;
        WorkflowManagement: Codeunit 1501;
        PurchPrePostCheckErr: TextConst ENU = 'Purchase %1 %2 must be approved and released before you can perform this action.', ESP = 'La compra %1 %2 debe aprobarse y lanzarse para poder realizar esta acci�n.';
        NoWorkflowEnabledErr: TextConst ENU = 'No approval workflow for this record type is enabled.', ESP = 'No hay ning�n flujo de trabajo de aprobaci�n habilitado para este tipo de registro.';
        ApprovalReqCanceledForSelectedLinesMsg: TextConst ENU = 'The approval request for the selected record has been canceled.', ESP = 'Se ha cancelado la solicitud de aprobaci�n del registro seleccionado.';
        PendingJournalBatchApprovalExistsErr: TextConst ENU = 'An approval request already exists.', ESP = 'Ya existe una solicitud de aprobaci�n.';
        ApporvalChainIsUnsupportedMsg: TextConst ENU = 'Only Direct Approver is supported as Approver Limit Type option for %1. The approval request will be approved automatically.', ESP = 'Solo se admite el Aprobador directo como opci�n Tipo de l�mite de aprobador para %1. La solicitud de aprobaci�n se aprobar� autom�ticamente.';
        RecHasBeenApprovedMsg: TextConst ENU = '%1 has been approved.', ESP = '%1 se ha aprobado.';
        NoPermissionToDelegateErr: TextConst ENU = 'You do not have permission to delegate one or more of the selected approval requests.', ESP = 'No tiene permiso para delegar una o m�s de las solicitudes de aprobaci�n seleccionadas.';
        NothingToApproveErr: TextConst ENU = 'There is nothing to approve.', ESP = 'No hay nada que aprobar.';


    //[IntegrationEvent]
    //[External]
    PROCEDURE OnSendGeneralJournalBatchForApproval(VAR GenJournalBatch: Record 232);
    BEGIN
    END;

    //[IntegrationEvent]
    //[External]
    PROCEDURE OnCancelGeneralJournalBatchApprovalRequest(VAR GenJournalBatch: Record 232);
    BEGIN
    END;

    //[IntegrationEvent]
    //[External]
    PROCEDURE OnSendGeneralJournalLineForApproval(VAR GenJournalLine: Record 81);
    BEGIN
    END;

    //[IntegrationEvent]
    //[External]
    PROCEDURE OnCancelGeneralJournalLineApprovalRequest(VAR GenJournalLine: Record 81);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnApproveApprovalRequest(VAR ApprovalEntry: Record 454);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnRejectApprovalRequest(VAR ApprovalEntry: Record 454);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnDelegateApprovalRequest(VAR ApprovalEntry: Record 454);
    BEGIN
    END;

    //[IntegrationEvent]
    //[External]
    PROCEDURE OnRenameRecordInApprovalRequest(OldRecordId: RecordID; NewRecordId: RecordID);
    BEGIN
    END;

    //[IntegrationEvent]
    //[External]
    PROCEDURE OnDeleteRecordInApprovalRequest(RecordIDToApprove: RecordID);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnPopulateApprovalEntryArgument(VAR RecRef: RecordRef; VAR ApprovalEntryArgument: Record 454; WorkflowStepInstance: Record 1504);
    BEGIN
    END;

    //[External]
    PROCEDURE ApproveRecordApprovalRequest(RecordID: RecordID);
    VAR
        ApprovalEntry: Record 454;
    BEGIN
        IF NOT FindOpenApprovalEntryForCurrUser(ApprovalEntry, RecordID) THEN
            ERROR(NoReqToApproveErr);

        ApprovalEntry.SETRECFILTER;
        ApproveApprovalRequests(ApprovalEntry);
    END;

    //[External]


    //[External]
    PROCEDURE RejectRecordApprovalRequest(RecordID: RecordID);
    VAR
        ApprovalEntry: Record 454;
    BEGIN
        IF NOT FindOpenApprovalEntryForCurrUser(ApprovalEntry, RecordID) THEN
            ERROR(NoReqToRejectErr);

        ApprovalEntry.SETRECFILTER;
        RejectApprovalRequests(ApprovalEntry);
    END;



    //[External]
    PROCEDURE DelegateRecordApprovalRequest(RecordID: RecordID);
    VAR
        ApprovalEntry: Record 454;
    BEGIN
        IF NOT FindOpenApprovalEntryForCurrUser(ApprovalEntry, RecordID) THEN
            ERROR(NoReqToDelegateErr);

        ApprovalEntry.SETRECFILTER;
        DelegateApprovalRequests(ApprovalEntry);
    END;



    //[External]
    PROCEDURE ApproveApprovalRequests(VAR ApprovalEntry: Record 454);
    VAR
        ApprovalEntryToUpdate: Record 454;
    BEGIN
        IF ApprovalEntry.FINDSET(TRUE) THEN
            REPEAT
                ApprovalEntryToUpdate := ApprovalEntry;
                ApproveSelectedApprovalRequest(ApprovalEntryToUpdate);
            UNTIL ApprovalEntry.NEXT = 0;
    END;

    //[External]
    PROCEDURE RejectApprovalRequests(VAR ApprovalEntry: Record 454);
    VAR
        ApprovalEntryToUpdate: Record 454;
    BEGIN
        IF ApprovalEntry.FINDSET(TRUE) THEN
            REPEAT
                ApprovalEntryToUpdate := ApprovalEntry;
                RejectSelectedApprovalRequest(ApprovalEntryToUpdate);
            UNTIL ApprovalEntry.NEXT = 0;
    END;

    //[External]
    PROCEDURE DelegateApprovalRequests(VAR ApprovalEntry: Record 454);
    VAR
        ApprovalEntryToUpdate: Record 454;
    BEGIN
        IF ApprovalEntry.FINDSET(TRUE) THEN BEGIN
            REPEAT
                ApprovalEntryToUpdate := ApprovalEntry;
                DelegateSelectedApprovalRequest(ApprovalEntryToUpdate, TRUE);
            UNTIL ApprovalEntry.NEXT = 0;
            MESSAGE(ApprovalsDelegatedMsg);
        END;
    END;

    LOCAL PROCEDURE ApproveSelectedApprovalRequest(VAR ApprovalEntry: Record 454);
    BEGIN
        IF ApprovalEntry.Status <> ApprovalEntry.Status::Open THEN
            ERROR(ApproveOnlyOpenRequestsErr);

        IF ApprovalEntry."Approver ID" <> USERID THEN
            CheckUserAsApprovalAdministrator;

        ApprovalEntry.VALIDATE(Status, ApprovalEntry.Status::Approved);
        ApprovalEntry.MODIFY(TRUE);
        OnApproveApprovalRequest(ApprovalEntry);
    END;

    LOCAL PROCEDURE RejectSelectedApprovalRequest(VAR ApprovalEntry: Record 454);
    BEGIN
        IF ApprovalEntry.Status <> ApprovalEntry.Status::Open THEN
            ERROR(RejectOnlyOpenRequestsErr);

        IF ApprovalEntry."Approver ID" <> USERID THEN
            CheckUserAsApprovalAdministrator;

        OnRejectApprovalRequest(ApprovalEntry);
        ApprovalEntry.GET(ApprovalEntry."Entry No.");
        ApprovalEntry.VALIDATE(Status, ApprovalEntry.Status::Rejected);
        ApprovalEntry.MODIFY(TRUE);
    END;

    //[External]
    PROCEDURE DelegateSelectedApprovalRequest(VAR ApprovalEntry: Record 454; CheckCurrentUser: Boolean);
    BEGIN
        IF ApprovalEntry.Status <> ApprovalEntry.Status::Open THEN
            ERROR(DelegateOnlyOpenRequestsErr);

        IF CheckCurrentUser AND (NOT ApprovalEntry.CanCurrentUserEdit) THEN
            ERROR(NoPermissionToDelegateErr);

        SubstituteUserIdForApprovalEntry(ApprovalEntry)
    END;

    LOCAL PROCEDURE SubstituteUserIdForApprovalEntry(ApprovalEntry: Record 454);
    VAR
        UserSetup: Record 91;
        ApprovalAdminUserSetup: Record 91;
    BEGIN
        IF NOT UserSetup.GET(ApprovalEntry."Approver ID") THEN
            ERROR(ApproverUserIdNotInSetupErr, ApprovalEntry."Sender ID");

        IF UserSetup.Substitute = '' THEN
            IF UserSetup."Approver ID" = '' THEN BEGIN
                ApprovalAdminUserSetup.SETRANGE("Approval Administrator", TRUE);
                IF ApprovalAdminUserSetup.FINDFIRST THEN
                    UserSetup.GET(ApprovalAdminUserSetup."User ID")
                ELSE
                    ERROR(SubstituteNotFoundErr, UserSetup."User ID");
            END ELSE
                UserSetup.GET(UserSetup."Approver ID")
        ELSE
            UserSetup.GET(UserSetup.Substitute);

        ApprovalEntry."Approver ID" := UserSetup."User ID";
        ApprovalEntry.MODIFY(TRUE);
        OnDelegateApprovalRequest(ApprovalEntry);
    END;

    //[External]
    PROCEDURE FindOpenApprovalEntryForCurrUser(VAR ApprovalEntry: Record 454; RecordID: RecordID): Boolean;
    BEGIN
        ApprovalEntry.SETRANGE("Table ID", RecordID.TABLENO);
        ApprovalEntry.SETRANGE("Record ID to Approve", RecordID);
        ApprovalEntry.SETRANGE(Status, ApprovalEntry.Status::Open);
        ApprovalEntry.SETRANGE("Approver ID", USERID);
        ApprovalEntry.SETRANGE("Related to Change", FALSE);

        EXIT(ApprovalEntry.FINDFIRST);
    END;


    LOCAL PROCEDURE ShowPurchApprovalStatus(PurchaseHeader: Record 38);
    BEGIN
        PurchaseHeader.FIND;

        CASE PurchaseHeader.Status OF
            PurchaseHeader.Status::Released:
                MESSAGE(DocStatusChangedMsg, PurchaseHeader."Document Type", PurchaseHeader."No.", PurchaseHeader.Status);
            PurchaseHeader.Status::"Pending Approval":
                IF HasOpenOrPendingApprovalEntries(PurchaseHeader.RECORDID) THEN
                    MESSAGE(PendingApprovalMsg);
            PurchaseHeader.Status::"Pending Prepayment":
                MESSAGE(DocStatusChangedMsg, PurchaseHeader."Document Type", PurchaseHeader."No.", PurchaseHeader.Status);
        END;
    END;

    LOCAL PROCEDURE ShowSalesApprovalStatus(SalesHeader: Record 36);
    BEGIN
        SalesHeader.FIND;

        CASE SalesHeader.Status OF
            SalesHeader.Status::Released:
                MESSAGE(DocStatusChangedMsg, SalesHeader."Document Type", SalesHeader."No.", SalesHeader.Status);
            SalesHeader.Status::"Pending Approval":
                IF HasOpenOrPendingApprovalEntries(SalesHeader.RECORDID) THEN
                    MESSAGE(PendingApprovalMsg);
            SalesHeader.Status::"Pending Prepayment":
                MESSAGE(DocStatusChangedMsg, SalesHeader."Document Type", SalesHeader."No.", SalesHeader.Status);
        END;
    END;

    LOCAL PROCEDURE ShowApprovalStatus(RecId: RecordID; WorkflowInstanceId: GUID);
    BEGIN
        IF HasPendingApprovalEntriesForWorkflow(RecId, WorkflowInstanceId) THEN
            MESSAGE(PendingApprovalMsg)
        ELSE
            MESSAGE(RecHasBeenApprovedMsg, FORMAT(RecId, 0, 1));
    END;

    //[External]
    PROCEDURE ApproveApprovalRequestsForRecord(RecRef: RecordRef; WorkflowStepInstance: Record 1504);
    VAR
        ApprovalEntry: Record 454;
    BEGIN
        ApprovalEntry.SETCURRENTKEY("Table ID", "Document Type", "Document No.", "Sequence No.");
        ApprovalEntry.SETRANGE("Table ID", RecRef.NUMBER);
        ApprovalEntry.SETRANGE("Record ID to Approve", RecRef.RECORDID);
        ApprovalEntry.SETFILTER(Status, '%1|%2', ApprovalEntry.Status::Created, ApprovalEntry.Status::Open);
        ApprovalEntry.SETRANGE("Workflow Step Instance ID", WorkflowStepInstance.ID);
        IF ApprovalEntry.FINDSET(TRUE) THEN
            REPEAT
                ApprovalEntry.VALIDATE(Status, ApprovalEntry.Status::Approved);
                ApprovalEntry.MODIFY(TRUE);
                CreateApprovalEntryNotification(ApprovalEntry, WorkflowStepInstance);
            UNTIL ApprovalEntry.NEXT = 0;
    END;

    //[External]
    PROCEDURE CancelApprovalRequestsForRecord(RecRef: RecordRef; WorkflowStepInstance: Record 1504);
    VAR
        ApprovalEntry: Record 454;
        OldStatus: Enum "Approval Status";
    BEGIN
        ApprovalEntry.SETCURRENTKEY("Table ID", "Document Type", "Document No.", "Sequence No.");
        ApprovalEntry.SETRANGE("Table ID", RecRef.NUMBER);
        ApprovalEntry.SETRANGE("Record ID to Approve", RecRef.RECORDID);
        ApprovalEntry.SETFILTER(Status, '<>%1&<>%2', ApprovalEntry.Status::Rejected, ApprovalEntry.Status::Canceled);
        ApprovalEntry.SETRANGE("Workflow Step Instance ID", WorkflowStepInstance.ID);
        IF ApprovalEntry.FINDSET(TRUE) THEN
            REPEAT
                OldStatus := ApprovalEntry.Status;//enum to option
                ApprovalEntry.VALIDATE(Status, ApprovalEntry.Status::Canceled);
                ApprovalEntry.MODIFY(TRUE);
                IF OldStatus IN [ApprovalEntry.Status::Open, ApprovalEntry.Status::Approved] THEN //enum to option
                    CreateApprovalEntryNotification(ApprovalEntry, WorkflowStepInstance);
            UNTIL ApprovalEntry.NEXT = 0;
    END;

    //[External]
    PROCEDURE RejectApprovalRequestsForRecord(RecRef: RecordRef; WorkflowStepInstance: Record 1504);
    VAR
        ApprovalEntry: Record 454;
        OldStatus: Enum "Approval Status";
    BEGIN
        ApprovalEntry.SETCURRENTKEY("Table ID", "Document Type", "Document No.", "Sequence No.");
        ApprovalEntry.SETRANGE("Table ID", RecRef.NUMBER);
        ApprovalEntry.SETRANGE("Record ID to Approve", RecRef.RECORDID);
        ApprovalEntry.SETFILTER(Status, '<>%1&<>%2', ApprovalEntry.Status::Rejected, ApprovalEntry.Status::Canceled);
        ApprovalEntry.SETRANGE("Workflow Step Instance ID", WorkflowStepInstance.ID);
        IF ApprovalEntry.FINDSET(TRUE) THEN BEGIN
            REPEAT
                OldStatus := ApprovalEntry.Status;
                ApprovalEntry.VALIDATE(Status, ApprovalEntry.Status::Rejected);
                ApprovalEntry.MODIFY(TRUE);
                IF (OldStatus IN [ApprovalEntry.Status::Open, ApprovalEntry.Status::Approved]) AND//enum to option
                   (ApprovalEntry."Approver ID" <> USERID)
                THEN
                    CreateApprovalEntryNotification(ApprovalEntry, WorkflowStepInstance);
            UNTIL ApprovalEntry.NEXT = 0;
            ApprovalEntry.SETRANGE(Status, ApprovalEntry.Status::Rejected);
            IF (ApprovalEntry."Approval Type" = ApprovalEntry."Approval Type"::Approver) AND
               (ApprovalEntry.COUNT = 1)
            THEN BEGIN
                ApprovalEntry."Approver ID" := ApprovalEntry."Sender ID";
                CreateApprovalEntryNotification(ApprovalEntry, WorkflowStepInstance);
            END;
        END;
    END;

    //[External]
    PROCEDURE SendApprovalRequestFromRecord(RecRef: RecordRef; WorkflowStepInstance: Record 1504);
    VAR
        ApprovalEntry: Record 454;
        ApprovalEntry2: Record 454;
    BEGIN
        ApprovalEntry.SETCURRENTKEY("Table ID", "Record ID to Approve", Status, "Workflow Step Instance ID", "Sequence No.");
        ApprovalEntry.SETRANGE("Table ID", RecRef.NUMBER);
        ApprovalEntry.SETRANGE("Record ID to Approve", RecRef.RECORDID);
        ApprovalEntry.SETRANGE(Status, ApprovalEntry.Status::Created);
        ApprovalEntry.SETRANGE("Workflow Step Instance ID", WorkflowStepInstance.ID);

        IF ApprovalEntry.FINDFIRST THEN BEGIN
            ApprovalEntry2.COPYFILTERS(ApprovalEntry);
            ApprovalEntry2.SETRANGE("Sequence No.", ApprovalEntry."Sequence No.");
            IF ApprovalEntry2.FINDSET(TRUE) THEN
                REPEAT
                    ApprovalEntry2.VALIDATE(Status, ApprovalEntry2.Status::Open);
                    ApprovalEntry2.MODIFY(TRUE);
                    CreateApprovalEntryNotification(ApprovalEntry2, WorkflowStepInstance);
                UNTIL ApprovalEntry2.NEXT = 0;
            IF FindApprovedApprovalEntryForWorkflowUserGroup(ApprovalEntry, WorkflowStepInstance) THEN
                OnApproveApprovalRequest(ApprovalEntry);
            EXIT;
        END;

        ApprovalEntry.SETRANGE(Status, ApprovalEntry.Status::Approved);
        IF ApprovalEntry.FINDLAST THEN
            OnApproveApprovalRequest(ApprovalEntry)
        ELSE
            ERROR(NoApprovalRequestsFoundErr);
    END;

    //[External]
    PROCEDURE SendApprovalRequestFromApprovalEntry(ApprovalEntry: Record 454; WorkflowStepInstance: Record 1504);
    VAR
        ApprovalEntry2: Record 454;
        ApprovalEntry3: Record 454;
    BEGIN
        IF ApprovalEntry.Status = ApprovalEntry.Status::Open THEN BEGIN
            CreateApprovalEntryNotification(ApprovalEntry, WorkflowStepInstance);
            EXIT;
        END;

        IF FindOpenApprovalEntriesForWorkflowStepInstance(ApprovalEntry, WorkflowStepInstance."Record ID") THEN
            EXIT;

        ApprovalEntry2.SETCURRENTKEY("Table ID", "Document Type", "Document No.", "Sequence No.");
        ApprovalEntry2.SETRANGE("Record ID to Approve", ApprovalEntry."Record ID to Approve");
        ApprovalEntry2.SETRANGE(Status, ApprovalEntry2.Status::Created);

        IF ApprovalEntry2.FINDFIRST THEN BEGIN
            ApprovalEntry3.COPYFILTERS(ApprovalEntry2);
            ApprovalEntry3.SETRANGE("Sequence No.", ApprovalEntry2."Sequence No.");
            IF ApprovalEntry3.FINDSET THEN
                REPEAT
                    ApprovalEntry3.VALIDATE(Status, ApprovalEntry3.Status::Open);
                    ApprovalEntry3.MODIFY(TRUE);
                    CreateApprovalEntryNotification(ApprovalEntry3, WorkflowStepInstance);
                UNTIL ApprovalEntry3.NEXT = 0;
        END;
    END;

    //[External]
    PROCEDURE CreateApprovalRequests(RecRef: RecordRef; WorkflowStepInstance: Record 1504);
    VAR
        WorkflowStepArgument: Record 1523;
        ApprovalEntryArgument: Record 454;
    BEGIN
        PopulateApprovalEntryArgument(RecRef, WorkflowStepInstance, ApprovalEntryArgument);

        IF WorkflowStepArgument.GET(WorkflowStepInstance.Argument) THEN
            CASE WorkflowStepArgument."Approver Type" OF
                WorkflowStepArgument."Approver Type"::"Salesperson/Purchaser":
                    CreateApprReqForApprTypeSalespersPurchaser(WorkflowStepArgument, ApprovalEntryArgument);
                WorkflowStepArgument."Approver Type"::Approver:
                    CreateApprReqForApprTypeApprover(WorkflowStepArgument, ApprovalEntryArgument);
                WorkflowStepArgument."Approver Type"::"Workflow User Group":
                    CreateApprReqForApprTypeWorkflowUserGroup(WorkflowStepArgument, ApprovalEntryArgument);
            END;

        IF WorkflowStepArgument."Show Confirmation Message" THEN
            InformUserOnStatusChange(RecRef, WorkflowStepInstance.ID);
    END;


    LOCAL PROCEDURE CreateApprReqForApprTypeSalespersPurchaser(WorkflowStepArgument: Record 1523; ApprovalEntryArgument: Record 454);
    BEGIN
        ApprovalEntryArgument.TESTFIELD("Salespers./Purch. Code");

        CASE WorkflowStepArgument."Approver Limit Type" OF
            WorkflowStepArgument."Approver Limit Type"::"Approver Chain":
                BEGIN
                    CreateApprovalRequestForSalespersPurchaser(WorkflowStepArgument, ApprovalEntryArgument);
                    CreateApprovalRequestForChainOfApprovers(WorkflowStepArgument, ApprovalEntryArgument);
                END;
            WorkflowStepArgument."Approver Limit Type"::"Direct Approver":
                CreateApprovalRequestForSalespersPurchaser(WorkflowStepArgument, ApprovalEntryArgument);
            WorkflowStepArgument."Approver Limit Type"::"First Qualified Approver":
                BEGIN
                    CreateApprovalRequestForSalespersPurchaser(WorkflowStepArgument, ApprovalEntryArgument);
                    CreateApprovalRequestForApproverWithSufficientLimit(WorkflowStepArgument, ApprovalEntryArgument);
                END;
            WorkflowStepArgument."Approver Limit Type"::"Specific Approver":
                BEGIN
                    CreateApprovalRequestForSalespersPurchaser(WorkflowStepArgument, ApprovalEntryArgument);
                    CreateApprovalRequestForSpecificUser(WorkflowStepArgument, ApprovalEntryArgument);
                END;
        END;

        OnAfterCreateApprReqForApprTypeSalespersPurchaser(WorkflowStepArgument, ApprovalEntryArgument);
    END;

    LOCAL PROCEDURE CreateApprReqForApprTypeApprover(WorkflowStepArgument: Record 1523; ApprovalEntryArgument: Record 454);
    BEGIN
        CASE WorkflowStepArgument."Approver Limit Type" OF
            WorkflowStepArgument."Approver Limit Type"::"Approver Chain":
                BEGIN
                    CreateApprovalRequestForUser(WorkflowStepArgument, ApprovalEntryArgument);
                    CreateApprovalRequestForChainOfApprovers(WorkflowStepArgument, ApprovalEntryArgument);
                END;
            WorkflowStepArgument."Approver Limit Type"::"Direct Approver":
                CreateApprovalRequestForApprover(WorkflowStepArgument, ApprovalEntryArgument);
            WorkflowStepArgument."Approver Limit Type"::"First Qualified Approver":
                BEGIN
                    CreateApprovalRequestForUser(WorkflowStepArgument, ApprovalEntryArgument);
                    CreateApprovalRequestForApproverWithSufficientLimit(WorkflowStepArgument, ApprovalEntryArgument);
                END;
            WorkflowStepArgument."Approver Limit Type"::"Specific Approver":
                CreateApprovalRequestForSpecificUser(WorkflowStepArgument, ApprovalEntryArgument);
        END;

        OnAfterCreateApprReqForApprTypeApprover(WorkflowStepArgument, ApprovalEntryArgument);
    END;

    LOCAL PROCEDURE CreateApprReqForApprTypeWorkflowUserGroup(WorkflowStepArgument: Record 1523; ApprovalEntryArgument: Record 454);
    VAR
        UserSetup: Record 91;
        WorkflowUserGroupMember: Record 1541;
        ApproverId: Code[50];
        SequenceNo: Integer;
    BEGIN
        IF NOT UserSetup.GET(USERID) THEN
            ERROR(UserIdNotInSetupErr, USERID);
        SequenceNo := GetLastSequenceNo(ApprovalEntryArgument);

        WITH WorkflowUserGroupMember DO BEGIN
            SETCURRENTKEY("Workflow User Group Code", "Sequence No.");
            SETRANGE("Workflow User Group Code", WorkflowStepArgument."Workflow User Group Code");

            IF NOT FINDSET THEN
                ERROR(NoWFUserGroupMembersErr);

            REPEAT
                ApproverId := "User Name";
                IF NOT UserSetup.GET(ApproverId) THEN
                    ERROR(WFUserGroupNotInSetupErr, ApproverId);
                MakeApprovalEntry(ApprovalEntryArgument, SequenceNo + "Sequence No.", ApproverId, WorkflowStepArgument);
            UNTIL NEXT = 0;
        END;

        OnAfterCreateApprReqForApprTypeWorkflowUserGroup(WorkflowStepArgument, ApprovalEntryArgument);
    END;

    LOCAL PROCEDURE CreateApprovalRequestForChainOfApprovers(WorkflowStepArgument: Record 1523; ApprovalEntryArgument: Record 454);
    BEGIN
        CreateApprovalRequestForApproverChain(WorkflowStepArgument, ApprovalEntryArgument, FALSE);
    END;

    LOCAL PROCEDURE CreateApprovalRequestForApproverWithSufficientLimit(WorkflowStepArgument: Record 1523; ApprovalEntryArgument: Record 454);
    BEGIN
        CreateApprovalRequestForApproverChain(WorkflowStepArgument, ApprovalEntryArgument, TRUE);
    END;

    LOCAL PROCEDURE CreateApprovalRequestForApproverChain(WorkflowStepArgument: Record 1523; ApprovalEntryArgument: Record 454; SufficientApproverOnly: Boolean);
    VAR
        ApprovalEntry: Record 454;
        UserSetup: Record 91;
        ApproverId: Code[50];
        SequenceNo: Integer;
    BEGIN
        ApproverId := USERID;

        WITH ApprovalEntry DO BEGIN
            SETCURRENTKEY("Record ID to Approve", "Workflow Step Instance ID", "Sequence No.");
            SETRANGE("Table ID", ApprovalEntryArgument."Table ID");
            SETRANGE("Record ID to Approve", ApprovalEntryArgument."Record ID to Approve");
            SETRANGE("Workflow Step Instance ID", ApprovalEntryArgument."Workflow Step Instance ID");
            SETRANGE(Status, Status::Created);
            IF FINDLAST THEN
                ApproverId := "Approver ID"
            ELSE
                IF (WorkflowStepArgument."Approver Type" = WorkflowStepArgument."Approver Type"::"Salesperson/Purchaser") AND
                   (WorkflowStepArgument."Approver Limit Type" = WorkflowStepArgument."Approver Limit Type"::"First Qualified Approver")
                THEN BEGIN
                    FindUserSetupBySalesPurchCode(UserSetup, ApprovalEntryArgument);
                    ApproverId := UserSetup."User ID";
                END;
        END;

        IF NOT UserSetup.GET(ApproverId) THEN
            ERROR(ApproverUserIdNotInSetupErr, ApprovalEntry."Sender ID");

        IF NOT IsSufficientApprover(UserSetup, ApprovalEntryArgument) THEN
            REPEAT
                ApproverId := UserSetup."Approver ID";

                IF ApproverId = '' THEN
                    ERROR(NoSuitableApproverFoundErr);

                IF NOT UserSetup.GET(ApproverId) THEN
                    ERROR(ApproverUserIdNotInSetupErr, UserSetup."User ID");

                // Approval Entry should not be created only when IsSufficientApprover is false and SufficientApproverOnly is true
                IF IsSufficientApprover(UserSetup, ApprovalEntryArgument) OR (NOT SufficientApproverOnly) THEN BEGIN
                    SequenceNo := GetLastSequenceNo(ApprovalEntryArgument) + 1;
                    MakeApprovalEntry(ApprovalEntryArgument, SequenceNo, ApproverId, WorkflowStepArgument);
                END;

            UNTIL IsSufficientApprover(UserSetup, ApprovalEntryArgument);
    END;

    LOCAL PROCEDURE CreateApprovalRequestForApprover(WorkflowStepArgument: Record 1523; ApprovalEntryArgument: Record 454);
    VAR
        UserSetup: Record 91;
        UsrId: Code[50];
        SequenceNo: Integer;
    BEGIN
        UsrId := USERID;

        SequenceNo := GetLastSequenceNo(ApprovalEntryArgument);

        IF NOT UserSetup.GET(USERID) THEN
            ERROR(UserIdNotInSetupErr, UsrId);

        UsrId := UserSetup."Approver ID";
        IF NOT UserSetup.GET(UsrId) THEN BEGIN
            IF NOT UserSetup."Approval Administrator" THEN
                ERROR(ApproverUserIdNotInSetupErr, UserSetup."User ID");
            UsrId := USERID;
        END;

        SequenceNo += 1;
        MakeApprovalEntry(ApprovalEntryArgument, SequenceNo, UsrId, WorkflowStepArgument);
    END;

    LOCAL PROCEDURE CreateApprovalRequestForSalespersPurchaser(WorkflowStepArgument: Record 1523; ApprovalEntryArgument: Record 454);
    VAR
        UserSetup: Record 91;
        SequenceNo: Integer;
    BEGIN
        SequenceNo := GetLastSequenceNo(ApprovalEntryArgument);

        FindUserSetupBySalesPurchCode(UserSetup, ApprovalEntryArgument);

        SequenceNo += 1;

        IF WorkflowStepArgument."Approver Limit Type" = WorkflowStepArgument."Approver Limit Type"::"First Qualified Approver" THEN BEGIN
            IF IsSufficientApprover(UserSetup, ApprovalEntryArgument) THEN
                MakeApprovalEntry(ApprovalEntryArgument, SequenceNo, UserSetup."User ID", WorkflowStepArgument);
        END ELSE
            MakeApprovalEntry(ApprovalEntryArgument, SequenceNo, UserSetup."User ID", WorkflowStepArgument);
    END;

    LOCAL PROCEDURE CreateApprovalRequestForUser(WorkflowStepArgument: Record 1523; ApprovalEntryArgument: Record 454);
    VAR
        SequenceNo: Integer;
    BEGIN
        SequenceNo := GetLastSequenceNo(ApprovalEntryArgument);

        SequenceNo += 1;
        MakeApprovalEntry(ApprovalEntryArgument, SequenceNo, USERID, WorkflowStepArgument);
    END;

    LOCAL PROCEDURE CreateApprovalRequestForSpecificUser(WorkflowStepArgument: Record 1523; ApprovalEntryArgument: Record 454);
    VAR
        UserSetup: Record 91;
        UsrId: Code[50];
        SequenceNo: Integer;
    BEGIN
        UsrId := WorkflowStepArgument."Approver User ID";

        SequenceNo := GetLastSequenceNo(ApprovalEntryArgument);

        IF NOT UserSetup.GET(UsrId) THEN
            ERROR(UserIdNotInSetupErr, UsrId);

        SequenceNo += 1;
        MakeApprovalEntry(ApprovalEntryArgument, SequenceNo, UsrId, WorkflowStepArgument);
    END;

    LOCAL PROCEDURE MakeApprovalEntry(ApprovalEntryArgument: Record 454; SequenceNo: Integer; ApproverId: Code[50]; WorkflowStepArgument: Record 1523);
    VAR
        ApprovalEntry: Record 454;
    BEGIN
        WITH ApprovalEntry DO BEGIN
            "Table ID" := ApprovalEntryArgument."Table ID";
            "Document Type" := ApprovalEntryArgument."Document Type";
            "Document No." := ApprovalEntryArgument."Document No.";
            "Salespers./Purch. Code" := ApprovalEntryArgument."Salespers./Purch. Code";
            "Sequence No." := SequenceNo;
            "Sender ID" := USERID;
            Amount := ApprovalEntryArgument.Amount;
            "Amount (LCY)" := ApprovalEntryArgument."Amount (LCY)";
            "Currency Code" := ApprovalEntryArgument."Currency Code";
            "Approver ID" := ApproverId;
            "Workflow Step Instance ID" := ApprovalEntryArgument."Workflow Step Instance ID";
            IF ApproverId = USERID THEN
                Status := Status::Approved
            ELSE
                Status := Status::Created;
            "Date-Time Sent for Approval" := CREATEDATETIME(TODAY, TIME);
            "Last Date-Time Modified" := CREATEDATETIME(TODAY, TIME);
            "Last Modified By User ID" := USERID;
            "Due Date" := CALCDATE(WorkflowStepArgument."Due Date Formula", TODAY);

            CASE WorkflowStepArgument."Delegate After" OF
                WorkflowStepArgument."Delegate After"::Never:
                    EVALUATE("Delegation Date Formula", '');
                WorkflowStepArgument."Delegate After"::"1 day":
                    EVALUATE("Delegation Date Formula", '<1D>');
                WorkflowStepArgument."Delegate After"::"2 days":
                    EVALUATE("Delegation Date Formula", '<2D>');
                WorkflowStepArgument."Delegate After"::"5 days":
                    EVALUATE("Delegation Date Formula", '<5D>');
                ELSE
                    EVALUATE("Delegation Date Formula", '');
            END;
            "Available Credit Limit (LCY)" := ApprovalEntryArgument."Available Credit Limit (LCY)";
            SetApproverType(WorkflowStepArgument, ApprovalEntry);
            SetLimitType(WorkflowStepArgument, ApprovalEntry);
            "Record ID to Approve" := ApprovalEntryArgument."Record ID to Approve";
            "Approval Code" := ApprovalEntryArgument."Approval Code";
            INSERT(TRUE);
        END;
    END;

    //[External]
    PROCEDURE CalcPurchaseDocAmount(PurchaseHeader: Record 38; VAR ApprovalAmount: Decimal; VAR ApprovalAmountLCY: Decimal);
    VAR
        TempPurchaseLine: Record 39 TEMPORARY;
        TotalPurchaseLine: Record 39;
        TotalPurchaseLineLCY: Record 39;
        PurchPost: Codeunit 90;
        TempAmount: Decimal;
        VAtText: Text[30];
    BEGIN
        PurchaseHeader.CalcInvDiscForHeader;
        PurchPost.GetPurchLines(PurchaseHeader, TempPurchaseLine, 0);
        CLEAR(PurchPost);
        PurchPost.SumPurchLinesTemp(
          PurchaseHeader, TempPurchaseLine, 0, TotalPurchaseLine, TotalPurchaseLineLCY,
          TempAmount, VAtText);
        ApprovalAmount := TotalPurchaseLine.Amount;
        ApprovalAmountLCY := TotalPurchaseLineLCY.Amount;
    END;

    //[External]
    PROCEDURE CalcSalesDocAmount(SalesHeader: Record 36; VAR ApprovalAmount: Decimal; VAR ApprovalAmountLCY: Decimal);
    VAR
        TempSalesLine: Record 37 TEMPORARY;
        TotalSalesLine: Record 37;
        TotalSalesLineLCY: Record 37;
        SalesPost: Codeunit 80;
        TempAmount: ARRAY[5] OF Decimal;
        VAtText: Text[30];
    BEGIN
        SalesHeader.CalcInvDiscForHeader;
        SalesPost.GetSalesLines(SalesHeader, TempSalesLine, 0);
        CLEAR(SalesPost);
        SalesPost.SumSalesLinesTemp(
          SalesHeader, TempSalesLine, 0, TotalSalesLine, TotalSalesLineLCY,
          TempAmount[1], VAtText, TempAmount[2], TempAmount[3], TempAmount[4]);
        ApprovalAmount := TotalSalesLine.Amount;
        ApprovalAmountLCY := TotalSalesLineLCY.Amount;
    END;

    LOCAL PROCEDURE PopulateApprovalEntryArgument(RecRef: RecordRef; WorkflowStepInstance: Record 1504; VAR ApprovalEntryArgument: Record 454);
    VAR
        Customer: Record 18;
        GenJournalBatch: Record 232;
        GenJournalLine: Record 81;
        PurchaseHeader: Record 38;
        SalesHeader: Record 36;
        IncomingDocument: Record 130;
        ApprovalAmount: Decimal;
        ApprovalAmountLCY: Decimal;
    BEGIN
        ApprovalEntryArgument.INIT;
        ApprovalEntryArgument."Table ID" := RecRef.NUMBER;
        ApprovalEntryArgument."Record ID to Approve" := RecRef.RECORDID;
        ApprovalEntryArgument."Document Type" := ApprovalEntryArgument."Document Type"::" ";
        ApprovalEntryArgument."Approval Code" := WorkflowStepInstance."Workflow Code";
        ApprovalEntryArgument."Workflow Step Instance ID" := WorkflowStepInstance.ID;

        CASE RecRef.NUMBER OF
            DATABASE::"Purchase Header":
                BEGIN
                    RecRef.SETTABLE(PurchaseHeader);
                    CalcPurchaseDocAmount(PurchaseHeader, ApprovalAmount, ApprovalAmountLCY);
                    ApprovalEntryArgument."Document Type" := PurchaseHeader."Document Type";
                    ApprovalEntryArgument."Document No." := PurchaseHeader."No.";
                    ApprovalEntryArgument."Salespers./Purch. Code" := PurchaseHeader."Purchaser Code";
                    ApprovalEntryArgument.Amount := ApprovalAmount;
                    ApprovalEntryArgument."Amount (LCY)" := ApprovalAmountLCY;
                    ApprovalEntryArgument."Currency Code" := PurchaseHeader."Currency Code";
                END;
            DATABASE::"Sales Header":
                BEGIN
                    RecRef.SETTABLE(SalesHeader);
                    CalcSalesDocAmount(SalesHeader, ApprovalAmount, ApprovalAmountLCY);
                    ApprovalEntryArgument."Document Type" := SalesHeader."Document Type";
                    ApprovalEntryArgument."Document No." := SalesHeader."No.";
                    ApprovalEntryArgument."Salespers./Purch. Code" := SalesHeader."Salesperson Code";
                    ApprovalEntryArgument.Amount := ApprovalAmount;
                    ApprovalEntryArgument."Amount (LCY)" := ApprovalAmountLCY;
                    ApprovalEntryArgument."Currency Code" := SalesHeader."Currency Code";
                    ApprovalEntryArgument."Available Credit Limit (LCY)" := GetAvailableCreditLimit(SalesHeader);
                END;
            DATABASE::Customer:
                BEGIN
                    RecRef.SETTABLE(Customer);
                    ApprovalEntryArgument."Salespers./Purch. Code" := Customer."Salesperson Code";
                    ApprovalEntryArgument."Currency Code" := Customer."Currency Code";
                    ApprovalEntryArgument."Available Credit Limit (LCY)" := Customer.CalcAvailableCredit;
                END;
            DATABASE::"Gen. Journal Batch":
                RecRef.SETTABLE(GenJournalBatch);
            DATABASE::"Gen. Journal Line":
                BEGIN
                    RecRef.SETTABLE(GenJournalLine);
                    ApprovalEntryArgument."Document Type" := GenJournalLine."Document Type";
                    ApprovalEntryArgument."Document No." := GenJournalLine."Document No.";
                    ApprovalEntryArgument."Salespers./Purch. Code" := GenJournalLine."Salespers./Purch. Code";
                    ApprovalEntryArgument.Amount := GenJournalLine.Amount;
                    ApprovalEntryArgument."Amount (LCY)" := GenJournalLine."Amount (LCY)";
                    ApprovalEntryArgument."Currency Code" := GenJournalLine."Currency Code";
                END;
            DATABASE::"Incoming Document":
                BEGIN
                    RecRef.SETTABLE(IncomingDocument);
                    ApprovalEntryArgument."Document No." := FORMAT(IncomingDocument."Entry No.");
                END;
            ELSE
                OnPopulateApprovalEntryArgument(RecRef, ApprovalEntryArgument, WorkflowStepInstance);
        END;
    END;

    //[External]
    PROCEDURE CreateApprovalEntryNotification(ApprovalEntry: Record 454; WorkflowStepInstance: Record 1504);
    VAR
        WorkflowStepArgument: Record 1523;
        NotificationEntry: Record 1511;
        UserSetup: Record 91;
    BEGIN
        IF NOT WorkflowStepArgument.GET(WorkflowStepInstance.Argument) THEN
            EXIT;

        IF WorkflowStepArgument."Notification User ID" = '' THEN BEGIN
            IF NOT UserSetup.GET(ApprovalEntry."Approver ID") THEN
                EXIT;
            WorkflowStepArgument.VALIDATE("Notification User ID", ApprovalEntry."Approver ID");
        END;

        ApprovalEntry.RESET;
        // NotificationEntry.CreateNewEntry(
        //   NotificationEntry.Type::Approval, WorkflowStepArgument."Notification User ID",
        //   ApprovalEntry, WorkflowStepArgument."Link Target Page", WorkflowStepArgument."Custom Link", ApprovalEntry."Sender ID");
    END;

    LOCAL PROCEDURE SetApproverType(WorkflowStepArgument: Record 1523; VAR ApprovalEntry: Record 454);
    BEGIN
        CASE WorkflowStepArgument."Approver Type" OF
            WorkflowStepArgument."Approver Type"::"Salesperson/Purchaser":
                ApprovalEntry."Approval Type" := ApprovalEntry."Approval Type"::"Sales Pers./Purchaser";
            WorkflowStepArgument."Approver Type"::Approver:
                ApprovalEntry."Approval Type" := ApprovalEntry."Approval Type"::Approver;
            WorkflowStepArgument."Approver Type"::"Workflow User Group":
                ApprovalEntry."Approval Type" := ApprovalEntry."Approval Type"::"Workflow User Group";
        END;
    END;

    LOCAL PROCEDURE SetLimitType(WorkflowStepArgument: Record 1523; VAR ApprovalEntry: Record 454);
    BEGIN
        CASE WorkflowStepArgument."Approver Limit Type" OF
            WorkflowStepArgument."Approver Limit Type"::"Approver Chain",
          WorkflowStepArgument."Approver Limit Type"::"First Qualified Approver":
                ApprovalEntry."Limit Type" := ApprovalEntry."Limit Type"::"Approval Limits";
            WorkflowStepArgument."Approver Limit Type"::"Direct Approver":
                ApprovalEntry."Limit Type" := ApprovalEntry."Limit Type"::"No Limits";
            WorkflowStepArgument."Approver Limit Type"::"Specific Approver":
                ApprovalEntry."Limit Type" := ApprovalEntry."Limit Type"::"No Limits";
        END;

        IF ApprovalEntry."Approval Type" = ApprovalEntry."Approval Type"::"Workflow User Group" THEN
            ApprovalEntry."Limit Type" := ApprovalEntry."Limit Type"::"No Limits";
    END;

    LOCAL PROCEDURE IsSufficientPurchApprover(UserSetup: Record 91; DocumentType: Enum "Purchase Document Type"; ApprovalAmountLCY: Decimal): Boolean;
    VAR
        PurchaseHeader: Record 38;
    BEGIN
        IF UserSetup."User ID" = UserSetup."Approver ID" THEN
            EXIT(TRUE);

        CASE DocumentType OF
            PurchaseHeader."Document Type"::Quote: //enum to option
                IF UserSetup."Unlimited Request Approval" OR
                   ((ApprovalAmountLCY <= UserSetup."Request Amount Approval Limit") AND (UserSetup."Request Amount Approval Limit" <> 0))
                THEN
                    EXIT(TRUE);
            ELSE
                IF UserSetup."Unlimited Purchase Approval" OR
                   ((ApprovalAmountLCY <= UserSetup."Purchase Amount Approval Limit") AND (UserSetup."Purchase Amount Approval Limit" <> 0))
                THEN
                    EXIT(TRUE);
        END;

        EXIT(FALSE);
    END;

    LOCAL PROCEDURE IsSufficientSalesApprover(UserSetup: Record 91; ApprovalAmountLCY: Decimal): Boolean;
    BEGIN
        IF UserSetup."User ID" = UserSetup."Approver ID" THEN
            EXIT(TRUE);

        IF UserSetup."Unlimited Sales Approval" OR
           ((ApprovalAmountLCY <= UserSetup."Sales Amount Approval Limit") AND (UserSetup."Sales Amount Approval Limit" <> 0))
        THEN
            EXIT(TRUE);

        EXIT(FALSE);
    END;

    LOCAL PROCEDURE IsSufficientGenJournalLineApprover(UserSetup: Record 91; ApprovalEntryArgument: Record 454): Boolean;
    VAR
        GenJournalLine: Record 81;
        RecRef: RecordRef;
    BEGIN
        RecRef.GET(ApprovalEntryArgument."Record ID to Approve");
        RecRef.SETTABLE(GenJournalLine);

        IF GenJournalLine.IsForPurchase THEN
            EXIT(IsSufficientPurchApprover(UserSetup, ApprovalEntryArgument."Document Type", ApprovalEntryArgument."Amount (LCY)")); //enum to option

        IF GenJournalLine.IsForSales THEN
            EXIT(IsSufficientSalesApprover(UserSetup, ApprovalEntryArgument."Amount (LCY)"));

        EXIT(TRUE);
    END;

    //[External]
    PROCEDURE IsSufficientApprover(UserSetup: Record 91; ApprovalEntryArgument: Record 454): Boolean;
    VAR
        IsSufficient: Boolean;
    BEGIN
        CASE ApprovalEntryArgument."Table ID" OF
            DATABASE::"Purchase Header":
                EXIT(IsSufficientPurchApprover(UserSetup, ApprovalEntryArgument."Document Type", ApprovalEntryArgument."Amount (LCY)")); //enum to option
            DATABASE::"Sales Header":
                EXIT(IsSufficientSalesApprover(UserSetup, ApprovalEntryArgument."Amount (LCY)"));
            DATABASE::"Gen. Journal Batch":
                MESSAGE(ApporvalChainIsUnsupportedMsg, FORMAT(ApprovalEntryArgument."Record ID to Approve"));
            DATABASE::"Gen. Journal Line":
                EXIT(IsSufficientGenJournalLineApprover(UserSetup, ApprovalEntryArgument));
        END;

        IsSufficient := TRUE;
        OnAfterIsSufficientApprover(UserSetup, ApprovalEntryArgument, IsSufficient);
        EXIT(IsSufficient);
    END;

    LOCAL PROCEDURE GetAvailableCreditLimit(SalesHeader: Record 36): Decimal;
    BEGIN
        EXIT(SalesHeader.CheckAvailableCreditLimit);
    END;

    //[External]
    PROCEDURE PrePostApprovalCheckSales(VAR SalesHeader: Record 36): Boolean;
    BEGIN
        IF IsSalesHeaderPendingApproval(SalesHeader) THEN
            ERROR(SalesPrePostCheckErr, SalesHeader."Document Type", SalesHeader."No.");

        EXIT(TRUE);
    END;

    //[External]
    PROCEDURE PrePostApprovalCheckPurch(VAR PurchaseHeader: Record 38): Boolean;
    BEGIN
        IF IsPurchaseHeaderPendingApproval(PurchaseHeader) THEN
            ERROR(PurchPrePostCheckErr, PurchaseHeader."Document Type", PurchaseHeader."No.");

        EXIT(TRUE);
    END;

    //[External]
    PROCEDURE IsIncomingDocApprovalsWorkflowEnabled(VAR IncomingDocument: Record 130): Boolean;
    BEGIN
        EXIT(WorkflowManagement.CanExecuteWorkflow(IncomingDocument, WorkflowEventHandling.RunWorkflowOnSendIncomingDocForApprovalCode));
    END;

    //[External]
    PROCEDURE IsPurchaseApprovalsWorkflowEnabled(VAR PurchaseHeader: Record 38): Boolean;
    VAR
        ApprovalPurchaseOrder: Codeunit 7206912;
        ApprovalPurchaseInvoice: Codeunit 7206913;
        ApprovalPurchaseCrMemo: Codeunit 7206928;
    BEGIN
        EXIT(WorkflowManagement.CanExecuteWorkflow(PurchaseHeader, WorkflowEventHandling.RunWorkflowOnSendPurchaseDocForApprovalCode));
    END;

    //[External]
    PROCEDURE IsPurchaseHeaderPendingApproval(VAR PurchaseHeader: Record 38): Boolean;
    BEGIN
        IF PurchaseHeader.Status <> PurchaseHeader.Status::Open THEN
            EXIT(FALSE);

        EXIT(IsPurchaseApprovalsWorkflowEnabled(PurchaseHeader));
    END;

    //[External]
    PROCEDURE IsSalesApprovalsWorkflowEnabled(VAR SalesHeader: Record 36): Boolean;
    BEGIN
        EXIT(WorkflowManagement.CanExecuteWorkflow(SalesHeader, WorkflowEventHandling.RunWorkflowOnSendSalesDocForApprovalCode));
    END;

    //[External]
    PROCEDURE IsSalesHeaderPendingApproval(VAR SalesHeader: Record 36): Boolean;
    BEGIN
        IF SalesHeader.Status <> SalesHeader.Status::Open THEN
            EXIT(FALSE);

        EXIT(IsSalesApprovalsWorkflowEnabled(SalesHeader));
    END;

    //[External]
    PROCEDURE IsGeneralJournalBatchApprovalsWorkflowEnabled(VAR GenJournalBatch: Record 232): Boolean;
    BEGIN
        EXIT(WorkflowManagement.CanExecuteWorkflow(GenJournalBatch,
            WorkflowEventHandling.RunWorkflowOnSendGeneralJournalBatchForApprovalCode));
    END;

    //[External]
    PROCEDURE IsGeneralJournalLineApprovalsWorkflowEnabled(VAR GenJournalLine: Record 81): Boolean;
    BEGIN
        EXIT(WorkflowManagement.CanExecuteWorkflow(GenJournalLine,
            WorkflowEventHandling.RunWorkflowOnSendGeneralJournalLineForApprovalCode));
    END;

    //[External]
    PROCEDURE CheckPurchaseApprovalPossible(VAR PurchaseHeader: Record 38): Boolean;
    BEGIN
        IF NOT IsPurchaseApprovalsWorkflowEnabled(PurchaseHeader) THEN
            ERROR(NoWorkflowEnabledErr);

        IF NOT PurchaseHeader.PurchLinesExist THEN
            ERROR(NothingToApproveErr);

        EXIT(TRUE);
    END;



    //[External]
    PROCEDURE CheckSalesApprovalPossible(VAR SalesHeader: Record 36): Boolean;
    BEGIN
        IF NOT IsSalesApprovalsWorkflowEnabled(SalesHeader) THEN
            ERROR(NoWorkflowEnabledErr);

        IF NOT SalesHeader.SalesLinesExist THEN
            ERROR(NothingToApproveErr);

        EXIT(TRUE);
    END;

    //[External]
    PROCEDURE CheckCustomerApprovalsWorkflowEnabled(VAR Customer: Record 18): Boolean;
    BEGIN
        IF NOT WorkflowManagement.CanExecuteWorkflow(Customer, WorkflowEventHandling.RunWorkflowOnSendCustomerForApprovalCode) THEN BEGIN
            IF WorkflowManagement.EnabledWorkflowExist(DATABASE::Customer, WorkflowEventHandling.RunWorkflowOnCustomerChangedCode) THEN
                EXIT(FALSE);
            ERROR(NoWorkflowEnabledErr);
        END;
        EXIT(TRUE);
    END;


    //[External]
    PROCEDURE CheckGeneralJournalBatchApprovalsWorkflowEnabled(VAR GenJournalBatch: Record 232): Boolean;
    BEGIN
        IF NOT
           WorkflowManagement.CanExecuteWorkflow(GenJournalBatch,
             WorkflowEventHandling.RunWorkflowOnSendGeneralJournalBatchForApprovalCode)
        THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    END;

    //[External]
    PROCEDURE CheckGeneralJournalLineApprovalsWorkflowEnabled(VAR GenJournalLine: Record 81): Boolean;
    BEGIN
        IF NOT
           WorkflowManagement.CanExecuteWorkflow(GenJournalLine,
             WorkflowEventHandling.RunWorkflowOnSendGeneralJournalLineForApprovalCode)
        THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    END;



    [EventSubscriber(ObjectType::Table, 232, OnAfterDeleteEvent, '', true, true)]
    //[External]
    PROCEDURE DeleteApprovalEntriesAfterDeleteGenJournalBatch(VAR Rec: Record 232; RunTrigger: Boolean);
    BEGIN
        IF NOT Rec.ISTEMPORARY THEN
            DeleteApprovalEntries(Rec.RECORDID);
    END;


    //[External]
    PROCEDURE PostApprovalEntries(ApprovedRecordID: RecordID; PostedRecordID: RecordID; PostedDocNo: Code[20]): Boolean;
    VAR
        ApprovalEntry: Record 454;
        PostedApprovalEntry: Record 456;
    BEGIN
        ApprovalEntry.SETAUTOCALCFIELDS("Pending Approvals", "Number of Approved Requests", "Number of Rejected Requests");
        ApprovalEntry.SETRANGE("Table ID", ApprovedRecordID.TABLENO);
        ApprovalEntry.SETRANGE("Record ID to Approve", ApprovedRecordID);
        IF NOT ApprovalEntry.FINDSET THEN
            EXIT(FALSE);

        REPEAT
            PostedApprovalEntry.INIT;
            PostedApprovalEntry.TRANSFERFIELDS(ApprovalEntry);
            PostedApprovalEntry."Number of Approved Requests" := ApprovalEntry."Number of Approved Requests";
            PostedApprovalEntry."Number of Rejected Requests" := ApprovalEntry."Number of Rejected Requests";
            PostedApprovalEntry."Table ID" := PostedRecordID.TABLENO;
            PostedApprovalEntry."Document No." := PostedDocNo;
            PostedApprovalEntry."Posted Record ID" := PostedRecordID;
            PostedApprovalEntry."Entry No." := 0;
            PostedApprovalEntry.INSERT(TRUE);
        UNTIL ApprovalEntry.NEXT = 0;

        PostApprovalCommentLines(ApprovedRecordID, PostedRecordID, PostedDocNo);
        EXIT(TRUE);
    END;

    LOCAL PROCEDURE PostApprovalCommentLines(ApprovedRecordID: RecordID; PostedRecordID: RecordID; PostedDocNo: Code[20]);
    VAR
        ApprovalCommentLine: Record 455;
        PostedApprovalCommentLine: Record 457;
    BEGIN
        ApprovalCommentLine.SETRANGE("Table ID", ApprovedRecordID.TABLENO);
        ApprovalCommentLine.SETRANGE("Record ID to Approve", ApprovedRecordID);
        IF ApprovalCommentLine.FINDSET THEN
            REPEAT
                PostedApprovalCommentLine.INIT;
                PostedApprovalCommentLine.TRANSFERFIELDS(ApprovalCommentLine);
                PostedApprovalCommentLine."Entry No." := 0;
                PostedApprovalCommentLine."Table ID" := PostedRecordID.TABLENO;
                PostedApprovalCommentLine."Document No." := PostedDocNo;
                PostedApprovalCommentLine."Posted Record ID" := PostedRecordID;
                PostedApprovalCommentLine.INSERT(TRUE);
            UNTIL ApprovalCommentLine.NEXT = 0;
    END;


    //[External]
    PROCEDURE DeletePostedApprovalEntries(PostedRecordID: RecordID);
    VAR
        PostedApprovalEntry: Record 456;
    BEGIN
        PostedApprovalEntry.SETRANGE("Table ID", PostedRecordID.TABLENO);
        PostedApprovalEntry.SETRANGE("Posted Record ID", PostedRecordID);
        PostedApprovalEntry.DELETEALL;
        DeletePostedApprovalCommentLines(PostedRecordID);
    END;

    LOCAL PROCEDURE DeletePostedApprovalCommentLines(PostedRecordID: RecordID);
    VAR
        PostedApprovalCommentLine: Record 457;
    BEGIN
        PostedApprovalCommentLine.SETRANGE("Table ID", PostedRecordID.TABLENO);
        PostedApprovalCommentLine.SETRANGE("Posted Record ID", PostedRecordID);
        IF NOT PostedApprovalCommentLine.ISEMPTY THEN
            PostedApprovalCommentLine.DELETEALL;
    END;

    //[External]
    PROCEDURE SetStatusToPendingApproval(VAR Variant: Variant);
    VAR
        SalesHeader: Record 36;
        PurchaseHeader: Record 38;
        IncomingDocument: Record 130;
        RecRef: RecordRef;
        IsHandled: Boolean;
    BEGIN
        RecRef.GETTABLE(Variant);

        CASE RecRef.NUMBER OF
            DATABASE::"Purchase Header":
                BEGIN
                    RecRef.SETTABLE(PurchaseHeader);
                    PurchaseHeader.VALIDATE(Status, PurchaseHeader.Status::"Pending Approval");
                    PurchaseHeader.MODIFY(TRUE);
                    Variant := PurchaseHeader;
                END;
            DATABASE::"Sales Header":
                BEGIN
                    RecRef.SETTABLE(SalesHeader);
                    SalesHeader.VALIDATE(Status, SalesHeader.Status::"Pending Approval");
                    SalesHeader.MODIFY(TRUE);
                    Variant := SalesHeader;
                END;
            DATABASE::"Incoming Document":
                BEGIN
                    RecRef.SETTABLE(IncomingDocument);
                    IncomingDocument.VALIDATE(Status, IncomingDocument.Status::"Pending Approval");
                    IncomingDocument.MODIFY(TRUE);
                    Variant := IncomingDocument;
                END;
            ELSE BEGIN
                IsHandled := FALSE;
                OnSetStatusToPendingApproval(RecRef, Variant, IsHandled);
                IF NOT IsHandled THEN
                    ERROR(UnsupportedRecordTypeErr, RecRef.CAPTION);
            END;
        END;
    END;

    //[External]
    PROCEDURE InformUserOnStatusChange(Variant: Variant; WorkflowInstanceId: GUID);
    VAR
        RecRef: RecordRef;
    BEGIN
        RecRef.GETTABLE(Variant);

        CASE RecRef.NUMBER OF
            DATABASE::"Purchase Header":
                ShowPurchApprovalStatus(Variant);
            DATABASE::"Sales Header":
                ShowSalesApprovalStatus(Variant);
            ELSE
                ShowApprovalStatus(RecRef.RECORDID, WorkflowInstanceId);
        END;
    END;


    LOCAL PROCEDURE ShowApprovalComments(Variant: Variant; WorkflowStepInstanceID: GUID);
    VAR
        ApprovalCommentLine: Record 455;
        ApprovalEntry: Record 454;
        ApprovalComments: Page 660;
        RecRef: RecordRef;
    BEGIN
        RecRef.GETTABLE(Variant);

        CASE RecRef.NUMBER OF
            DATABASE::"Approval Entry":
                BEGIN
                    ApprovalEntry := Variant;
                    RecRef.GET(ApprovalEntry."Record ID to Approve");
                    ApprovalCommentLine.SETRANGE("Table ID", RecRef.NUMBER);
                    ApprovalCommentLine.SETRANGE("Record ID to Approve", ApprovalEntry."Record ID to Approve");
                END;
            DATABASE::"Purchase Header":
                BEGIN
                    ApprovalCommentLine.SETRANGE("Table ID", RecRef.NUMBER);
                    ApprovalCommentLine.SETRANGE("Record ID to Approve", RecRef.RECORDID);
                    FindOpenApprovalEntryForCurrUser(ApprovalEntry, RecRef.RECORDID);
                END;
            DATABASE::"Sales Header":
                BEGIN
                    ApprovalCommentLine.SETRANGE("Table ID", RecRef.NUMBER);
                    ApprovalCommentLine.SETRANGE("Record ID to Approve", RecRef.RECORDID);
                    FindOpenApprovalEntryForCurrUser(ApprovalEntry, RecRef.RECORDID);
                END;
            ELSE BEGIN
                ApprovalCommentLine.SETRANGE("Table ID", RecRef.NUMBER);
                ApprovalCommentLine.SETRANGE("Record ID to Approve", RecRef.RECORDID);
                FindOpenApprovalEntryForCurrUser(ApprovalEntry, RecRef.RECORDID);
            END;
        END;

        IF ISNULLGUID(WorkflowStepInstanceID) AND (NOT ISNULLGUID(ApprovalEntry."Workflow Step Instance ID")) THEN
            WorkflowStepInstanceID := ApprovalEntry."Workflow Step Instance ID";

        ApprovalComments.SETTABLEVIEW(ApprovalCommentLine);
        ApprovalComments.SetWorkflowStepInstanceID(WorkflowStepInstanceID);
        ApprovalComments.RUN;
    END;

    //[External]
    PROCEDURE HasOpenApprovalEntriesForCurrentUser(RecordID: RecordID): Boolean;
    VAR
        ApprovalEntry: Record 454;
    BEGIN
        EXIT(FindOpenApprovalEntryForCurrUser(ApprovalEntry, RecordID));
    END;

    //[External]
    PROCEDURE HasOpenApprovalEntries(RecordID: RecordID): Boolean;
    VAR
        ApprovalEntry: Record 454;
    BEGIN
        ApprovalEntry.SETRANGE("Table ID", RecordID.TABLENO);
        ApprovalEntry.SETRANGE("Record ID to Approve", RecordID);
        ApprovalEntry.SETRANGE(Status, ApprovalEntry.Status::Open);
        ApprovalEntry.SETRANGE("Related to Change", FALSE);
        EXIT(NOT ApprovalEntry.ISEMPTY);
    END;

    //[External]
    PROCEDURE HasOpenOrPendingApprovalEntries(RecordID: RecordID): Boolean;
    VAR
        ApprovalEntry: Record 454;
    BEGIN
        ApprovalEntry.SETRANGE("Table ID", RecordID.TABLENO);
        ApprovalEntry.SETRANGE("Record ID to Approve", RecordID);
        ApprovalEntry.SETFILTER(Status, '%1|%2', ApprovalEntry.Status::Open, ApprovalEntry.Status::Created);
        ApprovalEntry.SETRANGE("Related to Change", FALSE);
        EXIT(NOT ApprovalEntry.ISEMPTY);
    END;

    //[External]
    PROCEDURE HasApprovalEntries(RecordID: RecordID): Boolean;
    VAR
        ApprovalEntry: Record 454;
    BEGIN
        ApprovalEntry.SETRANGE("Table ID", RecordID.TABLENO);
        ApprovalEntry.SETRANGE("Record ID to Approve", RecordID);
        ApprovalEntry.SETRANGE("Related to Change", FALSE);
        EXIT(NOT ApprovalEntry.ISEMPTY);
    END;

    LOCAL PROCEDURE HasPendingApprovalEntriesForWorkflow(RecId: RecordID; WorkflowInstanceId: GUID): Boolean;
    VAR
        ApprovalEntry: Record 454;
    BEGIN
        ApprovalEntry.SETRANGE("Record ID to Approve", RecId);
        ApprovalEntry.SETFILTER(Status, '%1|%2', ApprovalEntry.Status::Open, ApprovalEntry.Status::Created);
        ApprovalEntry.SETFILTER("Workflow Step Instance ID", WorkflowInstanceId);
        EXIT(NOT ApprovalEntry.ISEMPTY);
    END;

    //[External]
    PROCEDURE HasAnyOpenJournalLineApprovalEntries(JournalTemplateName: Code[20]; JournalBatchName: Code[20]): Boolean;
    VAR
        GenJournalLine: Record 81;
        ApprovalEntry: Record 454;
        GenJournalLineRecRef: RecordRef;
        GenJournalLineRecordID: RecordID;
    BEGIN
        ApprovalEntry.SETRANGE("Table ID", DATABASE::"Gen. Journal Line");
        ApprovalEntry.SETRANGE(Status, ApprovalEntry.Status::Open);
        ApprovalEntry.SETRANGE("Related to Change", FALSE);
        IF ApprovalEntry.ISEMPTY THEN
            EXIT(FALSE);

        GenJournalLine.SETRANGE("Journal Template Name", JournalTemplateName);
        GenJournalLine.SETRANGE("Journal Batch Name", JournalBatchName);
        IF GenJournalLine.ISEMPTY THEN
            EXIT(FALSE);

        IF GenJournalLine.COUNT < ApprovalEntry.COUNT THEN BEGIN
            GenJournalLine.FINDSET;
            REPEAT
                IF HasOpenApprovalEntries(GenJournalLine.RECORDID) THEN
                    EXIT(TRUE);
            UNTIL GenJournalLine.NEXT = 0;
        END ELSE BEGIN
            ApprovalEntry.FINDSET;
            REPEAT
                GenJournalLineRecordID := ApprovalEntry."Record ID to Approve";
                GenJournalLineRecRef := GenJournalLineRecordID.GETRECORD;
                GenJournalLineRecRef.SETTABLE(GenJournalLine);
                IF (GenJournalLine."Journal Template Name" = JournalTemplateName) AND
                   (GenJournalLine."Journal Batch Name" = JournalBatchName)
                THEN
                    EXIT(TRUE);
            UNTIL ApprovalEntry.NEXT = 0;
        END;

        EXIT(FALSE)
    END;

    //[External]
    PROCEDURE TrySendJournalBatchApprovalRequest(VAR GenJournalLine: Record 81);
    VAR
        GenJournalBatch: Record 232;
    BEGIN
        GetGeneralJournalBatch(GenJournalBatch, GenJournalLine);
        CheckGeneralJournalBatchApprovalsWorkflowEnabled(GenJournalBatch);
        IF HasOpenApprovalEntries(GenJournalBatch.RECORDID) OR
           HasAnyOpenJournalLineApprovalEntries(GenJournalBatch."Journal Template Name", GenJournalBatch.Name)
        THEN
            ERROR(PendingJournalBatchApprovalExistsErr);
        OnSendGeneralJournalBatchForApproval(GenJournalBatch);
    END;

    //[External]
    PROCEDURE TrySendJournalLineApprovalRequests(VAR GenJournalLine: Record 81);
    VAR
        LinesSent: Integer;
    BEGIN
        IF GenJournalLine.COUNT = 1 THEN
            CheckGeneralJournalLineApprovalsWorkflowEnabled(GenJournalLine);

        REPEAT
            IF WorkflowManagement.CanExecuteWorkflow(GenJournalLine,
                 WorkflowEventHandling.RunWorkflowOnSendGeneralJournalLineForApprovalCode) AND
               NOT HasOpenApprovalEntries(GenJournalLine.RECORDID)
            THEN BEGIN
                OnSendGeneralJournalLineForApproval(GenJournalLine);
                LinesSent += 1;
            END;
        UNTIL GenJournalLine.NEXT = 0;

        CASE LinesSent OF
            0:
                MESSAGE(NoApprovalsSentMsg);
            GenJournalLine.COUNT:
                MESSAGE(PendingApprovalForSelectedLinesMsg);
            ELSE
                MESSAGE(PendingApprovalForSomeSelectedLinesMsg);
        END;
    END;

    LOCAL PROCEDURE GetGeneralJournalBatch(VAR GenJournalBatch: Record 232; VAR GenJournalLine: Record 81);
    BEGIN
        IF NOT GenJournalBatch.GET(GenJournalLine."Journal Template Name", GenJournalLine."Journal Batch Name") THEN
            GenJournalBatch.GET(GenJournalLine.GETFILTER("Journal Template Name"), GenJournalLine.GETFILTER("Journal Batch Name"));
    END;


    [EventSubscriber(ObjectType::Codeunit, 1535, OnDeleteRecordInApprovalRequest, '', true, true)]
    //[External]
    PROCEDURE DeleteApprovalEntries(RecordIDToApprove: RecordID);
    VAR
        ApprovalEntry: Record 454;
    BEGIN
        ApprovalEntry.SETRANGE("Table ID", RecordIDToApprove.TABLENO);
        ApprovalEntry.SETRANGE("Record ID to Approve", RecordIDToApprove);
        IF NOT ApprovalEntry.ISEMPTY THEN
            ApprovalEntry.DELETEALL(TRUE);
        DeleteApprovalCommentLines(RecordIDToApprove);
    END;

    //[External]
    PROCEDURE DeleteApprovalCommentLines(RecordIDToApprove: RecordID);
    VAR
        ApprovalCommentLine: Record 455;
    BEGIN
        ApprovalCommentLine.SETRANGE("Table ID", RecordIDToApprove.TABLENO);
        ApprovalCommentLine.SETRANGE("Record ID to Approve", RecordIDToApprove);
        IF NOT ApprovalCommentLine.ISEMPTY THEN
            ApprovalCommentLine.DELETEALL(TRUE);
    END;

    //[External]
    PROCEDURE CopyApprovalEntryQuoteToOrder(FromRecID: RecordID; ToDocNo: Code[20]; ToRecID: RecordID);
    VAR
        FromApprovalEntry: Record 454;
        ToApprovalEntry: Record 454;
        FromApprovalCommentLine: Record 455;
        ToApprovalCommentLine: Record 455;
        LastEntryNo: Integer;
    BEGIN
        FromApprovalEntry.SETRANGE("Table ID", FromRecID.TABLENO);
        FromApprovalEntry.SETRANGE("Record ID to Approve", FromRecID);
        IF FromApprovalEntry.FINDSET THEN BEGIN
            ToApprovalEntry.FINDLAST;
            LastEntryNo := ToApprovalEntry."Entry No.";
            REPEAT
                ToApprovalEntry := FromApprovalEntry;
                ToApprovalEntry."Entry No." := LastEntryNo + 1;
                ToApprovalEntry."Document Type" := ToApprovalEntry."Document Type"::Order;
                ToApprovalEntry."Document No." := ToDocNo;
                ToApprovalEntry."Record ID to Approve" := ToRecID;
                LastEntryNo += 1;
                ToApprovalEntry.INSERT;
            UNTIL FromApprovalEntry.NEXT = 0;

            FromApprovalCommentLine.SETRANGE("Table ID", FromRecID.TABLENO);
            FromApprovalCommentLine.SETRANGE("Record ID to Approve", FromRecID);
            IF FromApprovalCommentLine.FINDSET THEN BEGIN
                ToApprovalCommentLine.FINDLAST;
                LastEntryNo := ToApprovalCommentLine."Entry No.";
                REPEAT
                    ToApprovalCommentLine := FromApprovalCommentLine;
                    ToApprovalCommentLine."Entry No." := LastEntryNo + 1;
                    ToApprovalCommentLine."Document Type" := ToApprovalCommentLine."Document Type"::Order;
                    ToApprovalCommentLine."Document No." := ToDocNo;
                    ToApprovalCommentLine."Record ID to Approve" := ToRecID;
                    ToApprovalCommentLine.INSERT;
                    LastEntryNo += 1;
                UNTIL FromApprovalCommentLine.NEXT = 0;
            END;
        END;
    END;

    LOCAL PROCEDURE GetLastSequenceNo(ApprovalEntryArgument: Record 454): Integer;
    VAR
        ApprovalEntry: Record 454;
    BEGIN
        WITH ApprovalEntry DO BEGIN
            SETCURRENTKEY("Record ID to Approve", "Workflow Step Instance ID", "Sequence No.");
            SETRANGE("Table ID", ApprovalEntryArgument."Table ID");
            SETRANGE("Record ID to Approve", ApprovalEntryArgument."Record ID to Approve");
            SETRANGE("Workflow Step Instance ID", ApprovalEntryArgument."Workflow Step Instance ID");
            IF FINDLAST THEN
                EXIT("Sequence No.");
        END;
        EXIT(0);
    END;


    //[External]
    PROCEDURE CanCancelApprovalForRecord(RecID: RecordID): Boolean;
    VAR
        ApprovalEntry: Record 454;
        UserSetup: Record 91;
    BEGIN
        IF NOT UserSetup.GET(USERID) THEN
            EXIT(FALSE);

        ApprovalEntry.SETRANGE("Table ID", RecID.TABLENO);
        ApprovalEntry.SETRANGE("Record ID to Approve", RecID);
        ApprovalEntry.SETFILTER(Status, '%1|%2', ApprovalEntry.Status::Created, ApprovalEntry.Status::Open);
        ApprovalEntry.SETRANGE("Related to Change", FALSE);

        IF NOT UserSetup."Approval Administrator" THEN
            ApprovalEntry.SETRANGE("Sender ID", USERID);
        EXIT(ApprovalEntry.FINDFIRST);
    END;

    LOCAL PROCEDURE FindUserSetupBySalesPurchCode(VAR UserSetup: Record 91; ApprovalEntryArgument: Record 454);
    BEGIN
        IF ApprovalEntryArgument."Salespers./Purch. Code" <> '' THEN BEGIN
            UserSetup.SETCURRENTKEY("Salespers./Purch. Code");
            UserSetup.SETRANGE("Salespers./Purch. Code", ApprovalEntryArgument."Salespers./Purch. Code");
            IF NOT UserSetup.FINDFIRST THEN
                ERROR(
                  PurchaserUserNotFoundErr, UserSetup."User ID", UserSetup.FIELDCAPTION("Salespers./Purch. Code"),
                  UserSetup."Salespers./Purch. Code");
            EXIT;
        END;
    END;

    LOCAL PROCEDURE CheckUserAsApprovalAdministrator();
    VAR
        UserSetup: Record 91;
    BEGIN
        UserSetup.GET(USERID);
        UserSetup.TESTFIELD("Approval Administrator");
    END;

    LOCAL PROCEDURE FindApprovedApprovalEntryForWorkflowUserGroup(VAR ApprovalEntry: Record 454; WorkflowStepInstance: Record 1504): Boolean;
    VAR
        WorkflowStepArgument: Record 1523;
        WorkflowResponseHandling: Codeunit 1521;
        WorkflowInstance: Query 1501;
    BEGIN
        WorkflowInstance.SETRANGE(Function_Name, WorkflowResponseHandling.CreateApprovalRequestsCode);
        WorkflowInstance.SETRANGE(Record_ID, WorkflowStepInstance."Record ID");
        WorkflowInstance.SETRANGE(Code, WorkflowStepInstance."Workflow Code");
        WorkflowInstance.SETRANGE(Type, WorkflowInstance.Type::Response);
        WorkflowInstance.SETRANGE(Status, WorkflowInstance.Status::Completed);
        WorkflowInstance.OPEN;
        WHILE WorkflowInstance.READ DO
            IF WorkflowStepInstance.GET(WorkflowInstance.Instance_ID, WorkflowInstance.Code, WorkflowInstance.Step_ID) THEN
                IF WorkflowStepArgument.GET(WorkflowStepInstance.Argument) THEN
                    IF WorkflowStepArgument."Approver Type" = WorkflowStepArgument."Approver Type"::"Workflow User Group" THEN BEGIN
                        ApprovalEntry.SETRANGE(Status, ApprovalEntry.Status::Approved);
                        EXIT(ApprovalEntry.FINDLAST);
                    END;

        EXIT(FALSE);
    END;

    LOCAL PROCEDURE FindOpenApprovalEntriesForWorkflowStepInstance(ApprovalEntry: Record 454; WorkflowStepInstanceRecID: RecordID): Boolean;
    VAR
        ApprovalEntry2: Record 454;
    BEGIN
        IF ApprovalEntry."Approval Type" = ApprovalEntry."Approval Type"::"Workflow User Group" THEN
            ApprovalEntry2.SETFILTER("Sequence No.", '>%1', ApprovalEntry."Sequence No.");
        ApprovalEntry2.SETFILTER("Record ID to Approve", '%1|%2', WorkflowStepInstanceRecID, ApprovalEntry."Record ID to Approve");
        ApprovalEntry2.SETRANGE(Status, ApprovalEntry2.Status::Open);
        ApprovalEntry2.SETRANGE("Workflow Step Instance ID", ApprovalEntry."Workflow Step Instance ID");
        EXIT(NOT ApprovalEntry2.ISEMPTY);
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterCreateApprReqForApprTypeWorkflowUserGroup(WorkflowStepArgument: Record 1523; ApprovalEntryArgument: Record 454);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterCreateApprReqForApprTypeSalespersPurchaser(WorkflowStepArgument: Record 1523; ApprovalEntryArgument: Record 454);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterCreateApprReqForApprTypeApprover(WorkflowStepArgument: Record 1523; ApprovalEntryArgument: Record 454);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterIsSufficientApprover(UserSetup: Record 91; ApprovalEntryArgument: Record 454; VAR IsSufficient: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnSetStatusToPendingApproval(RecRef: RecordRef; VAR Variant: Variant; VAR IsHandled: Boolean);
    BEGIN
    END;

    LOCAL PROCEDURE "----------------------------------------------------- QB"();
    BEGIN
    END;

    PROCEDURE CreateApprovalEntry(RecRef: RecordRef; WorkflowStepInstance: Record 1504; SequenceNo: Integer; ApproverId: Code[50]; OriginalId: Code[50]; VAR ApprovalEntryArgument: Record 454; Position: Code[10]);
    VAR
        WorkflowStepArgument: Record 1523;
        ApprovalEntry: Record 454;
    BEGIN
        //JAV 13/03/20: - Se a�ade la funci�n "CreateApprovalEntry" para poder crear registros en el fichero de aprobaci�n pues la funci�n MakeApprovalEntry es de tipo LOCAL

        WorkflowStepArgument.GET(WorkflowStepInstance.Argument);
        PopulateApprovalEntryArgument(RecRef, WorkflowStepInstance, ApprovalEntryArgument);  //Campos del est�ndar
        OnPopulateApprovalEntryArgument(RecRef, ApprovalEntryArgument, WorkflowStepInstance);  //Para que informe de los datos de la aprobaci�n de QB

        //Creo el registro de aprobaci�n
        ApprovalEntry.LOCKTABLE;
        MakeApprovalEntry(ApprovalEntryArgument, SequenceNo, ApproverId, WorkflowStepArgument);
        ApprovalEntry.FINDLAST;
        ApprovalEntry."Posted Sheet" := ApprovalEntryArgument."Posted Sheet";
        ApprovalEntry."Job No." := ApprovalEntryArgument."Job No.";
        ApprovalEntry."Payment Terms Code" := ApprovalEntryArgument."Payment Terms Code";
        ApprovalEntry."Payment Method Code" := ApprovalEntryArgument."Payment Method Code";
        ApprovalEntry.Type := ApprovalEntryArgument.Type;
        ApprovalEntry.Withholding := ApprovalEntryArgument.Withholding;
        ApprovalEntry."QB Document Type" := ApprovalEntryArgument."QB Document Type";

        //JAV 24/12/20: - QB1.07.17 Miro las substituciones autom�ticas
        IF (OriginalId <> '') AND (OriginalId <> ApproverId) THEN BEGIN
            ApprovalEntry."QB Substituted" := TRUE;
            ApprovalEntry."QB Original Approver" := OriginalId;
        END;

        //JAV 02/03/22: - QB 1.10.22 Se a�aden las columnas "QB Position" y "QB_Piecework No."
        ApprovalEntry."QB Position" := Position;
        ApprovalEntry."QB_Piecework No." := ApprovalEntryArgument."QB_Piecework No.";

        ApprovalEntry.MODIFY;
    END;


    /*BEGIN
/*{
      JAV 13/03/20: - Se a�ade la funci�n "CreateApprovalEntry" para poder crear registros en el fichero de aprobaci�n pues la funci�n MakeApprovalEntry es de tipo LOCAL
      JAV 14/09/20: - QB 1.06.12 A�adir si est� activo el flujo de aprobaci�n de facturas de compra de QuoBuilding
      JAV 10/02/22: - QB 1.10.19 Se elimina el control anterior que no tiene ya sentido
      JAV 02/03/22: - QB 1.10.22 Se a�ade el campo "QB Position"
      JAV 27/10/22: - QB 1.12.09 Se a�ade el campo "QB_Piecework No."
    }
END.*/
}









