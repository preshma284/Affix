pageextension 50144 MyExtension179 extends 179//179
{
layout
{
addafter("FA Posting Type")
{
    field("QB_Job No";rec."Job No.")
    {
        
}
    field("QB_PieceworkCode";rec."Piecework Code")
    {
        
}
}

}

actions
{


}

//trigger

//trigger

var
      Text000 : TextConst ENU='Reverse Transaction Entries',ESP='Revertir movs. trans.';
      Text001 : TextConst ENU='Reverse Register Entries',ESP='Revertir movs. registro';
      ReversalEntry : Record 179;
      DescriptionEditable : Boolean ;

    
    

//procedure
//Local procedure Post(PrintRegister : Boolean);
//    var
//      ReversalPost : Codeunit 179;
//    begin
//      ReversalPost.SetPrint(PrintRegister);
//      ReversalPost.RUN(Rec);
//      CurrPage.UPDATE(FALSE);
//      CurrPage.CLOSE;
//    end;
//Local procedure GetEntryTypeText() EntryTypeText : Text;
//    var
//      GLEntry : Record 17;
//      CustLedgEntry : Record 21;
//      VendLedgEntry : Record 25;
//      EmployeeLedgerEntry : Record 5222;
//      BankAccLedgEntry : Record 271;
//      FALedgEntry : Record 5601;
//      MaintenanceLedgEntry : Record 5625;
//      VATEntry : Record 254;
//      IsHandled : Boolean;
//    begin
//      IsHandled := FALSE;
//      OnBeforeGetEntryTypeText(Rec,EntryTypeText,IsHandled);
//      if ( IsHandled  )then
//        exit(EntryTypeText);
//
//      CASE rec."Entry Type" OF
//        rec."Entry Type"::"G/L Account":
//          exit(GLEntry.TABLECAPTION);
//        rec."Entry Type"::Customer:
//          exit(CustLedgEntry.TABLECAPTION);
//        rec."Entry Type"::Vendor:
//          exit(VendLedgEntry.TABLECAPTION);
//        rec."Entry Type"::Employee:
//          exit(EmployeeLedgerEntry.TABLECAPTION);
//        rec."Entry Type"::"Bank Account":
//          exit(BankAccLedgEntry.TABLECAPTION);
//        rec."Entry Type"::"Fixed Asset":
//          exit(FALedgEntry.TABLECAPTION);
//        rec."Entry Type"::Maintenance:
//          exit(MaintenanceLedgEntry.TABLECAPTION);
//        rec."Entry Type"::VAT:
//          exit(VATEntry.TABLECAPTION);
//        ELSE
//          exit(FORMAT(rec."Entry Type"));
//      end;
//    end;
//Local procedure InitializeFilter();
//    begin
//      Rec.FINDFIRST;
//      ReversalEntry := Rec;
//      if ( rec."Reversal Type" = rec."Reversal Type"::Transaction  )then begin
//        CurrPage.CAPTION := Text000;
//        ReversalEntry.SetReverseFilter(rec."Transaction No.",rec."Reversal Type");
//      end ELSE begin
//        CurrPage.CAPTION := Text001;
//        ReversalEntry.SetReverseFilter(rec."G/L Register No.",rec."Reversal Type");
//      end;
//    end;
//
//    [Integration]
//Local procedure OnBeforeGetEntryTypeText(var ReversalEntry : Record 179;var Text : Text;var IsHandled : Boolean);
//    begin
//    end;

//procedure
}

