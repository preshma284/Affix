query 50161 "Power BI GL Amount List 1"
{
  
  
    CaptionML=ENU='Power BI GL Amount List',ESP='Lista de importes CG de Power BI';
  
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

}DataItem("G_L_Entry";"G/L Entry")
{

DataItemLink="G/L Account No."= "G_L_Account"."No.";
Column("Posting_Date";"Posting Date")
{

}Column("Amount";"Amount")
{

}Column("Entry_No";"Entry No.")
{

}
}
}
}
  

    /*begin
    end.
  */
}




