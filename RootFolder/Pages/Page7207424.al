page 7207424 "Usage Header Stat. Hist."
{
CaptionML=ENU='Usage Header Stat. Hist.',ESP='Hist. Cab. Estadisticas Utili.';
    SourceTable=7207365;
    PageType=Card;
    
  layout
{
area(content)
{
group("General")
{
        
    field("Amount";rec."Amount")
    {
        
    }

}

}
}
  



trigger OnAfterGetRecord()    BEGIN
                       CLEARALL;
                     END;



    var
      Text000 : TextConst ENU='VAT Amount',ESP='Importe IVA';
      Text001 : TextConst ENU='%1% VAT',ESP='%1% IVA';

    /*begin
    end.
  
*/
}







