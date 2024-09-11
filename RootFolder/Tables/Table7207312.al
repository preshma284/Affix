table 7207312 "OLD_Charge"
{
  
  
    CaptionML=ENU='Charge',ESP='Cargo';
  
  fields
{
    field(1;"Code";Code[10])
    {
        CaptionML=ENU='Code',ESP='C¢digo';


    }
    field(2;"Description";Text[80])
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
    {
      JAV 25/02/22: - QB 1.10.22 ELIMINADO, se pasa al nuevo sistema de aprobaciones. No se borra porque se usa en el proceso de cambios de versiones
    }
    end.
  */
}







