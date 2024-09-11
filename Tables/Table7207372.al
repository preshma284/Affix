table 7207372 "QBU Rental Variant"
{
  
  DataCaptionFields="Code","Description";
    CaptionML=ENU='Rental Variant',ESP='Variantes alquiler';
  
  fields
{
    field(1;"Code";Code[10])
    {
        CaptionML=ENU='Code',ESP='C¢digo';
                                                   NotBlank=true;


    }
    field(2;"Description";Text[30])
    {
        CaptionML=ENU='Description',ESP='Descripci¢n';


    }
    field(3;"Rental Variant";Boolean)
    {
        CaptionML=ENU='Rental Variant',ESP='Variante de alquiler'; ;


    }
}
  keys
{
    key(key1;"Code")
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







