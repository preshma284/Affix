query 50177 "Item Sales and Profit 1"
{
  
  
    CaptionML=ENU='Item Sales and Profit',ESP='Ventas y beneficios de los productos';
  
  elements
{

DataItem("Item";"Item")
{

Column("No";"No.")
{

}Column("Description";"Description")
{

}Column("Gen_Prod_Posting_Group";"Gen. Prod. Posting Group")
{

}Column("Item_Disc_Group";"Item Disc. Group")
{

}Column("Item_Tracking_Code";"Item Tracking Code")
{

}Column("Profit_";"Profit %")
{

}Column("Scrap_";"Scrap %")
{

}Column("Sales_Unit_of_Measure";"Sales Unit of Measure")
{

}Column("Standard_Cost";"Standard Cost")
{

}Column("Unit_Cost";"Unit Cost")
{

}Column("Unit_Price";"Unit Price")
{

}Column("Unit_Volume";"Unit Volume")
{

}Column("Vendor_No";"Vendor No.")
{

}Column("Purch_Unit_of_Measure";"Purch. Unit of Measure")
{

}Column("COGS_LCY";"COGS (LCY)")
{

}Column("Inventory";"Inventory")
{

}Column("Net_Change";"Net Change")
{

}Column("Net_Invoiced_Qty";"Net Invoiced Qty.")
{

}Column("Purchases_LCY";"Purchases (LCY)")
{

}Column("Purchases_Qty";"Purchases (Qty.)")
{

}Column("Sales_LCY";"Sales (LCY)")
{

}Column("Sales_Qty";"Sales (Qty.)")
{

}DataItem("Vendor";"Vendor")
{

DataItemLink="No."= "Item"."Vendor No.";
Column(VendorName;"Name")
{

}
}
}
}
  

    /*begin
    end.
  */
}




