query 50155 "Cust.Ledg.Entry Remain. Amt. 1"
{


    CaptionML = ENU = 'Cust. Ledg. Entry Remain. Amt.', ESP = 'Importe restante movs. clientes';

    elements
    {

        DataItem("Cust_Ledger_Entry"; "Cust. Ledger Entry")
        {

            Filter("Document_Type"; "Document Type")
            {

            }
            Filter(IsOpen; "Open")
            {

            }
            Filter("Due_Date"; "Due Date")
            {

            }
            Filter("Customer_No"; "Customer No.")
            {

            }
            Filter("Customer_Posting_Group"; "Customer Posting Group")
            {

            }
            //Added Date Filter in Base query
            // filter(Date_Filter; "Date Filter")
            // {
            // }
            Column("Remaining_Amt_LCY"; "Remaining Amt. (LCY)")
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




