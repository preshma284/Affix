query 50217 "Workflow Instance 1"
{


    CaptionML = ENU = 'Workflow Instance', ESP = 'Instancia de flujo de trabajo';
    OrderBy = Ascending(Sequence_No);

    elements
    {

        DataItem("Workflow"; "Workflow")
        {

            Column("Code"; "Code")
            {

            }
            Column(Workflow_Description; "Description")
            {

            }
            Column("Enabled"; "Enabled")
            {

            }
            DataItem("Workflow_Step_Instance"; "Workflow Step Instance")
            {

                DataItemLink = "Workflow Code" = Workflow.Code;
                SqlJoinType = InnerJoin;
                //DataItemLinkType=Exclude Row If No Match;
                Column(Instance_ID; "ID")
                {

                }
                Column("Workflow_Code"; "Workflow Code")
                {

                }
                Column(Step_ID; "Workflow Step ID")
                {

                }
                Column(Step_Description; "Description")
                {

                }
                Column("Entry_Point"; "Entry Point")
                {

                }
                Column("Record_ID"; "Record ID")
                {

                }
                Column("Created_Date_Time"; "Created Date-Time")
                {

                }
                Column("Created_By_User_ID"; "Created By User ID")
                {

                }
                Column("Last_Modified_Date_Time"; "Last Modified Date-Time")
                {

                }
                Column("Last_Modified_By_User_ID"; "Last Modified By User ID")
                {

                }
                Column("Status"; "Status")
                {

                }
                Column("Previous_Workflow_Step_ID"; "Previous Workflow Step ID")
                {

                }
                Column("Next_Workflow_Step_ID"; "Next Workflow Step ID")
                {

                }
                Column("Type"; "Type")
                {

                }
                Column("Function_Name"; "Function Name")
                {

                }
                Column("Argument"; "Argument")
                {

                }
                Column("Original_Workflow_Code"; "Original Workflow Code")
                {

                }
                Column("Original_Workflow_Step_ID"; "Original Workflow Step ID")
                {

                }
                Column("Sequence_No"; "Sequence No.")
                {

                }
                DataItem("Workflow_Event"; "Workflow Event")
                {

                    DataItemLink = "Function Name" = "Workflow_Step_Instance"."Function Name";
                    Column("Table_ID"; "Table ID")
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




