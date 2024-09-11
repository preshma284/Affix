query 50185 "EU VAT Entries 1"
{


    CaptionML = ENU = 'EU VAT Entries', ESP = 'Movimientos de IVA de UE';

    elements
    {

        DataItem("VAT_Entry"; "VAT Entry")
        {

            DataItemTableFilter = "Type" = CONST("Sale");
            Column("Base"; "Base")
            {

            }
            Column(PostingDate; "Posting Date")
            {

            }
            //ADDed in base query
            // column(VATReportingDate; "VAT Reporting Date")
            // {
            // }
            // column(DocumentDate; "Document Date")
            // {
            // }
            Column("Type"; "Type")
            {

            }
            Column("EU_3_Party_Trade"; "EU 3-Party Trade")
            {

            }
            Column("VAT_Registration_No"; "VAT Registration No.")
            {

            }
            Column("EU_Service"; "EU Service")
            {

            }
            Column("Entry_No"; "Entry No.")
            {

            }
            DataItem("Country_Region"; "Country/Region")
            {

                DataItemTableFilter = "EU Country/Region Code" = FILTER(<> '');
                DataItemLink = "Code" = "VAT_Entry"."Country/Region Code";
                SqlJoinType = InnerJoin;
                //DataItemLinkType=Exclude Row If No Match;
                Column("Name"; "Name")
                {

                }
                Column("EU_Country_Region_Code"; "EU Country/Region Code")
                {

                }
                Column(CountryCode; "Code")
                {

                }
            }
        }
    }


    /*begin
    end.
  */
}




