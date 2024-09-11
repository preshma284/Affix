query 50176 "Item Sales by Customer 1"
{


    CaptionML = ENU = 'Item Sales by Customer', ESP = 'Ventas de productos por cliente';

    elements
    {

        DataItem("Value_Entry"; "Value Entry")
        {

            DataItemTableFilter = "Source Type" = FILTER("Customer"),
                                   "Item Ledger Entry No." = FILTER(<> 0),
                                   "Document Type" = FILTER("Sales Invoice");
            //Added In the base query
            //filter("Sales Invoice" | "Sales Credit Memo");
            Column("Entry_No"; "Entry No.")
            {

            }
            Column("Document_No"; "Document No.")
            {

            }
            Column("Posting_Date"; "Posting Date")
            {

            }
            Column("Item_No"; "Item No.")
            {

            }
            Column("Item_Ledger_Entry_Quantity"; "Item Ledger Entry Quantity")
            {

            }
            Column("Dimension_Set_ID"; "Dimension Set ID")
            {

            }
            DataItem("Customer"; "Customer")
            {

                DataItemLink = "No." = "Value_Entry"."Source No.";
                Column(CustomerNo; "No.")
                {

                }
                Column("Name"; "Name")
                {

                }
                DataItem("Item"; "Item")
                {

                    DataItemLink = "No." = "Value_Entry"."Item No.";
                    Column("Description"; "Description")
                    {

                    }
                    Column("Gen_Prod_Posting_Group"; "Gen. Prod. Posting Group")
                    {

                    }
                }
            }
        }
    }


    /*begin
    end.
  */
}




