query 50208 "Analysis Line Desc. Count 1"
{


    CaptionML = ENU = 'Analysis Line Desc. Count', ESP = 'Recuento desc. l�neas an�lisis';

    elements
    {

        DataItem("Analysis_Line"; "Analysis Line")
        {

            Column("Analysis_Area"; "Analysis Area")
            {

            }
            Column("Analysis_Line_Template_Name"; "Analysis Line Template Name")
            {

            }
            Column("Description"; "Description")
            {

            }
            Column(Count_)
            {
                ColumnFilter = Count_ = FILTER(> 1);
                //MethodType=Totals;
                Method = Count;
            }
        }
    }


    /*begin
    end.
  */
}




