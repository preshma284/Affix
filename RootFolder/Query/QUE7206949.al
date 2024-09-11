query 50133 "QB BI Historico abono venta v2"
{
  
  
  elements
{

DataItem("Sales_Cr_Memo_Header";"Sales Cr.Memo Header")
{

Column("No";"No.")
{

}Column("BilltoCustomerNo";"Bill-to Customer No.")
{

}Column("PostingDate";"Posting Date")
{

}Column("DueDate";"Due Date")
{

}Column("CurrencyFactor";"Currency Factor")
{

}Column("OnHold";"On Hold")
{

}Column("DocumentDate";"Document Date")
{

}Column("ExternalDocumentNo";"External Document No.")
{

}Column("NoSeries";"No. Series")
{

}Column("UserID";"User ID")
{

}Column("SourceCode";"Source Code")
{

}Column("CorrectedInvoiceNo";"Corrected Invoice No.")
{

}Column("PaymentbankNo";"Payment bank No.")
{

}Column("SelltoCustomerNo";"Sell-to Customer No.")
{

}DataItem("Sales_Cr_Memo_Line";"Sales Cr.Memo Line")
{

DataItemLink="Document No."= "Sales_Cr_Memo_Header"."No.";
Column("Type";"Type")
{

}Column(NoProducto;"No.")
{

}Column("Description";"Description")
{

}Column("UnitofMeasure";"Unit of Measure")
{

}Column("Quantity";"Quantity")
{

}Column("UnitPrice";"Unit Price")
{

}Column("UnitCostLCY";"Unit Cost (LCY)")
{

}Column("VAT";"VAT %")
{

}Column("LineDiscount";"Line Discount %")
{

}Column("LineDiscountAmount";"Line Discount Amount")
{

}Column(AmountlLine;"Amount")
{

}Column(AmountIncludingVATLIne;"Amount Including VAT")
{

}Column("ShortcutDimension1Code";"Shortcut Dimension 1 Code")
{

}Column("ShortcutDimension2Code";"Shortcut Dimension 2 Code")
{

}Column("JobNo";"Job No.")
{

}Column("WorkTypeCode";"Work Type Code")
{

}Column("InvDiscountAmount";"Inv. Discount Amount")
{

}Column("VATCalculationType";"VAT Calculation Type")
{

}Column("TransactionType";"Transaction Type")
{

}Column("DimensionSetID";"Dimension Set ID")
{

}Column("QBCertificationcode";"QB Certification code")
{

}Column("UsageDocument";"Usage Document")
{

}
}
}
}
  

    /*begin
    end.
  */
}








