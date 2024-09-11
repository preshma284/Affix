query 50178 "Sales Orders by Sales Person 1"
{
  
  
    CaptionML=ENU='Sales Orders by Sales Person',ESP='Pedidos de ventas por vendedor';
  
  elements
{

DataItem("Sales_Line";"Sales Line")
{

Column(ItemNo;"No.")
{

}Column(ItemDescription;"Description")
{

}Column("Document_No";"Document No.")
{

}Column("Posting_Date";"Posting Date")
{

}Column("Amount";"Amount")
{

}Column("Line_No";"Line No.")
{

}Column("Dimension_Set_ID";"Dimension Set ID")
{

}DataItem("Currency";"Currency")
{

DataItemLink="Code"= "Sales_Line"."Currency Code";
Column(CurrenyDescription;"Description")
{

}DataItem("Sales_Header";"Sales Header")
{

DataItemLink="No."= "Sales_Line"."Document No.";
Column("Currency_Code";"Currency Code")
{

}DataItem("Salesperson_Purchaser";"Salesperson/Purchaser")
{

DataItemLink="Code"= "Sales_Header"."Salesperson Code";
Column(SalesPersonCode;"Code")
{

}Column(SalesPersonName;"Name")
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




