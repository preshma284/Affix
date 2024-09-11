page 7206980 "QB Factoring Lines Cust. Subf"
{
DeleteAllowed=false;
    SourceTable=7206950;
    PageType=ListPart;
    
  layout
{
area(content)
{
repeater("Group")
{
        
    field("VAT Registration No.";rec."VAT Registration No.")
    {
        
                Editable=false;
                Style=Strong;
                StyleExpr=isHeading ;
    }
    field("Company";rec."Company")
    {
        
                Enabled=NOT isHeading ;
    }
    field("Customer Account";rec."Customer Account")
    {
        
                Enabled=NOT isHeading;
                
                            ;trigger OnValidate()    BEGIN
                             SetEditable;
                           END;


    }
    field("Name";rec."Name")
    {
        
                Editable=false ;
    }
    field("Active";rec."Active")
    {
        
                Enabled=isHeading;
                Style=Strong;
                StyleExpr=isHeading ;
    }
    field("Amount Limit";rec."Amount Limit")
    {
        
                Editable=isHeading;
                Style=Strong;
                StyleExpr=isHeading ;
    }
    field("Amount Disposed";rec."Amount Disposed")
    {
        
                Editable=false;
                Style=Strong;
                StyleExpr=isHeading 

  ;
    }

}

}
}
  

trigger OnAfterGetRecord()    BEGIN
                       SetEditable;
                     END;

trigger OnAfterGetCurrRecord()    BEGIN
                           SetEditable;
                         END;



    var
      isHeading : Boolean;

    LOCAL procedure SetEditable();
    begin
      isHeading := (rec."VAT Registration No." <> '') and (rec."Customer Account" = '');
    end;

    // begin//end
}








