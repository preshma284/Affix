page 7206972 "QB Cartera Changes"
{

  layout
{
area(content)
{
group("group37")
{
        
                CaptionML=ESP='Cambio Vto.';
    field("ActDueDate";ActDueDate)
    {
        
                CaptionML=ESP='Fecha Actual';
                Editable=false ;
    }
    field("NewDueDate";NewDueDate)
    {
        
                CaptionML=ESP='Nueva Fecha';
                
                            

  ;trigger OnValidate()    BEGIN
                             IF (NewDueDate <= ActDueDate) THEN
                               ERROR(Txt000);
                           END;


    }

}

}
}
  
    var
      ActDueDate : Date;
      NewDueDate : Date;
      Txt000 : TextConst ESP='La fecha debe ser posterior a la del documento.';

    

procedure SetDueDate(pActual : Date);
    begin
      ActDueDate := pActual;
    end;

    procedure GetDueDate() : Date;
    begin
      exit(NewDueDate);
    end;

    // begin//end
}








