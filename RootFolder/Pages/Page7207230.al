page 7207230 "QB BI Job Ledger Entries"
{
SourceTable=169;
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
    field("Job No.";rec."Job No.")
    {
        
    }
    field("Job Task No.";rec."Job Task No.")
    {
        
    }
    field("Posting Date";rec."Posting Date")
    {
        
    }
    field("Document Date";rec."Document Date")
    {
        
    }
    field("Document No.";rec."Document No.")
    {
        
    }
    field("Job Posting Group";rec."Job Posting Group")
    {
        
    }
    field("Resource Group No.";rec."Resource Group No.")
    {
        
    }
    field("Work Type Code";rec."Work Type Code")
    {
        
    }
    field("Gen. Bus. Posting Group";rec."Gen. Bus. Posting Group")
    {
        
    }
    field("Gen. Prod. Posting Group";rec."Gen. Prod. Posting Group")
    {
        
    }
    field("Location Code";rec."Location Code")
    {
        
    }
    field("Source Code";rec."Source Code")
    {
        
    }
    field("Reason Code";rec."Reason Code")
    {
        
    }
    field("Quantity (Base)";rec."Quantity (Base)")
    {
        
    }
    field("Direct Unit Cost (LCY)";rec."Direct Unit Cost (LCY)")
    {
        
    }
    field("Unit Cost (LCY)";rec."Unit Cost (LCY)")
    {
        
    }
    field("Total Cost (LCY)";rec."Total Cost (LCY)")
    {
        
    }
    field("Unit Price (LCY)";rec."Unit Price (LCY)")
    {
        
    }
    field("Total Price (LCY)";rec."Total Price (LCY)")
    {
        
    }
    field("Line Amount (LCY)";rec."Line Amount (LCY)")
    {
        
    }
    field("Dimension Set ID";rec."Dimension Set ID")
    {
        
    }
    field("Job_Description";Job.Description)
    {
        
    }

}

}
}
  trigger OnAfterGetRecord()    BEGIN
                       IF rec."Job No." <> Job."No." THEN
                         IF NOT Job.GET(rec."Job No.") THEN CLEAR(Job);
                     END;



    var
      Job : Record 167;

    /*begin
    end.
  
*/
}







