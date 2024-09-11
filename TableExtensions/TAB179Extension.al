tableextension 50147 "QBU Reversal EntryExt" extends "Reversal Entry"
{
  
  
    CaptionML=ENU='Reversal Entry',ESP='Mov. de reversi¢n';/*
PasteIsValid=false;
*/
  ;
  fields
{
    field(7207270;"QBU Piecework Code";Code[20])
    {
        TableRelation="Data Piecework For Production"."Piecework Code" WHERE ("Job No."=FIELD("Job No."));
                                                   CaptionML=ENU='Piecework Code',ESP='N§ unidad de obra';


    }
    field(7207271;"QBU Job No.";Code[20])
    {
        TableRelation="Job";
                                                   CaptionML=ENU='Job No.',ESP='N§ Proyecto'; ;


    }
}
  keys
{
   // key(key1;"Line No.")
  //  {
       /* Clustered=true;
 */
   // }
   // key(key2;"Entry Type")
  //  {
       /* ;
 */
   // }
   // key(key3;"Document No.","Posting Date","Entry Type","Entry No.")
  //  {
       /* ;
 */
   // }
   // key(key4;"Entry Type","Entry No.")
  //  {
       /* ;
 */
   // }
}
  fieldgroups
{
}
  
    var
//       GLSetup@1000 :
      GLSetup: Record 98;
//       TempReversalEntry@1001 :
      TempReversalEntry: Record 179 TEMPORARY;
//       GLEntry@1007 :
      GLEntry: Record 17;
//       CustLedgEntry@1006 :
      CustLedgEntry: Record 21;
//       VendLedgEntry@1005 :
      VendLedgEntry: Record 25;
//       EmployeeLedgerEntry@1031 :
      EmployeeLedgerEntry: Record 5222;
//       BankAccLedgEntry@1004 :
      BankAccLedgEntry: Record 271;
//       VATEntry@1003 :
      VATEntry: Record 254;
//       FALedgEntry@1002 :
      FALedgEntry: Record 5601;
//       MaintenanceLedgEntry@1009 :
      MaintenanceLedgEntry: Record 5625;
//       GLReg@1008 :
      GLReg: Record 45;
//       Text000@1010 :
      Text000: TextConst ENU='You cannot reverse %1 No. %2 because the entry is either applied to an entry or has been changed by a batch job.',ESP='No es posible revertir %1 n§ %2, el movimiento liquida otro movimiento o fue modificado por un trabajo por lotes.';
//       FAReg@1015 :
      FAReg: Record 5617;
//       GenJnlCheckLine@1011 :
      GenJnlCheckLine: Codeunit 11;
//       Text001@1012 :
      Text001: TextConst ENU='You cannot reverse %1 No. %2 because the posting date is not within the allowed posting period.',ESP='No es posible revertir %1 n§ %2, la fecha de registro no corresponde al periodo de registro aceptado.';
//       AllowPostingFrom@1014 :
      AllowPostingFrom: Date;
//       AllowPostingto@1013 :
      AllowPostingto: Date;
//       Text002@1016 :
      Text002: TextConst ENU='You cannot reverse the transaction because it is out of balance.',ESP='No es posible revertir la transacci¢n porque est  descuadrada.';
//       Text003@1017 :
      Text003: TextConst ENU='You cannot reverse %1 No. %2 because the entry has a related check ledger entry.',ESP='No es posible revertir %1 n§ %2, existe una entrada de registro de cheque correspondiente al movimiento.';
//       Text004@1018 :
      Text004: TextConst ENU='You can only reverse entries that were posted from a journal.',ESP='S¢lo puede invertir entradas registradas desde un diario.';
//       Text005@1020 :
      Text005: TextConst ENU='You cannot reverse %1 No. %2 because the %3 is not within the allowed posting period.',ESP='No es posible revertir %1 n§ %2, %3 no corresponde al periodo de registro aceptado.';
//       Text006@1022 :
      Text006: TextConst ENU='You cannot reverse %1 No. %2 because the entry is closed.',ESP='No es posible revertir %1 n§ %2, el movimiento ha sido cerrado.';
//       Text007@1021 :
      Text007: TextConst ENU='You cannot reverse %1 No. %2 because the entry is included in a bank account reconciliation line. The bank reconciliation has not yet been posted.',ESP='No es posible revertir %1 n§ %2, el movimiento est  incluido en una l¡nea de reconciliaci¢n de cuentas que a£n no se ha registrado.';
//       Text008@1019 :
      Text008: TextConst ENU='You cannot reverse the transaction because the %1 has been sold.',ESP='No es posible revertir la transacci¢n, se ha vendido el %1.';
//       MaxPostingDate@1024 :
      MaxPostingDate: Date;
//       CannotReverseDeletedErr@1025 :
      CannotReverseDeletedErr: 
// "%1 and %2 = table captions"
TextConst ENU='The transaction cannot be reversed, because the %1 has been compressed or a %2 has been deleted.',ESP='No es posible revertir la transacci¢n, se comprimi¢ el %1 o se elimin¢ un %2.';
//       Text010@1023 :
      Text010: TextConst ENU='You cannot reverse %1 No. %2 because the register has already been involved in a reversal.',ESP='No es posible revertir %1 n§ %2, el registro ya se ha incluido en una reversi¢n.';
//       Text011@1026 :
      Text011: TextConst ENU='You cannot reverse %1 No. %2 because the entry has already been involved in a reversal.',ESP='No es posible revertir %1 n§ %2, el movimiento ya se ha incluido en una reversi¢n.';
//       PostedAndAppliedSameTransactionErr@1028 :
      PostedAndAppliedSameTransactionErr: 
// "%1=""G/L Register No."""
TextConst ENU='You cannot reverse register number %1 because it contains customer or vendor or employee ledger entries that have been posted and applied in the same transaction.\\You must reverse each transaction in register number %1 separately.',ESP='No puede revertir el n£mero de registro %1 porque contiene movimientos contables de cliente o proveedor o empleado registrados y aplicados en la misma transacci¢n.\\Debe revertir por separado cada transacci¢n en el n£mero de registro %1.';
//       Text013@1039 :
      Text013: TextConst ENU='You cannot reverse %1 No. %2 because the entry has an associated Realized Gain/Loss entry.',ESP='No es posible revertir %1 n§ %2 porque la entrada tiene un movimiento Beneficio/p‚rdida realizado asociado.';
//       HideDialog@1030 :
      HideDialog: Boolean;
//       Text1100000@1100000 :
      Text1100000: TextConst ENU='You can not reverse entries that sent invoices to Cartera.',ESP='No puede revertir las entradas que hayan enviado facturas a Cartera.';
//       UnrealizedVATReverseErr@1027 :
      UnrealizedVATReverseErr: TextConst ENU='You cannot reverse %1 No. %2 because the entry has an associated Unrealized VAT Entry.',ESP='No es posible revertir %1 n§ %2 porque la entrada tiene un movimiento IVA no realizado asociado.';
//       HideWarningDialogs@1029 :
      HideWarningDialogs: Boolean;

    
//     procedure ReverseTransaction (TransactionNo@1000 :
    
/*
procedure ReverseTransaction (TransactionNo: Integer)
    begin
      ReverseEntries(TransactionNo,"Reversal Type"::Transaction);
    end;
*/


    
//     procedure ReverseRegister (RegisterNo@1000 :
    
/*
procedure ReverseRegister (RegisterNo: Integer)
    begin
      CheckRegister(RegisterNo);
      ReverseEntries(RegisterNo,"Reversal Type"::Register);
    end;
*/


//     LOCAL procedure ReverseEntries (Number@1001 : Integer;RevType@1000 :
    
/*
LOCAL procedure ReverseEntries (Number: Integer;RevType: Option "Transaction","Registe")
    var
//       ReversalPost@1002 :
      ReversalPost: Codeunit 179;
//       IsHandled@1003 :
      IsHandled: Boolean;
    begin
      IsHandled := FALSE;
      OnBeforeReverseEntries(Number,RevType,IsHandled);
      if IsHandled then
        exit;

      InsertReversalEntry(Number,RevType);
      TempReversalEntry.SETCURRENTKEY("Document No.","Posting Date","Entry Type","Entry No.");
      if not HideDialog then
        PAGE.RUNMODAL(PAGE::"Reverse Entries",TempReversalEntry)
      else begin
        ReversalPost.SetPrint(FALSE);
        ReversalPost.SetHideDialog(HideWarningDialogs);
        ReversalPost.RUN(TempReversalEntry);
      end;
      TempReversalEntry.DELETEALL;
    end;
*/


//     LOCAL procedure InsertReversalEntry (Number@1000 : Integer;RevType@1007 :
    
/*
LOCAL procedure InsertReversalEntry (Number: Integer;RevType: Option "Transaction","Registe")
    var
//       TempRevertTransactionNo@1005 :
      TempRevertTransactionNo: Record 2000000026 TEMPORARY;
//       NextLineNo@1008 :
      NextLineNo: Integer;
    begin
      GLSetup.GET;
      TempReversalEntry.DELETEALL;
      NextLineNo := 1;
      TempRevertTransactionNo.Number := Number;
      TempRevertTransactionNo.INSERT;
      SetReverseFilter(Number,RevType);

      InsertFromCustLedgEntry(TempRevertTransactionNo,Number,RevType,NextLineNo);
      InsertFromVendLedgEntry(TempRevertTransactionNo,Number,RevType,NextLineNo);
      InsertFromEmplLedgerEntry(TempRevertTransactionNo,Number,RevType,NextLineNo);
      InsertFromBankAccLedgEntry(Number,RevType,NextLineNo);
      InsertFromFALedgEntry(Number,RevType,NextLineNo);
      InsertFromMaintenanceLedgEntry(Number,RevType,NextLineNo);
      InsertFromVATEntry(TempRevertTransactionNo,Number,RevType,NextLineNo);
      InsertFromGLEntry(TempRevertTransactionNo,Number,RevType,NextLineNo);
      OnAfterInsertReversalEntry(TempRevertTransactionNo,Number,RevType,NextLineNo);
      if TempReversalEntry.FIND('-') then;
    end;
*/


    
    
/*
procedure CheckEntries ()
    var
//       GLAcc@1001 :
      GLAcc: Record 15;
//       DtldCustLedgEntry@1006 :
      DtldCustLedgEntry: Record 379;
//       DtldVendLedgEntry@1007 :
      DtldVendLedgEntry: Record 380;
//       DetailedEmployeeLedgerEntry@1003 :
      DetailedEmployeeLedgerEntry: Record 5223;
//       DateComprReg@1000 :
      DateComprReg: Record 87;
//       BalanceCheckAmount@1012 :
      BalanceCheckAmount: Decimal;
//       BalanceCheckAddCurrAmount@1010 :
      BalanceCheckAddCurrAmount: Decimal;
//       SkipCheck@1002 :
      SkipCheck: Boolean;
    begin
      DtldCustLedgEntry.LOCKTABLE;
      DtldVendLedgEntry.LOCKTABLE;
      DetailedEmployeeLedgerEntry.LOCKTABLE;
      GLEntry.LOCKTABLE;
      CustLedgEntry.LOCKTABLE;
      VendLedgEntry.LOCKTABLE;
      EmployeeLedgerEntry.LOCKTABLE;
      BankAccLedgEntry.LOCKTABLE;
      FALedgEntry.LOCKTABLE;
      MaintenanceLedgEntry.LOCKTABLE;
      VATEntry.LOCKTABLE;
      GLReg.LOCKTABLE;
      FAReg.LOCKTABLE;
      GLSetup.GET;
      MaxPostingDate := 0D;

      SkipCheck := FALSE;
      OnBeforeCheckEntries(Rec,DATABASE::"G/L Entry",SkipCheck);
      if not SkipCheck then begin
        if GLEntry.ISEMPTY then
          ERROR(CannotReverseDeletedErr,GLEntry.TABLECAPTION,GLAcc.TABLECAPTION);
        if GLEntry.FIND('-') then begin
          if GLEntry."Journal Batch Name" = '' then
            TestFieldError;
          repeat
            CheckGLAcc(GLEntry,BalanceCheckAmount,BalanceCheckAddCurrAmount);
          until GLEntry.NEXT = 0;
        end;
        if (BalanceCheckAmount <> 0) or (BalanceCheckAddCurrAmount <> 0) then
          ERROR(Text002);
      end;

      if CustLedgEntry.FIND('-') then begin
        SkipCheck := FALSE;
        OnBeforeCheckEntries(Rec,DATABASE::"Cust. Ledger Entry",SkipCheck);
        if not SkipCheck then
          repeat
            CheckCust(CustLedgEntry);
          until CustLedgEntry.NEXT = 0;
      end;

      if VendLedgEntry.FIND('-') then begin
        SkipCheck := FALSE;
        OnBeforeCheckEntries(Rec,DATABASE::"Vendor Ledger Entry",SkipCheck);
        if not SkipCheck then
          repeat
            CheckVend(VendLedgEntry);
          until VendLedgEntry.NEXT = 0;
      end;

      if EmployeeLedgerEntry.FINDSET then begin
        SkipCheck := FALSE;
        OnBeforeCheckEntries(Rec,DATABASE::"Employee Ledger Entry",SkipCheck);
        if not SkipCheck then
          repeat
            CheckEmpl(EmployeeLedgerEntry);
          until EmployeeLedgerEntry.NEXT = 0;
      end;

      if BankAccLedgEntry.FIND('-') then begin
        SkipCheck := FALSE;
        OnBeforeCheckEntries(Rec,DATABASE::"Bank Account Ledger Entry",SkipCheck);
        if not SkipCheck then
          repeat
            CheckBankAcc(BankAccLedgEntry);
          until BankAccLedgEntry.NEXT = 0;
      end;

      if FALedgEntry.FIND('-') then begin
        SkipCheck := FALSE;
        OnBeforeCheckEntries(Rec,DATABASE::"FA Ledger Entry",SkipCheck);
        if not SkipCheck then
          repeat
            CheckFA(FALedgEntry);
          until FALedgEntry.NEXT = 0;
      end;

      if MaintenanceLedgEntry.FIND('-') then begin
        SkipCheck := FALSE;
        OnBeforeCheckEntries(Rec,DATABASE::"Maintenance Ledger Entry",SkipCheck);
        if not SkipCheck then
          repeat
            CheckMaintenance(MaintenanceLedgEntry);
          until MaintenanceLedgEntry.NEXT = 0;
      end;

      if VATEntry.FIND('-') then begin
        SkipCheck := FALSE;
        OnBeforeCheckEntries(Rec,DATABASE::"VAT Entry",SkipCheck);
        if not SkipCheck then
          repeat
            CheckVAT(VATEntry);
          until VATEntry.NEXT = 0;
      end;

      OnAfterCheckEntries;

      DateComprReg.CheckMaxDateCompressed(MaxPostingDate,1);
    end;
*/


//     LOCAL procedure CheckGLAcc (GLEntry@1000 : Record 17;var BalanceCheckAmount@1002 : Decimal;var BalanceCheckAddCurrAmount@1001 :
    
/*
LOCAL procedure CheckGLAcc (GLEntry: Record 17;var BalanceCheckAmount: Decimal;var BalanceCheckAddCurrAmount: Decimal)
    var
//       GLAcc@1003 :
      GLAcc: Record 15;
//       Text1100100@1100000 :
      Text1100100: TextConst ENU='The entry cannot be reversed',ESP='No es posible revertir el movimiento';
//       GLRegDoc@1100001 :
      GLRegDoc: Codeunit 7000001;
//       CarteraDoc@1100002 :
      CarteraDoc: Record 7000002;
//       CarteraSetup@1100010 :
      CarteraSetup: Record 7000016;
    begin
      GLAcc.GET(GLEntry."G/L Account No.");
      CheckPostingDate(GLEntry."Posting Date",GLEntry.TABLECAPTION,GLEntry."Entry No.");
      GLAcc.TESTFIELD(Blocked,FALSE);
      GLEntry.TESTFIELD("Job No.",'');

      if CarteraSetup.READPERMISSION then
        if (GLEntry."Bill No." <> '') or GLRegDoc.CheckPostedDocsInPostedBGPO(GLEntry) then
          ERROR(Text1100100)
        else
          if GLEntry."Document Type" = GLEntry."Document Type"::Invoice then begin
            CarteraDoc.SETCURRENTKEY(Type,"Document No.");
            CarteraDoc.SETRANGE("Document No.","Document No.");
            CarteraDoc.SETRANGE("Document Type",CarteraDoc."Document Type"::Invoice);
            if CarteraDoc.FINDFIRST then
              ERROR(Text1100000);
          end;

      if GLEntry.Reversed then
        AlreadyReversedEntry(GLEntry.TABLECAPTION,GLEntry."Entry No.");
      BalanceCheckAmount := BalanceCheckAmount + GLEntry.Amount;
      if GLSetup."Additional Reporting Currency" <> '' then
        BalanceCheckAddCurrAmount := BalanceCheckAddCurrAmount + GLEntry."Additional-Currency Amount";

      OnAfterCheckGLAcc(GLAcc,GLEntry);
    end;
*/


//     LOCAL procedure CheckCust (CustLedgEntry@1001 :
    
/*
LOCAL procedure CheckCust (CustLedgEntry: Record 21)
    var
//       Cust@1000 :
      Cust: Record 18;
    begin
      Cust.GET(CustLedgEntry."Customer No.");
      CheckPostingDate(
        CustLedgEntry."Posting Date",CustLedgEntry.TABLECAPTION,CustLedgEntry."Entry No.");
      Cust.CheckBlockedCustOnJnls(Cust,CustLedgEntry."Document Type",FALSE);
      if CustLedgEntry.Reversed then
        AlreadyReversedEntry(CustLedgEntry.TABLECAPTION,CustLedgEntry."Entry No.");
      CheckDtldCustLedgEntry(CustLedgEntry);

      OnAfterCheckCust(Cust,CustLedgEntry);
    end;
*/


//     LOCAL procedure CheckVend (VendLedgEntry@1001 :
    
/*
LOCAL procedure CheckVend (VendLedgEntry: Record 25)
    var
//       Vend@1000 :
      Vend: Record 23;
    begin
      Vend.GET(VendLedgEntry."Vendor No.");
      CheckPostingDate(
        VendLedgEntry."Posting Date",VendLedgEntry.TABLECAPTION,VendLedgEntry."Entry No.");
      Vend.CheckBlockedVendOnJnls(Vend,VendLedgEntry."Document Type",FALSE);
      if VendLedgEntry.Reversed then
        AlreadyReversedEntry(VendLedgEntry.TABLECAPTION,VendLedgEntry."Entry No.");
      CheckDtldVendLedgEntry(VendLedgEntry);

      OnAfterCheckVend(Vend,VendLedgEntry);
    end;
*/


//     LOCAL procedure CheckEmpl (EmployeeLedgerEntry@1000 :
    
/*
LOCAL procedure CheckEmpl (EmployeeLedgerEntry: Record 5222)
    var
//       Employee@1001 :
      Employee: Record 5200;
    begin
      Employee.GET(EmployeeLedgerEntry."Employee No.");
      CheckPostingDate(
        EmployeeLedgerEntry."Posting Date",EmployeeLedgerEntry.TABLECAPTION,EmployeeLedgerEntry."Entry No.");
      Employee.CheckBlockedEmployeeOnJnls(FALSE);
      if EmployeeLedgerEntry.Reversed then
        AlreadyReversedEntry(EmployeeLedgerEntry.TABLECAPTION,EmployeeLedgerEntry."Entry No.");
      CheckDtldEmplLedgEntry(EmployeeLedgerEntry);

      OnAfterCheckEmpl(Employee,EmployeeLedgerEntry);
    end;
*/


//     LOCAL procedure CheckBankAcc (BankAccLedgEntry@1000 :
    
/*
LOCAL procedure CheckBankAcc (BankAccLedgEntry: Record 271)
    var
//       BankAcc@1001 :
      BankAcc: Record 270;
//       CheckLedgEntry@1002 :
      CheckLedgEntry: Record 272;
    begin
      BankAcc.GET(BankAccLedgEntry."Bank Account No.");
      CheckPostingDate(
        BankAccLedgEntry."Posting Date",BankAccLedgEntry.TABLECAPTION,BankAccLedgEntry."Entry No.");
      BankAcc.TESTFIELD(Blocked,FALSE);
      if BankAccLedgEntry.Reversed then
        AlreadyReversedEntry(BankAccLedgEntry.TABLECAPTION,BankAccLedgEntry."Entry No.");
      if not BankAccLedgEntry.Open then
        ERROR(
          Text006,BankAccLedgEntry.TABLECAPTION,BankAccLedgEntry."Entry No.");
      if BankAccLedgEntry."Statement No." <> '' then
        ERROR(
          Text007,BankAccLedgEntry.TABLECAPTION,BankAccLedgEntry."Entry No.");
      CheckLedgEntry.SETRANGE("Bank Account Ledger Entry No.",BankAccLedgEntry."Entry No.");
      if not CheckLedgEntry.ISEMPTY then
        ERROR(
          Text003,BankAccLedgEntry.TABLECAPTION,BankAccLedgEntry."Entry No.");

      OnAfterCheckBankAcc(BankAcc,BankAccLedgEntry);
    end;
*/


//     LOCAL procedure CheckFA (FALedgEntry@1000 :
    
/*
LOCAL procedure CheckFA (FALedgEntry: Record 5601)
    var
//       FA@1001 :
      FA: Record 5600;
//       FADeprBook@1002 :
      FADeprBook: Record 5612;
//       DeprCalc@1003 :
      DeprCalc: Codeunit 5616;
    begin
      FA.GET(FALedgEntry."FA No.");
      CheckPostingDate(
        FALedgEntry."Posting Date",FALedgEntry.TABLECAPTION,FALedgEntry."Entry No.");
      CheckFAPostingDate(
        FALedgEntry."FA Posting Date",FALedgEntry.TABLECAPTION,FALedgEntry."Entry No.");
      FA.TESTFIELD(Blocked,FALSE);
      FA.TESTFIELD(Inactive,FALSE);
      if FALedgEntry.Reversed then
        AlreadyReversedEntry(FALedgEntry.TABLECAPTION,FALedgEntry."Entry No.");
      FALedgEntry.TESTFIELD("Depreciation Book Code");
      FADeprBook.GET(FA."No.",FALedgEntry."Depreciation Book Code");
      if FADeprBook."Disposal Date" <> 0D then
        ERROR(Text008,DeprCalc.FAName(FA,FALedgEntry."Depreciation Book Code"));
      FALedgEntry.TESTFIELD("G/L Entry No.");

      OnAfterCheckFA(FA,FALedgEntry);
    end;
*/


//     LOCAL procedure CheckMaintenance (MaintenanceLedgEntry@1000 :
    
/*
LOCAL procedure CheckMaintenance (MaintenanceLedgEntry: Record 5625)
    var
//       FA@1001 :
      FA: Record 5600;
//       FADeprBook@1002 :
      FADeprBook: Record 5612;
    begin
      FA.GET(MaintenanceLedgEntry."FA No.");
      CheckPostingDate(
        MaintenanceLedgEntry."Posting Date",MaintenanceLedgEntry.TABLECAPTION,MaintenanceLedgEntry."Entry No.");
      CheckFAPostingDate(
        MaintenanceLedgEntry."FA Posting Date",MaintenanceLedgEntry.TABLECAPTION,MaintenanceLedgEntry."Entry No.");
      FA.TESTFIELD(Blocked,FALSE);
      FA.TESTFIELD(Inactive,FALSE);
      MaintenanceLedgEntry.TESTFIELD("Depreciation Book Code");
      if MaintenanceLedgEntry.Reversed then
        AlreadyReversedEntry(MaintenanceLedgEntry.TABLECAPTION,MaintenanceLedgEntry."Entry No.");
      FADeprBook.GET(FA."No.",MaintenanceLedgEntry."Depreciation Book Code");
      MaintenanceLedgEntry.TESTFIELD("G/L Entry No.");

      OnAfterCheckMaintenance(FA,MaintenanceLedgEntry);
    end;
*/


//     LOCAL procedure CheckVAT (VATEntry@1000 :
    
/*
LOCAL procedure CheckVAT (VATEntry: Record 254)
    begin
      CheckPostingDate(VATEntry."Posting Date",VATEntry.TABLECAPTION,VATEntry."Entry No.");
      if VATEntry.Closed then
        ERROR(
          Text006,VATEntry.TABLECAPTION,VATEntry."Entry No.");
      if VATEntry.Reversed then
        AlreadyReversedEntry(VATEntry.TABLECAPTION,VATEntry."Entry No.");
      if VATEntry."Unrealized VAT Entry No." <> 0 then
        ERROR(UnrealizedVATReverseError(VATEntry.TABLECAPTION,VATEntry."Entry No."));

      OnAfterCheckVAT(VATEntry);
    end;
*/


//     LOCAL procedure CheckDtldCustLedgEntry (CustLedgEntry@1000 :
    
/*
LOCAL procedure CheckDtldCustLedgEntry (CustLedgEntry: Record 21)
    var
//       DtldCustLedgEntry@1001 :
      DtldCustLedgEntry: Record 379;
    begin
      DtldCustLedgEntry.SETCURRENTKEY("Cust. Ledger Entry No.","Entry Type");
      DtldCustLedgEntry.SETRANGE("Cust. Ledger Entry No.",CustLedgEntry."Entry No.");
      DtldCustLedgEntry.SETFILTER("Entry Type",'<>%1',DtldCustLedgEntry."Entry Type"::"Initial Entry");
      DtldCustLedgEntry.SETRANGE(Unapplied,FALSE);
      if not DtldCustLedgEntry.ISEMPTY then
        ERROR(ReversalErrorForChangedEntry(CustLedgEntry.TABLECAPTION,CustLedgEntry."Entry No."));

      DtldCustLedgEntry.RESET;
      DtldCustLedgEntry.SETCURRENTKEY("Transaction No.","Customer No.","Entry Type");
      DtldCustLedgEntry.SETRANGE("Transaction No.",CustLedgEntry."Transaction No.");
      DtldCustLedgEntry.SETRANGE("Customer No.",CustLedgEntry."Customer No.");
      DtldCustLedgEntry.SETFILTER("Entry Type",'%1|%2',
        DtldCustLedgEntry."Entry Type"::"Realized Gain",DtldCustLedgEntry."Entry Type"::"Realized Loss");
      if not DtldCustLedgEntry.ISEMPTY then
        ERROR(Text013,CustLedgEntry.TABLECAPTION,CustLedgEntry."Entry No.");

      OnAfterCheckDtldCustLedgEntry(DtldCustLedgEntry,CustLedgEntry);
    end;
*/


//     LOCAL procedure CheckDtldVendLedgEntry (VendLedgEntry@1000 :
    
/*
LOCAL procedure CheckDtldVendLedgEntry (VendLedgEntry: Record 25)
    var
//       DtldVendLedgEntry@1001 :
      DtldVendLedgEntry: Record 380;
    begin
      DtldVendLedgEntry.SETCURRENTKEY("Vendor Ledger Entry No.","Entry Type");
      DtldVendLedgEntry.SETRANGE("Vendor Ledger Entry No.",VendLedgEntry."Entry No.");
      DtldVendLedgEntry.SETFILTER("Entry Type",'<>%1',DtldVendLedgEntry."Entry Type"::"Initial Entry");
      DtldVendLedgEntry.SETRANGE(Unapplied,FALSE);
      if not DtldVendLedgEntry.ISEMPTY then
        ERROR(ReversalErrorForChangedEntry(VendLedgEntry.TABLECAPTION,VendLedgEntry."Entry No."));

      DtldVendLedgEntry.RESET;
      DtldVendLedgEntry.SETCURRENTKEY("Transaction No.","Vendor No.","Entry Type");
      DtldVendLedgEntry.SETRANGE("Transaction No.",VendLedgEntry."Transaction No.");
      DtldVendLedgEntry.SETRANGE("Vendor No.",VendLedgEntry."Vendor No.");
      DtldVendLedgEntry.SETFILTER("Entry Type",'%1|%2',
        DtldVendLedgEntry."Entry Type"::"Realized Gain",DtldVendLedgEntry."Entry Type"::"Realized Loss");
      if not DtldVendLedgEntry.ISEMPTY then
        ERROR(Text013,VendLedgEntry.TABLECAPTION,VendLedgEntry."Entry No.");

      OnAfterCheckDtldVendLedgEntry(DtldVendLedgEntry,VendLedgEntry);
    end;
*/


//     LOCAL procedure CheckDtldEmplLedgEntry (EmployeeLedgerEntry@1000 :
    
/*
LOCAL procedure CheckDtldEmplLedgEntry (EmployeeLedgerEntry: Record 5222)
    var
//       DetailedEmployeeLedgerEntry@1001 :
      DetailedEmployeeLedgerEntry: Record 5223;
    begin
      DetailedEmployeeLedgerEntry.SETRANGE("Employee Ledger Entry No.",EmployeeLedgerEntry."Entry No.");
      DetailedEmployeeLedgerEntry.SETFILTER("Entry Type",'<>%1',DetailedEmployeeLedgerEntry."Entry Type"::"Initial Entry");
      DetailedEmployeeLedgerEntry.SETRANGE(Unapplied,FALSE);
      if not DetailedEmployeeLedgerEntry.ISEMPTY then
        ERROR(ReversalErrorForChangedEntry(EmployeeLedgerEntry.TABLECAPTION,EmployeeLedgerEntry."Entry No."));

      OnAfterCheckDtldEmplLedgEntry(DetailedEmployeeLedgerEntry,EmployeeLedgerEntry);
    end;
*/


//     LOCAL procedure CheckRegister (RegisterNo@1000 :
    
/*
LOCAL procedure CheckRegister (RegisterNo: Integer)
    var
//       GLReg@1001 :
      GLReg: Record 45;
//       IsHandled@1002 :
      IsHandled: Boolean;
    begin
      IsHandled := FALSE;
      OnBeforeCheckRegister(RegisterNo,IsHandled);
      if IsHandled then
        exit;

      GLReg.GET(RegisterNo);
      if GLReg.Reversed then
        ERROR(Text010,GLReg.TABLECAPTION,GLReg."No.");
      if GLReg."Journal Batch Name" = '' then
        TempReversalEntry.TestFieldError;
    end;
*/


    
//     procedure SetReverseFilter (Number@1001 : Integer;RevType@1000 :
    
/*
procedure SetReverseFilter (Number: Integer;RevType: Option "Transaction","Registe")
    begin
      if RevType = RevType::Transaction then begin
        GLEntry.SETCURRENTKEY("Transaction No.");
        CustLedgEntry.SETCURRENTKEY("Transaction No.");
        VendLedgEntry.SETCURRENTKEY("Transaction No.");
        EmployeeLedgerEntry.SETCURRENTKEY("Transaction No.");
        BankAccLedgEntry.SETCURRENTKEY("Transaction No.");
        FALedgEntry.SETCURRENTKEY("Transaction No.");
        MaintenanceLedgEntry.SETCURRENTKEY("Transaction No.");
        VATEntry.SETCURRENTKEY("Transaction No.");
        GLEntry.SETRANGE("Transaction No.",Number);
        CustLedgEntry.SETRANGE("Transaction No.",Number);
        VendLedgEntry.SETRANGE("Transaction No.",Number);
        EmployeeLedgerEntry.SETRANGE("Transaction No.",Number);
        BankAccLedgEntry.SETRANGE("Transaction No.",Number);
        FALedgEntry.SETRANGE("Transaction No.",Number);
        FALedgEntry.SETFILTER("G/L Entry No.",'<>%1',0);
        MaintenanceLedgEntry.SETRANGE("Transaction No.",Number);
        VATEntry.SETRANGE("Transaction No.",Number);
      end else begin
        GLReg.GET(Number);
        GLEntry.SETRANGE("Entry No.",GLReg."From Entry No.",GLReg."To Entry No.");
        CustLedgEntry.SETRANGE("Entry No.",GLReg."From Entry No.",GLReg."To Entry No.");
        VendLedgEntry.SETRANGE("Entry No.",GLReg."From Entry No.",GLReg."To Entry No.");
        EmployeeLedgerEntry.SETRANGE("Entry No.",GLReg."From Entry No.",GLReg."To Entry No.");
        BankAccLedgEntry.SETRANGE("Entry No.",GLReg."From Entry No.",GLReg."To Entry No.");
        FALedgEntry.SETCURRENTKEY("G/L Entry No.");
        FALedgEntry.SETRANGE("G/L Entry No.",GLReg."From Entry No.",GLReg."To Entry No.");
        MaintenanceLedgEntry.SETCURRENTKEY("G/L Entry No.");
        MaintenanceLedgEntry.SETRANGE("G/L Entry No.",GLReg."From Entry No.",GLReg."To Entry No.");
        VATEntry.SETRANGE("Entry No.",GLReg."From VAT Entry No.",GLReg."To VAT Entry No.");
      end;

      OnAfterSetReverseFilter(Number,RevType,GLReg);
    end;
*/


    
//     procedure CopyReverseFilters (var GLEntry2@1007 : Record 17;var CustLedgEntry2@1006 : Record 21;var VendLedgEntry2@1005 : Record 25;var BankAccLedgEntry2@1004 : Record 271;var VATEntry2@1003 : Record 254;var FALedgEntry2@1002 : Record 5601;var MaintenanceLedgEntry2@1001 : Record 5625;var EmployeeLedgerEntry2@1000 :
    
/*
procedure CopyReverseFilters (var GLEntry2: Record 17;var CustLedgEntry2: Record 21;var VendLedgEntry2: Record 25;var BankAccLedgEntry2: Record 271;var VATEntry2: Record 254;var FALedgEntry2: Record 5601;var MaintenanceLedgEntry2: Record 5625;var EmployeeLedgerEntry2: Record 5222)
    begin
      GLEntry2.COPY(GLEntry);
      CustLedgEntry2.COPY(CustLedgEntry);
      VendLedgEntry2.COPY(VendLedgEntry);
      EmployeeLedgerEntry2.COPY(EmployeeLedgerEntry);
      BankAccLedgEntry2.COPY(BankAccLedgEntry);
      VATEntry2.COPY(VATEntry);
      FALedgEntry2.COPY(FALedgEntry);
      MaintenanceLedgEntry2.COPY(MaintenanceLedgEntry);
    end;
*/


    
    
/*
procedure ShowGLEntries ()
    begin
      PAGE.RUN(0,GLEntry);
    end;
*/


    
    
/*
procedure ShowCustLedgEntries ()
    begin
      PAGE.RUN(0,CustLedgEntry);
    end;
*/


    
    
/*
procedure ShowVendLedgEntries ()
    begin
      PAGE.RUN(0,VendLedgEntry);
    end;
*/


    
    
/*
procedure ShowBankAccLedgEntries ()
    begin
      PAGE.RUN(0,BankAccLedgEntry);
    end;
*/


    
    
/*
procedure ShowFALedgEntries ()
    begin
      PAGE.RUN(0,FALedgEntry);
    end;
*/


    
    
/*
procedure ShowMaintenanceLedgEntries ()
    begin
      PAGE.RUN(0,MaintenanceLedgEntry);
    end;
*/


    
    
/*
procedure ShowVATEntries ()
    begin
      PAGE.RUN(0,VATEntry);
    end;
*/


    
    
/*
procedure Caption () : Text[250];
    var
//       GLAcc@1000 :
      GLAcc: Record 15;
//       GLEntry@1002 :
      GLEntry: Record 17;
//       Cust@1001 :
      Cust: Record 18;
//       CustLedgEntry@1003 :
      CustLedgEntry: Record 21;
//       Vend@1004 :
      Vend: Record 23;
//       VendLedgEntry@1005 :
      VendLedgEntry: Record 25;
//       Employee@1013 :
      Employee: Record 5200;
//       EmployeeLedgerEntry@1014 :
      EmployeeLedgerEntry: Record 5222;
//       BankAcc@1006 :
      BankAcc: Record 270;
//       BankAccLedgEntry@1007 :
      BankAccLedgEntry: Record 271;
//       FA@1008 :
      FA: Record 5600;
//       FALedgEntry@1009 :
      FALedgEntry: Record 5601;
//       MaintenanceLedgEntry@1011 :
      MaintenanceLedgEntry: Record 5625;
//       VATEntry@1010 :
      VATEntry: Record 254;
//       NewCaption@1012 :
      NewCaption: Text[250];
    begin
      CASE "Entry Type" OF
        "Entry Type"::"G/L Account":
          begin
            if GLEntry.GET("Entry No.") then;
            if GLAcc.GET(GLEntry."G/L Account No.") then;
            exit(STRSUBSTNO('%1 %2 %3',GLAcc.TABLECAPTION,GLAcc."No.",GLAcc.Name));
          end;
        "Entry Type"::Customer:
          begin
            if CustLedgEntry.GET("Entry No.") then;
            if Cust.GET(CustLedgEntry."Customer No.") then;
            exit(STRSUBSTNO('%1 %2 %3',Cust.TABLECAPTION,Cust."No.",Cust.Name));
          end;
        "Entry Type"::Vendor:
          begin
            if VendLedgEntry.GET("Entry No.") then;
            if Vend.GET(VendLedgEntry."Vendor No.") then;
            exit(STRSUBSTNO('%1 %2 %3',Vend.TABLECAPTION,Vend."No.",Vend.Name));
          end;
        "Entry Type"::Employee:
          begin
            if EmployeeLedgerEntry.GET("Entry No.") then;
            if Employee.GET(EmployeeLedgerEntry."Employee No.") then;
            exit(STRSUBSTNO('%1 %2 %3',Employee.TABLECAPTION,Employee."No.",Employee.FullName));
          end;
        "Entry Type"::"Bank Account":
          begin
            if BankAccLedgEntry.GET("Entry No.") then;
            if BankAcc.GET(BankAccLedgEntry."Bank Account No.") then;
            exit(STRSUBSTNO('%1 %2 %3',BankAcc.TABLECAPTION,BankAcc."No.",BankAcc.Name));
          end;
        "Entry Type"::"Fixed Asset":
          begin
            if FALedgEntry.GET("Entry No.") then;
            if FA.GET(FALedgEntry."FA No.") then;
            exit(STRSUBSTNO('%1 %2 %3',FA.TABLECAPTION,FA."No.",FA.Description));
          end;
        "Entry Type"::Maintenance:
          begin
            if MaintenanceLedgEntry.GET("Entry No.") then;
            if FA.GET(MaintenanceLedgEntry."FA No.") then;
            exit(STRSUBSTNO('%1 %2 %3',FA.TABLECAPTION,FA."No.",FA.Description));
          end;
        "Entry Type"::VAT:
          exit(STRSUBSTNO('%1',VATEntry.TABLECAPTION));
        else begin
          OnAfterCaption(Rec,NewCaption);
          exit(NewCaption);
        end;
      end;
    end;
*/


//     LOCAL procedure CheckPostingDate (PostingDate@1000 : Date;Caption@1002 : Text[50];EntryNo@1001 :
    
/*
LOCAL procedure CheckPostingDate (PostingDate: Date;Caption: Text[50];EntryNo: Integer)
    begin
      if GenJnlCheckLine.DateNotAllowed(PostingDate) then
        ERROR(Text001,Caption,EntryNo);
      if PostingDate > MaxPostingDate then
        MaxPostingDate := PostingDate;
    end;
*/


//     LOCAL procedure CheckFAPostingDate (FAPostingDate@1000 : Date;Caption@1004 : Text[50];EntryNo@1003 :
    
/*
LOCAL procedure CheckFAPostingDate (FAPostingDate: Date;Caption: Text[50];EntryNo: Integer)
    var
//       UserSetup@1001 :
      UserSetup: Record 91;
//       FASetup@1002 :
      FASetup: Record 5603;
    begin
      if (AllowPostingFrom = 0D) and (AllowPostingto = 0D) then begin
        if USERID <> '' then
          if UserSetup.GET(USERID) then begin
            AllowPostingFrom := UserSetup."Allow FA Posting From";
            AllowPostingto := UserSetup."Allow FA Posting To";
          end;
        if (AllowPostingFrom = 0D) and (AllowPostingto = 0D) then begin
          FASetup.GET;
          AllowPostingFrom := FASetup."Allow FA Posting From";
          AllowPostingto := FASetup."Allow FA Posting To";
        end;
        if AllowPostingto = 0D then
          AllowPostingto := 12319998D;
      end;
      if (FAPostingDate < AllowPostingFrom) or (FAPostingDate > AllowPostingto) then
        ERROR(Text005,Caption,EntryNo,FALedgEntry.FIELDCAPTION("FA Posting Date"));
      if FAPostingDate > MaxPostingDate then
        MaxPostingDate := FAPostingDate;
    end;
*/


    
    
/*
procedure TestFieldError ()
    begin
      ERROR(Text004);
    end;
*/


    
//     procedure AlreadyReversedEntry (Caption@1000 : Text[50];EntryNo@1001 :
    
/*
procedure AlreadyReversedEntry (Caption: Text[50];EntryNo: Integer)
    begin
      ERROR(Text011,Caption,EntryNo);
    end;
*/


    
//     procedure VerifyReversalEntries (var ReversalEntry2@1000 : Record 179;Number@1002 : Integer;RevType@1001 :
    
/*
procedure VerifyReversalEntries (var ReversalEntry2: Record 179;Number: Integer;RevType: Option "Transaction","Registe") : Boolean;
    begin
      InsertReversalEntry(Number,RevType);
      CLEAR(TempReversalEntry);
      CLEAR(ReversalEntry2);
      if ReversalEntry2.FINDSET then
        repeat
          if TempReversalEntry.NEXT = 0 then
            exit(FALSE);
          if not TempReversalEntry.Equal(ReversalEntry2) then
            exit(FALSE);
        until ReversalEntry2.NEXT = 0;
      exit(TempReversalEntry.NEXT = 0);
    end;
*/


    
//     procedure Equal (ReversalEntry2@1000 :
    
/*
procedure Equal (ReversalEntry2: Record 179) : Boolean;
    begin
      exit(
        ("Entry Type" = ReversalEntry2."Entry Type") and
        ("Entry No." = ReversalEntry2."Entry No."));
    end;
*/


    
//     procedure ReversalErrorForChangedEntry (TableName@1000 : Text[50];EntryNo@1001 :
    
/*
procedure ReversalErrorForChangedEntry (TableName: Text[50];EntryNo: Integer) : Text[1024];
    begin
      exit(STRSUBSTNO(Text000,TableName,EntryNo));
    end;
*/


    
//     procedure SetHideDialog (NewHideDialog@1000 :
    
/*
procedure SetHideDialog (NewHideDialog: Boolean)
    begin
      HideDialog := NewHideDialog;
    end;
*/


    
    
/*
procedure SetHideWarningDialogs ()
    begin
      HideDialog := TRUE;
      HideWarningDialogs := TRUE;
    end;
*/


//     LOCAL procedure UnrealizedVATReverseError (TableName@1001 : Text[50];EntryNo@1000 :
    
/*
LOCAL procedure UnrealizedVATReverseError (TableName: Text[50];EntryNo: Integer) : Text;
    begin
      exit(STRSUBSTNO(UnrealizedVATReverseErr,TableName,EntryNo));
    end;
*/


//     LOCAL procedure InsertFromCustLedgEntry (var TempRevertTransactionNo@1006 : TEMPORARY Record 2000000026;Number@1001 : Integer;RevType@1002 : 'Transaction,Register';var NextLineNo@1003 :
    
/*
LOCAL procedure InsertFromCustLedgEntry (var TempRevertTransactionNo: Record 2000000026 TEMPORARY;Number: Integer;RevType: Option "Transaction","Register";var NextLineNo: Integer)
    var
//       Cust@1000 :
      Cust: Record 18;
//       DtldCustLedgEntry@1004 :
      DtldCustLedgEntry: Record 379;
    begin
      DtldCustLedgEntry.SETCURRENTKEY("Transaction No.","Customer No.","Entry Type");
      DtldCustLedgEntry.SETFILTER(
        "Entry Type",'<>%1',DtldCustLedgEntry."Entry Type"::"Initial Entry");
      if CustLedgEntry.FINDSET then
        repeat
          DtldCustLedgEntry.SETRANGE("Transaction No.",CustLedgEntry."Transaction No.");
          DtldCustLedgEntry.SETRANGE("Customer No.",CustLedgEntry."Customer No.");
          if (not DtldCustLedgEntry.ISEMPTY) and (RevType = RevType::Register) then
            ERROR(PostedAndAppliedSameTransactionErr,Number);

          CLEAR(TempReversalEntry);
          if RevType = RevType::Register then
            TempReversalEntry."G/L Register No." := Number;
          TempReversalEntry."Reversal Type" := RevType;
          TempReversalEntry."Entry Type" := TempReversalEntry."Entry Type"::Customer;
          Cust.GET(CustLedgEntry."Customer No.");
          TempReversalEntry."Account No." := Cust."No.";
          TempReversalEntry."Account Name" := Cust.Name;
          TempReversalEntry.CopyFromCustLedgEntry(CustLedgEntry);
          TempReversalEntry."Line No." := NextLineNo;
          NextLineNo := NextLineNo + 1;
          TempReversalEntry.INSERT;

          DtldCustLedgEntry.SETRANGE(Unapplied,TRUE);
          if DtldCustLedgEntry.FINDSET then
            repeat
              InsertCustTempRevertTransNo(TempRevertTransactionNo,DtldCustLedgEntry."Unapplied by Entry No.");
            until DtldCustLedgEntry.NEXT = 0;
          DtldCustLedgEntry.SETRANGE(Unapplied);
        until CustLedgEntry.NEXT = 0;
    end;
*/


//     LOCAL procedure InsertFromVendLedgEntry (var TempRevertTransactionNo@1005 : TEMPORARY Record 2000000026;Number@1002 : Integer;RevType@1001 : 'Transaction,Register';var NextLineNo@1000 :
    
/*
LOCAL procedure InsertFromVendLedgEntry (var TempRevertTransactionNo: Record 2000000026 TEMPORARY;Number: Integer;RevType: Option "Transaction","Register";var NextLineNo: Integer)
    var
//       Vend@1003 :
      Vend: Record 23;
//       DtldVendLedgEntry@1004 :
      DtldVendLedgEntry: Record 380;
    begin
      DtldVendLedgEntry.SETCURRENTKEY("Transaction No.","Vendor No.","Entry Type");
      DtldVendLedgEntry.SETFILTER(
        "Entry Type",'<>%1',DtldVendLedgEntry."Entry Type"::"Initial Entry");
      if VendLedgEntry.FINDSET then
        repeat
          DtldVendLedgEntry.SETRANGE("Transaction No.",VendLedgEntry."Transaction No.");
          DtldVendLedgEntry.SETRANGE("Vendor No.",VendLedgEntry."Vendor No.");
          if (not DtldVendLedgEntry.ISEMPTY) and (RevType = RevType::Register) then
            ERROR(PostedAndAppliedSameTransactionErr,Number);

          CLEAR(TempReversalEntry);
          if RevType = RevType::Register then
            TempReversalEntry."G/L Register No." := Number;
          TempReversalEntry."Reversal Type" := RevType;
          TempReversalEntry."Entry Type" := TempReversalEntry."Entry Type"::Vendor;
          Vend.GET(VendLedgEntry."Vendor No.");
          TempReversalEntry."Account No." := Vend."No.";
          TempReversalEntry."Account Name" := Vend.Name;
          TempReversalEntry.CopyFromVendLedgEntry(VendLedgEntry);
          TempReversalEntry."Line No." := NextLineNo;
          NextLineNo := NextLineNo + 1;
          TempReversalEntry.INSERT;

          DtldVendLedgEntry.SETRANGE(Unapplied,TRUE);
          if DtldVendLedgEntry.FINDSET then
            repeat
              InsertVendTempRevertTransNo(TempRevertTransactionNo,DtldVendLedgEntry."Unapplied by Entry No.");
            until DtldVendLedgEntry.NEXT = 0;
          DtldVendLedgEntry.SETRANGE(Unapplied);
        until VendLedgEntry.NEXT = 0;
    end;
*/


//     LOCAL procedure InsertFromEmplLedgerEntry (var TempRevertTransactionNo@1003 : TEMPORARY Record 2000000026;Number@1002 : Integer;RevType@1001 : 'Transaction,Register';var NextLineNo@1000 :
    
/*
LOCAL procedure InsertFromEmplLedgerEntry (var TempRevertTransactionNo: Record 2000000026 TEMPORARY;Number: Integer;RevType: Option "Transaction","Register";var NextLineNo: Integer)
    var
//       DetailedEmployeeLedgerEntry@1004 :
      DetailedEmployeeLedgerEntry: Record 5223;
    begin
      DetailedEmployeeLedgerEntry.SETCURRENTKEY("Transaction No.","Employee No.","Entry Type");
      DetailedEmployeeLedgerEntry.SETFILTER(
        "Entry Type",'<>%1',DetailedEmployeeLedgerEntry."Entry Type"::"Initial Entry");

      if EmployeeLedgerEntry.FINDSET then
        repeat
          DetailedEmployeeLedgerEntry.SETRANGE("Transaction No.",EmployeeLedgerEntry."Transaction No.");
          DetailedEmployeeLedgerEntry.SETRANGE("Employee No.",EmployeeLedgerEntry."Employee No.");
          if (not DetailedEmployeeLedgerEntry.ISEMPTY) and (RevType = RevType::Register) then
            ERROR(PostedAndAppliedSameTransactionErr,Number);

          InsertTempReversalEntryEmployee(Number,RevType,NextLineNo);
          NextLineNo += 1;

          InsertTempRevertTransactionNoUnappliedEmployeeEntries(TempRevertTransactionNo,DetailedEmployeeLedgerEntry);

        until EmployeeLedgerEntry.NEXT = 0;
    end;
*/


//     LOCAL procedure InsertFromBankAccLedgEntry (Number@1002 : Integer;RevType@1001 : 'Transaction,Register';var NextLineNo@1000 :
    
/*
LOCAL procedure InsertFromBankAccLedgEntry (Number: Integer;RevType: Option "Transaction","Register";var NextLineNo: Integer)
    var
//       BankAcc@1003 :
      BankAcc: Record 270;
    begin
      if BankAccLedgEntry.FINDSET then
        repeat
          CLEAR(TempReversalEntry);
          if RevType = RevType::Register then
            TempReversalEntry."G/L Register No." := Number;
          TempReversalEntry."Reversal Type" := RevType;
          TempReversalEntry."Entry Type" := TempReversalEntry."Entry Type"::"Bank Account";
          BankAcc.GET(BankAccLedgEntry."Bank Account No.");
          TempReversalEntry."Account No." := BankAcc."No.";
          TempReversalEntry."Account Name" := BankAcc.Name;
          TempReversalEntry.CopyFromBankAccLedgEntry(BankAccLedgEntry);
          TempReversalEntry."Line No." := NextLineNo;
          NextLineNo := NextLineNo + 1;
          TempReversalEntry.INSERT;
        until BankAccLedgEntry.NEXT = 0;
    end;
*/


//     LOCAL procedure InsertFromFALedgEntry (Number@1002 : Integer;RevType@1001 : 'Transaction,Register';var NextLineNo@1000 :
    
/*
LOCAL procedure InsertFromFALedgEntry (Number: Integer;RevType: Option "Transaction","Register";var NextLineNo: Integer)
    var
//       FA@1003 :
      FA: Record 5600;
    begin
      if FALedgEntry.FINDSET then
        repeat
          CLEAR(TempReversalEntry);
          if RevType = RevType::Register then
            TempReversalEntry."G/L Register No." := Number;
          TempReversalEntry."Reversal Type" := RevType;
          TempReversalEntry."Entry Type" := TempReversalEntry."Entry Type"::"Fixed Asset";
          FA.GET(FALedgEntry."FA No.");
          TempReversalEntry."Account No." := FA."No.";
          TempReversalEntry."Account Name" := FA.Description;
          TempReversalEntry.CopyFromFALedgEntry(FALedgEntry);
          if FALedgEntry."FA Posting Type" <> FALedgEntry."FA Posting Type"::"Salvage Value" then begin
            TempReversalEntry."Line No." := NextLineNo;
            NextLineNo := NextLineNo + 1;
            TempReversalEntry.INSERT;
          end;
        until FALedgEntry.NEXT = 0;
    end;
*/


//     LOCAL procedure InsertFromMaintenanceLedgEntry (Number@1002 : Integer;RevType@1001 : 'Transaction,Register';var NextLineNo@1000 :
    
/*
LOCAL procedure InsertFromMaintenanceLedgEntry (Number: Integer;RevType: Option "Transaction","Register";var NextLineNo: Integer)
    var
//       FA@1003 :
      FA: Record 5600;
    begin
      if MaintenanceLedgEntry.FINDSET then
        repeat
          CLEAR(TempReversalEntry);
          if RevType = RevType::Register then
            TempReversalEntry."G/L Register No." := Number;
          TempReversalEntry."Reversal Type" := RevType;
          TempReversalEntry."Entry Type" := TempReversalEntry."Entry Type"::Maintenance;
          FA.GET(MaintenanceLedgEntry."FA No.");
          TempReversalEntry."Account No." := FA."No.";
          TempReversalEntry."Account Name" := FA.Description;
          TempReversalEntry.CopyFromMaintenanceEntry(MaintenanceLedgEntry);
          TempReversalEntry."Line No." := NextLineNo;
          NextLineNo := NextLineNo + 1;
          TempReversalEntry.INSERT;
        until MaintenanceLedgEntry.NEXT = 0;
    end;
*/


//     LOCAL procedure InsertFromVATEntry (var TempRevertTransactionNo@1004 : TEMPORARY Record 2000000026;Number@1002 : Integer;RevType@1001 : 'Transaction,Register';var NextLineNo@1000 :
    
/*
LOCAL procedure InsertFromVATEntry (var TempRevertTransactionNo: Record 2000000026 TEMPORARY;Number: Integer;RevType: Option "Transaction","Register";var NextLineNo: Integer)
    begin
      TempRevertTransactionNo.FINDSET;
      repeat
        if RevType = RevType::Transaction then
          VATEntry.SETRANGE("Transaction No.",TempRevertTransactionNo.Number);
        if VATEntry.FINDSET then
          repeat
            CLEAR(TempReversalEntry);
            if RevType = RevType::Register then
              TempReversalEntry."G/L Register No." := Number;
            TempReversalEntry."Reversal Type" := RevType;
            TempReversalEntry."Entry Type" := TempReversalEntry."Entry Type"::VAT;
            TempReversalEntry.CopyFromVATEntry(VATEntry);
            TempReversalEntry."Line No." := NextLineNo;
            NextLineNo := NextLineNo + 1;
            TempReversalEntry.INSERT;
          until VATEntry.NEXT = 0;
      until TempRevertTransactionNo.NEXT = 0;
    end;
*/


//     LOCAL procedure InsertFromGLEntry (var TempRevertTransactionNo@1005 : TEMPORARY Record 2000000026;Number@1002 : Integer;RevType@1001 : 'Transaction,Register';var NextLineNo@1000 :
    
/*
LOCAL procedure InsertFromGLEntry (var TempRevertTransactionNo: Record 2000000026 TEMPORARY;Number: Integer;RevType: Option "Transaction","Register";var NextLineNo: Integer)
    var
//       GLAcc@1004 :
      GLAcc: Record 15;
    begin
      TempRevertTransactionNo.FINDSET;
      repeat
        if RevType = RevType::Transaction then
          GLEntry.SETRANGE("Transaction No.",TempRevertTransactionNo.Number);
        if GLEntry.FINDSET then
          repeat
            CLEAR(TempReversalEntry);
            if RevType = RevType::Register then
              TempReversalEntry."G/L Register No." := Number;
            TempReversalEntry."Reversal Type" := RevType;
            TempReversalEntry."Entry Type" := TempReversalEntry."Entry Type"::"G/L Account";
            if not GLAcc.GET(GLEntry."G/L Account No.") then
              ERROR(CannotReverseDeletedErr,GLEntry.TABLECAPTION,GLAcc.TABLECAPTION);
            TempReversalEntry."Account No." := GLAcc."No.";
            TempReversalEntry."Account Name" := GLAcc.Name;
            TempReversalEntry.CopyFromGLEntry(GLEntry);
            TempReversalEntry."Line No." := NextLineNo;
            NextLineNo := NextLineNo + 1;
            TempReversalEntry.INSERT;
          until GLEntry.NEXT = 0;
      until TempRevertTransactionNo.NEXT = 0;
    end;
*/


//     LOCAL procedure InsertTempReversalEntryEmployee (Number@1004 : Integer;RevType@1003 : 'Transaction,Register';NextLineNo@1002 :
    
/*
LOCAL procedure InsertTempReversalEntryEmployee (Number: Integer;RevType: Option "Transaction","Register";NextLineNo: Integer)
    var
//       Employee@1000 :
      Employee: Record 5200;
    begin
      CLEAR(TempReversalEntry);
      if RevType = RevType::Register then
        TempReversalEntry."G/L Register No." := Number;
      TempReversalEntry."Reversal Type" := RevType;
      TempReversalEntry."Entry Type" := TempReversalEntry."Entry Type"::Employee;
      Employee.GET(EmployeeLedgerEntry."Employee No.");
      TempReversalEntry."Account No." := Employee."No.";
      TempReversalEntry."Account Name" := COPYSTR(Employee.FullName,1,MAXSTRLEN(TempReversalEntry."Account Name"));
      TempReversalEntry.CopyFromEmployeeLedgerEntry(EmployeeLedgerEntry);
      TempReversalEntry."Line No." := NextLineNo;
      TempReversalEntry.INSERT;
    end;
*/


    
//     procedure CopyFromCustLedgEntry (CustLedgEntry@1001 :
    
/*
procedure CopyFromCustLedgEntry (CustLedgEntry: Record 21)
    begin
      "Entry No." := CustLedgEntry."Entry No.";
      "Posting Date" := CustLedgEntry."Posting Date";
      "Source Code" := CustLedgEntry."Source Code";
      "Journal Batch Name" := CustLedgEntry."Journal Batch Name";
      "Transaction No." := CustLedgEntry."Transaction No.";
      "Currency Code" := CustLedgEntry."Currency Code";
      Description := CustLedgEntry.Description;
      CustLedgEntry.CALCFIELDS(Amount,"Debit Amount","Credit Amount",
        "Amount (LCY)","Debit Amount (LCY)","Credit Amount (LCY)");
      Amount := CustLedgEntry.Amount;
      "Debit Amount" := CustLedgEntry."Debit Amount";
      "Credit Amount" := CustLedgEntry."Credit Amount";
      "Amount (LCY)" := CustLedgEntry."Amount (LCY)";
      "Debit Amount (LCY)" := CustLedgEntry."Debit Amount (LCY)";
      "Credit Amount (LCY)" := CustLedgEntry."Credit Amount (LCY)";
      "Document Type" := CustLedgEntry."Document Type";
      "Document No." := CustLedgEntry."Document No.";
      "Bal. Account Type" := CustLedgEntry."Bal. Account Type";
      "Bal. Account No." := CustLedgEntry."Bal. Account No.";

      OnAfterCopyFromCustLedgEntry(Rec,CustLedgEntry);
    end;
*/


    
//     procedure CopyFromBankAccLedgEntry (BankAccLedgEntry@1001 :
    
/*
procedure CopyFromBankAccLedgEntry (BankAccLedgEntry: Record 271)
    begin
      "Entry No." := BankAccLedgEntry."Entry No.";
      "Posting Date" := BankAccLedgEntry."Posting Date";
      "Source Code" := BankAccLedgEntry."Source Code";
      "Journal Batch Name" := BankAccLedgEntry."Journal Batch Name";
      "Transaction No." := BankAccLedgEntry."Transaction No.";
      "Currency Code" := BankAccLedgEntry."Currency Code";
      Description := BankAccLedgEntry.Description;
      Amount := BankAccLedgEntry.Amount;
      "Debit Amount" := BankAccLedgEntry."Debit Amount";
      "Credit Amount" := BankAccLedgEntry."Credit Amount";
      "Amount (LCY)" := BankAccLedgEntry."Amount (LCY)";
      "Debit Amount (LCY)" := BankAccLedgEntry."Debit Amount (LCY)";
      "Credit Amount (LCY)" := BankAccLedgEntry."Credit Amount (LCY)";
      "Document Type" := BankAccLedgEntry."Document Type";
      "Document No." := BankAccLedgEntry."Document No.";
      "Bal. Account Type" := BankAccLedgEntry."Bal. Account Type";
      "Bal. Account No." := BankAccLedgEntry."Bal. Account No.";

      OnAfterCopyFromBankAccLedgEntry(Rec,BankAccLedgEntry);
    end;
*/


    
//     procedure CopyFromFALedgEntry (FALedgEntry@1001 :
    
/*
procedure CopyFromFALedgEntry (FALedgEntry: Record 5601)
    begin
      "Entry No." := FALedgEntry."Entry No.";
      "Posting Date" := FALedgEntry."Posting Date";
      "FA Posting Category" := FALedgEntry."FA Posting Category";
      "FA Posting Type" := FALedgEntry."FA Posting Type" + 1;
      "Source Code" := FALedgEntry."Source Code";
      "Journal Batch Name" := FALedgEntry."Journal Batch Name";
      "Transaction No." := FALedgEntry."Transaction No.";
      Description := FALedgEntry.Description;
      "Amount (LCY)" := FALedgEntry.Amount;
      "Debit Amount (LCY)" := FALedgEntry."Debit Amount";
      "Credit Amount (LCY)" := FALedgEntry."Credit Amount";
      "VAT Amount" := FALedgEntry."VAT Amount";
      "Document Type" := FALedgEntry."Document Type";
      "Document No." := FALedgEntry."Document No.";
      "Bal. Account Type" := FALedgEntry."Bal. Account Type";
      "Bal. Account No." := FALedgEntry."Bal. Account No.";

      OnAfterCopyFromFALedgEntry(Rec,FALedgEntry);
    end;
*/


    
//     procedure CopyFromGLEntry (GLEntry@1000 :
    
/*
procedure CopyFromGLEntry (GLEntry: Record 17)
    begin
      "Entry No." := GLEntry."Entry No.";
      "Posting Date" := GLEntry."Posting Date";
      "Source Code" := GLEntry."Source Code";
      "Journal Batch Name" := GLEntry."Journal Batch Name";
      "Transaction No." := GLEntry."Transaction No.";
      "Source Type" := GLEntry."Source Type";
      "Source No." := GLEntry."Source No.";
      Description := GLEntry.Description;
      "Amount (LCY)" := GLEntry.Amount;
      "Debit Amount (LCY)" := GLEntry."Debit Amount";
      "Credit Amount (LCY)" := GLEntry."Credit Amount";
      "VAT Amount" := GLEntry."VAT Amount";
      "Document Type" := GLEntry."Document Type";
      "Document No." := GLEntry."Document No.";
      "Bal. Account Type" := GLEntry."Bal. Account Type";
      "Bal. Account No." := GLEntry."Bal. Account No.";

      OnAfterCopyFromGLEntry(Rec,GLEntry);
    end;
*/


    
//     procedure CopyFromMaintenanceEntry (MaintenanceLedgEntry@1001 :
    
/*
procedure CopyFromMaintenanceEntry (MaintenanceLedgEntry: Record 5625)
    begin
      "Entry No." := MaintenanceLedgEntry."Entry No.";
      "Posting Date" := MaintenanceLedgEntry."Posting Date";
      "Source Code" := MaintenanceLedgEntry."Source Code";
      "Journal Batch Name" := MaintenanceLedgEntry."Journal Batch Name";
      "Transaction No." := MaintenanceLedgEntry."Transaction No.";
      Description := MaintenanceLedgEntry.Description;
      "Amount (LCY)" := MaintenanceLedgEntry.Amount;
      "Debit Amount (LCY)" := MaintenanceLedgEntry."Debit Amount";
      "Credit Amount (LCY)" := MaintenanceLedgEntry."Credit Amount";
      "VAT Amount" := MaintenanceLedgEntry."VAT Amount";
      "Document Type" := MaintenanceLedgEntry."Document Type";
      "Document No." := MaintenanceLedgEntry."Document No.";
      "Bal. Account Type" := MaintenanceLedgEntry."Bal. Account Type";
      "Bal. Account No." := MaintenanceLedgEntry."Bal. Account No.";

      OnAfterCopyFromMaintenanceEntry(Rec,MaintenanceLedgEntry);
    end;
*/


    
//     procedure CopyFromVATEntry (VATEntry@1001 :
    
/*
procedure CopyFromVATEntry (VATEntry: Record 254)
    begin
      "Entry No." := VATEntry."Entry No.";
      "Posting Date" := VATEntry."Posting Date";
      "Source Code" := VATEntry."Source Code";
      "Transaction No." := VATEntry."Transaction No.";
      Amount := VATEntry.Amount;
      "Amount (LCY)" := VATEntry.Amount;
      "Document Type" := VATEntry."Document Type";
      "Document No." := VATEntry."Document No.";

      OnAfterCopyFromVATEntry(Rec,VATEntry);
    end;
*/


    
//     procedure CopyFromVendLedgEntry (VendLedgEntry@1001 :
    
/*
procedure CopyFromVendLedgEntry (VendLedgEntry: Record 25)
    begin
      "Entry No." := VendLedgEntry."Entry No.";
      "Posting Date" := VendLedgEntry."Posting Date";
      "Source Code" := VendLedgEntry."Source Code";
      "Journal Batch Name" := VendLedgEntry."Journal Batch Name";
      "Transaction No." := VendLedgEntry."Transaction No.";
      "Currency Code" := VendLedgEntry."Currency Code";
      Description := VendLedgEntry.Description;
      VendLedgEntry.CALCFIELDS(Amount,"Debit Amount","Credit Amount",
        "Amount (LCY)","Debit Amount (LCY)","Credit Amount (LCY)");
      Amount := VendLedgEntry.Amount;
      "Debit Amount" := VendLedgEntry."Debit Amount";
      "Credit Amount" := VendLedgEntry."Credit Amount";
      "Amount (LCY)" := VendLedgEntry."Amount (LCY)";
      "Debit Amount (LCY)" := VendLedgEntry."Debit Amount (LCY)";
      "Credit Amount (LCY)" := VendLedgEntry."Credit Amount (LCY)";
      "Document Type" := VendLedgEntry."Document Type";
      "Document No." := VendLedgEntry."Document No.";
      "Bal. Account Type" := VendLedgEntry."Bal. Account Type";
      "Bal. Account No." := VendLedgEntry."Bal. Account No.";

      OnAfterCopyFromVendLedgEntry(Rec,VendLedgEntry);
    end;
*/


    
//     procedure CopyFromEmployeeLedgerEntry (EmployeeLedgerEntry@1000 :
    
/*
procedure CopyFromEmployeeLedgerEntry (EmployeeLedgerEntry: Record 5222)
    begin
      "Entry No." := EmployeeLedgerEntry."Entry No.";
      "Posting Date" := EmployeeLedgerEntry."Posting Date";
      "Source Code" := EmployeeLedgerEntry."Source Code";
      "Journal Batch Name" := EmployeeLedgerEntry."Journal Batch Name";
      "Transaction No." := EmployeeLedgerEntry."Transaction No.";
      "Currency Code" := EmployeeLedgerEntry."Currency Code";
      Description := EmployeeLedgerEntry.Description;
      EmployeeLedgerEntry.CALCFIELDS(
        Amount,"Debit Amount","Credit Amount","Amount (LCY)","Debit Amount (LCY)","Credit Amount (LCY)");
      Amount := EmployeeLedgerEntry.Amount;
      "Debit Amount" := EmployeeLedgerEntry."Debit Amount";
      "Credit Amount" := EmployeeLedgerEntry."Credit Amount";
      "Amount (LCY)" := EmployeeLedgerEntry."Amount (LCY)";
      "Debit Amount (LCY)" := EmployeeLedgerEntry."Debit Amount (LCY)";
      "Credit Amount (LCY)" := EmployeeLedgerEntry."Credit Amount (LCY)";
      "Document Type" := EmployeeLedgerEntry."Document Type";
      "Document No." := EmployeeLedgerEntry."Document No.";
      "Bal. Account Type" := EmployeeLedgerEntry."Bal. Account Type";
      "Bal. Account No." := EmployeeLedgerEntry."Bal. Account No.";

      OnAfterCopyFromEmplLedgEntry(Rec,EmployeeLedgerEntry);
    end;
*/


//     LOCAL procedure InsertCustTempRevertTransNo (var TempRevertTransactionNo@1000 : TEMPORARY Record 2000000026;CustLedgEntryNo@1001 :
    
/*
LOCAL procedure InsertCustTempRevertTransNo (var TempRevertTransactionNo: Record 2000000026 TEMPORARY;CustLedgEntryNo: Integer)
    var
//       DtldCustLedgEntry@1002 :
      DtldCustLedgEntry: Record 379;
    begin
      DtldCustLedgEntry.GET(CustLedgEntryNo);
      if DtldCustLedgEntry."Transaction No." <> 0 then begin
        TempRevertTransactionNo.Number := DtldCustLedgEntry."Transaction No.";
        if TempRevertTransactionNo.INSERT then;
      end;
    end;
*/


//     LOCAL procedure InsertVendTempRevertTransNo (var TempRevertTransactionNo@1000 : TEMPORARY Record 2000000026;VendLedgEntryNo@1001 :
    
/*
LOCAL procedure InsertVendTempRevertTransNo (var TempRevertTransactionNo: Record 2000000026 TEMPORARY;VendLedgEntryNo: Integer)
    var
//       DtldVendLedgEntry@1002 :
      DtldVendLedgEntry: Record 380;
    begin
      DtldVendLedgEntry.GET(VendLedgEntryNo);
      if DtldVendLedgEntry."Transaction No." <> 0 then begin
        TempRevertTransactionNo.Number := DtldVendLedgEntry."Transaction No.";
        if TempRevertTransactionNo.INSERT then;
      end;
    end;
*/


//     LOCAL procedure InsertEmplTempRevertTransNo (var TempRevertTransactionNo@1001 : TEMPORARY Record 2000000026;EmployeeLedgEntryNo@1000 :
    
/*
LOCAL procedure InsertEmplTempRevertTransNo (var TempRevertTransactionNo: Record 2000000026 TEMPORARY;EmployeeLedgEntryNo: Integer)
    var
//       DetailedEmployeeLedgerEntry@1002 :
      DetailedEmployeeLedgerEntry: Record 5223;
    begin
      DetailedEmployeeLedgerEntry.GET(EmployeeLedgEntryNo);
      if DetailedEmployeeLedgerEntry."Transaction No." <> 0 then begin
        TempRevertTransactionNo.Number := DetailedEmployeeLedgerEntry."Transaction No.";
        if TempRevertTransactionNo.INSERT then;
      end;
    end;
*/


//     LOCAL procedure InsertTempRevertTransactionNoUnappliedEmployeeEntries (var TempRevertTransactionNo@1001 : TEMPORARY Record 2000000026;var DetailedEmployeeLedgerEntry@1000 :
    
/*
LOCAL procedure InsertTempRevertTransactionNoUnappliedEmployeeEntries (var TempRevertTransactionNo: Record 2000000026 TEMPORARY;var DetailedEmployeeLedgerEntry: Record 5223)
    begin
      DetailedEmployeeLedgerEntry.SETRANGE(Unapplied,TRUE);
      if DetailedEmployeeLedgerEntry.FINDSET then
        repeat
          InsertEmplTempRevertTransNo(TempRevertTransactionNo,DetailedEmployeeLedgerEntry."Unapplied by Entry No.");
        until DetailedEmployeeLedgerEntry.NEXT = 0;
      DetailedEmployeeLedgerEntry.SETRANGE(Unapplied);
    end;
*/


    
//     LOCAL procedure OnAfterCaption (ReversalEntry@1000 : Record 179;var NewCaption@1001 :
    
/*
LOCAL procedure OnAfterCaption (ReversalEntry: Record 179;var NewCaption: Text[250])
    begin
    end;
*/


    
    
/*
LOCAL procedure OnAfterCheckEntries ()
    begin
    end;
*/


    
//     LOCAL procedure OnAfterCheckBankAcc (BankAccount@1000 : Record 270;BankAccountLedgerEntry@1001 :
    
/*
LOCAL procedure OnAfterCheckBankAcc (BankAccount: Record 270;BankAccountLedgerEntry: Record 271)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterCheckGLAcc (var GLAccount@1000 : Record 15;GLEntry@1001 :
    
/*
LOCAL procedure OnAfterCheckGLAcc (var GLAccount: Record 15;GLEntry: Record 17)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterCheckCust (Customer@1000 : Record 18;CustLedgerEntry@1001 :
    
/*
LOCAL procedure OnAfterCheckCust (Customer: Record 18;CustLedgerEntry: Record 21)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterCheckVend (Vendor@1000 : Record 23;VendorLedgerEntry@1001 :
    
/*
LOCAL procedure OnAfterCheckVend (Vendor: Record 23;VendorLedgerEntry: Record 25)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterCheckEmpl (Employee@1000 : Record 5200;EmployeeLedgerEntry@1001 :
    
/*
LOCAL procedure OnAfterCheckEmpl (Employee: Record 5200;EmployeeLedgerEntry: Record 5222)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterCheckFA (FixedAsset@1000 : Record 5600;FALedgerEntry@1001 :
    
/*
LOCAL procedure OnAfterCheckFA (FixedAsset: Record 5600;FALedgerEntry: Record 5601)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterCheckMaintenance (FixedAsset@1000 : Record 5600;MaintenanceLedgerEntry@1001 :
    
/*
LOCAL procedure OnAfterCheckMaintenance (FixedAsset: Record 5600;MaintenanceLedgerEntry: Record 5625)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterCheckVAT (var VATEntry@1000 :
    
/*
LOCAL procedure OnAfterCheckVAT (var VATEntry: Record 254)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterCheckDtldCustLedgEntry (DetailedCustLedgEntry@1000 : Record 379;CustLedgerEntry@1001 :
    
/*
LOCAL procedure OnAfterCheckDtldCustLedgEntry (DetailedCustLedgEntry: Record 379;CustLedgerEntry: Record 21)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterCheckDtldVendLedgEntry (DetailedVendorLedgEntry@1000 : Record 380;VendorLedgerEntry@1001 :
    
/*
LOCAL procedure OnAfterCheckDtldVendLedgEntry (DetailedVendorLedgEntry: Record 380;VendorLedgerEntry: Record 25)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterCheckDtldEmplLedgEntry (DetailedEmployeeLedgerEntry@1000 : Record 5223;EmployeeLedgerEntry@1001 :
    
/*
LOCAL procedure OnAfterCheckDtldEmplLedgEntry (DetailedEmployeeLedgerEntry: Record 5223;EmployeeLedgerEntry: Record 5222)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterCopyFromBankAccLedgEntry (var ReversalEntry@1000 : Record 179;BankAccLedgEntry@1001 :
    
/*
LOCAL procedure OnAfterCopyFromBankAccLedgEntry (var ReversalEntry: Record 179;BankAccLedgEntry: Record 271)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterCopyFromCustLedgEntry (var ReversalEntry@1000 : Record 179;CustLedgerEntry@1001 :
    
/*
LOCAL procedure OnAfterCopyFromCustLedgEntry (var ReversalEntry: Record 179;CustLedgerEntry: Record 21)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterCopyFromFALedgEntry (var ReversalEntry@1000 : Record 179;FALedgerEntry@1001 :
    
/*
LOCAL procedure OnAfterCopyFromFALedgEntry (var ReversalEntry: Record 179;FALedgerEntry: Record 5601)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterCopyFromGLEntry (var ReversalEntry@1000 : Record 179;GLEntry@1001 :
    
/*
LOCAL procedure OnAfterCopyFromGLEntry (var ReversalEntry: Record 179;GLEntry: Record 17)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterCopyFromMaintenanceEntry (var ReversalEntry@1000 : Record 179;MaintenanceLedgerEntry@1001 :
    
/*
LOCAL procedure OnAfterCopyFromMaintenanceEntry (var ReversalEntry: Record 179;MaintenanceLedgerEntry: Record 5625)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterCopyFromVATEntry (var ReversalEntry@1000 : Record 179;VATEntry@1001 :
    
/*
LOCAL procedure OnAfterCopyFromVATEntry (var ReversalEntry: Record 179;VATEntry: Record 254)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterCopyFromVendLedgEntry (var ReversalEntry@1000 : Record 179;VendorLedgerEntry@1001 :
    
/*
LOCAL procedure OnAfterCopyFromVendLedgEntry (var ReversalEntry: Record 179;VendorLedgerEntry: Record 25)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterCopyFromEmplLedgEntry (var ReversalEntry@1000 : Record 179;EmployeeLedgerEntry@1001 :
    
/*
LOCAL procedure OnAfterCopyFromEmplLedgEntry (var ReversalEntry: Record 179;EmployeeLedgerEntry: Record 5222)
    begin
    end;

    [Integration(TRUE,TRUE)]
*/

//     LOCAL procedure OnAfterInsertReversalEntry (var TempRevertTransactionNo@1000 : Record 2000000026;Number@1002 : Integer;RevType@1001 : 'Transaction,Register';var NextLineNo@1003 :
    
/*
LOCAL procedure OnAfterInsertReversalEntry (var TempRevertTransactionNo: Record 2000000026;Number: Integer;RevType: Option "Transaction","Register";var NextLineNo: Integer)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterSetReverseFilter (Number@1001 : Integer;RevType@1000 : 'Transaction,Register';GLRegister@1002 :
    
/*
LOCAL procedure OnAfterSetReverseFilter (Number: Integer;RevType: Option "Transaction","Register";GLRegister: Record 45)
    begin
    end;
*/


    
//     LOCAL procedure OnBeforeCheckEntries (ReversalEntry@1000 : Record 179;TableID@1001 : Integer;var SkipCheck@1002 :
    
/*
LOCAL procedure OnBeforeCheckEntries (ReversalEntry: Record 179;TableID: Integer;var SkipCheck: Boolean)
    begin
    end;
*/


    
//     LOCAL procedure OnBeforeCheckRegister (RegisterNo@1000 : Integer;var IsHandled@1001 :
    
/*
LOCAL procedure OnBeforeCheckRegister (RegisterNo: Integer;var IsHandled: Boolean)
    begin
    end;
*/


    
//     LOCAL procedure OnBeforeReverseEntries (Number@1000 : Integer;RevType@1001 : Integer;var IsHandled@1002 :
    
/*
LOCAL procedure OnBeforeReverseEntries (Number: Integer;RevType: Integer;var IsHandled: Boolean)
    begin
    end;

    /*begin
    end.
  */
}





