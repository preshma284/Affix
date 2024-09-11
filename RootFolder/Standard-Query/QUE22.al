query 50156 "Cust.Remain.Amt. By Due Date 1"
{


    CaptionML = ENU = 'Cust. Remain. Amt. By Due Date', ESP = 'Imp. restante cli. por vencimiento';

    elements
    {

        DataItem("Cust_Ledger_Entry"; "Cust. Ledger Entry")
        {

            Filter(IsOpen; "Open")
            {

            }
            Column("Due_Date"; "Due Date")
            {

            }
            Column("Customer_Posting_Group"; "Customer Posting Group")
            {

            }
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




