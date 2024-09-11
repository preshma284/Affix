query 50168 "Power BI Sales Hdr. Cust. 1"
{
  
  
    CaptionML=ENU='Power BI Sales Hdr. Cust.',ESP='Encabezado cl. ventas Power BI';
  
  elements
{

DataItem("Sales_Header";"Sales Header")
{

Column("No";"No.")
{

}DataItem("Sales_Line";"Sales Line")
{

               DataItemTableFilter="Type"=CONST("Item");
DataItemLink="Document Type"= "Sales_Header"."Document Type",
                            "Document No."= "Sales_Header"."No.";
Column(Item_No;"No.")
{

}Column("Quantity";"Quantity")
{

}Column("Qty_Invoiced_Base";"Qty. Invoiced (Base)")
{

}Column("Qty_Shipped_Base";"Qty. Shipped (Base)")
{

}DataItem("Item";"Item")
{

DataItemLink="No."= "Sales_Line"."No.";
Column("Base_Unit_of_Measure";"Base Unit of Measure")
{

}Column("Description";"Description")
{

}Column("Inventory";"Inventory")
{

}Column("Unit_Price";"Unit Price")
{

}DataItem("Customer";"Customer")
{

DataItemLink="No."= "Sales_Line"."Sell-to Customer No.";
Column(Customer_No;"No.")
{

}Column("Name";"Name")
{

}Column("Balance";"Balance")
{

}Column("Country_Region_Code";"Country/Region Code")
{

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




