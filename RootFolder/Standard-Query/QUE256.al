query 50190 "CF Forecast Entry Dimensions 1"
{
  
  
    CaptionML=ENU='CF Forecast Entry Dimensions',ESP='Dimensiones de movimiento de previsi¢n de flujos de efectivo';
  
  elements
{

DataItem("Cash_Flow_Forecast_Entry";"Cash Flow Forecast Entry")
{

Filter("Cash_Flow_Forecast_No";"Cash Flow Forecast No.")
{

}Filter("Cash_Flow_Date";"Cash Flow Date")
{

}Filter("Cash_Flow_Account_No";"Cash Flow Account No.")
{

}Filter("Global_Dimension_1_Code";"Global Dimension 1 Code")
{

}Filter("Global_Dimension_2_Code";"Global Dimension 2 Code")
{

}Column("Dimension_Set_ID";"Dimension Set ID")
{

}Column("Amount_LCY";"Amount (LCY)")
{

               //MethodType=Totals;
               Method=Sum ;
}
}
}
  

    /*begin
    end.
  */
}




