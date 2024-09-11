page 7207229 "QB BI FA Ledger Entries"
{
SourceTable=5601;
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
    field("G/L Entry No.";rec."G/L Entry No.")
    {
        
    }
    field("FA No.";rec."FA No.")
    {
        
    }
    field("FA Class Code";rec."FA Class Code")
    {
        
    }
    field("FA Posting Category";rec."FA Posting Category")
    {
        
    }
    field("FA Posting Type";rec."FA Posting Type")
    {
        
    }
    field("FA Subclass Code";rec."FA Subclass Code")
    {
        
    }
    field("FA Posting Date";rec."FA Posting Date")
    {
        
    }
    field("FA Location Code";rec."FA Location Code")
    {
        
    }
    field("Depreciation Book Code";rec."Depreciation Book Code")
    {
        
    }
    field("Posting Date";rec."Posting Date")
    {
        
    }
    field("Document Type";rec."Document Type")
    {
        
    }
    field("Document Date";rec."Document Date")
    {
        
    }
    field("Document No.";rec."Document No.")
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
    field("Amount (LCY)";rec."Amount (LCY)")
    {
        
    }
    field("Dimension Set ID";rec."Dimension Set ID")
    {
        
    }
    field("FA_Description";FA.Description)
    {
        
    }

}

}
}
  trigger OnAfterGetRecord()    BEGIN
                       IF rec."FA No." <> FA."No." THEN
                         IF NOT FA.GET(rec."FA No.") THEN CLEAR(FA);
                     END;



    var
      FA : Record 5600;

    /*begin
    end.
  
*/
}







