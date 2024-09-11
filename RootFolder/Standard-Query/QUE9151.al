query 50236 "My Vendors 1"
{


    CaptionML = ENU = 'My Vendors', ESP = 'Mis proveedores';



    elements
    {

        DataItem("My_Vendor"; "My Vendor")
        {

            Filter("User_ID"; "User ID")
            {

            }
            Column("Vendor_No"; "Vendor No.")
            {

            }
            DataItem("Vendor"; "Vendor")
            {

                DataItemLink = "No." = "My_Vendor"."Vendor No.";
                Filter("Date_Filter"; "Date Filter")
                {

                }
                Column("Balance"; "Balance")
                {

                    //MethodType=Totals;
                    Method = Sum;
                }
                Column("Invoice_Amounts"; "Invoice Amounts")
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




