query 50223 "PendingProd.Orders - by Cost 1"
{


    CaptionML = ENU = 'Pending Prod. Orders - by Cost', ESP = '�rdenes producci�n pendientes - Por coste';
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
            Filter("Due_Date"; "Due Date")
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

    trigger OnBeforeOpen();
    BEGIN
        SETFILTER(Due_Date, '>=%1', TODAY);
    END;


    /*begin
    end.
  */
}




