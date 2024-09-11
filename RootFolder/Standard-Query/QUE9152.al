query 50237 "My Items 1"
{


    CaptionML = ENU = 'My Items', ESP = 'Mis art�culos';



    elements
    {

        DataItem("My_Item"; "My Item")
        {

            Filter("User_ID"; "User ID")
            {

            }
            Column("Item_No"; "Item No.")
            {

            }
            DataItem("Prod_Order_Line"; "Prod. Order Line")
            {

                DataItemLink = "Item No." = "My_Item"."Item No.";
                Filter("Date_Filter"; "Date Filter")
                {

                }
                Column("Status"; "Status")
                {

                }
                Column("Remaining_Quantity"; "Remaining Quantity")
                {

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




