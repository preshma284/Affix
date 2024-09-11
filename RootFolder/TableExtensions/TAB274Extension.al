tableextension 50162 "MyExtension50162" extends "Bank Acc. Reconciliation Line"
{
  
  /*
Permissions=TableData 1221 rimd;
*/
    CaptionML=ENU='Bank Acc. Reconciliation Line',ESP='L¡n. conciliaci¢n banco';
  
  fields
{
    field(50001;"Concepto Interbancario";Code[2])
    {
        TableRelation="N43 Conceptos Interbancarios";
                                                   DataClassification=ToBeClassified;
                                                   Description='QB 1.06.14 JAV 15/09/20: - Cargado desde N43';
                                                   Editable=false;


    }
    field(50002;"Descripcion conc. interbanc.";Text[60])
    {
        FieldClass=FlowField;
                                                   CalcFormula=Lookup("N43 Conceptos Interbancarios"."Descripcion" WHERE ("Codigo"=FIELD("Concepto Interbancario")));
                                                   Description='QB 1.06.14 JAV 15/09/20: - Cargado desde N43';
                                                   Editable=false;


    }
    field(50003;"Description 2";Text[50])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Descripci¢n 2';
                                                   Description='QB 1.06.14 JAV 15/09/20: - Cargado desde N43';
                                                   Editable=false ;


    }
}
  keys
{
   // key(key1;"Account Type","Statement Amount")
  //  {
       /* ;
 */
   // }
}
  fieldgroups
{
}
  
    var
//       Text000@1000 :
      Text000: TextConst ENU='You cannot rename a %1.',ESP='No se puede cambiar el nombre a %1.';
//       Text001@1001 :
      Text001: TextConst ENU='Delete application?',ESP='¨Confirma que desea eliminar la conciliaci¢n?';
//       Text002@1002 :
      Text002: TextConst ENU='Update canceled.',ESP='Actualizaci¢n cancelada.';
//       BankAccLedgEntry@1003 :
      BankAccLedgEntry: Record 271;
//       CheckLedgEntry@1004 :
      CheckLedgEntry: Record 272;
//       BankAccRecon@1005 :
      BankAccRecon: Record 273;
//       BankAccSetStmtNo@1006 :
      BankAccSetStmtNo: Codeunit 375;
//       CheckSetStmtNo@1007 :
      CheckSetStmtNo: Codeunit 376;
//       DimMgt@1009 :
      DimMgt: Codeunit 408;
//       ConfirmManagement@1016 :
      ConfirmManagement: Codeunit 27;
//       AmountWithinToleranceRangeTok@1011 :
      AmountWithinToleranceRangeTok: 
// {Locked}
TextConst ENU='>=%1&<=%2',ESP='>=%1&<=%2';
//       AmountOustideToleranceRangeTok@1012 :
      AmountOustideToleranceRangeTok: 
// {Locked}
TextConst ENU='<%1|>%2',ESP='<%1|>%2';
//       TransactionAmountMustNotBeZeroErr@1008 :
      TransactionAmountMustNotBeZeroErr: TextConst ENU='The Transaction Amount field must have a value that is not 0.',ESP='El campo Importe de la transacci¢n debe tener un valor que no sea 0.';
//       CreditTheAccountQst@1013 :
      CreditTheAccountQst: 
// %1 is the account name, %2 is the amount that is not applied (there is filed on the page named Remaining Amount To Apply)
TextConst ENU='The remaining amount to apply is %2.\\Do you want to create a new payment application line that will debit or credit %1 with the remaining amount when you post the payment?',ESP='El Importe pendiente de liquidaci¢n es %2.\\¨Quiere crear una nueva l¡nea de liquidaci¢n de pago que debitar  o acreditar  en %1 el importe pendiente cuando registre el pago?';
//       ExcessiveAmountErr@1010 :
      ExcessiveAmountErr: 
// %1 is the amount that is not applied (there is filed on the page named Remaining Amount To Apply)
TextConst ENU='The remaining amount to apply is %1.',ESP='El importe pendiente de liquidaci¢n es %1.';
//       ImportPostedTransactionsQst@1014 :
      ImportPostedTransactionsQst: TextConst ENU='The bank statement contains payments that are already applied, but the related bank account ledger entries are not closed.\\Do you want to include these payments in the import?',ESP='El extracto bancario contiene pagos ya liquidados, pero los movimientos de banco relacionados no est n cerrados.\\¨Quiere incluir estos pagos en la importaci¢n?';
//       ICPartnerAccountTypeQst@1015 :
      ICPartnerAccountTypeQst: TextConst ENU='The resulting entry will be of type IC Transaction, but no Intercompany Outbox transaction will be created. \\Do you want to use the IC Partner account type anyway?',ESP='El movimiento resultante ser  del tipo transacci¢n IC, pero no se crear  ninguna transacci¢n de bandeja de salida entre empresas vinculadas. \\¨Desea usar el tipo de cuenta de socio IC de todas maneras?';

    
    


/*
trigger OnInsert();    begin
               BankAccRecon.GET("Statement Type","Bank Account No.","Statement No.");
               "Applied Entries" := 0;
               VALIDATE("Applied Amount",0);
             end;


*/

/*
trigger OnModify();    begin
               if xRec."Statement Amount" <> "Statement Amount" then
                 RemoveApplication(Type);
             end;


*/

/*
trigger OnDelete();    begin
               RemoveApplication(Type);
               ClearDataExchEntries;
               RemoveAppliedPaymentEntries;
               DeletePaymentMatchingDetails;
               UpdateParentLineStatementAmount;
               if FIND then;
             end;


*/

/*
trigger OnRename();    begin
               ERROR(Text000,TABLECAPTION);
             end;

*/




/*
procedure DisplayApplication ()
    var
//       PaymentApplication@1000 :
      PaymentApplication: Page 1292;
    begin
      CASE "Statement Type" OF
        "Statement Type"::"Bank Reconciliation":
          CASE Type OF
            Type::"Bank Account Ledger Entry":
              begin
                BankAccLedgEntry.RESET;
                BankAccLedgEntry.SETCURRENTKEY("Bank Account No.",Open);
                BankAccLedgEntry.SETRANGE("Bank Account No.","Bank Account No.");
                BankAccLedgEntry.SETRANGE(Open,TRUE);
                BankAccLedgEntry.SETRANGE(
                  "Statement Status",BankAccLedgEntry."Statement Status"::"Bank Acc. Entry Applied");
                BankAccLedgEntry.SETRANGE("Statement No.","Statement No.");
                BankAccLedgEntry.SETRANGE("Statement Line No.","Statement Line No.");
                PAGE.RUN(0,BankAccLedgEntry);
              end;
            Type::"Check Ledger Entry":
              begin
                CheckLedgEntry.RESET;
                CheckLedgEntry.SETCURRENTKEY("Bank Account No.",Open);
                CheckLedgEntry.SETRANGE("Bank Account No.","Bank Account No.");
                CheckLedgEntry.SETRANGE(Open,TRUE);
                CheckLedgEntry.SETRANGE(
                  "Statement Status",CheckLedgEntry."Statement Status"::"Check Entry Applied");
                CheckLedgEntry.SETRANGE("Statement No.","Statement No.");
                CheckLedgEntry.SETRANGE("Statement Line No.","Statement Line No.");
                PAGE.RUN(0,CheckLedgEntry);
              end;
          end;
        "Statement Type"::"Payment Application":
          begin
            if "Statement Amount" = 0 then
              ERROR(TransactionAmountMustNotBeZeroErr);
            PaymentApplication.SetBankAccReconcLine(Rec);
            PaymentApplication.RUNMODAL;
          end;
      end;
    end;
*/


    
    
/*
procedure GetCurrencyCode () : Code[10];
    var
//       BankAcc@1000 :
      BankAcc: Record 270;
    begin
      if "Bank Account No." = BankAcc."No." then
        exit(BankAcc."Currency Code");

      if BankAcc.GET("Bank Account No.") then
        exit(BankAcc."Currency Code");

      exit('');
    end;
*/


    
    
/*
procedure GetStyle () : Text;
    begin
      if "Applied Entries" <> 0 then
        exit('Favorable');

      exit('');
    end;
*/


    
    
/*
procedure ClearDataExchEntries ()
    var
//       DataExchField@1000 :
      DataExchField: Record 1221;
//       BankAccReconciliationLine@1001 :
      BankAccReconciliationLine: Record 274;
    begin
      DataExchField.DeleteRelatedRecords("Data Exch. Entry No.","Data Exch. Line No.");

      BankAccReconciliationLine.SETRANGE("Statement Type","Statement Type");
      BankAccReconciliationLine.SETRANGE("Bank Account No.","Bank Account No.");
      BankAccReconciliationLine.SETRANGE("Statement No.","Statement No.");
      BankAccReconciliationLine.SETRANGE("Data Exch. Entry No.","Data Exch. Entry No.");
      BankAccReconciliationLine.SETFILTER("Statement Line No.",'<>%1',"Statement Line No.");
      if BankAccReconciliationLine.ISEMPTY then
        DataExchField.DeleteRelatedRecords("Data Exch. Entry No.",0);
    end;
*/


    
    
/*
procedure ShowDimensions ()
    begin
      "Dimension Set ID" :=
        DimMgt.EditDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2 %3',TABLECAPTION,"Statement No.","Statement Line No."));
      DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
    end;
*/


    
//     procedure CreateDim (Type1@1000 : Integer;No1@1001 : Code[20];Type2@1007 : Integer;No2@1006 :
    
/*
procedure CreateDim (Type1: Integer;No1: Code[20];Type2: Integer;No2: Code[20])
    var
//       SourceCodeSetup@1002 :
      SourceCodeSetup: Record 242;
//       BankAccReconciliation@1005 :
      BankAccReconciliation: Record 273;
//       TableID@1003 :
      TableID: ARRAY [10] OF Integer;
//       No@1004 :
      No: ARRAY [10] OF Code[20];
    begin
      SourceCodeSetup.GET;
      TableID[1] := Type1;
      No[1] := No1;
      TableID[2] := Type2;
      No[2] := No2;
      OnAfterCreateDimTableIDs(Rec,CurrFieldNo,TableID,No);

      "Shortcut Dimension 1 Code" := '';
      "Shortcut Dimension 2 Code" := '';
      BankAccReconciliation.GET("Statement Type","Bank Account No.","Statement No.");
      "Dimension Set ID" :=
        DimMgt.GetRecDefaultDimID(
          Rec,CurrFieldNo,TableID,No,SourceCodeSetup."Payment Reconciliation Journal",
          "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code",BankAccReconciliation."Dimension Set ID",DATABASE::"Bank Account");
    end;
*/


    
    
/*
procedure SetUpNewLine ()
    begin
      "Transaction Date" := WORKDATE;
      "Match Confidence" := "Match Confidence"::None;
      "Document No." := '';
    end;
*/


    
//     procedure ValidateShortcutDimCode (FieldNumber@1000 : Integer;var ShortcutDimCode@1001 :
    
/*
procedure ValidateShortcutDimCode (FieldNumber: Integer;var ShortcutDimCode: Code[20])
    begin
      DimMgt.ValidateShortcutDimValues(FieldNumber,ShortcutDimCode,"Dimension Set ID");
    end;
*/


    
//     procedure ShowShortcutDimCode (var ShortcutDimCode@1000 :
    
/*
procedure ShowShortcutDimCode (var ShortcutDimCode: ARRAY [8] OF Code[20])
    begin
      DimMgt.GetShortcutDimensions("Dimension Set ID",ShortcutDimCode);
    end;
*/


    
    
/*
procedure AcceptAppliedPaymentEntriesSelectedLines ()
    begin
      if FINDSET then
        repeat
          AcceptApplication;
        until NEXT = 0;
    end;
*/


    
    
/*
procedure RejectAppliedPaymentEntriesSelectedLines ()
    begin
      if FINDSET then
        repeat
          RejectAppliedPayment;
        until NEXT = 0;
    end;
*/


    
    
/*
procedure RejectAppliedPayment ()
    begin
      RemoveAppliedPaymentEntries;
      DeletePaymentMatchingDetails;
    end;
*/


    
    
/*
procedure AcceptApplication ()
    var
//       AppliedPaymentEntry@1000 :
      AppliedPaymentEntry: Record 1294;
    begin
      // For customer payments, the applied amount is positive, so positive difference means excessive amount.
      // For vendor payments, the applied amount is negative, so negative difference means excessive amount.
      // if "Applied Amount" and Difference have the same sign, then this is an overpayment situation.
      // Two non-zero numbers have the same sign if and only if their product is a positive number.
      if Difference * "Applied Amount" > 0 then begin
        if "Account Type" = "Account Type"::"Bank Account" then
          ERROR(ExcessiveAmountErr,Difference);
        SetAppliedPaymentEntryFromRec(AppliedPaymentEntry);
        if not AppliedPaymentEntry.FIND then begin
          if not CONFIRM(STRSUBSTNO(CreditTheAccountQst,GetAppliedToName,Difference)) then
            exit;
          TransferRemainingAmountToAccount;
        end;
      end;

      AppliedPaymentEntry.FilterAppliedPmtEntry(Rec);
      AppliedPaymentEntry.MODIFYALL("Match Confidence","Match Confidence"::Accepted);
    end;
*/


//     LOCAL procedure RemoveApplication (AppliedType@1000 :
    
/*
LOCAL procedure RemoveApplication (AppliedType: Option)
    begin
      if "Statement Type" = "Statement Type"::"Bank Reconciliation" then
        CASE AppliedType OF
          Type::"Bank Account Ledger Entry":
            begin
              BankAccLedgEntry.RESET;
              BankAccLedgEntry.SETCURRENTKEY("Bank Account No.",Open);
              BankAccLedgEntry.SETRANGE("Bank Account No.","Bank Account No.");
              BankAccLedgEntry.SETRANGE(Open,TRUE);
              BankAccLedgEntry.SETRANGE(
                "Statement Status",BankAccLedgEntry."Statement Status"::"Bank Acc. Entry Applied");
              BankAccLedgEntry.SETRANGE("Statement No.","Statement No.");
              BankAccLedgEntry.SETRANGE("Statement Line No.","Statement Line No.");
              BankAccLedgEntry.LOCKTABLE;
              CheckLedgEntry.LOCKTABLE;
              if BankAccLedgEntry.FIND('-') then
                repeat
                  BankAccSetStmtNo.RemoveReconNo(BankAccLedgEntry,Rec,TRUE);
                until BankAccLedgEntry.NEXT = 0;
              "Applied Entries" := 0;
              VALIDATE("Applied Amount",0);
              MODIFY;
            end;
          Type::"Check Ledger Entry":
            begin
              CheckLedgEntry.RESET;
              CheckLedgEntry.SETCURRENTKEY("Bank Account No.",Open);
              CheckLedgEntry.SETRANGE("Bank Account No.","Bank Account No.");
              CheckLedgEntry.SETRANGE(Open,TRUE);
              CheckLedgEntry.SETRANGE(
                "Statement Status",CheckLedgEntry."Statement Status"::"Check Entry Applied");
              CheckLedgEntry.SETRANGE("Statement No.","Statement No.");
              CheckLedgEntry.SETRANGE("Statement Line No.","Statement Line No.");
              BankAccLedgEntry.LOCKTABLE;
              CheckLedgEntry.LOCKTABLE;
              if CheckLedgEntry.FIND('-') then
                repeat
                  CheckSetStmtNo.RemoveReconNo(CheckLedgEntry,Rec,TRUE);
                until CheckLedgEntry.NEXT = 0;
              "Applied Entries" := 0;
              VALIDATE("Applied Amount",0);
              "Check No." := '';
              MODIFY;
            end;
        end;
    end;
*/


    
    
/*
procedure SetManualApplication ()
    var
//       AppliedPaymentEntry@1000 :
      AppliedPaymentEntry: Record 1294;
    begin
      AppliedPaymentEntry.FilterAppliedPmtEntry(Rec);
      AppliedPaymentEntry.MODIFYALL("Match Confidence","Match Confidence"::Manual)
    end;
*/


    
/*
LOCAL procedure RemoveAppliedPaymentEntries ()
    var
//       AppliedPmtEntry@1000 :
      AppliedPmtEntry: Record 1294;
    begin
      VALIDATE("Applied Amount",0);
      VALIDATE("Applied Entries",0);
      VALIDATE("Account No.",'');
      MODIFY(TRUE);

      AppliedPmtEntry.FilterAppliedPmtEntry(Rec);
      AppliedPmtEntry.DELETEALL(TRUE);
    end;
*/


    
/*
LOCAL procedure DeletePaymentMatchingDetails ()
    var
//       PaymentMatchingDetails@1000 :
      PaymentMatchingDetails: Record 1299;
    begin
      PaymentMatchingDetails.SETRANGE("Statement Type","Statement Type");
      PaymentMatchingDetails.SETRANGE("Bank Account No.","Bank Account No.");
      PaymentMatchingDetails.SETRANGE("Statement No.","Statement No.");
      PaymentMatchingDetails.SETRANGE("Statement Line No.","Statement Line No.");
      PaymentMatchingDetails.DELETEALL(TRUE);
    end;
*/


    
//     procedure GetAppliedEntryAccountName (AppliedToEntryNo@1000 :
    
/*
procedure GetAppliedEntryAccountName (AppliedToEntryNo: Integer) : Text;
    var
//       AccountType@1005 :
      AccountType: Option;
//       AccountNo@1006 :
      AccountNo: Code[20];
    begin
      AccountType := GetAppliedEntryAccountType(AppliedToEntryNo);
      AccountNo := GetAppliedEntryAccountNo(AppliedToEntryNo);
      exit(GetAccountName(AccountType,AccountNo));
    end;
*/


    
    
/*
procedure GetAppliedToName () : Text;
    var
//       AccountType@1005 :
      AccountType: Option;
//       AccountNo@1006 :
      AccountNo: Code[20];
    begin
      AccountType := GetAppliedToAccountType;
      AccountNo := GetAppliedToAccountNo;
      exit(GetAccountName(AccountType,AccountNo));
    end;
*/


    
//     procedure GetAppliedEntryAccountType (AppliedToEntryNo@1000 :
    
/*
procedure GetAppliedEntryAccountType (AppliedToEntryNo: Integer) : Integer;
    var
//       BankAccountLedgerEntry@1003 :
      BankAccountLedgerEntry: Record 271;
    begin
      if "Account Type" = "Account Type"::"Bank Account" then
        if BankAccountLedgerEntry.GET(AppliedToEntryNo) then
          exit(BankAccountLedgerEntry."Bal. Account Type");
      exit("Account Type");
    end;
*/


    
    
/*
procedure GetAppliedToAccountType () : Integer;
    var
//       BankAccountLedgerEntry@1003 :
      BankAccountLedgerEntry: Record 271;
    begin
      if "Account Type" = "Account Type"::"Bank Account" then
        if BankAccountLedgerEntry.GET(GetFirstAppliedToEntryNo) then
          exit(BankAccountLedgerEntry."Bal. Account Type");
      exit("Account Type");
    end;
*/


    
//     procedure GetAppliedEntryAccountNo (AppliedToEntryNo@1000 :
    
/*
procedure GetAppliedEntryAccountNo (AppliedToEntryNo: Integer) : Code[20];
    var
//       CustLedgerEntry@1001 :
      CustLedgerEntry: Record 21;
//       VendorLedgerEntry@1002 :
      VendorLedgerEntry: Record 25;
//       BankAccountLedgerEntry@1003 :
      BankAccountLedgerEntry: Record 271;
    begin
      CASE "Account Type" OF
        "Account Type"::Customer:
          if CustLedgerEntry.GET(AppliedToEntryNo) then
            exit(CustLedgerEntry."Customer No.");
        "Account Type"::Vendor:
          if VendorLedgerEntry.GET(AppliedToEntryNo) then
            exit(VendorLedgerEntry."Vendor No.");
        "Account Type"::"Bank Account":
          if BankAccountLedgerEntry.GET(AppliedToEntryNo) then
            exit(BankAccountLedgerEntry."Bal. Account No.");
      end;
      exit("Account No.");
    end;
*/


    
    
/*
procedure GetAppliedToAccountNo () : Code[20];
    var
//       BankAccountLedgerEntry@1004 :
      BankAccountLedgerEntry: Record 271;
    begin
      if "Account Type" = "Account Type"::"Bank Account" then
        if BankAccountLedgerEntry.GET(GetFirstAppliedToEntryNo) then
          exit(BankAccountLedgerEntry."Bal. Account No.");
      exit("Account No.")
    end;
*/


//     LOCAL procedure GetAccountName (AccountType@1000 : Option;AccountNo@1001 :
    
/*
LOCAL procedure GetAccountName (AccountType: Option;AccountNo: Code[20]) : Text;
    var
//       Customer@1005 :
      Customer: Record 18;
//       Vendor@1004 :
      Vendor: Record 23;
//       GLAccount@1003 :
      GLAccount: Record 15;
//       BankAccount@1002 :
      BankAccount: Record 270;
//       Name@1006 :
      Name: Text;
    begin
      CASE AccountType OF
        "Account Type"::Customer:
          if Customer.GET(AccountNo) then
            Name := Customer.Name;
        "Account Type"::Vendor:
          if Vendor.GET(AccountNo) then
            Name := Vendor.Name;
        "Account Type"::"G/L Account":
          if GLAccount.GET(AccountNo) then
            Name := GLAccount.Name;
        "Account Type"::"Bank Account":
          if BankAccount.GET(AccountNo) then
            Name := BankAccount.Name;
      end;

      exit(Name);
    end;
*/


//     LOCAL procedure SetAppliedPaymentEntryFromRec (var AppliedPaymentEntry@1000 :
    
/*
LOCAL procedure SetAppliedPaymentEntryFromRec (var AppliedPaymentEntry: Record 1294)
    begin
      AppliedPaymentEntry.TransferFromBankAccReconLine(Rec);
      AppliedPaymentEntry."Account Type" := GetAppliedToAccountType;
      AppliedPaymentEntry."Account No." := GetAppliedToAccountNo;
    end;
*/


    
//     procedure AppliedEntryAccountDrillDown (AppliedEntryNo@1000 :
    
/*
procedure AppliedEntryAccountDrillDown (AppliedEntryNo: Integer)
    var
//       AccountType@1004 :
      AccountType: Option;
//       AccountNo@1003 :
      AccountNo: Code[20];
    begin
      AccountType := GetAppliedEntryAccountType(AppliedEntryNo);
      AccountNo := GetAppliedEntryAccountNo(AppliedEntryNo);
      OpenAccountPage(AccountType,AccountNo);
    end;
*/


    
    
/*
procedure AppliedToDrillDown ()
    var
//       AccountType@1004 :
      AccountType: Option;
//       AccountNo@1003 :
      AccountNo: Code[20];
    begin
      AccountType := GetAppliedToAccountType;
      AccountNo := GetAppliedToAccountNo;
      OpenAccountPage(AccountType,AccountNo);
    end;
*/


//     LOCAL procedure OpenAccountPage (AccountType@1006 : Option;AccountNo@1007 :
    
/*
LOCAL procedure OpenAccountPage (AccountType: Option;AccountNo: Code[20])
    var
//       Customer@1002 :
      Customer: Record 18;
//       Vendor@1001 :
      Vendor: Record 23;
//       GLAccount@1000 :
      GLAccount: Record 15;
//       BankAccount@1005 :
      BankAccount: Record 270;
    begin
      CASE AccountType OF
        "Account Type"::Customer:
          begin
            Customer.GET(AccountNo);
            PAGE.RUN(PAGE::"Customer Card",Customer);
          end;
        "Account Type"::Vendor:
          begin
            Vendor.GET(AccountNo);
            PAGE.RUN(PAGE::"Vendor Card",Vendor);
          end;
        "Account Type"::"G/L Account":
          begin
            GLAccount.GET(AccountNo);
            PAGE.RUN(PAGE::"G/L Account Card",GLAccount);
          end;
        "Account Type"::"Bank Account":
          begin
            BankAccount.GET(AccountNo);
            PAGE.RUN(PAGE::"Bank Account Card",BankAccount);
          end;
      end;
    end;
*/


    
    
/*
procedure DrillDownOnNoOfLedgerEntriesWithinAmountTolerance ()
    begin
      DrillDownOnNoOfLedgerEntriesBasedOnAmount(AmountWithinToleranceRangeTok);
    end;
*/


    
    
/*
procedure DrillDownOnNoOfLedgerEntriesOutsideOfAmountTolerance ()
    begin
      DrillDownOnNoOfLedgerEntriesBasedOnAmount(AmountOustideToleranceRangeTok);
    end;
*/


//     LOCAL procedure DrillDownOnNoOfLedgerEntriesBasedOnAmount (AmountFilter@1005 :
    
/*
LOCAL procedure DrillDownOnNoOfLedgerEntriesBasedOnAmount (AmountFilter: Text)
    var
//       CustLedgerEntry@1003 :
      CustLedgerEntry: Record 21;
//       VendorLedgerEntry@1004 :
      VendorLedgerEntry: Record 25;
//       BankAccountLedgerEntry@1000 :
      BankAccountLedgerEntry: Record 271;
//       MinAmount@1001 :
      MinAmount: Decimal;
//       MaxAmount@1002 :
      MaxAmount: Decimal;
    begin
      GetAmountRangeForTolerance(MinAmount,MaxAmount);

      CASE "Account Type" OF
        "Account Type"::Customer:
          begin
            GetCustomerLedgerEntriesInAmountRange(CustLedgerEntry,"Account No.",AmountFilter,MinAmount,MaxAmount);
            PAGE.RUN(PAGE::"Customer Ledger Entries",CustLedgerEntry);
          end;
        "Account Type"::Vendor:
          begin
            GetVendorLedgerEntriesInAmountRange(VendorLedgerEntry,"Account No.",AmountFilter,MinAmount,MaxAmount);
            PAGE.RUN(PAGE::"Vendor Ledger Entries",VendorLedgerEntry);
          end;
        "Account Type"::"Bank Account":
          begin
            GetBankAccountLedgerEntriesInAmountRange(BankAccountLedgerEntry,AmountFilter,MinAmount,MaxAmount);
            PAGE.RUN(PAGE::"Bank Account Ledger Entries",BankAccountLedgerEntry);
          end;
      end;
    end;
*/


//     LOCAL procedure GetCustomerLedgerEntriesInAmountRange (var CustLedgerEntry@1004 : Record 21;AccountNo@1005 : Code[20];AmountFilter@1001 : Text;MinAmount@1002 : Decimal;MaxAmount@1003 :
    
/*
LOCAL procedure GetCustomerLedgerEntriesInAmountRange (var CustLedgerEntry: Record 21;AccountNo: Code[20];AmountFilter: Text;MinAmount: Decimal;MaxAmount: Decimal) : Integer;
    var
//       BankAccount@1000 :
      BankAccount: Record 270;
    begin
      CustLedgerEntry.SETAUTOCALCFIELDS("Remaining Amount","Remaining Amt. (LCY)");
      BankAccount.GET("Bank Account No.");
      GetApplicableCustomerLedgerEntries(CustLedgerEntry,BankAccount."Currency Code",AccountNo);

      if BankAccount.IsInLocalCurrency then
        CustLedgerEntry.SETFILTER("Remaining Amt. (LCY)",AmountFilter,MinAmount,MaxAmount)
      else
        CustLedgerEntry.SETFILTER("Remaining Amount",AmountFilter,MinAmount,MaxAmount);

      exit(CustLedgerEntry.COUNT);
    end;
*/


//     LOCAL procedure GetVendorLedgerEntriesInAmountRange (var VendorLedgerEntry@1004 : Record 25;AccountNo@1005 : Code[20];AmountFilter@1002 : Text;MinAmount@1001 : Decimal;MaxAmount@1000 :
    
/*
LOCAL procedure GetVendorLedgerEntriesInAmountRange (var VendorLedgerEntry: Record 25;AccountNo: Code[20];AmountFilter: Text;MinAmount: Decimal;MaxAmount: Decimal) : Integer;
    var
//       BankAccount@1003 :
      BankAccount: Record 270;
    begin
      VendorLedgerEntry.SETAUTOCALCFIELDS("Remaining Amount","Remaining Amt. (LCY)");

      BankAccount.GET("Bank Account No.");
      GetApplicableVendorLedgerEntries(VendorLedgerEntry,BankAccount."Currency Code",AccountNo);

      if BankAccount.IsInLocalCurrency then
        VendorLedgerEntry.SETFILTER("Remaining Amt. (LCY)",AmountFilter,MinAmount,MaxAmount)
      else
        VendorLedgerEntry.SETFILTER("Remaining Amount",AmountFilter,MinAmount,MaxAmount);

      exit(VendorLedgerEntry.COUNT);
    end;
*/


//     LOCAL procedure GetBankAccountLedgerEntriesInAmountRange (var BankAccountLedgerEntry@1004 : Record 271;AmountFilter@1002 : Text;MinAmount@1001 : Decimal;MaxAmount@1000 :
    
/*
LOCAL procedure GetBankAccountLedgerEntriesInAmountRange (var BankAccountLedgerEntry: Record 271;AmountFilter: Text;MinAmount: Decimal;MaxAmount: Decimal) : Integer;
    var
//       BankAccount@1003 :
      BankAccount: Record 270;
    begin
      BankAccount.GET("Bank Account No.");
      GetApplicableBankAccountLedgerEntries(BankAccountLedgerEntry,BankAccount."Currency Code","Bank Account No.");

      BankAccountLedgerEntry.SETFILTER("Remaining Amount",AmountFilter,MinAmount,MaxAmount);

      exit(BankAccountLedgerEntry.COUNT);
    end;
*/


//     LOCAL procedure GetApplicableCustomerLedgerEntries (var CustLedgerEntry@1000 : Record 21;CurrencyCode@1001 : Code[10];AccountNo@1002 :
    
/*
LOCAL procedure GetApplicableCustomerLedgerEntries (var CustLedgerEntry: Record 21;CurrencyCode: Code[10];AccountNo: Code[20])
    begin
      CustLedgerEntry.SETRANGE(Open,TRUE);
      CustLedgerEntry.SETRANGE("Applies-to ID",'');
      CustLedgerEntry.SETFILTER("Document Type",'<>%1&<>%2',
        CustLedgerEntry."Document Type"::Payment,
        CustLedgerEntry."Document Type"::Refund);

      if CurrencyCode <> '' then
        CustLedgerEntry.SETRANGE("Currency Code",CurrencyCode);

      if AccountNo <> '' then
        CustLedgerEntry.SETFILTER("Customer No.",AccountNo);
    end;
*/


//     LOCAL procedure GetApplicableVendorLedgerEntries (var VendorLedgerEntry@1000 : Record 25;CurrencyCode@1002 : Code[10];AccountNo@1001 :
    
/*
LOCAL procedure GetApplicableVendorLedgerEntries (var VendorLedgerEntry: Record 25;CurrencyCode: Code[10];AccountNo: Code[20])
    begin
      VendorLedgerEntry.SETRANGE(Open,TRUE);
      VendorLedgerEntry.SETRANGE("Applies-to ID",'');
      VendorLedgerEntry.SETFILTER("Document Type",'<>%1&<>%2',
        VendorLedgerEntry."Document Type"::Payment,
        VendorLedgerEntry."Document Type"::Refund);

      if CurrencyCode <> '' then
        VendorLedgerEntry.SETRANGE("Currency Code",CurrencyCode);

      if AccountNo <> '' then
        VendorLedgerEntry.SETFILTER("Vendor No.",AccountNo);
    end;
*/


//     LOCAL procedure GetApplicableBankAccountLedgerEntries (var BankAccountLedgerEntry@1000 : Record 271;CurrencyCode@1002 : Code[10];AccountNo@1001 :
    
/*
LOCAL procedure GetApplicableBankAccountLedgerEntries (var BankAccountLedgerEntry: Record 271;CurrencyCode: Code[10];AccountNo: Code[20])
    begin
      BankAccountLedgerEntry.SETRANGE(Open,TRUE);

      if CurrencyCode <> '' then
        BankAccountLedgerEntry.SETRANGE("Currency Code",CurrencyCode);

      if AccountNo <> '' then
        BankAccountLedgerEntry.SETRANGE("Bank Account No.",AccountNo);
    end;
*/


    
//     procedure FilterBankRecLines (BankAccRecon@1000 :
    
/*
procedure FilterBankRecLines (BankAccRecon: Record 273)
    begin
      RESET;
      SETRANGE("Statement Type",BankAccRecon."Statement Type");
      SETRANGE("Bank Account No.",BankAccRecon."Bank Account No.");
      SETRANGE("Statement No.",BankAccRecon."Statement No.");
    end;
*/


    
//     procedure LinesExist (BankAccRecon@1001 :
    
/*
procedure LinesExist (BankAccRecon: Record 273) : Boolean;
    begin
      FilterBankRecLines(BankAccRecon);
      exit(FINDSET);
    end;
*/


    
    
/*
procedure GetAppliedToDocumentNo () : Text;
    var
//       ApplyType@1002 :
      ApplyType: Option "Document No.","Entry No.";
    begin
      exit(GetAppliedNo(ApplyType::"Document No."));
    end;
*/


    
    
/*
procedure GetAppliedToEntryNo () : Text;
    var
//       ApplyType@1000 :
      ApplyType: Option "Document No.","Entry No.";
    begin
      exit(GetAppliedNo(ApplyType::"Entry No."));
    end;
*/


    
/*
LOCAL procedure GetFirstAppliedToEntryNo () : Integer;
    var
//       AppliedEntryNumbers@1001 :
      AppliedEntryNumbers: Text;
//       AppliedToEntryNo@1003 :
      AppliedToEntryNo: Integer;
    begin
      AppliedEntryNumbers := GetAppliedToEntryNo;
      if AppliedEntryNumbers = '' then
        exit(0);
      EVALUATE(AppliedToEntryNo,SELECTSTR(1,AppliedEntryNumbers));
      exit(AppliedToEntryNo);
    end;
*/


//     LOCAL procedure GetAppliedNo (ApplyType@1000 :
    
/*
LOCAL procedure GetAppliedNo (ApplyType: Option "Document No.","Entry No") : Text;
    var
//       AppliedPaymentEntry@1002 :
      AppliedPaymentEntry: Record 1294;
//       AppliedNumbers@1001 :
      AppliedNumbers: Text;
    begin
      AppliedPaymentEntry.SETRANGE("Statement Type","Statement Type");
      AppliedPaymentEntry.SETRANGE("Bank Account No.","Bank Account No.");
      AppliedPaymentEntry.SETRANGE("Statement No.","Statement No.");
      AppliedPaymentEntry.SETRANGE("Statement Line No.","Statement Line No.");

      AppliedNumbers := '';
      if AppliedPaymentEntry.FINDSET then begin
        repeat
          if ApplyType = ApplyType::"Document No." then begin
            if AppliedPaymentEntry."Document No." <> '' then
              if AppliedNumbers = '' then
                AppliedNumbers := AppliedPaymentEntry."Document No."
              else
                AppliedNumbers := AppliedNumbers + ', ' + AppliedPaymentEntry."Document No.";
          end else begin
            if AppliedPaymentEntry."Applies-to Entry No." <> 0 then
              if AppliedNumbers = '' then
                AppliedNumbers := FORMAT(AppliedPaymentEntry."Applies-to Entry No.")
              else
                AppliedNumbers := AppliedNumbers + ', ' + FORMAT(AppliedPaymentEntry."Applies-to Entry No.");
          end;
        until AppliedPaymentEntry.NEXT = 0;
      end;

      exit(AppliedNumbers);
    end;
*/


    
    
/*
procedure TransferRemainingAmountToAccount ()
    var
//       AppliedPaymentEntry@1000 :
      AppliedPaymentEntry: Record 1294;
    begin
      TESTFIELD("Account No.");

      SetAppliedPaymentEntryFromRec(AppliedPaymentEntry);
      AppliedPaymentEntry.VALIDATE("Applied Amount",Difference);
      AppliedPaymentEntry.VALIDATE("Match Confidence",AppliedPaymentEntry."Match Confidence"::Manual);
      AppliedPaymentEntry.INSERT(TRUE);
    end;
*/


    
//     procedure GetAmountRangeForTolerance (var MinAmount@1001 : Decimal;var MaxAmount@1002 :
    
/*
procedure GetAmountRangeForTolerance (var MinAmount: Decimal;var MaxAmount: Decimal)
    var
//       BankAccount@1000 :
      BankAccount: Record 270;
//       TempAmount@1003 :
      TempAmount: Decimal;
    begin
      BankAccount.GET("Bank Account No.");
      CASE BankAccount."Match Tolerance Type" OF
        BankAccount."Match Tolerance Type"::Amount:
          begin
            MinAmount := "Statement Amount" - BankAccount."Match Tolerance Value";
            MaxAmount := "Statement Amount" + BankAccount."Match Tolerance Value";

            if ("Statement Amount" >= 0) and (MinAmount < 0) then
              MinAmount := 0
            else
              if ("Statement Amount" < 0) and (MaxAmount > 0) then
                MaxAmount := 0;
          end;
        BankAccount."Match Tolerance Type"::Percentage:
          begin
            MinAmount := "Statement Amount" * (1 - BankAccount."Match Tolerance Value" / 100);
            MaxAmount := "Statement Amount" * (1 + BankAccount."Match Tolerance Value" / 100);

            if "Statement Amount" < 0 then begin
              TempAmount := MinAmount;
              MinAmount := MaxAmount;
              MaxAmount := TempAmount;
            end;
          end;
      end;

      MinAmount := ROUND(MinAmount);
      MaxAmount := ROUND(MaxAmount);
    end;
*/


    
//     procedure GetAppliedPmtData (var AppliedPmtEntry@1000 : Record 1294;var RemainingAmountAfterPosting@1002 : Decimal;var DifferenceStatementAmtToApplEntryAmount@1001 : Decimal;PmtAppliedToTxt@1004 :
    
/*
procedure GetAppliedPmtData (var AppliedPmtEntry: Record 1294;var RemainingAmountAfterPosting: Decimal;var DifferenceStatementAmtToApplEntryAmount: Decimal;PmtAppliedToTxt: Text)
    var
//       CurrRemAmtAfterPosting@1003 :
      CurrRemAmtAfterPosting: Decimal;
    begin
      AppliedPmtEntry.INIT;
      RemainingAmountAfterPosting := 0;
      DifferenceStatementAmtToApplEntryAmount := 0;

      AppliedPmtEntry.FilterAppliedPmtEntry(Rec);
      AppliedPmtEntry.SETFILTER("Applies-to Entry No.",'<>0');
      if AppliedPmtEntry.FINDSET then begin
        DifferenceStatementAmtToApplEntryAmount := "Statement Amount";
        repeat
          CurrRemAmtAfterPosting :=
            AppliedPmtEntry.GetRemAmt -
            AppliedPmtEntry.GetAmtAppliedToOtherStmtLines;

          RemainingAmountAfterPosting += CurrRemAmtAfterPosting - AppliedPmtEntry."Applied Amount";
          DifferenceStatementAmtToApplEntryAmount -= CurrRemAmtAfterPosting - AppliedPmtEntry."Applied Pmt. Discount";
        until AppliedPmtEntry.NEXT = 0;
      end;

      if "Applied Entries" > 1 then
        AppliedPmtEntry.Description := STRSUBSTNO(PmtAppliedToTxt,"Applied Entries");
    end;
*/


    
/*
LOCAL procedure UpdateParentLineStatementAmount ()
    var
//       BankAccReconciliationLine@1000 :
      BankAccReconciliationLine: Record 274;
    begin
      if BankAccReconciliationLine.GET("Statement Type","Bank Account No.","Statement No.","Parent Line No.") then begin
        BankAccReconciliationLine.VALIDATE("Statement Amount","Statement Amount" + BankAccReconciliationLine."Statement Amount");
        BankAccReconciliationLine.MODIFY(TRUE)
      end
    end;
*/


    
    
/*
procedure IsTransactionPostedAndReconciled () : Boolean;
    var
//       PostedPaymentReconLine@1001 :
      PostedPaymentReconLine: Record 1296;
//       BankAccountStatementLine@1000 :
      BankAccountStatementLine: Record 276;
    begin
      if "Transaction ID" <> '' then begin
        PostedPaymentReconLine.SETRANGE("Bank Account No.","Bank Account No.");
        PostedPaymentReconLine.SETRANGE("Transaction ID","Transaction ID");
        PostedPaymentReconLine.SETRANGE(Reconciled,TRUE);
        if not PostedPaymentReconLine.ISEMPTY then
          exit(TRUE);
        BankAccountStatementLine.SETRANGE("Bank Account No.","Bank Account No.");
        BankAccountStatementLine.SETRANGE("Transaction ID","Transaction ID");
        exit(not BankAccountStatementLine.ISEMPTY);
      end;
      exit(FALSE);
    end;
*/


    
/*
LOCAL procedure IsTransactionPostedAndNotReconciled () : Boolean;
    var
//       PostedPaymentReconLine@1001 :
      PostedPaymentReconLine: Record 1296;
    begin
      if "Transaction ID" <> '' then begin
        PostedPaymentReconLine.SETRANGE("Bank Account No.","Bank Account No.");
        PostedPaymentReconLine.SETRANGE("Transaction ID","Transaction ID");
        PostedPaymentReconLine.SETRANGE(Reconciled,FALSE);
        exit(PostedPaymentReconLine.FINDFIRST)
      end;
      exit(FALSE);
    end;
*/


    
/*
LOCAL procedure IsTransactionAlreadyImported () : Boolean;
    var
//       BankAccReconciliationLine@1001 :
      BankAccReconciliationLine: Record 274;
    begin
      if "Transaction ID" <> '' then begin
        BankAccReconciliationLine.SETRANGE("Statement Type","Statement Type");
        BankAccReconciliationLine.SETRANGE("Bank Account No.","Bank Account No.");
        BankAccReconciliationLine.SETRANGE("Transaction ID","Transaction ID");
        exit(BankAccReconciliationLine.FINDFIRST)
      end;
      exit(FALSE);
    end;
*/


    
/*
LOCAL procedure AllowImportOfPostedNotReconciledTransactions () : Boolean;
    var
//       BankAccReconciliation@1000 :
      BankAccReconciliation: Record 273;
    begin
      BankAccReconciliation.GET("Statement Type","Bank Account No.","Statement No.");
      if BankAccReconciliation."Import Posted Transactions" = BankAccReconciliation."Import Posted Transactions"::" " then begin
        BankAccReconciliation."Import Posted Transactions" := BankAccReconciliation."Import Posted Transactions"::No;
        if GUIALLOWED then
          if CONFIRM(ImportPostedTransactionsQst) then
            BankAccReconciliation."Import Posted Transactions" := BankAccReconciliation."Import Posted Transactions"::Yes;
        BankAccReconciliation.MODIFY;
      end;

      exit(BankAccReconciliation."Import Posted Transactions" = BankAccReconciliation."Import Posted Transactions"::Yes);
    end;
*/


    
    
/*
procedure CanImport () : Boolean;
    begin
      if IsTransactionPostedAndReconciled or IsTransactionAlreadyImported then
        exit(FALSE);

      if IsTransactionPostedAndNotReconciled then
        exit(AllowImportOfPostedNotReconciledTransactions);

      exit(TRUE);
    end;
*/


    
/*
LOCAL procedure GetSalepersonPurchaserCode () : Code[20];
    var
//       Customer@1002 :
      Customer: Record 18;
//       Vendor@1003 :
      Vendor: Record 23;
    begin
      CASE "Account Type" OF
        "Account Type"::Customer:
          if Customer.GET("Account No.") then
            exit(Customer."Salesperson Code");
        "Account Type"::Vendor:
          if Vendor.GET("Account No.") then
            exit(Vendor."Purchaser Code");
      end;
    end;
*/


    
    
/*
procedure GetAppliesToID () : Code[50];
    var
//       CustLedgerEntry@1001 :
      CustLedgerEntry: Record 21;
    begin
      exit(COPYSTR(FORMAT("Statement No.") + '-' + FORMAT("Statement Line No."),1,MAXSTRLEN(CustLedgerEntry."Applies-to ID")));
    end;
*/


    
    
/*
procedure GetDescription () : Text[50];
    var
//       AppliedPaymentEntry@1000 :
      AppliedPaymentEntry: Record 1294;
    begin
      if Description <> '' then
        exit(Description);

      AppliedPaymentEntry.FilterAppliedPmtEntry(Rec);
      AppliedPaymentEntry.SETFILTER("Applies-to Entry No.",'<>%1',0);
      if AppliedPaymentEntry.FINDSET then
        if AppliedPaymentEntry.NEXT = 0 then
          exit(AppliedPaymentEntry.Description);

      exit('');
    end;
*/


    
//     LOCAL procedure OnAfterCreateDimTableIDs (var BankAccReconciliationLine@1000 : Record 274;var FieldNo@1001 : Integer;var TableID@1003 : ARRAY [10] OF Integer;var No@1002 :
    
/*
LOCAL procedure OnAfterCreateDimTableIDs (var BankAccReconciliationLine: Record 274;var FieldNo: Integer;var TableID: ARRAY [10] OF Integer;var No: ARRAY [10] OF Code[20])
    begin
    end;

    /*begin
    //{
//      JAV 15/09/20: - QB 1.06.14 Se a¤aden los campos cargados desde N43 "Concepto Interbancario", "Descripcion conc. interbanc." y "Description 2"
//    }
    end.
  */
}




