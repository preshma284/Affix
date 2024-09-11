table 7238249 "Siglas"
{
  
  
    DataPerCompany=false;
    CaptionML=ENU='Siglas de la Calle';
    LookupPageID="Siglas";
  
  fields
{
    field(1;"Codigo";Code[3])
    {
        CaptionML=ENU='Code',ESP='C¢digo';


    }
    field(2;"Descripcion";Text[30])
    {
        CaptionML=ENU='Description',ESP='Descripci¢n';


    }
    field(3;"Codigo Oficial";Text[5])
    {
        CaptionML=ESP='C¢digo Oficial';


    }
}
  keys
{
    key(key1;"Codigo")
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







