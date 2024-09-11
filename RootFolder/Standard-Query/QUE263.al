query 50195 "Vendor Ledger Entries 1"
{
  
  
    CaptionML=ENU='Vendor Ledger Entries',ESP='Movs. proveedores';
  
  elements
{

DataItem("Vendor_Ledger_Entry";"Vendor Ledger Entry")
{

Column("Entry_No";"Entry No.")
{

}Column("Transaction_No";"Transaction No.")
{

}Column("Vendor_No";"Vendor No.")
{

}Column("Posting_Date";"Posting Date")
{

}Column("Due_Date";"Due Date")
{

}Column("Pmt_Discount_Date";"Pmt. Discount Date")
{

}Column("Document_Date";"Document Date")
{

}Column("Document_Type";"Document Type")
{

}Column("Document_No";"Document No.")
{

}Column("Purchaser_Code";"Purchaser Code")
{

}Column("Source_Code";"Source Code")
{

}Column("Reason_Code";"Reason Code")
{

}Column("IC_Partner_Code";"IC Partner Code")
{

}Column("Open";"Open")
{

}Column("Currency_Code";"Currency Code")
{

}Column("Amount";"Amount")
{

}Column("Debit_Amount";"Debit Amount")
{

}Column("Credit_Amount";"Credit Amount")
{

}Column("Remaining_Amount";"Remaining Amount")
{

}Column("Amount_LCY";"Amount (LCY)")
{

}Column("Debit_Amount_LCY";"Debit Amount (LCY)")
{

}Column("Credit_Amount_LCY";"Credit Amount (LCY)")
{

}Column("Remaining_Amt_LCY";"Remaining Amt. (LCY)")
{

}Column("Original_Amt_LCY";"Original Amt. (LCY)")
{

}Column("Dimension_Set_ID";"Dimension Set ID")
{

}DataItem("Vendor";"Vendor")
{

DataItemLink="No."= "Vendor_Ledger_Entry"."Vendor No.";
Column(Vendor_Name;"Name")
{

}
}
}
}
  

    /*begin
    end.
  */
}




