table 7207417 "QBU Other Default Vendor Cond."
{
  
  
    CaptionML=ENU='Other Default Vendor Cond.',ESP='Otras condiciones por defecto del proveedor';
    LookupPageID="Other Def. Vendor Cond. List";
    DrillDownPageID="Other Def. Vendor Cond. List";
  
  fields
{
    field(1;"Code";Code[20])
    {
        CaptionML=ENU='Code',ESP='C¢digo';


    }
    field(2;"Description";Text[50])
    {
        CaptionML=ENU='Description',ESP='Descripci¢n';


    }
    field(3;"Default Load";Boolean)
    {
        CaptionML=ENU='Default Load',ESP='Carga por defecto'; ;


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
    {
      JAV 12/11/19: - Se cambia el caption y el name para que sean mas significativos
    }
    end.
  */
}







