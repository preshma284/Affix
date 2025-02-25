pageextension 50123 MyExtension132 extends 132//112
{
layout
{
addafter("General")
{
group("Service Order")
{
        
                CaptionML=ENU='Service Order',ESP='Pedido de Servicio';
                Visible=seeServiceOrder;
    field("Expenses/Investment";SalesHeaderExt."Expenses/Investment")
    {
        
                CaptionML=ENU='Expenses/Investment',ESP='Gastos/Inversi¢n';
                Editable=false ;
}
    field("Grouping Criteria";SalesHeaderExt."Grouping Criteria")
    {
        
                CaptionML=ENU='Grouping Criteria',ESP='Criterios de agrupaci¢n';
                Editable=false ;
}
group("PriceReview")
{
        
                CaptionML=ENU='rec."Price review"',ESP='Revisi¢n precios';
                Editable=false;
    field("Price review";SalesHeaderExt."Price review")
    {
        
                CaptionML=ENU='rec."Price review"',ESP='Revision precios';
}
    field("Price review code";SalesHeaderExt."Price review code")
    {
        
                CaptionML=ENU='rec."Price review code"',ESP='Cod. Revision precios';
}
    field("Price review percentage";SalesHeaderExt."Price review percentage")
    {
        
                CaptionML=ENU='rec."Price review percentage"',ESP='Porcentaje revision precios';
}
    field("IPC/Rev aplicado";SalesHeaderExt."IPC/Rev aplicado")
    {
        
                CaptionML=ENU='rec."IPC/Rev aplicado"',ESP='rec."IPC/Rev aplicado"';
}
}
group("Control1100286032")
{
        
                CaptionML=ENU='Failiure Information',ESP='Informaci¢n aver¡as';
                Editable=false;
    field("Contract No.";SalesHeaderExt."Contract No.")
    {
        
                CaptionML=ENU='Contract No.',ESP='N§ contrato';
}
    field("Failiure Benefit Centre";SalesHeaderExt."Failiure Benefit Centre")
    {
        
                CaptionML=ENU='Benefit Centre',ESP='Centro beneficio';
}
    field("Failiure Budget Pos.";SalesHeaderExt."Failiure Budget Pos.")
    {
        
                CaptionML=ENU='Budget Pos.',ESP='Pos. presup.';
}
    field("Failiure Order";SalesHeaderExt."Failiure Order")
    {
        
                CaptionML=ENU='Order',ESP='Orden';
}
    field("Failiure Pep.";SalesHeaderExt."Failiure Pep.")
    {
        
                CaptionML=ESP='Pep.';
}
    field("Failiure Order No.";SalesHeaderExt."Failiure Order No.")
    {
        
                CaptionML=ENU='rec."Order No."',ESP='N§ pedido';
}
}
}
} addafter("Sell-to Customer Name")
{
    field("QB_JobNo";rec."Job No.")
    {
        
                Editable=FALSE ;
}
} addafter("Due Date")
{
//     field("Do not send to SII";rec."Do not send to SII")
//     {
        
//                 Visible=verSII;
//                 Editable=FALSE ;
// }
} addafter("Payment Terms Code")
{
    field("QB_CodWithholdingByG.E";rec."QW Cod. Withholding by GE")
    {
        
                Editable=false ;
}
    field("QB_CodWithholdingByPIT";rec."QW Cod. Withholding by PIT")
    {
        
                Editable=false ;
}
    field("QB_WitholdingDueDate";rec."QW Witholding Due Date")
    {
        
                Editable=false ;
}
    field("QB_PaymentBankNo";rec."Payment bank No.")
    {
        
                Editable=false ;
}
    field("QB_BankName";FunctionQB.GetBankName(rec."Payment bank No."))
    {
        
                CaptionML=ENU='Bank Name',ESP='Nombre del banco';
                Enabled=false ;
}
group("Control1100286006")
{
        
                CaptionML=ENU='Payment',ESP='Periodo de facturaci¢n';
                Visible=seeFacturae;
    field("QFA Period Start Date";rec."QFA Period Start Date")
    {
        
                Visible=seeFacturae;
                Editable=FALSE ;
}
    field("QFA Period End Date";rec."QFA Period End Date")
    {
        
                Visible=seeFacturae;
                Editable=FALSE ;
}
}
} addafter("Foreign Trade")
{
group("Control1100286011")
{
        
                CaptionML=ENU='QuoSII',ESP='QuoSII';
                Visible=verQuoSII;
    field("QuoSII Exercise-Period";rec."QuoSII Exercise-Period")
    {
        
}
    field("QuoSII Operation Date";rec."QuoSII Operation Date")
    {
        
                ToolTipML=ESP='Si est  informada la feha de operaci¢n se usar  esta, si no lo est  y hay fecha fin del periodo se usar  esta, si no hay ninguna informada se usara la mayor de las fechas de env¡o de las lineas que en general coincide con la fecha de registro';
}
    field("QuosII_DoNotSendToSI";rec."Do not send to SII")
    {
        
                ToolTipML=ESP='Si se marca este documento no subir  al SII, pero quedar  en la lista de documentos del SII como referencia';
}
    field("QuoSII Entity";rec."QuoSII Entity")
    {
        
}
    field("QuoSII Sales Invoice Type QS";rec."QuoSII Sales Invoice Type QS")
    {
        
                Enabled=FALSE;
                Editable=FALSE ;
}
    field("QuoSII Sales Corr. Inv. Type";rec."QuoSII Sales Corr. Inv. Type")
    {
        
                Enabled=FALSE;
                Editable=FALSE ;
}
    field("QuoSII Sales Cr.Memo Type";rec."QuoSII Sales Cr.Memo Type")
    {
        
                Enabled=FALSE;
                Editable=FALSE ;
}
    field("QuoSII Sales Special Regimen";rec."QuoSII Sales Special Regimen")
    {
        
                Enabled=FALSE;
                Editable=FALSE ;
}
    field("QuoSII Sales Special Regimen 1";rec."QuoSII Sales Special Regimen 1")
    {
        
                Enabled=FALSE;
                Editable=FALSE ;
}
    field("QuoSII Sales Special Regimen 2";rec."QuoSII Sales Special Regimen 2")
    {
        
                Enabled=FALSE;
                Editable=FALSE ;
}
    field("QuoSII Sales UE Inv Type";rec."QuoSII Sales UE Inv Type")
    {
        
                Enabled=FALSE;
                Editable=FALSE ;
}
    field("QuoSII Bienes Description";rec."QuoSII Bienes Description")
    {
        
                Enabled=FALSE;
                Editable=FALSE ;
}
    field("QuoSII Operator Address";rec."QuoSII Operator Address")
    {
        
                Enabled=FALSE;
                Editable=FALSE ;
}
    field("QuoSII First Ticket No.";rec."QuoSII First Ticket No.")
    {
        
}
    field("QuoSII Last Ticket No.";rec."QuoSII Last Ticket No.")
    {
        
                Enabled=FALSE;
                Editable=FALSE ;
}
    field("QuoSII Third Party";rec."QuoSII Third Party")
    {
        
                Enabled=FALSE;
                Editable=FALSE ;
}
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
} addafter("IncomingDocAttachFactBox")
{
    part("QB_QuoFacturae_Entry_FactBox";7174499)
    {
        
                CaptionML=ESP='Mov. QuoFacturae';SubPageLink="Document no."=field("No.");
                Visible=seeFacturae;
}
}


modify("SII Information")
{
Visible=verSII;


}


modify("OperationDescription")
{
Visible=verSII;


}


modify("Special Scheme Code")
{
Visible=verSII;


}


modify("Invoice Type")
{
Visible=verSII;


}


modify("ID Type")
{
Visible=verSII;


}


modify("Succeeded Company Name")
{
Visible=verSII;


}


modify("Succeeded VAT Registration No.")
{
Visible=verSII;


}


//modify("Payment")
//{
//
//
//}
//

// modify("Attached Documents")
// {
// Name=QB_Attached Documents;
// }
// modify("Attached Documents")
// {
// }

}

actions
{
addafter("&Navigate")
{
    action("QB_SendInternalMail")
    {
        
                      CaptionML=ENU='Send from Mail to Administration',ESP='Enviar por Mail a Administraci¢n';
                      ToolTipML=ESP='Esta opci¢n remitir  un mail de confirmaci¢n del documento registrado de manera interna';
                      Promoted=true;
                      Visible=seeDocToAdmin;
                      PromotedIsBig=true;
                      Image=SendAsPDF;
                      PromotedCategory=Category6;
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
                      PromotedCategory=Category7;
                      PromotedOnly=true;
}
    action("RequestFacturae")
    {
        CaptionML=ENU='Consultar factura en Facturae',ESP='Consultar en Facturae';
                      Promoted=true;
                      Visible=seeFacturae;
                      Image=ElectronicDoc;
                      PromotedCategory=Category7;
                      PromotedOnly=true;
}
    action("ExportFacturaefile")
    {
        CaptionML=ENU='Export Facturae xml file',ESP='Generar XML Facturae';
                      Promoted=true;
                      Visible=seeFacturae;
                      Image=ExportElectronicDocument;
                      PromotedCategory=Category7;
                      PromotedOnly=true;
}
    action("VoidFacturae")
    {
        CaptionML=ENU='Void Facturae Invoice',ESP='Anular en Facturae';
                      Promoted=true;
                      Visible=seeFacturae;
                      Image=VoidElectronicDocument;
                      PromotedCategory=Category7;
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
                      PromotedCategory=Category7;
                      PromotedOnly=true;
}
    action("AddLogFacturae")
    {
        CaptionML=ESP='Add Log.';
                      Promoted=true;
                      Visible=seeFacturae;
                      Image=Ledger;
                      PromotedCategory=Category7;
                      PromotedOnly=true;
}
}
}

}

//trigger
trigger OnOpenPage()    VAR
                 PaymentServiceSetup : Record 1060;
                 OfficeMgt : Codeunit 1630;
                 SIIManagement : Codeunit 10756;
               BEGIN
                 rec.SetSecurityFilterOnRespCenter;
                 CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;

                 IsOfficeAddin := OfficeMgt.IsAvailable;
                 IsFoundationEnabled := ApplicationAreaMgmtFacade.IsFoundationEnabled;

                 SIIManagement.CombineOperationDescription(rec."Operation Description",rec."Operation Description 2",OperationDescription);

                 ActivateFields;
                 PaymentServiceVisible := PaymentServiceSetup.IsPaymentServiceVisible;

                 //QB
                 verQuoSII := FunctionQB.AccessToQuoSII;
                 seeFacturae := FunctionQB.AccessToFacturae;
                 verSII := FunctionQB.AccessToSII();
                 seeServiceOrder := FunctionQB.AccessToServiceOrder(FALSE);

                 //+Q16494
                 seeDocToAdmin := FunctionQB.AutomaticInvoiceSending;
                 //-Q16494

                 //Q7357 -
                 seeDragDrop := FunctionQB.AccessToDragAndDrop(Rec.RECORDID);
                 IF seeDragDrop THEN
                   CurrPage.FilesSP.PAGE.FncGetAllDataOpenPage(DATABASE::"Sales Invoice Header");
                 //Q7357 +
               END;
trigger OnAfterGetCurrRecord()    VAR
                           IncomingDocument : Record 130;
                           CRMCouplingManagement : Codeunit 5331;
                           SIIManagement : Codeunit 10756;
                         BEGIN
                           HasIncomingDocument := IncomingDocument.PostedDocExists(rec."No.",rec."Posting Date");
                           DocExchStatusStyle := rec.GetDocExchStatusStyle;
                           CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);
                           IF CRMIntegrationEnabled THEN BEGIN
                             CRMIsCoupledToRecord := CRMCouplingManagement.IsRecordCoupledToCRM(Rec.RECORDID);
                             IF rec."No." <> xRec."No." THEN
                               CRMIntegrationManagement.SendResultNotification(Rec);
                           END;
                           UpdatePaymentService;
                           DocExcStatusVisible := rec.DocExchangeStatusIsSent;

                           SIIManagement.CombineOperationDescription(rec."Operation Description",rec."Operation Description 2",OperationDescription);

                           IF NOT SalesHeaderExt.GET(Rec.RECORDID) THEN
                             SalesHeaderExt.INIT;
                         END;


//trigger

var
      SalesInvHeader : Record 112;
      ApplicationAreaMgmtFacade : Codeunit 9179;
      CRMIntegrationManagement : Codeunit 5330;
      FormatAddress : Codeunit 365;
      ChangeExchangeRate : Page 511;
      HasIncomingDocument : Boolean;
      DocExchStatusStyle : Text;
      CRMIntegrationEnabled : Boolean;
      CRMIsCoupledToRecord : Boolean;
      PaymentServiceVisible : Boolean;
      PaymentServiceEnabled : Boolean;
      DocExcStatusVisible : Boolean;
      IsOfficeAddin : Boolean;
      IsFoundationEnabled : Boolean;
      IsBillToCountyVisible : Boolean;
      IsSellToCountyVisible : Boolean;
      IsShipToCountyVisible : Boolean;
      OperationDescription : Text[500];
      "--------------------- QB" : Integer;
      FunctionQB : Codeunit 7207272;
      verQuoSII : Boolean;
      seeFacturae : Boolean;
      verSII : Boolean;
      SalesHeaderExt : Record 7207071;
      seeServiceOrder : Boolean;
      seeDocToAdmin : Boolean;
      seeDragDrop : Boolean;

    
    

//procedure
Local procedure ActivateFields();
   begin
     IsBillToCountyVisible := FormatAddress.UseCounty(rec."Bill-to Country/Region Code");
     IsSellToCountyVisible := FormatAddress.UseCounty(rec."Sell-to Country/Region Code");
     IsShipToCountyVisible := FormatAddress.UseCounty(rec."Ship-to Country/Region Code");
   end;
Local procedure UpdatePaymentService();
   var
     PaymentServiceSetup : Record 1060;
   begin
     PaymentServiceEnabled := PaymentServiceSetup.CanChangePaymentService(Rec);
   end;

//procedure
}

