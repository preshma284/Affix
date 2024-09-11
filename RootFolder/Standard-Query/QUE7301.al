query 50232 "Whse. Employees at Locations 1"
{
  
  
    CaptionML=ENU='Whse. Employees at Locations',ESP='Empleados de almac‚n en ubicaciones';
  
  elements
{

DataItem("Location";"Location")
{

Column("Code";"Code")
{

}Column("Bin_Mandatory";"Bin Mandatory")
{

}Column("Directed_Put_away_and_Pick";"Directed Put-away and Pick")
{

}DataItem("Warehouse_Employee";"Warehouse Employee")
{

DataItemLink="Location Code"=Location.Code;
Column("User_ID";"User ID")
{

}Column("Default";"Default")
{

}
}
}
}
  

    /*begin
    end.
  */
}




