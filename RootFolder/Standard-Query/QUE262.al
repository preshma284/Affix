query 50194 "Cust. Ledger Entries 1"
{
  
  
    CaptionML=ENU='Cust. Ledger Entries',ESP='Movimientos de cliente';
  
  elements
{

DataItem("Cust_Ledger_Entry";"Cust. Ledger Entry")
{

Column("Entry_No";"Entry No.")
{

}Column("Transaction_No";"Transaction No.")
{

}Column("Customer_No";"Customer No.")
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

}Column("Salesperson_Code";"Salesperson Code")
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

}DataItem("Customer";"Customer")
{

DataItemLink="No."= "Cust_Ledger_Entry"."Customer No.";
Column(Customer_Name;"Name")
{

}
}
}
}
  

    /*begin
    end.
  */
}




