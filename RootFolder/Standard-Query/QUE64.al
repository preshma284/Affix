query 50172 "PowerBIPurchase Hdr. Vendor 1"
{


    CaptionML = ENU = 'Power BI Purchase Hdr. Vendor', ESP = 'Encab. proveedor compra Power BI';

    elements
    {

        DataItem("Purchase_Header"; "Purchase Header")
        {

            Column("No"; "No.")
            {

            }
            DataItem("Purchase_Line"; "Purchase Line")
            {

                DataItemTableFilter = "Type" = CONST("Item");
                DataItemLink = "Document Type" = "Purchase_Header"."Document Type",
                            "Document No." = "Purchase_Header"."No.";
                Column(Item_No; "No.")
                {

                }
                Column("Quantity"; "Quantity")
                {

                }
                DataItem("Item"; "Item")
                {

                    DataItemLink = "No." = "Purchase_Line"."No.";
                    Column("Base_Unit_of_Measure"; "Base Unit of Measure")
                    {

                    }
                    Column("Description"; "Description")
                    {

                    }
                    Column("Inventory"; "Inventory")
                    {

                    }
                    Column("Qty_on_Purch_Order"; "Qty. on Purch. Order")
                    {

                    }
                    Column("Unit_Price"; "Unit Price")
                    {

                    }
                    DataItem("Vendor"; "Vendor")
                    {

                        DataItemLink = "No." = "Purchase_Header"."Buy-from Vendor No.";
                        Column(Vendor_No; "No.")
                        {

                        }
                        Column("Name"; "Name")
                        {

                        }
                        Column("Balance"; "Balance")
                        {

                        }
                        Column("Country_Region_Code"; "Country/Region Code")
                        {

                        }
                    }
                }
            }
        }
    }


    /*begin
    end.
  */
}




