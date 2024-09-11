page 7207464 "Usage Stat. Head. Hist. FB"
{
Editable=false;
    CaptionML=ENU='Usage Stat. Head. Hist. FB',ESP='Hist. Cab. Estad. Utili. FB';
    SourceTable=7207365;
    PageType=CardPart;
    
  layout
{
area(content)
{
    field("Amount";rec."Amount")
    {
        
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







