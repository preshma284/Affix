pageextension 50105 MyExtension10752 extends 10752//10750
{
layout
{
addafter("Error Message")
{
    field("QB_LastStatus";rec."Last Status")
    {
        
                CaptionML=ESP='Ultimo Estado';
                StyleExpr=Last_StyleText 

  ;
}
}

}

actions
{
addafter("Recreate Missing SII Entries")
{
group("QB_See")
{
        
                      CaptionML=ESP='Filtros';
                      //ActionContainerType=ActionItems ;
    action("QB_SeeError")
    {
        
                      CaptionML=ESP='Ver Erroneos';
                      Promoted=true;
                      PromotedIsBig=true;
                      Image=ErrorLog;
                      PromotedCategory=Process;
                      Scope=Repeater;
                      
                                trigger OnAction()    VAR
                                 Navigate : Page 344;
                               BEGIN
                                 Rec.SETFILTER("Last Status", '<>%1 & <>%2', rec."Last Status"::Accepted, rec."Last Status"::"Accepted With Errors");
                               END;


}
    action("QB_SeeAll")
    {
        
                      CaptionML=ESP='Ver Todos';
                      Promoted=true;
                      PromotedIsBig=true;
                      Image=Log;
                      PromotedCategory=Process;
                      
                                trigger OnAction()    VAR
                                 SIISession : Record 10753;
                                //  TempBlob : Record 99008535 TEMPORARY ;
                                TempBlob : Codeunit "Temp Blob";
Blob : OutStream;
InStr : InStream;
                                 FileManagement : Codeunit 419;
                                 FileName : Text;
                               BEGIN
                                 Rec.RESET;
                               END;


}
}
}


modify("&Navigate")
{
ToolTipML=ENU='Find all entries and documents that exist for the document number and posting date on the selected entry or document.',ESP='Buscar todos los movimientos y los documentos que existen para el n£mero de documento y la fecha de registro que constan en el movimiento o documento seleccionados.';


}

}

//trigger
trigger OnAfterGetRecord()    VAR
                       SIIManagement : Codeunit 10756;
                     BEGIN
                       RecordsFound := TRUE;
                       StyleText := SIIManagement.GetSIIStyle(rec."Status".AsInteger());
                       SIIDocUploadState.GET(rec."Document State Id");

                       //QB
                       Last_StyleText := SIIManagement.GetSIIStyle(SIIDocUploadState.Status.AsInteger());
                       //QB fin
                     END;


//trigger

var
      SIIDocUploadState : Record 10752;
      RecordsFound : Boolean ;
      HasRequestXML : Boolean ;
      HasResponseXML : Boolean ;
      StyleText : Text ;
      Enabled : Boolean;
      EnabledBatchSubmission : Boolean;
      RetryAcceptedQst : TextConst ENU='Accepted entries have been selected. Do you want to resend them?',ESP='Se han seleccionado movimientos aceptados. ¨Confirma que desea reenviarlos?';
      ShowAdvancedActions : Boolean;
      "----------------------------------- QB" : Integer;
      Last_StyleText : Text;

    
    

//procedure
//Local procedure IssueManualRequest(RetryAccepted : Boolean);
//    var
//      SIIHistory : Record 10750;
//      TempSIIDocUploadState : Record 10752 TEMPORARY ;
//      SIIDocUploadManagement : Codeunit 10752;
//    begin
//      if ( EnabledBatchSubmission  )then
//        CurrPage.SETSELECTIONFILTER(SIIHistory)
//      ELSE begin
//        SIIHistory := Rec;
//        SIIHistory.SETRECFILTER;
//      end;
//
//      WITH SIIHistory DO begin
//        ASCENDING(FALSE);
//        if ( RetryAccepted  )then
//          SETRANGE("Status",rec."Status"::Accepted)
//        ELSE
//          SETFILTER("Status",'<>%1',Status::Accepted);
//
//        if ( FINDSET(TRUE)  )then
//          repeat
//            CreateNewRequestPerDocument(
//              TempSIIDocUploadState,SIIHistory,rec."Upload Type",RetryAccepted or (rec."Status" = rec."Status"::"Accepted With Errors"));
//          until NEXT = 0;
//      end;
//      SIIDocUploadManagement.UploadManualDocument;
//    end;
//Local procedure RetryAllRequests();
//    var
//      SIIDocUploadState : Record 10752;
//      SIIHistory : Record 10750;
//      SIIDocUploadManagement : Codeunit 10752;
//    begin
//      SIIDocUploadState.SETFILTER("Status",'<>%1',Status::Accepted);
//      if ( SIIDocUploadState.FINDSET(TRUE)  )then begin
//        SIIHistory.ASCENDING(FALSE);
//        repeat
//          SIIHistory.SETRANGE("Document State Id",SIIDocUploadState.Id);
//          if ( SIIHistory.FINDFIRST  )then
//            if ( SIIHistory.Status <> SIIHistory.Status::Pending  )then
//              rec.CreateNewRequest(
//                SIIHistory."Document State Id",SIIHistory."Upload Type",1,TRUE,
//                SIIHistory.Status = SIIHistory.Status::"Accepted With Errors")
//            ELSE
//              if ( not SIIHistory."Is Manual"  )then begin
//                SIIHistory."Is Manual" := TRUE;
//                SIIHistory.MODIFY;
//                SIIDocUploadState."Is Manual" := TRUE;
//                SIIDocUploadState.MODIFY;
//              end;
//        until SIIDocUploadState.NEXT = 0;
//      end;
//      SIIDocUploadManagement.UploadManualDocument
//    end;
//Local procedure CreateNewRequestPerDocument(var TempSIIDocUploadState : Record 10752 TEMPORARY ;var SIIHistory : Record 10750;UploadType : Option;IsAcceptedWithErrorRetry : Boolean);
//    begin
//      WITH SIIHistory DO
//        if ( not TempSIIDocUploadState.GET(rec."Document State Id")  )then begin
//          TempSIIDocUploadState.Id := rec."Document State Id";
//          TempSIIDocUploadState.INSERT;
//
//          if ( rec."Status" <> rec."Status"::Pending  )then
//            // We set 1 retry for manual call.
//            rec.CreateNewRequest(rec."Document State Id",UploadType,1,TRUE,IsAcceptedWithErrorRetry)
//          ELSE
//            if ( not rec."Is Manual" and (rec."Status" <> rec."Status"::Accepted)  )then begin
//              rec."Is Manual" := TRUE;
//              Rec.MODIFY;
//              SIIDocUploadState.GET(rec."Document State Id");
//              SIIDocUploadState."Is Manual" := TRUE;
//              SIIDocUploadState.MODIFY;
//            end;
//        end;
//    end;

//procedure
}

