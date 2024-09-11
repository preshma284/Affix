query 50160 "Power BI Item Purchase List 1"
{
  
  
    CaptionML=ENU='Power BI Item Purchase List',ESP='Lista de compra del producto Power BI';
  
  elements
{

DataItem("Item";"Item")
{

Column(Item_No;"No.")
{

}Column("Search_Description";"Search Description")
{

}DataItem("Item_Ledger_Entry";"Item Ledger Entry")
{

               DataItemTableFilter="Entry Type"=CONST("Purchase");
DataItemLink="Item No."=Item."No.";
Column(Purchase_Post_Date;"Posting Date")
{

}Column(Purchased_Quantity;"Invoiced Quantity")
{

}Column(Purchase_Entry_No;"Entry No.")
{

}
}
}
}
  

    /*begin
    end.
  */
}




