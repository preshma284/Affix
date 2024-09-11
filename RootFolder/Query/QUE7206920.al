query 50104 "QB BI Item Ledger Entry"
{


    elements
    {

        DataItem("Item_Ledger_Entry"; "Item Ledger Entry")
        {

            Column("EntryNo"; "Entry No.")
            {

            }
            Column("EntryType"; "Entry Type")
            {

            }
            Column("ItemNo"; "Item No.")
            {

            }
            Column("ItemReferenceNo"; "Item Reference No.")
            {

            }
            Column("LotNo"; "Lot No.")
            {

            }
            Column("ItemCategoryCode"; "Item Category Code")
            {

            }
            Column("PostingDate"; "Posting Date")
            {

            }
            Column("ExpirationDate"; "Expiration Date")
            {

            }
            Column("WarrantyDate"; "Warranty Date")
            {

            }
            Column("DocumentDate"; "Document Date")
            {

            }
            Column("DocumentNo"; "Document No.")
            {

            }
            Column("DocumentType"; "Document Type")
            {

            }
            Column("LocationCode"; "Location Code")
            {

            }
            Column("JobNo"; "Job No.")
            {

            }
            Column("JobTaskNo"; "Job Task No.")
            {

            }
            Column("Open"; "Open")
            {

            }
            Column("Quantity"; "Quantity")
            {

            }
            Column("UnitofMeasureCode"; "Unit of Measure Code")
            {

            }
            Column("QtyperUnitofMeasure"; "Qty. per Unit of Measure")
            {

            }
            Column("RemainingQuantity"; "Remaining Quantity")
            {

            }
            Column("InvoicedQuantity"; "Invoiced Quantity")
            {

            }
            Column("CostAmountExpected"; "Cost Amount (Expected)")
            {

            }
            Column("CostAmountActual"; "Cost Amount (Actual)")
            {

            }
            Column("CostAmountNonInvtbl"; "Cost Amount (Non-Invtbl.)")
            {

            }
            Column("PurchaseAmountExpected"; "Purchase Amount (Expected)")
            {

            }
            Column("PurchaseAmountActual"; "Purchase Amount (Actual)")
            {

            }
            Column("SalesAmountExpected"; "Sales Amount (Expected)")
            {

            }
            Column("SalesAmountActual"; "Sales Amount (Actual)")
            {

            }
            Column("DimensionSetID"; "Dimension Set ID")
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








