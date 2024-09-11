query 50212 "Data Exch. Field Details 1"
{


    CaptionML = ENU = 'Data Exch. Field Details', ESP = 'Detalles del campo Intercambio datos';

    elements
    {

        DataItem("Data_Exch_Field"; "Data Exch. Field")
        {

            SqlJoinType = InnerJoin;
            //DataItemLinkType=Exclude Row If No Match;
            Column("Line_No"; "Line No.")
            {

            }
            Column("Column_No"; "Column No.")
            {

            }
            Column(FieldValue; "Value")
            {

            }
            Column("Data_Exch_Line_Def_Code"; "Data Exch. Line Def Code")
            {

            }
            Column("Data_Exch_No"; "Data Exch. No.")
            {

            }
            Column("Node_ID"; "Node ID")
            {

            }
            DataItem("Data_Exch"; "Data Exch.")
            {

                DataItemLink = "Entry No." = "Data_Exch_Field"."Data Exch. No.";
                DataItem("Data_Exch_Column_Def"; "Data Exch. Column Def")
                {

                    DataItemLink = "Column No." = "Data_Exch_Field"."Column No.",
                            "Data Exch. Def Code" = "Data_Exch"."Data Exch. Def Code",
                            "Data Exch. Line Def Code" = "Data_Exch_Field"."Data Exch. Line Def Code";
                    Column("Name"; "Name")
                    {

                    }
                    Column("Path"; "Path")
                    {

                    }
                    Column("Negative_Sign_Identifier"; "Negative-Sign Identifier")
                    {

                    }
                }
            }
        }
    }

    /*begin
    end.
  */
}




