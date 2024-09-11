query 50224 "Top-10Prod.Orders - by Cost 1"
{


    CaptionML = ENU = 'Top-10 Prod. Orders - by Cost', ESP = '10 mejores �rdenes producci�n - Por coste';
    TopNumberOfRows = 10;
    OrderBy = Descending(Cost_of_Open_Production_Orders);

    elements
    {

        DataItem("Prod_Order_Line"; "Prod. Order Line")
        {

            DataItemTableFilter = "Status" = FILTER('Planned' | 'Firm Planned' | 'Released');
            Column("Item_No"; "Item No.")
            {

            }
            Column("Status"; "Status")
            {

            }
            Column("Remaining_Quantity"; "Remaining Quantity")
            {

                //MethodType=Totals;
                Method = Sum;
            }
            DataItem("Item"; "Item")
            {

                DataItemLink = "No." = "Prod_Order_Line"."Item No.";
                Column("Cost_of_Open_Production_Orders"; "Cost of Open Production Orders")
                {

                }
            }
        }
    }


    /*begin
    end.
  */
}




