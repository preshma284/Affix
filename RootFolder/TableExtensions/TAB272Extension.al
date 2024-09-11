tableextension 50161 "MyExtension50161" extends "Check Ledger Entry"
{
  
  
    CaptionML=ENU='Check Ledger Entry',ESP='Mov. cheque';
    LookupPageID="Check Ledger Entries";
    DrillDownPageID="Check Ledger Entries";
  
  fields
{
    field(7207270;"Payment Relation";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='N§ Relaci¢n Pagos';
                                                   Description='QB 1.1 Relaci¢n de pagos en que se incluye';


    }
    field(7207271;"Due Date";Date)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Fecha Vto.';
                                                   Description='QB 1.1 Fecha de vto del pagar‚' ;


    }
}
  keys
{
   // key(key1;"Entry No.")
  //  {
       /* Clustered=true;
 */
   // }
   // key(key2;"Bank Account No.","Check Date")
  //  {
       /* ;
 */
   // }
    key(Extkey3;"Bank Account No.","Entry Status","Check No.")
    {
        ;
    }
   // key(key4;"Bank Account No.","Entry Status","Check No.","Statement Status")
  //  {
       /* ;
 */
   // }
   // key(key5;"Bank Account No.","Open")
  //  {
       /* ;
 */
   // }
}
  fieldgroups
{
}
  
    var
//       NothingToExportErr@1000 :
      NothingToExportErr: TextConst ENU='There is nothing to export.',ESP='No hay nada que exportar.';

    
    
/*
procedure GetCurrencyCodeFromBank () : Code[10];
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


    
//     procedure CopyFromBankAccLedgEntry (BankAccLedgEntry@1000 :
    
/*
procedure CopyFromBankAccLedgEntry (BankAccLedgEntry: Record 271)
    begin
      "Bank Account No." := BankAccLedgEntry."Bank Account No.";
      "Bank Account Ledger Entry No." := BankAccLedgEntry."Entry No.";
      "Posting Date" := BankAccLedgEntry."Posting Date";
      "Document Type" := BankAccLedgEntry."Document Type";
      "Document No." := BankAccLedgEntry."Document No.";
      "External Document No." := BankAccLedgEntry."External Document No.";
      Description := BankAccLedgEntry.Description;
      "Bank Payment Type" := "Bank Payment Type";
      "Bal. Account Type" := BankAccLedgEntry."Bal. Account Type";
      "Bal. Account No." := BankAccLedgEntry."Bal. Account No.";
      "Entry Status" := "Entry Status"::Posted;
      Open := TRUE;
      "User ID" := USERID;
      "Check Date" := BankAccLedgEntry."Posting Date";
      "Check No." := BankAccLedgEntry."Document No.";

      OnAfterCopyFromBankAccLedgEntry(Rec,BankAccLedgEntry);
    end;
*/


    
    
/*
procedure ExportCheckFile ()
    var
//       BankAcc@1000 :
      BankAcc: Record 270;
    begin
      if not FINDSET then
        ERROR(NothingToExportErr);

      if not BankAcc.GET("Bank Account No.") then
        ERROR(NothingToExportErr);

      if BankAcc.GetPosPayExportCodeunitID > 0 then
        CODEUNIT.RUN(BankAcc.GetPosPayExportCodeunitID,Rec)
      else
        CODEUNIT.RUN(CODEUNIT::"Exp. Launcher Pos. Pay",Rec);
    end;
*/


    
    
/*
procedure GetPayee () Payee : Text[50];
    var
//       Vendor@1003 :
      Vendor: Record 23;
//       Customer@1002 :
      Customer: Record 18;
//       GLAccount@1001 :
      GLAccount: Record 15;
//       BankAccount@1000 :
      BankAccount: Record 270;
    begin
      CASE "Bal. Account Type" OF
        "Bal. Account Type"::"G/L Account":
          if "Bal. Account No." <> '' then begin
            GLAccount.GET("Bal. Account No.");
            Payee := GLAccount.Name;
          end;
        "Bal. Account Type"::Customer:
          if "Bal. Account No." <> '' then begin
            Customer.GET("Bal. Account No.");
            Payee := Customer.Name;
          end;
        "Bal. Account Type"::Vendor:
          if "Bal. Account No." <> '' then begin
            Vendor.GET("Bal. Account No.");
            Payee := Vendor.Name;
          end;
        "Bal. Account Type"::"Bank Account":
          if "Bal. Account No." <> '' then begin
            BankAccount.GET("Bal. Account No.");
            Payee := BankAccount.Name;
          end;
        "Bal. Account Type"::"Fixed Asset":
          Payee := "Bal. Account No.";
      end;
    end;
*/


    
//     procedure SetFilterBankAccNoOpen (BankAccNo@1000 :
    
/*
procedure SetFilterBankAccNoOpen (BankAccNo: Code[20])
    begin
      RESET;
      SETCURRENTKEY("Bank Account No.",Open);
      SETRANGE("Bank Account No.",BankAccNo);
      SETRANGE(Open,TRUE);
    end;
*/


    
    
//     procedure OnAfterCopyFromBankAccLedgEntry (var CheckLedgerEntry@1000 : Record 272;BankAccountLedgerEntry@1001 :
    
/*
procedure OnAfterCopyFromBankAccLedgEntry (var CheckLedgerEntry: Record 272;BankAccountLedgerEntry: Record 271)
    begin
    end;

    /*begin
    //{
//      JAV 08/05/19: A¤adido el campo 50010 "No. Relacion" con la Relaci¢n el que se incluye
//    }
    end.
  */
}




