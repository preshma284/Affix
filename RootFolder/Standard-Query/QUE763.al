query 50207 "Colm.Layt.Colm. Header Count 1"
{


    CaptionML = ENU = 'Colm. Layt. Colm. Header Count', ESP = 'Recuento cabecera columna plantilla columna';

    elements
    {

        DataItem("Column_Layout"; "Column Layout")
        {

            Column("Column_Layout_Name"; "Column Layout Name")
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




