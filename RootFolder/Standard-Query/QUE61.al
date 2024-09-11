query 50169 "PowerBICust. Item Ledg. Ent. 1"
{


    CaptionML = ENU = 'Power BI Cust. Item Ledg. Ent.', ESP = 'Mov. prod. cliente Power BI';

    elements
    {

        DataItem("Customer"; "Customer")
        {

            Column("No"; "No.")
            {

            }
            DataItem("Item_Ledger_Entry"; "Item Ledger Entry")
            {

                DataItemTableFilter = "Source Type" = CONST("Customer");
                DataItemLink = "Source No." = "Customer"."No.";
                Column("Item_No"; "Item No.")
                {

                }
                Column("Quantity"; "Quantity")
                {

                }
            }
        }
    }


    /*begin
    end.
  */
}




