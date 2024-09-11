page 7207203 "QB BI Power BI GL Account List"
{
SourceTable=17;
    SourceTableView=SORTING("G/L Account No.","Posting Date");
    PageType=List;
    
  layout
{
area(content)
{
repeater("Group")
{
        
    field("GL_Account_No";rec."G/L Account No.")
    {
        
    }
    field("Name";GLAccount.Name)
    {
        
    }
    field("Account Type";GLAccount."Account Type")
    {
        
    }
    field("Debit_Credit";GLAccount."Debit/Credit")
    {
        
    }
    field("Posting Date";rec."Posting Date")
    {
        
    }
    field("Amount";rec."Amount")
    {
        
    }
    field("Entry No.";rec."Entry No.")
    {
        
    }

}

}
}
  trigger OnAfterGetRecord()    VAR
                       GLAccount : Record 15;
                     BEGIN
                       IF GLAccount."No." <> rec."G/L Account No." THEN BEGIN
                         CLEAR(GLAccount);
                         IF GLAccount.GET(rec."G/L Account No.") THEN;
                       END;
                     END;



    var
      Name : Text[50];
      GLAccount : Record 15;

    /*begin
    end.
  
*/
}







