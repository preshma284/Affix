page 7207204 "QB BI Power BI Jobs List"
{
SourceTable=169;
    SourceTableView=SORTING("Job No.","Posting Date");
    PageType=List;
    
  layout
{
area(content)
{
repeater("Group")
{
        
    field("Job_No";rec."Job No.")
    {
        
    }
    field("Search_Description";Job."Search Description")
    {
        
    }
    field("Complete";Job.Complete)
    {
        
    }
    field("Status";Job.Status)
    {
        
    }
    field("Posting Date";rec."Posting Date")
    {
        
    }
    field("Total Cost";rec."Total Cost")
    {
        
    }
    field("Entry No.";rec."Entry No.")
    {
        
    }
    field("Entry Type";rec."Entry Type")
    {
        
    }

}

}
}
  trigger OnAfterGetRecord()    VAR
                       GLAccount : Record 15;
                     BEGIN
                       IF Job."No." <> rec."Job No." THEN BEGIN
                         CLEAR(Job);
                         IF Job.GET(rec."Job No.") THEN;
                       END;
                     END;



    var
      Job : Record 167;

    /*begin
    end.
  
*/
}







