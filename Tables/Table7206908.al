table 7206908 "QBU Job Attr. Value Translation"
{
  
  
    CaptionML=ENU='Job Attr. Value Translation',ESP='Traducci¢n del valor de atributo de proyecto/estudio';
  
  fields
{
    field(1;"Attribute ID";Integer)
    {
        CaptionML=ENU='Attribute ID',ESP='Id. de atributo';
                                                   NotBlank=true;


    }
    field(2;"ID";Integer)
    {
        CaptionML=ENU='ID',ESP='Id.';
                                                   NotBlank=true;


    }
    field(4;"Language Code";Code[10])
    {
        TableRelation="Language";
                                                   CaptionML=ENU='Language Code',ESP='C¢d. idioma';
                                                   NotBlank=true;


    }
    field(5;"Name";Text[250])
    {
        CaptionML=ENU='Name',ESP='Nombre'; ;


    }
}
  keys
{
    key(key1;"Attribute ID","ID","Language Code")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  

    /*begin
    {
      JAV 13/02/20: - Gesti¢n de atributos para proyectos
    }
    end.
  */
}







