query 50183 "OCR Vendors 1"
{


    CaptionML = ENU = 'OCR Vendors', ESP = 'Proveedores de OCR';

    elements
    {

        DataItem("Vendor"; "Vendor")
        {

            DataItemTableFilter = "Name" = FILTER(<> '');
            Column("Id"; SystemId)
            {

            }
            Column("No"; "No.")
            {

            }
            Column("VAT_Registration_No"; "VAT Registration No.")
            {

            }
            Column("Name"; "Name")
            {

            }
            Column("Address"; "Address")
            {

            }
            Column("Post_Code"; "Post Code")
            {

            }
            Column("City"; "City")
            {

            }
            Column("Phone_No"; "Phone No.")
            {

            }
            Column("Blocked"; "Blocked")
            {

            }
            //Fix added from base table
            Column("ModifiedAt"; SystemModifiedAt)
            {

            }
            //The table Integration Record is removed and replaced by SystemID fields
            // DataItem("Integration_Record"; "Integration Record")
            // {

            //     DataItemTableFilter = "Table ID" = CONST(23);
            //     DataItemLink = "Integration ID" = "Vendor".SystemId;
            //     SqlJoinType= InnerJoin;
            // //DataItemLinkType=Exclude Row If No Match;
            //     Column("Modified_On"; "Modified On")
            //     {

            //     }
            // }
        }
    }


    /*begin
    end.
  */
}




