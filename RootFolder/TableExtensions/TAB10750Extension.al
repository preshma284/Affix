tableextension 50207 "MyExtension50207" extends "SII History"
{
  
  
    CaptionML=ENU='SII History',ESP='Historial SII';
  
  fields
{
    field(7207270;"Last Status";Option)
    {
        OptionMembers="Pending","Incorrect","Accepted","Accepted With Errors","Communication Error","Failed","Not Supported";FieldClass=FlowField;
                                                   CalcFormula=Lookup("SII History"."Status" WHERE ("Document State Id"=FIELD("Document State Id"),
                                                                                                  "Status"=FILTER('Accepted'|'Accepted With Errors')));
                                                   CaptionML=ENU='Status',ESP='Ultimo Estado';
                                                   OptionCaptionML=ENU='Pending,Incorrect,Accepted,Accepted With Errors,Communication Error,Failed,Not Supported',ESP='Pendiente,Incorrecto,Aceptado,Aceptado con errores,Error de comunicaci¢n,Errores,No compatible';
                                                   
                                                   Editable=false ;


    }
}
  keys
{
   // key(key1;"Id")
  //  {
       /* Clustered=true;
 */
   // }
}
  fieldgroups
{
}
  
    var
//       CommunicationErrorWithRetriesErr@1100000 :
      CommunicationErrorWithRetriesErr: 
// @1 is the error message.@2 is the number or automatic retries before the upload is considered failed.
TextConst ENU='%1. More details may be available in the content of the response. There are %2 automatic retries left before failure.',ESP='%1. Puede haber m s detalles en el contenido de la respuesta. Quedan %2 intentos autom ticos hasta que se genere el error.';
//       MarkAsNotAcceptedErr@1100001 :
      MarkAsNotAcceptedErr: 
// "%1 = user id;%2 = date time of mark"
TextConst ENU='Marked as not accepted by %1 on %2.',ESP='Marcado como no aceptado por %1 el %2.';
//       MarkAsAcceptedErr@1100002 :
      MarkAsAcceptedErr: 
// "%1 = user id;%2 = date time of mark"
TextConst ENU='Marked as accepted by %1 on %2.',ESP='Marcado como aceptado por %1 el %2.';

//     procedure CreateNewRequest (DocUploadId@1100000 : Integer;UploadType@1100001 : Option;RetriesLeft@1100002 : Integer;IsManual@1100003 : Boolean;IsAcceptedWithErrorRetry@1100006 :
    
/*
procedure CreateNewRequest (DocUploadId: Integer;UploadType: Option;RetriesLeft: Integer;IsManual: Boolean;IsAcceptedWithErrorRetry: Boolean) : Integer;
    var
//       Customer@1100007 :
      Customer: Record 18;
//       SIIDocUploadState@1100004 :
      SIIDocUploadState: Record 10752;
//       SIIHistory@1100005 :
      SIIHistory: Record 10750;
    begin
      SIIDocUploadState.GET(DocUploadId);
      if (UploadType IN [SIIDocUploadState."Transaction Type"::Regular,
                         SIIDocUploadState."Transaction Type"::"Collection In Cash"]) and
         (SIIDocUploadState.Status = SIIDocUploadState.Status::Accepted) and
         (not IsAcceptedWithErrorRetry)
      then
        exit;

      SIIHistory.INIT;
      SIIHistory."Request Date" := CURRENTDATETIME;
      SIIHistory."Document State Id" := DocUploadId;
      if SIIDocUploadState.Status <> SIIDocUploadState.Status::"not Supported" then
        SIIHistory.Status := Status::Pending
      else
        SIIHistory.Status := Status::"not Supported";
      SIIHistory."Retries Left" := RetriesLeft;
      SIIHistory."Upload Type" := UploadType;
      SIIHistory."Is Manual" := IsManual;
      SIIHistory."Retry Accepted" := IsAcceptedWithErrorRetry;
      SIIHistory.INSERT;

      SIIDocUploadState.GET(DocUploadId);
      if SIIDocUploadState.Status <> SIIDocUploadState.Status::"not Supported" then
        SIIDocUploadState.Status := SIIDocUploadState.Status::Pending
      else
        SIIDocUploadState.Status := SIIDocUploadState.Status::"not Supported";
      SIIDocUploadState."Is Manual" := SIIHistory."Is Manual";
      SIIDocUploadState."Transaction Type" := SIIHistory."Upload Type";
      SIIDocUploadState."Retry Accepted" := SIIHistory."Retry Accepted";
      if SIIDocUploadState."Transaction Type" = SIIDocUploadState."Transaction Type"::"Collection In Cash" then begin
        Customer.GET(SIIDocUploadState."CV No.");
        SIIDocUploadState."CV Name" := Customer.Name;
        SIIDocUploadState."Country/Region Code" := Customer."Country/Region Code";
        SIIDocUploadState."VAT Registration No." := Customer."VAT Registration No.";
      end;
      SIIDocUploadState.MODIFY;

      exit(SIIHistory.Id);
    end;
*/


    
/*
procedure ProcessResponse ()
    var
//       SIIDocUploadState@1100002 :
      SIIDocUploadState: Record 10752;
    begin
      SIIDocUploadState.GET("Document State Id");
      BuildDocumentStatus(SIIDocUploadState);

      MODIFY;
      SIIDocUploadState.MODIFY;
    end;
*/


//     procedure ProcessResponseCommunicationError (ErrorMessage@1100001 :
    
/*
procedure ProcessResponseCommunicationError (ErrorMessage: Text[250])
    var
//       SIIDocUploadState@1100000 :
      SIIDocUploadState: Record 10752;
//       SIIJobRetryCommError@1100002 :
      SIIJobRetryCommError: Codeunit 10754;
    begin
      SIIDocUploadState.GET("Document State Id");

      "Error Message" := ErrorMessage;

      "Retries Left" -= 1;
      if ("Retries Left" > 0) or "Is Manual" then begin
        // Some retries left or it was a manual retry
        Status := Status::"Communication Error";
        "Error Message" := COPYSTR(
            STRSUBSTNO(CommunicationErrorWithRetriesErr,ErrorMessage,"Retries Left"),1,
            MAXSTRLEN("Error Message"));
        SIIJobRetryCommError.ScheduleJobForRetry;
      end else begin
        // We ran out of automatic retries, just set document state to "Failed".
        Status := Status::Failed;
        "Error Message" := COPYSTR(ErrorMessage,1,MAXSTRLEN("Error Message"));
      end;
      BuildDocumentStatus(SIIDocUploadState);

      MODIFY;
      SIIDocUploadState.MODIFY;
    end;
*/


//     LOCAL procedure BuildDocumentStatus (var SIIDocUploadState@1100000 :
    
/*
LOCAL procedure BuildDocumentStatus (var SIIDocUploadState: Record 10752)
    var
//       SIIHistory@1100002 :
      SIIHistory: Record 10750;
//       RequestToFindType@1100001 :
      RequestToFindType: Option;
    begin
      if (Status = Status::Failed) or
         (Status = Status::"Communication Error") or
         (Status = Status::Incorrect) or
         (Status = Status::"not Supported")
      then begin
        SIIDocUploadState.Status := Status;
        exit;
      end;
      // We get here with request's status "Accepted" or "Accepted with Errors"

      // There is no need to search for other requests if it's a regural upload.
      if SIIDocUploadState."Transaction Type" IN
         [SIIDocUploadState."Transaction Type"::Regular,SIIDocUploadState."Transaction Type"::RetryAccepted,
          SIIDocUploadState."Transaction Type"::"Collection In Cash"]
      then
        SIIDocUploadState.Status := Status
      else begin
        if "Upload Type" = "Upload Type"::Intracommunity then
          RequestToFindType := "Upload Type"::Regular
        else
          RequestToFindType := "Upload Type"::Intracommunity;

        SIIHistory.ASCENDING(FALSE);
        SIIHistory.SETRANGE("Document State Id",SIIDocUploadState.Id);
        SIIHistory.SETRANGE("Upload Type",RequestToFindType);

        SIIHistory.FINDFIRST;
        if Status = SIIHistory.Status::Accepted then begin
          if SIIHistory.Status = SIIHistory.Status::Accepted then
            SIIDocUploadState.Status := SIIDocUploadState.Status::Accepted;
          exit;
        end;

        if (SIIHistory.Status = SIIHistory.Status::"Accepted With Errors") or
           (SIIHistory.Status = SIIHistory.Status::Accepted)
        then
          SIIDocUploadState.Status := SIIDocUploadState.Status::"Accepted With Errors";
      end;
    end;
*/


    
/*
procedure MarkAsAccepted ()
    var
//       SIIDocUploadState@1100000 :
      SIIDocUploadState: Record 10752;
    begin
      if Status IN [Status::Accepted,Status::"Accepted With Errors"] then
        FIELDERROR(Status);

      SIIDocUploadState.GET("Document State Id");
      SIIDocUploadState.VALIDATE(Status,SIIDocUploadState.Status::"Accepted With Errors");
      SIIDocUploadState.VALIDATE("Accepted By User ID",USERID);
      SIIDocUploadState.VALIDATE("Accepted Date Time",CURRENTDATETIME);
      SIIDocUploadState.MODIFY;

      Status := Status::"Accepted With Errors";
      "Error Message" := STRSUBSTNO(MarkAsAcceptedErr,USERID,CURRENTDATETIME);
      MODIFY;
    end;
*/


    
/*
procedure MarkAsNotAccepted ()
    var
//       SIIDocUploadState@1100000 :
      SIIDocUploadState: Record 10752;
    begin
      if not (Status IN [Status::Accepted,Status::"Accepted With Errors"]) then
        FIELDERROR(Status);

      SIIDocUploadState.GET("Document State Id");
      SIIDocUploadState.VALIDATE(Status,SIIDocUploadState.Status::Failed);
      SIIDocUploadState.VALIDATE("Accepted By User ID",'');
      SIIDocUploadState.VALIDATE("Accepted Date Time",0DT);
      SIIDocUploadState.MODIFY;

      Status := Status::Failed;
      "Error Message" := STRSUBSTNO(MarkAsNotAcceptedErr,USERID,CURRENTDATETIME);
      MODIFY;
    end;

    /*begin
    end.
  */
}




