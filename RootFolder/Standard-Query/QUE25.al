query 50157 "Vend.Ledg.Entry Remain. Amt. 1"
{


    CaptionML = ENU = 'Vend. Ledg. Entry Remain. Amt.', ESP = 'Importe restante movs. proveedores';

    elements
    {

        DataItem("Vendor_Ledger_Entry"; "Vendor Ledger Entry")
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
            Filter("Vendor_No"; "Vendor No.")
            {

            }
            Filter("Vendor_Posting_Group"; "Vendor Posting Group")
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




