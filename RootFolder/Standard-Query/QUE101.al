query 50175 "Sales Dashboard 1"
{
  
  
    CaptionML=ENU='Sales Dashboard',ESP='Panel de ventas';
  
  elements
{

DataItem("Item_Ledger_Entry";"Item Ledger Entry")
{

               DataItemTableFilter="Entry Type"=FILTER("Sale");
Column("Entry_No";"Entry No.")
{

}Column("Document_No";"Document No.")
{

}Column("Posting_Date";"Posting Date")
{

}Column("Entry_Type";"Entry Type")
{

}Column("Quantity";"Quantity")
{

}Column("Sales_Amount_Actual";"Sales Amount (Actual)")
{

}Column("Sales_Amount_Expected";"Sales Amount (Expected)")
{

}Column("Cost_Amount_Actual";"Cost Amount (Actual)")
{

}Column("Cost_Amount_Expected";"Cost Amount (Expected)")
{

}Column("Dimension_Set_ID";"Dimension Set ID")
{

}DataItem("Country_Region";"Country/Region")
{

DataItemLink="Code"= "Item_Ledger_Entry"."Country/Region Code";
Column(CountryRegionName;"Name")
{

}DataItem("Customer";"Customer")
{

DataItemLink="No."= "Item_Ledger_Entry"."Source No.";
Column(CustomerName;"Name")
{

}Column("Customer_Posting_Group";"Customer Posting Group")
{

}Column("Customer_Disc_Group";"Customer Disc. Group")
{

}Column("City";"City")
{

}DataItem("Item";"Item")
{

DataItemLink="No."= "Item_Ledger_Entry"."Item No.";
Column("Description";"Description")
{

}DataItem("Salesperson_Purchaser";"Salesperson/Purchaser")
{

DataItemLink="Code"= "Customer"."Salesperson Code";
Column(SalesPersonName;"Name")
{

}
}
}
}
}
}
}
  

    /*begin
    end.
  */
}




