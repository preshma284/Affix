pageextension 50139 MyExtension147 extends 147//124
{
layout
{
addafter("Applies-to Doc. Type")
{
    field("QB_JobNo";rec."Job No.")
    {
        
}
    field("QB_JobDescription";"JobDescription")
    {
        
                CaptionML=ENU='Description',ESP='Descripci¢n Proyecto';
}
    field("QB_OperationDateSII";rec."Operation date SII")
    {
        
                Visible=seeSII;
                Editable=FALSE ;
}
    field("QB_Vinculos";"Vinculos")
    {
        
                CaptionML=ESP='V¡nculos';
}
    field("QS_Status";"QS_Status")
    {
        
                CaptionML=ESP='Estado QuoSII';
                Visible=seeQuoSII;
                StyleExpr=stStatus ;
}
} addfirst("factboxes")
{    part("DropArea";7174655)
    {
        
                Visible=seeDragDrop;
}
    part("FilesSP";7174656)
    {
        
                Visible=seeDragDrop;
}
}

}

actions
{


}

//trigger
trigger OnOpenPage()    VAR
                 SIISetup : Record 10751;
                 OfficeMgt : Codeunit 1630;
                 HasFilters : Boolean;
               BEGIN
                 HasFilters := Rec.GETFILTERS <> '';
                 rec.SetSecurityFilterOnRespCenter;
                 IF HasFilters THEN
                   IF Rec.FINDFIRST THEN;
                 IsOfficeAddin := OfficeMgt.IsAvailable;
                 IsFoundationEnabled := ApplicationAreaMgmtFacade.IsFoundationEnabled;

                 SIIStateVisible := SIISetup.IsEnabled;

                 //JAV 04/07/19: - Control del SII de Mirosoft, se incluye la fecha de operaci¢n
                 seeSII := FunctionQB.AccessToSII();

                 //Q7357 -
                 seeDragDrop := FunctionQB.AccessToDragAndDrop(Rec.RECORDID);
                 IF seeDragDrop THEN
                   CurrPage.FilesSP.PAGE.FncGetAllDataOpenPage(DATABASE::"Purch. Cr. Memo Hdr.");
                 //Q7357 +

                 seeQuoSII := FunctionQB.AccessToQuoSII;
               END;
trigger OnAfterGetRecord()    VAR
                       SIIManagement : Codeunit 10756;
                     BEGIN
                       StyleText := SIIManagement.GetSIIStyle(rec."SII Status".AsInteger());

                       //QB - Nombre del proyecto
                       JobDescription := '';
                       IF Job.GET(Rec."Job No.") THEN
                         JobDescription := Job.Description;

                       //JAV 14/06/21: - QB 1.08.48 obtener el estado en el QuoSII
                       IF seeQuoSII THEN
                         SIIProcesing.QuoSII_GetStatus(2, rec."No.", QS_Status, stStatus);  //JAV 08/09/22: - QuoSII 1.06.11 Se cambia el tipo de documento de 1 (F.Emitida) a 2 (F.Recibida)

                       //+Q8636
                       IF seeDragDrop THEN BEGIN
                         CurrPage.DropArea.PAGE.SetFilter(Rec);
                         CurrPage.FilesSP.PAGE.SetFilter(Rec);
                       END;
                       //-Q8636
                     END;
trigger OnAfterGetCurrRecord()    VAR
                           rr : RecordRef;
                           RecordLink : Record 2000000068;
                         BEGIN
                           CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);

                           //QBA-01 21/02/19 JAV - Indicar si tiene v¡nculos el documento
                           Vinculos := FALSE;
                           rr.GETTABLE(Rec);
                           RecordLink.RESET;
                           RecordLink.SETRANGE("Record ID", rr.RECORDID);
                           Vinculos := RecordLink.FINDSET;

                           //JAV 14/06/21: - QB 1.08.48 obtener el estado en el QuoSII
                           IF seeQuoSII THEN
                             SIIProcesing.QuoSII_GetStatus(1, rec."No.", QS_Status, stStatus);
                         END;


//trigger

var
      ApplicationAreaMgmtFacade : Codeunit 9179;
      IsOfficeAddin : Boolean;
      IsFoundationEnabled : Boolean;
      StyleText : Text ;
      SIIStateVisible : Boolean ;
      "--------------------------QB" : Integer;
      Job : Record 167;
      FunctionQB : Codeunit 7207272;
      SIIProcesing : Codeunit 7174332;
      JobDescription : Text;
      Vinculos : Boolean;
      seeSII : Boolean ;
      seeDragDrop : Boolean;
      seeQuoSII : Boolean;
      QS_Status : Text;
      stStatus : Text;

    

//procedure
//Local procedure OnBeforePrintRecords(var PurchCrMemoHdr : Record 124);
//    begin
//    end;

//procedure
}

