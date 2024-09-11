page 7207207 "QB BI Power BI GL Budgeted Amt"
{
SourceTable=96;
    SourceTableView=SORTING("G/L Account No.","Date","Budget Name","Dimension Set ID");
    PageType=List;
    
  layout
{
area(content)
{
repeater("Group")
{
        
    field("GL_Account_No";GLAccount."No.")
    {
        
    }
    field("Name";GLAccount.Name)
    {
        
    }
    field("Account_Type";GLAccount."Account Type")
    {
        
    }
    field("Debit_Credit";GLAccount."Debit/Credit")
    {
        
    }
    field("Date";rec."Date")
    {
        
    }
    field("Amount";rec."Amount")
    {
        
    }

}

}
}
  trigger OnAfterGetRecord()    BEGIN
                       IF (GLAccount."No." <> rec."G/L Account No.") THEN BEGIN
                         CLEAR(GLAccount);
                         IF GLAccount.GET(rec."G/L Account No.") THEN;
                       END;
                     END;



    var
      GLAccount : Record 15;

    /*begin
    end.
  
*/
}







