query 50209 "Analysis Column Header Count 1"
{


    CaptionML = ENU = 'Analysis Column Header Count', ESP = 'Recuento cabecera columna an�lisis';

    elements
    {

        DataItem("Analysis_Column"; "Analysis Column")
        {

            Column("Analysis_Area"; "Analysis Area")
            {

            }
            Column("Analysis_Column_Template"; "Analysis Column Template")
            {

            }
            Column("Column_Header"; "Column Header")
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




