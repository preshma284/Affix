query 50174 "Top Customer Overview 1"
{
  
  
    CaptionML=ENU='Top Customer Overview',ESP='Informaci¢n general de los principales clientes';
  
  elements
{

DataItem("Customer";"Customer")
{

Column("Name";"Name")
{

}Column("No";"No.")
{

}Column("Sales_LCY";"Sales (LCY)")
{

}Column("Profit_LCY";"Profit (LCY)")
{

}Column("Country_Region_Code";"Country/Region Code")
{

}Column("City";"City")
{

}Column("Global_Dimension_1_Code";"Global Dimension 1 Code")
{

}Column("Global_Dimension_2_Code";"Global Dimension 2 Code")
{

}Column("Salesperson_Code";"Salesperson Code")
{

}DataItem("Salesperson_Purchaser";"Salesperson/Purchaser")
{

DataItemLink="Code"= "Customer"."Salesperson Code";
Column(SalesPersonName;"Name")
{

}DataItem("Country_Region";"Country/Region")
{

DataItemLink="Code"= "Customer"."Country/Region Code";
Column(CountryRegionName;"Name")
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




