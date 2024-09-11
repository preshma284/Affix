page 7206976 "QB Confirming Lines Estatistic"
{
Editable=false;
    InsertAllowed=false;
    DeleteAllowed=false;
    SourceTable=7206946;
    PageType=CardPart;
    
  layout
{
area(content)
{
group("group73")
{
        
                CaptionML=ESP='L�nea';
    field("Amount Limit";rec."Amount Limit")
    {
        
    }
    field("Amount Disposed";rec."Amount Disposed")
    {
        
    }
    field("Dis1";rec."Amount Limit" -rec. "Amount Disposed")
    {
        
                CaptionML=ESP='Disponible';
    }
    field("Por1";"PendingL")
    {
        
                ExtendedDatatype=Ratio;
                CaptionML=ESP='% Dsiponible';
    }

}
group("group78")
{
        
                CaptionML=ESP='Totales';
    field("Total Limit";rec."Total Limit")
    {
        
    }
    field("Total Disposed";rec."Total Disposed")
    {
        
    }
    field("Dis2";rec."Total Limit" -rec. "Total Disposed")
    {
        
                CaptionML=ESP='Disponible';
    }
    field("Por2";"PendingT")
    {
        
                ExtendedDatatype=Ratio;
                CaptionML=ESP='% Dsiponible';
    }

}

}
}
  

trigger OnAfterGetCurrRecord()    BEGIN
                           IF (rec."Amount Limit" = 0) THEN
                             PendingL := 0
                           ELSE
                             PendingL := ((rec."Amount Limit" - rec."Amount Disposed") * 100 / rec."Amount Limit") * 100;

                           IF (rec."Amount Limit" = 0) THEN
                             PendingT := 0
                           ELSE
                             PendingT := ((rec."Total Limit" - rec."Total Disposed") * 100 / rec."Total Limit") * 100;
                         END;



    var
      PendingL : Decimal;
      PendingT : Decimal;

    /*begin
    end.
  
*/
}








