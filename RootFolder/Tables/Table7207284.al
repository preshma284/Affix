table 7207284 "Price Cost Database PRESTO"
{
  
  
    CaptionML=ENU='Price cost database PRESTO',ESP='Precio preciario PRESTO';
    LookupPageID="Price Cost Database List";
    DrillDownPageID="Price Cost Database List";
  
  fields
{
    field(1;"Cod. Cost Database";Code[20])
    {
        CaptionML=ENU='Cod. Cost Database',ESP='Cod. preciario';


    }
    field(2;"Piecework";Code[20])
    {
        TableRelation=Piecework."No." WHERE ("Cost Database Default"=FIELD("Cod. Cost Database"));
                                                   CaptionML=ENU='Piecework',ESP='Unidad de obra';


    }
    field(3;"Description";Text[30])
    {
        CaptionML=ENU='Description',ESP='Descripci¢n';


    }
    field(4;"Quantity";Decimal)
    {
        CaptionML=ENU='Quantity',ESP='Cantidad por';


    }
    field(5;"Price Cost";Decimal)
    {
        CaptionML=ENU='Price Cost',ESP='Precio coste';
                                                   AutoFormatType=2;


    }
    field(6;"Price Sale";Decimal)
    {
        CaptionML=ENU='Price Sale',ESP='Precio venta';
                                                   AutoFormatType=2;


    }
    field(7;"Budget Cost Amount";Decimal)
    {
        CaptionML=ENU='Budget Cost Amount',ESP='Importe coste ppto.';
                                                   AutoFormatType=1;


    }
    field(8;"Budget Sale Amount";Decimal)
    {
        CaptionML=ENU='Budget Sale Amount',ESP='Importe venta ppto.';
                                                   AutoFormatType=1 ;


    }
}
  keys
{
    key(key1;"Cod. Cost Database","Piecework")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  

    /*begin
    end.
  */
}







