query 50229 "Tax Groups For Tax Areas 1"
{


    CaptionML = ENU = 'Tax Groups For Tax Areas', ESP = 'Grupos de impuestos para �reas impuesto';

    elements
    {

        DataItem("Tax_Area"; "Tax Area")
        {

            Column(Tax_Area_Code; "Code")
            {

            }
            DataItem("Tax_Area_Line"; "Tax Area Line")
            {

                DataItemLink = "Tax Area" = "Tax_Area".Code;
                SqlJoinType = InnerJoin;
                //DataItemLinkType=Exclude Row If No Match;
                Column("Tax_Jurisdiction_Code"; "Tax Jurisdiction Code")
                {

                }
                DataItem("Tax_Detail"; "Tax Detail")
                {

                    DataItemLink = "Tax Jurisdiction Code" = "Tax_Area_Line"."Tax Jurisdiction Code";
                    SqlJoinType = InnerJoin;
                    //DataItemLinkType=Exclude Row If No Match;
                    Column("Tax_Group_Code"; "Tax Group Code")
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




