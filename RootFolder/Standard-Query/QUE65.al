query 50173 "PowerBIVend. Item Ledg. Ent. 1"
{


    CaptionML = ENU = 'Vendor Item Ledger Entries', ESP = 'Movs. producto proveedor';

    elements
    {

        DataItem("Vendor"; "Vendor")
        {

            Column("No"; "No.")
            {

            }
            DataItem("Item_Ledger_Entry"; "Item Ledger Entry")
            {

                DataItemTableFilter = "Source Type" = CONST("Vendor");
                DataItemLink = "Source No." = "Vendor"."No.";
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




