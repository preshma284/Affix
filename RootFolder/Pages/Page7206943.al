page 7206943 "QB SII Operations Description"
{
  ApplicationArea=All;

CaptionML=ENU='SII Operations Description',ESP='Descripci¢n de Operaciones para el SII';
    SourceTable=7206931;
    PageType=Worksheet;
  layout
{
area(content)
{
repeater("table")
{
        
    field("Code";rec."Code")
    {
        
    }
    field("Description";rec."Description")
    {
        
    }
    field("Default";rec."Default")
    {
        
    }

}

}
}
  
    var
      Anticipo : Record 7206923;
      Factura : Record 25;
      FechaRegistro : Date;
      ImporteFinal : Decimal;

    procedure SetVLE(pAnticipo : Record 7206923;pFactura : Record 25);
    begin
      Anticipo := pAnticipo;
      Factura := pFactura;
      FechaRegistro := WORKDATE;

      Factura.CALCFIELDS("Remaining Amount");
      ImporteFinal := Anticipo."Importe Pendiente" + Factura."Remaining Amount";
      if (ImporteFinal < 0) then
        ImporteFinal := 0;
    end;

    procedure GetDate() : Date;
    begin
      exit(FechaRegistro);
    end;

    // begin//end
}









