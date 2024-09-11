query 50188 "AnalysisViewEntry Dimensions 1"
{


    CaptionML = ENU = 'Analysis View Entry Dimensions', ESP = 'Dimensiones de movimiento de la vista de an�lisis';

    elements
    {
        DataItem("Analysis_View_Entry"; "Analysis View Entry")
        {

            //DataItemLinkType=SQL Advanced Options;
            SQLJoinType = CrossJoin;
            Filter("Analysis_View_Code"; "Analysis View Code")
            {

            }
            Filter("Business_Unit_Code"; "Business Unit Code")
            {

            }
            Filter("Account_No"; "Account No.")
            {

            }
            Filter("Posting_Date"; "Posting Date")
            {

            }
            Filter("Account_Source"; "Account Source")
            {

            }
            Filter("Cash_Flow_Forecast_No"; "Cash Flow Forecast No.")
            {

            }
            Column("Dimension_1_Value_Code"; "Dimension 1 Value Code")
            {

            }
            Column("Dimension_2_Value_Code"; "Dimension 2 Value Code")
            {

            }
            Column("Dimension_3_Value_Code"; "Dimension 3 Value Code")
            {

            }
            Column("Dimension_4_Value_Code"; "Dimension 4 Value Code")
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




