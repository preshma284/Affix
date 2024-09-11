query 50144 "QB BI Pagos"
{
  
  
  elements
{

DataItem("Vendor_Ledger_Entry";"Vendor Ledger Entry")
{

               DataItemTableFilter="Document Type"=CONST("Payment");
Column("EntryNo";"Entry No.")
{

}Column("VendorNo";"Vendor No.")
{

}Column("PostingDate";"Posting Date")
{

}Column("DocumentType";"Document Type")
{

}Column("DocumentNo";"Document No.")
{

}Column("Description";"Description")
{

}Column("CurrencyCode";"Currency Code")
{

}Column("Amount";"Amount")
{

}Column("RemainingAmount";"Remaining Amount")
{

}Column("OriginalAmtLCY";"Original Amt. (LCY)")
{

}Column("RemainingAmtLCY";"Remaining Amt. (LCY)")
{

}Column("AmountLCY";"Amount (LCY)")
{

}Column("PurchaseLCY";"Purchase (LCY)")
{

}Column("InvDiscountLCY";"Inv. Discount (LCY)")
{

}Column("BuyfromVendorNo";"Buy-from Vendor No.")
{

}Column("VendorPostingGroup";"Vendor Posting Group")
{

}Column("GlobalDimension1Code";"Global Dimension 1 Code")
{

}Column("GlobalDimension2Code";"Global Dimension 2 Code")
{

}Column("PurchaserCode";"Purchaser Code")
{

}Column("UserID";"User ID")
{

}Column("SourceCode";"Source Code")
{

}Column("OnHold";"On Hold")
{

}Column("AppliestoDocType";"Applies-to Doc. Type")
{

}Column("AppliestoDocNo";"Applies-to Doc. No.")
{

}Column("Open";"Open")
{

}Column("DueDate";"Due Date")
{

}Column("PmtDiscountDate";"Pmt. Discount Date")
{

}Column("OriginalPmtDiscPossible";"Original Pmt. Disc. Possible")
{

}Column("Positive";"Positive")
{

}Column("ClosedbyEntryNo";"Closed by Entry No.")
{

}Column("ClosedatDate";"Closed at Date")
{

}Column("ClosedbyAmount";"Closed by Amount")
{

}Column("AppliestoID";"Applies-to ID")
{

}Column("JournalBatchName";"Journal Batch Name")
{

}Column("ReasonCode";"Reason Code")
{

}Column("BalAccountType";"Bal. Account Type")
{

}Column("BalAccountNo";"Bal. Account No.")
{

}Column("TransactionNo";"Transaction No.")
{

}Column("ClosedbyAmountLCY";"Closed by Amount (LCY)")
{

}Column("DebitAmount";"Debit Amount")
{

}Column("CreditAmount";"Credit Amount")
{

}Column("DebitAmountLCY";"Debit Amount (LCY)")
{

}Column("CreditAmountLCY";"Credit Amount (LCY)")
{

}Column("DocumentDate";"Document Date")
{

}Column("ExternalDocumentNo";"External Document No.")
{

}Column("ClosedbyCurrencyCode";"Closed by Currency Code")
{

}Column("ClosedbyCurrencyAmount";"Closed by Currency Amount")
{

}Column("AdjustedCurrencyFactor";"Adjusted Currency Factor")
{

}Column("OriginalCurrencyFactor";"Original Currency Factor")
{

}Column("OriginalAmount";"Original Amount")
{

}Column("RemainingPmtDiscPossible";"Remaining Pmt. Disc. Possible")
{

}Column("PmtDiscToleranceDate";"Pmt. Disc. Tolerance Date")
{

}Column("MaxPaymentTolerance";"Max. Payment Tolerance")
{

}Column("AmounttoApply";"Amount to Apply")
{

}Column("ApplyingEntry";"Applying Entry")
{

}Column("Reversed";"Reversed")
{

}Column("ReversedbyEntryNo";"Reversed by Entry No.")
{

}Column("ReversedEntryNo";"Reversed Entry No.")
{

}Column("Prepayment";"Prepayment")
{

}Column("PaymentTermsCode";"Payment Terms Code")
{

}Column("PaymentMethodCode";"Payment Method Code")
{

}Column("AppliestoExtDocNo";"Applies-to Ext. Doc. No.")
{

}Column("DimensionSetID";"Dimension Set ID")
{

}Column("InvoiceType";"Invoice Type")
{

}Column("CrMemoType";"Cr. Memo Type")
{

}Column("SpecialSchemeCode";"Special Scheme Code")
{

}Column("CorrectionType";"Correction Type")
{

}Column("CorrectedInvoiceNo";"Corrected Invoice No.")
{

}Column("SucceededCompanyName";"Succeeded Company Name")
{

}Column("SucceededVATRegistrationNo";"Succeeded VAT Registration No.")
{

}Column("BillNo";"Bill No.")
{

}Column("DocumentSituation";"Document Situation")
{

}Column("AppliestoBillNo";"Applies-to Bill No.")
{

}Column("DocumentStatus";"Document Status")
{

}Column("RemainingAmountLCYstats";"Remaining Amount (LCY) stats.")
{

}Column("AmountLCYstats";"Amount (LCY) stats.")
{

}Column("QWWithholdingEntry";"QW Withholding Entry")
{

}DataItem("Detailed_Vendor_Ledg_Entry";"Detailed Vendor Ledg. Entry")
{

               DataItemTableFilter="Entry Type"=FILTER("Application"),
                                   "Initial Document Type"=FILTER('Invoice'|'Bill'|'Credit Memo'),
                                   "Unapplied"=FILTER(false);
DataItemLink="Vendor Ledger Entry No."= "Vendor_Ledger_Entry"."Entry No.";
               //DataItemLinkType=SQL Advanced Options;
Column("QBJobNo";"QB Job No.")
{

}
}
}
}
  

    /*begin
    end.
  */
}








