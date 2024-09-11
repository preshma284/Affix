query 50206 "Acc. Sched. Line Desc. Count 1"
{


    CaptionML = ENU = 'Acc. Sched. Line Desc. Count', ESP = 'Recuento desc. l�neas esquema cuentas';

    elements
    {

        DataItem("Acc_Schedule_Line"; "Acc. Schedule Line")
        {

            Column("Schedule_Name"; "Schedule Name")
            {

            }
            Column("Description"; "Description")
            {
                ColumnFilter = Description = FILTER(<> '');
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




