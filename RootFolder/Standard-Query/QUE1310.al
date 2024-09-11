query 50214 "Cust. Ledg. Entry Sales 1"
{
  
  
    CaptionML=ENU='Cust. Ledg. Entry Sales',ESP='Ventas movs. clientes';
  
  elements
{

DataItem("Cust_Ledger_Entry";"Cust. Ledger Entry")
{

Filter("Document_Type";"Document Type")
{

}Filter(IsOpen;"Open")
{

}Filter("Customer_No";"Customer No.")
{

}Filter("Posting_Date";"Posting Date")
{

}Column("Sales_LCY";"Sales (LCY)")
{

               //MethodType=Totals;
               Method=Sum ;
}
}
}
  

    /*begin
    end.
  */
}




