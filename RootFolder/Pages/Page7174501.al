page 7174501 "Quofacturae Manual Entry"
{
CaptionML=ENU='Quofacturae endpoints',ESP='Puntos de entrada de Quofacturae';
    PageType=Card;
  layout
{
area(content)
{
group("Group")
{
        
                CaptionML=ESP='N£mero de registro';
    field("Nro";Nro)
    {
        
                CaptionML=ESP='N§';
    }

}

}
}
  
    var
      Nro : Code[20];

    procedure GetNro() : Code[20];
    begin
      exit(Nro);
    end;

    // begin//end
}








