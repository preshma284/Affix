query 50100 "QuoFacturae_InvGroupedConcepts"
{

    // Query Id: 50100 //7174340
    // Column names in query file (but without underscore):
    // Document_No
    // Unit_of_Measure_Code
    // Line_Discount
    // VAT_Prod_Posting_Group
    // Description_2

    // Missing column names:
    // Sum_Unit_Price
    // Sum_Amount_Including_VAT
    // Sum_Line_Discount_Amount
    // Sum_VAT_Base_Amount
    // Sum_Amount

    //     Query Id: 50100 //7174340
    // Column names in query file (but without underscore):
    // VAT_Prod_Posting_Group

    elements
    {

        DataItem("Sales_Invoice_Line"; "Sales Invoice Line")
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
            Column("Sum_Amount_Including_VAT"; "Amount Including VAT")
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








