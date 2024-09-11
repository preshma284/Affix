query 50201 "Res. Ledger Entries 1"
{
  
  
    CaptionML=ENU='Res. Ledger Entries',ESP='Movimientos de recursos';
  
  elements
{

DataItem("Res_Ledger_Entry";"Res. Ledger Entry")
{

Column("Entry_No";"Entry No.")
{

}Column("Entry_Type";"Entry Type")
{

}Column("Resource_No";"Resource No.")
{

}Column("Resource_Group_No";"Resource Group No.")
{

}Column("Job_No";"Job No.")
{

}Column("Work_Type_Code";"Work Type Code")
{

}Column("Posting_Date";"Posting Date")
{

}Column("Document_Date";"Document Date")
{

}Column("Document_No";"Document No.")
{

}Column("Gen_Bus_Posting_Group";"Gen. Bus. Posting Group")
{

}Column("Gen_Prod_Posting_Group";"Gen. Prod. Posting Group")
{

}Column("Source_Code";"Source Code")
{

}Column("Reason_Code";"Reason Code")
{

}Column("Unit_of_Measure_Code";"Unit of Measure Code")
{

}Column("Quantity";"Quantity")
{

}Column("Quantity_Base";"Quantity (Base)")
{

}Column("Direct_Unit_Cost";"Direct Unit Cost")
{

}Column("Unit_Cost";"Unit Cost")
{

}Column("Total_Cost";"Total Cost")
{

}Column("Unit_Price";"Unit Price")
{

}Column("Total_Price";"Total Price")
{

}Column("Dimension_Set_ID";"Dimension Set ID")
{

}DataItem("Resource";"Resource")
{

DataItemLink="No."= "Res_Ledger_Entry"."Resource No.";
Column(Resource_Name;"Name")
{

}DataItem("Resource_Group";"Resource Group")
{

DataItemLink="No."= "Res_Ledger_Entry"."Resource Group No.";
Column(Resource_Group_Name;"Name")
{

}
}
}
}
}
  

    /*begin
    end.
  */
}




