tableextension 50682 "QBU Gen. Journal BatchExt" extends "Gen. Journal Batch"
{
  
  DataCaptionFields="Name","Description";
    CaptionML=ENU='Gen. Journal Batch',ESP='Secci¢n diario general';
    LookupPageID="General Journal Batches";
  
  fields
{
    field(50000;"QBU Internal";Boolean)
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Internal',ESP='Interno';
                                                   Description='19975' ;

trigger OnValidate();
    VAR
//                                                                 GenJournalLine@1100286000 :
                                                                GenJournalLine: Record 81;
                                                              BEGIN 
                                                                //+19975
                                                                GenJournalLine.RESET;
                                                                GenJournalLine.SETRANGE("Journal Template Name", Rec."Journal Template Name");
                                                                GenJournalLine.SETRANGE("Journal Batch Name", Rec.Name);
                                                                GenJournalLine.MODIFYALL(Internal, Rec.Internal, TRUE);
                                                                //-19975
                                                              END;


    }
}
  keys
{
   // key(key1;"Journal Template Name","Name")
  //  {
       /* Clustered=true;
 */
   // }
}
  fieldgroups
{
}
  
    var
//       Text000@1000 :
      Text000: TextConst ENU='Only the %1 field can be filled in on recurring journals.',ESP='S¢lo se debe completar el campo %1 en los diarios peri¢dicos.';
//       Text001@1001 :
      Text001: TextConst ENU='must not be %1',ESP='No puede ser %1.';
//       GenJnlTemplate@1002 :
      GenJnlTemplate: Record 80;
//       GenJnlLine@1003 :
      GenJnlLine: Record 81;
//       GenJnlAlloc@1004 :
      GenJnlAlloc: Record 221;
//       BankStmtImpFormatBalAccErr@1005 :
      BankStmtImpFormatBalAccErr: 
// "FIELDERROR ex: Bank Statement Import Format must be blank. When Bal. Account Type = Bank Account, then Bank Statement Import Format on the Bank Account card will be used in Gen. Journal Batch Journal Template Name=''GENERAL'',Name=''CASH''."
TextConst ENU='must be blank. When Bal. Account Type = Bank Account, then Bank Statement Import Format on the Bank Account card will be used',ESP='debe estar en blanco. Cuando Tipo contrapartida = Cuenta bancaria, se utilizar  el Formato de importaci¢n de extractos bancarios en la Ficha Banco.';
//       ApprovalsMgmt@1006 :
      ApprovalsMgmt: Codeunit 1535;
//       CannotBeSpecifiedForRecurrJnlErr@1007 :
      CannotBeSpecifiedForRecurrJnlErr: TextConst ENU='cannot be specified when using recurring journals',ESP='no se puede utilizar en diarios peri¢dicos';
//       BalAccountIdDoesNotMatchAGLAccountErr@1008 :
      BalAccountIdDoesNotMatchAGLAccountErr: 
// {Locked}
TextConst ENU='The "balancingAccountNumber" does not match to a G/L Account.',ESP='The "balancingAccountNumber" does not match to a G/L Account.';

    
    


/*
trigger OnInsert();    begin
               LOCKTABLE;
               GenJnlTemplate.GET("Journal Template Name");
               if not GenJnlTemplate."Copy VAT Setup to Jnl. Lines" then
                 "Copy VAT Setup to Jnl. Lines" := FALSE;
               "Allow Payment Export" := GenJnlTemplate.Type = GenJnlTemplate.Type::Payments;

               SetLastModifiedDateTime;
             end;


*/

/*
trigger OnModify();    begin
               SetLastModifiedDateTime;
             end;


*/

/*
trigger OnDelete();    begin
               ApprovalsMgmt.OnCancelGeneralJournalBatchApprovalRequest(Rec);

               GenJnlAlloc.SETRANGE("Journal Template Name","Journal Template Name");
               GenJnlAlloc.SETRANGE("Journal Batch Name",Name);
               GenJnlAlloc.DELETEALL;
               GenJnlLine.SETRANGE("Journal Template Name","Journal Template Name");
               GenJnlLine.SETRANGE("Journal Batch Name",Name);
               GenJnlLine.DELETEALL(TRUE);
             end;


*/

/*
trigger OnRename();    begin
               ApprovalsMgmt.OnRenameRecordInApprovalRequest(xRec.RECORDID,RECORDID);

               SetLastModifiedDateTime;
             end;

*/




/*
procedure SetupNewBatch ()
    begin
      GenJnlTemplate.GET("Journal Template Name");
      "Bal. Account Type" := GenJnlTemplate."Bal. Account Type";
      "Bal. Account No." := GenJnlTemplate."Bal. Account No.";
      "No. Series" := GenJnlTemplate."No. Series";
      "Posting No. Series" := GenJnlTemplate."Posting No. Series";
      "Reason Code" := GenJnlTemplate."Reason Code";
      "Copy VAT Setup to Jnl. Lines" := GenJnlTemplate."Copy VAT Setup to Jnl. Lines";
      "Allow VAT Difference" := GenJnlTemplate."Allow VAT Difference";
    end;
*/


//     LOCAL procedure CheckGLAcc (AccNo@1000 :
    
/*
LOCAL procedure CheckGLAcc (AccNo: Code[20])
    var
//       GLAcc@1001 :
      GLAcc: Record 15;
    begin
      if AccNo <> '' then begin
        GLAcc.GET(AccNo);
        GLAcc.CheckGLAcc;
        GLAcc.TESTFIELD("Direct Posting",TRUE);
      end;
    end;
*/


    
/*
LOCAL procedure CheckJnlIsNotRecurring ()
    begin
      if "Bal. Account No." = '' then
        exit;

      GenJnlTemplate.GET("Journal Template Name");
      if GenJnlTemplate.Recurring then
        FIELDERROR("Bal. Account No.",CannotBeSpecifiedForRecurrJnlErr);
    end;
*/


//     LOCAL procedure ModifyLines (i@1000 :
    
/*
LOCAL procedure ModifyLines (i: Integer)
    begin
      GenJnlLine.LOCKTABLE;
      GenJnlLine.SETRANGE("Journal Template Name","Journal Template Name");
      GenJnlLine.SETRANGE("Journal Batch Name",Name);
      if GenJnlLine.FIND('-') then
        repeat
          CASE i OF
            FIELDNO("Reason Code"):
              GenJnlLine.VALIDATE("Reason Code","Reason Code");
            FIELDNO("Posting No. Series"):
              GenJnlLine.VALIDATE("Posting No. Series","Posting No. Series");
          end;
          GenJnlLine.MODIFY(TRUE);
        until GenJnlLine.NEXT = 0;
    end;
*/


    
    
/*
procedure LinesExist () : Boolean;
    var
//       GenJournalLine@1000 :
      GenJournalLine: Record 81;
    begin
      GenJournalLine.SETRANGE("Journal Template Name","Journal Template Name");
      GenJournalLine.SETRANGE("Journal Batch Name",Name);
      exit(not GenJournalLine.ISEMPTY);
    end;
*/


    
    
/*
procedure GetBalance () : Decimal;
    var
//       GenJournalLine@1000 :
      GenJournalLine: Record 81;
    begin
      GenJournalLine.SETRANGE("Journal Template Name","Journal Template Name");
      GenJournalLine.SETRANGE("Journal Batch Name",Name);
      GenJournalLine.CALCSUMS("Balance (LCY)");
      exit(GenJournalLine."Balance (LCY)");
    end;
*/


    
    
/*
procedure CheckBalance () Balance : Decimal;
    begin
      Balance := GetBalance;

      if Balance = 0 then
        OnGeneralJournalBatchBalanced
      else
        OnGeneralJournalBatchNotBalanced;
    end;

    [Integration(TRUE)]
*/

    
/*
LOCAL procedure OnGeneralJournalBatchBalanced ()
    begin
    end;

    [Integration(TRUE)]
*/

    
/*
LOCAL procedure OnGeneralJournalBatchNotBalanced ()
    begin
    end;

    [Integration(TRUE)]
*/

    
    
/*
procedure OnCheckGenJournalLineExportRestrictions ()
    begin
    end;

    [Integration(TRUE)]
*/

    
//     procedure OnMoveGenJournalBatch (ToRecordID@1000 :
    
/*
procedure OnMoveGenJournalBatch (ToRecordID: RecordID)
    begin
    end;
*/


    
/*
LOCAL procedure SetLastModifiedDateTime ()
    begin
      "Last Modified DateTime" := CURRENTDATETIME;
    end;
*/


    
    
/*
procedure UpdateBalAccountId ()
    var
//       GLAccount@1000 :
      GLAccount: Record 15;
    begin
      if "Bal. Account No." = '' then begin
        CLEAR(BalAccountId);
        exit;
      end;

      if not GLAccount.GET("Bal. Account No.") then
        exit;

      BalAccountId := GLAccount.Id;
    end;

    /*begin
    end.
  */
}





