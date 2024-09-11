query 50235 "My Customers 1"
{


    CaptionML = ENU = 'My Customers', ESP = 'Mis clientes';



    elements
    {

        DataItem("My_Customer"; "My Customer")
        {

            Filter("User_ID"; "User ID")
            {

            }
            Column("Customer_No"; "Customer No.")
            {

            }
            DataItem("Customer"; "Customer")
            {

                DataItemLink = "No." = "My_Customer"."Customer No.";
                Filter("Date_Filter"; "Date Filter")
                {

                }
                Column("Sales_LCY"; "Sales (LCY)")
                {

                    //MethodType=Totals;
                    Method = Sum;
                }
                Column("Profit_LCY"; "Profit (LCY)")
                {

                    //MethodType=Totals;
                    Method = Sum;
                }
            }
        }
    }

    trigger OnBeforeOpen();
    BEGIN
        SETRANGE(User_ID, USERID);
    END;

    /*begin
    end.
  */
}




