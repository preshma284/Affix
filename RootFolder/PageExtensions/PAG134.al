pageextension 50125 MyExtension134 extends 134//114
{
layout
{
addafter("Sell-to Customer Name")
{
    field("QB_JobNo";rec."Job No.")
    {
        
                Editable=FALSE ;
}
} addafter("Document Date")
{
//     field("Do not send to SII";rec."Do not send to SII")
//     {
        
//                 Editable=FALSE ;
// }
} addafter("Location Code")
{
    field("QB_PaymentBankNo";rec."Payment bank No.")
    {
        
                Editable=false ;
}
    field("QB_BankName";FunctionQB.GetBankName(rec."Payment bank No."))
    {
        
                CaptionML=ENU='Bank Name',ESP='Nombre del banco';
                Enabled=false ;
}
} addafter("Shipping and Billing")
{
group("Control1100286011")
{
        
                CaptionML=ENU='QuoSII',ESP='QuoSII';
                Visible=vQuoSII;
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
    field("QuoSII Sales Cor. Inv. Type";rec."QuoSII Sales Cor. Inv. Type")
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


modify("Cr. Memo Type")
{
Visible=verSII;


}


modify("Correction Type")
{
Visible=verSII;


}

}

actions
{
addafter("SendCustom")
{
    action("QB_SendInternalMail")
    {
        
                      CaptionML=ENU='Send from Mail to Administration',ESP='Enviar por Mail a Administraci¢n';
                      ToolTipML=ESP='Esta opci¢n remitir  un mail de confirmaci¢n del documento registrado de manera interna';
                      Promoted=true;
                      Visible=seeDocToAdmin;
                      PromotedIsBig=true;
                      Image=SendAsPDF;
                      PromotedCategory=Category4;
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
}
}

}

//trigger
trigger OnOpenPage()    VAR
                 OfficeMgt : Codeunit 1630;
                 SIIManagement : Codeunit 10756;
                 CompanyInformation : Record 79;
               BEGIN
                 rec.SetSecurityFilterOnRespCenter;
                 IsOfficeAddin := OfficeMgt.IsAvailable;
                 IsFoundationEnabled := ApplicationAreaMgmtFacade.IsFoundationEnabled;

                 SIIManagement.CombineOperationDescription(rec."Operation Description",rec."Operation Description 2",OperationDescription);

                 ActivateFields;

                 verSII := FunctionQB.AccessToSII;           //Campos del estandar de MS
                 vQuoSII := FunctionQB.AccessToQuoSII;       //Campos del QuoSII
                 seeFacturae := FunctionQB.AccessToFacturae;
                 //+Q16494
                 seeDocToAdmin := FunctionQB.AutomaticInvoiceSending;
                 //-Q16494
               END;


//trigger

var
      SalesCrMemoHeader : Record 114;
      ApplicationAreaMgmtFacade : Codeunit 9179;
      FormatAddress : Codeunit 365;
      ChangeExchangeRate : Page 511;
      HasIncomingDocument : Boolean;
      DocExchStatusStyle : Text;
      DocExchStatusVisible : Boolean;
      IsOfficeAddin : Boolean;
      IsFoundationEnabled : Boolean;
      SalesCorrectiveCrMemoExists : Boolean;
      IsBillToCountyVisible : Boolean;
      IsSellToCountyVisible : Boolean;
      IsShipToCountyVisible : Boolean;
      OperationDescription : Text[500];
      "--------------------- QB" : Integer;
      FunctionQB : Codeunit 7207272;
      vQuoSII : Boolean;
      seeFacturae : Boolean;
      verSII : Boolean;
      seeDocToAdmin : Boolean;

    
    

//procedure
Local procedure ActivateFields();
   begin
     IsBillToCountyVisible := FormatAddress.UseCounty(rec."Bill-to Country/Region Code");
     IsSellToCountyVisible := FormatAddress.UseCounty(rec."Sell-to Country/Region Code");
     IsShipToCountyVisible := FormatAddress.UseCounty(rec."Ship-to Country/Region Code");
   end;

//procedure
}

