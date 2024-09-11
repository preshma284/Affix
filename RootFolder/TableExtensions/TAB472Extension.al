tableextension 50864 "MyExtension50864" extends "Job Queue Entry"
{
  
  /*
Permissions=TableData 472 rimd,
                TableData 474 rim;
*/DataCaptionFields="Object Type to Run","Object ID to Run","Object Caption to Run";
    /*
ReplicateData=false;
*/
    CaptionML=ENU='Job Queue Entry',ESP='Mov. cola proyecto';
    LookupPageID="Job Queue Entries";
    DrillDownPageID="Job Queue Entries";
  
  fields
{
    field(50001;"AutoRestart";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Auto Restart',ESP='Auto Reinicio'; ;


    }
}
  keys
{
   // key(key1;"ID")
  //  {
       /* Clustered=true;
 */
   // }
}
  fieldgroups
{
}
  
    var
//       NoErrMsg@1000 :
      NoErrMsg: TextConst ENU='There is no error message.',ESP='No hay ning£n mensaje de error.';
//       CannotDeleteEntryErr@1001 :
      CannotDeleteEntryErr: 
// %1 is a status value, such as Success or Error.
TextConst ENU='You cannot delete an entry that has status %1.',ESP='No puede eliminar un movimiento con estado %1.';
//       DeletedEntryErr@1008 :
      DeletedEntryErr: TextConst ENU='The job queue entry has been deleted.',ESP='Se ha borrado el movimiento de cola de proyectos.';
//       ScheduledForPostingMsg@1002 :
      ScheduledForPostingMsg: 
// "%1=a date, %2 = a user."
TextConst ENU='Scheduled for posting on %1 by %2.',ESP='Programado para registro el %1 por %2.';
//       NoRecordErr@1003 :
      NoRecordErr: TextConst ENU='No record is associated with the job queue entry.',ESP='No hay registros asociados con la entrada de cola de proyecto.';
//       RequestPagesOptionsDeletedMsg@1004 :
      RequestPagesOptionsDeletedMsg: TextConst ENU='You have cleared the report parameters. Select the check box in the field to show the report request page again.',ESP='Ha borrado los par metros del informe. Active la casilla del campo para volver a mostrar la p gina de solicitud de informe.';
//       ExpiresBeforeStartErr@1005 :
      ExpiresBeforeStartErr: 
// "%1 = Expiration Date, %2=Start date"
TextConst ENU='%1 must be later than %2.',ESP='%1 debe ser posterior que %2.';
//       UserSessionJobsCannotBeRecurringErr@1006 :
      UserSessionJobsCannotBeRecurringErr: TextConst ENU='You cannot set up recurring user session job queue entries.',ESP='No se pueden configurar movimientos de cola de proyectos de sesi¢n de usuario recurrentes.';
//       NoPrintOnSaaSMsg@1007 :
      NoPrintOnSaaSMsg: TextConst ENU='You cannot select a printer from this online product. Instead, save as PDF, or another format, which you can print later.\\The output type has been set to PDF.',ESP='No puede seleccionar una impresora de este producto en l¡nea. En su lugar, guarde como PDF o en otro formato, que puede imprimir m s tarde.\\Se ha establecido el tipo de salida en PDF.';
//       LastJobQueueLogEntryNo@1009 :
      LastJobQueueLogEntryNo: Integer;

    
    


/*
trigger OnInsert();    begin
               if ISNULLGUID(ID) then
                 ID := CREATEGUID;
               SetDefaultValues(TRUE);
             end;


*/

/*
trigger OnModify();    var
//                RunParametersChanged@1000 :
               RunParametersChanged: Boolean;
             begin
               RunParametersChanged := AreRunParametersChanged;
               if RunParametersChanged then
                 Reschedule;
               SetDefaultValues(RunParametersChanged);
             end;


*/

/*
trigger OnDelete();    begin
               if Status = Status::"In Process" then
                 ERROR(CannotDeleteEntryErr,Status);
               CancelTask;
             end;

*/




/*
procedure DoesExistLocked () : Boolean;
    begin
      LOCKTABLE;
      exit(GET(ID));
    end;
*/


    
    
/*
procedure RefreshLocked ()
    begin
      LOCKTABLE;
      GET(ID);
    end;
*/


    
//     procedure IsExpired (AtDateTime@1000 :
    
/*
procedure IsExpired (AtDateTime: DateTime) : Boolean;
    begin
      exit((AtDateTime <> 0DT) and ("Expiration Date/Time" <> 0DT) and ("Expiration Date/Time" < AtDateTime));
    end;
*/


    
    
/*
procedure IsReadyToStart () : Boolean;
    begin
      exit(Status IN [Status::Ready,Status::"In Process",Status::"On Hold with Inactivity Timeout"]);
    end;
*/


    
    
/*
procedure GetErrorMessage () : Text;
    var
//       TextMgt@1000 :
      TextMgt: Codeunit 41;
    begin
      exit(TextMgt.GetRecordErrorMessage("Error Message","Error Message 2","Error Message 3","Error Message 4"));
    end;
*/


    
//     procedure SetErrorMessage (ErrorText@1000 :
    
/*
procedure SetErrorMessage (ErrorText: Text)
    var
//       TextMgt@1001 :
      TextMgt: Codeunit 41;
    begin
      TextMgt.SetRecordErrorMessage("Error Message","Error Message 2","Error Message 3","Error Message 4",ErrorText);
    end;
*/


    
    
/*
procedure ShowErrorMessage ()
    var
//       e@1000 :
      e: Text;
    begin
      e := GetErrorMessage;
      if e = '' then
        e := NoErrMsg;
      MESSAGE('%1',e);
    end;
*/


    
//     procedure SetError (ErrorText@1000 :
    
/*
procedure SetError (ErrorText: Text)
    begin
      RefreshLocked;
      SetErrorMessage(ErrorText);
      ClearServiceValues;
      SetStatusValue(Status::Error);
    end;
*/


    
//     procedure SetResult (IsSuccess@1000 : Boolean;PrevStatus@1002 :
    
/*
procedure SetResult (IsSuccess: Boolean;PrevStatus: Option)
    begin
      if (Status = Status::"On Hold") or "Manual Recurrence" then
        exit;
      if IsSuccess then
        if "Recurring Job" and (PrevStatus IN [Status::"On Hold",Status::"On Hold with Inactivity Timeout"]) then
          Status := PrevStatus
        else
          Status := Status::Finished
      else begin
        Status := Status::Error;
        SetErrorMessage(GETLASTERRORTEXT);
      end;
      MODIFY;
    end;
*/


    
    
/*
procedure SetResultDeletedEntry ()
    begin
      Status := Status::Error;
      SetErrorMessage(DeletedEntryErr);
      MODIFY;
    end;
*/


    
    
/*
procedure FinalizeRun ()
    begin
      CASE Status OF
        Status::Finished,Status::"On Hold with Inactivity Timeout":
          CleanupAfterExecution;
        Status::Error:
          HandleExecutionError;
      end;

      if (Status = Status::Finished) or ("Maximum No. of Attempts to Run" = "No. of Attempts to Run") then
        UpdateDocumentSentHistory;
    end;
*/


    
    
/*
procedure GetLastLogEntryNo () : Integer;
    begin
      exit(LastJobQueueLogEntryNo);
    end;
*/


    
//     procedure InsertLogEntry (var JobQueueLogEntry@1000 :
    
/*
procedure InsertLogEntry (var JobQueueLogEntry: Record 474)
    begin
      JobQueueLogEntry."Entry No." := 0;
      JobQueueLogEntry.INIT;
      JobQueueLogEntry.ID := ID;
      JobQueueLogEntry."User ID" := "User ID";
      JobQueueLogEntry."Start Date/Time" := "User Session Started";
      JobQueueLogEntry."Object Type to Run" := "Object Type to Run";
      JobQueueLogEntry."Object ID to Run" := "Object ID to Run";
      JobQueueLogEntry.Description := Description;
      JobQueueLogEntry.Status := JobQueueLogEntry.Status::"In Process";
      JobQueueLogEntry."Processed by User ID" := USERID;
      JobQueueLogEntry."Job Queue Category Code" := "Job Queue Category Code";
      OnBeforeInsertLogEntry(JobQueueLogEntry,Rec);
      JobQueueLogEntry.INSERT(TRUE);
      LastJobQueueLogEntryNo := JobQueueLogEntry."Entry No.";
    end;
*/


    
//     procedure FinalizeLogEntry (JobQueueLogEntry@1000 :
    
/*
procedure FinalizeLogEntry (JobQueueLogEntry: Record 474)
    begin
      if Status = Status::Error then begin
        JobQueueLogEntry.Status := JobQueueLogEntry.Status::Error;
        JobQueueLogEntry.SetErrorMessage(GetErrorMessage);
        JobQueueLogEntry.SetErrorCallStack(GETLASTERRORCALLSTACK);
      end else
        JobQueueLogEntry.Status := JobQueueLogEntry.Status::Success;
      JobQueueLogEntry."end Date/Time" := CURRENTDATETIME;
      OnBeforeModifyLogEntry(JobQueueLogEntry,Rec);
      JobQueueLogEntry.MODIFY(TRUE);
    end;
*/


    
//     procedure SetStatus (NewStatus@1000 :
    
/*
procedure SetStatus (NewStatus: Option)
    begin
      if NewStatus = Status then
        exit;
      RefreshLocked;
      ClearServiceValues;
      SetStatusValue(NewStatus);
    end;
*/


    
    
/*
procedure Cancel ()
    begin
      if DoesExistLocked then
        DeleteTask;
    end;
*/


    
    
/*
procedure DeleteTask ()
    begin
      Status := Status::Finished;
      DELETE(TRUE);
    end;
*/


    
    
/*
procedure DeleteTasks ()
    begin
      if FINDSET then
        repeat
          DeleteTask;
        until NEXT = 0;
    end;
*/


    
    
/*
procedure Restart ()
    begin
      RefreshLocked;
      ClearServiceValues;
      if (Status = Status::"On Hold with Inactivity Timeout") and ("Inactivity Timeout Period" > 0) then
        "Earliest Start Date/Time" := CURRENTDATETIME;
      Status := Status::"On Hold";
      SetStatusValue(Status::Ready);
    end;
*/


    
/*
LOCAL procedure EnqueueTask ()
    begin
      CODEUNIT.RUN(CODEUNIT::"Job Queue - Enqueue",Rec);
    end;
*/


    
    
/*
procedure CancelTask ()
    var
//       ScheduledTask@1000 :
      ScheduledTask: Record 2000000175;
    begin
      if not ISNULLGUID("System Task ID") then begin
        if ScheduledTask.GET("System Task ID") then
          TASKSCHEDULER.CANCELTASK("System Task ID");
        CLEAR("System Task ID");
      end;
    end;
*/


    
    
/*
procedure ScheduleTask () : GUID;
    var
//       TaskGUID@1000 :
      TaskGUID: GUID;
    begin
      if "User ID" <> USERID then begin
        "User ID" := USERID;
        MODIFY(TRUE);
      end;
      OnBeforeScheduleTask(Rec,TaskGUID);
      if not ISNULLGUID(TaskGUID) then
        exit(TaskGUID);

      exit(
        TASKSCHEDULER.CREATETASK(
          CODEUNIT::"Job Queue Dispatcher",
          CODEUNIT::"Job Queue Error Handler",
          TRUE,COMPANYNAME,"Earliest Start Date/Time",RECORDID));
    end;
*/


    
/*
LOCAL procedure Reschedule ()
    begin
      CancelTask;
      if Status IN [Status::Ready,Status::"On Hold with Inactivity Timeout"] then begin
        SetDefaultValues(FALSE);
        EnqueueTask;
      end;

      OnAfterReschedule(Rec);
    end;
*/


    
//     procedure ReuseExistingJobFromID (JobID@1000 : GUID;ExecutionDateTime@1002 :
    
/*
procedure ReuseExistingJobFromID (JobID: GUID;ExecutionDateTime: DateTime) : Boolean;
    begin
      if GET(JobID) then begin
        if not (Status IN [Status::Ready,Status::"In Process"]) then begin
          "Earliest Start Date/Time" := ExecutionDateTime;
          SetStatus(Status::Ready);
        end;
        exit(TRUE);
      end;

      exit(FALSE);
    end;
*/


    
//     procedure ReuseExistingJobFromCatagory (JobQueueCatagoryCode@1001 : Code[10];ExecutionDateTime@1002 :
    
/*
procedure ReuseExistingJobFromCatagory (JobQueueCatagoryCode: Code[10];ExecutionDateTime: DateTime) : Boolean;
    begin
      SETRANGE("Job Queue Category Code",JobQueueCatagoryCode);
      if FINDFIRST then
        exit(ReuseExistingJobFromID(ID,ExecutionDateTime));

      exit(FALSE);
    end;
*/


    
/*
LOCAL procedure AreRunParametersChanged () : Boolean;
    begin
      exit(
        ("User ID" = '') or
        ("Object Type to Run" <> xRec."Object Type to Run") or
        ("Object ID to Run" <> xRec."Object ID to Run") or
        ("Parameter String" <> xRec."Parameter String"));
    end;
*/


//     LOCAL procedure SetDefaultValues (SetupUserId@1002 :
    
/*
LOCAL procedure SetDefaultValues (SetupUserId: Boolean)
    var
//       Language@1001 :
      Language: Record 8;
//       IdentityManagement@1000 :
      IdentityManagement: Codeunit 9801;
    begin
      "Last Ready State" := CURRENTDATETIME;
      if IdentityManagement.IsInvAppId then
        "User Language ID" := Language.GetLanguageID(Language.GetUserLanguage)
      else
        "User Language ID" := GLOBALLANGUAGE;
      if SetupUserId then
        "User ID" := USERID;
      "No. of Attempts to Run" := 0;
    end;
*/


    
/*
LOCAL procedure ClearServiceValues ()
    begin
      OnBeforeClearServiceValues(Rec);

      "User Session Started" := 0DT;
      "User Service Instance ID" := 0;
      "User Session ID" := 0;
    end;
*/


    
/*
LOCAL procedure CleanupAfterExecution ()
    var
//       JobQueueDispatcher@1000 :
      JobQueueDispatcher: Codeunit 448;
    begin
      if "Notify On Success" then
        CODEUNIT.RUN(CODEUNIT::"Job Queue - Send Notification",Rec);

      if "Recurring Job" then begin
        ClearServiceValues;
        if Status = Status::"On Hold with Inactivity Timeout" then
          "Earliest Start Date/Time" := JobQueueDispatcher.CalcNextRunTimeHoldDuetoInactivityJob(Rec,CURRENTDATETIME)
        else
          "Earliest Start Date/Time" := JobQueueDispatcher.CalcNextRunTimeForRecurringJob(Rec,CURRENTDATETIME);
        EnqueueTask;
      end else
        DELETE;
    end;
*/


    
/*
LOCAL procedure HandleExecutionError ()
    begin
      if "Maximum No. of Attempts to Run" > "No. of Attempts to Run" then begin
        "No. of Attempts to Run" += 1;
        "Earliest Start Date/Time" := CURRENTDATETIME + 1000 * "Rerun Delay (sec.)";
        EnqueueTask;
      end else begin
        SetStatusValue(Status::Error);
        COMMIT;
        if CODEUNIT.RUN(CODEUNIT::"Job Queue - Send Notification",Rec) then;
      end;
    end;
*/


    
    
/*
procedure GetTimeout () : Integer;
    begin
      if "Timeout (sec.)" > 0 then
        exit("Timeout (sec.)");
      exit(1000000000);
    end;
*/


    
/*
LOCAL procedure SetRecurringField ()
    begin
      "Recurring Job" :=
        "Run on Mondays" or
        "Run on Tuesdays" or "Run on Wednesdays" or "Run on Thursdays" or "Run on Fridays" or "Run on Saturdays" or "Run on Sundays";

      if "Recurring Job" and "Run in User Session" then
        ERROR(UserSessionJobsCannotBeRecurringErr);
    end;
*/


//     LOCAL procedure SetStatusValue (NewStatus@1000 :
    
/*
LOCAL procedure SetStatusValue (NewStatus: Option)
    var
//       JobQueueDispatcher@1001 :
      JobQueueDispatcher: Codeunit 448;
    begin
      OnBeforeSetStatusValue(Rec,xRec,NewStatus);

      if NewStatus = Status then
        exit;
      CASE NewStatus OF
        Status::Ready:
          begin
            SetDefaultValues(FALSE);
            "Earliest Start Date/Time" := JobQueueDispatcher.CalcInitialRunTime(Rec,CURRENTDATETIME);
            EnqueueTask;
          end;
        Status::"On Hold":
          CancelTask;
        Status::"On Hold with Inactivity Timeout":
          if "Inactivity Timeout Period" > 0 then begin
            SetDefaultValues(FALSE);
            "Earliest Start Date/Time" := JobQueueDispatcher.CalcNextRunTimeHoldDuetoInactivityJob(Rec,CURRENTDATETIME);
            EnqueueTask;
          end;
      end;
      Status := NewStatus;
      MODIFY;
    end;
*/


    
//     procedure ShowStatusMsg (JQID@1000 :
    
/*
procedure ShowStatusMsg (JQID: GUID)
    var
//       JobQueueEntry@1001 :
      JobQueueEntry: Record 472;
    begin
      if JobQueueEntry.GET(JQID) then
        CASE JobQueueEntry.Status OF
          JobQueueEntry.Status::Error:
            MESSAGE(JobQueueEntry.GetErrorMessage);
          JobQueueEntry.Status::"In Process":
            MESSAGE(FORMAT(JobQueueEntry.Status::"In Process"));
          else
            MESSAGE(ScheduledForPostingMsg,JobQueueEntry."User Session Started",JobQueueEntry."User ID");
        end;
    end;
*/


    
    
/*
procedure LookupRecordToProcess ()
    var
//       RecRef@1002 :
      RecRef: RecordRef;
//       RecVariant@1001 :
      RecVariant: Variant;
    begin
      if ISNULLGUID(ID) then
        exit;
      if FORMAT("Record ID to Process") = '' then
        ERROR(NoRecordErr);
      RecRef.GET("Record ID to Process");
      RecRef.SETRECFILTER;
      RecVariant := RecRef;
      PAGE.RUN(0,RecVariant);
    end;
*/


    
//     procedure LookupObjectID (var NewObjectID@1000 :
    
/*
procedure LookupObjectID (var NewObjectID: Integer) : Boolean;
    var
//       AllObjWithCaption@1002 :
      AllObjWithCaption: Record 2000000058;
//       Objects@1001 :
      Objects: Page 358;
    begin
      if AllObjWithCaption.GET("Object Type to Run","Object ID to Run") then;
      AllObjWithCaption.FILTERGROUP(2);
      AllObjWithCaption.SETRANGE("Object Type","Object Type to Run");
      AllObjWithCaption.FILTERGROUP(0);
      Objects.SETRECORD(AllObjWithCaption);
      Objects.SETTABLEVIEW(AllObjWithCaption);
      Objects.LOOKUPMODE := TRUE;
      if Objects.RUNMODAL = ACTION::LookupOK then begin
        Objects.GETRECORD(AllObjWithCaption);
        NewObjectID := AllObjWithCaption."Object ID";
        exit(TRUE);
      end;
      exit(FALSE);
    end;
*/


//     LOCAL procedure LookupDateTime (InitDateTime@1000 : DateTime;EarliestDateTime@1001 : DateTime;LatestDateTime@1003 :
    
/*
LOCAL procedure LookupDateTime (InitDateTime: DateTime;EarliestDateTime: DateTime;LatestDateTime: DateTime) : DateTime;
    var
//       DateTimeDialog@1004 :
      DateTimeDialog: Page 684;
//       NewDateTime@1002 :
      NewDateTime: DateTime;
    begin
      NewDateTime := InitDateTime;
      if InitDateTime < EarliestDateTime then
        InitDateTime := EarliestDateTime;
      if (LatestDateTime <> 0DT) and (InitDateTime > LatestDateTime) then
        InitDateTime := LatestDateTime;

      DateTimeDialog.SetDateTime(ROUNDDATETIME(InitDateTime,1000));

      if DateTimeDialog.RUNMODAL = ACTION::OK then
        NewDateTime := DateTimeDialog.GetDateTime;
      exit(NewDateTime);
    end;
*/


    
/*
LOCAL procedure CheckStartAndExpirationDateTime ()
    begin
      if IsExpired("Earliest Start Date/Time") then
        ERROR(ExpiresBeforeStartErr,FIELDCAPTION("Expiration Date/Time"),FIELDCAPTION("Earliest Start Date/Time"));
    end;
*/


    
    
/*
procedure GetXmlContent () : Text;
    var
//       InStr@1000 :
      InStr: InStream;
//       Params@1001 :
      Params: Text;
    begin
      CALCFIELDS(XML);
      if XML.HASVALUE then begin
        XML.CREATEINSTREAM(InStr,TEXTENCODING::UTF8);
        InStr.READ(Params);
      end;

      exit(Params);
    end;
*/


    
//     procedure SetXmlContent (Params@1002 :
    
/*
procedure SetXmlContent (Params: Text)
    var
//       OutStr@1001 :
      OutStr: OutStream;
    begin
      CLEAR(XML);
      if Params <> '' then begin
        XML.CREATEOUTSTREAM(OutStr,TEXTENCODING::UTF8);
        OutStr.WRITE(Params);
      end;
      MODIFY; // Necessary because the following function does a CALCFIELDS(XML)
      Description := GetDefaultDescriptionFromReportRequestPage(Description);
      MODIFY;
    end;
*/


    
    
/*
procedure GetReportParameters () : Text;
    begin
      TESTFIELD("Object Type to Run","Object Type to Run"::Report);
      TESTFIELD("Object ID to Run");

      exit(GetXmlContent);
    end;
*/


//     procedure SetReportParameters (Params@1002 :
    
/*
procedure SetReportParameters (Params: Text)
    begin
      TESTFIELD("Object Type to Run","Object Type to Run"::Report);
      TESTFIELD("Object ID to Run");

      "Report Request Page Options" := Params <> '';

      SetXmlContent(Params);
    end;
*/


    
    
/*
procedure RunReportRequestPage ()
    var
//       Params@1000 :
      Params: Text;
//       OldParams@1001 :
      OldParams: Text;
    begin
      if "Object Type to Run" <> "Object Type to Run"::Report then
        exit;
      if "Object ID to Run" = 0 then
        exit;

      OldParams := GetReportParameters;
      Params := REPORT.RUNREQUESTPAGE("Object ID to Run",OldParams);

      if (Params <> '') and (Params <> OldParams) then begin
        "User ID" := USERID;
        SetReportParameters(Params);
      end;
    end;
*/


    
//     procedure ScheduleJobQueueEntry (CodeunitID@1001 : Integer;RecordIDToProcess@1000 :
    
/*
procedure ScheduleJobQueueEntry (CodeunitID: Integer;RecordIDToProcess: RecordID)
    begin
      ScheduleJobQueueEntryWithParameters(CodeunitID,RecordIDToProcess,'');
    end;
*/


    
//     procedure ScheduleJobQueueEntryWithParameters (CodeunitID@1000 : Integer;RecordIDToProcess@1001 : RecordID;JobParameter@1002 :
    
/*
procedure ScheduleJobQueueEntryWithParameters (CodeunitID: Integer;RecordIDToProcess: RecordID;JobParameter: Text[250])
    begin
      INIT;
      "Earliest Start Date/Time" := CREATEDATETIME(TODAY,TIME);
      "Object Type to Run" := "Object Type to Run"::Codeunit;
      "Object ID to Run" := CodeunitID;
      "Record ID to Process" := RecordIDToProcess;
      "Run in User Session" := FALSE;
      Priority := 1000;
      "Parameter String" := JobParameter;
      EnqueueTask;
    end;
*/


    
//     procedure ScheduleJobQueueEntryForLater (CodeunitID@1000 : Integer;StartDateTime@1001 : DateTime;JobQueueCategoryCode@1002 : Code[10];JobParameter@1003 :
    
/*
procedure ScheduleJobQueueEntryForLater (CodeunitID: Integer;StartDateTime: DateTime;JobQueueCategoryCode: Code[10];JobParameter: Text)
    begin
      INIT;
      "Earliest Start Date/Time" := StartDateTime;
      "Object Type to Run" := "Object Type to Run"::Codeunit;
      "Object ID to Run" := CodeunitID;
      "Run in User Session" := FALSE;
      Priority := 1000;
      "Job Queue Category Code" := JobQueueCategoryCode;
      "Maximum No. of Attempts to Run" := 3;
      "Rerun Delay (sec.)" := 60;
      "Parameter String" := COPYSTR(JobParameter,1,MAXSTRLEN("Parameter String"));
      EnqueueTask;
    end;
*/


    
//     procedure GetStartingDateTime (Date@1000 :
    
/*
procedure GetStartingDateTime (Date: DateTime) : DateTime;
    begin
      if "Reference Starting Time" = 0DT then
        VALIDATE("Starting Time");
      exit(CREATEDATETIME(DT2DATE(Date),DT2TIME("Reference Starting Time")));
    end;
*/


    
//     procedure GetEndingDateTime (Date@1000 :
    
/*
procedure GetEndingDateTime (Date: DateTime) : DateTime;
    begin
      if "Reference Starting Time" = 0DT then
        VALIDATE("Starting Time");
      if "Ending Time" = 0T then
        exit(CREATEDATETIME(DT2DATE(Date),0T));
      if "Starting Time" = 0T then
        exit(CREATEDATETIME(DT2DATE(Date),"Ending Time"));
      if "Starting Time" < "Ending Time" then
        exit(CREATEDATETIME(DT2DATE(Date),"Ending Time"));
      exit(CREATEDATETIME(DT2DATE(Date) + 1,"Ending Time"));
    end;
*/


    
//     procedure ScheduleRecurrentJobQueueEntry (ObjType@1001 : Option;ObjID@1002 : Integer;RecId@1000 :
    
/*
procedure ScheduleRecurrentJobQueueEntry (ObjType: Option;ObjID: Integer;RecId: RecordID)
    begin
      RESET;
      SETRANGE("Object Type to Run",ObjType);
      SETRANGE("Object ID to Run",ObjID);
      if FORMAT(RecId) <> '' then
        SETFILTER("Record ID to Process",FORMAT(RecId));
      LOCKTABLE;

      if not FINDFIRST then begin
        InitRecurringJob(5);
        "Object Type to Run" := ObjType;
        "Object ID to Run" := ObjID;
        "Record ID to Process" := RecId;
        "Starting Time" := 080000T;
        "Maximum No. of Attempts to Run" := 3;
        EnqueueTask;
      end;
    end;
*/


    
//     procedure InitRecurringJob (NoofMinutesbetweenRuns@1000 :
    
/*
procedure InitRecurringJob (NoofMinutesbetweenRuns: Integer)
    begin
      INIT;
      CLEAR(ID); // "Job Queue - Enqueue" is to define new ID
      "Recurring Job" := TRUE;
      "Run on Mondays" := TRUE;
      "Run on Tuesdays" := TRUE;
      "Run on Wednesdays" := TRUE;
      "Run on Thursdays" := TRUE;
      "Run on Fridays" := TRUE;
      "Run on Saturdays" := TRUE;
      "Run on Sundays" := TRUE;
      "No. of Minutes between Runs" := NoofMinutesbetweenRuns;
      "Earliest Start Date/Time" := CURRENTDATETIME;
    end;
*/


    
//     procedure FindJobQueueEntry (ObjType@1002 : Option;ObjID@1001 :
    
/*
procedure FindJobQueueEntry (ObjType: Option;ObjID: Integer) : Boolean;
    begin
      RESET;
      SETRANGE("Object Type to Run",ObjType);
      SETRANGE("Object ID to Run",ObjID);
      exit(FINDFIRST);
    end;
*/


    
    
/*
procedure GetDefaultDescription () : Text[250];
    var
//       DefaultDescription@1004 :
      DefaultDescription: Text[250];
    begin
      CALCFIELDS("Object Caption to Run");
      DefaultDescription := COPYSTR("Object Caption to Run",1,MAXSTRLEN(DefaultDescription));
      if "Object Type to Run" <> "Object Type to Run"::Report then
        exit(DefaultDescription);
      exit(GetDefaultDescriptionFromReportRequestPage(DefaultDescription));
    end;
*/


//     LOCAL procedure GetDefaultDescriptionFromReportRequestPage (DefaultDescription@1004 :
    
/*
LOCAL procedure GetDefaultDescriptionFromReportRequestPage (DefaultDescription: Text[250]) : Text[250];
    var
//       AccScheduleName@1005 :
      AccScheduleName: Record 84;
//       XMLDOMManagement@1003 :
      XMLDOMManagement: Codeunit 6224;
//       InStr@1002 :
      InStr: InStream;
//       XMLRootNode@1001 :
      XMLRootNode: DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
//       XMLNode@1000 :
      XMLNode: DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
    begin
      if not ("Object ID to Run" IN [REPORT::"Account Schedule"]) then
        exit(DefaultDescription);

      CALCFIELDS(XML); // Requestpage data
      if not XML.HASVALUE then
        exit(DefaultDescription);
      XML.CREATEINSTREAM(InStr);
      if not XMLDOMManagement.LoadXMLNodeFromInStream(InStr,XMLRootNode) then
        exit(DefaultDescription);
      if ISNULL(XMLRootNode) then
        exit(DefaultDescription);

      // Specific for report 25 Account Schedule
      XMLNode := XMLRootNode.SelectSingleNode('//Field[@name="AccSchedName"]');
      if ISNULL(XMLNode) then
        exit(DefaultDescription);
      if not AccScheduleName.GET(COPYSTR(XMLNode.InnerText,1,MAXSTRLEN(AccScheduleName.Name))) then
        exit(DefaultDescription);
      exit(AccScheduleName.Description);
    end;
*/


    
    
/*
procedure IsToReportInbox () : Boolean;
    begin
      exit(
        ("Object Type to Run" = "Object Type to Run"::Report) and
        ("Report Output Type" IN ["Report Output Type"::PDF,"Report Output Type"::Word,
                                  "Report Output Type"::Excel]));
    end;
*/


    
/*
LOCAL procedure UpdateDocumentSentHistory ()
    var
//       O365DocumentSentHistory@1001 :
      O365DocumentSentHistory: Record 2158;
    begin
      if ("Object Type to Run" = "Object Type to Run"::Codeunit) and ("Object ID to Run" = CODEUNIT::"Document-Mailing") then
        if (Status = Status::Error) or (Status = Status::Finished) then begin
          O365DocumentSentHistory.SETRANGE("Job Queue Entry ID",ID);
          if not O365DocumentSentHistory.FINDFIRST then
            exit;

          if Status = Status::Error then
            O365DocumentSentHistory.SetStatusAsFailed
          else
            O365DocumentSentHistory.SetStatusAsSuccessfullyFinished;
        end;
    end;
*/


    
    
/*
procedure FilterInactiveOnHoldEntries ()
    begin
      RESET;
      SETRANGE(Status,Status::"On Hold with Inactivity Timeout");
    end;
*/


    
    
/*
procedure DoesJobNeedToBeRun () Result : Boolean;
    begin
      OnFindingIfJobNeedsToBeRun(Result);
    end;
*/


    
//     LOCAL procedure OnAfterReschedule (var JobQueueEntry@1000 :
    
/*
LOCAL procedure OnAfterReschedule (var JobQueueEntry: Record 472)
    begin
    end;
*/


    
//     LOCAL procedure OnBeforeClearServiceValues (var JobQueueEntry@1000 :
    
/*
LOCAL procedure OnBeforeClearServiceValues (var JobQueueEntry: Record 472)
    begin
    end;
*/


    
//     LOCAL procedure OnBeforeInsertLogEntry (var JobQueueLogEntry@1000 : Record 474;var JobQueueEntry@1001 :
    
/*
LOCAL procedure OnBeforeInsertLogEntry (var JobQueueLogEntry: Record 474;var JobQueueEntry: Record 472)
    begin
    end;
*/


    
//     LOCAL procedure OnBeforeModifyLogEntry (var JobQueueLogEntry@1000 : Record 474;var JobQueueEntry@1001 :
    
/*
LOCAL procedure OnBeforeModifyLogEntry (var JobQueueLogEntry: Record 474;var JobQueueEntry: Record 472)
    begin
    end;
*/


    
//     LOCAL procedure OnBeforeScheduleTask (var JobQueueEntry@1000 : Record 472;var TaskGUID@1001 :
    
/*
LOCAL procedure OnBeforeScheduleTask (var JobQueueEntry: Record 472;var TaskGUID: GUID)
    begin
    end;
*/


    
//     LOCAL procedure OnBeforeSetStatusValue (var JobQueueEntry@1000 : Record 472;var xJobQueueEntry@1001 : Record 472;var NewStatus@1002 :
    
/*
LOCAL procedure OnBeforeSetStatusValue (var JobQueueEntry: Record 472;var xJobQueueEntry: Record 472;var NewStatus: Option)
    begin
    end;

    [Integration(TRUE)]
*/

//     LOCAL procedure OnFindingIfJobNeedsToBeRun (var Result@1000 :
    
/*
LOCAL procedure OnFindingIfJobNeedsToBeRun (var Result: Boolean)
    begin
    end;

    /*begin
    end.
  */
}




