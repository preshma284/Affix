pageextension 50135 MyExtension143 extends 143//112
{
layout
{
addafter("Sell-to Contact")
{
    field("QB_JobNo";rec."Job No.")
    {
        
}
    field("QB_CodWithholdingByGE";rec."QW Cod. Withholding by GE")
    {
        
}
    field("QB_CodWithholdingByPIT";rec."QW Cod. Withholding by PIT")
    {
        
}
} addafter("<Document Exchange Status>")
{
    field("QFA_QuoFacturaeStatus";rec."QFA QuoFacturae status")
    {
        
                Visible=seeFacturae ;
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
addafter("ActivityLog")
{
    action("QFA_SendFacturae")
    {
        CaptionML=ENU='Send invoice to Factura-e',ESP='Enviar factura a Factura-e';
                      Promoted=true;
                      Visible=seeFacturae;
                      Image=SendElectronicDocument;
                      PromotedCategory=Process;
}
    action("QB_SendInternalMail")
    {
        
                      CaptionML=ENU='Send from Mail to Administration',ESP='Enviar por Mail a Administraci¢n';
                      ToolTipML=ESP='Esta opci¢n remitir  un mail de confirmaci¢n del documento registrado de manera interna';
                      Promoted=true;
                      Visible=seeDocToAdmin;
                      PromotedIsBig=true;
                      Image=SendAsPDF;
                      PromotedCategory=Category7;
                      PromotedOnly=true;
                      
                                trigger OnAction()    VAR
                                 QBMailManagement : Codeunit 7206983;
                                 SalesInvoiceHeader : Record 112;
                               BEGIN
                                 //APC 12/05/22: QB 1.10.41 (Q16494) Remitir un mail con el documento a la administraci¢n   //JAV 16/05/22 Peque¤os Cambios
                                 SalesInvoiceHeader := Rec;
                                 CurrPage.SETSELECTIONFILTER(SalesInvoiceHeader);
                                 QBMailManagement.SendInternalSalesDocument(SalesInvoiceHeader, TRUE);
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
                 SalesInvoiceHeader : Record 112;
                 CRMIntegrationManagement : Codeunit 5330;
                 OfficeMgt : Codeunit 1630;
                 HasFilters : Boolean;
                 CompanyInformation : Record 79;
               BEGIN
                 HasFilters := Rec.GETFILTERS <> '';
                 rec.SetSecurityFilterOnRespCenter;
                 CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;
                 IF HasFilters THEN
                   IF Rec.FINDFIRST THEN;
                 IsOfficeAddin := OfficeMgt.IsAvailable;
                 IsFoundationEnabled := ApplicationAreaMgmtFacade.IsFoundationEnabled;

                 SIIStateVisible := SIISetup.IsEnabled;
                 SalesInvoiceHeader.COPYFILTERS(Rec);
                 SalesInvoiceHeader.SETFILTER("Document Exchange Status",'<>%1',rec."Document Exchange Status"::"Not Sent");
                 DocExchStatusVisible := NOT SalesInvoiceHeader.ISEMPTY;

                 //QFA
                 seeFacturae := FunctionQB.AccessToFacturae;
                 //JAV 14/06/21: - QB 1.08.48 ver el estado del QuoSII del documento
                 //IF seeQuoSII THEN  //JAV 03/12/21 - QB 1.10.07 No debe estar  condicionado
                 seeQuoSII := FunctionQB.AccessToQuoSII;

                 //+Q16494
                 seeDocToAdmin := FunctionQB.AutomaticInvoiceSending;
                 //-Q16494

                 //Q7357 -
                 seeDragDrop := FunctionQB.AccessToDragAndDrop(Rec.RECORDID);
                 IF seeDragDrop THEN
                   CurrPage.FilesSP.PAGE.FncGetAllDataOpenPage(DATABASE::"Sales Invoice Header");
                 //Q7357 +
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

                       //+Q8636
                       IF seeDragDrop THEN BEGIN
                         CurrPage.DropArea.PAGE.SetFilter(Rec);
                         CurrPage.FilesSP.PAGE.SetFilter(Rec);
                       END;
                       //-Q8636
                     END;
trigger OnAfterGetCurrRecord()    VAR
                           CRMCouplingManagement : Codeunit 5331;
                         BEGIN
                           HasPostedSalesInvoices := TRUE;
                           CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);
                           CRMIsCoupledToRecord := CRMIntegrationEnabled AND CRMCouplingManagement.IsRecordCoupledToCRM(Rec.RECORDID);

                           //JAV 14/06/21: - QB 1.08.48 obtener el estado en el QuoSII
                           IF seeQuoSII THEN  //JAV 03/12/21 - QB 1.10.07 No estaba condicionado por lo que daba un error de permiso
                             SIIProcesing.QuoSII_GetStatus(1, rec."No.", QS_Status, stStatus);
                         END;


//trigger

var
      ApplicationAreaMgmtFacade : Codeunit 9179;
      DocExchStatusStyle : Text;
      CRMIntegrationEnabled : Boolean;
      CRMIsCoupledToRecord : Boolean;
      DocExchStatusVisible : Boolean;
      IsOfficeAddin : Boolean;
      HasPostedSalesInvoices : Boolean;
      IsFoundationEnabled : Boolean;
      StyleText : Text ;
      SIIStateVisible : Boolean ;
      "---------------------------- QB" : Integer;
      seeFacturae : Boolean;
      FunctionQB : Codeunit 7207272;
      SIIProcesing : Codeunit 7174332;
      seeQuoSII : Boolean;
      QS_Status : Text;
      stStatus : Text;
      seeDocToAdmin : Boolean;
      seeDragDrop : Boolean;

    

//procedure

//procedure
}

