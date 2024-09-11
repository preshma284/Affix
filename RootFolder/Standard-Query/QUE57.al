query 50165 "Power BI Item Sales List 1"
{
  
  
    CaptionML=ENU='Power BI Item Sales List',ESP='Lista de ventas del producto Power BI';
  
  elements
{

DataItem("Item";"Item")
{

Column(Item_No;"No.")
{

}Column("Search_Description";"Search Description")
{

}DataItem("Value_Entry";"Value Entry")
{

               DataItemTableFilter="Item Ledger Entry Type"=CONST("Sale");
DataItemLink="Item No."=Item."No.";
Column(Sales_Post_Date;"Posting Date")
{

}Column(Sold_Quantity;"Invoiced Quantity")
{
ReverseSign=false;
}Column(Sales_Entry_No;"Entry No.")
{

}
}
}
}
  

    /*begin
    end.
  */
}




