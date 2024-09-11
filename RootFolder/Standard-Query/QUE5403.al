query 50225 "My Prod. Orders - By Cost 1"
{


    CaptionML = ENU = 'My Prod. Orders - By Cost', ESP = 'Mis �rdenes producci�n - Por coste';
    OrderBy = Descending(Cost_of_Open_Production_Orders);



    elements
    {

        DataItem("My_Item"; "My Item")
        {

            Filter("User_ID"; "User ID")
            {

            }
            DataItem("Prod_Order_Line"; "Prod. Order Line")
            {

                DataItemTableFilter = "Status" = FILTER('Planned' | 'Firm Planned' | 'Released');
                DataItemLink = "Item No." = "My_Item"."Item No.";
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
    }
    trigger OnBeforeOpen();
    BEGIN
        SETRANGE(User_ID, USERID);
    END;

    /*begin
    end.
  */
}




