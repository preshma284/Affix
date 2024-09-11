query 50184 "OCR Vendor Bank Accounts 1"
{


    CaptionML = ENU = 'OCR Vendor Bank Accounts', ESP = 'Bancos de proveedor de OCR';

    elements
    {

        DataItem("Vendor_Bank_Account"; "Vendor Bank Account")
        {

            DataItemTableFilter = "Bank Account No." = FILTER(<> '');
            Column("Name"; "Name")
            {

            }
            Column("Bank_Branch_No"; "Bank Branch No.")
            {

            }
            Column("Bank_Account_No"; "Bank Account No.")
            {

            }
            DataItem("Vendor"; "Vendor")
            {

                DataItemLink = "No." = "Vendor_Bank_Account"."Vendor No.";
                SqlJoinType = InnerJoin;
                //DataItemLinkType=Exclude Row If No Match;
                Column("Id"; SystemId)
                {

                }
                Column("No"; "No.")
                {

                }
                //fix added from base query
                Column("ModifiedAt"; SystemModifiedAt)
                {

                }
                //The table Integration Record is removed and replaced by SystemID fields
                // DataItem("Integration_Record";"Integration Record")
                // {

                //                DataItemTableFilter="Table ID"=CONST(23);
                // DataItemLink="Integration ID"= "Vendor".Id;
                //                SqlJoinType= InnerJoin;
                //DataItemLinkType=Exclude Row If No Match;
                // Column("Modified_On";"Modified On")
                // {

                // }
                //}
            }
        }
    }


    /*begin
    end.
  */
}




