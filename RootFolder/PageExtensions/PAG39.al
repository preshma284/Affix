pageextension 50184 MyExtension39 extends 39//81
{
layout
{
addafter("Account No.")
{
    field("QB_AccountBalance";"AccountBalance")
    {
        
                CaptionML=ENU='Balance',ESP='Saldo';
                Visible=seeAccountBalance;
                Editable=false ;
}
} addafter("Description")
{
    field("Job No.";rec."Job No.")
    {
        
}
    field("Piecework Code";rec."Piecework Code")
    {
        
                Visible=seeQB ;
}
    field("Job Task No.";rec."Job Task No.")
    {
        
                Visible=seeNotQB ;
}
} addafter("VAT Prod. Posting Group")
{
    field("QB_PaymentBankNo";rec."QB Payment Bank No.")
    {
        
                
                            ;trigger OnValidate()    BEGIN
                             CurrPage.UPDATE;
                           END;


}
    field("QB_BankName";FunctionQB.GetBankName(rec."QB Payment Bank No."))
    {
        
                CaptionML=ENU='Bank Name',ESP='Nombre del banco';
                Enabled=false ;
}
} addafter("ShortcutDimCode8")
{
    field("Payment Method Code";rec."Payment Method Code")
    {
        
                Visible=FALSE ;
}
} addafter("Succeeded VAT Registration No.")
{
    field("QB_SourceType";rec."Source Type")
    {
        
                ApplicationArea=Basic,Suite;
}
    field("QB_SourceNo";rec."Source No.")
    {
        
                ApplicationArea=Basic,Suite;
}
    field("QB_DueDate";rec."Due Date")
    {
        
}
}


//modify("Account No.")
//{
//
//
//}
//
}

actions
{


}

//trigger
trigger OnOpenPage()    VAR
                 ServerConfigSettingHandler : Codeunit 6723;
                 PermissionManager : Codeunit 9002;
                 PermissionManager1 : Codeunit 51256; 
                 JnlSelected : Boolean;
                 LastGenJnlBatch : Code[10];
               BEGIN
                 //JAV 28/10/22: - QB 1.12.09 Agrupamos y posicionamos mejor los campos visibles en QB. Lo ponemos antes porque puede hacer un Exit la funci¢n
                 QB_SetVisibles;

                 IsSaasExcelAddinEnabled := ServerConfigSettingHandler.GetIsSaasExcelAddinEnabled;
                 IF ClientTypeManagement.GetCurrentClientType = CLIENTTYPE::ODataV4 THEN
                   EXIT;

                 BalAccName := '';
                 SetConrolVisibility;
                 IF rec.IsOpenedFromBatch THEN BEGIN
                   CurrentJnlBatchName := rec."Journal Batch Name";
                   GenJnlManagement.OpenJnl(CurrentJnlBatchName,Rec);
                   SetControlAppearanceFromBatch;
                   SetDataForSimpleModeOnOpen;
                   EXIT;
                 END;
                 GenJnlManagement.TemplateSelection(PAGE::"General Journal",ENUM::"Gen. Journal Template Type".FromInteger(0),FALSE,Rec,JnlSelected);
                 IF NOT JnlSelected THEN
                   ERROR('');

                 LastGenJnlBatch := GenJnlManagement.GetLastViewedJournalBatchName(PAGE::"General Journal");
                 IF LastGenJnlBatch <> '' THEN
                   CurrentJnlBatchName := LastGenJnlBatch;
                 GenJnlManagement.OpenJnl(CurrentJnlBatchName,Rec);
                 SetControlAppearanceFromBatch;

                 IsSaaS := PermissionManager1.SoftwareAsAService;
                 SetDataForSimpleModeOnOpen;
               END;
trigger OnAfterGetRecord()    BEGIN
                       GenJnlManagement.GetAccounts(Rec,AccName,BalAccName);
                       rec.ShowShortcutDimCode(ShortcutDimCode);
                       HasIncomingDocument := rec."Incoming Document Entry No." <> 0;
                       SetUserInteractions;

                       //JAV 16/06/21: - QB 1.08.48 Si puede ver el saldo lo calculamos
                       QB_GetAccountBalance;
                     END;
trigger OnAfterGetCurrRecord()    BEGIN
                           GenJnlManagement.GetAccounts(Rec,AccName,BalAccName);
                           IF ClientTypeManagement.GetCurrentClientType <> CLIENTTYPE::ODataV4 THEN
                             UpdateBalance;
                           EnableApplyEntriesAction;
                           SetControlAppearance;
                           // PostedFromSimplePage is set to TRUE when 'POST' / 'POST+PRINT' action is executed in simple page mode.
                           // It gets set to FALSE when OnNewRecord is called in the simple mode.
                           // After posting we try to find the first record and filter on its document number
                           // Executing LoaddataFromRecord for incomingDocAttachFactbox is also forcing this (PAG39) page to update
                           // and for some reason after posting this page doesn't refresh with the filter set by POST / POST-PRINT action in simple mode.
                           // To resolve this only call LoaddataFromRecord if PostedFromSimplePage is FALSE.
                           IF NOT PostedFromSimplePage THEN
                             CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);

                           //JAV 16/06/21: - QB 1.08.48 Si puede ver el saldo lo calculamos
                           QB_GetAccountBalance;
                         END;


//trigger

var
      GenJnlManagement : Codeunit 230;
      ReportPrint : Codeunit 228;
      PayrollManagement : Codeunit 1660;
      ClientTypeManagement : Codeunit 50192;
      NoSeriesMgt : Codeunit 396;
      ChangeExchangeRate : Page 511;
      GLReconcile : Page 345;
      CurrentJnlBatchName : Code[10];
      AccName : Text[100];
      BalAccName : Text[50];
      Balance : Decimal;
      TotalBalance : Decimal;
      ShowBalance : Boolean;
      ShowTotalBalance : Boolean;
      ShortcutDimCode : ARRAY [8] OF Code[20];
      Text000 : TextConst ENU='General Journal lines have been successfully inserted from Standard General Journal %1.',ESP='Las l¡neas del Diario general se insertaron correctamente desde el Diario general est ndar %1.';
      Text001 : TextConst ENU='Standard General Journal %1 has been successfully created.',ESP='El Diario general est ndar %1 se cre¢ correctamente.';
      HasIncomingDocument : Boolean;
      ApplyEntriesActionEnabled : Boolean;
      BalanceVisible : Boolean ;
      TotalBalanceVisible : Boolean ;
      StyleTxt : Text;
      OpenApprovalEntriesExistForCurrUser : Boolean;
      OpenApprovalEntriesOnJnlBatchExist : Boolean;
      OpenApprovalEntriesOnJnlLineExist : Boolean;
      OpenApprovalEntriesOnBatchOrCurrJnlLineExist : Boolean;
      OpenApprovalEntriesOnBatchOrAnyJnlLineExist : Boolean;
      ShowWorkflowStatusOnBatch : Boolean;
      ShowWorkflowStatusOnLine : Boolean;
      CanCancelApprovalForJnlBatch : Boolean;
      CanCancelApprovalForJnlLine : Boolean;
      ImportPayrollTransactionsAvailable : Boolean;
      IsSaasExcelAddinEnabled : Boolean;
      CanRequestFlowApprovalForBatch : Boolean;
      CanRequestFlowApprovalForBatchAndAllLines : Boolean;
      CanRequestFlowApprovalForBatchAndCurrentLine : Boolean;
      CanCancelFlowApprovalForBatch : Boolean;
      CanCancelFlowApprovalForLine : Boolean;
      AmountVisible : Boolean;
      DebitCreditVisible : Boolean;
      IsSaaS : Boolean;
      IsSimplePage : Boolean;
      CurrentDocNo : Code[20];
      CurrentPostingDate : Date;
      CurrentCurrencyCode : Code[10];
      IsChangingDocNo : Boolean;
      MissingExchangeRatesQst : TextConst ENU='There are no exchange rates for currency %1 and date %2. Do you want to add them now? Otherwise, the last change you made will be reverted.',ESP='No hay tipos de cambio para la divisa %1 y la fecha %2. ¨Desea agregarlos ahora? De lo contrario, se revertir  el £ltimo cambio que hizo.';
      PostedFromSimplePage : Boolean;
      "------------------------------------------------- QB" : Integer;
      UserSetup : Record 91;
      FunctionQB : Codeunit 7207272;
      AccountBalance : Decimal;
      seeAccountBalance : Boolean;
      seeQB : Boolean;
      seeNotQB : Boolean;
      "----------------------------------------------- Prorrata" : Integer;
      DPProrrataManagement : Codeunit 7174414;
      seeProrrata : Boolean;

    
    

//procedure
Local procedure UpdateBalance();
   begin
     GenJnlManagement.CalcBalance(Rec,xRec,Balance,TotalBalance,ShowBalance,ShowTotalBalance);
     BalanceVisible := ShowBalance;
     TotalBalanceVisible := ShowTotalBalance;
   end;
Local procedure EnableApplyEntriesAction();
   begin
     ApplyEntriesActionEnabled :=
       (rec."Account Type" IN [rec."Account Type"::Customer,rec."Account Type"::Vendor,rec."Account Type"::Employee]) or
       (rec."Bal. Account Type" IN [rec."Bal. Account Type"::Customer,rec."Bal. Account Type"::Vendor,rec."Bal. Account Type"::Employee]);
   end;
Local procedure CurrentJnlBatchNameOnAfterVali();
   begin
     CurrPage.SAVERECORD;
     GenJnlManagement.SetName(CurrentJnlBatchName,Rec);
     SetControlAppearanceFromBatch;
     CurrPage.UPDATE(FALSE);
   end;

   //[External]
procedure SetUserInteractions();
   begin
     StyleTxt := rec.GetStyle;
   end;
Local procedure GetCurrentlySelectedLines(var GenJournalLine : Record 81) : Boolean;
   begin
     CurrPage.SETSELECTIONFILTER(GenJournalLine);
     exit(GenJournalLine.FINDSET);
   end;
Local procedure SetControlAppearance();
   var
     ApprovalsMgmt : Codeunit 1535;
     WorkflowWebhookManagement : Codeunit 1543;
     CanRequestFlowApprovalForLine : Boolean;
   begin
     OpenApprovalEntriesExistForCurrUser :=
       OpenApprovalEntriesExistForCurrUser or
       ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RECORDID);

     OpenApprovalEntriesOnJnlLineExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RECORDID);
     OpenApprovalEntriesOnBatchOrCurrJnlLineExist := OpenApprovalEntriesOnJnlBatchExist or OpenApprovalEntriesOnJnlLineExist;

     ShowWorkflowStatusOnLine := CurrPage.WorkflowStatusLine.PAGE.SetFilterOnWorkflowRecord(Rec.RECORDID);

     CanCancelApprovalForJnlLine := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RECORDID);

     SetPayrollAppearance;

     WorkflowWebhookManagement.GetCanRequestAndCanCancel(Rec.RECORDID,CanRequestFlowApprovalForLine,CanCancelFlowApprovalForLine);
     CanRequestFlowApprovalForBatchAndCurrentLine := CanRequestFlowApprovalForBatch and CanRequestFlowApprovalForLine;
   end;
Local procedure IterateDocNumbers(FindTxt : Text;NextNum : Integer);
   var
     GenJournalLine : Record 81;
     CurrentDocNoWasFound : Boolean;
     NoLines : Boolean;
   begin
     if ( Rec.COUNT = 0  )then
       NoLines := TRUE;
     GenJournalLine.RESET;
     GenJournalLine.SETCURRENTKEY("Document No.","Line No.");
     GenJournalLine.SETRANGE("Journal Template Name",rec."Journal Template Name");
     GenJournalLine.SETRANGE("Journal Batch Name",rec."Journal Batch Name");
     // if ( GenJournalLine.FIND('+')  )then
     if ( GenJournalLine.FIND(FindTxt)  )then
       repeat
         if ( NoLines  )then begin
           SetDataForSimpleMode(GenJournalLine);
           exit;
         end;
         // Find the rec for current doc no.
         if ( not CurrentDocNoWasFound and (GenJournalLine."Document No." = CurrentDocNo)  )then
           CurrentDocNoWasFound := TRUE;
         if ( CurrentDocNoWasFound and (GenJournalLine."Document No." <> CurrentDocNo)  )then begin
           SetDataForSimpleMode(GenJournalLine);
           exit;
         end;
       until GenJournalLine.NEXT(NextNum) = 0;
   end;
Local procedure SetPayrollAppearance();
   var
     TempPayrollServiceConnection : Record 1400 TEMPORARY ;
   begin
     PayrollManagement.OnRegisterPayrollService(TempPayrollServiceConnection);
     ImportPayrollTransactionsAvailable := not TempPayrollServiceConnection.ISEMPTY;
   end;
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

     ShowWorkflowStatusOnBatch := CurrPage.WorkflowStatusBatch.PAGE.SetFilterOnWorkflowRecord(GenJournalBatch.RECORDID);
     OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(GenJournalBatch.RECORDID);
     OpenApprovalEntriesOnJnlBatchExist := ApprovalsMgmt.HasOpenApprovalEntries(GenJournalBatch.RECORDID);

     OpenApprovalEntriesOnBatchOrAnyJnlLineExist :=
       OpenApprovalEntriesOnJnlBatchExist or
       ApprovalsMgmt.HasAnyOpenJournalLineApprovalEntries(rec."Journal Template Name",rec."Journal Batch Name");

     CanCancelApprovalForJnlBatch := ApprovalsMgmt.CanCancelApprovalForRecord(GenJournalBatch.RECORDID);

     WorkflowWebhookManagement.GetCanRequestAndCanCancelJournalBatch(
       GenJournalBatch,CanRequestFlowApprovalForBatch,CanCancelFlowApprovalForBatch,CanRequestFlowApprovalForAllLines);
     CanRequestFlowApprovalForBatchAndAllLines := CanRequestFlowApprovalForBatch and CanRequestFlowApprovalForAllLines;
   end;
Local procedure SetConrolVisibility();
   var
     GLSetup : Record 98;
   begin
     GLSetup.GET;
     if ( IsSimplePage  )then begin
       AmountVisible := FALSE;
       DebitCreditVisible := TRUE;
     end ELSE begin
       AmountVisible := not (GLSetup."Show Amounts" = GLSetup."Show Amounts"::"Debit/Credit Only");
       DebitCreditVisible := not (GLSetup."Show Amounts" = GLSetup."Show Amounts"::"Amount Only");
     end;
   end;
Local procedure SetDocumentNumberFilter(DocNoToSet : Code[20]);
   var
     OriginalFilterGroup : Integer;
   begin
     OriginalFilterGroup := Rec.FILTERGROUP;
     Rec.FILTERGROUP := 25;
     Rec.SETFILTER("Document No.",DocNoToSet);
     Rec.FILTERGROUP := OriginalFilterGroup;
   end;
//Local procedure DisplayTotalDebit() : Decimal;
//    var
//      GenJournalLine : Record 81;
//      TotalDebitAmt : Decimal;
//    begin
//      if ( IsSimplePage  )then begin
//        CLEAR(TotalDebitAmt);
//        GenJournalLine.RESET;
//        GenJournalLine.SETRANGE("Journal Template Name",rec."Journal Template Name");
//        GenJournalLine.SETRANGE("Journal Batch Name",rec."Journal Batch Name");
//        GenJournalLine.SETRANGE("Document No.",CurrentDocNo);
//        if ( GenJournalLine.FIND('-')  )then
//          repeat
//            TotalDebitAmt := TotalDebitAmt + GenJournalLine."Debit Amount";
//          until GenJournalLine.NEXT = 0;
//        exit(TotalDebitAmt);
//      end
//    end;
//Local procedure DisplayTotalCredit() : Decimal;
//    var
//      GenJournalLine : Record 81;
//      TotalCreditAmt : Decimal;
//    begin
//      if ( IsSimplePage  )then begin
//        CLEAR(TotalCreditAmt);
//        GenJournalLine.RESET;
//        GenJournalLine.SETRANGE("Journal Template Name",rec."Journal Template Name");
//        GenJournalLine.SETRANGE("Journal Batch Name",rec."Journal Batch Name");
//        GenJournalLine.SETRANGE("Document No.",CurrentDocNo);
//        if ( GenJournalLine.FIND('-')  )then
//          repeat
//            TotalCreditAmt := TotalCreditAmt + GenJournalLine."Credit Amount";
//          until GenJournalLine.NEXT = 0;
//        exit(TotalCreditAmt);
//      end
//    end;
Local procedure SetDataForSimpleMode(GenJournalLine1 : Record 81);
   begin
     CurrentDocNo := GenJournalLine1."Document No.";
     CurrentPostingDate := GenJournalLine1."Posting Date";
     CurrentCurrencyCode := GenJournalLine1."Currency Code";
     SetDocumentNumberFilter(CurrentDocNo);
   end;
Local procedure SetDataForSimpleModeOnOpen();
   begin
     if ( IsSimplePage  )then begin
       // Filter on the first record
       Rec.SETCURRENTKEY("Document No.","Line No.");
       if ( Rec.FINDFIRST  )then
         SetDataForSimpleMode(Rec)
       ELSE begin
         // if no rec is found reset the currentposting date to workdate and currency code to empty
         CurrentPostingDate := WORKDATE;
         CLEAR(CurrentCurrencyCode);
       end;
     end;
   end;
//Local procedure SetDataForSimpleModeOnBatchChange();
//    var
//      GenJournalLine : Record 81;
//    begin
//      GenJnlManagement.SetLastViewedJournalBatchName(PAGE::"General Journal",CurrentJnlBatchName);
//      // Need to set up simple page mode properties on batch change
//      if ( IsSimplePage  )then begin
//        GenJournalLine.RESET;
//        GenJournalLine.SETRANGE("Journal Template Name",rec."Journal Template Name");
//        GenJournalLine.SETRANGE("Journal Batch Name",CurrentJnlBatchName);
//        IsChangingDocNo := FALSE;
//        if ( GenJournalLine.FINDFIRST  )then
//          SetDataForSimpleMode(GenJournalLine);
//      end;
//    end;
//Local procedure SetDataForSimpleModeOnNewRecord();
//    begin
//      // No lines shown
//      if ( Rec.COUNT = 0  )then
//        // if xrec."Document No." is empty that means this is the first entry for a batch
//        // In this case we want to assign current doc no. to the document no. of the record
//        // But if ( user changes the doc no.  )then we want to use whatever value they enter for
//        // current doc no.
//        if ( ((xRec."Document No." = '') or (xRec."Journal Batch Name" <> rec."Journal Batch Name")) and (not IsChangingDocNo)  )then
//          CurrentDocNo := rec."Document No."
//        ELSE begin
//          rec."Document No." := CurrentDocNo;
//          // Clear out credit / debit for empty page since these
//          // might have been set if suggest balance amount is checked on the batch
//          Rec.VALIDATE("Credit Amount",0);
//          Rec.VALIDATE("Debit Amount",0);
//        end
//      ELSE
//        rec."Document No." := CurrentDocNo;
//
//      rec."Currency Code" := CurrentCurrencyCode;
//      if ( CurrentPostingDate <> 0D  )then
//        Rec.VALIDATE("Posting Date",CurrentPostingDate);
//    end;
//Local procedure SetDataForSimpleModeOnPropValidation(FiledNumber : Integer);
//    var
//      GenJournalLine : Record 81;
//    begin
//      if ( IsSimplePage and (Rec.COUNT > 0)  )then begin
//        GenJournalLine.RESET;
//        GenJournalLine.SETRANGE("Journal Template Name",rec."Journal Template Name");
//        GenJournalLine.SETRANGE("Journal Batch Name",rec."Journal Batch Name");
//        GenJournalLine.SETRANGE("Document No.",CurrentDocNo);
//        if ( GenJournalLine.FIND('-')  )then
//          repeat
//            CASE FiledNumber OF
//              GenJournalLine.FIELDNO(rec."Currency Code"):
//                GenJournalLine.VALIDATE("Currency Code",CurrentCurrencyCode);
//              GenJournalLine.FIELDNO(rec."Posting Date"):
//                GenJournalLine.VALIDATE("Posting Date",CurrentPostingDate);
//            end;
//            GenJournalLine.MODIFY;
//          until GenJournalLine.NEXT = 0;
//      end;
//      CurrPage.UPDATE(FALSE);
//    end;
//Local procedure SetDataForSimpleModeOnPost();
//    begin
//      PostedFromSimplePage := TRUE;
//      Rec.SETCURRENTKEY("Document No.","Line No.");
//      if ( Rec.FINDFIRST  )then
//        SetDataForSimpleMode(Rec)
//    end;
//Local procedure UpdateCurrencyFactor(FieldNo : Integer);
//    var
//      UpdateCurrencyExchangeRates : Codeunit 1281;
//    begin
//      if ( CurrentCurrencyCode <> ''  )then
//        if ( UpdateCurrencyExchangeRates.ExchangeRatesForCurrencyExist(CurrentPostingDate,CurrentCurrencyCode)  )then
//          SetDataForSimpleModeOnPropValidation(FieldNo)
//        ELSE
//          if ( CONFIRM(STRSUBSTNO(MissingExchangeRatesQst,CurrentCurrencyCode,CurrentPostingDate))  )then begin
//            UpdateCurrencyExchangeRates.OpenExchangeRatesPage(CurrentCurrencyCode);
//            UpdateCurrencyFactor(FieldNo);
//          end ELSE begin
//            CurrentCurrencyCode := rec."Currency Code";
//            CurrentPostingDate := rec."Posting Date";
//          end
//      ELSE
//        SetDataForSimpleModeOnPropValidation(FieldNo);
//    end;
LOCAL procedure "----------------------------------------------- QB"();
    begin
    end;
LOCAL procedure QB_GetAccountBalance();
    var
      GLAccount : Record 15;
    begin
      AccountBalance := 0;
      if ( (seeAccountBalance) and (rec."Account Type" = rec."Account Type"::"G/L Account")  )then begin
        if ( (GLAccount.GET(rec."Account No."))  )then begin
          GLAccount.CALCFIELDS(Balance);
          AccountBalance := GLAccount.Balance;
        end;
      end;
    end;
LOCAL procedure QB_SetVisibles();
    begin
      //JAV 11/08/21: - QB 1.09.16 Campos visibles seg£n si est  activo o no QuoBuilding
      seeQB    := FunctionQB.AccessToQuobuilding;
      seeNotQB := not seeQB;

      //JAV 20/06/22: - DP 1.00.00 Se a¤aden los campos de la prorrata y su condici¢n de visibles
      seeProrrata := DPProrrataManagement.AccessToNonDeductible;

      //JAV 16/06/21: - QB 1.08.48 Si puede ver el saldo en el diario
      if ( UserSetup.GET(USERID)  )then
        seeAccountBalance := UserSetup."See Balance"
      ELSE
        seeAccountBalance := FALSE;
    end;

//procedure
}

