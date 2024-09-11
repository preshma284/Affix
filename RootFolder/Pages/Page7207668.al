page 7207668 "QB Debit Relations List"
{
  ApplicationArea=All;

CaptionML=ESP='Relaciones de Cobros';
    SourceTable=7206919;
    SourceTableView=SORTING("Relacion No.")
                    WHERE("Closed"=CONST(false));
    PageType=List;
    CardPageID="QB Debit Relations Header";
    
  layout
{
area(content)
{
repeater("Group")
{
        
    field("Relacion No.";rec."Relacion No.")
    {
        
    }
    field("Job No.";rec."Job No.")
    {
        
    }
    field("Job Desription";rec."Job Desription")
    {
        
    }
    field("Customer No.";rec."Customer No.")
    {
        
    }
    field("Customer Name";rec."Customer Name")
    {
        
    }
    field("Date";rec."Date")
    {
        
    }
    field("Closed";rec."Closed")
    {
        
                Visible=false ;
    }
    field("Type";rec."Type")
    {
        
    }
    field("Amount";rec."Amount")
    {
        
    }
    field("Amount Invoiced";rec."Amount Invoiced")
    {
        
                Visible=false ;
    }
    field("Amount Received";rec."Amount Received")
    {
        
                Visible=false 

  ;
    }

}

}
}
  
trigger OnOpenPage()    BEGIN
                 QBRelationshipSetup.GET();
                 IF NOT QBRelationshipSetup."RC Use Debit Relations" THEN
                   ERROR(Text00);
               END;



    var
      QBRelationshipSetup : Record 7207335;
      Text00 : TextConst ENU='This option is not active',ESP='Esta opci�n no est� activa';

    /*begin
    end.
  
*/
}








