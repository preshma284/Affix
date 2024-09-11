tableextension 50206 "MyExtension50206" extends "No Taxable Entry"
{
  
  /*
Permissions=TableData 10740 rim;
*/
    CaptionML=ENU='No Taxable Entry',ESP='Ninguna entrada gravable';
    LookupPageID="No Taxable Entries";
    DrillDownPageID="No Taxable Entries";
  
  fields
{
}
  keys
{
   // key(key1;"Entry No.")
  //  {
       /* Clustered=true;
 */
   // }
   // key(key2;"Document No.","Posting Date")
  //  {
       /* ;
 */
   // }
   // key(key3;"Type","Posting Date","Document Type","Document No.","Source No.")
  //  {
       /* ;
 */
   // }
}
  fieldgroups
{
}
  

    // procedure FilterNoTaxableEntry (EntryType@1100004 : Option;SourceNo@1100003 : Code[20];DocumentType@1100006 : Option;DocumentNo@1100001 : Code[20];PostingDate@1100002 : Date;IsReversed@1100005 :

/*
procedure FilterNoTaxableEntry (EntryType: Option;SourceNo: Code[20];DocumentType: Option;DocumentNo: Code[20];PostingDate: Date;IsReversed: Boolean)
    begin
      SETRANGE(Type,EntryType);
      SETRANGE("Source No.",SourceNo);
      SETRANGE("Document Type",DocumentType);
      SETRANGE("Document No.",DocumentNo);
      SETRANGE("Posting Date",PostingDate);
      SETRANGE(Reversed,IsReversed);
    end;
*/


//     procedure FilterNoTaxableEntriesForSource (EntryType@1100006 : Option;SourceNo@1100001 : Code[20];DocumentType@1100002 : Option;FromDate@1100003 : Date;ToDate@1100004 : Date;GenProdPostGroupFilter@1100005 :
    
/*
procedure FilterNoTaxableEntriesForSource (EntryType: Option;SourceNo: Code[20];DocumentType: Option;FromDate: Date;ToDate: Date;GenProdPostGroupFilter: Text)
    begin
      SETRANGE(Type,EntryType);
      SETRANGE("Source No.",SourceNo);
      SETRANGE("Document Type",DocumentType);
      SETRANGE("Posting Date",FromDate,ToDate);
      if GenProdPostGroupFilter <> '' then
        SETFILTER("Gen. Prod. Posting Group",GenProdPostGroupFilter);
      SETRANGE(Intracommunity,TRUE);
      SETRANGE(Reversed,FALSE);
    end;
*/


//     procedure InitFromGenJnlLine (GenJournalLine@1000 :
    
/*
procedure InitFromGenJnlLine (GenJournalLine: Record 81)
    begin
      "Document No." := GenJournalLine."Document No.";
      "Document Type" := GenJournalLine."Document Type";
      "Document Date" := GenJournalLine."Document Date";
      "Posting Date" := GenJournalLine."Posting Date";
      "Currency Code" := GenJournalLine."Currency Code";
      "Country/Region Code" := GenJournalLine."Country/Region Code";
      "Source No." := GenJournalLine."Account No.";
      "External Document No." := GenJournalLine."External Document No.";
      "Currency Factor" := GenJournalLine."Currency Factor";
      "No. Series" := GenJournalLine."Posting No. Series";
      "EU 3-Party Trade" := GenJournalLine."EU 3-Party Trade";
      "VAT Registration No." := GenJournalLine."VAT Registration No.";
    end;
*/


//     procedure InitFromServiceDocument (ServiceHeader@1000 : Record 5900;PostedDocumentNo@1100000 :
    
/*
procedure InitFromServiceDocument (ServiceHeader: Record 5900;PostedDocumentNo: Code[20])
    begin
      "Document No." := PostedDocumentNo;
      if ServiceHeader."Document Type" = ServiceHeader."Document Type"::"Credit Memo" then
        "Document Type" := "Document Type"::"Credit Memo"
      else
        "Document Type" := "Document Type"::Invoice;
      "Document Date" := ServiceHeader."Document Date";
      "Posting Date" := ServiceHeader."Posting Date";
      "Currency Code" := ServiceHeader."Currency Code";
      "Country/Region Code" := ServiceHeader."Country/Region Code";
      "Source No." := ServiceHeader."Customer No.";
      "External Document No." := ServiceHeader."No.";
      "Currency Factor" := ServiceHeader."Currency Factor";
      "No. Series" := ServiceHeader."Posting No. Series";
      "EU 3-Party Trade" := ServiceHeader."EU 3-Party Trade";
      "VAT Registration No." := ServiceHeader."VAT Registration No.";
    end;
*/


//     procedure InitFromVendorEntry (VendorLedgerEntry@1000 : Record 25;CountryRegionCode@1100002 : Code[10];EU3PartyTrade@1100000 : Boolean;VATRegistrationNo@1100001 :
    
/*
procedure InitFromVendorEntry (VendorLedgerEntry: Record 25;CountryRegionCode: Code[10];EU3PartyTrade: Boolean;VATRegistrationNo: Text[20])
    begin
      "Document No." := VendorLedgerEntry."Document No.";
      "Document Type" := VendorLedgerEntry."Document Type";
      "Document Date" := VendorLedgerEntry."Document Date";
      "Posting Date" := VendorLedgerEntry."Posting Date";
      "Currency Code" := VendorLedgerEntry."Currency Code";
      "Country/Region Code" := CountryRegionCode;
      "Source No." := VendorLedgerEntry."Vendor No.";
      "External Document No." := VendorLedgerEntry."External Document No.";
      "Currency Factor" := VendorLedgerEntry."Original Currency Factor";
      "No. Series" := VendorLedgerEntry."No. Series";
      "EU 3-Party Trade" := EU3PartyTrade;
      "VAT Registration No." := VATRegistrationNo;
      "Transaction No." := VendorLedgerEntry."Transaction No.";
    end;
*/


//     procedure InitFromCustomerEntry (CustLedgerEntry@1000 : Record 21;CountryRegionCode@1100002 : Code[10];EU3PartyTrade@1100001 : Boolean;VATRegistrationNo@1100000 :
    
/*
procedure InitFromCustomerEntry (CustLedgerEntry: Record 21;CountryRegionCode: Code[10];EU3PartyTrade: Boolean;VATRegistrationNo: Text[20])
    begin
      "Document No." := CustLedgerEntry."Document No.";
      "Document Type" := CustLedgerEntry."Document Type";
      "Document Date" := CustLedgerEntry."Document Date";
      "Posting Date" := CustLedgerEntry."Posting Date";
      "Currency Code" := CustLedgerEntry."Currency Code";
      "Country/Region Code" := CountryRegionCode;
      "Source No." := CustLedgerEntry."Customer No.";
      "External Document No." := CustLedgerEntry."External Document No.";
      "Currency Factor" := CustLedgerEntry."Original Currency Factor";
      "No. Series" := CustLedgerEntry."No. Series";
      "EU 3-Party Trade" := EU3PartyTrade;
      "VAT Registration No." := VATRegistrationNo;
      "Transaction No." := CustLedgerEntry."Transaction No.";
    end;
*/


//     procedure Reverse (EntryType@1100001 : Option;SourceNo@1100000 : Code[20];DocumentType@1100007 : Option;DocumentNo@1100005 : Code[20];PostingDate@1100006 :
    
/*
procedure Reverse (EntryType: Option;SourceNo: Code[20];DocumentType: Option;DocumentNo: Code[20];PostingDate: Date)
    var
//       NoTaxableEntry@1100002 :
      NoTaxableEntry: Record 10740;
//       NewNoTaxableEntry@1100003 :
      NewNoTaxableEntry: Record 10740;
    begin
      NoTaxableEntry.FilterNoTaxableEntry(EntryType,SourceNo,DocumentType,DocumentNo,PostingDate,FALSE);
      if NoTaxableEntry.ISEMPTY then
        exit;

      NoTaxableEntry.FINDSET(TRUE);
      repeat
        NewNoTaxableEntry := NoTaxableEntry;
        NewNoTaxableEntry."Entry No." := GetLastEntryNo + 1;
        NewNoTaxableEntry.Base := -NewNoTaxableEntry.Base;
        NewNoTaxableEntry."Base (LCY)" := -NewNoTaxableEntry."Base (LCY)";
        NewNoTaxableEntry."Base (ACY)" := -NewNoTaxableEntry."Base (ACY)";
        NewNoTaxableEntry.Amount := -NewNoTaxableEntry.Amount;
        NewNoTaxableEntry."Amount (LCY)" := -NewNoTaxableEntry."Amount (LCY)";
        NewNoTaxableEntry."Amount (ACY)" := -NewNoTaxableEntry."Amount (ACY)";

        NewNoTaxableEntry.Reversed := TRUE;
        NewNoTaxableEntry."Reversed Entry No." := NoTaxableEntry."Entry No.";
        NewNoTaxableEntry.INSERT;

        NoTaxableEntry.Reversed := TRUE;
        NoTaxableEntry."Reversed by Entry No." := NewNoTaxableEntry."Entry No.";
        NoTaxableEntry.MODIFY;
      until NoTaxableEntry.NEXT = 0;
    end;
*/


//     procedure Update (NoTaxableEntry@1001 :
    
/*
procedure Update (NoTaxableEntry: Record 10740)
    begin
      Rec := NoTaxableEntry;

      SETRANGE(Type,NoTaxableEntry.Type);
      SETRANGE("Document Type",NoTaxableEntry."Document Type");
      SETRANGE("Document No.",NoTaxableEntry."Document No.");
      SETRANGE("Posting Date",NoTaxableEntry."Posting Date");
      SETRANGE("Source No.",NoTaxableEntry."Source No.");
      SETRANGE("VAT Calculation Type",NoTaxableEntry."VAT Calculation Type");
      SETRANGE("EU Service",NoTaxableEntry."EU Service");
      SETRANGE("not In 347",NoTaxableEntry."not In 347");
      SETRANGE("No Taxable Type",NoTaxableEntry."No Taxable Type");
      SETRANGE("Delivery Operation Code",NoTaxableEntry."Delivery Operation Code");
      if FINDFIRST then begin
        Base += NoTaxableEntry.Base;
        "Base (LCY)" += NoTaxableEntry."Base (LCY)";
        "Base (ACY)" += NoTaxableEntry."Base (ACY)";
        Amount += NoTaxableEntry.Amount;
        "Amount (LCY)" += NoTaxableEntry."Amount (LCY)";
        "Amount (ACY)" += NoTaxableEntry."Amount (ACY)";
        MODIFY;
      end else begin
        "Entry No." := GetLastEntryNo + 1;
        INSERT;
      end;
    end;
*/


    
/*
LOCAL procedure GetLastEntryNo () : Integer;
    var
//       NoTaxableEntry@1100000 :
      NoTaxableEntry: Record 10740;
    begin
      if not NoTaxableEntry.FINDLAST then
        exit(0);

      exit(NoTaxableEntry."Entry No.");
    end;

    /*begin
    end.
  */
}




