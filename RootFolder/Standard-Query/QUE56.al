query 50164 "Power BI Purchase List 1"
{
  
  
    CaptionML=ENU='Power BI Purchase List',ESP='Lista de compras de Power BI';
  
  elements
{

DataItem("Purchase_Header";"Purchase Header")
{

Column(Document_No;"No.")
{

}Column("Order_Date";"Order Date")
{

}Column("Expected_Receipt_Date";"Expected Receipt Date")
{

}Column("Due_Date";"Due Date")
{

}Column("Pmt_Discount_Date";"Pmt. Discount Date")
{

}DataItem("Purchase_Line";"Purchase Line")
{

DataItemLink="Document No."= "Purchase_Header"."No.";
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




