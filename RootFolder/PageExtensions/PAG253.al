pageextension 50159 MyExtension253 extends 253//81
{
layout
{
addafter("Description")
{
    field("QB Job No.";rec."QB Job No.")
    {
        
                Visible=false ;
}
    field("QB_JobNo";rec."Job No.")
    {
        
}
    field("Piecework Code";rec."Piecework Code")
    {
        
}
} addafter("Direct Debit Mandate ID")
{
    field("QuoSII Sales Invoice Type QS";rec."QuoSII Sales Invoice Type QS")
    {
        
                Visible=vQuoSII;
                
                            ;trigger OnValidate()    BEGIN
                             //QuoSII_1.4.98.999.begin
                             IF (vQuoSII) THEN
                               SIIProcesing.P253_SetFieldNotEditable(Rec,SalesCorrectedInvoiceTypeB,SalesCrMemoTypeB,SalesUEInvTypeB,BienesDescriptionB,OperatorAddressB,FirstTicketNoB,LastTicketNoB);
                           END;


}
    field("QuoSII Sales Cor. Invoice Type";rec."QuoSII Sales Cor. Invoice Type")
    {
        
                Visible=vQuoSII;
                Enabled=SalesCorrectedInvoiceTypeB;
                
                            ;trigger OnValidate()    BEGIN
                             //QuoSII_1.4.98.999.begin
                             IF (vQuoSII) THEN
                               SIIProcesing.P253_SetFieldNotEditable(Rec,SalesCorrectedInvoiceTypeB,SalesCrMemoTypeB,SalesUEInvTypeB,BienesDescriptionB,OperatorAddressB,FirstTicketNoB,LastTicketNoB);
                           END;


}
    field("QuoSII Sales Cr.Memo Type";rec."QuoSII Sales Cr.Memo Type")
    {
        
                Visible=vQuoSII;
                Enabled=SalesCrMemoTypeB;
                
                            ;trigger OnValidate()    BEGIN
                             //QuoSII_1.4.98.999.begin
                             IF (vQuoSII) THEN
                               SIIProcesing.P253_SetFieldNotEditable(Rec,SalesCorrectedInvoiceTypeB,SalesCrMemoTypeB,SalesUEInvTypeB,BienesDescriptionB,OperatorAddressB,FirstTicketNoB,LastTicketNoB);
                           END;


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
        
                Visible=vQuoSII;
                Enabled=SalesUEInvTypeB;
                
                            ;trigger OnValidate()    BEGIN
                             //QuoSII_1.4.98.999.begin
                             IF (vQuoSII) THEN
                               SIIProcesing.P253_SetFieldNotEditable(Rec,SalesCorrectedInvoiceTypeB,SalesCrMemoTypeB,SalesUEInvTypeB,BienesDescriptionB,OperatorAddressB,FirstTicketNoB,LastTicketNoB);
                           END;


}
    field("QuoSII Bienes Description";rec."QuoSII Bienes Description")
    {
        
                Visible=vQuoSII;
                Enabled=BienesDescriptionB ;
}
    field("QuoSII Operator Address";rec."QuoSII Operator Address")
    {
        
                Visible=vQuoSII;
                Enabled=OperatorAddressB ;
}
    field("QuoSII UE Country";rec."QuoSII UE Country")
    {
        
                Visible=vQuoSII ;
}
    field("QuoSII Medio Cobro/Pago";rec."QuoSII Medio Cobro/Pago")
    {
        
                Visible=vQuoSII ;
}
    field("QuoSII Cuenta Medio Cobro/Pago";rec."QuoSII Cuenta Medio Cobro/Pago")
    {
        
                Visible=vQuoSII ;
}
    field("QuoSII First Ticket No.";rec."QuoSII First Ticket No.")
    {
        
                Visible=vQuoSII;
                Enabled=FirstTicketNoB ;
}
    field("QuoSII Last Ticket No.";rec."QuoSII Last Ticket No.")
    {
        
                Visible=vQuoSII;
                Enabled=LastTicketNoB ;
}
    field("QuoSII Sales Third Party";rec."QuoSII Sales Third Party")
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
    field("QuoSII Entity";rec."QuoSII Entity")
    {
        
                Visible=vQuoSII ;
}
} addafter("Succeeded VAT Registration No.")
{
    field("Do not sent to SII";rec."Do not sent to SII")
    {
        
}
}

}

actions
{


}

//trigger
trigger OnOpenPage()    VAR
                 ServerConfigSettingHandler : Codeunit 6723;
                 JnlSelected : Boolean;
                 LastGenJnlBatch : Code[10];
                 GenJournalTemplateType: Enum "Gen. Journal Template Type";
               BEGIN
                 IsSaasExcelAddinEnabled := ServerConfigSettingHandler.GetIsSaasExcelAddinEnabled;
                 IF ClientTypeManagement.GetCurrentClientType = CLIENTTYPE::ODataV4 THEN
                   EXIT;

                 BalAccName := '';
                 SetControlVisibility;
                 IF rec.IsOpenedFromBatch THEN BEGIN
                   CurrentJnlBatchName := rec."Journal Batch Name";
                   GenJnlManagement.OpenJnl(CurrentJnlBatchName,Rec);
                   EXIT;
                 END;
                 GenJnlManagement.TemplateSelection(PAGE::"Sales Journal",Enum::"Gen. Journal Template Type".FromInteger(1),FALSE,Rec,JnlSelected);
                 IF NOT JnlSelected THEN
                   ERROR('');

                 LastGenJnlBatch := GenJnlManagement.GetLastViewedJournalBatchName(PAGE::"Sales Journal");
                 IF LastGenJnlBatch <> '' THEN
                   CurrentJnlBatchName := LastGenJnlBatch;
                 GenJnlManagement.OpenJnl(CurrentJnlBatchName,Rec);

                 //QuoSII_1.4.98.999.begin
                 vQuoSII := FunctionQB.AccessToQuoSII;
                 IF (vQuoSII) THEN
                   SIIProcesing.P253_SetFieldNotEditable(Rec,SalesCorrectedInvoiceTypeB,SalesCrMemoTypeB,SalesUEInvTypeB,BienesDescriptionB,OperatorAddressB,FirstTicketNoB,LastTicketNoB);
               END;


//trigger

var
      GenJnlManagement : Codeunit 230;
      ReportPrint : Codeunit 228;
      ClientTypeManagement : Codeunit 50192; //changed from  4
      ChangeExchangeRate : Page 511;
      GLReconcile : Page 345;
      CurrentJnlBatchName : Code[10];
      AccName : Text[50];
      BalAccName : Text[50];
      Balance : Decimal;
      TotalBalance : Decimal;
      ShowBalance : Boolean;
      ShowTotalBalance : Boolean;
      ShortcutDimCode : ARRAY [8] OF Code[20];
      ApplyEntriesActionEnabled : Boolean;
      BalanceVisible : Boolean ;
      TotalBalanceVisible : Boolean ;
      AmountVisible : Boolean;
      DebitCreditVisible : Boolean;
      IsSaasExcelAddinEnabled : Boolean;
      IsSimplePage : Boolean;
      DocumentAmount : Decimal;
      EmptyDocumentTypeErr : TextConst ENU='You must specify a document type for %1.',ESP='Debe especificar un tipo de documento para %1.';
      NegativeDocAmountErr : TextConst ENU='You must specify a positive amount as the document amount. if the journal line is for a document type that has a negative amount, the amount will be tracked correctly.',ESP='Debe especificar un importe positivo como importe del documento. Si la l¡nea de diario es para un tipo de documento que tiene un importe negativo, se realizar  un seguimiento correcto del importe.';
      "--------------------- QuoSII" : Integer;
      FunctionQB : Codeunit 7207272;
      SIIProcesing : Codeunit 7174332;
      vQuoSII : Boolean;
      SalesCorrectedInvoiceTypeB : Boolean;
      SalesCrMemoTypeB : Boolean;
      SalesUEInvTypeB : Boolean;
      BienesDescriptionB : Boolean;
      OperatorAddressB : Boolean;
      FirstTicketNoB : Boolean;
      LastTicketNoB : Boolean;

    
    

//procedure
//Local procedure UpdateBalance();
//    begin
//      GenJnlManagement.CalcBalance(
//        Rec,xRec,Balance,TotalBalance,ShowBalance,ShowTotalBalance);
//      BalanceVisible := ShowBalance;
//      TotalBalanceVisible := ShowTotalBalance;
//    end;
//Local procedure EnableApplyEntriesAction();
//    begin
//      ApplyEntriesActionEnabled :=
//        (rec."Account Type" IN [rec."Account Type"::Customer,rec."Account Type"::Vendor]) or
//        (rec."Bal. Account Type" IN [rec."Bal. Account Type"::Customer,rec."Bal. Account Type"::Vendor]);
//    end;
//Local procedure CurrentJnlBatchNameOnAfterVali();
//    begin
//      CurrPage.SAVERECORD;
//      GenJnlManagement.SetName(CurrentJnlBatchName,Rec);
//      CurrPage.UPDATE(FALSE);
//    end;
Local procedure SetControlVisibility();
   var
     GLSetup : Record 98;
   begin
     GLSetup.GET;
     // Hide amount when open in simple page mode.
     if ( IsSimplePage  )then begin
       AmountVisible := FALSE;
       DebitCreditVisible := FALSE;
     end ELSE begin
       AmountVisible := not (GLSetup."Show Amounts" = GLSetup."Show Amounts"::"Debit/Credit Only");
       DebitCreditVisible := not (GLSetup."Show Amounts" = GLSetup."Show Amounts"::"Amount Only");
     end;
   end;

//procedure
}

