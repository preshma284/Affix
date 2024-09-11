query 50218 "Workflow Definition 1"
{


    CaptionML = ENU = 'Workflow Definition', ESP = 'Definici�n de flujo de trabajo';
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
            Column("Template"; "Template")
            {

            }
            DataItem("Workflow_Step"; "Workflow Step")
            {

                DataItemLink = "Workflow Code" = Workflow.Code;
                SqlJoinType = InnerJoin;
                //DataItemLinkType=Exclude Row If No Match;
                Column("ID"; "ID")
                {

                }
                Column(Step_Description; "Description")
                {

                }
                Column("Entry_Point"; "Entry Point")
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
                Column("Sequence_No"; "Sequence No.")
                {

                }
                DataItem("Workflow_Event"; "Workflow Event")
                {

                    DataItemLink = "Function Name" = "Workflow_Step"."Function Name";
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




