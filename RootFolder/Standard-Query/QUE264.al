query 50196 "Bank Account Ledger Entries 1"
{
  
  
    CaptionML=ENU='Bank Account Ledger Entries',ESP='Movs. bancos';
  
  elements
{

DataItem("Bank_Account_Ledger_Entry";"Bank Account Ledger Entry")
{

Column("Entry_No";"Entry No.")
{

}Column("Transaction_No";"Transaction No.")
{

}Column("Bank_Account_No";"Bank Account No.")
{

}Column("Posting_Date";"Posting Date")
{

}Column("Document_Date";"Document Date")
{

}Column("Document_Type";"Document Type")
{

}Column("Document_No";"Document No.")
{

}Column("Source_Code";"Source Code")
{

}Column("Reason_Code";"Reason Code")
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

}Column("Dimension_Set_ID";"Dimension Set ID")
{

}DataItem("Bank_Account";"Bank Account")
{

DataItemLink="No."= "Bank_Account_Ledger_Entry"."Bank Account No.";
Column(Bank_Account_Name;"Name")
{

}
}
}
}
  

    /*begin
    end.
  */
}




