query 50132 "QB BI Historico fact venta v2"
{
  
  
  elements
{

DataItem("Sales_Invoice_Header";"Sales Invoice Header")
{

Column("BilltoCustomerNo";"Bill-to Customer No.")
{

}Column("No";"No.")
{

}Column("PostingDate";"Posting Date")
{

}Column("DueDate";"Due Date")
{

}Column("CurrencyCode";"Currency Code")
{

}Column("PaymentTermsCode";"Payment Terms Code")
{

}Column("PaymentMethodCode";"Payment Method Code")
{

}Column("SalespersonCode";"Salesperson Code")
{

}Column("SelltoCustomerNo";"Sell-to Customer No.")
{

}Column("CustLedgerEntryNo";"Cust. Ledger Entry No.")
{

}Column("PostingDescription";"Posting Description")
{

}Column("JobSaleDocType";"Job Sale Doc. Type")
{

}DataItem("Sales_Invoice_Line";"Sales Invoice Line")
{

DataItemLink="Document No."= "Sales_Invoice_Header"."No.";
Column("LineNo";"Line No.")
{

}Column("Description";"Description")
{

}Column("Quantity";"Quantity")
{

}Column("UnitPrice";"Unit Price")
{

}Column("Amount";"Amount")
{

}Column("AmountIncludingVAT";"Amount Including VAT")
{

}Column("JobNo";"Job No.")
{

}Column("OrderNo";"Order No.")
{

}Column("OrderLineNo";"Order Line No.")
{

}Column("QBCertificationcode";"QB Certification code")
{

}Column("QB_PieceworkNo";"QB_Piecework No.")
{

}Column("UsageDocumentLine";"Usage Document Line")
{

}Column("UsageDocument";"Usage Document")
{

}Column(NoProducto;"No.")
{

}
}
}
}
  

    /*begin
    end.
  */
}








