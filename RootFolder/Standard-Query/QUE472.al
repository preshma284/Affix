query 50204 "Failed Job Queue Entry 1"
{
  
  
    CaptionML=ENU='Failed Job Queue Entry',ESP='Mov. cola proyecto err¢neo';
  
  elements
{

DataItem("Job_Queue_Entry";"Job Queue Entry")
{

               DataItemTableFilter="Status"=FILTER("Error"),
                                   "Recurring Job"=CONST(false);
Column("ID";"ID")
{

}Column("Status";"Status")
{

}Column("Recurring_Job";"Recurring Job")
{

}Column("Earliest_Start_Date_Time";"Earliest Start Date/Time")
{

}DataItem("Job_Queue_Log_Entry";"Job Queue Log Entry")
{

DataItemLink="ID"= "Job_Queue_Entry".ID;
Column("End_Date_Time";"End Date/Time")
{

}
}
}
}
  

    /*begin
    end.
  */
}




