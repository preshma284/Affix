pageextension 50136 MyExtension144 extends 144//114
{
layout
{
addafter("Document Exchange Status")
{
    field("QS_Status";"QS_Status")
    {
        
                CaptionML=ESP='Estado QuoSII';
                Visible=seeQuoSII;
                StyleExpr=stStatus ;
}
} addfirst("factboxes")
{}

}

actions
{
addafter("Send")
{
    action("QB_SendInternalMail")
    {
        
                      CaptionML=ENU='Send from Mail to Administration',ESP='Enviar por Mail a Administraci¢n';
                      ToolTipML=ESP='Esta opci¢n remitir  un mail de confirmaci¢n del documento registrado de manera interna';
                      Promoted=true;
                      Visible=seeDocToAdmin;
                      PromotedIsBig=true;
                      Image=SendAsPDF;
                      PromotedCategory=Process;
                      PromotedOnly=true;
                      
                                trigger OnAction()    VAR
                                 QBMailManagement : Codeunit 7206983;
                                 SalesCrMemoHeader : Record 114;
                               BEGIN
                                 //APC 12/05/22: QB 1.10.41 (Q16494) Remitir un mail con el documento a la administraci¢n   //JAV 16/05/22 Peque¤os Cambios
                                 SalesCrMemoHeader := Rec;
                                 CurrPage.SETSELECTIONFILTER(SalesCrMemoHeader);
                                 QBMailManagement.SendInternalSalesDocument(SalesCrMemoHeader, TRUE);
                                 //-Q16494
                               END;


}
} addafter("Update Document")
{
group("QFA_Group")
{
        
                      CaptionML=ESP='Facturae';
                      Visible=seeFacturae ;
    action("SendFacturae")
    {
        CaptionML=ENU='Send invoice to Factura-e',ESP='Enviar a Facturae';
                      Promoted=true;
                      Visible=seeFacturae;
                      Image=SendElectronicDocument;
                      PromotedCategory=Category8;
                      PromotedOnly=true;
}
    action("RequestFacturae")
    {
        CaptionML=ENU='Consultar factura en Facturae',ESP='Consultar en Facturae';
                      Promoted=true;
                      Visible=seeFacturae;
                      Image=ElectronicDoc;
                      PromotedCategory=Category8;
                      PromotedOnly=true;
}
    action("ExportFacturaefile")
    {
        CaptionML=ENU='Export Facturae xml file',ESP='Generar XML Facturae';
                      Promoted=true;
                      Visible=seeFacturae;
                      Image=ExportElectronicDocument;
                      PromotedCategory=Category8;
                      PromotedOnly=true;
}
    action("VoidFacturae")
    {
        CaptionML=ENU='Void Facturae Invoice',ESP='Anular en Facturae';
                      Promoted=true;
                      Visible=seeFacturae;
                      Image=VoidElectronicDocument;
                      PromotedCategory=Category8;
                      PromotedOnly=true;
}
    action("FacturaeLedger")
    {
        CaptionML=ESP='Movs. Facturae';
                      RunObject=Page 7174497;
RunPageLink="Document no."=field("No.");
                      Promoted=true;
                      Visible=seeFacturae;
                      Image=Ledger;
                      PromotedCategory=Category8;
                      PromotedOnly=true;
}
}
}

}

//trigger
trigger OnOpenPage()    VAR
                 SIISetup : Record 10751;
                 SalesCrMemoHeader : Record 114;
                 OfficeMgt : Codeunit 1630;
                 HasFilters : Boolean;
                 CompanyInformation : Record 79;
               BEGIN
                 HasFilters := Rec.GETFILTERS <> '';
                 rec.SetSecurityFilterOnRespCenter;
                 IF HasFilters THEN
                   IF Rec.FINDFIRST THEN;
                 IsOfficeAddin := OfficeMgt.IsAvailable;
                 IsFoundationEnabled := ApplicationAreaMgmtFacade.IsFoundationEnabled;

                 SIIStateVisible := SIISetup.IsEnabled;
                 SalesCrMemoHeader.COPYFILTERS(Rec);
                 SalesCrMemoHeader.SETFILTER("Document Exchange Status",'<>%1',rec."Document Exchange Status"::"Not Sent");
                 DocExchStatusVisible := NOT SalesCrMemoHeader.ISEMPTY;

                 //QFA
                 seeFacturae := FunctionQB.AccessToFacturae;
                 //JAV 14/06/21: - QB 1.08.48 ver el estado del QuoSII del documento
                 seeQuoSII := FunctionQB.AccessToQuoSII;
                 //+Q16494
                 seeDocToAdmin := FunctionQB.AutomaticInvoiceSending;
                 //-Q16494
               END;
trigger OnAfterGetRecord()    VAR
                       SIIManagement : Codeunit 10756;
                     BEGIN
                       IF DocExchStatusVisible THEN
                         DocExchStatusStyle := rec.GetDocExchStatusStyle;
                       StyleText := SIIManagement.GetSIIStyle(rec."SII Status".AsInteger());

                       //JAV 14/06/21: - QB 1.08.48 obtener el estado en el QuoSII
                       IF seeQuoSII THEN
                         SIIProcesing.QuoSII_GetStatus(1, rec."No.", QS_Status, stStatus);
                     END;
trigger OnAfterGetCurrRecord()    BEGIN
                           CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);

                           //JAV 14/06/21: - QB 1.08.48 obtener el estado en el QuoSII
                           IF seeQuoSII THEN
                             SIIProcesing.QuoSII_GetStatus(1, rec."No.", QS_Status, stStatus);
                         END;


//trigger

var
      ApplicationAreaMgmtFacade : Codeunit 9179;
      DocExchStatusStyle : Text;
      DocExchStatusVisible : Boolean;
      IsOfficeAddin : Boolean;
      IsFoundationEnabled : Boolean;
      StyleText : Text ;
      SIIStateVisible : Boolean ;
      "----------------------------- QB" : Integer;
      FunctionQB : Codeunit 7207272;
      SIIProcesing : Codeunit 7174332;
      seeFacturae : Boolean;
      seeQuoSII : Boolean;
      QS_Status : Text;
      stStatus : Text;
      seeDocToAdmin : Boolean;

    

//procedure
//Local procedure OnBeforePrintRecords(var SalesCrMemoHeader : Record 114);
//    begin
//    end;

//procedure
}

