query 50215 "Top 10 Customer Sales 1"
{


    CaptionML = ENU = 'Top 10 Customer Sales', ESP = 'Ventas 10 mejores clientes';
    TopNumberOfRows = 10;
    OrderBy = Descending(Sum_Sales_LCY);

    elements
    {

        DataItem("Cust_Ledger_Entry"; "Cust. Ledger Entry")
        {

            Filter("Posting_Date"; "Posting Date")
            {

            }
            Column("Customer_No"; "Customer No.")
            {

            }
            Column("Sum_Sales_LCY"; "Sales (LCY)")
            {

                //MethodType=Totals;
                Method = Sum;
            }
        }
    }


    /*begin
    end.
  */
}




