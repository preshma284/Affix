Codeunit 50102 "Gen. Jnl.-Post Preview 1"
{


    trigger OnRun()
    BEGIN
    END;

    VAR
        NothingToPostMsg: TextConst ENU = 'There is nothing to post.', ESP = 'No hay nada que registrar.';
        PreviewModeErr: TextConst ENU = 'Preview mode.', ESP = 'Modo de vista previa';
        PostingPreviewEventHandler: Codeunit 20;
        SubscriberTypeErr: TextConst ENU = 'Invalid Subscriber type. The type must be CODEUNIT.', ESP = 'Tipo de suscriptor no v�lido. El tipo debe ser CODEUNIT.';
        RecVarTypeErr: TextConst ENU = 'Invalid RecVar type. The type must be RECORD.', ESP = 'Tipo RecVar no v�lido. El tipo debe ser RECORD.';
        PreviewExitStateErr: TextConst ENU = 'The posting preview has stopped because of a state that is not valid.', ESP = 'La vista previa de registro se ha detenido debido a un estado no v�lido.';
        "----------------------------------------- QB": Integer;
        QBPostPreview: Codeunit 7207359;
        DetailedJobMovementsPreview: Codeunit 7207344;

    //[External]
    PROCEDURE Preview(Subscriber: Variant; RecVar: Variant);
    VAR
        RunResult: Boolean;
    BEGIN
        IF NOT Subscriber.ISCODEUNIT THEN
            ERROR(SubscriberTypeErr);
        IF NOT RecVar.ISRECORD THEN
            ERROR(RecVarTypeErr);

        BINDSUBSCRIPTION(PostingPreviewEventHandler);
        OnAfterBindSubscription;

        //QB Si no lo pongo aqu� no funciona el BINDING
        BINDSUBSCRIPTION(QBPostPreview);
        //QB fin

        RunResult := RunPreview(Subscriber, RecVar);

        UNBINDSUBSCRIPTION(PostingPreviewEventHandler);
        OnAfterUnbindSubscription;

        // The OnRunPreview event expects subscriber following template: Result := <Codeunit>.RUN
        // So we assume RunPreview returns FALSE with the error.
        // To prevent return FALSE without thrown error we check error call stack.
        IF RunResult OR (GETLASTERRORCALLSTACK = '') THEN
            ERROR(PreviewExitStateErr);

        IF GETLASTERRORTEXT <> PreviewModeErr THEN
            ERROR(GETLASTERRORTEXT);
        ShowAllEntries;
        ERROR('');
    END;

    //[External]

    LOCAL PROCEDURE ShowAllEntries();
    VAR
        TempDocumentEntry: Record 265 TEMPORARY;
        GLPostingPreview: Page 115;
    BEGIN
        PostingPreviewEventHandler.FillDocumentEntry(TempDocumentEntry);
        IF NOT TempDocumentEntry.ISEMPTY THEN BEGIN
            GLPostingPreview.Set(TempDocumentEntry, PostingPreviewEventHandler);
            GLPostingPreview.RUNMODAL
        END ELSE
            MESSAGE(NothingToPostMsg);
    END;

    //[External]
    PROCEDURE ShowDimensions(TableID: Integer; EntryNo: Integer; DimensionSetID: Integer);
    VAR
        DimMgt: Codeunit 408;
        RecRef: RecordRef;
    BEGIN
        RecRef.OPEN(TableID);
        DimMgt.ShowDimensionSet(DimensionSetID, STRSUBSTNO('%1 %2', RecRef.CAPTION, EntryNo));
    END;

    LOCAL PROCEDURE RunPreview(Subscriber: Variant; RecVar: Variant): Boolean;
    VAR
        Result: Boolean;
    BEGIN
        OnRunPreview(Result, Subscriber, RecVar);
        EXIT(Result);
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnRunPreview(VAR Result: Boolean; Subscriber: Variant; RecVar: Variant);
    BEGIN
    END;
    
    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterBindSubscription();
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterUnbindSubscription();
    BEGIN
    END;

    // //[IntegrationEvent]
    // LOCAL PROCEDURE OnSystemSetPostingPreviewActive(VAR Result: Boolean);
    // BEGIN
    // END;

    // //[IntegrationEvent]
    // LOCAL PROCEDURE OnAfterIsActive(VAR Result: Boolean);
    // BEGIN
    // END;

    // //[IntegrationEvent]
    // LOCAL PROCEDURE OnBeforeThrowError();
    // BEGIN
    // END;

    /* /*BEGIN
END.*/
}







