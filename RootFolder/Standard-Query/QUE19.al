query 50154 "VAT Entries Base Amt. Sum 1"
{


    CaptionML = ENU = 'VAT Entries Base Amt. Sum', ESP = 'Suma importe base mov. IVA';
    OrderBy = Ascending(Country_Region_Code), Ascending(VAT_Registration_No);

    elements
    {

        DataItem("VAT_Entry"; "VAT Entry")
        {

            DataItemTableFilter = "Type" = CONST("Sale");
            Filter("Posting_Date"; "Posting Date")
            {

            }
            //Added in base query
            // filter(VAT_Date; "VAT Reporting Date")
            //             {
            //             }
            //             filter(Document_Date; "Document Date")
            //             {
            //             }

            Column("VAT_Registration_No"; "VAT Registration No.")
            {

            }
            Column("EU_3_Party_Trade"; "EU 3-Party Trade")
            {

            }
            Column("EU_Service"; "EU Service")
            {

            }
            Column("Country_Region_Code"; "Country/Region Code")
            {

            }
            Column("Base"; "Base")
            {

                //MethodType=Totals;
                Method = Sum;
            }
            Column("Additional_Currency_Base"; "Additional-Currency Base")
            {

                //MethodType=Totals;
                Method = Sum;
            }
            Column("Bill_to_Pay_to_No"; "Bill-to/Pay-to No.")
            {

            }
            DataItem("Country_Region"; "Country/Region")
            {

                DataItemLink = "Code" = "VAT_Entry"."Country/Region Code";
                Column("EU_Country_Region_Code"; "EU Country/Region Code")
                {
                    ColumnFilter = EU_Country_Region_Code = FILTER(<> '');
                }
            }
        }
    }


    /*begin
    end.
  */
}




