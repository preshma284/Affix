query 50191 "Dimension Sets 1"
{


    CaptionML = ENU = 'Dimension Sets', ESP = 'Grupos de dimensiones';

    elements
    {

        DataItem("General_Ledger_Setup"; "General Ledger Setup")
        {

            DataItem("Dimension_Set_Entry"; "Dimension Set Entry")
            {

                //DataItemLinkType=SQL Advanced Options;
                SQLJoinType = CrossJoin;
                Column("Dimension_Set_ID"; "Dimension Set ID")
                {

                }
                Column(Value_Count)
                {
                    //MethodType=Totals;
                    Method = Count;
                }
                DataItem(Dimension_1; "Dimension Set Entry")
                {

                    DataItemLink = "Dimension Set ID" = "Dimension_Set_Entry"."Dimension Set ID",
                            "Dimension Code" = "General_Ledger_Setup"."Shortcut Dimension 1 Code";
                    Column(Dimension_1_Value_Code; "Dimension Value Code")
                    {

                    }
                    Column(Dimension_1_Value_Name; "Dimension Value Name")
                    {

                    }
                    DataItem(Dimension_2; "Dimension Set Entry")
                    {

                        DataItemLink = "Dimension Set ID" = "Dimension_Set_Entry"."Dimension Set ID",
                            "Dimension Code" = "General_Ledger_Setup"."Shortcut Dimension 2 Code";
                        Column(Dimension_2_Value_Code; "Dimension Value Code")
                        {

                        }
                        Column(Dimension_2_Value_Name; "Dimension Value Name")
                        {

                        }
                        DataItem(Dimension_3; "Dimension Set Entry")
                        {

                            DataItemLink = "Dimension Set ID" = "Dimension_Set_Entry"."Dimension Set ID",
                            "Dimension Code" = "General_Ledger_Setup"."Shortcut Dimension 3 Code";
                            Column(Dimension_3_Value_Code; "Dimension Value Code")
                            {

                            }
                            Column(Dimension_3_Value_Name; "Dimension Value Name")
                            {

                            }
                            DataItem(Dimension_4; "Dimension Set Entry")
                            {

                                DataItemLink = "Dimension Set ID" = "Dimension_Set_Entry"."Dimension Set ID",
                            "Dimension Code" = "General_Ledger_Setup"."Shortcut Dimension 4 Code";
                                Column(Dimension_4_Value_Code; "Dimension Value Code")
                                {

                                }
                                Column(Dimension_4_Value_Name; "Dimension Value Name")
                                {

                                }
                                DataItem(Dimension_5; "Dimension Set Entry")
                                {

                                    DataItemLink = "Dimension Set ID" = "Dimension_Set_Entry"."Dimension Set ID",
                            "Dimension Code" = "General_Ledger_Setup"."Shortcut Dimension 5 Code";
                                    Column(Dimension_5_Value_Code; "Dimension Value Code")
                                    {

                                    }
                                    Column(Dimension_5_Value_Name; "Dimension Value Name")
                                    {

                                    }
                                    DataItem(Dimension_6; "Dimension Set Entry")
                                    {

                                        DataItemLink = "Dimension Set ID" = "Dimension_Set_Entry"."Dimension Set ID",
                            "Dimension Code" = "General_Ledger_Setup"."Shortcut Dimension 6 Code";
                                        Column(Dimension_6_Value_Code; "Dimension Value Code")
                                        {

                                        }
                                        Column(Dimension_6_Value_Name; "Dimension Value Name")
                                        {

                                        }
                                        DataItem(Dimension_7; "Dimension Set Entry")
                                        {

                                            DataItemLink = "Dimension Set ID" = "Dimension_Set_Entry"."Dimension Set ID",
                            "Dimension Code" = "General_Ledger_Setup"."Shortcut Dimension 7 Code";
                                            Column(Dimension_7_Value_Code; "Dimension Value Code")
                                            {

                                            }
                                            Column(Dimension_7_Value_Name; "Dimension Value Name")
                                            {

                                            }
                                            DataItem(Dimension_8; "Dimension Set Entry")
                                            {

                                                DataItemLink = "Dimension Set ID" = "Dimension_Set_Entry"."Dimension Set ID",
                            "Dimension Code" = "General_Ledger_Setup"."Shortcut Dimension 8 Code";
                                            }
                                            Column(Dimension_8_Value_Code; "Dimension Value Code")
                                            {

                                            }
                                            Column(Dimension_8_Value_Name; "Dimension Value Name")
                                            {

                                            }
                                        }
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




