table 7207283 "Quote Type"
{
  
  
    CaptionML=ENU='Quote Type',ESP='Tipos de oferta';
    LookupPageID="Quotes Type List";
    DrillDownPageID="Quotes Type List";
  
  fields
{
    field(1;"Code";Code[20])
    {
        CaptionML=ENU='Code',ESP='C¢digo';


    }
    field(2;"Description";Text[50])
    {
        CaptionML=ENU='Description',ESP='Descripci¢n'; ;


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







