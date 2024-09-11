query 50226 "My Delayed Prod. Orders 1"
{


    CaptionML = ENU = 'My Delayed Prod. Orders', ESP = 'Mis �rdenes producci�n retrasadas';



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
                Filter("Due_Date"; "Due Date")
                {

                }
                Column("Remaining_Quantity"; "Remaining Quantity")
                {

                    //MethodType=Totals;
                    Method = Sum;
                }
            }
        }
    }
    trigger OnBeforeOpen();
    BEGIN
        SETFILTER(Due_Date, '<%1', TODAY);
        SETRANGE(User_ID, USERID);
    END;

    /*begin
    end.
  */
}




