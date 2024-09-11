query 50186 "G/L Entry Dimensions 1"
{


    CaptionML = ENU = 'G/L Entry Dimensions', ESP = 'Dimensiones de movimiento de contabilidad';

    elements
    {
        DataItem("G_L_Entry"; "G/L Entry")
        {

            Filter("G_L_Account_No"; "G/L Account No.")
            {

            }
            Filter("Posting_Date"; "Posting Date")
            {

            }
            Filter("Business_Unit_Code"; "Business Unit Code")
            {

            }
            Filter("Global_Dimension_1_Code"; "Global Dimension 1 Code")
            {

            }
            Filter("Global_Dimension_2_Code"; "Global Dimension 2 Code")
            {

            }
            Column("Dimension_Set_ID"; "Dimension Set ID")
            {

            }
            Column("Amount"; "Amount")
            {

                //MethodType=Totals;
                Method = Sum;
            }
            Column("Debit_Amount"; "Debit Amount")
            {

                //MethodType=Totals;
                Method = Sum;
            }
            Column("Credit_Amount"; "Credit Amount")
            {

                //MethodType=Totals;
                Method = Sum;
            }
        }
    }

    /*begin
    end.
  */
}




