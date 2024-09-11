table 7207385 "QBU Hist. Sale Prices Piecework"
{
  
  
    CaptionML=ENU='Hist. Sale Prices JU',ESP='Hist. Precios Venta UO';
  
  fields
{
    field(1;"Cod. Reestimate";Code[20])
    {
        CaptionML=ENU='Cod. Reestimate',ESP='Cod. Reestimaci¢n';
                                                   Editable=false;


    }
    field(2;"Job No.";Code[20])
    {
        TableRelation="Job";
                                                   CaptionML=ENU='Job No.',ESP='N§ Proyecto';


    }
    field(3;"Piecework Code";Code[20])
    {
        CaptionML=ENU='Piecework Code',ESP='C¢d. unidad de obra';


    }
    field(4;"Sale Price";Decimal)
    {
        CaptionML=ENU='Sale Price',ESP='Precio Venta';
                                                   Editable=false ;


    }
}
  keys
{
    key(key1;"Job No.","Piecework Code","Cod. Reestimate")
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







