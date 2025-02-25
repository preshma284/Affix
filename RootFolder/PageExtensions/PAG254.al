pageextension 50160 MyExtension254 extends 254//81
{
layout
{
addafter("Description")
{
    field("QB_UsageSale";rec."Usage/Sale")
    {
        
}
    field("QB_JobNo";rec."Job No.")
    {
        
}
} addafter("Comment")
{
    field("QuoSII Purch. Invoice Type QS";rec."QuoSII Purch. Invoice Type QS")
    {
        
                Visible=vQuoSII;
                
                            ;trigger OnValidate()    BEGIN
                             //QuoSII_1.4.98.999.begin
                             IF (vQuoSII) THEN
                               SIIProcesing.P254_SetFieldNotEditable(Rec,PurchCorrectedInvoiceTypeB,PurchCrMemoTypeB,PurchUEInvTypeB,BienesDescriptionB,OperatorAddressB,FirstTicketNoB,LastTicketNoB);
                           END;


}
    field("QuoSII Purch. Cr.Memo Type";rec."QuoSII Purch. Cr.Memo Type")
    {
        
                Visible=vQuoSII;
                Enabled=PurchCrMemoTypeB;
                
                            ;trigger OnValidate()    BEGIN
                             //QuoSII_1.4.98.999.begin
                             IF (vQuoSII) THEN
                               SIIProcesing.P254_SetFieldNotEditable(Rec,PurchCorrectedInvoiceTypeB,PurchCrMemoTypeB,PurchUEInvTypeB,BienesDescriptionB,OperatorAddressB,FirstTicketNoB,LastTicketNoB);
                           END;


}
    field("QuoSII Purch. Cor. Inv. Type";rec."QuoSII Purch. Cor. Inv. Type")
    {
        
                Visible=vQuoSII;
                Enabled=PurchCorrectedInvoiceTypeB;
                
                            ;trigger OnValidate()    BEGIN
                             //QuoSII_1.4.98.999.begin
                             IF (vQuoSII) THEN
                               SIIProcesing.P254_SetFieldNotEditable(Rec,PurchCorrectedInvoiceTypeB,PurchCrMemoTypeB,PurchUEInvTypeB,BienesDescriptionB,OperatorAddressB,FirstTicketNoB,LastTicketNoB);
                           END;


}
    field("QuoSII Purch. Special Regimen";rec."QuoSII Purch. Special Regimen")
    {
        
                Visible=vQuoSII ;
}
    field("QuoSII Purch. Special Reg. 1";rec."QuoSII Purch. Special Reg. 1")
    {
        
                Visible=vQuoSII ;
}
    field("QuoSII Purch. Special Reg. 2";rec."QuoSII Purch. Special Reg. 2")
    {
        
                Visible=vQuoSII ;
}
    field("QuoSII Purch. UE Inv Type";rec."QuoSII Purch. UE Inv Type")
    {
        
                Visible=vQuoSII;
                Enabled=PurchUEInvTypeB;
                
                            ;trigger OnValidate()    BEGIN
                             //QuoSII_1.4.98.999.begin
                             IF (vQuoSII) THEN
                               SIIProcesing.P254_SetFieldNotEditable(Rec,PurchCorrectedInvoiceTypeB,PurchCrMemoTypeB,PurchUEInvTypeB,BienesDescriptionB,OperatorAddressB,FirstTicketNoB,LastTicketNoB);
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
    field("QuoSII Last Ticket No.";rec."QuoSII Last Ticket No.")
    {
        
                Visible=vQuoSII;
                Enabled=LastTicketNoB ;
}
    field("QuoSII Purch. Third Party";rec."QuoSII Purch. Third Party")
    {
        
                Visible=vQuoSII ;
}
    field("QuoSII Entity";rec."QuoSII Entity")
    {
        
                Visible=vQuoSII ;
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
               BEGIN
                 IsSaasExcelAddinEnabled := ServerConfigSettingHandler.GetIsSaasExcelAddinEnabled;
                 IF ClientTypeManagement.GetCurrentClientType = CLIENTTYPE::ODataV4 THEN
                   EXIT;

                 SetControlVisibility;
                 BalAccName := '';
                 IF rec.IsOpenedFromBatch THEN BEGIN
                   CurrentJnlBatchName := rec."Journal Batch Name";
                   GenJnlManagement.OpenJnl(CurrentJnlBatchName,Rec);
                   EXIT;
                 END;
                 GenJnlManagement.TemplateSelection(PAGE::"Purchase Journal",Enum::"Gen. Journal Template Type".FromInteger(2),FALSE,Rec,JnlSelected);
                 IF NOT JnlSelected THEN
                   ERROR('');

                 LastGenJnlBatch := GenJnlManagement.GetLastViewedJournalBatchName(PAGE::"Purchase Journal");
                 IF LastGenJnlBatch <> '' THEN
                   CurrentJnlBatchName := LastGenJnlBatch;
                 GenJnlManagement.OpenJnl(CurrentJnlBatchName,Rec);

                 //QuoSII_1.4.98.999.begin
                 vQuoSII := FunctionQB.AccessToQuoSII;
                 IF (vQuoSII) THEN
                   SIIProcesing.P254_SetFieldNotEditable(Rec,PurchCorrectedInvoiceTypeB,PurchCrMemoTypeB,PurchUEInvTypeB,BienesDescriptionB,OperatorAddressB,FirstTicketNoB,LastTicketNoB);
               END;


//trigger

var
      GenJnlManagement : Codeunit 230;
      ReportPrint : Codeunit 228;
      ClientTypeManagement : Codeunit 50192;//changed from  4
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
      HasIncomingDocument : Boolean;
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
      PurchCorrectedInvoiceTypeB : Boolean;
      PurchCrMemoTypeB : Boolean;
      PurchUEInvTypeB : Boolean;
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

