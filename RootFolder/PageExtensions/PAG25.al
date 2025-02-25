pageextension 50158 MyExtension25 extends 25//21
{
layout
{
addafter("Customer No.")
{
    field("QB_CustomerName";rec."QB Customer Name")
    {
        
}
    field("QB_CustomerPostingGroup";rec."Customer Posting Group")
    {
        
}
} addafter("External Document No.")
{
    field("QuoSII Sales Invoice Type";rec."QuoSII Sales Invoice Type")
    {
        
                Visible=vQuoSII ;
}
    field("QuoSII Sales Corrected In.Type";rec."QuoSII Sales Corrected In.Type")
    {
        
                Visible=vQuoSII ;
}
    field("QuoSII Sales Cr.Memo Type";rec."QuoSII Sales Cr.Memo Type")
    {
        
                Visible=vQuoSII ;
}
    field("QuoSII Sales Special Regimen";rec."QuoSII Sales Special Regimen")
    {
        
                Visible=vQuoSII ;
}
    field("QuoSII Sales Special Regimen 1";rec."QuoSII Sales Special Regimen 1")
    {
        
                Visible=vQuoSII ;
}
    field("QuoSII Sales Special Regimen 2";rec."QuoSII Sales Special Regimen 2")
    {
        
                Visible=vQuoSII ;
}
    field("QuoSII Sales UE Inv Type";rec."QuoSII Sales UE Inv Type")
    {
        
                Visible=vQuoSII ;
}
    field("QuoSII UE Country";rec."QuoSII UE Country")
    {
        
                Visible=vQuoSII ;
}
    field("QuoSII Bienes Description";rec."QuoSII Bienes Description")
    {
        
                Visible=vQuoSII ;
}
    field("QuoSII Operator Address";rec."QuoSII Operator Address")
    {
        
                Visible=vQuoSII ;
}
    field("QuoSII Third Party";rec."QuoSII Third Party")
    {
        
                Visible=vQuoSII ;
}
    field("QuoSII Situacion Inmueble";rec."QuoSII Situacion Inmueble")
    {
        
                Visible=vQuoSII ;
}
    field("QuoSII Referencia Catastral";rec."QuoSII Referencia Catastral")
    {
        
                Visible=vQuoSII ;
}
    field("QuoSII AEAT Status";rec."QuoSII AEAT Status")
    {
        
                Visible=vQuoSII ;
}
    field("QuoSII Ship No.";rec."QuoSII Ship No.")
    {
        
                Visible=vQuoSII ;
}
    field("QuoSII First Ticket No.";rec."QuoSII First Ticket No.")
    {
        
                Visible=vQuoSII ;
}
    field("QuoSII Last Ticket No.";rec."QuoSII Last Ticket No.")
    {
        
                Visible=vQuoSII ;
}
    field("QuoSII Entity";rec."QuoSII Entity")
    {
        
                Visible=vQuoSII ;
}
    field("QB_JobNo";rec."QB Job No.")
    {
        
}
    field("QB_BudgetItem";rec."QB Budget Item")
    {
        
}
    field("QB_WIPRemainingAmount";rec."QB WIP Remaining Amount")
    {
        
}
    field("QB_WIPRemainingAmtLCY";rec."QB WIP Remaining Amt. (LCY)")
    {
        
}
    field("QB_ReceivableBankNo";rec."QB Receivable Bank No.")
    {
        
                Editable=FALSE ;
}
    field("QB_BankName";FunctionQB.GetBankName(rec."QB Receivable Bank No."))
    {
        
                CaptionML=ESP='Nombre del banco';
                Enabled=false ;
}
    field("QW_WithholdingEntry";rec."QW Withholding Entry")
    {
        
}
    field("QB_Confirming";rec."QB Confirming")
    {
        
                ToolTipML=ESP='Indica si la operaciï¿½n ha provenido de un confirming';
}
    field("QB_ConfirmingDealingType";rec."QB Confirming Dealing Type")
    {
        
                ToolTipML=ESP='Indica el tipo de gestiï¿½n del confirming si la operaciï¿½n es de confirming';
}
    field("QFA_QuoFacturaeStatus";rec."QFA QuoFacturae Status")
    {
        
                Visible=seeFacturae ;
}
    field("QFA_PostingNoFacturae";rec."QFA Posting No. Facturae")
    {
        
                Visible=seeFacturae ;
}
    field("QB_Prepayment";rec."QB Prepayment")
    {
        
}
} addafter("Control38")
{
    part("QB_Document_Attachment_Factbox";1174)
    {
        SubPageLink="Table ID"=CONST(112), "No."=field("Document No.");
                Visible=seeFacturae;
}
    part("QB_QuoFacturae_Entry_FactBox";7174499)
    {
        
                CaptionML=ESP='Mov. QuoFacturae';SubPageLink="Document no."=field("Document No.");
                Visible=seeFacturae;
}
}

}

actions
{
addafter("F&unctions")
{
group("QFA_Group")
{
        
                      CaptionML=ESP='Facturae';
                      Visible=seeFacturae ;
    action("SendFacturae")
    {
        CaptionML=ENU='Send invoice to Factura-e',ESP='Enviar factura a Factura-e';
                      Promoted=true;
                      Visible=seeFacturae;
                      Image=SendElectronicDocument;
                      PromotedCategory=Category4;
                      PromotedOnly=true;
}
    action("RequestFacturae")
    {
        CaptionML=ENU='Consultar factura en Facturae',ESP='Consultar factura en Facturae';
                      Promoted=true;
                      Visible=seeFacturae;
                      Image=ElectronicDoc;
                      PromotedCategory=Category4;
                      PromotedOnly=true;
}
    action("ExportFacturaefile")
    {
        CaptionML=ENU='Export Facturae xml file',ESP='Exportar fichero xml Facturae';
                      Promoted=true;
                      Visible=seeFacturae;
                      Image=ExportElectronicDocument;
                      PromotedCategory=Category4;
                      PromotedOnly=true;
}
    action("VoidFacturae")
    {
        CaptionML=ENU='Void Facturae Invoice',ESP='Anular Factura Facturae';
                      Promoted=true;
                      Visible=seeFacturae;
                      Image=VoidElectronicDocument;
                      PromotedCategory=Category4;
                      PromotedOnly=true;
}
    action("FacturaeLedger")
    {
        CaptionML=ESP='Movs. Facturae';
                      RunObject=Page 7174497;
RunPageLink="Document no."=field("Document No.");
                      Promoted=true;
                      Visible=seeFacturae;
                      Image=Ledger;
                      PromotedCategory=Category4;
                      PromotedOnly=true;
}
}
} addfirst("F&unctions")
{
    action("Exports")
    {
        
                      CaptionML=ENU='First half-year Export',ESP='Exportar primer semestre';
                      ToolTipML=ENU='Exports First half-year movements in excel format',ESP='Exporta movimientos de cliente del primer semestre en formato excel para envï¿½o SII';
                      Visible=vQuoSII;
                      Image=Excel;
                      Scope=Repeater;
                      
                                trigger OnAction()    VAR
                                 SIIManagement : Codeunit 7174331;
                                 TipoExportacion: Option "Customer","Vendor";
                               BEGIN
                                 //QuoSII.B9.Begin
                                 SIIManagement.CSVExportEntries(TipoExportacion::Customer);
                                 //QuoSII.B9.End
                               END;


}
    action("Imports")
    {
        
                      CaptionML=ENU='First half-year Import',ESP='Importar primer semestre';
                      ToolTipML=ENU='Imports First half-year movements in excel format',ESP='Importa movimientos de cliente del primer semestre en formato excel para envï¿½o SII';
                      Visible=vQuoSII;
                      Image=Excel;
                      Scope=Repeater;
                      
                                trigger OnAction()    VAR
                                 SIIManagement : Codeunit 7174331;
                                 TipoExportacion: Option "Customer","Vendor";
                               BEGIN
                                 //QuoSII.B9.Begin
                                 SIIManagement.CSVImportEntries(TipoExportacion::Customer);
                                 //QuoSII.B9.end
                               END;


}
    separator("Action1100286102")
    {
        
}
}

}

//trigger
trigger OnOpenPage()    BEGIN
                 SetConrolVisibility;

                 IF Rec.GETFILTERS <> '' THEN
                   IF Rec.FINDFIRST THEN;

                 vQuoSII := FunctionQB.AccessToQuoSII;

                 //QFA
                 seeFacturae := FunctionQB.AccessToFacturae;
               END;


//trigger

var
      Navigate : Page 344;
      DimensionSetIDFilter : Page 481;
      StyleTxt : Text;
      HasIncomingDocument : Boolean;
      AmountVisible : Boolean;
      DebitCreditVisible : Boolean;
      "---------------------------- QB" : Integer;
      seeFacturae : Boolean;
      FunctionQB : Codeunit 7207272;
      vQuoSII : Boolean;

    
    

//procedure
Local procedure SetConrolVisibility();
   var
     GLSetup : Record 98;
   begin
     GLSetup.GET;
     AmountVisible := not (GLSetup."Show Amounts" = GLSetup."Show Amounts"::"Debit/Credit Only");
     DebitCreditVisible := not (GLSetup."Show Amounts" = GLSetup."Show Amounts"::"Amount Only");
   end;

//procedure
}

