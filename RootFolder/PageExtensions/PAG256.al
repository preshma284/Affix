pageextension 50162 MyExtension256 extends 256//81
{
layout
{
addafter("Account No.")
{
    field("QB_UsageSale";rec."Usage/Sale")
    {
        
}
    field("QB_JobNo";rec."Job No.")
    {
        
}
    field("QB_PieceworkCode";rec."Piecework Code")
    {
        
                Visible=FALSE ;
}
} addafter("Has Payment Export Error")
{
    field("QuoSII Auto Posting Date";rec."QuoSII Auto Posting Date")
    {
        
                Visible=vQuoSII ;
}
    field("QuoSII Purch. Invoice Type QS";rec."QuoSII Purch. Invoice Type QS")
    {
        
                Visible=vQuoSII ;
}
    field("QuoSII Purch. Cor. Inv. Type";rec."QuoSII Purch. Cor. Inv. Type")
    {
        
                Visible=vQuoSII ;
}
    field("QuoSII Purch. Cr.Memo Type";rec."QuoSII Purch. Cr.Memo Type")
    {
        
                Visible=vQuoSII ;
}
    field("QuoSII Purch. Special Regimen";rec."QuoSII Purch. Special Regimen")
    {
        
                Visible=vQuoSII ;
}
    field("QuoSII Purch. UE Inv Type";rec."QuoSII Purch. UE Inv Type")
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
    field("QuoSII Bienes Description";rec."QuoSII Bienes Description")
    {
        
                Visible=vQuoSII ;
}
    field("QuoSII Operator Address";rec."QuoSII Operator Address")
    {
        
                Visible=vQuoSII ;
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
        
                Visible=vQuoSII ;
}
    field("QuoSII Purch. Third Party";rec."QuoSII Purch. Third Party")
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
    field("QuoSII First Ticket No.";rec."QuoSII First Ticket No.")
    {
        
                Visible=vQuoSII ;
}
    field("QuoSII Entity";rec."QuoSII Entity")
    {
        
                Visible=vQuoSII ;
}
} addafter("Succeeded VAT Registration No.")
{
    field("QB_DueDate";rec."Due Date")
    {
        
}
}

}

actions
{


}

//trigger

trigger OnOpenPage()
var
ServerConfigSettingHandler : Codeunit 6723;
                 PermissionManager : Codeunit 51256; //changed from 9002
                 JnlSelected : Boolean;
               
begin

                 IsSaasExcelAddinEnabled := ServerConfigSettingHandler.GetIsSaasExcelAddinEnabled;
                 IsSaaS := PermissionManager.SoftwareAsAService;
                 IF CURRENTCLIENTTYPE = CLIENTTYPE::ODataV4 THEN
                   EXIT;

                 BalAccName := '';

                 SetConrolVisibility;
                 IF rec.IsOpenedFromBatch THEN BEGIN
                   CurrentJnlBatchName := rec."Journal Batch Name";
                   GenJnlManagement.OpenJnl(CurrentJnlBatchName,Rec);
                   SetControlAppearanceFromBatch;
                   EXIT;
                 END;
                 GenJnlManagement.TemplateSelection(PAGE::"Payment Journal",Enum::"Gen. Journal Template Type".FromInteger(4),FALSE,Rec,JnlSelected);
                 IF NOT JnlSelected THEN
                   ERROR('');
                 GenJnlManagement.OpenJnl(CurrentJnlBatchName,Rec);
                 SetControlAppearanceFromBatch;

                 vQuoSII := FunctionQB.AccessToQuoSII;
               
             TotalBalanceVisible := TRUE;
             BalanceVisible := TRUE;
             AmountVisible := TRUE;
           
end;

trigger OnAfterGetCurrRecord()    VAR
                           GenJournalBatch : Record 232;
                           WorkflowEventHandling : Codeunit 1520;
                           WorkflowManagement : Codeunit 1501;
                         BEGIN
                           StyleTxt := rec.GetOverdueDateInteractions(OverdueWarningText);
                           GenJnlManagement.GetAccounts(Rec,AccName,BalAccName);
                           UpdateBalance;
                           EnableApplyEntriesAction;
                           SetControlAppearance;
                           CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);

                           IF GenJournalBatch.GET(rec."Journal Template Name",rec."Journal Batch Name") THEN BEGIN
                             ShowWorkflowStatusOnBatch := CurrPage.WorkflowStatusBatch.PAGE.SetFilterOnWorkflowRecord(GenJournalBatch.RECORDID);
                             IsAllowPaymentExport := GenJournalBatch."Allow Payment Export";
                           END;
                           ShowWorkflowStatusOnLine := CurrPage.WorkflowStatusLine.PAGE.SetFilterOnWorkflowRecord(Rec.RECORDID);

                           EventFilter := WorkflowEventHandling.RunWorkflowOnSendGeneralJournalLineForApprovalCode;
                           EnabledApprovalWorkflowsExist := WorkflowManagement.EnabledWorkflowExist(DATABASE::"Gen. Journal Line",EventFilter);
                         END;


//trigger

var
      Text000 : TextConst ENU='Void Check %1?',ESP='¨Confirma que desea anular el cheque %1?';
      Text001 : TextConst ENU='Void all printed checks?',ESP='¨Confirma que desea anular todos los cheques impresos?';
      GeneratingPaymentsMsg : TextConst ENU='Generating Payment file...',ESP='Generando archivo de pago...';
      GenJnlLine : Record 81;
      GenJnlLine2 : Record 81;
      GenJnlManagement : Codeunit 230;
      ReportPrint : Codeunit 228;
      DocPrint : Codeunit 229;
      CheckManagement : Codeunit 367;
      ChangeExchangeRate : Page 511;
      GLReconcile : Page 345;
      CurrentJnlBatchName : Code[10];
      AccName : Text[50];
      BalAccName : Text[50];
      Balance : Decimal;
      TotalBalance : Decimal;
      ShowBalance : Boolean;
      ShowTotalBalance : Boolean;
      HasPmtFileErr : Boolean;
      ShortcutDimCode : ARRAY [8] OF Code[20];
      ApplyEntriesActionEnabled : Boolean;
      BalanceVisible : Boolean ;
      TotalBalanceVisible : Boolean ;
      StyleTxt : Text;
      OverdueWarningText : Text;
      EventFilter : Text;
      OpenApprovalEntriesExistForCurrUser : Boolean;
      OpenApprovalEntriesExistForCurrUserBatch : Boolean;
      OpenApprovalEntriesOnJnlBatchExist : Boolean;
      OpenApprovalEntriesOnJnlLineExist : Boolean;
      OpenApprovalEntriesOnBatchOrCurrJnlLineExist : Boolean;
      OpenApprovalEntriesOnBatchOrAnyJnlLineExist : Boolean;
      ShowWorkflowStatusOnBatch : Boolean;
      ShowWorkflowStatusOnLine : Boolean;
      CanCancelApprovalForJnlBatch : Boolean;
      CanCancelApprovalForJnlLine : Boolean;
      EnabledApprovalWorkflowsExist : Boolean;
      IsAllowPaymentExport : Boolean;
      IsSaasExcelAddinEnabled : Boolean;
      RecipientBankAccountMandatory : Boolean;
      CanRequestFlowApprovalForBatch : Boolean;
      CanRequestFlowApprovalForBatchAndAllLines : Boolean;
      CanRequestFlowApprovalForBatchAndCurrentLine : Boolean;
      CanCancelFlowApprovalForBatch : Boolean;
      CanCancelFlowApprovalForLine : Boolean;
      AmountVisible : Boolean;
      IsSaaS : Boolean;
      DebitCreditVisible : Boolean;
      "--------------------- QB" : Integer;
      FunctionQB : Codeunit 7207272;
      vQuoSII : Boolean;

    
    

//procedure
//Local procedure CheckForPmtJnlErrors();
//    var
//      BankAccount : Record 270;
//      BankExportImportSetup : Record 1200;
//    begin
//      if ( HasPmtFileErr  )then
//        if ( (rec."Bal. Account Type" = rec."Bal. Account Type"::"Bank Account") and BankAccount.GET(rec."Bal. Account No.")  )then
//          if ( BankExportImportSetup.GET(BankAccount."Payment Export Format")  )then
//            if ( BankExportImportSetup."Check Export Codeunit" > 0  )then
//              CODEUNIT.RUN(BankExportImportSetup."Check Export Codeunit",Rec);
//    end;
//Local procedure UpdateBalance();
//    begin
//      GenJnlManagement.CalcBalance(
//        Rec,xRec,Balance,TotalBalance,ShowBalance,ShowTotalBalance);
//      BalanceVisible := ShowBalance;
//      TotalBalanceVisible := ShowTotalBalance;
//    end;
Local procedure EnableApplyEntriesAction();
   begin
     ApplyEntriesActionEnabled :=
       (rec."Account Type" IN [rec."Account Type"::Customer,rec."Account Type"::Vendor]) or
       (rec."Bal. Account Type" IN [rec."Bal. Account Type"::Customer,rec."Bal. Account Type"::Vendor]);
   end;
//Local procedure CurrentJnlBatchNameOnAfterVali();
//    begin
//      CurrPage.SAVERECORD;
//      GenJnlManagement.SetName(CurrentJnlBatchName,Rec);
//      SetControlAppearanceFromBatch;
//      CurrPage.UPDATE(FALSE);
//    end;
//Local procedure GetCurrentlySelectedLines(var GenJournalLine : Record 81) : Boolean;
//    begin
//      CurrPage.SETSELECTIONFILTER(GenJournalLine);
//      exit(GenJournalLine.FINDSET);
//    end;
Local procedure SetControlAppearanceFromBatch();
   var
     GenJournalBatch : Record 232;
     ApprovalsMgmt : Codeunit 1535;
     WorkflowWebhookManagement : Codeunit 1543;
     CanRequestFlowApprovalForAllLines : Boolean;
   begin
     if ( (rec."Journal Template Name" <> '') and (rec."Journal Batch Name" <> '')  )then
       GenJournalBatch.GET(rec."Journal Template Name",rec."Journal Batch Name")
     ELSE
       if ( not GenJournalBatch.GET(Rec.GETRANGEMAX(rec."Journal Template Name"),CurrentJnlBatchName)  )then
         exit;

     CheckOpenApprovalEntries(GenJournalBatch.RECORDID);

     CanCancelApprovalForJnlBatch := ApprovalsMgmt.CanCancelApprovalForRecord(GenJournalBatch.RECORDID);

     WorkflowWebhookManagement.GetCanRequestAndCanCancelJournalBatch(
       GenJournalBatch,CanRequestFlowApprovalForBatch,CanCancelFlowApprovalForBatch,CanRequestFlowApprovalForAllLines);
     CanRequestFlowApprovalForBatchAndAllLines := CanRequestFlowApprovalForBatch and CanRequestFlowApprovalForAllLines;
   end;
Local procedure CheckOpenApprovalEntries(BatchRecordId : RecordID);
   var
     ApprovalsMgmt : Codeunit 1535;
   begin
     OpenApprovalEntriesExistForCurrUserBatch := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(BatchRecordId);

     OpenApprovalEntriesOnJnlBatchExist := ApprovalsMgmt.HasOpenApprovalEntries(BatchRecordId);

     OpenApprovalEntriesOnBatchOrAnyJnlLineExist :=
       OpenApprovalEntriesOnJnlBatchExist or
       ApprovalsMgmt.HasAnyOpenJournalLineApprovalEntries(rec."Journal Template Name",rec."Journal Batch Name");
   end;
Local procedure SetControlAppearance();
   var
     ApprovalsMgmt : Codeunit 1535;
     WorkflowWebhookManagement : Codeunit 1543;
     CanRequestFlowApprovalForLine : Boolean;
   begin
     OpenApprovalEntriesExistForCurrUser :=
       OpenApprovalEntriesExistForCurrUserBatch or ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RECORDID);

     OpenApprovalEntriesOnJnlLineExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RECORDID);
     OpenApprovalEntriesOnBatchOrCurrJnlLineExist := OpenApprovalEntriesOnJnlBatchExist or OpenApprovalEntriesOnJnlLineExist;

     CanCancelApprovalForJnlLine := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RECORDID);

     WorkflowWebhookManagement.GetCanRequestAndCanCancel(Rec.RECORDID,CanRequestFlowApprovalForLine,CanCancelFlowApprovalForLine);
     CanRequestFlowApprovalForBatchAndCurrentLine := CanRequestFlowApprovalForBatch and CanRequestFlowApprovalForLine;
   end;
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

