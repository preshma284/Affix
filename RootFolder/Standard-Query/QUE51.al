query 50159 "Power BI Vendor List 1"
{
  
  
    CaptionML=ENU='Power BI Vendor List',ESP='Lista de proveedores de Power BI';
  
  elements
{

DataItem("Vendor";"Vendor")
{

Column(Vendor_No;"No.")
{

}Column(Vendor_Name;"Name")
{

}Column("Balance_Due";"Balance Due")
{

}DataItem("Detailed_Vendor_Ledg_Entry";"Detailed Vendor Ledg. Entry")
{

DataItemLink="Vendor No."=Vendor."No.";
Column("Posting_Date";"Posting Date")
{

}Column("Applied_Vend_Ledger_Entry_No";"Applied Vend. Ledger Entry No.")
{

}Column("Amount";"Amount")
{
ReverseSign=false;
}Column("Amount_LCY";"Amount (LCY)")
{
ReverseSign=false;
}Column("Transaction_No";"Transaction No.")
{

}Column("Entry_No";"Entry No.")
{

}Column("Remaining_Pmt_Disc_Possible";"Remaining Pmt. Disc. Possible")
{

}
}
}
}
  

    /*begin
    end.
  */
}




