query 50166 "Power BI GL Budgeted Amount 1"
{
  
  
    CaptionML=ENU='Power BI GL Budgeted Amount',ESP='Cantidad presupuestada CG de Power BI';
  
  elements
{

DataItem("G_L_Account";"G/L Account")
{

Column(GL_Account_No;"No.")
{

}Column("Name";"Name")
{

}Column("Account_Type";"Account Type")
{
ColumnFilter=Account_Type=CONST(Posting);
}Column("Debit_Credit";"Debit/Credit")
{

}DataItem("G_L_Budget_Entry";"G/L Budget Entry")
{

DataItemLink="G/L Account No."= "G_L_Account"."No.";
Column("Amount";"Amount")
{

}Column("Date";"Date")
{

}
}
}
}
  

    /*begin
    end.
  */
}




