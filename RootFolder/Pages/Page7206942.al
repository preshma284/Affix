page 7206942 "QB Liquidar Anticipo"
{
PageType=Worksheet;
    
  layout
{
area(content)
{
group("group38")
{
        
                CaptionML=ESP='Datos Anticipo';
    field("Anticipo.Document No.";Anticipo."Document No.")
    {
        
                CaptionML=ESP='Pagar‚';
                Editable=false ;
    }
    field("Anticipo.Posting Date";Anticipo."Posting Date")
    {
        
                CaptionML=ESP='Fecha Registro';
                Enabled=false ;
    }
    field("Anticipo.Due Date";Anticipo."Due Date")
    {
        
                CaptionML=ESP='Fecha Vto';
                Editable=false ;
    }
    field("Anticipo.Importe Pendiente";Anticipo."Importe Pendiente")
    {
        
                CaptionML=ESP='Importe Pendiente';
                Editable=false ;
    }

}
group("group43")
{
        
                CaptionML=ESP='Datos Fatura';
    field("Factura.Document No.";Factura."Document No.")
    {
        
                CaptionML=ESP='Pagar‚';
                Editable=false ;
    }
    field("Factura.Posting Date";Factura."Posting Date")
    {
        
                CaptionML=ESP='Fecha Registro';
                Editable=false ;
    }
    field("Factura.Due Date";Factura."Due Date")
    {
        
                CaptionML=ESP='Fecha Vto';
                Editable=false ;
    }
    field("-Factura.Remaining Amount";-Factura."Remaining Amount")
    {
        
                CaptionML=ESP='Importe Factura';
                Editable=false ;
    }

}
group("group48")
{
        
                CaptionML=ESP='Liquidaci¢n';
    field("FechaRegistro";FechaRegistro)
    {
        
                CaptionML=ESP='Fecha Registro';
    }
    field("ImporteFinal";ImporteFinal)
    {
        
                CaptionML=ESP='Importe Final';
                Editable=False 

  ;
    }

}

}
}
  trigger OnOpenPage()    BEGIN
                 FunctionQB.OpenPagePaymentRelations;
               END;



    var
      FunctionQB : Codeunit 7207272;
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








