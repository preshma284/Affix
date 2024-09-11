query 50163 "Power BI Sales List 1"
{
  
  
    CaptionML=ENU='Power BI Sales List',ESP='Lista de ventas de Power BI';
  
  elements
{

DataItem("Sales_Header";"Sales Header")
{

Column(Document_No;"No.")
{

}Column("Requested_Delivery_Date";"Requested Delivery Date")
{

}Column("Shipment_Date";"Shipment Date")
{

}Column("Due_Date";"Due Date")
{

}DataItem("Sales_Line";"Sales Line")
{

DataItemLink="Document No."= "Sales_Header"."No.";
Column("Quantity";"Quantity")
{

}Column("Amount";"Amount")
{

}Column(Item_No;"No.")
{

}Column("Description";"Description")
{

}
}
}
}
  

    /*begin
    end.
  */
}




