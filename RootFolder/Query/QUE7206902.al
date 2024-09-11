query 50103 "Ppto-Proyecto.Descompuestos"
{


    elements
    {

        DataItem("Job"; "Job")
        {

            Filter("No"; "No.")
            {

            }
            Column("CardType"; "Card Type")
            {

            }
            DataItem("Data_Piecework_For_Production"; "Data Piecework For Production")
            {

                DataItemTableFilter = "Account Type" = FILTER("Unit");
                DataItemLink = "Job No." = Job."No.";
                Filter("AccountType"; "Account Type")
                {

                }
                Filter("BudgetFilter"; "Budget Filter")
                {

                }
                Filter("FilterDate"; "Filter Date")
                {

                }
                DataItem("Data_Cost_By_Piecework"; "Data Cost By Piecework")
                {

                    DataItemLink = "Job No." = "Data_Piecework_For_Production"."Job No.",
                            "Piecework Code" = "Data_Piecework_For_Production"."Piecework Code",
                            "Analytical Concept Direct Cost" = "Data_Piecework_For_Production"."Filter Analytical Concept",
                            "Cod. Budget" = "Data_Piecework_For_Production"."Budget Filter",
                            "Assistant U. Code" = "Data_Piecework_For_Production"."Code U. Posting";
                    Column("BudgetCost"; "Budget Cost")
                    {
                        CaptionML = ENU = 'Aver. Cost Price Pend. Budget';
                        //MethodType=Totals;
                        Method = Sum;
                    }
                    DataItem("Expected_Time_Unit_Data"; "Expected Time Unit Data")
                    {

                        DataItemLink = "Job No." = "Data_Piecework_For_Production"."Job No.",
                            "Piecework Code" = "Data_Piecework_For_Production"."Piecework Code",
                            "Budget Code" = "Data_Piecework_For_Production"."Budget Filter";
                        Column("ExpectedMeasuredAmount"; "Expected Measured Amount")
                        {
                            CaptionML = ENU = 'Expected Measured Amount';
                            //MethodType=Totals;
                            Method = Sum;
                        }
                        DataItem(Amount_Sale_Performed_JC; "Hist. Prod. Measure Lines")
                        {

                            DataItemLink = "Job No." = "Data_Piecework_For_Production"."Job No.",
                            "Piecework No." = "Data_Piecework_For_Production"."Piecework Code",
                            "Posting Date" = "Data_Piecework_For_Production"."Filter Date";
                            Column("MeasureTerm"; "Measure Term")
                            {
                                CaptionML = ENU = 'Amount Sale Performed (JC)';
                                //MethodType=Totals;
                                Method = Sum;
                            }
                            DataItem(Amount_Production_Performed_JC; "Hist. Prod. Measure Lines")
                            {

                                DataItemLink = "Job No." = "Data_Piecework_For_Production"."Job No.",
                            "Piecework No." = "Data_Piecework_For_Production"."Piecework Code",
                            "Piecework No." = "Data_Piecework_For_Production".Totaling,
                            "Posting Date" = "Data_Piecework_For_Production"."Filter Date";
                                Column("PRODAmountTerm"; "PROD Amount Term")
                                {
                                    CaptionML = ENU = 'Amount Production Performed (JC)';
                                    //MethodType=Totals;
                                    Method = Sum;
                                }
                                DataItem("Job_Ledger_Entry"; "Job Ledger Entry")
                                {

                                    DataItemTableFilter = "Entry Type" = CONST("Sale");
                                    DataItemLink = "Job No." = "Data_Piecework_For_Production"."Job No.",
                            "Piecework No." = "Data_Piecework_For_Production"."Piecework Code",
                            "Piecework No." = "Data_Piecework_For_Production".Totaling,
                            "Posting Date" = "Data_Piecework_For_Production"."Filter Date";
                                    Column("TotalPrice"; "Total Price")
                                    {
                                        CaptionML = ENU = 'Amount Sale Performed (JC)';
                                        ReverseSign = true;
                                        //MethodType=Totals;
                                        Method = Sum;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }


    /*begin
    end.
  */
}








