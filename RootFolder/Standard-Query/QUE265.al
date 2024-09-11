query 50197 "Item Ledger Entries 1"
{


    CaptionML = ENU = 'Item Ledger Entries', ESP = 'Movs. productos';

    elements
    {

        DataItem("Item_Ledger_Entry"; "Item Ledger Entry")
        {

            Column("Entry_No"; "Entry No.")
            {

            }
            Column("Entry_Type"; "Entry Type")
            {

            }
            Column("Item_No"; "Item No.")
            {

            }
            Column("Item_Reference_No"; "Item Reference No.")
            {

            }
            Column("Lot_No"; "Lot No.")
            {

            }
            Column("Item_Category_Code"; "Item Category Code")
            {

            }
            Column("Posting_Date"; "Posting Date")
            {

            }
            Column("Expiration_Date"; "Expiration Date")
            {

            }
            Column("Warranty_Date"; "Warranty Date")
            {

            }
            Column("Document_Date"; "Document Date")
            {

            }
            Column("Document_No"; "Document No.")
            {

            }
            Column("Document_Type"; "Document Type")
            {

            }
            Column("Location_Code"; "Location Code")
            {

            }
            Column("Job_No"; "Job No.")
            {

            }
            Column("Job_Task_No"; "Job Task No.")
            {

            }
            Column("Open"; "Open")
            {

            }
            Column("Quantity"; "Quantity")
            {

            }
            Column("Unit_of_Measure_Code"; "Unit of Measure Code")
            {

            }
            Column("Qty_per_Unit_of_Measure"; "Qty. per Unit of Measure")
            {

            }
            Column("Remaining_Quantity"; "Remaining Quantity")
            {

            }
            Column("Invoiced_Quantity"; "Invoiced Quantity")
            {

            }
            Column("Cost_Amount_Expected"; "Cost Amount (Expected)")
            {

            }
            Column("Cost_Amount_Actual"; "Cost Amount (Actual)")
            {

            }
            Column("Cost_Amount_Non_Invtbl"; "Cost Amount (Non-Invtbl.)")
            {

            }
            Column("Purchase_Amount_Expected"; "Purchase Amount (Expected)")
            {

            }
            Column("Purchase_Amount_Actual"; "Purchase Amount (Actual)")
            {

            }
            Column("Sales_Amount_Expected"; "Sales Amount (Expected)")
            {

            }
            Column("Sales_Amount_Actual"; "Sales Amount (Actual)")
            {

            }
            Column("Dimension_Set_ID"; "Dimension Set ID")
            {

            }
            DataItem("Item"; "Item")
            {

                DataItemLink = "No." = "Item_Ledger_Entry"."Item No.";
                Column(Item_Description; "Description")
                {

                }
            }
        }
    }


    /*begin
    end.
  */
}




