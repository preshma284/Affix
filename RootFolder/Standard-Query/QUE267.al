query 50199 "FA Ledger Entries 1"
{
  
  
    CaptionML=ENU='FA Ledger Entries',ESP='Movimientos de activos';
  
  elements
{

DataItem("FA_Ledger_Entry";"FA Ledger Entry")
{

Column("Entry_No";"Entry No.")
{

}Column("G_L_Entry_No";"G/L Entry No.")
{

}Column("FA_No";"FA No.")
{

}Column("FA_Class_Code";"FA Class Code")
{

}Column("FA_Subclass_Code";"FA Subclass Code")
{

}Column("FA_Posting_Date";"FA Posting Date")
{

}Column("FA_Posting_Category";"FA Posting Category")
{

}Column("FA_Posting_Type";"FA Posting Type")
{

}Column("FA_Location_Code";"FA Location Code")
{

}Column("Depreciation_Book_Code";"Depreciation Book Code")
{

}Column("Posting_Date";"Posting Date")
{

}Column("Document_Date";"Document Date")
{

}Column("Document_Type";"Document Type")
{

}Column("Document_No";"Document No.")
{

}Column("Gen_Bus_Posting_Group";"Gen. Bus. Posting Group")
{

}Column("Gen_Prod_Posting_Group";"Gen. Prod. Posting Group")
{

}Column("Location_Code";"Location Code")
{

}Column("Source_Code";"Source Code")
{

}Column("Reason_Code";"Reason Code")
{

}Column("Amount_LCY";"Amount (LCY)")
{

}Column("Dimension_Set_ID";"Dimension Set ID")
{

}DataItem("Fixed_Asset";"Fixed Asset")
{

DataItemLink="No."= "FA_Ledger_Entry"."FA No.";
Column(FA_Description;"Description")
{

}
}
}
}
  

    /*begin
    end.
  */
}




