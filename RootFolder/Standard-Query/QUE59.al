query 50167 "PowerBITop Cust. Overview 1"
{


    CaptionML = ENU = 'Power BI Top Cust. Overview', ESP = 'Inf. general principales clientes Power BI';

    elements
    {
        DataItem("Cust_Ledger_Entry"; "Cust. Ledger Entry")
        {

            Column("Entry_No"; "Entry No.")
            {
                CaptionML = ENU = 'Entry No.', ESP = 'N.� de movimiento';
            }
            Column("Posting_Date"; "Posting Date")
            {
                CaptionML = ENU = 'Posting Date', ESP = 'Fecha reg.';
            }
            Column("Customer_No"; "Customer No.")
            {
                CaptionML = ENU = 'Customer No.', ESP = 'N.� de cliente';
            }
            Column("Sales_LCY"; "Sales (LCY)")
            {
                CaptionML = ENU = 'Sales (LCY)', ESP = 'Ventas (DL)';
            }
            DataItem("Customer"; "Customer")
            {

                DataItemLink = "No." = "Cust_Ledger_Entry"."Customer No.";
                Column("Name"; "Name")
                {
                    CaptionML = ENU = 'Name', ESP = 'Nombre';
                }
            }
        }
    }

    /*begin
    end.
  */
}




