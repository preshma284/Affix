query 50198 "Value Entries 1"
{
  
  
    CaptionML=ENU='Value Entries',ESP='Movimientos valor';
  
  elements
{

DataItem("Value_Entry";"Value Entry")
{

Column("Entry_No";"Entry No.")
{

}Column("Item_No";"Item No.")
{

}Column("Item_Ledger_Entry_No";"Item Ledger Entry No.")
{

}Column("Item_Ledger_Entry_Type";"Item Ledger Entry Type")
{

}Column("Item_Ledger_Entry_Quantity";"Item Ledger Entry Quantity")
{

}Column("Posting_Date";"Posting Date")
{

}Column("Valuation_Date";"Valuation Date")
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

}Column("Job_No";"Job No.")
{

}Column("Job_Task_No";"Job Task No.")
{

}Column("Job_Ledger_Entry_No";"Job Ledger Entry No.")
{

}Column("Valued_Quantity";"Valued Quantity")
{

}Column("Invoiced_Quantity";"Invoiced Quantity")
{

}Column("Cost_per_Unit";"Cost per Unit")
{

}Column("Cost_Posted_to_G_L";"Cost Posted to G/L")
{

}Column("Expected_Cost";"Expected Cost")
{

}Column("Cost_Amount_Actual";"Cost Amount (Actual)")
{

}Column("Cost_Amount_Expected";"Cost Amount (Expected)")
{

}Column("Cost_Amount_Non_Invtbl";"Cost Amount (Non-Invtbl.)")
{

}Column("Sales_Amount_Actual";"Sales Amount (Actual)")
{

}Column("Sales_Amount_Expected";"Sales Amount (Expected)")
{

}Column("Purchase_Amount_Actual";"Purchase Amount (Actual)")
{

}Column("Purchase_Amount_Expected";"Purchase Amount (Expected)")
{

}Column("Dimension_Set_ID";"Dimension Set ID")
{

}DataItem("Item";"Item")
{

DataItemLink="No."= "Value_Entry"."Item No.";
Column(Item_Description;"Description")
{

}
}
}
}
  

    /*begin
    end.
  */
}




