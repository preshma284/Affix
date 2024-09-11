tableextension 50177 "MyExtension50177" extends "Detailed Vendor Ledg. Entry"
{
  
  /*
Permissions=TableData 380 m;
*/DataCaptionFields="Vendor No.";
    CaptionML=ENU='Detailed Vendor Ledg. Entry',ESP='Mov. proveedor detallado';
    LookupPageID="Detailed Vendor Ledg. Entries";
    DrillDownPageID="Detailed Vendor Ledg. Entries";
  
  fields
{
    field(7174331;"QuoSII Exported";Boolean)
    {
        CaptionML=ENU='SII Exported',ESP='Exportado SII';
                                                   Description='QuoSII_02_07';


    }
    field(7207270;"QB Expense Note Code";Code[20])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Expense Note Code',ESP='C¢d. Nota gasto';
                                                   Description='QB 1.00 - QB22110 JAV 05/08/19: - Renumerado';
                                                   Editable=false;


    }
    field(7207273;"QB Original Due Date";Date)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Vencimiento Contractual';
                                                   Description='QB 1.06.15 - JAV 23/09/20: - Fecha de vencimiento original del documento, solo se establece si se ha cambiado el vto tras el registro.';


    }
    field(7207290;"QB Job No.";Code[20])
    {
        FieldClass=FlowField;
                                                   CalcFormula=Lookup("Vendor Ledger Entry"."QB Job No." WHERE ("Entry No."=FIELD("Vendor Ledger Entry No.")));
                                                   CaptionML=ENU='Job No.',ESP='No. Proyecto';
                                                   Description='para Cash-Flow';
                                                   Editable=false;


    }
    field(7207292;"QB Shipment Line No";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='N§ L¡nea del albar n';
                                                   Description='QB 1.06.21  - JAV 21/10/20: - Si es un albar n de compra, de que l¡nea es' ;


    }
}
  keys
{
   // key(key1;"Entry No.")
  //  {
       /* Clustered=true;
 */
   // }
   // key(key2;"Vendor Ledger Entry No.","Posting Date")
  //  {
       /* ;
 */
   // }
   // key(key3;"Initial Document Type","Entry Type","Vendor No.","Currency Code","Initial Entry Global Dim. 1","Initial Entry Global Dim. 2","Posting Date")
  //  {
       /* SumIndexFields="Amount","Amount (LCY)";
 */
   // }
   // key(key4;"Vendor No.","Currency Code","Initial Entry Global Dim. 1","Initial Entry Global Dim. 2","Initial Entry Due Date","Posting Date")
  //  {
       /* SumIndexFields="Amount","Amount (LCY)";
 */
   // }
   // key(key5;"Document No.","Document Type","Posting Date")
  //  {
       /* ;
 */
   // }
   // key(key6;"Applied Vend. Ledger Entry No.","Entry Type")
  //  {
       /* ;
 */
   // }
   // key(key7;"Transaction No.","Vendor No.","Entry Type")
  //  {
       /* ;
 */
   // }
}
  fieldgroups
{
   // fieldgroup(DropDown;"Entry No.","Vendor Ledger Entry No.","Vendor No.","Posting Date","Document Type","Document No.")
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
//       DtldVendLedgEntry@1001 :
      DtldVendLedgEntry: Record 380;
//       ApplicationNo@1002 :
      ApplicationNo: Integer;
    begin
      DtldVendLedgEntry.SETCURRENTKEY("Transaction No.");
      DtldVendLedgEntry.SETRANGE("Transaction No.",TransactionNo);
      if DtldVendLedgEntry.FINDSET(TRUE) then begin
        ApplicationNo := DtldVendLedgEntry."Entry No.";
        repeat
          DtldVendLedgEntry."Transaction No." := 0;
          DtldVendLedgEntry."Application No." := ApplicationNo;
          DtldVendLedgEntry.MODIFY;
        until DtldVendLedgEntry.NEXT = 0;
      end;
    end;
*/


    
/*
LOCAL procedure SetLedgerEntryAmount ()
    begin
      "Ledger Entry Amount" :=
        not (("Entry Type" = "Entry Type"::Application) or ("Entry Type" = "Entry Type"::"Appln. Rounding"));
    end;
*/


    
//     procedure GetUnrealizedGainLossAmount (EntryNo@1000 :
    
/*
procedure GetUnrealizedGainLossAmount (EntryNo: Integer) : Decimal;
    begin
      SETCURRENTKEY("Vendor Ledger Entry No.","Entry Type");
      SETRANGE("Vendor Ledger Entry No.",EntryNo);
      SETRANGE("Entry Type","Entry Type"::"Unrealized Loss","Entry Type"::"Unrealized Gain");
      CALCSUMS("Amount (LCY)");
      exit("Amount (LCY)");
    end;

    /*begin
    //{
//      JAV 05/08/19: - Renumerado el campo "Expense Note Code" de 7000100 a 7207270
//      JAV 07/10/20: QB 1.06.20 - Creado el tipo "Shipment" en el campo "Document Type"
//    }
    end.
  */
}




