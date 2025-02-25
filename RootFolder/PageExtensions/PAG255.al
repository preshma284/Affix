pageextension 50161 MyExtension255 extends 255//81
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
    field("QB_Piecework Code";rec."Piecework Code")
    {
        
                Visible=FALSE ;
}
} addafter("Direct Debit Mandate ID")
{
    field("QuoSII Auto Posting Date";rec."QuoSII Auto Posting Date")
    {
        
                Visible=vQuoSII ;
}
    field("QuoSII Sales Invoice Type QS";rec."QuoSII Sales Invoice Type QS")
    {
        
                Visible=vQuoSII ;
}
    field("QuoSII Sales Cor. Invoice Type";rec."QuoSII Sales Cor. Invoice Type")
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
    field("QuoSII Sales UE Inv Type";rec."QuoSII Sales UE Inv Type")
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
    field("QuoSII Payment Cash SII";rec."QuoSII Payment Cash SII")
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
    field("QB_PaymentMethodCode";rec."Payment Method Code")
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
                 PermissionManager : Codeunit 51256; //changed from 9002
                 JnlSelected : Boolean;
               BEGIN
                 IsSaasExcelAddinEnabled := ServerConfigSettingHandler.GetIsSaasExcelAddinEnabled;
                 IsSaaS := PermissionManager.SoftwareAsAService;
                 IF ClientTypeManagement.GetCurrentClientType = CLIENTTYPE::ODataV4 THEN
                   EXIT;

                 SetConrolVisibility;
                 BalAccName := '';
                 IF rec.IsOpenedFromBatch THEN BEGIN
                   CurrentJnlBatchName := rec."Journal Batch Name";
                   GenJnlManagement.OpenJnl(CurrentJnlBatchName,Rec);
                   SetControlAppearanceFromBatch;
                   EXIT;
                 END;
                 GenJnlManagement.TemplateSelection(PAGE::"Cash Receipt Journal",Enum::"Gen. Journal Template Type".FromInteger(3),FALSE,Rec,JnlSelected);
                 IF NOT JnlSelected THEN
                   ERROR('');
                 GenJnlManagement.OpenJnl(CurrentJnlBatchName,Rec);
                 SetControlAppearanceFromBatch;

                 vQuoSII := FunctionQB.AccessToQuoSII;
               END;


//trigger

var
      GenJnlManagement : Codeunit 230;
      ReportPrint : Codeunit 228;
      ClientTypeManagement : Codeunit 50192; //changed from 4
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
      IsSaasExcelAddinEnabled : Boolean;
      CanRequestFlowApprovalForBatch : Boolean;
      CanRequestFlowApprovalForBatchAndAllLines : Boolean;
      CanRequestFlowApprovalForBatchAndCurrentLine : Boolean;
      CanCancelFlowApprovalForBatch : Boolean;
      CanCancelFlowApprovalForLine : Boolean;
      AmountVisible : Boolean;
      DebitCreditVisible : Boolean;
      IsSaaS : Boolean;
      "--------------------- QB" : Integer;
      FunctionQB : Codeunit 7207272;
      vQuoSII : Boolean;

    
    

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
Local procedure CurrentJnlBatchNameOnAfterVali();
   begin
     CurrPage.SAVERECORD;
     GenJnlManagement.SetName(CurrentJnlBatchName,Rec);
     SetControlAppearanceFromBatch;
     CurrPage.UPDATE(FALSE);
   end;
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
//Local procedure SetControlAppearance();
//    var
//      ApprovalsMgmt : Codeunit 1535;
//      WorkflowWebhookManagement : Codeunit 1543;
//      CanRequestFlowApprovalForLine : Boolean;
//    begin
//      OpenApprovalEntriesExistForCurrUser :=
//        OpenApprovalEntriesExistForCurrUserBatch or ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RECORDID);
//
//      OpenApprovalEntriesOnJnlLineExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RECORDID);
//      OpenApprovalEntriesOnBatchOrCurrJnlLineExist := OpenApprovalEntriesOnJnlBatchExist or OpenApprovalEntriesOnJnlLineExist;
//
//      CanCancelApprovalForJnlLine := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RECORDID);
//
//      WorkflowWebhookManagement.GetCanRequestAndCanCancel(Rec.RECORDID,CanRequestFlowApprovalForLine,CanCancelFlowApprovalForLine);
//      CanRequestFlowApprovalForBatchAndCurrentLine := CanRequestFlowApprovalForBatch and CanRequestFlowApprovalForLine;
//    end;
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

