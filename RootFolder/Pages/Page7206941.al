page 7206941 "QB Anular Pagare"
{
PageType=Worksheet;
    
  layout
{
area(content)
{
group("group29")
{
        
                CaptionML=ESP='General';
group("group30")
{
        
                CaptionML=ESP='Datos Pagar‚';
    field("VendorLedgerEntry.Bill No.";VendorLedgerEntry."Bill No.")
    {
        
                CaptionML=ESP='Pagar‚';
                Editable=false ;
    }
    field("VendorLedgerEntry.Posting Date";VendorLedgerEntry."Posting Date")
    {
        
                CaptionML=ESP='Fecha Registro Original';
                Editable=false ;
    }
    field("VendorLedgerEntry.Due Date";VendorLedgerEntry."Due Date")
    {
        
                CaptionML=ESP='Fecha Vto';
                Editable=false ;
    }
    field("VendorLedgerEntry.Remaining Amount";VendorLedgerEntry."Remaining Amount")
    {
        
                CaptionML=ESP='Importe';
                Editable=false ;
    }

}
group("group35")
{
        
                CaptionML=ESP='" Anuaci¢n"';
    field("FechaRegistro";FechaRegistro)
    {
        
                CaptionML=ESP='Fecha Registro';
    }

}

}

}
}
  trigger OnOpenPage()    BEGIN
                 FunctionQB.OpenPagePaymentRelations;
               END;



    var
      FunctionQB : Codeunit 7207272;
      VendorLedgerEntry : Record 25;
      FechaRegistro : Date;

    procedure SetVLE(pVendorLedgerEntry : Record 25);
    begin
      VendorLedgerEntry := pVendorLedgerEntry;
      FechaRegistro := WORKDATE;
    end;

    procedure GetDate() : Date;
    begin
      exit(FechaRegistro);
    end;

    // begin//end
}








