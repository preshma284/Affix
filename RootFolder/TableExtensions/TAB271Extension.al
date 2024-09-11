tableextension 50160 "MyExtension50160" extends "Bank Account Ledger Entry"
{
  
  
    CaptionML=ENU='Bank Account Ledger Entry',ESP='Mov. banco';
    LookupPageID="Bank Account Ledger Entries";
    DrillDownPageID="Bank Account Ledger Entries";
  
  fields
{
    field(7207270;"Liquidity Account No.";Code[20])
    {
        TableRelation="Cash Flow Account";
                                                   CaptionML=ENU='Liquidity Account No.',ESP='N§ cta. liquidez';
                                                   Description='QB 1.00';


    }
    field(7207271;"Value Date";Date)
    {
        CaptionML=ENU='Value Date',ESP='Fecha valor';
                                                   Description='QB 1.00' ;


    }
}
  keys
{
   // key(key1;"Entry No.")
  //  {
       /* Clustered=true;
 */
   // }
   // key(key2;"Bank Account No.","Posting Date")
  //  {
       /* SumIndexFields="Amount","Amount (LCY)","Debit Amount","Credit Amount","Debit Amount (LCY)","Credit Amount (LCY)";
 */
   // }
   // key(key3;"Bank Account No.","Open")
  //  {
       /* ;
 */
   // }
   // key(key4;"Document No.","Posting Date")
  //  {
       /* ;
 */
   // }
   // key(key5;"Transaction No.")
  //  {
       /* ;
 */
   // }
   // key(No6;"Bank Account No.","Global Dimension 1 Code","Global Dimension 2 Code","Posting Date")
   // {
       /* SumIndexFields="Amount","Amount (LCY)","Debit Amount","Credit Amount","Debit Amount (LCY)","Credit Amount (LCY)";
 */
   // }
}
  fieldgroups
{
   // fieldgroup(DropDown;"Entry No.","Description","Bank Account No.","Posting Date","Document Type","Document No.")
   // {
       // 
   // }
}
  
    var
//       DimMgt@1000 :
      DimMgt: Codeunit 408;

    
    
/*
procedure ShowDimensions ()
    begin
      DimMgt.ShowDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2',TABLECAPTION,"Entry No."));
    end;
*/


    
//     procedure CopyFromGenJnlLine (GenJnlLine@1000 :
    
/*
procedure CopyFromGenJnlLine (GenJnlLine: Record 81)
    begin
      "Bank Account No." := GenJnlLine."Account No.";
      "Posting Date" := GenJnlLine."Posting Date";
      "Document Date" := GenJnlLine."Document Date";
      "Document Type" := GenJnlLine."Document Type";
      "Document No." := GenJnlLine."Document No.";
      "External Document No." := GenJnlLine."External Document No.";
      Description := GenJnlLine.Description;
      "Global Dimension 1 Code" := GenJnlLine."Shortcut Dimension 1 Code";
      "Global Dimension 2 Code" := GenJnlLine."Shortcut Dimension 2 Code";
      "Dimension Set ID" := GenJnlLine."Dimension Set ID";
      "Our Contact Code" := GenJnlLine."Salespers./Purch. Code";
      "Source Code" := GenJnlLine."Source Code";
      "Journal Batch Name" := GenJnlLine."Journal Batch Name";
      "Reason Code" := GenJnlLine."Reason Code";
      "Currency Code" := GenJnlLine."Currency Code";
      "User ID" := USERID;
      "Bal. Account Type" := GenJnlLine."Bal. Account Type";
      "Bal. Account No." := GenJnlLine."Bal. Account No.";

      OnAfterCopyFromGenJnlLine(Rec,GenJnlLine);
    end;
*/


    
//     procedure UpdateDebitCredit (Correction@1000 :
    
/*
procedure UpdateDebitCredit (Correction: Boolean)
    begin
      if (Amount > 0) and (not Correction) or
         (Amount < 0) and Correction
      then begin
        "Debit Amount" := Amount;
        "Credit Amount" := 0;
        "Debit Amount (LCY)" := "Amount (LCY)";
        "Credit Amount (LCY)" := 0;
      end else begin
        "Debit Amount" := 0;
        "Credit Amount" := -Amount;
        "Debit Amount (LCY)" := 0;
        "Credit Amount (LCY)" := -"Amount (LCY)";
      end;
    end;
*/


    
    
/*
procedure IsApplied () IsApplied : Boolean;
    var
//       CheckLedgerEntry@1000 :
      CheckLedgerEntry: Record 272;
    begin
      CheckLedgerEntry.SETRANGE("Bank Account No.","Bank Account No.");
      CheckLedgerEntry.SETRANGE("Bank Account Ledger Entry No.","Entry No.");
      CheckLedgerEntry.SETRANGE(Open,TRUE);
      CheckLedgerEntry.SETRANGE("Statement Status",CheckLedgerEntry."Statement Status"::"Check Entry Applied");
      CheckLedgerEntry.SETFILTER("Statement No.",'<>%1','');
      CheckLedgerEntry.SETFILTER("Statement Line No.",'<>%1',0);
      IsApplied := not CheckLedgerEntry.ISEMPTY;

      IsApplied := IsApplied or
        (("Statement Status" = "Statement Status"::"Bank Acc. Entry Applied") and
         ("Statement No." <> '') and ("Statement Line No." <> 0));

      exit(IsApplied);
    end;
*/


    
    
/*
procedure SetStyle () : Text;
    begin
      if IsApplied then
        exit('Favorable');

      exit('');
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


    
    
//     procedure OnAfterCopyFromGenJnlLine (var BankAccountLedgerEntry@1000 : Record 271;GenJournalLine@1001 :
    
/*
procedure OnAfterCopyFromGenJnlLine (var BankAccountLedgerEntry: Record 271;GenJournalLine: Record 81)
    begin
    end;

    /*begin
    end.
  */
}




