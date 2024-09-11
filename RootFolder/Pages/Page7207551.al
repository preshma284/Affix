page 7207551 "Other Vendor Conditions"
{
SourceTable=7207416;
    PageType=List;
    
  layout
{
area(content)
{
group("group69")
{
        
    field("Vendor No.";rec."Vendor No.")
    {
        
    }
    field("Contact No.";rec."Contact No.")
    {
        
    }
    field("Version No.";rec."Version No.")
    {
        
    }

}
repeater("table")
{
        
    field("Code";rec."Code")
    {
        
    }
    field("Description";rec."Description")
    {
        
    }
    field("Amount";rec."Amount")
    {
        
    }

}
group("group77")
{
        
                CaptionML=ESP='Totales';
    field("Total Amount";rec."Total Amount")
    {
        
                CaptionML=ESP='Importe Total Otras Condiciones';
    }

}

}
}
  
trigger OnAfterGetCurrRecord()    BEGIN
                           Rec.CALCFIELDS("Total Amount");
                         END;




    LOCAL procedure CalcSum();
    begin
    end;

    // begin//end
}







