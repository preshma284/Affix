query 50101 "QuoFacturae_CrMGroupedConcepts"
{


    // Query Id: 50101 //7174341
    // Column name in query file (but without underscore):
    // VAT_Prod_Posting_Group

    // Missing column name:
    // Sum_VAT_Base_Amount

    //     Query Id: 50101 //7174341
    // Column name in query file (but without underscore):
    // Document_No
    // Description_2
    // Unit_of_Measure_Code
    // Line_Discount

    // Missing column name:
    // Sum_Unit_Price
    // Sum_Amount
    // Sum_Line_Discount_Amount
    elements
    {

        DataItem("Sales_Cr_Memo_Line"; "Sales Cr.Memo Line")
        {

            Filter("Document_No"; "Document No.")
            {

            }
            Column("Description"; "Description")
            {

            }
            Column("Description_2"; "Description 2")
            {

            }
            Column("Quantity"; "Quantity")
            {

            }
            Column("Unit_of_Measure_Code"; "Unit of Measure Code")
            {

            }
            Column("Sum_Unit_Price"; "Unit Price")
            {

                //MethodType=Totals;
                Method = Sum;
            }
            Column("Sum_Amount"; "Amount")
            {

                //MethodType=Totals;
                Method = Sum;
            }
            Column("Line_Discount"; "Line Discount %")
            {

            }
            Column("EC"; "EC %")
            {

            }
            Column("VATBaseAmount"; "VAT Base Amount")
            {

            }
            Column("Sum_Line_Discount_Amount"; "Line Discount Amount")
            {

                //MethodType=Totals;
                Method = Sum;
            }
            Column("VAT_Prod_Posting_Group"; "VAT Prod. Posting Group")
            {

            }
            Column("VAT"; "VAT %")
            {

            }
            Column("Sum_VAT_Base_Amount"; "VAT Base Amount")
            {

                //MethodType=Totals;
                Method = Sum;
            }
            Column("AmountIncludingVAT"; "Amount Including VAT")
            {

                //MethodType=Totals;
                Method = Sum;
            }
            Column("No"; "No.")
            {

            }
        }
    }


    /*begin
    end.
  */
}








