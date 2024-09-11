query 50158 "Power BI Customer List 1"
{
  
  
    CaptionML=ENU='Power BI Customer List',ESP='Lista de clientes de Power BI';
  
  elements
{

DataItem("Customer";"Customer")
{

Column(Customer_Name;"Name")
{

}Column(Customer_No;"No.")
{

}Column(Credit_Limit;"Credit Limit (LCY)")
{

}Column("Balance_Due";"Balance Due")
{

}DataItem("Detailed_Cust_Ledg_Entry";"Detailed Cust. Ledg. Entry")
{

DataItemLink="Customer No."=Customer."No.";
Column("Posting_Date";"Posting Date")
{

}Column("Cust_Ledger_Entry_No";"Cust. Ledger Entry No.")
{

}Column("Amount";"Amount")
{

}Column("Amount_LCY";"Amount (LCY)")
{

}Column("Transaction_No";"Transaction No.")
{

}Column("Entry_No";"Entry No.")
{

}
}
}
}
  

    /*begin
    end.
  */
}




