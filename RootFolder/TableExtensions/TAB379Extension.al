tableextension 50176 "MyExtension50176" extends "Detailed Cust. Ledg. Entry"
{
  
  /*
Permissions=TableData 379 m;
*/DataCaptionFields="Customer No.";
    CaptionML=ENU='Detailed Cust. Ledg. Entry',ESP='Movs. clientes detallados';
    LookupPageID="Detailed Cust. Ledg. Entries";
    DrillDownPageID="Detailed Cust. Ledg. Entries";
  
  fields
{
    field(7174331;"QuoSII Exported";Boolean)
    {
        CaptionML=ENU='SII Exported',ESP='Exportado SII';
                                                   Description='QuoSII_02_07';


    }
    field(7207270;"QB Job No.";Code[20])
    {
        FieldClass=FlowField;
                                                   CalcFormula=Lookup("Cust. Ledger Entry"."QB Job No." WHERE ("Entry No."=FIELD("Cust. Ledger Entry No.")));
                                                   Description='QB 1.06.14 JMM 16/09/20: - Para usarlo en los Cash-Flow' ;


    }
}
  keys
{
   // key(key1;"Entry No.")
  //  {
       /* //SumIndexFields=""Amount (LCY)""
                                                   Clustered=true;
 */
   // }
   // key(key2;"Cust. Ledger Entry No.","Posting Date")
  //  {
       /* ;
 */
   // }
   // key(key3;"Cust. Ledger Entry No.","Entry Type","Posting Date")
  //  {
       /* SumIndexFields="Amount","Amount (LCY)";
 */
   // }
   // key(key4;"Initial Document Type","Entry Type","Customer No.","Currency Code","Initial Entry Global Dim. 1","Initial Entry Global Dim. 2","Posting Date")
  //  {
       /* SumIndexFields="Amount","Amount (LCY)";
 */
   // }
   // key(key5;"Customer No.","Currency Code","Initial Entry Global Dim. 1","Initial Entry Global Dim. 2","Initial Entry Due Date","Posting Date")
  //  {
       /* SumIndexFields="Amount","Amount (LCY)";
 */
   // }
   // key(key6;"Document No.","Document Type","Posting Date")
  //  {
       /* ;
 */
   // }
   // key(key7;"Applied Cust. Ledger Entry No.","Entry Type")
  //  {
       /* ;
 */
   // }
   // key(key8;"Transaction No.","Customer No.","Entry Type")
  //  {
       /* ;
 */
   // }
   // key(key9;"Application No.","Customer No.","Entry Type")
  //  {
       /* ;
 */
   // }
   // key(key10;"Customer No.","Entry Type","Posting Date","Initial Document Type")
  //  {
       /* SumIndexFields="Amount","Amount (LCY)";
 */
   // }
}
  fieldgroups
{
   // fieldgroup(DropDown;"Entry No.","Cust. Ledger Entry No.","Customer No.","Posting Date","Document Type","Document No.")
   // {
       // 
   // }
}
  

    
    


/*
trigger OnInsert();    begin
               SetLedgerEntryAmount;
             end;

*/



// procedure UpdateDebitCredit (Correction@1000 :

/*
procedure UpdateDebitCredit (Correction: Boolean)
    begin
      if ((Amount > 0) or ("Amount (LCY)" > 0)) and not Correction or
         ((Amount < 0) or ("Amount (LCY)" < 0)) and Correction
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


    
//     procedure SetZeroTransNo (TransactionNo@1000 :
    
/*
procedure SetZeroTransNo (TransactionNo: Integer)
    var
//       DtldCustLedgEntry@1001 :
      DtldCustLedgEntry: Record 379;
//       ApplicationNo@1002 :
      ApplicationNo: Integer;
    begin
      DtldCustLedgEntry.SETCURRENTKEY("Transaction No.");
      DtldCustLedgEntry.SETRANGE("Transaction No.",TransactionNo);
      if DtldCustLedgEntry.FINDSET(TRUE) then begin
        ApplicationNo := DtldCustLedgEntry."Entry No.";
        repeat
          DtldCustLedgEntry."Transaction No." := 0;
          DtldCustLedgEntry."Application No." := ApplicationNo;
          DtldCustLedgEntry.MODIFY;
        until DtldCustLedgEntry.NEXT = 0;
      end;
    end;
*/


    
/*
LOCAL procedure SetLedgerEntryAmount ()
    begin
      "Ledger Entry Amount" :=
        not ("Entry Type" IN ["Entry Type"::Application,"Entry Type"::"Appln. Rounding","Entry Type"::Redrawal,
                              "Entry Type"::Rejection]);
    end;
*/


    
//     procedure GetUnrealizedGainLossAmount (EntryNo@1000 :
    
/*
procedure GetUnrealizedGainLossAmount (EntryNo: Integer) : Decimal;
    begin
      SETCURRENTKEY("Cust. Ledger Entry No.","Entry Type");
      SETRANGE("Cust. Ledger Entry No.",EntryNo);
      SETRANGE("Entry Type","Entry Type"::"Unrealized Loss","Entry Type"::"Unrealized Gain");
      CALCSUMS("Amount (LCY)");
      exit("Amount (LCY)");
    end;

    /*begin
    end.
  */
}




