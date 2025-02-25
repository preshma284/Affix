pageextension 50138 MyExtension146 extends 146//122
{
layout
{
addafter("Buy-from Vendor Name")
{
    field("QB_VATRegistrationNo";rec."VAT Registration No.")
    {
        
}
} addafter("Amount Including VAT")
{
    field("QB_Base";"QB_Base")
    {
        
                CaptionML=ESP='Base Imponible';
}
    field("QB_IVA";"QB_IVA")
    {
        
                CaptionML=ESP='IVA';
}
    field("QB_IRPF";"QB_IRPF")
    {
        
                CaptionML=ESP='IRPF';
}
    field("QB_Total";"QB_Total")
    {
        
                CaptionML=ESP='Total';
}
    field("QB_Ret";"QB_Ret")
    {
        
                CaptionML=ESP='Ret.Pago';
}
    field("QB_Pagar";"QB_Pagar")
    {
        
                CaptionML=ESP='A Pagar';
}
} addafter("Corrective")
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


modify("Amount")
{
Visible=false;


}


modify("Amount Including VAT")
{
Visible=false;


}


modify("Location Code")
{
Visible=false ;


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

                 //JAV 14/06/21: - QB 1.08.48 ver el estado del QuoSII del documento
                 seeQuoSII := FunctionQB.AccessToQuoSII;

                 //Q7357 -
                 seeDragDrop := FunctionQB.AccessToDragAndDrop(Rec.RECORDID);
                 IF seeDragDrop THEN
                   CurrPage.FilesSP.PAGE.FncGetAllDataOpenPage(DATABASE::"Purch. Inv. Header");
                 //Q7357 +
               END;
trigger OnAfterGetRecord()    VAR
                       SIIManagement : Codeunit 10756;
                     BEGIN
                       StyleText := SIIManagement.GetSIIStyle(rec."SII Status".AsInteger());

                       //QB - Nombre del proyecto
                       JobDescription := '';
                       IF Job.GET(Rec."Job No.") THEN
                         JobDescription := Job.Description;

                       //JAV 30/10/20 - QB 1.07.02 Calculo de importes
                       QB_CalculateDocTotals;

                       //JAV 14/06/21: - QB 1.08.48 obtener el estado en el QuoSII
                       IF seeQuoSII THEN
                         SIIProcesing.QuoSII_GetStatus(2, rec."No.", QS_Status, stStatus);
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

                           //+Q8636
                           IF seeDragDrop THEN BEGIN
                             CurrPage.DropArea.PAGE.SetFilter(Rec);
                             CurrPage.FilesSP.PAGE.SetFilter(Rec);
                           END;
                           //-Q8636

                           IF seeQuoSII THEN
                             SIIProcesing.QuoSII_GetStatus(2, rec."No.", QS_Status, stStatus);
                         END;


//trigger

var
      ApplicationAreaMgmtFacade : Codeunit 9179;
      IsOfficeAddin : Boolean;
      IsFoundationEnabled : Boolean;
      StyleText : Text ;
      SIIStateVisible : Boolean ;
      "---------------------------- QB" : Integer;
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
      "------------------------------------ QB" : Integer;
      QB_Base : Decimal;
      QB_IVA : Decimal;
      QB_IRPF : Decimal;
      QB_Total : Decimal;
      QB_Ret : Decimal;
      QB_Pagar : Decimal;

    
    

//procedure
LOCAL procedure "-------------------------------------------- QB"();
    begin
    end;
LOCAL procedure QB_CalculateDocTotals();
    begin
      //JAV 18/08/19: - Calculo del total del documento con las retenciones
      Rec.CALCFIELDS("Amount", "Amount Including VAT", "QW Total Withholding GE", "QW Total Withholding PIT");

      QB_Base  := Rec.Amount;
      QB_IVA   := Rec."Amount Including VAT" - Rec.Amount;
      QB_IRPF  := Rec."QW Total Withholding PIT";
      QB_Total := QB_Base + QB_IVA - QB_IRPF;
      QB_Ret   := Rec."QW Total Withholding GE";
      QB_Pagar := QB_Total - QB_Ret;
    end;

//procedure
}

