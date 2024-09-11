page 7207427 "Hist. Head. Statistics Del/Ret"
{
Editable=false;
    CaptionML=ENU='Hist. Head. Statistics Del/Ret. Ele',ESP='Hist. cab. estadist ent/dev el';
    SourceTable=7207359;
    PageType=Card;
    
  layout
{
area(content)
{
group("General")
{
        
                CaptionML=ENU='General',ESP='General';
    field("Amount";rec."Amount")
    {
        
                CaptionML=ENU='AMount',ESP='Importe';
    }

}

}
}
  trigger OnAfterGetRecord()    BEGIN
                       CLEARALL;
                     END;




    /*begin
    end.
  
*/
}







