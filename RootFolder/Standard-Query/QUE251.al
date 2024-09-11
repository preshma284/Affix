query 50187 "G/L Budget Entry Dimensions 1"
{


    CaptionML = ENU = 'G/L Budget Entry Dimensions', ESP = 'Dimensiones de movimiento de presupuesto';

    elements
    {
        DataItem("G_L_Budget_Entry"; "G/L Budget Entry")
        {

            Filter("Budget_Name"; "Budget Name")
            {

            }
            Filter("G_L_Account_No"; "G/L Account No.")
            {

            }
            Filter("Date"; "Date")
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
        }
    }

    /*begin
    end.
  */
}




