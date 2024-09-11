page 7207423 "Usage Header Statistic"
{
CaptionML=ENU='Usage Header Statistic',ESP='Estadistica utilizacion cab';
    InsertAllowed=false;
    DeleteAllowed=false;
    SourceTable=7207362;
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
  

    LOCAL procedure UpdateHeaderInfo();
    var
      CurrencyExchangeRate : Record 330;
      UseDate : Date;
    begin

      //Actualiza los campos calculados manualmente y los autom ticos (Navisi¢n)
    end;

    // begin//end
}







