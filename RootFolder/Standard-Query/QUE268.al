query 50200 "Job Ledger Entries 1"
{
  
  
    CaptionML=ENU='Job Ledger Entries',ESP='Movs. proyectos';
  
  elements
{

DataItem("Job_Ledger_Entry";"Job Ledger Entry")
{

Column("Entry_No";"Entry No.")
{

}Column("Job_No";"Job No.")
{

}Column("Job_Task_No";"Job Task No.")
{

}Column("Posting_Date";"Posting Date")
{

}Column("Document_Date";"Document Date")
{

}Column("Document_No";"Document No.")
{

}Column("Job_Posting_Group";"Job Posting Group")
{

}Column("Resource_Group_No";"Resource Group No.")
{

}Column("Work_Type_Code";"Work Type Code")
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

}Column("Quantity_Base";"Quantity (Base)")
{

}Column("Direct_Unit_Cost_LCY";"Direct Unit Cost (LCY)")
{

}Column("Unit_Cost_LCY";"Unit Cost (LCY)")
{

}Column("Total_Cost_LCY";"Total Cost (LCY)")
{

}Column("Unit_Price_LCY";"Unit Price (LCY)")
{

}Column("Total_Price_LCY";"Total Price (LCY)")
{

}Column("Line_Amount_LCY";"Line Amount (LCY)")
{

}Column("Dimension_Set_ID";"Dimension Set ID")
{

}DataItem("Job";"Job")
{

DataItemLink="No."= "Job_Ledger_Entry"."Job No.";
Column(Job_Description;"Description")
{

}
}
}
}
  

    /*begin
    end.
  */
}




