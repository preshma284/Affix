Codeunit 50623 "Batch Processing Mgt. 1"
{
  
  
    Permissions=TableData 52=rimd,
                TableData 54=rimd;
    trigger OnRun()
BEGIN
            RunCustomProcessing;
          END;
    VAR
      PostingTemplateMsg : TextConst ENU='Processing: @@@@@@@',ESP='Procesando: @@@@@@@';
      TempErrorMessage : Record 700 TEMPORARY;
      RecRefCustomerProcessing : RecordRef;
      ProcessingCodeunitID : Integer;
      BatchID : GUID;
      ProcessingCodeunitNotSetErr : TextConst ENU='A processing codeunit has not been selected.',ESP='No se ha seleccionado un codeunit de procesamiento.';
      BatchCompletedMsg : TextConst ENU='All the documents were processed.',ESP='Se han procesado todos los documentos.';
      BatchCompletedWithErrorsMsg : TextConst ENU='One or more of the documents could not be processed.',ESP='No ha sido posible procesar uno o m s documentos.';
      IsCustomProcessingHandled : Boolean;
      KeepParameters : Boolean;

    //[External]
    PROCEDURE BatchProcess(VAR RecRef : RecordRef);
    VAR
      Window : Dialog;
      CounterTotal : Integer;
      CounterToPost : Integer;
      CounterPosted : Integer;
      BatchConfirm : Option " ","Skip","Update";
    BEGIN
      IF ProcessingCodeunitID = 0 THEN
        ERROR(ProcessingCodeunitNotSetErr);

      WITH RecRef DO BEGIN
        IF ISEMPTY THEN
          EXIT;

        TempErrorMessage.DELETEALL;

        FillBatchProcessingMap(RecRef);
        COMMIT;

        FINDSET;

        IF GUIALLOWED THEN BEGIN
          Window.OPEN(PostingTemplateMsg);
          CounterTotal := COUNT;
        END;

        REPEAT
          IF GUIALLOWED THEN BEGIN
            CounterToPost += 1;
            Window.UPDATE(1,ROUND(CounterToPost / CounterTotal * 10000,1));
          END;

          IF CanProcessRecord(RecRef) THEN
            IF ProcessRecord(RecRef,BatchConfirm) THEN
              CounterPosted += 1;
        UNTIL NEXT = 0;

        ResetBatchID;

        IF GUIALLOWED THEN BEGIN
          Window.CLOSE;
          IF CounterPosted <> CounterTotal THEN
            MESSAGE(BatchCompletedWithErrorsMsg)
          ELSE
            MESSAGE(BatchCompletedMsg);
        END;
      END;

      OnAfterBatchProcess(RecRef,CounterPosted);
    END;

    LOCAL PROCEDURE CanProcessRecord(VAR RecRef : RecordRef) : Boolean;
    VAR
      Result : Boolean;
    BEGIN
      Result := TRUE;
      OnVerifyRecord(RecRef,Result);

      EXIT(Result);
    END;

    LOCAL PROCEDURE FillBatchProcessingMap(VAR RecRef : RecordRef);
    BEGIN
      WITH RecRef DO BEGIN
        FINDSET;
        REPEAT
          DeleteLostParameters(RECORDID);
          InsertBatchProcessingSessionMapEntry(RecRef);
        UNTIL NEXT = 0;
      END;
    END;

    //[External]
    PROCEDURE GetErrorMessages(VAR TempErrorMessageResult : Record 700 TEMPORARY);
    BEGIN
      TempErrorMessageResult.COPY(TempErrorMessage,TRUE);
    END;

    LOCAL PROCEDURE InsertBatchProcessingSessionMapEntry(RecRef : RecordRef);
    VAR
      BatchProcessingSessionMap : Record 54;
    BEGIN
      IF ISNULLGUID(BatchID) THEN
        EXIT;

      BatchProcessingSessionMap.INIT;
      BatchProcessingSessionMap."Record ID" := RecRef.RECORDID;
      BatchProcessingSessionMap."Batch ID" := BatchID;
      BatchProcessingSessionMap."User ID" := USERSECURITYID;
      BatchProcessingSessionMap."Session ID" := SESSIONID;
      BatchProcessingSessionMap.INSERT;
    END;

    LOCAL PROCEDURE InvokeProcessing(VAR RecRef : RecordRef) : Boolean;
    VAR
      BatchProcessingMgt : Codeunit 1380;
      RecVar : Variant;
      Result : Boolean;
    BEGIN
      CLEARLASTERROR;

      BatchProcessingMgt.SetRecRefForCustomProcessing(RecRef);
      Result := BatchProcessingMgt.RUN;
      BatchProcessingMgt.GetRecRefForCustomProcessing(RecRef);

      RecVar := RecRef;

      IF (GETLASTERRORCALLSTACK = '') AND Result AND NOT BatchProcessingMgt.GetIsCustomProcessingHandled THEN
        Result := CODEUNIT.RUN(ProcessingCodeunitID,RecVar);
      IF BatchProcessingMgt.GetIsCustomProcessingHandled THEN
        KeepParameters := BatchProcessingMgt.GetKeepParameters;
      IF NOT Result THEN
        LogError(RecVar,Result);

      RecRef.GETTABLE(RecVar);

      EXIT(Result);
    END;

    LOCAL PROCEDURE RunCustomProcessing();
    VAR
      Handled : Boolean;
      KeepParametersLocal : Boolean;
    BEGIN
      OnCustomProcessing(RecRefCustomerProcessing,Handled,KeepParametersLocal);
      IsCustomProcessingHandled := Handled;
      KeepParameters := KeepParametersLocal;
    END;

    LOCAL PROCEDURE InitBatchID();
    BEGIN
      IF ISNULLGUID(BatchID) THEN
        BatchID := CREATEGUID;
    END;

    LOCAL PROCEDURE LogError(RecVar : Variant;RunResult : Boolean);
    BEGIN
      IF NOT RunResult THEN
        TempErrorMessage.LogMessage(RecVar,0,TempErrorMessage."Message Type"::Error,GETLASTERRORTEXT);
    END;

    LOCAL PROCEDURE ProcessRecord(VAR RecRef : RecordRef;VAR BatchConfirm : Option) : Boolean;
    VAR
      ProcessingResult : Boolean;
    BEGIN
      OnBeforeBatchProcessing(RecRef,BatchConfirm);

      ProcessingResult := InvokeProcessing(RecRef);

      OnAfterBatchProcessing(RecRef,ProcessingResult);

      EXIT(ProcessingResult);
    END;

    //[External]
    PROCEDURE ResetBatchID();
    VAR
      BatchProcessingParameter : Record 52;
      BatchProcessingSessionMap : Record 54;
    BEGIN
      IF NOT KeepParameters THEN BEGIN
        BatchProcessingParameter.SETRANGE("Batch ID",BatchID);
        BatchProcessingParameter.DELETEALL;

        BatchProcessingSessionMap.SETRANGE("Batch ID",BatchID);
        BatchProcessingSessionMap.DELETEALL;
      END;

      CLEAR(BatchID);

      COMMIT;
    END;

    PROCEDURE DeleteProcessingSessionMapForRecordId(RecordIDToClean : RecordID);
    VAR
      BatchProcessingSessionMap : Record 54;
    BEGIN
      BatchProcessingSessionMap.SETRANGE("Record ID",RecordIDToClean);
      BatchProcessingSessionMap.SETRANGE("Batch ID",BatchID);
      BatchProcessingSessionMap.DELETEALL;
    END;

    LOCAL PROCEDURE DeleteLostParameters(RecordID : RecordID);
    VAR
      BatchProcessingSessionMap : Record 54;
      BatchProcessingParameter : Record 52;
    BEGIN
      BatchProcessingSessionMap.SETRANGE("Record ID",RecordID);
      BatchProcessingSessionMap.SETRANGE("User ID",USERSECURITYID);
      BatchProcessingSessionMap.SETRANGE("Session ID",SESSIONID);
      BatchProcessingSessionMap.SETFILTER("Batch ID",'<>%1',BatchID);
      IF BatchProcessingSessionMap.FINDSET THEN BEGIN
        REPEAT
          BatchProcessingParameter.SETRANGE("Batch ID",BatchProcessingSessionMap."Batch ID");
          IF NOT BatchProcessingParameter.ISEMPTY THEN
            BatchProcessingParameter.DELETEALL;
        UNTIL BatchProcessingSessionMap.NEXT = 0;
        BatchProcessingSessionMap.DELETEALL;
      END;
    END;

    PROCEDURE AddParameter(ParameterId : Integer;Value : Variant);
    VAR
      BatchProcessingParameter : Record 52;
    BEGIN
      InitBatchID;

      BatchProcessingParameter.INIT;
      BatchProcessingParameter."Batch ID" := BatchID;
      BatchProcessingParameter."Parameter Id" := ParameterId;
      BatchProcessingParameter."Parameter Value" := FORMAT(Value);
      BatchProcessingParameter.INSERT;
    END;

    PROCEDURE GetParameterText(RecordID : RecordID;ParameterId : Integer;VAR ParameterValue : Text[250]) : Boolean;
    VAR
      BatchProcessingParameter : Record 52;
      BatchProcessingSessionMap : Record 54;
    BEGIN
      BatchProcessingSessionMap.SETRANGE("Record ID",RecordID);
      BatchProcessingSessionMap.SETRANGE("User ID",USERSECURITYID);
      BatchProcessingSessionMap.SETRANGE("Session ID",SESSIONID);

      IF NOT BatchProcessingSessionMap.FINDFIRST THEN
        EXIT(FALSE);

      IF NOT BatchProcessingParameter.GET(BatchProcessingSessionMap."Batch ID",ParameterId) THEN
        EXIT(FALSE);

      ParameterValue := BatchProcessingParameter."Parameter Value";
      EXIT(TRUE);
    END;

    //[External]
    PROCEDURE GetParameterBoolean(RecordID : RecordID;ParameterId : Integer;VAR ParameterValue : Boolean) : Boolean;
    VAR
      Result : Boolean;
      Value : Text[250];
    BEGIN
      IF NOT GetParameterText(RecordID,ParameterId,Value) THEN
        EXIT(FALSE);

      IF NOT EVALUATE(Result,Value) THEN
        EXIT(FALSE);

      ParameterValue := Result;
      EXIT(TRUE);
    END;

    PROCEDURE GetParameterInteger(RecordID : RecordID;ParameterId : Integer;VAR ParameterValue : Integer) : Boolean;
    VAR
      Result : Integer;
      Value : Text[250];
    BEGIN
      IF NOT GetParameterText(RecordID,ParameterId,Value) THEN
        EXIT(FALSE);

      IF NOT EVALUATE(Result,Value) THEN
        EXIT(FALSE);

      ParameterValue := Result;
      EXIT(TRUE);
    END;

    //[External]
    PROCEDURE GetParameterDate(RecordID : RecordID;ParameterId : Integer;VAR ParameterValue : Date) : Boolean;
    VAR
      Result : Date;
      Value : Text[250];
    BEGIN
      IF NOT GetParameterText(RecordID,ParameterId,Value) THEN
        EXIT(FALSE);

      IF NOT EVALUATE(Result,Value) THEN
        EXIT(FALSE);

      ParameterValue := Result;
      EXIT(TRUE);
    END;

    
    //[IntegrationEvent]
    LOCAL PROCEDURE OnVerifyRecord(VAR RecRef : RecordRef;VAR Result : Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeBatchProcessing(VAR RecRef : RecordRef;VAR BatchConfirm : Option);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterBatchProcess(VAR RecRef : RecordRef;VAR CounterPosted : Integer);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterBatchProcessing(VAR RecRef : RecordRef;PostingResult : Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnCustomProcessing(VAR RecRef : RecordRef;VAR Handled : Boolean;VAR KeepParameters : Boolean);
    BEGIN
    END;

    /* /*BEGIN
END.*/
}





