page 7207208 "QB BI Top Cust.Overview"
{
SourceTable=21;
    PageType=List;
    
  layout
{
area(content)
{
repeater("Group")
{
        
    field("Entry No.";rec."Entry No.")
    {
        
    }
    field("Customer No.";rec."Customer No.")
    {
        
    }
    field("Posting Date";rec."Posting Date")
    {
        
    }
    field("Sales (LCY)";rec."Sales (LCY)")
    {
        
    }
    field("Customer.Name";Customer.Name)
    {
        
    }

}

}
}
  trigger OnAfterGetRecord()    BEGIN
                       IF (Customer."No." <> rec."Customer No.") THEN BEGIN
                         CLEAR(Customer);
                         IF Customer.GET(rec."Customer No.") THEN;
                       END;
                     END;



    var
      Customer : Record 18;

    /*begin
    end.
  
*/
}







