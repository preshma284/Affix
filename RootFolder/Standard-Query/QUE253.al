query 50189 "AnalysisViewBudg. Entry Dims 1"
{


    CaptionML = ENU = 'Analysis View Budg. Entry Dims', ESP = 'Dimensiones de movimiento de presupuesto de la vista de an�lisis';

    elements
    {
        DataItem("Analysis_View_Budget_Entry"; "Analysis View Budget Entry")
        {

            //DataItemLinkType=SQL Advanced Options;
            SQLJoinType = CrossJoin;
            Filter("Analysis_View_Code"; "Analysis View Code")
            {

            }
            Filter("Budget_Name"; "Budget Name")
            {

            }
            Filter("Business_Unit_Code"; "Business Unit Code")
            {

            }
            Filter("Posting_Date"; "Posting Date")
            {

            }
            Filter("G_L_Account_No"; "G/L Account No.")
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
        }
    }

    /*begin
    end.
  */
}




