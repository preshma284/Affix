page 7207231 "QB BI Res. Ledger Entries"
{
SourceTable=203;
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
    field("Entry Type";rec."Entry Type")
    {
        
    }
    field("Document No.";rec."Document No.")
    {
        
    }
    field("Posting Date";rec."Posting Date")
    {
        
    }
    field("Resource No.";rec."Resource No.")
    {
        
    }
    field("Resource Group No.";rec."Resource Group No.")
    {
        
    }
    field("Work Type Code";rec."Work Type Code")
    {
        
    }
    field("Job No.";rec."Job No.")
    {
        
    }
    field("Unit of Measure Code";rec."Unit of Measure Code")
    {
        
    }
    field("Quantity";rec."Quantity")
    {
        
    }
    field("Direct Unit Cost";rec."Direct Unit Cost")
    {
        
    }
    field("Unit Cost";rec."Unit Cost")
    {
        
    }
    field("Total Cost";rec."Total Cost")
    {
        
    }
    field("Unit Price";rec."Unit Price")
    {
        
    }
    field("Total Price";rec."Total Price")
    {
        
    }
    field("Source Code";rec."Source Code")
    {
        
    }
    field("Reason Code";rec."Reason Code")
    {
        
    }
    field("Gen. Bus. Posting Group";rec."Gen. Bus. Posting Group")
    {
        
    }
    field("Gen. Prod. Posting Group";rec."Gen. Prod. Posting Group")
    {
        
    }
    field("Document Date";rec."Document Date")
    {
        
    }
    field("Quantity (Base)";rec."Quantity (Base)")
    {
        
    }
    field("Dimension Set ID";rec."Dimension Set ID")
    {
        
    }
    field("Resource_Name";Resource.Name)
    {
        
    }
    field("Resource_Group_Name";ResourceGroup.Name)
    {
        
    }

}

}
}
  trigger OnAfterGetRecord()    BEGIN
                       IF rec."Resource No." <> Resource."No." THEN
                         IF NOT Resource.GET(rec."Resource No.") THEN CLEAR(Resource);

                       IF rec."Resource Group No." <> ResourceGroup."No." THEN
                         IF NOT ResourceGroup.GET(rec."Resource Group No.") THEN CLEAR(ResourceGroup);
                     END;



    var
      Resource : Record 156;
      ResourceGroup : Record 152;

    /*begin
    end.
  
*/
}







