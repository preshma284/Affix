page 7206955 "QB External Worksheet Lin. Fac"
{
CaptionML=ENU='Lines',ESP='Lineas';
    InsertAllowed=false;
    DeleteAllowed=false;
    SourceTable=7206936;
    PageType=List;
  layout
{
area(content)
{
repeater("Group")
{
        
    field("Invoice";rec."Invoice")
    {
        
                
                            ;trigger OnValidate()    BEGIN
                             IF (rec.Invoice) THEN BEGIN
                               rec."Apply to Document Type" := pDocType;
                               rec."Apply to Document No"   := pDocNo;
                             END ELSE BEGIN
                               CLEAR(rec."Apply to Document Type");
                               CLEAR(rec."Apply to Document No");
                             END;
                           END;


    }
    field("Quantity To Invoice";rec."Quantity To Invoice")
    {
        
                
                            ;trigger OnValidate()    BEGIN
                             IF (rec."Quantity To Invoice" <> 0) THEN BEGIN
                               rec."Apply to Document Type" := pDocType;
                               rec."Apply to Document No"   := pDocNo;
                             END ELSE BEGIN
                               CLEAR(rec."Apply to Document Type");
                               CLEAR(rec."Apply to Document No");
                             END;
                           END;


    }
    field("Amount to Invoice";rec."Amount to Invoice")
    {
        
    }
    field("Vendor No.";rec."Vendor No.")
    {
        
    }
    field("Job No.";rec."Job No.")
    {
        
    }
    field("Piecework No.";rec."Piecework No.")
    {
        
    }
    field("Resource No.";rec."Resource No.")
    {
        
    }
    field("Description";rec."Description")
    {
        
    }
    field("Work Type Code";rec."Work Type Code")
    {
        
    }
    field("Work Day Date";rec."Work Day Date")
    {
        
    }
    field("Quantity";rec."Quantity")
    {
        
    }
    field("Quantity Invoiced";rec."Quantity Invoiced")
    {
        
    }
    field("Quantity Pending";rec."Quantity Pending")
    {
        
    }
    field("Cost Price";rec."Cost Price")
    {
        
    }
    field("Total Cost";rec."Total Cost")
    {
        
    }

}

}
}
  
    var
      // pDocType : Option;
      pDocType :Enum "Purchase Document Type";
      pDocNo : Code[20];

    // procedure SetDocument(pType : Option;pNo : Code[20]);
    procedure SetDocument(pType : Enum "Purchase Document Type";pNo : Code[20]);

    begin
      pDocType := pType;
      pDocNo := pNo;
    end;

    // begin//end
}








